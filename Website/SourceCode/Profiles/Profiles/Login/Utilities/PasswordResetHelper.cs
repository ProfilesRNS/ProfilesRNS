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
        /* Variables to hold settings values. */
        private string fromAddressString;
        private string fromNameString;
        private string smtpHostString;
        private string smtpUserNameString;
        private string smtpPasswordString;
        private string passwordResetSubjectString;
        private int smtpPort = 0;
        private string passwordResetExpireTimeHoursString;
        private int passwordResetExpireTimeHours = 0;
        private string passwordResetResendRequestsAllowedString;
        private int passwordResetResendRequestAllowed = 0;

        /* Valid string used for creation of unique reset string. */
        private const string validRandomStringCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";

        /* Data IO Object */
        DataIO data;

        /// <summary>
        /// Constructor, throws if configuration is invalid or incomplete. 
        /// </summary>
        public PasswordResetHelper()
        {
            /* Get required email settings from config */
            this.fromAddressString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_FROM_ADDR_SETTING];
            this.fromNameString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_FROM_NAME_SETTING];
            string smtpPortString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_PORT_SETTING];
            this.smtpHostString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_HOST_SETTING];
            this.smtpUserNameString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_USERNAME_SETTING];
            this.smtpPasswordString = ConfigurationManager.AppSettings[PasswordResetConst.SMTP_PASSWORD_SETTING];
            this.passwordResetSubjectString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_SUBJECT_SETTING];
            this.passwordResetExpireTimeHoursString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_EXPIRE_TIME_HOURS_SETTING];
            this.passwordResetResendRequestsAllowedString = ConfigurationManager.AppSettings[PasswordResetConst.PASSWORD_RESET_RESEND_REQUESTS_ALLOWED_SETTING];        
            

            /* Validate configuration, if invalid log error and throw. */
            if (string.IsNullOrEmpty(fromAddressString) || string.IsNullOrEmpty(fromNameString) ||
                string.IsNullOrEmpty(smtpPortString) || string.IsNullOrEmpty(smtpHostString) || 
                string.IsNullOrEmpty(passwordResetSubjectString) || string.IsNullOrEmpty(passwordResetExpireTimeHoursString) ||
                string.IsNullOrEmpty(passwordResetResendRequestsAllowedString))
            {
                /* Incomplete reset email configuration */
                string errorMessage = "PasswordReset.FromAddress, PasswordReset.FromName, PasswordReset.SmtpPort, PasswordReset.SmtpHost, PasswordReset.Subject, PasswordReset.ExpireTime.Hours, and PasswordReset.ResendRequests.Allowed must be configured.  Email send failed.";
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
                    string errorMessage = "Invalid smtp port configured [" + smtpPortString + "].  Valid PasswordReset.SmtpPort required. Email send failed.";
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

                data = new DataIO();
            }
        }

        /// <summary>
        /// Generate a password reset request using the email address passed. 
        /// </summary>
        /// <param name="emailToAddress">Email address associated with account for which we want to generate a reset request.</param>
        /// <returns>Populated PasswordResetRequest object if creation is successful.  Otherwise, a null object is returned.</returns>
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

        /// <summary>
        /// Get the PasswordResetRequest object associated with the email address passed.  Request must be not 
        /// expired or previously have been used to reset.
        /// </summary>
        /// <param name="emailAddress">Email address associated with the account to reset.</param>
        /// <returns>Populated PasswordResetRequest object if successful, otherwise object returned will be null.</returns>
        public PasswordResetRequest GetPasswordResetRequestByEmail(string emailAddress)
        {
            PasswordResetRequest passwordResetRequest = null;

            try
            {
                passwordResetRequest = data.GetPasswordResetRequestByEmail(emailAddress);
            }
            catch (Exception e)
            {
                passwordResetRequest = null;
                string errorMessage = "Unable to retrieve password reset request.  Reset failed.";
                DebugLogging.Log(errorMessage + e.Message + e.StackTrace);
                throw new Exception(errorMessage);
            }

            return passwordResetRequest;
        }

        /// <summary>
        /// Get the PasswordResetRequest object associated with the reset token passed.  Request must be not 
        /// expired or previously have been used to reset.
        /// </summary>
        /// <param name="resetToken">Reset token associated with the request.</param>
        /// <returns>Populated PasswordResetRequest object if successful, otherwise object returned will be null.</returns>
        public PasswordResetRequest GetPasswordResetRequestByToken(string resetToken)
        {
            PasswordResetRequest passwordResetRequest = null;

            try
            {
                passwordResetRequest = data.GetPasswordResetRequestByToken(resetToken);
            }
            catch (Exception e)
            {
                passwordResetRequest = null;
                string errorMessage = "Unable to retrieve password reset request.  Reset failed.";
                DebugLogging.Log(errorMessage + e.Message + e.StackTrace);
                throw new Exception(errorMessage);
            }

            return passwordResetRequest;
        }

        /// <summary>
        /// Send a the email for password reset using the PasswordResetRequest object passed.
        /// </summary>
        /// <param name="passwordResetRequest">PasswordResetRequest object containing the email address, token and other information needed
        /// to create the email.</param>
        /// <returns>True if send is successful, otherwise returns False.</returns>
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
                client.Credentials = new System.Net.NetworkCredential(this.smtpUserNameString, this.smtpPasswordString);
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

        /// <summary>
        /// Resend the email for password reset using the PasswordResetRequest object passed.
        /// </summary>
        /// <param name="passwordResetRequest">PasswordResetRequest object containing the email address, token and other information needed
        /// to create the email.</param>
        /// <returns>True if send is successful, otherwise returns False.</returns>
        public bool ResendResetEmail(PasswordResetRequest passwordResetRequest)
        {
            bool resetSuccessful = false;

            try
            {
                /* Decrement the number of resends that can be performed. */
                passwordResetRequest.ResendRequestsRemaining = passwordResetRequest.ResendRequestsRemaining - 1;

                /* Update the request record. */
                data.UpdatePasswordResetRequestRequestsRemaining(passwordResetRequest.ResetToken, passwordResetRequest.ResendRequestsRemaining);

                /* Resend the email. */
                resetSuccessful = SendResetEmail(passwordResetRequest);
            }
            catch (Exception e)
            {
                DebugLogging.Log(e.Message + e.StackTrace);
                throw;
            }

            return resetSuccessful;
        }

        /// <summary>
        /// Reset the password using the PasswordReset entry associated with the token passed.  
        /// </summary>
        /// <param name="resetToken">Password reset token associated with the request to use for reset.</param>
        /// <param name="newPassword">Password that will be used for all accounts associated with the email address in the 
        /// reset request.</param>
        /// <returns>True if send is successful, otherwise returns False.</returns>
        public bool ResetPassword(string resetToken, string newPassword)
        {
            bool resetSuccessful = false;
            try
            {
                resetSuccessful = data.ResetPassword(resetToken, newPassword);
            }
            catch (Exception e)
            {
                DebugLogging.Log(e.Message + e.StackTrace);
                throw;
            }
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

        public SimpleMathEquationAndAnswer GetRandomMathEquationAndAnswer()
        {
            SimpleMathEquationAndAnswer simpleMathEquationAndAnswer = new SimpleMathEquationAndAnswer();
            Random random = new Random();
            int operator1 = random.Next(1, 9);
            int operator2 = random.Next(1, 9);
            int coinFlip = random.Next(0, 2);

            /* Use simple coinflip for whether we do plus or minus, also make sure operator 1 is larger than 2 if doing subtraction. */
            if (coinFlip > 0 && operator1 >= operator2)
            {
                simpleMathEquationAndAnswer.QuestionText = string.Format("What is {0} minus {1}?", operator1, operator2);
                simpleMathEquationAndAnswer.Answer = operator1 - operator2;
            }
            else
            {
                simpleMathEquationAndAnswer.QuestionText = string.Format("What is {0} plus {1}?", operator1, operator2);
                simpleMathEquationAndAnswer.Answer = operator1 + operator2;
            }
            return simpleMathEquationAndAnswer;
        }
    }
}