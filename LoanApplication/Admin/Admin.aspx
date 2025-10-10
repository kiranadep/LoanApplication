<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="LoanApplication.Admin.Admin" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Login - Loan Application</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 0;
        }
        .login-box {
            width: 350px;
            margin: 120px auto;
            padding: 30px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0px 0px 8px #888;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #444;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn-login {
            width: 100%;
            padding: 10px;
            background: #0078d7;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-login:hover {
            background: #005a9e;
        }
        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box">
            <h2>Admin Login</h2>

            <%
                string errorMessage = "";

                if (IsPostBack)
                {
                    string username = Request.Form["txtUsername"];
                    string password = Request.Form["txtPassword"];

                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                    {
                        errorMessage = "Please enter username and password.";
                    }
                    else
                    {
                        // MySQL connection string (defined in Web.config)
                        string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;

                        using (MySqlConnection con = new MySqlConnection(connStr))
                        {
                            // ✅ Case-sensitive comparison using BINARY
                            string query = "SELECT COUNT(*) FROM Admin WHERE BINARY Username=@uname AND BINARY Password=@pwd";

                            using (MySqlCommand cmd = new MySqlCommand(query, con))
                            {
                                cmd.Parameters.AddWithValue("@uname", username);
                                cmd.Parameters.AddWithValue("@pwd", password);

                                con.Open();
                                int count = Convert.ToInt32(cmd.ExecuteScalar());
                                con.Close();

                                if (count == 1)
                                {
                                    Session["AdminUser"] = username;
                                    Response.Redirect("AdminDashboard.aspx");
                                }
                                else
                                {
                                    errorMessage = "Invalid username or password!";
                                }
                            }
                        }
                    }
                }
            %>

            <input type="text" name="txtUsername" placeholder="Enter Username" class="form-control" />
            <input type="password" name="txtPassword" placeholder="Enter Password" class="form-control" />
            <input type="submit" value="Login" class="btn-login" />

            <% if (!string.IsNullOrEmpty(errorMessage)) { %>
                <div class="error"><%= errorMessage %></div>
            <% } %>
        </div>
    </form>
</body>
</html>
