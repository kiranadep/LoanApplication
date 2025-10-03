<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userview.aspx.cs" Inherits="LoanApplication.Loans.userview" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Loan Services - Apply Now</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 50%, #7e22ce 100%);
            min-height: 100vh;
        }
        
        /* Header Styles */
        .header {
            background: rgba(255, 255, 255, 0.95);
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .logo {
            font-size: 28px;
            font-weight: bold;
            background: linear-gradient(135deg, #1e3c72, #7e22ce);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        .auth-buttons {
            display: flex;
            gap: 15px;
        }
        .btn-login, .btn-signup {
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s;
        }
        .btn-login {
            background: white;
            color: #1e3c72;
            border: 2px solid #1e3c72;
        }
        .btn-login:hover {
            background: #1e3c72;
            color: white;
        }
        .btn-signup {
            background: linear-gradient(135deg, #1e3c72 0%, #7e22ce 100%);
            color: white;
        }
        .btn-signup:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3);
        }

        /* Hero Section */
        .hero {
            text-align: center;
            padding: 60px 20px;
            color: white;
        }
        .hero h1 {
            font-size: 48px;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .hero p {
            font-size: 20px;
            margin-bottom: 10px;
            opacity: 0.95;
        }

        /* Loan Cards Container */
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 20px;
        }
        .loan-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }
        .loan-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .loan-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, #1e3c72, #7e22ce);
        }
        .loan-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        .loan-icon {
            font-size: 48px;
            margin-bottom: 20px;
        }
        .loan-title {
            font-size: 24px;
            font-weight: bold;
            color: #1e3c72;
            margin-bottom: 15px;
        }
        .loan-summary {
            color: #666;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 20px;
        }
        .learn-more {
            color: #7e22ce;
            font-weight: bold;
            font-size: 14px;
        }

        /* Modal/Popup Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            animation: fadeIn 0.3s;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .modal-content {
            position: relative;
            background: white;
            margin: 50px auto;
            padding: 40px;
            width: 90%;
            max-width: 700px;
            border-radius: 15px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-height: 85vh;
            overflow-y: auto;
            animation: slideDown 0.3s;
        }
        @keyframes slideDown {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .close {
            position: absolute;
            right: 20px;
            top: 20px;
            font-size: 32px;
            font-weight: bold;
            color: #666;
            cursor: pointer;
            transition: color 0.3s;
        }
        .close:hover {
            color: #dc3545;
        }
        .modal-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 3px solid #f0f0f0;
        }
        .modal-icon {
            font-size: 56px;
        }
        .modal-title {
            font-size: 32px;
            color: #1e3c72;
            font-weight: bold;
        }
        .modal-body {
            color: #333;
            line-height: 1.8;
        }
        .feature-list {
            list-style: none;
            margin: 20px 0;
        }
        .feature-list li {
            padding: 12px 0;
            padding-left: 30px;
            position: relative;
            font-size: 15px;
        }
        .feature-list li::before {
            content: '✓';
            position: absolute;
            left: 0;
            color: #28a745;
            font-weight: bold;
            font-size: 18px;
        }
        .highlight-box {
            background: linear-gradient(135deg, #f093fb15 0%, #f5576c15 100%);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
            border-left: 4px solid #7e22ce;
        }
        .highlight-box h3 {
            color: #1e3c72;
            margin-bottom: 10px;
            font-size: 18px;
        }
        .btn-apply {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #1e3c72 0%, #7e22ce 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 25px;
            transition: all 0.3s;
        }
        .btn-apply:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(30, 60, 114, 0.4);
        }
    </style>
</head>
<body>
    <form  id="form1" runat="server">
        <!-- Header with Login/Signup -->
        <div class="header">
            <div class="logo">💰 LoanHub</div>
            <div class="auth-buttons">
                <button type="button" class="btn-login" onclick="window.location.href='login.aspx'">Login</button>
                <button type="button" class="btn-signup" onclick="window.location.href='signup.aspx'">Sign Up</button>
            </div>
        </div>

        <!-- Hero Section -->
        <div class="hero">
            <h1>Find Your Perfect Loan</h1>
            <p>Quick approval • Low interest rates • Flexible terms</p>
        </div>

        <!-- Loan Cards -->
        <div class="container">
            <div class="loan-grid">
                <!-- Personal Loan Card -->
                <div class="loan-card" onclick="openModal('personalLoan')">
                    <div class="loan-icon">👤</div>
                    <div class="loan-title">Personal Loan</div>
                    <div class="loan-summary">
                        Get instant cash for any personal needs. Quick approval with minimal documentation.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>

                <!-- Home Loan Card -->
                <div class="loan-card" onclick="openModal('homeLoan')">
                    <div class="loan-icon">🏠</div>
                    <div class="loan-title">Home Loan</div>
                    <div class="loan-summary">
                        Make your dream home a reality with our flexible home loan plans and competitive rates.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>

                <!-- Car Loan Card -->
                <div class="loan-card" onclick="openModal('carLoan')">
                    <div class="loan-icon">🚗</div>
                    <div class="loan-title">Car Loan</div>
                    <div class="loan-summary">
                        Drive your dream car today with our hassle-free auto loan solutions.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>

                <!-- Education Loan Card -->
                <div class="loan-card" onclick="openModal('educationLoan')">
                    <div class="loan-icon">🎓</div>
                    <div class="loan-title">Education Loan</div>
                    <div class="loan-summary">
                        Invest in your future with our education loans covering tuition and living expenses.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>

                <!-- Business Loan Card -->
                <div class="loan-card" onclick="openModal('businessLoan')">
                    <div class="loan-icon">💼</div>
                    <div class="loan-title">Business Loan</div>
                    <div class="loan-summary">
                        Fuel your business growth with our customized business loan solutions.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>

                <!-- Gold Loan Card -->
                <div class="loan-card" onclick="openModal('goldLoan')">
                    <div class="loan-icon">🥇</div>
                    <div class="loan-title">Gold Loan</div>
                    <div class="loan-summary">
                        Unlock the value of your gold with instant loans at attractive interest rates.
                    </div>
                    <div class="learn-more">Click to learn more →</div>
                </div>
            </div>
        </div>

        <!-- Modal for Personal Loan -->
        <div id="personalLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('personalLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">👤</div>
                    <div class="modal-title">Personal Loan</div>
                </div>
                <div class="modal-body">
                    <p>A personal loan is an unsecured loan that can be used for any personal financial needs. Whether it's a wedding, medical emergency, vacation, or debt consolidation, our personal loans offer quick disbursal and flexible repayment options.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to ₹25 lakhs</li>
                            <li>Interest rates starting from 10.49% p.a.</li>
                            <li>Tenure: 1 to 5 years</li>
                            <li>Minimal documentation required</li>
                            <li>Quick approval within 24-48 hours</li>
                            <li>No collateral needed</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Age: 21 to 60 years</li>
                        <li>Minimum monthly income: ₹20,000</li>
                        <li>Employment: Salaried or self-employed</li>
                        <li>Credit score: 700 or above preferred</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Personal Loan')">Apply Now</button>
                </div>
            </div>
        </div>

        <!-- Modal for Home Loan -->
        <div id="homeLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('homeLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">🏠</div>
                    <div class="modal-title">Home Loan</div>
                </div>
                <div class="modal-body">
                    <p>Our home loans help you purchase your dream house, construct a new property, or renovate your existing home. Enjoy competitive interest rates and flexible repayment tenures of up to 30 years.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to ₹5 crores</li>
                            <li>Interest rates starting from 8.35% p.a.</li>
                            <li>Tenure: Up to 30 years</li>
                            <li>Finance up to 90% of property value</li>
                            <li>Tax benefits under Section 80C and 24(b)</li>
                            <li>Balance transfer facility available</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Age: 21 to 65 years</li>
                        <li>Stable source of income</li>
                        <li>Good credit history</li>
                        <li>Property should be approved by bank</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Home Loan')">Apply Now</button>
                </div>
            </div>
        </div>

        <!-- Modal for Car Loan -->
        <div id="carLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('carLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">🚗</div>
                    <div class="modal-title">Car Loan</div>
                </div>
                <div class="modal-body">
                    <p>Get behind the wheel of your dream car with our attractive car loan options. We finance both new and used cars with competitive interest rates and quick processing.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to ₹1 crore</li>
                            <li>Interest rates starting from 8.70% p.a.</li>
                            <li>Tenure: Up to 7 years</li>
                            <li>Finance up to 90% of car's on-road price</li>
                            <li>Covers both new and used cars</li>
                            <li>Flexible EMI options</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Age: 21 to 65 years</li>
                        <li>Minimum monthly income: ₹25,000</li>
                        <li>Valid driving license</li>
                        <li>Stable employment for at least 1 year</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Car Loan')">Apply Now</button>
                </div>
            </div>
        </div>

        <!-- Modal for Education Loan -->
        <div id="educationLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('educationLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">🎓</div>
                    <div class="modal-title">Education Loan</div>
                </div>
                <div class="modal-body">
                    <p>Pursue your educational dreams without financial constraints. Our education loans cover tuition fees, accommodation, books, and other related expenses for studies in India and abroad.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to ₹1.5 crores</li>
                            <li>Interest rates starting from 9.50% p.a.</li>
                            <li>Tenure: Up to 15 years</li>
                            <li>Covers tuition, living expenses, and equipment</li>
                            <li>Moratorium period during study + 1 year</li>
                            <li>Tax benefits under Section 80E</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Student age: 16 to 35 years</li>
                        <li>Admission to recognized institution</li>
                        <li>Co-applicant (parent/guardian) required</li>
                        <li>Good academic record</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Education Loan')">Apply Now</button>
                </div>
            </div>
        </div>

        <!-- Modal for Business Loan -->
        <div id="businessLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('businessLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">💼</div>
                    <div class="modal-title">Business Loan</div>
                </div>
                <div class="modal-body">
                    <p>Expand your business, purchase equipment, manage working capital, or invest in new opportunities with our flexible business loan solutions tailored for entrepreneurs and enterprises.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to ₹50 lakhs</li>
                            <li>Interest rates starting from 11.00% p.a.</li>
                            <li>Tenure: Up to 5 years</li>
                            <li>Minimal documentation</li>
                            <li>Quick approval within 48 hours</li>
                            <li>Collateral-free for loans up to ₹20 lakhs</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Age: 21 to 65 years</li>
                        <li>Business vintage: Minimum 3 years</li>
                        <li>Annual turnover: Minimum ₹10 lakhs</li>
                        <li>Good credit score and business profile</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Business Loan')">Apply Now</button>
                </div>
            </div>
        </div>

        <!-- Modal for Gold Loan -->
        <div id="goldLoan" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal('goldLoan')">&times;</span>
                <div class="modal-header">
                    <div class="modal-icon">🥇</div>
                    <div class="modal-title">Gold Loan</div>
                </div>
                <div class="modal-body">
                    <p>Get instant liquidity by pledging your gold jewelry or coins. Our gold loans offer the lowest interest rates with the safety and security of your precious gold guaranteed.</p>
                    
                    <div class="highlight-box">
                        <h3>Key Features</h3>
                        <ul class="feature-list">
                            <li>Loan amount up to 75% of gold value</li>
                            <li>Interest rates starting from 7.35% p.a.</li>
                            <li>Tenure: Up to 3 years</li>
                            <li>Instant approval within 30 minutes</li>
                            <li>Safe and secure gold storage</li>
                            <li>Flexible repayment options</li>
                        </ul>
                    </div>

                    <h3 style="color: #1e3c72; margin: 20px 0 10px;">Eligibility Criteria</h3>
                    <ul class="feature-list">
                        <li>Age: 18 years and above</li>
                        <li>Gold purity: Minimum 18 karats</li>
                        <li>Valid ID and address proof</li>
                        <li>Gold ownership proof</li>
                    </ul>

                    <button type="button" class="btn-apply" onclick="applyLoan('Gold Loan')">Apply Now</button>
                </div>
            </div>
        </div>
    </form>

    <script>
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'block';
            document.body.style.overflow = 'hidden';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
            document.body.style.overflow = 'auto';
        }

        function applyLoan(loanType) {
            // Redirect to apply loan page with loan type
            window.location.href = 'Loan.aspx?loanType=' + encodeURIComponent(loanType);
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
                document.body.style.overflow = 'auto';
            }
        }

        // Close modal on Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                var modals = document.getElementsByClassName('modal');
                for (var i = 0; i < modals.length; i++) {
                    modals[i].style.display = 'none';
                }
                document.body.style.overflow = 'auto';
            }
        });
    </script>
</body>
</html>