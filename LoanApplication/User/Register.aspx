<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="LoanApplication.User.Register" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Register - Loan Application</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" 
          integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" 
          crossorigin="anonymous">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Register - Loan Application</h4>
                    </div>
                    <div class="card-body">
                        <form id="form1" runat="server">
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="txtFullName" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="txtEmail" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="txtPassword" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="text" name="txtPhone" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea name="txtAddress" class="form-control" rows="3" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Occupation</label>
                                <select name="txtOccupation" class="form-control" required>
                                    <option value="">-- Select Occupation --</option>
                                    <option value="Student">Student</option>
                                    <option value="Software Developer">Software Developer</option>
                                    <option value="Teacher">Teacher</option>
                                    <option value="Doctor">Doctor</option>
                                    <option value="Business Owner">Business Owner</option>
                                    <option value="Housewife">Housewife</option>
                                    <option value="Freelancer">Freelancer</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Monthly Income</label>
                                <input type="number" step="0.01" name="txtIncome" class="form-control" required />
                            </div>
                            <button type="submit" class="btn btn-success w-100">Register</button>
                            <p class="text-center mt-3">Already have an account? <a href="Login.aspx">Login here</a></p>
                        </form>

                        <%
                            string errorMessage = "";
                            string successMessage = "";

                            if (IsPostBack)
                            {
                                string fullName = Request.Form["txtFullName"];
                                string email = Request.Form["txtEmail"];
                                string password = Request.Form["txtPassword"];
                                string phone = Request.Form["txtPhone"];
                                string address = Request.Form["txtAddress"];
                                string occupation = Request.Form["txtOccupation"];
                                string incomeStr = Request.Form["txtIncome"];

                                if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) ||
                                    string.IsNullOrEmpty(password) || string.IsNullOrEmpty(phone) ||
                                    string.IsNullOrEmpty(address) || string.IsNullOrEmpty(occupation) ||
                                    string.IsNullOrEmpty(incomeStr))
                                {
                                    errorMessage = "All fields are required!";
                                }
                                else
                                {
                                    try
                                    {
                                        decimal income = Convert.ToDecimal(incomeStr);

                                        // Railway MySQL Connection string
                                        string connStr = ConfigurationManager.ConnectionStrings["LoanAppDB"]?.ConnectionString;
                                        if (string.IsNullOrEmpty(connStr))
                                            throw new Exception("Connection string 'LoanAppDB' not found in Web.config!");

                                        using (MySqlConnection con = new MySqlConnection(connStr))
                                        {
                                            string query = @"INSERT INTO Users (FullName, Email, Password, Phone, Address, Occupation, MonthlyIncome)
                                                             VALUES (@FullName, @Email, @Password, @Phone, @Address, @Occupation, @MonthlyIncome)";

                                            using (MySqlCommand cmd = new MySqlCommand(query, con))
                                            {
                                                cmd.Parameters.AddWithValue("@FullName", fullName);
                                                cmd.Parameters.AddWithValue("@Email", email);
                                                cmd.Parameters.AddWithValue("@Password", password);
                                                cmd.Parameters.AddWithValue("@Phone", phone);
                                                cmd.Parameters.AddWithValue("@Address", address);
                                                cmd.Parameters.AddWithValue("@Occupation", occupation);
                                                cmd.Parameters.AddWithValue("@MonthlyIncome", income);

                                                con.Open();
                                                int rowsAffected = cmd.ExecuteNonQuery();
                                                con.Close();

                                                if (rowsAffected > 0)
                                                {
                                                    successMessage = "Registration successful! Redirecting to login...";
                                                    Response.Write("<script>setTimeout(function(){ window.location.href = 'Login.aspx'; }, 2000);</script>");
                                                }
                                                else
                                                {
                                                    errorMessage = "Registration failed. Please try again.";
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
                            <div class="alert alert-success mt-3"><%= successMessage %></div>
                        <% } %>

                        <% if (!string.IsNullOrEmpty(errorMessage)) { %>
                            <div class="alert alert-danger mt-3"><%= errorMessage %></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
