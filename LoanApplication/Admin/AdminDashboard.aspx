<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="LoanApplication.Admin.AdminDashboard" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard - Loan Applications</title>
    <style>
        /* ===== Reset & Base ===== */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { display: flex; min-height: 100vh; background: #f4f7fa; }

        /* ===== Sidebar ===== */
        .sidebar {
            width: 220px;
            background: #1e3c72;
            color: #fff;
            padding: 20px;
            display: flex;
            flex-direction: column;
        }
        .sidebar h2 { font-size: 20px; margin-bottom: 30px; text-align: center; }
        .sidebar a {
            color: #fff;
            text-decoration: none;
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            display: block;
            transition: 0.3s;
        }
        .sidebar a:hover { background: #2a5298; }
        .sidebar a.active { background: #7e22ce; }

        /* ===== Main Content ===== */
        .main-content { flex: 1; padding: 30px; }
        .header h1 { color: #1e3c72; font-size: 28px; margin-bottom: 5px; }
        .header p { color: #666; font-size: 14px; margin-bottom: 20px; }

        /* ===== Alerts ===== */
        .alert { padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        /* ===== Statistics Cards ===== */
        .stats-container { display: flex; gap: 20px; margin-bottom: 25px; flex-wrap: wrap; }
        .stat-card { flex: 1; background: #fff; padding: 20px; border-radius: 12px; text-align: center; box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
        .stat-number { font-size: 24px; font-weight: bold; color: #1e3c72; }
        .stat-label { font-size: 14px; color: #666; margin-top: 5px; }

        .stat-card.pending { border-left: 4px solid #ffc107; }
        .stat-card.approved { border-left: 4px solid #28a745; }
        .stat-card.rejected { border-left: 4px solid #dc3545; }

        /* ===== Search Section ===== */
        .search-section { background: #fff; padding: 15px 20px; border-radius: 12px; display: flex; gap: 15px; margin-bottom: 25px; flex-wrap: wrap; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .search-group { display: flex; flex-direction: column; }
        .search-group label { font-size: 12px; color: #333; margin-bottom: 5px; }
        .search-group input, .search-group select { padding: 8px 10px; border-radius: 6px; border: 1px solid #ccc; }
        .btn-search { padding: 8px 20px; background: #1e3c72; color: #fff; border: none; border-radius: 6px; cursor: pointer; transition: 0.3s; }
        .btn-search:hover { background: #2a5298; }

        /* ===== Table ===== */
        .table-container { overflow-x: auto; background: #fff; border-radius: 12px; padding: 15px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; text-align: left; border-bottom: 1px solid #eee; font-size: 14px; }
        th { background: #f4f7fa; }
        .amount { text-align: right; }
        .status-badge { padding: 4px 10px; border-radius: 6px; color: #fff; font-size: 12px; }
        .status-pending { background: #ffc107; }
        .status-approved { background: #28a745; }
        .status-rejected { background: #dc3545; }

        .btn-action { padding: 5px 10px; border: none; border-radius: 6px; cursor: pointer; font-size: 12px; margin-right: 5px; color: #fff; }
        .btn-approve { background: #28a745; }
        .btn-reject { background: #dc3545; }
        .btn-delete { background: #6c757d; }
        .no-records { text-align: center; padding: 10px; font-style: italic; color: #666; }

        /* Responsive */
        @media(max-width: 900px) { body { flex-direction: column; } .sidebar { width: 100%; flex-direction: row; overflow-x: auto; } .sidebar a { flex: 1; text-align: center; } }
    </style>
</head>
<body>
    <!-- ===== Sidebar ===== -->
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="AdminDashboard.aspx" class="active">Dashboard</a>
        <a href="Users.aspx">View Users</a>
        <a href="#">Settings</a>
        <a href="#">Logout</a>
    </div>

    <!-- ===== Main Content ===== -->
    <div class="main-content">
        <div class="header">
            <h1>Loan Applications Dashboard</h1>
            <p class="subtitle">View and manage all loan applications</p>
        </div>

        <%
        // ===== Server-side Variables =====
        string alertMessage = "";
        string alertType = "";

        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;

        if (Request.HttpMethod == "POST")
        {
            string action = Request.Form["action"];
            string applicationId = Request.Form["applicationId"];

            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    string query = "";

                    if (action == "approve")
                    {
                        query = "UPDATE LoanApplications SET Status='Approved' WHERE ApplicationID=@ID";
                        alertMessage = "✓ Application approved successfully!";
                        alertType = "success";
                    }
                    else if (action == "reject")
                    {
                        query = "UPDATE LoanApplications SET Status='Rejected' WHERE ApplicationID=@ID";
                        alertMessage = "✓ Application rejected successfully!";
                        alertType = "success";
                    }
                    else if (action == "delete")
                    {
                        query = "DELETE FROM LoanApplications WHERE ApplicationID=@ID";
                        alertMessage = "✓ Application deleted successfully!";
                        alertType = "success";
                    }

                    MySqlCommand cmd = new MySqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@ID", applicationId);
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    alertMessage = "✗ Error: " + ex.Message;
                    alertType = "error";
                }
            }
        }

        // Get filters
        string searchName = Request.QueryString["searchName"] ?? "";
        string filterStatus = Request.QueryString["filterStatus"] ?? "";
        string filterLoanType = Request.QueryString["filterLoanType"] ?? "";
        %>

        <!-- ===== Alert ===== -->
        <%
        if (!string.IsNullOrEmpty(alertMessage))
        {
            Response.Write("<div class='alert alert-" + alertType + "'>" + alertMessage + "</div>");
        }
        %>

        <!-- ===== Statistics ===== -->
        <%
        int totalApps = 0, pendingCount = 0, approvedCount = 0, rejectedCount = 0;

        using (MySqlConnection statsConn = new MySqlConnection(connString))
        {
            try
            {
                statsConn.Open();
                MySqlCommand statsCmd = new MySqlCommand("SELECT Status, COUNT(*) as Count FROM LoanApplications GROUP BY Status", statsConn);
                MySqlDataReader statsReader = statsCmd.ExecuteReader();

                while (statsReader.Read())
                {
                    string status = statsReader["Status"].ToString();
                    int count = Convert.ToInt32(statsReader["Count"]);
                    totalApps += count;

                    if (status == "Pending") pendingCount = count;
                    else if (status == "Approved") approvedCount = count;
                    else if (status == "Rejected") rejectedCount = count;
                }
                statsReader.Close();
            }
            catch { }
        }
        %>

        <!-- ===== Statistics Cards ===== -->
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-number"><%= totalApps %></div>
                <div class="stat-label">Total Applications</div>
            </div>
            <div class="stat-card pending">
                <div class="stat-number"><%= pendingCount %></div>
                <div class="stat-label">Pending</div>
            </div>
            <div class="stat-card approved">
                <div class="stat-number"><%= approvedCount %></div>
                <div class="stat-label">Approved</div>
            </div>
            <div class="stat-card rejected">
                <div class="stat-number"><%= rejectedCount %></div>
                <div class="stat-label">Rejected</div>
            </div>
        </div>

        <!-- ===== Search Section ===== -->
        <div class="search-section">
            <form method="get" style="display: contents;">
                <div class="search-group">
                    <label>Search by Name</label>
                    <input type="text" name="searchName" placeholder="Enter name..." value="<%= searchName %>" />
                </div>
                <div class="search-group">
                    <label>Filter by Status</label>
                    <select name="filterStatus">
                        <option value="">All Status</option>
                        <option value="Pending" <%= filterStatus == "Pending" ? "selected" : "" %>>Pending</option>
                        <option value="Approved" <%= filterStatus == "Approved" ? "selected" : "" %>>Approved</option>
                        <option value="Rejected" <%= filterStatus == "Rejected" ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <div class="search-group">
                    <label>Filter by Loan Type</label>
                    <select name="filterLoanType">
                        <option value="">All Types</option>
                        <option value="Personal Loan" <%= filterLoanType == "Personal Loan" ? "selected" : "" %>>Personal Loan</option>
                        <option value="Home Loan" <%= filterLoanType == "Home Loan" ? "selected" : "" %>>Home Loan</option>
                        <option value="Car Loan" <%= filterLoanType == "Car Loan" ? "selected" : "" %>>Car Loan</option>
                        <option value="Education Loan" <%= filterLoanType == "Education Loan" ? "selected" : "" %>>Education Loan</option>
                        <option value="Business Loan" <%= filterLoanType == "Business Loan" ? "selected" : "" %>>Business Loan</option>
                        <option value="Gold Loan" <%= filterLoanType == "Gold Loan" ? "selected" : "" %>>Gold Loan</option>
                    </select>
                </div>
                <button type="submit" class="btn-search">🔍 Search</button>
            </form>
        </div>

        <!-- ===== Applications Table ===== -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Full Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Loan Type</th>
                        <th>Amount</th>
                        <th>Employment</th>
                        <th>Income</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    using (MySqlConnection conn2 = new MySqlConnection(connString))
                    {
                        try
                        {
                            conn2.Open();
                            string query = "SELECT * FROM LoanApplications WHERE 1=1";

                            if (!string.IsNullOrEmpty(searchName))
                                query += " AND FullName LIKE @SearchName";
                            if (!string.IsNullOrEmpty(filterStatus))
                                query += " AND Status=@FilterStatus";
                            if (!string.IsNullOrEmpty(filterLoanType))
                                query += " AND LoanType=@FilterLoanType";

                            MySqlCommand cmd = new MySqlCommand(query, conn2);

                            if (!string.IsNullOrEmpty(searchName))
                                cmd.Parameters.AddWithValue("@SearchName", "%" + searchName + "%");
                            if (!string.IsNullOrEmpty(filterStatus))
                                cmd.Parameters.AddWithValue("@FilterStatus", filterStatus);
                            if (!string.IsNullOrEmpty(filterLoanType))
                                cmd.Parameters.AddWithValue("@FilterLoanType", filterLoanType);

                            MySqlDataReader reader = cmd.ExecuteReader();
                            bool hasRecords = false;

                            while (reader.Read())
                            {
                                hasRecords = true;
                                string status = reader["Status"].ToString();
                                string statusClass = status == "Pending" ? "status-pending" : 
                                                   status == "Approved" ? "status-approved" : "status-rejected";

                                Response.Write("<tr>");
                                Response.Write("<td>" + reader["ApplicationID"] + "</td>");
                                Response.Write("<td>" + reader["FullName"] + "</td>");
                                Response.Write("<td>" + reader["Email"] + "</td>");
                                Response.Write("<td>" + reader["Phone"] + "</td>");
                                Response.Write("<td>" + reader["LoanType"] + "</td>");
                                Response.Write("<td class='amount'>₹" + Convert.ToDecimal(reader["LoanAmount"]).ToString("N0") + "</td>");
                                Response.Write("<td>" + reader["EmploymentType"] + "</td>");
                                Response.Write("<td class='amount'>₹" + Convert.ToDecimal(reader["MonthlyIncome"]).ToString("N0") + "</td>");
                                Response.Write("<td><span class='status-badge " + statusClass + "'>" + status + "</span></td>");
                                Response.Write("<td>");

                                if (status == "Pending")
                                {
                                    Response.Write("<form method='post' style='display:inline;'>");
                                    Response.Write("<input type='hidden' name='applicationId' value='" + reader["ApplicationID"] + "' />");
                                    Response.Write("<button type='submit' name='action' value='approve' class='btn-action btn-approve'>✓ Approve</button>");
                                    Response.Write("<button type='submit' name='action' value='reject' class='btn-action btn-reject'>✗ Reject</button>");
                                    Response.Write("</form>");
                                }

                                Response.Write("<form method='post' style='display:inline;' onsubmit='return confirm(\"Are you sure?\");'>");
                                Response.Write("<input type='hidden' name='applicationId' value='" + reader["ApplicationID"] + "' />");
                                Response.Write("<button type='submit' name='action' value='delete' class='btn-action btn-delete'>🗑 Delete</button>");
                                Response.Write("</form>");

                                Response.Write("</td>");
                                Response.Write("</tr>");
                            }

                            if (!hasRecords)
                            {
                                Response.Write("<tr><td colspan='10' class='no-records'>📋 No loan applications found</td></tr>");
                            }

                            reader.Close();
                        }
                        catch (Exception ex)
                        {
                            Response.Write("<tr><td colspan='10' class='no-records' style='color:red;'>Error: " + ex.Message + "</td></tr>");
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
