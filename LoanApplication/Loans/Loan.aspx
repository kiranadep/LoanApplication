<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loan.aspx.cs" Inherits="LoanApplication.Loans.Loan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<%@ Import Namespace="System.Configuration" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Loan</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: linear-gradient(135deg,#1e3c72 0%,#2a5298 50%,#7e22ce 100%); min-height:100vh; padding:40px 20px; }
        .container-custom { max-width:700px; margin:0 auto; background:white; padding:40px; border-radius:15px; box-shadow:0 20px 60px rgba(0,0,0,0.3);}
        .alert-custom { margin-bottom:20px; }
    </style>
</head>
<body>
<div class="container container-custom">
    <h1 class="text-center text-primary mb-4">Loan Application</h1>

<%
    // =========================
    //  Autofill user info
    // =========================
    string fullName = "";
    string email = "";
    string phone = "";
    string address = "";
    string employmentType = "";
    string monthlyIncome = "";

    string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;

    if (Session["UserEmail"] != null)
    {
        using (MySqlConnection con = new MySqlConnection(connStr))
        {
            con.Open();
            string query = "SELECT FullName, Email, Phone, Address, Occupation, MonthlyIncome FROM Users WHERE Email=@Email";
            MySqlCommand cmd = new MySqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", Session["UserEmail"].ToString());

            using (MySqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    fullName = reader["FullName"].ToString();
                    email = reader["Email"].ToString();
                    phone = reader["Phone"].ToString();
                    address = reader["Address"].ToString();
                    employmentType = reader["Occupation"].ToString();
                    monthlyIncome = reader["MonthlyIncome"].ToString();
                }
            }
        }
    }

    // Helper to use posted value or autofill fallback
    string getValue(string key, string fallback) => string.IsNullOrEmpty(Request.Form[key]) ? fallback : Request.Form[key];

    // =========================
    //  Variables for loan calculation
    // =========================
    string alert = "";
    decimal TotalAmount = 0;
    decimal interestRate = 0;
    int months = 12;
    string payableMessage = "";
    string TotalMOnths = "";
    string deadline = "";
    decimal monthlyPayable = 0;

    string selectedLoanType = Request.QueryString["loanType"];

    // Load hidden fields if page was posted
    decimal.TryParse(Request.Form["totalAmountHidden"], out TotalAmount);
    decimal.TryParse(Request.Form["interestRateHidden"], out interestRate);
    int.TryParse(Request.Form["monthsHidden"], out months);
    decimal.TryParse(Request.Form["monthlyPayableHidden"], out monthlyPayable);
    deadline = Request.Form["deadlineHidden"];

    if (Request.HttpMethod == "POST")
    {
        string action = Request.Form["action"];

        if (action == "calculate")
        {
            string loanType = Request.Form["loanType"];
            decimal amount = 0;
            decimal.TryParse(Request.Form["loanAmount"], out amount);

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

                    // Set months based on loan amount
                    if (amount < 50000) months = 6;
                    else if (amount < 200000) months = 12;
                    else if (amount < 500000) months = 24;
                    else if (amount < 2000000) months = 36;
                    else if (amount < 5000000) months = 60;
                    else months = 84;

                    // EMI Calculation
                    decimal monthlyRate = interestRate / 12 / 100;
                    monthlyPayable = (amount * monthlyRate * (decimal)Math.Pow((double)(1 + monthlyRate), months))
                                    / (decimal)(Math.Pow((double)(1 + monthlyRate), months) - 1);
                    monthlyPayable = Math.Round(monthlyPayable, 2);

                    TotalAmount = monthlyPayable * months;
                    TotalAmount = Math.Round(TotalAmount, 2);

                    DateTime deadlineDate = DateTime.Now.AddMonths(months);
                    deadline = deadlineDate.ToString("dd-MMM-yyyy");

                    payableMessage = $"₹{TotalAmount:F2}";
                    TotalMOnths = $"{months} months (Deadline: {deadline})";
                }
                else
                {
                    payableMessage = "❌ No matching loan type found.";
                }
            }
        }
        else if (action == "submit")
        {
            try
            {
                string sFullName = Request.Form["fullName"];
                string sEmail = Request.Form["email"];
                string sPhone = Request.Form["phone"];
                string sAddress = Request.Form["address"];
                string sLoanType = Request.Form["loanType"];
                decimal sLoanAmount = Convert.ToDecimal(Request.Form["loanAmount"]);
                string sEmploymentType = Request.Form["employmentType"];
                decimal sMonthlyIncome = Convert.ToDecimal(Request.Form["monthlyIncome"]);

                decimal.TryParse(Request.Form["totalAmountHidden"], out TotalAmount);
                decimal.TryParse(Request.Form["monthlyPayableHidden"], out monthlyPayable);
                int.TryParse(Request.Form["monthsHidden"], out months);
                deadline = Request.Form["deadlineHidden"];

                HttpPostedFile documentFile = Request.Files["document"];
                if (documentFile == null || documentFile.ContentLength == 0)
                {
                    alert = "<div class='alert alert-danger alert-custom'>Please upload document!</div>";
                }
                else
                {
                    byte[] documentBytes = new byte[documentFile.ContentLength];
                    documentFile.InputStream.Read(documentBytes, 0, documentFile.ContentLength);

                    using (MySqlConnection conn = new MySqlConnection(connStr))
                    {
                        conn.Open();
                        string query = @"INSERT INTO LoanApplications 
                            (FullName, Email, Phone, Address, LoanType, LoanAmount, EmploymentType, MonthlyIncome, 
                            TotalAmount, Deadline, DurationMonths, MonthlyPayable, Status, AppliedAt, Document)
                            VALUES
                            (@FullName, @Email, @Phone, @Address, @LoanType, @LoanAmount, @EmploymentType, @MonthlyIncome, 
                            @TotalAmount, @Deadline, @DurationMonths, @MonthlyPayable, 'Pending', NOW(), @Document)";

                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@FullName", sFullName);
                        cmd.Parameters.AddWithValue("@Email", sEmail);
                        cmd.Parameters.AddWithValue("@Phone", sPhone);
                        cmd.Parameters.AddWithValue("@Address", sAddress);
                        cmd.Parameters.AddWithValue("@LoanType", sLoanType);
                        cmd.Parameters.AddWithValue("@LoanAmount", sLoanAmount);
                        cmd.Parameters.AddWithValue("@EmploymentType", sEmploymentType);
                        cmd.Parameters.AddWithValue("@MonthlyIncome", sMonthlyIncome);
                        cmd.Parameters.AddWithValue("@TotalAmount", Math.Round(TotalAmount,2));
                        cmd.Parameters.AddWithValue("@Deadline", deadline);
                        cmd.Parameters.AddWithValue("@DurationMonths", months);
                        cmd.Parameters.AddWithValue("@MonthlyPayable", Math.Round(monthlyPayable,2));
                        cmd.Parameters.AddWithValue("@Document", documentBytes);
                        cmd.ExecuteNonQuery();
                    }

                    alert = "<div class='alert alert-success alert-custom'>✓ Application submitted successfully!</div>";
                }
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

    <form method="post" enctype="multipart/form-data">
        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Full Name <span class="text-danger">*</span></label>
                <input type="text" class="form-control" name="fullName" value="<%= getValue("fullName", fullName) %>" required />
            </div>
            <div class="col">
                <label class="form-label">Email <span class="text-danger">*</span></label>
                <input type="email" class="form-control" name="email" value="<%= getValue("email", email) %>" required />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Phone <span class="text-danger">*</span></label>
                <input type="tel" class="form-control" name="phone" pattern="[0-9]{10}" value="<%= getValue("phone", phone) %>" required />
            </div>
            <div class="col">
                <label class="form-label">Loan Type <span class="text-danger">*</span></label>
                <!-- 🔹 Modified dropdown to preselect loan type from query string -->
                <select class="form-select" name="loanType" readonly>
                    <option value="">--Select--</option>
                    <option value="Personal Loan" <%= selectedLoanType=="Personal Loan"?"selected":"" %>>Personal Loan</option>
                    <option value="Home Loan" <%= selectedLoanType=="Home Loan"?"selected":"" %>>Home Loan</option>
                    <option value="Car Loan" <%= selectedLoanType=="Car Loan"?"selected":"" %>>Car Loan</option>
                    <option value="Education Loan" <%= selectedLoanType=="Education Loan"?"selected":"" %>>Education Loan</option>
                    <option value="Business Loan" <%= selectedLoanType=="Business Loan"?"selected":"" %>>Business Loan</option>
                    <option value="Gold Loan" <%= selectedLoanType=="Gold Loan"?"selected":"" %>>Gold Loan</option>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Address <span class="text-danger">*</span></label>
            <input type="text" class="form-control" name="address" value="<%= getValue("address", address) %>" required />
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Loan Amount (₹) <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="loanAmount" min="10000" step="1000" value="<%= getValue("loanAmount","") %>" required />
            </div>
            <div class="col">
                <label class="form-label">Deadline</label>
                <input type="text" class="form-control" name="deadline" value="<%= deadline %>" readonly />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">EMI (Monthly Payment)</label>
                <input type="text" class="form-control" name="emi" value="<%= monthlyPayable.ToString("F2") %>" readonly />
            </div>
            <div class="col">
                <label class="form-label">Total Months</label>
                <input type="text" class="form-control" name="emiMonths" value="<%= TotalMOnths %>" readonly />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Employment Type <span class="text-danger">*</span></label>
                <select class="form-select" name="employmentType" required>
                    <option value="">-- Select Occupation --</option>
                    <option value="Student" <%= getValue("employmentType", employmentType) == "Student" ? "selected" : "" %>>Student</option>
                    <option value="Software Developer" <%= getValue("employmentType", employmentType) == "Software Developer" ? "selected" : "" %>>Software Developer</option>
                    <option value="Teacher" <%= getValue("employmentType", employmentType) == "Teacher" ? "selected" : "" %>>Teacher</option>
                    <option value="Doctor" <%= getValue("employmentType", employmentType) == "Doctor" ? "selected" : "" %>>Doctor</option>
                    <option value="Business Owner" <%= getValue("employmentType", employmentType) == "Business Owner" ? "selected" : "" %>>Business Owner</option>
                    <option value="Housewife" <%= getValue("employmentType", employmentType) == "Housewife" ? "selected" : "" %>>Housewife</option>
                    <option value="Freelancer" <%= getValue("employmentType", employmentType) == "Freelancer" ? "selected" : "" %>>Freelancer</option>
                    <option value="Other" <%= getValue("employmentType", employmentType) == "Other" ? "selected" : "" %>>Other</option>
                </select>
            </div>
            <div class="col">
                <label class="form-label">Monthly Income (₹) <span class="text-danger">*</span></label>
                <input type="number" class="form-control" name="monthlyIncome" min="10000" step="1000" value="<%= getValue("monthlyIncome", monthlyIncome) %>" required />
            </div>
        </div>

        <!-- Hidden Fields -->
        <input type="hidden" name="totalAmountHidden" value="<%= TotalAmount %>" />
        <input type="hidden" name="interestRateHidden" value="<%= interestRate %>" />
        <input type="hidden" name="monthsHidden" value="<%= months %>" />
        <input type="hidden" name="deadlineHidden" value="<%= deadline %>" />
        <input type="hidden" name="monthlyPayableHidden" value="<%= monthlyPayable %>" />

        <div class="row mb-3">
            <div class="col">
                <label class="form-label">Total Payable Amount</label>
                <input type="text" class="form-control" name="totalAmountDisplay" value="<%= payableMessage %>" readonly />
            </div>
            <div class="col d-flex align-items-end">
                <button type="submit" name="action" value="calculate" class="btn btn-success flex-fill">Calculate</button>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Upload Document (PDF/Image) <span class="text-danger">*</span></label>
            <input type="file" class="form-control" name="document" accept=".pdf,.jpg,.jpeg,.png" />
        </div>

        <div class="d-flex gap-2">
            <button type="submit" name="action" value="submit" class="btn btn-primary flex-fill">Submit Application</button>
        </div>
    </form>
</div>
</body>
</html>
