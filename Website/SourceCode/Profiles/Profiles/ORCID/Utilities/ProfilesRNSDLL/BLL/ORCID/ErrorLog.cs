using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID
{
    public partial class ErrorLog 
    {
        public static int LogError(Exception ex, string internalUsername)
        {
            BO.ORCID.ErrorLog bo = new BO.ORCID.ErrorLog();
            bo.Exception = GetExceptionDetails(ex);
            if (!string.IsNullOrEmpty(internalUsername))
            {
                bo.InternalUsername = internalUsername;
            }
            bo.OccurredOn = DateTime.Now;
            bo.Processed = false;
            try
            {
                new BLL.ORCID.ErrorLog().Add(bo);
                return bo.ErrorLogID;
            }
            catch // (Exception ex2)
            {
                // just move along as the logging of errors is failing.
                return 0;
            }
        }

        internal static DevelopmentBase.BO.ExceptionSafeToDisplay LogError(Exception ex, string internalUsername, string friendlyMessage)
        {
            try
            {
                int errorID = LogError(ex, internalUsername);
                if (ex.GetType().IsAssignableFrom(typeof(DevelopmentBase.BO.ExceptionSafeToDisplay)))
                {
                    return (DevelopmentBase.BO.ExceptionSafeToDisplay)ex;
                }
                else
                {
                    return new DevelopmentBase.BO.ExceptionSafeToDisplay(errorID.ToString() + ": " + friendlyMessage);
                }
            }
            catch // (Exception ex2)
            { 
                // just move along as the logging of errors is failing.
                return new DevelopmentBase.BO.ExceptionSafeToDisplay(friendlyMessage);
            }
        }

        private static string GetExceptionDetails(Exception ex)
        {
            string exceptionDetails = string.Empty;
            if (ex.GetType().IsAssignableFrom(typeof(System.Net.WebException)))
            {
                System.Net.WebException en = (System.Net.WebException)ex;
                exceptionDetails += ex.Message + Environment.NewLine;
                using (WebResponse response = en.Response)
                {
                    HttpWebResponse httpResponse = (HttpWebResponse)response;
                    exceptionDetails += string.Format("Error code: {0}", httpResponse.StatusCode) + Environment.NewLine;
                    using (Stream data = response.GetResponseStream())
                    {
                        exceptionDetails += new StreamReader(data).ReadToEnd();
                    }
                }
            }
            else
            {
                exceptionDetails += ex.Message;
            }
            if (ex.InnerException != null)
            {
                exceptionDetails += " (Inner Exception: " + GetExceptionDetails(ex.InnerException) + ") ";
            }
            return exceptionDetails;
        }
    }
}
