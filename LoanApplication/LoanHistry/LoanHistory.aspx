<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoanHistory.aspx.cs" Inherits="LoanApplication.LoanHistry.LoanHistory" %>




<%@ Import Namespace="System.Data.SqlClient" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Loan History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        .loan-card { 
            border-left: 5px solid #0d6efd;
            transition: box-shadow 0.3s ease; 

        }
        .loan-card:hover { 
            box-shadow: 0 0 10px rgba(0,0,0,0.15); 

        }
        .status-approved { 
            color: green; font-weight: bold;

        /*}*/
        .status-pending { 
            color: orange; font-weight: bold; 

        }
        .status-rejected { 
        .status-rejected { 
            color: red; font-weight: bold;

        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-4">
            <h2 class="text-center mb-4">Your Loan History</h2>
            <div class="row row-cols-1 row-cols-md-2 g-4">
            <%
                if (Session["UserID"] != null)
                {
                    int userId = Convert.ToInt32(Session["UserID"]);
                    string connectionString = "Data Source=LAPTOP-P2EGJFP1\\SQLEXPRESS;Initial Catalog=Loan;Integrated Security=True;";
                    string query = "SELECT LoanID, Amount, Status, DateApplied, LoanType FROM LoanHistry WHERE UserID=@UserID ORDER BY DateApplied DESC";

                    using(SqlConnection con = new SqlConnection(connectionString))
                    using(SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        con.Open();
                        using(SqlDataReader br = cmd.ExecuteReader())
                        {
                            if(br.HasRows)
                            {
                                while(br.Read())
                                {
                                    string loanId = br["LoanID"].ToString();
                                    string amount = Convert.ToDecimal(br["Amount"]).ToString("₹#,##0.00");
                                    string status = br["Status"].ToString();
                                    string Loantype = br["Loantype"]ToString();
                                    string dateApplied = Convert.ToDateTime(br["DateApplied"]).ToString("yyyy-MM-dd");

                                    string statusClass = "";
                                    string statusIcon = "";
                                    switch(status.ToLower())
                                    {
                                        case "approved": statusClass="status-approved"; statusIcon="✅"; break;
                                        case "pending": statusClass="status-pending"; statusIcon="⏳"; break;
                                        case "rejected": statusClass="status-rejected"; statusIcon="❌"; break;
                                    }
            %>
                <div class="col">
                    <div class="card loan-card">
                        <div class="card-body">
                            <h5 class="card-title">Loan ID: <%= loanId %></h5>
                            <p class="card-text">Amount: <%= amount %></p>
                            <p class="card-text">Date Applied: <%= dateApplied %></p>
                            <p class="card-text <%= statusClass %>">Status: <%= status %> <%= statusIcon %></p>
                        </div>
                    </div>
                </div>
            <%
                                }
                            }
                            else
                            {
            %>
                <div class="col">
                    <div class="alert alert-info">No loan history found.</div>
                </div>
            <%
                            }
                        }
                    }
                }
                else
                {
            %>
                <div class="col">
                    <div class="alert alert-warning">User not logged in. Please log in to view your loan history.</div>
                </div>
            <%
                }
            %>
            </div>
        </div>
    </form>

  </body>
    </html>