<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="registersql.aspx.cs" Inherits="LoanApplication.User.registersql" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%
       string username = Request.Form["t1"];
    string password = Request.Form["t2"];

    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
    {
        Response.Redirect("userlogin.aspx");
        return;
    }


    string path = "Data Source=LAPTOP-P2EGJFP1\\SQLEXPRESS;Initial Catalog=loan;Integrated Security=True;";

    SqlConnection con = new SqlConnection(path);



    SqlCommand cmd = new SqlCommand("select * from Users where Username ='" + username + "' and Password ='" + password + "'", con);

    cmd.Parameters.AddWithValue("@Username", username);
    cmd.Parameters.AddWithValue("@Password", password);

    con.Open();

    SqlDataReader br = cmd.ExecuteReader(); // get UserID

    if (br.Read())
    {
        // ✅ Set session for LoanHistory.aspx
        Session["FullName"] = Convert.ToInt32(br["fullName"]);
        Response.Redirect("../LoanHistry/LoanHistory.aspx");
    }
    else
    {
        Session["LoginError"] = "You entered wrong username or password";
        Response.Redirect("use.aspx");

    }





%>
</body>
</html>
