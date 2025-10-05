<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Users.aspx.cs" Inherits="LoanApplication.Admin.Users" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html>
<head><title>Users</title></head>
<body style="font-family:'Segoe UI';padding:30px;background:#f4f7fa;">
<h1>👤 Registered Users</h1>
<table border="1" cellpadding="8" cellspacing="0" style="background:#fff;border-collapse:collapse;width:100%;">
<tr><th>UserID</th><th>Full Name</th><th>Email</th><th>Phone</th><th>Actions</th></tr>
<%
string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
using (MySqlConnection conn = new MySqlConnection(connString))
{
    conn.Open();
    MySqlCommand cmd = new MySqlCommand("SELECT * FROM Users", conn);
    MySqlDataReader reader = cmd.ExecuteReader();
    while (reader.Read())
    {
        Response.Write("<tr>");
        Response.Write("<td>" + reader["Id"] + "</td>");
        Response.Write("<td>" + reader["FullName"] + "</td>");
        Response.Write("<td>" + reader["Email"] + "</td>");
        Response.Write("<td>" + reader["Phone"] + "</td>");
        Response.Write("<td><button style='background:#dc3545;color:#fff;border:none;padding:5px 10px;border-radius:5px;'>🗑 Delete</button></td>");
        Response.Write("</tr>");
    }
}
%>
</table>
</body>
</html>
