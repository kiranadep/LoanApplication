using System;
using MySql.Data.MySqlClient;

namespace LoanApplication.Admin
{
    public partial class Restore : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string appId = Request.Form["id"];
            if (!string.IsNullOrEmpty(appId))
            {
                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;

                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();

                    // Insert back into LoanApplications from DeletedApplications
                    string insertQuery = @"
                        INSERT INTO LoanApplications 
                        (ApplicationID, FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, Status, AppliedAt)
                        SELECT ApplicationID, FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, Status, AppliedAt
                        FROM DeletedApplications
                        WHERE ApplicationID=@ID";

                    MySqlCommand insertCmd = new MySqlCommand(insertQuery, conn);
                    insertCmd.Parameters.AddWithValue("@ID", appId);
                    insertCmd.ExecuteNonQuery();

                    // Delete from DeletedApplications
                    string deleteQuery = "DELETE FROM DeletedApplications WHERE ApplicationID=@ID";
                    MySqlCommand deleteCmd = new MySqlCommand(deleteQuery, conn);
                    deleteCmd.Parameters.AddWithValue("@ID", appId);
                    deleteCmd.ExecuteNonQuery();
                }

                // Redirect back to Trash page or Dashboard
                Response.Redirect("Trash.aspx");
            }
        }
    }
}
