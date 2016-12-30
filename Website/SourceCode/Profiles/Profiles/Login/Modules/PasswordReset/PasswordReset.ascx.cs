using Profiles.Framework.Utilities;
using Profiles.Login.Objects;
using Profiles.Login.Utilities;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;

namespace Profiles.Login.Modules.PasswordReset
{
    public partial class PasswordReset : System.Web.UI.UserControl
    {
        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtEmailAddress.Focus();

                PasswordResetHelper passwordResetHelper = new PasswordResetHelper();
                SimpleMathEquasionAndAnswer simpleMathEquasionAndAnswer = passwordResetHelper.GetRandomMathEquationAndAnswer();
                /* Tried to hold these with viewstate but no matter what I tried it wouldn't work so using sessions. */
                Session["SimpleMathAnswer"] = simpleMathEquasionAndAnswer.Answer;
                Session["SimpleMathQuestion"] = simpleMathEquasionAndAnswer.QuestionText;
            }
            
            this.lblSimpleMathQuestion.Text = Session["SimpleMathQuestion"].ToString();

        }

        public PasswordReset() { }
        public PasswordReset(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
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
            if (simpleMathAnswerCorrect())
            {
                // Get the email address entered by the user.
                string resetEmailText = txtEmailAddress.Text;
                if (!string.IsNullOrEmpty(resetEmailText))
                {
                    HandleResetRequest(resetEmailText);
                }
            }
            else
            {
                lblError.Text = "Please enter the correct answer to the simple math question.";
                lblError.Visible = true;
                this.txtSimpleMathAnswer.Text = string.Empty;
            }

        }

        private bool simpleMathAnswerCorrect()
        {
            bool simpleMathAnswerCorrect = false;
            if (Session["SimpleMathAnswer"] != null)
            {
                int simpleMathAnswerServer = 0;
                bool parseSuccess = int.TryParse(Session["SimpleMathAnswer"].ToString(), out simpleMathAnswerServer);
                if (parseSuccess)
                {
                    int simpleMathAnswerUser = 0;
                    parseSuccess = int.TryParse(this.txtSimpleMathAnswer.Text, out simpleMathAnswerUser);
                    if (parseSuccess)
                    {
                        simpleMathAnswerCorrect = (simpleMathAnswerServer == simpleMathAnswerUser);
                    }
                }
            }
            return simpleMathAnswerCorrect;
        }

        private void HandleResetRequest(string emailAddress)
        {
            /* Create the password reset email object. */
            Utilities.PasswordResetHelper passwordResetHelper = new Utilities.PasswordResetHelper();

            /* Get an existing password reset request record of there is one.   A valid request is one that was created in the last 
             * 24 hours and has not been used to reset the password. */
            PasswordResetRequest passwordResetRequest = passwordResetHelper.GetPasswordResetRequestByEmail(emailAddress);

            /* Create or use an existing request */
            if (passwordResetRequest == null)
            {
                /* No request exists so create a reset email object. */
                passwordResetRequest = passwordResetHelper.GeneratePasswordResetRequest(emailAddress);

                /* Create the reset row in the database. */
                if (passwordResetRequest != null)
                {
                    /* Send the reset email to the user's email address. */
                    bool sendSuccess = passwordResetHelper.SendResetEmail(passwordResetRequest);

                    if (sendSuccess)
                    {
                        showSentPanel(emailAddress);
                    }
                    else
                    {
                        showSendErrorPanel();
                    }
                }
                else
                {
                    showSendErrorPanel();
                }

            }
            else
            {
                if (passwordResetRequest.ResendRequestsRemaining > 0)
                {
                    /* Resend the existing request. */
                    bool resendSuccess = passwordResetHelper.ResendResetEmail(passwordResetRequest);
                    if (resendSuccess)
                    {
                        showResentPanel(emailAddress);
                    }
                    else
                    {
                        showSendErrorPanel();
                    }
                }
                else
                {
                    showResentRetryExceededPanel(emailAddress);
                }
            }
        }

        private void showSentPanel(string emailAddress)
        {
            this.lblEmailAddressEmailSent.Text = emailAddress;
            this.PanelPasswordResetForm.Visible = false;
            this.PanelEmailSent.Visible = true;
            this.PanelEmailResent.Visible = false;
            this.PanelEmailSendFailed.Visible = false;
            this.PanelEmailResentRetryExceeded.Visible = false;
        }

        private void showResentPanel(string emailAddress)
        {
            this.lblEmailAddressEmailReSent.Text = emailAddress;
            this.PanelPasswordResetForm.Visible = false;
            this.PanelEmailSent.Visible = false;
            this.PanelEmailResent.Visible = true;
            this.PanelEmailSendFailed.Visible = false;
            this.PanelEmailResentRetryExceeded.Visible = false;
        }
        private void showResentRetryExceededPanel(string emailAddress)
        {
            this.lblEmailAddressEmailReSentRetryExceeded.Text = emailAddress;
            this.PanelPasswordResetForm.Visible = false;
            this.PanelEmailSent.Visible = false;
            this.PanelEmailResent.Visible = false;
            this.PanelEmailSendFailed.Visible = false;
            this.PanelEmailResentRetryExceeded.Visible = true;
        }

        private void showSendErrorPanel()
        {
            this.PanelPasswordResetForm.Visible = false;
            this.PanelEmailSent.Visible = false;
            this.PanelEmailResent.Visible = false;
            this.PanelEmailSendFailed.Visible = true;
            this.PanelEmailResentRetryExceeded.Visible = false;
        }
    }
}