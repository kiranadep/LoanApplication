<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Settings - Add Loan Type</title>
    <style>
        body { font-family:'Segoe UI'; background:#f4f7fa; padding:30px; }
        h1 { color:#1e3c72; margin-bottom: 20px; }
        form { background:#fff; padding:20px; border-radius:12px; width:500px; box-shadow:0 3px 10px rgba(0,0,0,0.1); }
        label { display:block; margin-top:10px; font-weight:600; }
        input, textarea { width:100%; padding:8px; border:1px solid #ccc; border-radius:6px; margin-top:5px; }
        button { margin-top:15px; padding:10px 20px; border:none; background:#1e3c72; color:#fff; border-radius:6px; cursor:pointer; font-weight:600; }
        .message { margin-top:15px; font-weight:600; }
        .success { color: green; }
        .error { color: red; }
    </style>
</head>
<body>
    <h1>⚙️ Admin Settings - Add New Loan Type</h1>

    <%
        string message = "";
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;

        if (IsPostBack)
        {
            string loanName = Request.Form["LoanName"];
            string loanIcon = Request.Form["LoanIcon"];
            string loanSummary = Request.Form["LoanSummary"];
            string loanDetails = Request.Form["LoanDetails"];
            string eligibility = Request.Form["Eligibility"];
            string interestRate = Request.Form["InterestRate"];
            string maxAmount = Request.Form["MaxAmount"];
            string tenure = Request.Form["Tenure"];

            if (!string.IsNullOrEmpty(loanName))
            {
                try
                {
                    using (MySqlConnection conn = new MySqlConnection(connString))
                    {
                        conn.Open();
                        string query = "INSERT INTO LoanTypes (LoanName, LoanIcon, LoanSummary, LoanDetails, Eligibility, InterestRate, MaxAmount, Tenure) " +
                                       "VALUES (@LoanName, @LoanIcon, @LoanSummary, @LoanDetails, @Eligibility, @InterestRate, @MaxAmount, @Tenure)";
                        MySqlCommand cmd = new MySqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@LoanName", loanName);
                        cmd.Parameters.AddWithValue("@LoanIcon", loanIcon);
                        cmd.Parameters.AddWithValue("@LoanSummary", loanSummary);
                        cmd.Parameters.AddWithValue("@LoanDetails", loanDetails);
                        cmd.Parameters.AddWithValue("@Eligibility", eligibility);
                        cmd.Parameters.AddWithValue("@InterestRate", interestRate);
                        cmd.Parameters.AddWithValue("@MaxAmount", maxAmount);
                        cmd.Parameters.AddWithValue("@Tenure", tenure);
                        cmd.ExecuteNonQuery();
                        message = "<span class='success'>✅ Loan type added successfully!</span>";
                    }
                }
                catch (Exception ex)
                {
                    message = "<span class='error'>❌ Error: " + ex.Message + "</span>";
                }
            }
            else
            {
                message = "<span class='error'>❌ Loan Name is required!</span>";
            }
        }
    %>

    <form method="post">
        <label>New Loan Name:</label>
        <input type="text" name="LoanName" required />

        <label>Loan Icon (Emoji):</label>
        <input type="text" name="LoanIcon" placeholder="e.g., 👤" />

        <label>Loan Summary:</label>
        <input type="text" name="LoanSummary" />

        <label>Loan Details:</label>
        <textarea name="LoanDetails" rows="3"></textarea>

        <label>Eligibility Criteria:</label>
        <textarea name="Eligibility" rows="3"></textarea>

        <label>Interest Rate (%):</label>
        <input type="number" name="InterestRate" step="0.01" />

        <label>Max Loan Amount:</label>
        <input type="number" name="MaxAmount" step="0.01" />

        <label>Tenure:</label>
        <input type="text" name="Tenure" />

        <button type="submit">💾 Save Loan Type</button>

        <div class="message"><%= message %></div>
    </form>
</body>
</html>
