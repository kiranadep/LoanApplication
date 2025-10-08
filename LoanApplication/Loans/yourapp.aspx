<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="yourapp.aspx.cs" Inherits="LoanApplication.Loans.yourapp" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Application</title>
</head>
<body style="font-family:'Segoe UI';padding:30px;background:#f4f7fa;">
<h1>👤 Your Application</h1>

<table border="1" cellpadding="8" cellspacing="0" style="background:#fff;border-collapse:collapse;width:100%;">
<tr>
    <th>Loan Type</th>
    <th>Loan Amount</th>
    <th>Status</th>
    <th>Action</th>
</tr>
<%
string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;

// Assuming user email is stored in session after login
string userEmail = Session["UserEmail"] as string;

if (!string.IsNullOrEmpty(userEmail))
{
    using (MySqlConnection conn = new MySqlConnection(connString))
    {
        conn.Open();
        MySqlCommand cmd = new MySqlCommand("SELECT LoanType, LoanAmount, Status FROM LoanApplications WHERE Email = @Email", conn);
        cmd.Parameters.AddWithValue("@Email", userEmail);

        MySqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            Response.Write("<tr>");
            Response.Write("<td>" + reader["LoanType"] + "</td>");
            Response.Write("<td>" + reader["LoanAmount"] + "</td>");
            Response.Write("<td>" + reader["Status"] + "</td>");
%>
            <td>
                <a href="yourapp.aspx" class="btn btn-outline-danger">Delete</a>
            </td>

 <%             
            Response.Write("</tr>");
        }
    }
}
else
{
    Response.Write("<tr><td colspan='3' style='text-align:center;color:red;'>Please log in to view your application details.</td></tr>");
}
%>
</table>
</body>
</html>
