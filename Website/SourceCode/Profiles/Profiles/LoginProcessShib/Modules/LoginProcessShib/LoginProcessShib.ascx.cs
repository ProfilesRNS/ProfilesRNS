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

namespace Profiles.LoginProcessShib.Modules
{
    public partial class LoginProcessShib : System.Web.UI.UserControl
    {
        /* Login Method Constants */
        private const string METHOD_LOGOUT = "logout";
        private const string METHOD_SHIBBOLETH = "shibboleth";
        private const string METHOD_LOGIN = "login";

        private ShibAppSettings shibAppSettings = null;

        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            string loggingPrefix = "LoginProcessShib - Page_Load - ";
            ShibUtil.Log(loggingPrefix + "Starting.");

            shibAppSettings = new ShibAppSettings();
            if (shibAppSettings.InitializeAppSettings())
            {
                if (!IsPostBack)
                {
                    string methodQueryStringValue = Request.QueryString["method"].ToString();
                    ShibUtil.Log(loggingPrefix + "methodQueryStringValue - " + methodQueryStringValue);

                    if (methodQueryStringValue == METHOD_SHIBBOLETH)
                    {
                        processShibbolethResponse();
                    }
                }
            }
            else
            {
                ShibUtil.Log(loggingPrefix + " One or more required configuration parameters are missing.  Required settings are: " + shibAppSettings.RequiredSettingsString);
                this.cmdProceedToSearch.Visible = false;
                this.lblError.Text = "Single sign-on configuration incomplete.  Contact your administrator.";
            }
        }

        private void processShibbolethResponse()
        {
            string loggingPrefix = "LoginProcessShib - Method processShibbolethResponse - ";
            ShibUtil.Log(loggingPrefix + "Starting");

            /* Temp logging of headers */
            var headers = String.Empty;
            foreach (var key in Request.Headers.AllKeys)
            {
                headers += key + "=" + Request.Headers[key] + Environment.NewLine;
            }
            ShibUtil.Log(loggingPrefix + " headers - " + headers);

            /* Temp logging of Request.Form */
            string keysAndFormValues = String.Empty;
            foreach (string key in Request.Form.Keys)
            {
                keysAndFormValues += key + ": " + Request.Form[key] + " | ";
            }
            ShibUtil.Log(loggingPrefix + "keys and form values - " + keysAndFormValues);

            // added by Eric
            // If they specify an Idp, then check that they logged in from the configured IDP
            bool authenticated = false;

            ShibUtil.Log(loggingPrefix + "ShibIdentityProvider from Request.Headers.Get:  " + Request.Headers.Get("ShibIdentityProvider"));

            if (shibAppSettings.ShibIdentityProviderAppSettingValue == null ||
                shibAppSettings.ShibIdentityProviderAppSettingValue.ToString().Equals(Request.Headers.Get("ShibIdentityProvider").ToString(), StringComparison.InvariantCultureIgnoreCase))
            {

                ShibUtil.Log(loggingPrefix + "Authenticated check header " + Request.Headers.Get(shibAppSettings.ShibUsernameHeaderAppSettingValue));
                ShibUtil.Log(loggingPrefix + "Authenticated check request " + Request[shibAppSettings.ShibUsernameHeaderAppSettingValue]);
                String userName = Request[shibAppSettings.ShibUsernameHeaderAppSettingValue].ToString(); //"025693078";

                if (!string.IsNullOrEmpty(userName))
                {
                    Login.Utilities.DataIO data = new Login.Utilities.DataIO();
                    User user = new User();

                    user.UserName = userName;
                    ShibUtil.Log(loggingPrefix + "Calling - data.UserLoginExternal with userName: " + userName);
                    if (data.UserLoginExternal(ref user))
                    {
                        ShibUtil.Log(loggingPrefix + "Authenticated with profile access " + Request[shibAppSettings.ShibUsernameHeaderAppSettingValue].ToString());
                        authenticated = true;
                    }
                    else
                    {
                        ShibUtil.Log(loggingPrefix + "Authenticated no profile access " + Request[shibAppSettings.ShibUsernameHeaderAppSettingValue].ToString());
                        authenticated = false;
                    }
                }
            }
            if (!authenticated)
            {
                this.panelLoginSuccessful.Visible = false;
                this.panelLoginFailed.Visible = true;
                this.cmdProceedToSearch.Visible = false;
            }
            else
            {
                this.panelLoginSuccessful.Visible = true;
                this.panelLoginFailed.Visible = false;
                this.cmdProceedToSearch.Visible = true;
            }
        }

        /// <summary>
        /// Logout of Shibboleth.  If a logout URL has been configured redirect to that.  Otherwise just redirect to the 
        /// redirect url passed in the querystring. 
        /// </summary>
        private void logoutFromShibboleth()
        {
            string loggingPrefix = "LoginProcessShib - Function logoutFromShibboleth - ";
            ShibUtil.Log(loggingPrefix + " Starting.");

            var redirect = "return=" + Root.Domain + "/login/default.aspx?method=shiblogoutsuccess";

            ShibUtil.Log(loggingPrefix + "- logouturl  " + shibAppSettings.ShibLogoutUrlAppSettingValue + HttpUtility.UrlEncode(redirect));

            Response.Redirect(shibAppSettings.ShibLogoutUrlAppSettingValue + HttpUtility.UrlEncode(redirect));

        }

        public LoginProcessShib() { }

        public LoginProcessShib(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            string loggingPrefix = "LoginProcessShib - Function LoginProcessShib (Constructor) - ";
            ShibUtil.Log(loggingPrefix + " Starting.");

            sm = new SessionManagement();

        }

        protected void cmdProceedToSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect(Root.Domain + "/search");
        }
    }
}