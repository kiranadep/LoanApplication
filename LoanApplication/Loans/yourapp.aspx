<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="yourapp.aspx.cs" Inherits="LoanApplication.Loans.yourapp" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Application</title>
</head>
<body style="font-family:'Segoe UI';padding:30px;background:#f4f7fa;">
<h1>👤 Your Application</h1>

<table border="1" cellpadding="8" cellspacing="0" style="background:#fff;border-collapse:collapse;width:100%;">
<tr>
    <th>Loan Type</th>
    <th>Loan Amount</th>
    <th>Status</th>
    <th>Action</th>
</tr>
<%
string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
string userEmail = Session["UserEmail"] as string;

// ✅ Handle deletion if deleteId is present
string deleteId = Request.QueryString["deleteId"];
if (!string.IsNullOrEmpty(deleteId) && !string.IsNullOrEmpty(userEmail))
{
    using (MySqlConnection conn = new MySqlConnection(connString))
    {
        conn.Open();
        MySqlCommand deleteCmd = new MySqlCommand("DELETE FROM LoanApplications WHERE ApplicationId = @ApplicationId AND Email = @Email", conn);
        deleteCmd.Parameters.AddWithValue("@ApplicationId", deleteId);
        deleteCmd.Parameters.AddWithValue("@Email", userEmail);
        deleteCmd.ExecuteNonQuery();
    }

    // ✅ Redirect to refresh the page without query string
    Response.Redirect("yourapp.aspx");
}

// ✅ Display applications
if (!string.IsNullOrEmpty(userEmail))
{
    using (MySqlConnection conn = new MySqlConnection(connString))
    {
        conn.Open();
        MySqlCommand cmd = new MySqlCommand("SELECT ApplicationId, LoanType, LoanAmount, Status FROM LoanApplications WHERE Email = @Email", conn);
        cmd.Parameters.AddWithValue("@Email", userEmail);

        MySqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            string appId = reader["ApplicationId"].ToString();
            string loanType = reader["LoanType"].ToString();
            string loanAmount = reader["LoanAmount"].ToString();
            string status = reader["Status"].ToString();

            Response.Write("<tr>");
            Response.Write("<td>" + loanType + "</td>");
            Response.Write("<td>" + loanAmount + "</td>");
            Response.Write("<td>" + status + "</td>");
            Response.Write("<td><a href='yourapp.aspx?deleteId=" + appId + "' class='btn btn-outline-danger'>Delete</a></td>");
            Response.Write("</tr>");
        }
    }
}
else
{
    Response.Write("<tr><td colspan='4' style='text-align:center;color:red;'>Please log in to view your application details.</td></tr>");
}
%>
</table>
</body>
</html>
