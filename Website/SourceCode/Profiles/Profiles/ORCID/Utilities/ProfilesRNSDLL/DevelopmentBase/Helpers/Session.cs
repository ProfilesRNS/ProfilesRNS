using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Session
    {
        public static string Get(string queryStringParamName)
        {
            if (System.Web.HttpContext.Current.Session[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Session[queryStringParamName].ToString() != string.Empty)
                {
                    return System.Web.HttpContext.Current.Session[queryStringParamName].ToString();
                }
            }
            return string.Empty;
        }
        public static int GetInt(string queryStringParamName)
        {
            int returnInt = 0;
            if (System.Web.HttpContext.Current.Session[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Session[queryStringParamName].ToString() != string.Empty)
                {
                    int.TryParse(System.Web.HttpContext.Current.Session[queryStringParamName].ToString(), out returnInt);
                }
            }
            return returnInt;
        }
    }
}
