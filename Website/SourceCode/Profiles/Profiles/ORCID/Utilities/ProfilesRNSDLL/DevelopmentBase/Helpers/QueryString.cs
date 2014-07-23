using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class QueryString
    {
        public static void SetByQueryString(string queryStringParamName, ref System.Web.UI.WebControls.Label label)
        {
            label.Text = GetQueryString(queryStringParamName);
        }
        public static string GetQueryString(string queryStringParamName)
        {
            if (System.Web.HttpContext.Current.Request.QueryString[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Request.QueryString[queryStringParamName].ToString() != string.Empty)
                {
                    return System.Web.HttpContext.Current.Request.QueryString[queryStringParamName].ToString();
                }
            }
            return string.Empty;
        }
        public static int GetQueryStringInt(string queryStringParamName)
        {
            int returnInt = 0;
            if (System.Web.HttpContext.Current.Request.QueryString[queryStringParamName] != null)
            {
                if (System.Web.HttpContext.Current.Request.QueryString[queryStringParamName].ToString() != string.Empty)
                {
                    int.TryParse(System.Web.HttpContext.Current.Request.QueryString[queryStringParamName].ToString(), out returnInt);
                }
            }
            return returnInt;
        }
    }
}
