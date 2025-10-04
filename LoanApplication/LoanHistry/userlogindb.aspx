<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userlogindb.aspx.cs" Inherits="LoanApplication.LoanHistry.userlogindb" %>

<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login Processing</title>
</head>
<body>          
<%
  

    


    string path = "Data Source=LAPTOP-8665JUUD\\SQLEXPRESS;Initial Catalog=LoanDB1;Integrated Security=True;";

    SqlConnection con = new SqlConnection(path);



    SqlCommand cmd = new SqlCommand("select * from Users where FullName ='" +  + "' and Password ='" + + "'", con);

    con.Open();

    SqlDataReader br = cmd.ExecuteReader(); // get UserID

        Response.Redirect("../Loans/userview/.aspx");
  




%>
</body>
</html>