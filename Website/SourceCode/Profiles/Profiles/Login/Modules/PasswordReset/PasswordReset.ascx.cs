using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Configuration;

using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;
using Profiles.Login.Objects;

namespace Profiles.Login.Modules.PasswordReset
{
    public partial class PasswordReset : System.Web.UI.UserControl
    {
        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                /*
                if (Request.QueryString["method"].ToString() == "login" && sm.Session().PersonID > 0)
                {
                    if (Request.QueryString["redirectto"] == null && Request.QueryString["edit"] == "true")
                    {
                        if (Request.QueryString["editparams"] == null)
                            Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
                        else
                            Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + sm.Session().NodeID + "&" + Request.QueryString["editparams"]);
                    }
                    else
                        Response.Redirect(Request.QueryString["redirectto"].ToString());
                } */
            } 

        }

        public PasswordReset() { }
        public PasswordReset(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {


            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();

            if (false && Request.QueryString["method"].ToString() == "login")
            {
                Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();
                //user.UserName = txtUserName.Text.Trim();
                //user.Password = txtPassword.Text.Trim();

                if (data.UserLogin(ref user))
                {
                    if (Request.QueryString["edit"] == "true")
                        if (Request.QueryString["editparams"] == null)
                            Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
                        else
                            Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + sm.Session().NodeID + "&" + Request.QueryString["editparams"]);
                    else
                        Response.Redirect(Request.QueryString["redirectto"].ToString());

                }
                else
                {
                    lblError.Text = "Login failed, please try again";
                    //txtPassword.Text = "";
                    //txtPassword.Focus();
                }





            }

        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

            // Inject script into HEADER
            Literal script = new Literal();
            script.Text = "<script>var _path = \"" + Root.Domain + "\";</script>";
            Page.Header.Controls.Add(script);
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        protected void cmdSendResetEmail_Click(object sender, EventArgs e)
        {
            string resetEmailText = txtEmailAddress.Text;
            if (!string.IsNullOrEmpty(resetEmailText))
            {
                /* Get the email address the user entered. */
                string emailAddress = txtEmailAddress.Text.Trim();

                /* Create the password reset email object. */
                Utilities.PasswordReset passwordResetEmail = new Utilities.PasswordReset();

                /* Determine whether a reset request already exists. */
                PasswordResetRequest passwordResetRequest = passwordResetEmail.GetPasswordResetRequest(emailAddress);

                /* Create or use an existing request */
                if (passwordResetRequest == null)
                {
                    /* No request exists so create a reset email object. */
                    passwordResetRequest = passwordResetEmail.GeneratePasswordResetRequest(emailAddress);

                    /* Create the reset row in the database. */
                    if (passwordResetRequest != null)
                    {
                        /* Send the reset email to the user's email address. */
                        bool sendSuccess = passwordResetEmail.Send(passwordResetRequest);

                        if (sendSuccess)
                        {
                            this.lblError.Text = "A password reset email will be sent to the specified account.";
                        }
                        else
                        {
                            this.lblError.Text = "Unable to send reset request, please contact your administrator.";
                        }
                    }
                    else
                    {
                        this.lblError.Text = "The email address entered has no account associated valid for reset.";
                    }

                }
                else
                {
                    /* Resend the existing request. */
                    bool resendSuccess = passwordResetEmail.Resend(passwordResetRequest);
                    if (resendSuccess)
                    {
                        this.lblError.Text = "Existing reset request has been resent, if not received please check your spam folder.";
                    }
                    else
                    {
                        this.lblError.Text = "An existing reset request was found but could not be resent.  Please contact your administrator.";
                    }
                }

            }
        }
    }
}