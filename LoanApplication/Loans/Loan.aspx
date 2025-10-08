<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loan.aspx.cs" Inherits="LoanApplication.Loans.Loan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Loan</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg,#1e3c72 0%,#2a5298 50%,#7e22ce 100%);
            min-height: 100vh; 
            padding: 40px 20px; 
        }
        .container { 
            max-width: 700px; 
            margin:0 auto; 
            background:white; 
            padding:40px; 
            border-radius:15px; 
            box-shadow:0 20px 60px rgba(0,0,0,0.3); 
        }
        h1 { color:#1e3c72; margin-bottom:10px; font-size:32px; text-align:center; }
        .form-row { display:flex; gap:20px; margin-bottom:20px; }
        .form-group { flex:1; margin-bottom:20px; }
        label { display:block; margin-bottom:8px; color:#333; font-weight:600; font-size:14px; }
        input,select,textarea { 
            width:100%; padding:12px 15px; border:2px solid #e0e0e0;
            border-radius:8px; font-size:15px; transition: all 0.3s; font-family:inherit; 
        }
        input:focus, select:focus, textarea:focus { 
            outline:none; border-color:#2a5298; box-shadow:0 0 0 3px rgba(42,82,152,0.1); 
        }
        textarea { resize:vertical; min-height:100px; }
        .required { color:#e74c3c; }
        .btn-submit { 
            background:linear-gradient(135deg,#1e3c72 0%,#2a5298 100%); 
            color:white; padding:15px 40px; border:none; border-radius:8px; 
            cursor:pointer; font-size:16px; font-weight:bold; width:100%; 
            transition:all 0.3s; margin-top:10px; 
        }
            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px rgba(30,60,114,0.3);
            }
        .btn-green{ 
            background:#256029; 
            color:white; padding:15px 40px; border:none; border-radius:8px; 
            cursor:pointer; font-size:16px; font-weight:bold; width:100%; 
            transition:all 0.3s; margin-top:10px; 
        }
        .btn-green:hover { 
            transform:translateY(-2px); 
            box-shadow:0 10px 25px rgba(30,60,114,0.3); 
        }
        .alert { 
            padding:15px 20px; margin-bottom:25px; border-radius:8px; 
            text-align:center; font-weight:500; animation: slideDown 0.3s ease; 
        }
        .alert.success { background:#e6ffed; color:#256029; border:1px solid #b7e4c7; }
        .alert.error { background:#fdecea; color:#a71d2a; border:1px solid #f5c6cb; }
        .buttons { display:flex; gap:15px; justify-content:center; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Loan Application</h1>

        <%
            string alert = "";
            string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;
            string payableMessage = "";
            decimal TotalAmount = 0;
            decimal interestRate = 0;
            int months = 12; // Default 12 months

            if (Request.HttpMethod == "POST")
            {
<<<<<<< HEAD
                string action = Request.Form["action"];
=======
                string fullName = Request.Form["fullName"];
                string email = Request.Form["email"];
                string phone = Request.Form["phone"];
                string address = Request.Form["address"];
                string loanType = Request.Form["loanType"];
                decimal loanAmount = Convert.ToDecimal(Request.Form["loanAmount"]);
                string employmentType = Request.Form["employmentType"];
                decimal monthlyIncome = Convert.ToDecimal(Request.Form["monthlyIncome"]);
                HttpPostedFile documentFile = Request.Files["document"];

>>>>>>> 4aad3f1f8e611cc13e34872704cb8c8df6fa8440

                if (action == "calculate")
                {
                    string loanType = Request.Form["loanType"];
                    decimal amount = 0;

                    if (!string.IsNullOrEmpty(Request.Form["loanAmount"]))
                        amount = Convert.ToDecimal(Request.Form["loanAmount"]);

                    if (!string.IsNullOrEmpty(Request.Form["months"]))
                        months = Convert.ToInt32(Request.Form["months"]);

                    using (MySqlConnection con = new MySqlConnection(connStr))
                    {
                        con.Open();
                        string q = "SELECT InterestRate FROM LoanTypes WHERE LoanName=@LoanType";
                        MySqlCommand cmd = new MySqlCommand(q, con);
                        cmd.Parameters.AddWithValue("@LoanType", loanType);
                        object result = cmd.ExecuteScalar();

                        if (result != null)
                        {
                            interestRate = Convert.ToDecimal(result);
                            decimal interest = amount * interestRate / 100 * months / 12m;
                            TotalAmount = amount + interest;
                            payableMessage = $"₹{Math.Round(TotalAmount)} (Interest: ₹{Math.Round(interest)} at {interestRate}% p.a.)";
                        }
                        else
                        {
                            payableMessage = "❌ No matching loan type found.";
                        }
                    }

                    ViewState["TotalAmount"] = TotalAmount;
                    ViewState["InterestRate"] = interestRate;
                    ViewState["Months"] = months;
                }

                else if (action == "submit")
                {
                    try
                    {
<<<<<<< HEAD
                        string fullName = Request.Form["fullName"];
                        string email = Request.Form["email"];
                        string phone = Request.Form["phone"];
                        string address = Request.Form["address"];
                        string loanType = Request.Form["loanType"];
                        decimal loanAmount = Convert.ToDecimal(Request.Form["loanAmount"]);
                        string employmentType = Request.Form["employmentType"];
                        decimal monthlyIncome = Convert.ToDecimal(Request.Form["monthlyIncome"]);
=======
                        conn.Open();
                        string query = @"INSERT INTO LoanApplications 
                                    (FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, Status,documentFile,TotalAmount)
                                    VALUES
                                    (@FullName,@Email,@Phone,@Address,@LoanType,@LoanAmount,@EmploymentType,@MonthlyIncome,'Pending',@documentFile,@TotalAmount)";
>>>>>>> 4aad3f1f8e611cc13e34872704cb8c8df6fa8440

                        if (ViewState["TotalAmount"] != null)
                            TotalAmount = Convert.ToDecimal(ViewState["TotalAmount"]);
                        if (ViewState["InterestRate"] != null)
                            interestRate = Convert.ToDecimal(ViewState["InterestRate"]);
                        if (ViewState["Months"] != null)
                            months = Convert.ToInt32(ViewState["Months"]);

                        using (MySqlConnection conn = new MySqlConnection(connStr))
                        {
                            conn.Open();
                            string query = @"INSERT INTO LoanApplications 
                            (FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, TotalAmount, Status, AppliedAt, Document)
                            VALUES
                            (@FullName, @Email, @Phone, @Address, @LoanType, @LoanAmount, @EmploymentType, @MonthlyIncome, @TotalAmount, 'Pending', NOW(), @Document)";

                            MySqlCommand cmd = new MySqlCommand(query, conn);
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@Phone", phone);
                            cmd.Parameters.AddWithValue("@Address", address);
                            cmd.Parameters.AddWithValue("@LoanType", loanType);
                            cmd.Parameters.AddWithValue("@LoanAmount", loanAmount);
                            cmd.Parameters.AddWithValue("@EmploymentType", employmentType);
                            cmd.Parameters.AddWithValue("@MonthlyIncome", monthlyIncome);
<<<<<<< HEAD
                            cmd.Parameters.AddWithValue("@TotalAmount", TotalAmount);
                            //cmd.Parameters.AddWithValue("@Document", documentBytes); // if you are uploading a file
=======
                            cmd.Parameters.AddWithValue("@documentFile", documentFile);
>>>>>>> 4aad3f1f8e611cc13e34872704cb8c8df6fa8440

                            cmd.ExecuteNonQuery();
                        }

                        alert = "<div class='alert success'>✓ Application submitted successfully!</div>";
                    }
                    catch (Exception ex)
                    {
                        alert = "<div class='alert error'>✗ Error: " + ex.Message + "</div>";
                    }
                }
            }

            Response.Write(alert);
            if (!string.IsNullOrEmpty(payableMessage))
                Response.Write("<div class='alert success'>" + payableMessage + "</div>");
        %>

        <form method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name <span class="required">*</span></label>
                    <input type="text" name="fullName" value="<%= Request.Form["fullName"] %>" required /> 
                    <!--Request.Form["fullName"] means:
                “get the value that the user typed in this box before refresh.”-->
                </div>
                <div class="form-group">
                    <label>Email <span class="required">*</span></label>
                    <input type="email" name="email" value="<%= Request.Form["email"] %>" required />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Phone <span class="required">*</span></label>
                    <input type="tel" name="phone" pattern="[0-9]{10}" value="<%= Request.Form["phone"] %>" required />
                </div>
                <div class="form-group">
                    <label>Loan Type <span class="required">*</span></label>
                    <select name="loanType" required>
                        <option value="">--Select--</option>
                        <option value="Personal Loan" <%= Request.Form["loanType"] == "Personal Loan" ? "selected" : "" %>>Personal Loan</option>
                        <option value="Home Loan" <%= Request.Form["loanType"] == "Home Loan" ? "selected" : "" %>>Home Loan</option>
                        <option value="Car Loan" <%= Request.Form["loanType"] == "Car Loan" ? "selected" : "" %>>Car Loan</option>
                        <option value="Education Loan" <%= Request.Form["loanType"] == "Education Loan" ? "selected" : "" %>>Education Loan</option>
                        <option value="Business Loan" <%= Request.Form["loanType"] == "Business Loan" ? "selected" : "" %>>Business Loan</option>
                        <option value="Gold Loan" <%= Request.Form["loanType"] == "Gold Loan" ? "selected" : "" %>>Gold Loan</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Address <span class="required">*</span></label>
                <input type="text" name="address" value="<%= Request.Form["address"] %>" required />
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Loan Amount (₹) <span class="required">*</span></label>
                    <input type="number" name="loanAmount" min="10000" step="1000" value="<%= Request.Form["loanAmount"] %>" required />
                </div>
                <div class="form-group">
                    <label>Employment Type <span class="required">*</span></label>
                    <select name="employmentType" required>
                        <option value="">-- Select Occupation --</option>
                        <option value="Student" <%= Request.Form["employmentType"] == "Student" ? "selected" : "" %>>Student</option>
                        <option value="Software Developer" <%= Request.Form["employmentType"] == "Software Developer" ? "selected" : "" %>>Software Developer</option>
                        <option value="Teacher" <%= Request.Form["employmentType"] == "Teacher" ? "selected" : "" %>>Teacher</option>
                        <option value="Doctor" <%= Request.Form["employmentType"] == "Doctor" ? "selected" : "" %>>Doctor</option>
                        <option value="Business Owner" <%= Request.Form["employmentType"] == "Business Owner" ? "selected" : "" %>>Business Owner</option>
                        <option value="Housewife" <%= Request.Form["employmentType"] == "Housewife" ? "selected" : "" %>>Housewife</option>
                        <option value="Freelancer" <%= Request.Form["employmentType"] == "Freelancer" ? "selected" : "" %>>Freelancer</option>
                        <option value="Other" <%= Request.Form["employmentType"] == "Other" ? "selected" : "" %>>Other</option>
                    </select>
                </div>
            </div>
<<<<<<< HEAD

            <div class="form-group">
                <label>Monthly Income (₹) <span class="required">*</span></label>
                <input type="number" name="monthlyIncome" min="10000" step="1000" value="<%= Request.Form["monthlyIncome"] %>" required />
            </div>

            <input type="hidden" name="months" value="12" />


            <div class="form-row">
                <div class="form-group" style="flex:2;">
                    <label>Total Payable Amount</label>
                    <input type="text" name="totalAmount" value="<%= payableMessage %>" readonly />
                </div>
                <div class="form-group" style="flex:1; display:flex; align-items:flex-end;">
                    <button type="submit" name="action" value="calculate" class="btn-green">Calculate</button>

                </div>
            </div>

            <div class="buttons">
               
                <button type="submit" name="action" value="submit" class="btn-submit">Submit Application</button>
            </div>
=======
            <div class="form-group"><label>Monthly Income (₹) <span class="required">*</span></label><input type="number" name="monthlyIncome" min="10000" step="1000" required /></div>
            <form method="post" enctype="multipart/form-data">
    
    <div class="form-group">
        <label>Upload Document (PDF/Image) <span class="required">*</span></label>
        <input type="file" name="document" accept=".pdf,.jpg,.jpeg,.png" required />
    </div>
    
</form>

            <button type="submit" class="btn-submit">Submit Application</button>

>>>>>>> 4aad3f1f8e611cc13e34872704cb8c8df6fa8440
        </form>
    </div>
</body>
</html>
