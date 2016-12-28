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
    public partial class PasswordResetConfirm : System.Web.UI.UserControl
    {
        private string PASSWORD_VALIDATION_EXPRESSION_SETTING = "PasswordReset.PasswordValidation.ValidationExpression";
        private string PASSWORD_VALIDATION_ERROR_MESSAGE_SETTING = "PasswordReset.PasswordValidation.ErrorMessage";

        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string resetToken = Request.QueryString["token"];

                if (!string.IsNullOrEmpty(resetToken) && resetToken.Length == PasswordResetConst.RESET_TOKEN_LENGTH)
                {
                    /* Verify the request token is actually valid. */
                    PasswordResetHelper passwordResetHelper = new PasswordResetHelper();
                    PasswordResetRequest passwordResetRequest = passwordResetHelper.GetPasswordResetRequestByToken(resetToken);

                    if (passwordResetRequest != null && passwordResetRequest.ResendRequestsRemaining > 0)
                    {
                        /* Setup the validator as configured. */
                        string passwordValidationExpression = ConfigurationManager.AppSettings[PASSWORD_VALIDATION_EXPRESSION_SETTING];
                        string passwordValidationErrorMessage = ConfigurationManager.AppSettings[PASSWORD_VALIDATION_ERROR_MESSAGE_SETTING];
                        if (!string.IsNullOrEmpty(passwordValidationExpression) && !string.IsNullOrEmpty(passwordValidationErrorMessage))
                        {
                            this.regexPasswordValidator.ValidationExpression = passwordValidationExpression;
                            this.regexPasswordValidator.ErrorMessage = passwordValidationErrorMessage;
                        }

                        this.txtPassword.Focus();
                    }
                    else
                    {
                        /* Invalid or already used password reset link */
                        InvalidResetRequest();
                    }
                }
                else
                {
                    /* Invalid request, no token or invalid token length. */
                    InvalidResetRequest();
                }
            }
        }

        public PasswordResetConfirm() { }
        public PasswordResetConfirm(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {
            string resetToken = Request.QueryString["token"];
            if (!string.IsNullOrEmpty(resetToken))
            {
                PasswordResetHelper passwordResetHelper = new PasswordResetHelper();
                bool resetSuccessful = passwordResetHelper.ResetPassword(resetToken, this.txtPassword.Text);

                if (resetSuccessful)
                {
                    ResetSuccessful();
                }
                else
                {
                    ResetFailed();
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

        private void InvalidResetRequest()
        {
            this.PanelInvalidResetRequest.Visible = true;
            this.PanelPasswordResetConfirmForm.Visible = false;
            this.PanelPasswordResetFailed.Visible = false;
            this.PanelPasswordResetSuccess.Visible = false;
        }

        private void ResetSuccessful()
        {
            this.PanelInvalidResetRequest.Visible = false;
            this.PanelPasswordResetConfirmForm.Visible = false;
            this.PanelPasswordResetFailed.Visible = false;
            this.PanelPasswordResetSuccess.Visible = true;
        }

        private void ResetFailed()
        {
            this.PanelInvalidResetRequest.Visible = false;
            this.PanelPasswordResetConfirmForm.Visible = false;
            this.PanelPasswordResetFailed.Visible = true;
            this.PanelPasswordResetSuccess.Visible = false;
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

    }
}