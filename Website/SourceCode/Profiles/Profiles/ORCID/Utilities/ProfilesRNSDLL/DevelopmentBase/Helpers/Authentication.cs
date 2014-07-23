using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Profiles.ORCID.Utilities.ProfilesRNSDLL.DevelopmentBase.Helpers
{
    public class Authentication
    {
        public static int PersonID
        {
            get
            {
                int personID = 0;
                if (System.Web.HttpContext.Current != null)
                {
                    if (System.Web.HttpContext.Current.Session["PersonID"] != null)
                    {
                        int.TryParse(System.Web.HttpContext.Current.Session["PersonID"].ToString(), out personID);
                    }
                }
                if (personID.Equals(0))
                {
                    return LoggedInPersonID;
                }
                return personID;
            }
        }
        public static int LoggedInPersonID
        {
            get
            {
                int loggedInUser = 0;
                if (System.Web.HttpContext.Current != null)
                {
                    if (System.Web.HttpContext.Current.User.Identity.Name != null)
                    {
                        int.TryParse(System.Web.HttpContext.Current.User.Identity.Name.ToString(), out loggedInUser);
                    }
                }
                return loggedInUser;
            }
        }
        public static string LoggedInBUID
        {
            get
            {
                if (System.Web.HttpContext.Current != null)
                {
                    if (System.Web.HttpContext.Current.Session["LoggedInBUID"] != null)
                    {
                        return System.Web.HttpContext.Current.Session["LoggedInBUID"].ToString();
                    }
                }
                return string.Empty;
            }
        }
    }
}
