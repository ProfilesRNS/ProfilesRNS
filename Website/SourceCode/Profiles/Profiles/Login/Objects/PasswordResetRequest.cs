using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Profiles.Login.Objects
{
    public class PasswordResetRequest
    {
        public PasswordResetRequest(string emailAddr)
        {
            this.EmailAddr = emailAddr;
        }

        public int PasswordResetRequestID
        {
            get;
            set;
        }

        public string ResetToken
        {
            get;
            set;
        }

        public string EmailAddr
        {
            get;
            set;
        }

        public DateTime CreateDate
        {
            get;
            set;
        }

        public DateTime RequestExpireDate
        {
            get;
            set;
        }

        public int ResendRequestsRemaining
        {
            get;
            set;
        }

        public DateTime ResetDate
        {
            get;
            set;
        }
    }
}