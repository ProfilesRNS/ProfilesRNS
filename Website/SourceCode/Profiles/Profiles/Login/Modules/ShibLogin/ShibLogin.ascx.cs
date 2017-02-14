/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Configuration;

using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Login.Modules.ShibLogin
{
    public partial class ShibLogin : System.Web.UI.UserControl
    {
        /* Login Method Constants */
        private const string METHOD_LOGOUT = "logout";
        private const string METHOD_SHIBBOLETH = "shibboleth";
        private const string METHOD_LOGIN = "login";

        /* App Settings Constants */
        private const string APP_SETTING_SHIB_IDENTITY_PROVIDER = "Shibboleth.ShibIdentityProvider";
        private const string APP_SETTING_SHIB_USERNAME_HEADER = "Shibboleth.UserNameHeader";
        private const string APP_SETTING_SHIB_SESSION_ID = "Shibboleth.SessionID";


        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string methodQueryStringValue = Request.QueryString["method"].ToString();

                if (methodQueryStringValue == METHOD_LOGOUT)
                {
                    string loggingPrefix = "Shibboleth - Method Logout";
                    DebugLogging.Log(loggingPrefix + " - Starting");

                    sm.SessionLogout();
                    sm.SessionDestroy();

                    //added by kp to logout from shibboleth
                    LogoutFromShibboleth();
                }
                else if (methodQueryStringValue == METHOD_SHIBBOLETH)
                {
                    string loggingPrefix = "Shibboleth - Method Shibboleth - ";
                    DebugLogging.Log(loggingPrefix + "Starting");

                    // added by Eric
                    // If they specify an Idp, then check that they logged in from the configured IDP
                    bool authenticated = false;

                    string shibIdentityProviderAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_IDENTITY_PROVIDER];
                    string shibUsernameHeaderAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_USERNAME_HEADER].ToString();

                    DebugLogging.Log(loggingPrefix + "ShibIdentityProvider from Request.Headers.Get:  " + Request.Headers.Get("ShibIdentityProvider"));

                    if (shibIdentityProviderAppSettingValue == null ||
                        shibIdentityProviderAppSettingValue.ToString().Equals(Request.Headers.Get("ShibIdentityProvider").ToString(), StringComparison.InvariantCultureIgnoreCase))
                    {

                        DebugLogging.Log(loggingPrefix + "Authenticated check header " + Request.Headers.Get(shibUsernameHeaderAppSettingValue));
                        DebugLogging.Log(loggingPrefix + "Authenticated check request " + Request[shibUsernameHeaderAppSettingValue]);
                        //String userName = Request.Headers.Get(ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"].ToString()); //"025693078";
                        String userName = Request[shibUsernameHeaderAppSettingValue].ToString(); //"025693078";

                        if (!string.IsNullOrEmpty(userName))
                        {
                            Utilities.DataIO data = new Utilities.DataIO();
                            User user = new User();

                            user.UserName = userName;
                            DebugLogging.Log(loggingPrefix + "Calling - data.UserLoginExternal with userName: " + userName);
                            if (data.UserLoginExternal(ref user))
                            {
                                DebugLogging.Log(loggingPrefix + "Authenticated with profile access " + Request[shibUsernameHeaderAppSettingValue].ToString());
                                authenticated = true;
                                RedirectAuthenticatedUser();
                            }
                            else
                            {
                                DebugLogging.Log(loggingPrefix + "Authenticated no profile access " + Request[shibUsernameHeaderAppSettingValue].ToString());
                                authenticated = false;
                                LogoutFromShibboleth();
                            }
                        }
                    }
                    if (!authenticated)
                    {
                        DebugLogging.Log(loggingPrefix + "Not Authenticated");
                        // try and just put their name in the session.
                        //sm.Session().ShortDisplayName = Request.Headers.Get("ShibdisplayName");
                        LogoutFromShibboleth();

                        RedirectAuthenticatedUser();
                    }
                }
                else if (methodQueryStringValue == METHOD_LOGIN)
                {
                    string shibSessionIDrAppSettingValue = ConfigurationManager.AppSettings[APP_SETTING_SHIB_SESSION_ID];

                    string loggingPrefix = "Shibboleth - Method Login - ";
                    DebugLogging.Log(loggingPrefix + "Starting");

                    // see if they already have a login session, if so don't send them to shibboleth
                    SessionManagement sm = new SessionManagement();
                    String viewerId = sm.Session().PersonURI;
                    if (viewerId != null && viewerId.Trim().Length > 0)
                    {
                        DebugLogging.Log(loggingPrefix + "PersonURI Found - already authenticated.  Redirecting.");
                        RedirectAuthenticatedUser();
                    }
                    //added by KP
                    //duplicated shibboleth login code . code was not working as it is in our environment had to modify so login links changed to logout and added extra information to check session id
                    else if (shibSessionIDrAppSettingValue != null && Request[shibSessionIDrAppSettingValue.ToString()] != null && !String.IsNullOrEmpty(Request[shibSessionIDrAppSettingValue.ToString()].ToString()))
                    {
                        DebugLogging.Log(loggingPrefix + "SessionID Exists: " + " - Re-Authenticating");

                        bool authenticated = false;

                        String userName = Request[ConfigurationManager.AppSettings[APP_SETTING_SHIB_USERNAME_HEADER]].ToString(); //"025693078";
                        if (userName != null && userName.Trim().Length > 0)
                        {
                            DebugLogging.Log(loggingPrefix + "login - username " + userName);
                            Utilities.DataIO data = new Utilities.DataIO();
                            User user = new User();

                            user.UserName = userName;
                            DebugLogging.Log(loggingPrefix + "Calling - data.UserLoginExternal with userName: " + userName);
                            if (data.UserLoginExternal(ref user))
                            {
                                DebugLogging.Log(loggingPrefix + "Authenticated with profile access " + userName);
                                authenticated = true;
                                RedirectAuthenticatedUser();
                            }
                            else
                            {
                                DebugLogging.Log(loggingPrefix + "Authenticated no profile access with userName: " + userName);
                            }
                        }
                        if (!authenticated)
                        {
                            DebugLogging.Log(loggingPrefix + " Not Authenticated");

                            //Logout from shibboleth 
                            LogoutFromShibboleth();
                            // try and just put their name in the session.
                            //sm.Session().ShortDisplayName = Request.Headers.Get("ShibdisplayName");
                            RedirectAuthenticatedUser();
                        }
                    }
                    else
                    {
                        DebugLogging.Log(loggingPrefix + " - Redirect");

                        string redirect = Root.Domain + "/login/default.aspx?method=shibboleth";
                        if (Request.QueryString["redirectto"] == null && Request.QueryString["edit"] == "true")
                            redirect += "&edit=true";

                        else
                            redirect += "&redirectto=" + Request.QueryString["redirectto"].ToString();
                        redirect += "&return=" + Request.QueryString["redirectto"].ToString();
                        Response.Redirect(ConfigurationManager.AppSettings["Shibboleth.LoginURL"].ToString().Trim() +
                            HttpUtility.UrlEncode(redirect));
                    }
                }

            }
        }

        private void LogoutFromShibboleth()
        {
            string loggingPrefix = "Shibboleth - Function LogoutFromShibboleth - ";
            DebugLogging.Log(loggingPrefix + " Starting.");

            if (ConfigurationManager.AppSettings["Shibboleth.LogoutURL"] != null)
            {
                var redirect = "return=" + Request.QueryString["redirectto"].ToString();
                var shibbolethlogout = ConfigurationManager.AppSettings["Shibboleth.LogoutURL"].ToString().Trim();


                DebugLogging.Log(loggingPrefix + "- logouturl  " + shibbolethlogout + HttpUtility.UrlEncode(redirect));

                Response.Redirect(shibbolethlogout + HttpUtility.UrlEncode(redirect));
            }
            else
            {
                Response.Redirect(Request.QueryString["redirectto"].ToString());
            }
            lblError.Text = "You currently don't have active faculty account. ";
        }

        private void RedirectAuthenticatedUser()
        {
            string loggingPrefix = "Shibboleth - Function RedirectAuthenticatedUser - ";
            DebugLogging.Log(loggingPrefix + " Starting.");

            DebugLogging.Log(loggingPrefix + "redirectto " + Request.QueryString["redirectto"]);
            DebugLogging.Log(loggingPrefix + "editlink " + Request.QueryString["edit"]);

            if (Request.QueryString["redirectto"] == null && Request.QueryString["edit"] == "true")
            {
                Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
            }
            else if (Request.QueryString["redirectto"] != null)
            {
                if ("mypage".Equals(Request.QueryString["redirectto"].ToLower()))
                {
                    Response.Redirect(Root.Domain + "/profile/" + sm.Session().NodeID);
                }
                else if ("myproxies".Equals(Request.QueryString["redirectto"].ToLower()))
                {
                    Response.Redirect(Root.Domain + "/proxy/default.aspx?subject=" + sm.Session().NodeID);
                }
                else
                {
                    Response.Redirect(Request.QueryString["redirectto"].ToString());
                }
            }

            Response.Redirect(Root.Domain);
        }

        public ShibLogin() { }
        public ShibLogin(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            string loggingPrefix = "Shibboleth - Function ShibLogin (Constructor) - ";
            DebugLogging.Log(loggingPrefix + " Starting.");

            sm = new SessionManagement();

        }

        protected void cmdProceedToLogin_Click(object sender, EventArgs e)
        {

        }
    }
}