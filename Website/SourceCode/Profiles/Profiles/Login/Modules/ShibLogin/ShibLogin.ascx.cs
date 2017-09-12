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
using System.IO;
using Profiles.Login.Objects;

namespace Profiles.Login.Modules.ShibLogin
{
    public partial class ShibLogin : System.Web.UI.UserControl
    {
        /* Login Method Constants */
        private const string METHOD_LOGOUT = "logout";
        private const string METHOD_LOGIN = "login";
        private const string METHOD_SHIB_LOGOUT_SUCCESS = "shiblogoutsuccess";

        private ShibAppSettings shibAppSettings = null;

        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            string loggingPrefix = "ShibLogin - Page_Load - ";
            ShibUtil.Log(loggingPrefix + "Starting.");

            /* Reset panel states by default */
            this.panelLoginInfo.Visible = true;
            this.panelLoggedOut.Visible = false;
            this.cmdProceedToLogin.Visible = true;
            this.cmdProceedToSearch.Visible = false;

            shibAppSettings = new ShibAppSettings();
            if (shibAppSettings.InitializeAppSettings())
            {
                if (!IsPostBack)
                {
                    string methodQueryStringValue = Request.QueryString["method"].ToString();
                    ShibUtil.Log(loggingPrefix + "methodQueryStringValue - " + methodQueryStringValue);

                    if (methodQueryStringValue == METHOD_LOGOUT)
                    {
                        logoutFromProfilesAndShibboleth();
                    }
                    else if (methodQueryStringValue == METHOD_LOGIN && sm.Session().PersonID > 0)
                    {
                        if (Request.QueryString["redirectto"] == null && Request.QueryString["edit"] == "true")
                        {
                            if (Request.QueryString["editparams"] == null)
                            {
                                Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
                            }
                            else
                            {
                                Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + sm.Session().NodeID + "&" + Request.QueryString["editparams"]);
                            }
                        }
                        else
                            Response.Redirect(Request.QueryString["redirectto"].ToString());
                    }
                    else if (methodQueryStringValue == METHOD_SHIB_LOGOUT_SUCCESS)
                    {
                        /* Show the logged out message and button to go back to search */
                        this.panelLoginInfo.Visible = false;
                        this.panelLoggedOut.Visible = true;
                        this.cmdProceedToLogin.Visible = false;
                        this.cmdProceedToSearch.Visible = true;
                    }
                }
            }
            else
            {
                ShibUtil.Log(loggingPrefix + " One or more required configuration parameters are missing.  Required settings are: " + shibAppSettings.RequiredSettingsString);
                this.cmdProceedToLogin.Visible = false;
                this.lblError.Text = "Single sign-on configuration incomplete.  Contact your administrator.";
            }
        }

        private void beginLoginProcedure()
        {
            string loggingPrefix = "ShibLogin - beginLoginProcedure - ";
            ShibUtil.Log(loggingPrefix + "Starting");

            // see if they already have a login session, if so don't send them to shibboleth
            SessionManagement sm = new SessionManagement();
            String viewerId = sm.Session().PersonURI;
            if (viewerId != null && viewerId.Trim().Length > 0)
            {
                ShibUtil.Log(loggingPrefix + "PersonURI Found - already authenticated.  Showing logged in message.");
                this.panelAlreadyLoggedIn.Visible = true;
                this.panelLoggedOut.Visible = false;
                this.panelLoginInfo.Visible = false;
                this.cmdProceedToLogin.Visible = false;
                this.cmdProceedToSearch.Visible = true;
            }
            else
            {
                ShibUtil.Log(loggingPrefix + " - Redirect to LoginProcessShib to begin login procedure.");

                /* Redirect to the LoginProcessShib page so the authentication will be triggered. */
                Response.Redirect(Root.Domain + "/LoginProcessShib/default.aspx?method=shibboleth");
            }
        }

        /// <summary>
        /// Destroy the Profiles session and redirect to logout from Shibboleth. 
        /// </summary>
        private void logoutFromProfilesAndShibboleth()
        {
            string loggingPrefix = "ShibLogin - Function logoutFromProfilesAndShibboleth";
            ShibUtil.Log(loggingPrefix + " - Starting");

            sm.SessionLogout();
            sm.SessionDestroy();

            logoutFromShibboleth();
        }



        /// <summary>
        /// Logout of Shibboleth.  If a logout URL has been configured redirect to that.  Otherwise just redirect to the 
        /// redirect url passed in the querystring. 
        /// </summary>
        private void logoutFromShibboleth()
        {
            string loggingPrefix = "ShibLogin - Function logoutFromShibboleth - ";
            ShibUtil.Log(loggingPrefix + " Starting.");

            var redirect = "return=" + Root.Domain + "/login/default.aspx?method=shiblogoutsuccess";

            ShibUtil.Log(loggingPrefix + "- logouturl  " + shibAppSettings.ShibLogoutUrlAppSettingValue + HttpUtility.UrlEncode(redirect));

            Response.Redirect(shibAppSettings.ShibLogoutUrlAppSettingValue + HttpUtility.UrlEncode(redirect));

        }

        public ShibLogin() { }
        public ShibLogin(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            string loggingPrefix = "ShibLogin - Function ShibLogin (Constructor) - ";
            ShibUtil.Log(loggingPrefix + " Starting.");

            sm = new SessionManagement();

        }

        protected void cmdProceedToLogin_Click(object sender, EventArgs e)
        {
            beginLoginProcedure();
        }


        protected void cmdProceedToSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect(Root.Domain + "/search");
        }
    }
}