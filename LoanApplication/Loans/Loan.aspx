<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loan.aspx.cs" Inherits="LoanApplication.Loans.Loan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Loan</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg,#1e3c72 0%,#2a5298 50%,#7e22ce 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container-custom {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .alert-custom {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container container-custom">
        <h1 class="text-center text-primary mb-4">Loan Application</h1>

        <%
            string alert = "";
            string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;
            string payableMessage = "";
            decimal TotalAmount = 0;
            decimal interestRate = 0;
            int months = 12; // Default 12 months

            if (Request.HttpMethod == "POST")
            {
                string action = Request.Form["action"];

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
                        string fullName = Request.Form["fullName"];
                        string email = Request.Form["email"];
                        string phone = Request.Form["phone"];
                        string address = Request.Form["address"];
                        string loanType = Request.Form["loanType"];
                        decimal loanAmount = Convert.ToDecimal(Request.Form["loanAmount"]);
                        string employmentType = Request.Form["employmentType"];
                        decimal monthlyIncome = Convert.ToDecimal(Request.Form["monthlyIncome"]);
                        HttpPostedFile documentFile = Request.Files["document"];

                        if (ViewState["TotalAmount"] != null)
                            TotalAmount = Convert.ToDecimal(ViewState["TotalAmount"]);

                        byte[] documentBytes = null;
                        if (documentFile != null && documentFile.ContentLength > 0)
                        {
                            documentBytes = new byte[documentFile.ContentLength];
                            documentFile.InputStream.Read(documentBytes, 0, documentFile.ContentLength);
                        }

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
                            cmd.Parameters.AddWithValue("@TotalAmount", TotalAmount);
                            cmd.Parameters.AddWithValue("@Document", documentBytes);

                            cmd.ExecuteNonQuery();
                        }

                        alert = "<div class='alert alert-success alert-custom'>✓ Application submitted successfully!</div>";
                    }
                    catch (Exception ex)
                    {
                        alert = "<div class='alert alert-danger alert-custom'>✗ Error: " + ex.Message + "</div>";
                    }
                }
            }

            Response.Write(alert);
            if (!string.IsNullOrEmpty(payableMessage))
                Response.Write("<div class='alert alert-success alert-custom'>" + payableMessage + "</div>");
        %>

        <!-- Main Form -->
        <form method="post" enctype="multipart/form-data">
            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">Full Name <span class="text-danger">*</span></label>
                    <input type="text" class="form-control" name="fullName" value="<%= Request.Form["fullName"] %>" required />
                </div>
                <div class="col">
                    <label class="form-label">Email <span class="text-danger">*</span></label>
                    <input type="email" class="form-control" name="email" value="<%= Request.Form["email"] %>" required />
                </div>
            </div>

            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">Phone <span class="text-danger">*</span></label>
                    <input type="tel" class="form-control" name="phone" pattern="[0-9]{10}" value="<%= Request.Form["phone"] %>" required />
                </div>
                <div class="col">
                    <label class="form-label">Loan Type <span class="text-danger">*</span></label>
                    <select class="form-select" name="loanType" required>
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

            <div class="mb-3">
                <label class="form-label">Address <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="address" value="<%= Request.Form["address"] %>" required />
            </div>

            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">Loan Amount (₹) <span class="text-danger">*</span></label>
                    <input type="number" class="form-control" name="loanAmount" min="10000" step="1000" value="<%= Request.Form["loanAmount"] %>" required />
                </div>
                <div class="col">
                    <label class="form-label">Employment Type <span class="text-danger">*</span></label>
                    <select class="form-select" name="employmentType" required>
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

            <div class="mb-3">
                <label class="form-label">Monthly Income (₹) <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="monthlyIncome" min="10000" step="1000" value="<%= Request.Form["monthlyIncome"] %>" required />
            </div>

            <div class="mb-3">
                <label class="form-label">Upload Document (PDF/Image) <span class="text-danger">*</span></label>
                <input type="file" class="form-control" name="document" accept=".pdf,.jpg,.jpeg,.png" required />
            </div>

            <input type="hidden" name="months" value="12" />

            <div class="row mb-3">
                <div class="col">
                    <label class="form-label">Total Payable Amount</label>
                    <input type="text" class="form-control" name="totalAmount" value="<%= payableMessage %>" readonly />
                </div>
                <div class="col d-flex align-items-end">
                    <button type="submit" name="action" value="calculate" class="btn btn-success flex-fill">Calculate</button>
                </div>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" name="action" value="submit" class="btn btn-primary flex-fill">Submit Application</button>
            </div>
        </form>
    </div>
</body>
</html>
