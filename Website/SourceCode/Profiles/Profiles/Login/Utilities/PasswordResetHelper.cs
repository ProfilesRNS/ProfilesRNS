using Profiles.Framework.Utilities;
using Profiles.Login.Objects;
using System;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Security.Cryptography;

namespace Profiles.Login.Utilities
{
    public class PasswordResetHelper
    {
        /* Settings */
        private string fromAddressString;
        private string fromNameString;
        private string smtpHostString;
        private string passwordResetSubjectString;
        private int smtpPort = 0;
        private string passwordResetExpireTimeHoursString = string.Empty;
        private int passwordResetExpireTimeHours = 0;
        private string passwordResetResendRequestsAllowedString = string.Empty;
        private int passwordResetResendRequestAllowed = 0;

        /* Valid string used for creation of unique reset string. */
        private const string validRandomStringCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";

        /// <summary>
        /// Constructor, throws if configuration is invalid or incomplete. 
        /// </summary>
        public PasswordResetHelper()
        {
            /* Get required email settings from config */
            this.fromAddressString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_FROM_ADDR_SETTING];
            this.fromNameString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_FROM_NAME_SETTING];
            this.smtpHostString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_HOST_SETTING];
            this.passwordResetSubjectString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_SUBJECT_SETTING];
            this.passwordResetExpireTimeHoursString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_EXPIRE_TIME_HOURS_SETTING];
            this.passwordResetResendRequestsAllowedString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_RESEND_REQUESTS_ALLOWED_SETTING];

            /* Validate configuration, if invalid log error and throw. */
            string smtpPortString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_PORT_SETTING];
            if (string.IsNullOrEmpty(fromAddressString) || string.IsNullOrEmpty(fromNameString) ||
                string.IsNullOrEmpty(smtpPortString) || string.IsNullOrEmpty(smtpHostString) || 
                string.IsNullOrEmpty(passwordResetExpireTimeHoursString) || 
                string.IsNullOrEmpty(passwordResetResendRequestsAllowedString))
            {
                /* Incomplete reset email configuration */
                string errorMessage = "PasswordReset.FromAddress,  PasswordReset.FromName, PasswordReset.SmtpPort, PasswordReset.SmtpHost, PasswordReset.ExpireTime.Hours, and PasswordReset.ResendRequests.Allowed must be configured.  Email send failed.";
                DebugLogging.Log(errorMessage);
                throw new Exception(errorMessage);
            }
            else
            {
                /* Parse the smtp port setting to int. */
                bool parseSmtpPortSuccess = int.TryParse(smtpPortString, out smtpPort);
                if (!parseSmtpPortSuccess)
                {
                    /* SMTP Port invalid, not convertible to int. */
                    string errorMessage = "Invalid smtp port configured [" + smtpPortString + "].  Email send failed.";
                    DebugLogging.Log(errorMessage);
                    throw new Exception(errorMessage);
                }

                /* Parse the password reset request expire time setting to int. */
                bool passwordResetExpireTimeSuccess = int.TryParse(passwordResetExpireTimeHoursString, out passwordResetExpireTimeHours);
                if (!passwordResetExpireTimeSuccess)
                {
                    /* Time configured not valid, not convertible to int. */
                    string errorMessage = "Invalid password reset expire time configured [" + passwordResetExpireTimeHoursString + "].  Email send failed.";
                    DebugLogging.Log(errorMessage);
                    throw new Exception(errorMessage);
                }

                /* Parse the password reset request expire time setting to int. */
                bool passwordResetResendRequestAllowedSuccess = int.TryParse(passwordResetResendRequestsAllowedString, out passwordResetResendRequestAllowed);
                if (!passwordResetResendRequestAllowedSuccess)
                {
                    /* Time configured not valid, not convertible to int. */
                    string errorMessage = "Invalid password resend request allowed configured [" + passwordResetResendRequestsAllowedString + "].  Email send failed.";
                    DebugLogging.Log(errorMessage);
                    throw new Exception(errorMessage);
                }
            }
        }


        public PasswordResetRequest GeneratePasswordResetRequest(string emailToAddress)
        {
            PasswordResetRequest passwordResetRequest = new PasswordResetRequest() { EmailAddr = emailToAddress };

            try
            {
                /* Generate random string to be used as a token. */
                passwordResetRequest.ResetToken = GetRandomString(PasswordResetConst.RESET_TOKEN_LENGTH);

                /* Set the expire time. */
                passwordResetRequest.RequestExpireDate = DateTime.Now.AddHours(this.passwordResetExpireTimeHours);

                /* Set the reset resent requests allowed to the starting value configured. */
                passwordResetRequest.ResendRequestsRemaining = this.passwordResetResendRequestAllowed;

                /* Create the actual request row in the database. */
                DataIO data = new DataIO();
                bool requestCreateSuccess = data.CreatePasswordResetRequest(passwordResetRequest);

                /* Make sure request was successfully created, if not return a null reset object. */
                if (!requestCreateSuccess)
                {
                    passwordResetRequest = null;
                }
            }
            catch (Exception e)
            {
                passwordResetRequest = null;
                string errorMessage = "Unable to configure reset email template.  Email send failed.";
                DebugLogging.Log(errorMessage + e.Message + e.StackTrace);
                throw new Exception(errorMessage);
            }

            return passwordResetRequest;
        }

        public PasswordResetRequest GetPasswordResetRequestByEmail(string emailAddress)
        {
            DataIO data = new DataIO();

            return data.GetPasswordResetRequestByEmail(emailAddress);
        }

        public PasswordResetRequest GetPasswordResetRequestByToken(string resetToken)
        {
            DataIO data = new DataIO();

            return data.GetPasswordResetRequestByToken(resetToken);
        }

        public bool SendResetEmail(PasswordResetRequest passwordResetRequest)
        {
            
            bool returnFlag = false;
            try
            {
                /* Read the email template and plug in the domain and token for reset. */
                string emailBody = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Login/EmailTemplate/ResetEmailTemplate.html");
                emailBody = emailBody.Replace("[url_domain]", Root.Domain);
                emailBody = emailBody.Replace("[reset_token]", passwordResetRequest.ResetToken);

                /* Generate the email and send it. */
                MailAddress fromMailAddress = new MailAddress(fromAddressString, fromNameString);
                MailAddress toMailAddress = new MailAddress(passwordResetRequest.EmailAddr);
                SmtpClient client = new SmtpClient(smtpHostString);
                client.Port = smtpPort;
                client.Credentials = new System.Net.NetworkCredential("", "");
                MailMessage mailMessage = new MailMessage(fromMailAddress, toMailAddress);
                mailMessage.Subject = passwordResetSubjectString;
                mailMessage.Body = emailBody;
                mailMessage.IsBodyHtml = true;
                client.Send(mailMessage);
                returnFlag = true;
            }
            catch (Exception e)
            {
                DebugLogging.Log(e.Message + e.StackTrace);
                throw;
            }

            return returnFlag;
        }

        public bool ResendResetEmail(PasswordResetRequest passwordResetRequest)
        {
            /* Decrement the number of resends that can be performed. */
            passwordResetRequest.ResendRequestsRemaining = passwordResetRequest.ResendRequestsRemaining - 1;

            /* Update the request record. */
            DataIO data = new DataIO();
            data.UpdatePasswordResetRequest(passwordResetRequest.ResetToken, passwordResetRequest.ResendRequestsRemaining);

            /* Resend the email. */
            return SendResetEmail(passwordResetRequest);
        }

        public bool ResetPassword(string resetToken, string newPassword)
        {
            DataIO data = new DataIO();
            bool resetSuccessful = data.ResetPassword(resetToken, newPassword);
            return resetSuccessful;
        }

        /// <summary>
        /// Generate a random string used for password reset.  This is a bit innefficient because the crypto 
        /// provider returns values that don't equate to valid strings which we skip.  For our purposes it should 
        /// be fine though.
        /// </summary>
        /// <param name="length">Length of string to return.</param>
        /// <returns>Randomely generated string</returns>
        private string GetRandomString(int length)
        {
            string returnString = "";
            using (RNGCryptoServiceProvider rngCryptoServiceProvider = new RNGCryptoServiceProvider())
            {
                while (returnString.Length != length)
                {
                    byte[] oneByte = new byte[1];
                    rngCryptoServiceProvider.GetBytes(oneByte);
                    char character = (char)oneByte[0];
                    if (validRandomStringCharacters.Contains(character))
                    {
                        returnString += character;
                    }
                }
            }
            return returnString;
        }
    }
}