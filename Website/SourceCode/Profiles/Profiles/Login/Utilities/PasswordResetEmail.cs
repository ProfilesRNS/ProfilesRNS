using Profiles.Framework.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Mail;
using System.Web;

namespace Profiles.Login.Utilities
{
    public class PasswordResetEmail
    {
        private const string SMTP_HOST = "PasswordReset.SmtpHost";
        private const string SMTP_PORT = "PasswordReset.SmtpPort";
        private const string PASSWORD_RESET_FROM_ADDR = "PasswordReset.FromAddress";
        private const string PASSWORD_RESET_FROM_NAME = "PasswordReset.FromName";
        private const string PASSWORD_RESET_SUBJECT = "PasswordReset.Subject";

        private string emailToAddress;
        private string emailBody;

        public PasswordResetEmail(string emailToAddress, string resetToken)
        {
            this.emailToAddress = emailToAddress;

            try
            {
                /* Read the email template and plug in the domain and unique id for reset */
                emailBody = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Login/EmailTemplate/ResetEmailTemplate.html");
                emailBody = emailBody.Replace("[url_domain]", Root.Domain);
                emailBody = emailBody.Replace("[reset_token]", resetToken);
            }
            catch (Exception e)
            {
                string errorMessage = "Unable to configure reset email template.  Email send failed.";
                DebugLogging.Log(errorMessage + e.Message + e.StackTrace);
                throw new Exception(errorMessage);
            }
        }

        public bool Send()
        {
            bool returnFlag = false;
            try
            {
                /* Get required email settings from config */
                string fromAddressString = ConfigurationManager.AppSettings[PASSWORD_RESET_FROM_ADDR];
                string fromNameString = ConfigurationManager.AppSettings[PASSWORD_RESET_FROM_NAME];
                string smtpPortString = ConfigurationManager.AppSettings[SMTP_PORT];
                string smtpHostString = ConfigurationManager.AppSettings[SMTP_HOST];
                string passwordResetSubjectString = ConfigurationManager.AppSettings[PASSWORD_RESET_SUBJECT];

                /* Validate configuration, if invalid log error and throw. */
                int smtpPort = 0;
                if (string.IsNullOrEmpty(fromAddressString) || string.IsNullOrEmpty(fromNameString) ||
                    string.IsNullOrEmpty(smtpPortString) || string.IsNullOrEmpty(smtpHostString))
                {
                    /* Incomplete reset email configuration */
                    string errorMessage = "PasswordReset.FromAddress,  PasswordReset.FromName, PasswordReset.SmtpPort, and PasswordReset.SmtpHost must be configured.  Email send failed.";
                    DebugLogging.Log(errorMessage);
                    throw new Exception(errorMessage);
                }
                else
                {
                    /* Parse the smtp port setting to int */
                    bool parseSmtpPortSuccess = int.TryParse(smtpPortString, out smtpPort);
                    if (!parseSmtpPortSuccess)
                    {
                        /* SMTP Port invalid, not convertible to int. */
                        string errorMessage = "Invalid smtp port configured [" + smtpPortString + "].  Email send failed.";
                        DebugLogging.Log(errorMessage);
                        throw new Exception(errorMessage);

                    }
                    else
                    {
                        MailAddress fromMailAddress = new MailAddress(fromAddressString, fromNameString);
                        MailAddress toMailAddress = new MailAddress(emailToAddress);
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
                }
            }
            catch (Exception e)
            {
                DebugLogging.Log(e.Message + e.StackTrace);
                throw e;
            }

            return returnFlag;
        }
    }
}