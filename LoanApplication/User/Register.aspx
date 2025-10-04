<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="LoanApplication.User.Register" %>
<%@ Import Namespace="System.Data.SqlClient" %>
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
                        <!-- Form posting to the same page -->
                        <form method="post">
                            <div class="mb-3">
                                <label class="form-label">Full Name</label>
                                <input type="text" name="t1" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Email</label>
                                <input type="email" name="t2" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Password</label>
                                <input type="password" name="t3" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Phone Number</label>
                                <input type="text" name="t4" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea name="t5" class="form-control" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Occupation</label>
                                <input type="text" name="t6" class="form-control" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Monthly Income</label>
                                <input type="number" step="0.01" name="t7" class="form-control" required />
                            </div>
                            <button type="submit" class="btn btn-success w-100">Register</button>
                            <p class="text-center mt-3">Already have an account? <a href="Login.aspx">Login here</a></p>
                        </form>

                        <%
                                        if (IsPostBack)
                                        {
                                            try
                                            {
                                                // Get form values
                                                string t1 = Request.Form["t1"];
                                                string t2 = Request.Form["t2"];
                                                string t3 = Request.Form["t3"];
                                                string t4 = Request.Form["t4"];
                                                string t5 = Request.Form["t5"];
                                                string t6 = Request.Form["t6"];
                                                decimal t7 = Convert.ToDecimal(Request.Form["t7"]);

                                                // Connection string
                                                string path = @"Data Source=LAPTOP-8665JUUD\SQLEXPRESS;Initial Catalog=LoanDB1;Integrated Security=True";

                                                SqlConnection con = new SqlConnection(path);

                                                string query = "INSERT INTO UserN (FullName, Email, Password, Phone, Address, Occupation, MonthlyIncome) VALUES (@FullName, @Email, @Password, @Phone, @Address, @Occupation, @MonthlyIncome)";

                                                SqlCommand cmd = new SqlCommand(query, con);

                                                cmd.Parameters.AddWithValue("@FullName", t1);
                                                cmd.Parameters.AddWithValue("@Email", t2);
                                                cmd.Parameters.AddWithValue("@Password", t3);
                                                cmd.Parameters.AddWithValue("@Phone", t4);
                                                cmd.Parameters.AddWithValue("@Address", t5);
                                                cmd.Parameters.AddWithValue("@Occupation", t6);
                                                cmd.Parameters.AddWithValue("@MonthlyIncome", t7);

                                                con.Open();
                                                cmd.ExecuteNonQuery();
                                            
                                    

                                        // Redirect to Login.aspx after successful registration
                                        Response.Redirect("Login.aspx");
                                    }
                                catch (Exception ex)
                                {
                                    // Show any error for debugging
                                    Response.Write("<div class='alert alert-danger mt-3'>Error: " + ex.Message + "</div>");
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
