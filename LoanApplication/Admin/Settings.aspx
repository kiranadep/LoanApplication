<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Settings - Manage Loan Types</title>
    <style>
        body { font-family:'Segoe UI'; background:#f4f7fa; padding:30px; }
        h1 { color:#1e3c72; margin-bottom: 20px; }
        form { background:#fff; padding:20px; border-radius:12px; width:500px; box-shadow:0 3px 10px rgba(0,0,0,0.1); margin-bottom:30px; }
        label { display:block; margin-top:10px; font-weight:600; }
        input, textarea { width:100%; padding:8px; border:1px solid #ccc; border-radius:6px; margin-top:5px; }
        button { margin-top:15px; padding:10px 20px; border:none; background:#1e3c72; color:#fff; border-radius:6px; cursor:pointer; font-weight:600; }
        button:hover { background:#2a5298; }
        .message { margin-top:15px; font-weight:600; }
        .success { color: green; }
        .error { color: red; }
        table { width:100%; border-collapse: collapse; background:white; box-shadow:0 3px 10px rgba(0,0,0,0.1); border-radius:12px; overflow:hidden; }
        th, td { padding:10px; text-align:left; border-bottom:1px solid #ddd; }
        th { background:#1e3c72; color:white; }
        tr:hover { background:#f1f1f1; }
        .action-btn { border:none; padding:6px 12px; border-radius:6px; cursor:pointer; font-weight:600; text-decoration:none; display:inline-block; }
        .delete-btn { background:#e74c3c; color:white; }
        .delete-btn:hover { background:#c0392b; }
        .edit-btn { background:#3498db; color:white; }
        .edit-btn:hover { background:#2980b9; }
    </style>
</head>
<body>

<script runat="server">

    // global variables accessible to HTML
    protected string message = "";
    protected string loanName = "", loanIcon = "", loanSummary = "", loanDetails = "",
                    eligibility = "", interestRate = "", maxAmount = "", tenure = "";
    protected string editId = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
        editId = Request.QueryString["edit"];
        string deleteId = Request.QueryString["delete"];

        // --- DELETE LOAN ---
        if (!string.IsNullOrEmpty(deleteId))
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    MySqlCommand cmd = new MySqlCommand("DELETE FROM LoanTypes WHERE ID=@id", conn);
                    cmd.Parameters.AddWithValue("@id", deleteId);
                    cmd.ExecuteNonQuery();
                }
                Response.Redirect("Settings.aspx");
            }
            catch (Exception ex)
            {
                message = "<span class='error'>Error deleting loan: " + ex.Message + "</span>";
            }
        }

        // --- LOAD DETAILS FOR EDIT ---
        if (!IsPostBack && !string.IsNullOrEmpty(editId))
        {
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * FROM LoanTypes WHERE ID=@id", conn);
                cmd.Parameters.AddWithValue("@id", editId);
                using (MySqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        loanName = dr["LoanName"].ToString();
                        loanIcon = dr["LoanIcon"].ToString();
                        loanSummary = dr["LoanSummary"].ToString();
                        loanDetails = dr["LoanDetails"].ToString();
                        eligibility = dr["Eligibility"].ToString();
                        interestRate = dr["InterestRate"].ToString();
                        maxAmount = dr["MaxAmount"].ToString();
                        tenure = dr["Tenure"].ToString();
                    }
                }
            }
        }

        // --- ADD / UPDATE LOAN ---
        if (IsPostBack)
        {
            loanName = Request.Form["LoanName"];
            loanIcon = Request.Form["LoanIcon"];
            loanSummary = Request.Form["LoanSummary"];
            loanDetails = Request.Form["LoanDetails"];
            eligibility = Request.Form["Eligibility"];
            interestRate = Request.Form["InterestRate"];
            maxAmount = Request.Form["MaxAmount"];
            tenure = Request.Form["Tenure"];

            try
            {
                using (MySqlConnection conn = new MySqlConnection(connString))
                {
                    conn.Open();
                    string query;

                    if (!string.IsNullOrEmpty(editId))
                    {
                        query = @"UPDATE LoanTypes SET 
                                  LoanName=@LoanName, LoanIcon=@LoanIcon, LoanSummary=@LoanSummary,
                                  LoanDetails=@LoanDetails, Eligibility=@Eligibility,
                                  InterestRate=@InterestRate, MaxAmount=@MaxAmount, Tenure=@Tenure
                                  WHERE ID=@id";
                    }
                    else
                    {
                        query = @"INSERT INTO LoanTypes 
                                  (LoanName, LoanIcon, LoanSummary, LoanDetails, Eligibility, InterestRate, MaxAmount, Tenure)
                                  VALUES (@LoanName, @LoanIcon, @LoanSummary, @LoanDetails, @Eligibility, @InterestRate, @MaxAmount, @Tenure)";
                    }

                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@LoanName", loanName);
                    cmd.Parameters.AddWithValue("@LoanIcon", loanIcon);
                    cmd.Parameters.AddWithValue("@LoanSummary", loanSummary);
                    cmd.Parameters.AddWithValue("@LoanDetails", loanDetails);
                    cmd.Parameters.AddWithValue("@Eligibility", eligibility);
                    cmd.Parameters.AddWithValue("@InterestRate", interestRate);
                    cmd.Parameters.AddWithValue("@MaxAmount", maxAmount);
                    cmd.Parameters.AddWithValue("@Tenure", tenure);
                    if (!string.IsNullOrEmpty(editId)) cmd.Parameters.AddWithValue("@id", editId);
                    cmd.ExecuteNonQuery();

                    Response.Redirect("Settings.aspx");
                }
            }
            catch (Exception ex)
            {
                message = "<span class='error'>Error saving loan: " + ex.Message + "</span>";
            }
        }
    }

    // --- LOAD ALL LOANS ---
    protected DataTable GetLoans()
    {
        DataTable dt = new DataTable();
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
        using (MySqlConnection conn = new MySqlConnection(connString))
        {
            conn.Open();
            MySqlDataAdapter da = new MySqlDataAdapter("SELECT * FROM LoanTypes ORDER BY ID DESC", conn);
            da.Fill(dt);
        }
        return dt;
    }


</script>

<h1>⚙️ Admin Settings - Manage Loan Types</h1>

<% if (string.IsNullOrEmpty(editId)) { %>
    <button type="button" onclick="document.getElementById('loanFormContainer').style.display='block'; this.style.display='none';" 
            style="margin-bottom:20px;">
        ➕ Add Loan Type
    </button>
<% } %>


<div id="loanFormContainer" style="display:none;">
<form id="form1" runat="server" method="post">
    <label>Loan Name:</label>
    <input type="text" name="LoanName" value="<%= loanName %>" required />

    <label>Loan Icon:</label>
    <input type="text" name="LoanIcon" value="<%= loanIcon %>" />

    <label>Loan Summary:</label>
    <input type="text" name="LoanSummary" value="<%= loanSummary %>" />

    <label>Loan Details:</label>
    <textarea name="LoanDetails" rows="3"><%= loanDetails %></textarea>

    <label>Eligibility:</label>
    <textarea name="Eligibility" rows="3"><%= eligibility %></textarea>

    <label>Interest Rate (%):</label>
    <input type="number" step="0.01" name="InterestRate" value="<%= interestRate %>" />

    <label>Max Amount:</label>
    <input type="number" step="0.01" name="MaxAmount" value="<%= maxAmount %>" />

    <label>Tenure (in months):</label>
    <input type="number" id="tenureMonthsInput" oninput="updateTenure()" required />

    <!-- Hidden input to send combined value to server -->
    <input type="hidden" id="tenureHidden" name="Tenure" value="<%= tenure %>" />

    <p id="tenureText" style="font-weight:bold; margin-top:5px;"></p>

    <button type="submit"><%= string.IsNullOrEmpty(editId) ? "💾 Add Loan" : "✏️ Update Loan" %></button>
</form>

<script>
    function updateTenure() {
        let totalMonths = parseInt(document.getElementById('tenureMonthsInput').value);

        if (isNaN(totalMonths) || totalMonths < 0) {
            document.getElementById('tenureText').innerText = "";
            document.getElementById('tenureHidden').value = "";
            return;
        }

        let years = Math.floor(totalMonths / 12);
        let months = totalMonths % 12;

        let result = "";
        if (years > 0) {
            result += years + " year" + (years > 1 ? "s" : "");
        }
        if (months > 0) {
            if (years > 0) result += " and ";
            result += months + " Month" + (months > 1 ? "s" : "");
        }

        if (result === "") result = "0 Months";

        // Display formatted text to user
        document.getElementById('tenureText').innerText = "(" + result + ")";

        // Store in hidden field as: "30 (2 years and 6 Months)"
        document.getElementById('tenureHidden').value = totalMonths + " (" + result + ")";
    }
</script>

</div>
    <script>
        window.onload = function () {
        <% if (!string.IsNullOrEmpty(editId)) { %>
            document.getElementById('loanFormContainer').style.display = 'block';
        <% } %>
        }
    </script>


<div class="message"><%= message %></div>

<h2>📋 Existing Loans</h2>
<table>
    <tr>
        <th>ID</th>
        <th>Icon</th>
        <th>Name</th>
        <th>Interest</th>
        <th>Max</th>
        <th>Tenure</th>
        <th>Actions</th>
    </tr>

<%
    DataTable dt = GetLoans();
    foreach (DataRow row in dt.Rows)
    {
%>
    <tr>
        <td><%= row["ID"] %></td>
        <td><%= row["LoanIcon"] %></td>
        <td><%= row["LoanName"] %></td>
        <td><%= row["InterestRate"] %></td>
        <td><%= row["MaxAmount"] %></td>
        <td><%= row["Tenure"] %></td>
        <td>
            <a href="Settings.aspx?edit=<%= row["ID"] %>" class="action-btn edit-btn">Edit</a>
            <a href="Settings.aspx?delete=<%= row["ID"] %>" onclick="return confirm('Delete this loan?');" class="action-btn delete-btn">Delete</a>
        </td>
    </tr>
<% } %>
</table>

</body>
</html>
