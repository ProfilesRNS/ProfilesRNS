using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Application
    {
        public static string Get(string queryStringParamName)
        {
            if (System.Web.HttpContext.Current.Application[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Application[queryStringParamName].ToString() != string.Empty)
                {
                    return System.Web.HttpContext.Current.Application[queryStringParamName].ToString();
                }
            }
            return string.Empty;
        }
        public static int GetInt(string queryStringParamName)
        {
            int returnInt = 0;
            if (System.Web.HttpContext.Current.Application[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Application[queryStringParamName].ToString() != string.Empty)
                {
                    int.TryParse(System.Web.HttpContext.Current.Application[queryStringParamName].ToString(), out returnInt);
                }
            }
            return returnInt;
        }
    }
}
