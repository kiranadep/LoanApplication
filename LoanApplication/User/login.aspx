<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="LoanApplication.User.login" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Login - Loan Application</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e91e63, #f8f9fa);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-box {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 400px;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #e91e63;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        input[type="email"],
        input[type="password"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .btn-login {
            width: 100%;
            padding: 12px;
            background-color: #e91e63;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            font-weight: 600;
            margin-top: 10px;
        }
        .btn-login:hover {
            background-color: #d81b60;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #777;
        }
        .footer a {
            color: #e91e63;
            text-decoration: none;
            font-weight: 600;
        }
        .footer a:hover {
            text-decoration: underline;
        }
        .error {
            color: #d32f2f;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            background-color: #ffebee;
            border-radius: 5px;
            font-size: 14px;
        }
        .success {
            color: #388e3c;
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            background-color: #e8f5e9;
            border-radius: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-box">
            <h2>User Login</h2>
            
            <div class="form-group">
                <label for="txtEmail">Email</label>
                <input type="email" id="txtEmail" name="txtEmail" placeholder="Enter your email" required />
            </div>
            
            <div class="form-group">
                <label for="txtPassword">Password</label>
                <input type="password" id="txtPassword" name="txtPassword" placeholder="Enter your password" required />
            </div>
            
            <button type="submit" class="btn-login">Login</button>
            
            <div class="footer">
                Don't have an account? <a href="Register.aspx">Register here</a>
            </div>

            <%
                string errorMessage = "";
                string successMessage = "";

                if (IsPostBack)
                {
                    string email = Request.Form["txtEmail"];
                    string password = Request.Form["txtPassword"];

                    if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
                    {
                        errorMessage = "Please enter email and password.";
                    }
                    else
                    {
                        try
                        {
                            string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;
                            if (string.IsNullOrEmpty(connStr))
                                throw new Exception("Connection string 'LoanAppDB' not found in Web.config!");

                            using (MySqlConnection con = new MySqlConnection(connStr))
                            {
                                string query = "SELECT ID, FullName, Email FROM Users WHERE Email=@email AND Password=@password";
                                
                                using (MySqlCommand cmd = new MySqlCommand(query, con))
                                {
                                    cmd.Parameters.AddWithValue("@email", email);
                                    cmd.Parameters.AddWithValue("@password", password);

                                    con.Open();
                                    using (MySqlDataReader reader = cmd.ExecuteReader())
                                    {
                                        if (reader.Read())
                                        {
                                            // Login successful - store session
                                            Session["UserID"] = reader["ID"].ToString();
                                            Session["UserName"] = reader["FullName"].ToString();
                                            Session["UserEmail"] = reader["Email"].ToString();

                                            reader.Close();
                                            con.Close();

                                            Response.Redirect("../Loans/userview.aspx");
                                        }
                                        else
                                        {
                                            errorMessage = "Invalid email or password!";
                                        }
                                    }
                                }
                            }
                        }
                        catch (MySqlException sqlEx)
                        {
                            errorMessage = "Database Error: " + sqlEx.Message;
                        }
                        catch (Exception ex)
                        {
                            errorMessage = "Error: " + ex.Message;
                        }
                    }
                }
            %>

            <% if (!string.IsNullOrEmpty(successMessage)) { %>
                <div class="success"><%= successMessage %></div>
            <% } %>

            <% if (!string.IsNullOrEmpty(errorMessage)) { %>
                <div class="error"><%= errorMessage %></div>
            <% } %>
        </div>
    </form>
</body>
</html>
