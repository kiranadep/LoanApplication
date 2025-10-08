<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loan.aspx.cs" Inherits="LoanApplication.Loans.Loan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %> <!-- ✅ Use MySQL namespace -->

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Loan</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg,#1e3c72 0%,#2a5298 50%,#7e22ce 100%); min-height: 100vh; padding: 40px 20px; }
        .container { max-width: 700px; margin:0 auto; background:white; padding:40px; border-radius:15px; box-shadow:0 20px 60px rgba(0,0,0,0.3);}
        h1 { color:#1e3c72; margin-bottom:10px; font-size:32px; text-align:center;}
        .form-row{display:flex; gap:20px; margin-bottom:20px;}
        .form-group{flex:1; margin-bottom:20px;}
        label{display:block;margin-bottom:8px;color:#333;font-weight:600;font-size:14px;}
        input,select,textarea{width:100%;padding:12px 15px;border:2px solid #e0e0e0;border-radius:8px;font-size:15px; transition: all 0.3s; font-family:inherit;}
        input:focus, select:focus, textarea:focus{outline:none;border-color:#2a5298; box-shadow:0 0 0 3px rgba(42,82,152,0.1);}
        textarea{resize:vertical;min-height:100px;}
        .required{color:#e74c3c;}
        .btn-submit{background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); color:white;padding:15px 40px;border:none;border-radius:8px; cursor:pointer;font-size:16px;font-weight:bold;width:100%;transition:all 0.3s; margin-top:10px;}
        .btn-submit:hover{transform:translateY(-2px); box-shadow:0 10px 25px rgba(30,60,114,0.3);}
        .alert{padding:15px 20px;margin-bottom:25px;border-radius:8px;text-align:center;font-weight:500; animation: slideDown 0.3s ease;}
        @keyframes slideDown{from {opacity:0; transform:translateY(-10px);} to {opacity:1; transform:translateY(0);}}
        .alert-success{background:#d4edda; color:#155724; border:1px solid #c3e6cb;}
        .alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;}
    </style>
</head>
<body>
    <div class="container">
        <h1>Loan Application</h1>

        <%
            string alertMessage = "";
            string alertType = "";

            if (Request.HttpMethod == "POST")
            {
                string fullName = Request.Form["fullName"];
                string email = Request.Form["email"];
                string phone = Request.Form["phone"];
                string address = Request.Form["address"];
                string loanType = Request.Form["loanType"];
                decimal loanAmount = Convert.ToDecimal(Request.Form["loanAmount"]);
                string employmentType = Request.Form["employmentType"];
                decimal monthlyIncome = Convert.ToDecimal(Request.Form["monthlyIncome"]);

                // ✅ Use your MySQL connection string from Railway
                string connString = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;

                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    try
                    {
                        conn.Open();
                        string query = @"INSERT INTO LoanApplications 
                                    (FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, Status)
                                    VALUES
                                    (@FullName,@Email,@Phone,@Address,@LoanType,@LoanAmount,@EmploymentType,@MonthlyIncome,'Pending')";

                        using (MySqlCommand cmd = new MySqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Phone", phone);
                            cmd.Parameters.AddWithValue("@Address", address);
                            cmd.Parameters.AddWithValue("@LoanType", loanType);
                            cmd.Parameters.AddWithValue("@LoanAmount", loanAmount);
                            cmd.Parameters.AddWithValue("@EmploymentType", employmentType);
                            cmd.Parameters.AddWithValue("@MonthlyIncome", monthlyIncome);

                            int rows = cmd.ExecuteNonQuery();
                            if (rows > 0)
                            {
                                alertMessage = "✓ Application submitted successfully!";
                                alertType = "success";
                            }
                            else
                            {
                                alertMessage = "✗ Failed to submit application.";
                                alertType = "error";
                            }
                            Response.Redirect("userview.aspx");
                        }
                    }
                    catch (Exception ex)
                    {
                        alertMessage = "✗ Error: " + ex.Message;
                        alertType = "error";
                    }
                }
            }

            if (!string.IsNullOrEmpty(alertMessage))
            {
                Response.Write("<div class='alert alert-" + alertType + "'>" + alertMessage + "</div>");
            }
        %>

        <form method="post">
            <div class="form-row">
                <div class="form-group"><label>Full Name <span class="required">*</span></label><input type="text" name="fullName" required /></div>
                <div class="form-group"><label>Email <span class="required">*</span></label><input type="email" name="email" required /></div>
            </div>
            <div class="form-row">
                <div class="form-group"><label>Phone <span class="required">*</span></label><input type="tel" name="phone" pattern="[0-9]{10}" required /></div>
                <div class="form-group"><label>Loan Type <span class="required">*</span></label>
                    <select name="loanType" required>
                        <option value="">--Select--</option>
                        <option value="Personal Loan">Personal Loan</option>
                        <option value="Home Loan">Home Loan</option>
                        <option value="Car Loan">Car Loan</option>
                        <option value="Education Loan">Education Loan</option>
                        <option value="Business Loan">Business Loan</option>
                        <option value="Gold Loan">Gold Loan</option>
                    </select>
                </div>
            </div>
            <div class="form-group"><label>Address <span class="required">*</span></label><input type="text" name="address" required /></div>
            <div class="form-row">
                <div class="form-group"><label>Loan Amount (₹) <span class="required">*</span></label><input type="number" name="loanAmount" min="10000" step="1000" required /></div>
                <div class="form-group"><label>Employment Type <span class="required">*</span></label>
                    <select name="employmentType" required>
                        <option value="">-- Select Occupation --</option>
                        <option value="Student">Student</option>
                        <option value="Software Developer">Software Developer</option>
                        <option value="Teacher">Teacher</option>
                        <option value="Doctor">Doctor</option>
                        <option value="Business Owner">Business Owner</option>
                        <option value="Housewife">Housewife</option>
                        <option value="Freelancer">Freelancer</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            <div class="form-group"><label>Monthly Income (₹) <span class="required">*</span></label><input type="number" name="monthlyIncome" min="10000" step="1000" required /></div>
            <button type="submit" class="btn-submit">Submit Application</button>
        </form>
    </div>
</body>
</html>
