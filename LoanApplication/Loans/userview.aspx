<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userview.aspx.cs" Inherits="LoanApplication.Loans.userview3" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="MySql.Data.MySqlClient" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Loan Services - Apply Now</title>
    
</head>
<body>
    <form id="form1" runat="server">
        <!-- Menu Toggle Button -->
        <div class="menu-toggle" onclick="toggleSidebar()">
            <span></span>
        </div>

        <!-- Sidebar Overlay -->
        <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <h2>💰 LoanHub</h2>
                <p>Your Financial Partner</p>
            </div>
            <ul class="sidebar-menu">
                <li>
                    <a href="../Loans/yourapp.aspx">
                        <span class="menu-icon">📋</span>
                        <span>Your Applications</span>
                    </a>
                </li>
                <li>
                    <a href="../About/AboutUs.aspx">
                        <span class="menu-icon">ℹ️</span>
                        <span>About Us</span>
                    </a>
                </li>
            </ul>
        </div>

        <!-- Header -->
        <div class="header">
            <div class="logo">💰 LoanHub</div>
            <div class="auth-buttons">
                <%
                    bool isLoggedIn = Session["UserID"] != null;
                    string userName = Session["UserName"] != null ? Session["UserName"].ToString() : "";
                    if (isLoggedIn)
                    {
                %>
                    <span class="user-welcome">Welcome, <%= userName %>!</span>
                    <button type="submit" name="btnLogout" class="btn-logout">Logout</button>
                <% } else { %>
                    <button type="button" class="btn-login" onclick="window.location.href='../user/login.aspx'">Login</button>
                    <button type="button" class="btn-signup" onclick="window.location.href='../user/Register.aspx'">Register</button>
                <% } %>
            </div>
        </div>

        <%
            if (IsPostBack && Request.Form["btnLogout"] != null)
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("userview.aspx");
            }
        %>

        <!-- Hero -->
        <div class="hero">
            <h1>Find Your Perfect Loan</h1>
            <p>Quick approval • Low interest rates • Flexible terms</p>
        </div>

        <!-- Loan Cards -->
        <div class="container">
            <div class="loan-grid">
                <%
                    string connString = System.Configuration.ConfigurationManager.ConnectionStrings["LoanAppDB"].ConnectionString;
                    try
                    {
                        using (MySqlConnection conn = new MySqlConnection(connString))
                        {
                            conn.Open();
                            MySqlCommand cmd = new MySqlCommand("SELECT * FROM LoanTypes", conn);
                            MySqlDataReader reader = cmd.ExecuteReader();
                            while (reader.Read())
                            {
                                string loanId = reader["ID"].ToString();
                                string loanName = reader["LoanName"].ToString();
                                string loanIcon = reader["LoanIcon"].ToString();
                                string loanSummary = reader["LoanSummary"].ToString();
                %>
                                <div class="loan-card" onclick="openModal('modal<%=loanId%>')">
                                    <div class="loan-icon"><%=loanIcon%></div>
                                    <div class="loan-title"><%=loanName%></div>
                                    <div class="loan-summary"><%=loanSummary%></div>
                                    <div class="learn-more">Click to learn more →</div>
                                </div>

                                <!-- Modal -->
                                <div id="modal<%=loanId%>" class="modal">
                                    <div class="modal-content">
                                        <span class="close" onclick="closeModal('modal<%=loanId%>')">&times;</span>
                                        <div class="modal-header">
                                            <div class="modal-icon"><%=loanIcon%></div>
                                            <div class="modal-title"><%=loanName%></div>
                                        </div>
                                        <div class="modal-body">
                                            <p><%=reader["LoanDetails"].ToString()%></p>
                                            <ul class="feature-list">
                                                <li>Eligibility: <%=reader["Eligibility"].ToString()%></li>
                                                <li>Interest Rate: <%=reader["InterestRate"].ToString()%> %</li>
                                                <li>Max Amount: ₹<%=reader["MaxAmount"].ToString()%></li>
                                                <li>Tenure: <%=reader["Tenure"].ToString()%></li>
                                            </ul>
                                            <% if (isLoggedIn) { %>
                                                <button type="button" class="btn-apply" 
                                                        onclick="window.location.href='../Loans/Loan.aspx?loan=<%=loanId%>'">
                                                    Apply Now
                                                </button>
                                            <% } else { %>
                                                <button type="button" class="btn-apply" 
                                                        onclick="alert('You must login first to apply for a loan'); window.location.href='../user/login.aspx';">
                                                    Apply Now
                                                </button>
                                            <% } %>

                                        </div>
                                    </div>
                                </div>
                <%
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<p style='color:red;font-weight:bold;'>Error: " + ex.Message + "</p>");
                    }
                %>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                var sidebar = document.querySelector('.sidebar');
                var overlay = document.querySelector('.sidebar-overlay');
                var toggle = document.querySelector('.menu-toggle');

                sidebar.classList.toggle('active');
                overlay.classList.toggle('active');
                toggle.classList.toggle('active');
            }

            function openModal(id) { document.getElementById(id).style.display = "block"; }
            function closeModal(id) { document.getElementById(id).style.display = "none"; }

            window.onclick = function (event) {
                var modals = document.getElementsByClassName("modal");
                for (var i = 0; i < modals.length; i++) {
                    if (event.target == modals[i]) { modals[i].style.display = "none"; }
                }
            }

            //chatboat script
            function toggleChatbot() {
                document.getElementById("chatbot-box").classList.toggle("active");
            }

            function sendMessage() {
                let input = document.getElementById("chatbot-input");
                let msg = input.value.trim();
                if (!msg) return;

                let chat = document.getElementById("chatbot-messages");
                chat.innerHTML += `<div class='chat-msg user-msg'>${msg}</div>`;
                input.value = "";

                // Simulated AI reply (replace this with API call)
                let reply = getBotResponse(msg);
                setTimeout(() => {
                    chat.innerHTML += `<div class='chat-msg bot-msg'>${reply}</div>`;
                    chat.scrollTop = chat.scrollHeight;
                }, 700);
            }

            function getBotResponse(msg) {
                msg = msg.toLowerCase();

                // Greetings & small talk
                if (msg.includes("hello") || msg.includes("hi") || msg.includes("hey"))
                    return "Hello 👋 I'm your Loan Assistant! How can I help you today?";
                if (msg.includes("how are you"))
                    return "I'm just a bot, but I’m always ready to help you with loan-related queries 😊";
                if (msg.includes("thank"))
                    return "You're welcome! I'm happy to assist you. 🙌";
                if (msg.includes("bye"))
                    return "Goodbye! 👋 Have a great day and best of luck with your loan journey!";

                // Loan-related
                if (msg.includes("loan") && msg.includes("apply"))
                    return "You can apply for any loan by clicking the 'Apply Now' button on its card!";
                if (msg.includes("types of loan") || msg.includes("loan types"))
                    return "We currently offer Personal Loan, Home Loan, Car Loan, Education Loan, and Business Loan.";
                if (msg.includes("personal loan"))
                    return "A Personal Loan helps with your personal needs — like travel, medical expenses, or debt consolidation.";
                if (msg.includes("home loan"))
                    return "A Home Loan helps you buy or build your dream house 🏠. Usually, interest starts from 8.5% per annum.";
                if (msg.includes("car loan"))
                    return "Car Loans are available for both new and used cars 🚗 with flexible EMIs.";
                if (msg.includes("education loan"))
                    return "Education Loans help cover tuition, books, and living expenses while studying 🎓.";
                if (msg.includes("business loan"))
                    return "Business Loans are designed to help startups and existing businesses with capital and growth 💼.";

                // Interest rates
                if (msg.includes("interest"))
                    return "Interest rates vary between 8% to 14% depending on loan type and applicant profile.";
                if (msg.includes("lowest interest"))
                    return "Home loans and secured loans generally have the lowest interest rates, starting around 8%.";

                // Eligibility & documents
                if (msg.includes("eligibility"))
                    return "Eligibility depends on income, credit score, and employment history. Salaried and self-employed people are eligible.";
                if (msg.includes("documents") || msg.includes("requirement"))
                    return "Common documents: Aadhaar card, PAN card, salary slips or ITR, bank statements, and address proof.";
                if (msg.includes("income proof"))
                    return "You can provide your salary slips (for salaried) or ITR (for self-employed) as income proof.";

                // EMI & repayment
                if (msg.includes("emi"))
                    return "EMI stands for Equated Monthly Instalment — a fixed monthly amount you pay towards loan repayment.";
                if (msg.includes("calculate") && msg.includes("emi"))
                    return "You can use our EMI Calculator on the Loans page to get an estimate of your monthly payments.";
                if (msg.includes("repay") || msg.includes("payment"))
                    return "You can repay your loan through monthly EMIs using auto-debit or manual payment from your registered bank account.";

                // Application process
                if (msg.includes("process") || msg.includes("steps"))
                    return "Step 1️⃣ Choose your loan type → Step 2️⃣ Fill in the online form → Step 3️⃣ Upload documents → Step 4️⃣ Wait for verification → Step 5️⃣ Get approval and disbursal!";
                if (msg.includes("approve") || msg.includes("approval"))
                    return "Loan approval usually takes 24-48 hours after document verification.";
                if (msg.includes("rejected"))
                    return "If your loan is rejected, check your credit score or missing documents and try reapplying.";

                // Credit score
                if (msg.includes("credit score") || msg.includes("cibil"))
                    return "A minimum CIBIL score of 700+ is usually required for smooth loan approval.";

                // Contact / Help
                if (msg.includes("contact") || msg.includes("help") || msg.includes("support"))
                    return "You can reach our support team at support@loanassist.com or visit the 'Contact Us' page.";

                // Default / fallback response
                return "I’m not sure about that 🤔, but you can explore our loan options above or contact support for more info!";
            }

        </script>
    </form>
    <div id="chatbot-icon" onclick="toggleChatbot()">💬</div>

    <!-- Chatbot Window -->
    <div id="chatbot-box">
        <div id="chatbot-header">
            <span>Loan Assistant AI 🤖</span>
            <button onclick="toggleChatbot()">✖</button>
        </div>
        <div id="chatbot-messages"></div>
        <div id="chatbot-input-area">
            <input type="text" id="chatbot-input" placeholder="Ask about loan types..." />
            <button onclick="sendMessage()">Send</button>
        </div>
    </div>
</body>
</html>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
               background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
               min-height: 100vh; }
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: relative;
            z-index: 100;
        }
        .logo { font-size: 28px; font-weight: bold; background: linear-gradient(135deg, #1e3c72, #7e22ce); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .auth-buttons { display: flex; gap: 15px; align-items: center; }
        .user-welcome { font-size: 14px; color: #1e3c72; font-weight: 600; margin-right: 10px; }
        .btn-login, .btn-signup, .btn-logout { padding: 10px 25px; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: bold; transition: all 0.3s; }
        .btn-login { background: white; color: #1e3c72; border: 2px solid #1e3c72; }
        .btn-login:hover { background: #1e3c72; color: white; }
        .btn-signup { background: linear-gradient(135deg, #1e3c72 0%, #7e22ce 100%); color: white; }
        .btn-signup:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3); }
        .btn-logout { background: #dc3545; color: white; }
        .btn-logout:hover { background: #c82333; transform: translateY(-2px); }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            left: -300px;
            top: 0;
            width: 300px;
            height: 100vh;
            background: white;
            box-shadow: 2px 0 20px rgba(0,0,0,0.2);
            transition: left 0.3s ease;
            z-index: 999;
            overflow-y: auto;
        }
        .sidebar.active { left: 0; }
        .sidebar-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            z-index: 998;
        }
        .sidebar-overlay.active { display: block; }
        .menu-toggle {
            position: fixed;
            left: 20px;
            top: 90px;
            width: 50px;
            height: 50px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            transition: all 0.3s;
            z-index: 101;
        }
        .menu-toggle:hover { transform: scale(1.1); box-shadow: 0 6px 20px rgba(0,0,0,0.3); }
        .menu-toggle span {
            display: block;
            width: 24px;
            height: 3px;
            background: #1e3c72;
            position: relative;
            transition: all 0.3s;
        }
        .menu-toggle span::before, .menu-toggle span::after {
            content: '';
            position: absolute;
            width: 24px;
            height: 3px;
            background: #1e3c72;
            left: 0;
            transition: all 0.3s;
        }
        .menu-toggle span::before { top: -8px; }
        .menu-toggle span::after { top: 8px; }
        .menu-toggle.active span { background: transparent; }
        .menu-toggle.active span::before { top: 0; transform: rotate(45deg); }
        .menu-toggle.active span::after { top: 0; transform: rotate(-45deg); }
        
        .sidebar-header {
            padding: 30px 20px;
            background: linear-gradient(135deg, #1e3c72 0%, #7e22ce 100%);
            color: white;
        }
        .sidebar-header h2 { font-size: 22px; margin-bottom: 5px; }
        .sidebar-header p { font-size: 14px; opacity: 0.9; }
        
        .sidebar-menu { list-style: none; padding: 20px 0; }
        .sidebar-menu li { padding: 0; }
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 18px 25px;
            color: #333;
            text-decoration: none;
            font-size: 16px;
            transition: all 0.3s;
            border-left: 4px solid transparent;
        }
        .sidebar-menu a:hover {
            background: #f8f9fa;
            border-left-color: #7e22ce;
            padding-left: 30px;
        }
        .sidebar-menu a.active {
            background: linear-gradient(90deg, #f0f4ff 0%, #fff 100%);
            border-left-color: #1e3c72;
            color: #1e3c72;
            font-weight: 600;
        }
        .sidebar-menu .menu-icon {
            font-size: 20px;
            margin-right: 15px;
            width: 24px;
            text-align: center;
        }

        .hero { text-align: center; padding: 60px 20px; color: white; }
        .hero h1 { font-size: 48px; margin-bottom: 20px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .hero p { font-size: 20px; margin-bottom: 10px; opacity: 0.95; }

        .container { max-width: 1400px; margin: 0 auto; padding: 40px 20px; }
        .loan-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 30px; margin-top: 40px; }
        .loan-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); transition: all 0.3s; cursor: pointer; position: relative; overflow: hidden; }
        .loan-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 5px; background: linear-gradient(90deg, #1e3c72, #7e22ce); }
        .loan-card:hover { transform: translateY(-10px); box-shadow: 0 15px 40px rgba(0,0,0,0.3); }
        .loan-icon { font-size: 48px; margin-bottom: 20px; }
        .loan-title { font-size: 24px; font-weight: bold; color: #1e3c72; margin-bottom: 15px; }
        .loan-summary { color: #666; font-size: 14px; line-height: 1.6; margin-bottom: 20px; }
        .learn-more { color: #7e22ce; font-weight: bold; font-size: 14px; }

        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.7); animation: fadeIn 0.3s; }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        .modal-content { position: relative; background: white; margin: 50px auto; padding: 40px; width: 90%; max-width: 700px; border-radius: 15px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-height: 85vh; overflow-y: auto; animation: slideDown 0.3s; }
        @keyframes slideDown { from { transform: translateY(-50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .close { position: absolute; right: 20px; top: 20px; font-size: 32px; font-weight: bold; color: #666; cursor: pointer; transition: color 0.3s; }
        .close:hover { color: #dc3545; }
        .modal-header { display: flex; align-items: center; gap: 20px; margin-bottom: 25px; padding-bottom: 20px; border-bottom: 3px solid #f0f0f0; }
        .modal-icon { font-size: 56px; }
        .modal-title { font-size: 32px; color: #1e3c72; font-weight: bold; }
        .modal-body { color: #333; line-height: 1.8; }
        .feature-list { list-style: none; margin: 20px 0; }
        .feature-list li { padding: 12px 0; padding-left: 30px; position: relative; font-size: 15px; }
        .feature-list li::before { content: '✓'; position: absolute; left: 0; color: #28a745; font-weight: bold; font-size: 18px; }
        .highlight-box { background: linear-gradient(135deg, #f093fb15 0%, #f5576c15 100%); padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 4px solid #7e22ce; }
        .highlight-box h3 { color: #1e3c72; margin-bottom: 10px; font-size: 18px; }
        .btn-apply { width: 100%; padding: 15px; background: linear-gradient(135deg, #1e3c72 0%, #7e22ce 100%); color: white; border: none; border-radius: 10px; font-size: 18px; font-weight: bold; cursor: pointer; margin-top: 25px; transition: all 0.3s; }
        .btn-apply:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(30, 60, 114, 0.4); }
        #chatbot-icon {
    position: fixed;
    bottom: 25px;
    right: 25px;
    background: linear-gradient(135deg, #1e3c72, #7e22ce);
    color: white;
    width: 60px; height: 60px;
    border-radius: 50%;
    font-size: 28px;
    display: flex; align-items: center; justify-content: center;
    cursor: pointer;
    box-shadow: 0 5px 20px rgba(0,0,0,0.3);
    z-index: 1001;
}
#chatbot-box {
    position: fixed;
    bottom: 100px; right: 25px;
    width: 350px; height: 450px;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
    display: none;
    flex-direction: column;
    overflow: hidden;
    z-index: 1002;
}
#chatbot-box.active { display: flex; animation: popIn 0.3s ease; }
@keyframes popIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
#chatbot-header {
    background: linear-gradient(135deg, #1e3c72, #7e22ce);
    color: white;
    padding: 15px;
    font-weight: bold;
    display: flex; justify-content: space-between; align-items: center;
}
#chatbot-messages {
    flex: 1;
    padding: 10px;
    overflow-y: auto;
    font-size: 14px;
}
#chatbot-input-area {
    display: flex;
    border-top: 1px solid #ddd;
}
#chatbot-input {
    flex: 1; border: none; padding: 10px; outline: none;
}
#chatbot-input-area button {
    background: #1e3c72; color: white; border: none;
    padding: 10px 15px; cursor: pointer;
}
.chat-msg { margin: 8px 0; }
.user-msg { text-align: right; color: #1e3c72; font-weight: 600; }
.bot-msg { text-align: left; color: #333; }
    </style>