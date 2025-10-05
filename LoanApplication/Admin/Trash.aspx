<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Trash.aspx.cs" Inherits="LoanApplication.Admin.Trash" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html>
<head>
    <title>Trash Bin - Loan Applications</title>
    <style>
        body { font-family: 'Segoe UI'; background:#f4f7fa; padding:30px; }
        h1 { color:#1e3c72; }
        table { width:100%; border-collapse:collapse; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 3px 10px rgba(0,0,0,0.1); }
        th,td { padding:10px; border-bottom:1px solid #eee; text-align:left; }
        th { background:#f4f7fa; }
        .btn { padding:6px 10px; border:none; border-radius:6px; color:#fff; cursor:pointer; font-size:12px; margin-right:5px; }
        .btn-restore { background:#28a745; }
        .btn-delete { background:#dc3545; }
    </style>
</head>
<body>
    <h1>🗑 Deleted Applications</h1>

    <%
    string alertMessage = "";
    if (Request.HttpMethod == "POST")
    {
        string action = Request.Form["action"];
        string appId = Request.Form["id"];
        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;

        using (MySqlConnection conn = new MySqlConnection(connString))
        {
            conn.Open();
            if (action == "permanentDelete")
            {
                MySqlCommand delCmd = new MySqlCommand("DELETE FROM DeletedApplications WHERE ApplicationID=@ID", conn);
                delCmd.Parameters.AddWithValue("@ID", appId);
                int rows = delCmd.ExecuteNonQuery();
                if (rows > 0) alertMessage = "✓ Application permanently deleted!";
            }
        }
    }

    if (!string.IsNullOrEmpty(alertMessage))
    {
        Response.Write("<div style='padding:10px;background:#d4edda;color:#155724;border-radius:6px;margin-bottom:10px;'>" + alertMessage + "</div>");
    }
    %>

    <table>
        <tr><th>ID</th><th>Name</th><th>Loan Type</th><th>Deleted At</th><th>Actions</th></tr>
        <%
        try
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connString))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand("SELECT * FROM DeletedApplications", conn);
                MySqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Response.Write("<tr>");
                    Response.Write("<td>" + reader["ApplicationID"] + "</td>");
                    Response.Write("<td>" + reader["FullName"] + "</td>");
                    Response.Write("<td>" + reader["LoanType"] + "</td>");
                    Response.Write("<td>" + reader["DeletedAt"] + "</td>");
                    Response.Write("<td>");
                    
                    // Restore Button
                    Response.Write("<form method='post' action='Restore.aspx' style='display:inline;'>");
                    Response.Write("<input type='hidden' name='id' value='" + reader["ApplicationID"] + "' />");
                    Response.Write("<button class='btn btn-restore'>↩ Restore</button>");
                    Response.Write("</form>");

                    // Permanent Delete Button
                    Response.Write("<form method='post' style='display:inline;' onsubmit='return confirm(\"Are you sure you want to permanently delete?\");'>");
                    Response.Write("<input type='hidden' name='id' value='" + reader["ApplicationID"] + "' />");
                    Response.Write("<button type='submit' name='action' value='permanentDelete' class='btn btn-delete'>🗑 Delete</button>");
                    Response.Write("</form>");

                    Response.Write("</td>");
                    Response.Write("</tr>");
                }

                reader.Close();
            }
        }
        catch (Exception ex)
        {
            Response.Write("<tr><td colspan='5' style='color:red;'>Error: " + ex.Message + "</td></tr>");
        }
        %>
    </table>
</body>
</html>
