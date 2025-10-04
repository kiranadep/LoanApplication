using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace LoanApplication.Admin
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is authenticated and is admin
            if (!IsUserAuthenticated() || !IsAdminUser())
            {
                RedirectToLogin();
            }
        }

        protected void btnConfirmLogout_Click(object sender, EventArgs e)
        {
            try
            {
                // Clear all session data
                Session.Clear();
                Session.Abandon();
                
                // Clear authentication cookies
                FormsAuthentication.SignOut();
                
                // Clear any custom cookies
                if (Request.Cookies["AdminAuth"] != null)
                {
                    HttpCookie adminCookie = new HttpCookie("AdminAuth");
                    adminCookie.Expires = DateTime.Now.AddDays(-1);
                    adminCookie.Value = "";
                    Response.Cookies.Add(adminCookie);
                }
                
                // Clear any remember me cookies
                if (Request.Cookies["RememberMe"] != null)
                {
                    HttpCookie rememberCookie = new HttpCookie("RememberMe");
                    rememberCookie.Expires = DateTime.Now.AddDays(-1);
                    rememberCookie.Value = "";
                    Response.Cookies.Add(rememberCookie);
                }

                // Add a script to show logout message and redirect
                string script = @"
                    alert('You have been successfully logged out!');
                    window.location.href = '../LoanHistry/userlogindb.aspx';
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "logout", script, true);
            }
            catch (Exception ex)
            {
                // Log the error and show user-friendly message
                string errorScript = "alert('An error occurred during logout. Please try again.');";
                ScriptManager.RegisterStartupScript(this, GetType(), "error", errorScript, true);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // Redirect back to admin dashboard
            Response.Redirect("AdminDashBoard.aspx");
        }

        private bool IsUserAuthenticated()
        {
            // Check if user is logged in via session
            return Session["AdminLoggedIn"] != null && 
                   Convert.ToBoolean(Session["AdminLoggedIn"]) == true;
        }

        private bool IsAdminUser()
        {
            // Check if the logged-in user is an admin
            string userRole = Session["UserRole"] as string;
            return !string.IsNullOrEmpty(userRole) && userRole.Equals("Admin", StringComparison.OrdinalIgnoreCase);
        }

        private void RedirectToLogin()
        {
            // Redirect to login page if not authenticated
            Response.Redirect("../LoanHistry/userlogindb.aspx");
        }
    }
}