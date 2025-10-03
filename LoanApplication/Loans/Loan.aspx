<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Loan.aspx.cs" Inherits="LoanApplication.Loans.Loan" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Apply for Loan</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container { 
            max-width: 700px; 
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
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-group { 
            flex: 1;
            margin-bottom: 20px; 
        }
        label { 
            display: block; 
            margin-bottom: 8px; 
            color: #333; 
            font-weight: 600;
            font-size: 14px;
        }
        input, select, textarea { 
            width: 100%; 
            padding: 12px 15px; 
            border: 2px solid #e0e0e0; 
            border-radius: 8px; 
            font-size: 15px; 
            transition: all 0.3s;
            font-family: inherit;
        }
        input:focus, select:focus, textarea:focus { 
            outline: none; 
            border-color: #2a5298;
            box-shadow: 0 0 0 3px rgba(42, 82, 152, 0.1);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .required { color: #e74c3c; }
        .btn-submit { 
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white; 
            padding: 15px 40px; 
            border: none; 
            border-radius: 8px; 
            cursor: pointer; 
            font-size: 16px; 
            font-weight: bold; 
            width: 100%; 
            transition: all 0.3s;
            margin-top: 10px;
        }
        .btn-submit:hover { 
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(30, 60, 114, 0.3);
        }
        .btn-submit:active {
            transform: translateY(0);
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
        .info-box {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            border-left: 4px solid #2196f3;
        }
        .info-box p {
            color: #1976d2;
            font-size: 14px;
            margin: 5px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Loan Application</h1>
            <p class="subtitle">Fill out the form below to apply for a loan</p>
        </div>

        <%
        string alertMessage = "";
        string alertType = "";
        
        if (Request.HttpMethod == "POST")
        {
            // Retrieve form data
            string fullName = Request.Form["fullName"];
            string email = Request.Form["email"];
            string phone = Request.Form["phone"];
            string address = Request.Form["address"];
            string loanType = Request.Form["loanType"];
            string loanAmount = Request.Form["loanAmount"];
            string employmentType = Request.Form["employmentType"];
            string monthlyIncome = Request.Form["monthlyIncome"];
            
            // Create database connection
            string connString = "Data Source=LAPTOP-8665JUUD\\SQLEXPRESS;Initial Catalog=LoanDB1;Integrated Security=True";
            SqlConnection conn = new SqlConnection(connString);
            
            try
            {
                // Open connection
                conn.Open();
                
                // SQL Insert query
                string query = @"INSERT INTO LoanApplications 
                               (FullName, Email, Phone, Address, LoanType, LoanAmount, 
                                EmploymentType, MonthlyIncome,  Status) 
                               VALUES 
                               (@FullName, @Email, @Phone, @Address, @LoanType, @LoanAmount, 
                                @EmploymentType, @MonthlyIncome, @Status)";
                
                // Create command with parameters
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FullName", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Address", address);
                cmd.Parameters.AddWithValue("@LoanType", loanType);
                cmd.Parameters.AddWithValue("@LoanAmount", Convert.ToDecimal(loanAmount));
                cmd.Parameters.AddWithValue("@EmploymentType", employmentType);
                cmd.Parameters.AddWithValue("@MonthlyIncome", Convert.ToDecimal(monthlyIncome));
                cmd.Parameters.AddWithValue("@Status", "Pending");
                
                // Execute query
                int rowsAffected = cmd.ExecuteNonQuery();
                
                if (rowsAffected > 0)
                {
                    alertMessage = "✓ Application submitted successfully! Reference ID will be sent to your email.";
                    alertType = "success";
                }
                else
                {
                    alertMessage = "✗ Failed to submit application. Please try again.";
                    alertType = "error";
                }
            }
            catch (SqlException ex)
            {
                alertMessage = "✗ Database Error: " + ex.Message;
                alertType = "error";
            }
            catch (Exception ex)
            {
                alertMessage = "✗ Error: " + ex.Message;
                alertType = "error";
            }
            finally
            {
                // Close connection
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
        %>

        <div class="info-box">
            <p><strong>📋 Before you apply:</strong></p>
            <p>• Ensure all information provided is accurate</p>
            <p>• Have your employment and income documents ready</p>
            <p>• Processing time: 2-3 business days</p>
        </div>

        <form method="post" action="">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name <span class="required">*</span></label>
                    <input type="text" name="fullName" placeholder="Enter your full name" required />
                </div>
                
                <div class="form-group">
                    <label>Email Address <span class="required">*</span></label>
                    <input type="email" name="email" placeholder="example@email.com" required />
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Phone Number <span class="required">*</span></label>
                    <input type="tel" name="phone" placeholder="10-digit mobile number" pattern="[0-9]{10}" required />
                </div>
                
                <div class="form-group">
                    <label>Loan Type <span class="required">*</span></label>
                    <select name="loanType" required>
                        <option value="">-- Select Loan Type --</option>
                        <option value="Personal Loan">Personal Loan</option>
                        <option value="Home Loan">Home Loan</option>
                        <option value="Car Loan">Car Loan</option>
                        <option value="Education Loan">Education Loan</option>
                        <option value="Business Loan">Business Loan</option>
                        <option value="Gold Loan">Gold Loan</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label>Address <span class="required">*</span></label>
                <input type="text" name="address" placeholder="Enter your complete address" required />
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Loan Amount (₹) <span class="required">*</span></label>
                    <input type="number" name="loanAmount" placeholder="50000" min="10000" max="10000000" step="1000" required />
                </div>
                
            
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label>Employment Type <span class="required">*</span></label>
                    <select name="employmentType" required>
                        <option value="">-- Select Type --</option>
                        <option value="Salaried">Salaried</option>
                        <option value="Self-Employed">Self-Employed</option>
                        <option value="Business Owner">Business Owner</option>
                        <option value="Professional">Professional</option>
                        <option value="Retired">Retired</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Monthly Income (₹) <span class="required">*</span></label>
                    <input type="number" name="monthlyIncome" placeholder="25000" min="10000" step="1000" required />
                </div>
            </div>

           
            <button type="submit" class="btn-submit">Submit Application</button>
        </form>
    </div>
</body>
</html>
