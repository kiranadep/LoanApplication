<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/AdminDashboard.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="LoanApplication.Admin.Logout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="logout-container">
        <div class="logout-card">
            <div class="logout-icon">
                <span>⏻</span>
            </div>
            <h2>Logout Confirmation</h2>
            <p>Are you sure you want to logout from the Admin Panel?</p>
            
            <div class="logout-buttons">
                <asp:Button ID="btnConfirmLogout" runat="server" Text="Yes, Logout" 
                    OnClick="btnConfirmLogout_Click" CssClass="btn-logout-confirm" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                    OnClick="btnCancel_Click" CssClass="btn-cancel" />
            </div>
            
            <div class="logout-info">
                <p><small>You will be redirected to the login page after logout.</small></p>
            </div>
        </div>
    </div>
</asp:Content>