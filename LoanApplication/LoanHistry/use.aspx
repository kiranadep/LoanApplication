<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="userlogin.aspx.cs" Inherits="LoanApplication.LoanHistry.userlogin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <div>
    <h1>Admin Page</h1>
    <form action=" userlogindb.aspx" method="post">
      <div class="form-group">
        <label for="username">Admin Username</label>
        <input type="text" id="username" name="t1" />
      </div>
      <div class="form-group">
        <label for="password">Admin Password</label>
        <input type="password" id="password" name="t2" />
      </div>
        <button type="submit" class="btn-login">Login</button>
    </form>
   </div>
</body>
</html>

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
    }
    input[type="text"],
    input[type="password"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 16px;
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
  </style>