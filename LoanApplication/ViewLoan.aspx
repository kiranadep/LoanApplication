<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewLoan.aspx.cs" Inherits="LoanApplication.ViewLoan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Loan Applications</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container { 
            max-width: 1400px; 
            margin: 0 auto; 
            background: white; 
            padding: 40px; 
            border-radius: 15px; 
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        h1 { 
            color: #1e3c72; 
            margin-bottom: 10px;
            font-size: 32px;
        }
        .subtitle {
            color: #666;
            font-size: 14px;
        }
        .search-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: end;
        }
        .search-group {
            flex: 1;
            min-width: 200px;
        }
        .search-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 600;
            font-size: 14px;
        }
        .search-group input, .search-group select {
            width: 100%;
            padding: 10px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        .btn-search {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
            height: 42px;
        }
        .btn-search:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3);
        }
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 20px;
            border-radius: 10px;
            color: white;
            text-align: center;
        }
        .stat-card.pending {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .stat-card.approved {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        .stat-card.rejected {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
        }
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
        }
        .table-container {
            overflow-x: auto;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        thead {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white;
        }
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            white-space: nowrap;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
        }
        tr:hover {
            background: #f8f9fa;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            display: inline-block;
        }
        .status-pending {
            background: #fff3cd;
            color: #856404;
        }
        .status-approved {
            background: #d4edda;
            color: #155724;
        }
        .status-rejected {
            background: #f8d7da;
            color: #721c24;
        }
        .btn-action {
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            font-weight: bold;
            margin-right: 5px;
            transition: all 0.2s;
        }
        .btn-approve {
            background: #28a745;
            color: white;
        }
        .btn-approve:hover {
            background: #218838;
        }
        .btn-reject {
            background: #dc3545;
            color: white;
        }
        .btn-reject:hover {
            background: #c82333;
        }
        .btn-delete {
            background: #6c757d;
            color: white;
        }
        .btn-delete:hover {
            background: #5a6268;
        }
        .alert { 
            padding: 15px 20px; 
            margin-bottom: 25px; 
            border-radius: 8px; 
            text-align: center; 
            font-weight: 500;
            animation: slideDown 0.3s ease;
        }
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .alert-success { 
            background: #d4edda; 
            color: #155724; 
            border: 1px solid #c3e6cb; 
        }
        .alert-error { 
            background: #f8d7da; 
            color: #721c24; 
            border: 1px solid #f5c6cb; 
        }
        .no-records {
            text-align: center;
            padding: 40px;
            color: #666;
            font-size: 16px;
        }
        .amount {
            color: #2a5298;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Loan Applications Dashboard</h1>
            <p class="subtitle">View and manage all loan applications</p>
        </div>

        <%
        string alertMessage = "";
        string alertType = "";
        string connString = "Data Source=LAPTOP-8665JUUD\\SQLEXPRESS;Initial Catalog=LoanDB1;Integrated Security=True";
        
        // Handle actions (Approve, Reject, Delete)
        if (Request.HttpMethod == "POST")
        {
            string action = Request.Form["action"];
            string applicationId = Request.Form["applicationId"];
            
            SqlConnection conn = new SqlConnection(connString);
            
            try
            {
                conn.Open();
                string query = "";
                
                if (action == "approve")
                {
                    query = "UPDATE LoanApplications SET Status = 'Approved' WHERE ApplicationID = @ID";
                    alertMessage = "✓ Application approved successfully!";
                    alertType = "success";
                }
                else if (action == "reject")
                {
                    query = "UPDATE LoanApplications SET Status = 'Rejected' WHERE ApplicationID = @ID";
                    alertMessage = "✓ Application rejected successfully!";
                    alertType = "success";
                }
                else if (action == "delete")
                {
                    query = "DELETE FROM LoanApplications WHERE ApplicationID = @ID";
                    alertMessage = "✓ Application deleted successfully!";
                    alertType = "success";
                }
                
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", applicationId);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                alertMessage = "✗ Error: " + ex.Message;
                alertType = "error";
            }
            finally
            {
                if (conn.State == ConnectionState.Open)
                {
                    conn.Close();
                }
            }
        }
        
        // Display alert message
        if (!string.IsNullOrEmpty(alertMessage))
        {
            Response.Write("<div class='alert alert-" + alertType + "'>" + alertMessage + "</div>");
        }
        
        // Get filter parameters
        string searchName = Request.QueryString["searchName"] ?? "";
        string filterStatus = Request.QueryString["filterStatus"] ?? "";
        string filterLoanType = Request.QueryString["filterLoanType"] ?? "";
        %>

        <!-- Search Section -->
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

        <%
        // Statistics
        SqlConnection statsConn = new SqlConnection(connString);
        int totalApps = 0, pendingCount = 0, approvedCount = 0, rejectedCount = 0;
        
        try
        {
            statsConn.Open();
            SqlCommand statsCmd = new SqlCommand("SELECT Status, COUNT(*) as Count FROM LoanApplications GROUP BY Status", statsConn);
            SqlDataReader statsReader = statsCmd.ExecuteReader();
            
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
        catch (Exception) { }
        finally
        {
            if (statsConn.State == ConnectionState.Open)
                statsConn.Close();
        }
        %>

        <!-- Statistics Cards -->
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

        <!-- Applications Table -->
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
                        
                    </tr>
                </thead>
                <tbody>
                    <%
                    SqlConnection conn2 = new SqlConnection(connString);
                    
                    try
                    {
                        conn2.Open();
                        
                        // Build query with filters
                        string query = "SELECT * FROM LoanApplications WHERE 1=1";
                        
                        if (!string.IsNullOrEmpty(searchName))
                        {
                            query += " AND FullName LIKE @SearchName";
                        }
                        if (!string.IsNullOrEmpty(filterStatus))
                        {
                            query += " AND Status = @FilterStatus";
                        }
                        if (!string.IsNullOrEmpty(filterLoanType))
                        {
                            query += " AND LoanType = @FilterLoanType";
                        }
                        
                        
                        
                        SqlCommand cmd = new SqlCommand(query, conn2);
                        
                        if (!string.IsNullOrEmpty(searchName))
                        {
                            cmd.Parameters.AddWithValue("@SearchName", "%" + searchName + "%");
                        }
                        if (!string.IsNullOrEmpty(filterStatus))
                        {
                            cmd.Parameters.AddWithValue("@FilterStatus", filterStatus);
                        }
                        if (!string.IsNullOrEmpty(filterLoanType))
                        {
                            cmd.Parameters.AddWithValue("@FilterLoanType", filterLoanType);
                        }
                        
                        SqlDataReader reader = cmd.ExecuteReader();
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
                            
                            Response.Write("<form method='post' style='display:inline;' onsubmit='return confirm(\"Are you sure you want to delete this application?\");'>");
                            Response.Write("<input type='hidden' name='applicationId' value='" + reader["ApplicationID"] + "' />");
                            Response.Write("<button type='submit' name='action' value='delete' class='btn-action btn-delete'>🗑 Delete</button>");
                            Response.Write("</form>");
                            
                            Response.Write("</td>");
                            Response.Write("</tr>");
                        }
                        
                        if (!hasRecords)
                        {
                            Response.Write("<tr><td colspan='11' class='no-records'>📋 No loan applications found</td></tr>");
                        }
                        
                        reader.Close();
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<tr><td colspan='11' class='no-records' style='color:red;'>Error: " + ex.Message + "</td></tr>");
                    }
                    finally
                    {
                        if (conn2.State == ConnectionState.Open)
                        {
                            conn2.Close();
                        }
                    }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
