using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Login.Utilities
{
    public class PasswordResetConst
    {
        /* Constant strings for configuration setting names. */
        public const string SMTP_HOST_SETTING = "PasswordReset.Smtp.Host";
        public const string SMTP_PORT_SETTING = "PasswordReset.Smtp.Port";
        public const string SMTP_USERNAME_SETTING = "PasswordReset.Smtp.UserName";
        public const string SMTP_PASSWORD_SETTING = "PasswordReset.Smtp.Password";
        public const string PASSWORD_RESET_FROM_ADDR_SETTING = "PasswordReset.FromAddress";
        public const string PASSWORD_RESET_FROM_NAME_SETTING = "PasswordReset.FromName";
        public const string PASSWORD_RESET_SUBJECT_SETTING = "PasswordReset.Subject";
        public const string PASSWORD_RESET_EXPIRE_TIME_HOURS_SETTING = "PasswordReset.ExpireTime.Hours";
        public const string PASSWORD_RESET_RESEND_REQUESTS_ALLOWED_SETTING = "PasswordReset.ResendRequests.Allowed";

        /* Length of the token that will be generated for the url used to reset the password.  */
        public const int RESET_TOKEN_LENGTH = 255;
    }
}