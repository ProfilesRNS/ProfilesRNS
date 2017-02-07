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
        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                if (Request.QueryString["method"].ToString() == "logout")
                {

                    sm.SessionLogout();
                    sm.SessionDestroy();

                    //added by kp to logout from shibboleth
                    LogoutFromShibboleth();


                   
                }
                else if (Request.QueryString["method"].ToString() == "shibboleth")
                {
                    // added by Eric
                    // If they specify an Idp, then check that they logged in from the configured IDP
                    bool authenticated = false;
                    if (ConfigurationManager.AppSettings["Shibboleth.ShibIdentityProvider"] == null ||
                        ConfigurationManager.AppSettings["Shibboleth.ShibIdentityProvider"].ToString().Equals(Request.Headers.Get("ShibIdentityProvider").ToString(), StringComparison.InvariantCultureIgnoreCase))
                    {

                        Framework.Utilities.DebugLogging.Log("Shiboleth - autheticated check header " + Request.Headers.Get(ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"].ToString()));
                        Framework.Utilities.DebugLogging.Log("Shibboleth - autheticated check request " + Request[ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"]].ToString());
                        //String userName = Request.Headers.Get(ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"].ToString()); //"025693078";
                        String userName = Request[ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"]].ToString(); //"025693078";

                        if (userName != null && userName.Trim().Length > 0)
                        {
                            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();
                            Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();

                            user.UserName = userName;
                            if (data.UserLoginExternal(ref user))
                            {
                                authenticated = true;
                                RedirectAuthenticatedUser();
                            }
                            else
                            {
                                Framework.Utilities.DebugLogging.Log("Shibboleth - authenticated no profile access " + Request[ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"]].ToString());

                                authenticated = false;
                                LogoutFromShibboleth();
                                
                            }
                        }
                    }
                    if (!authenticated)
                    {
                        Framework.Utilities.DebugLogging.Log("Shibboleth - notauthenticated");
                        // try and just put their name in the session.
                        //sm.Session().ShortDisplayName = Request.Headers.Get("ShibdisplayName");
                        LogoutFromShibboleth();
                       
                        RedirectAuthenticatedUser();
                    }
                }
                else if (Request.QueryString["method"].ToString() == "login")
                {
                    // see if they already have a login session, if so don't send them to shibboleth
                    Profiles.Framework.Utilities.SessionManagement sm = new Profiles.Framework.Utilities.SessionManagement();
                    String viewerId = sm.Session().PersonURI;
                    if (viewerId != null && viewerId.Trim().Length > 0)
                    {
                        RedirectAuthenticatedUser();
                    }
                    //added by KP
                    //duplicated shibboleth login code . code was not working as it is in our environment had to modify so login links changed to logout and added extra information to check session id
                    else if (Request[ConfigurationManager.AppSettings["Shibboleth.SessionID"]] != null && !String.IsNullOrEmpty(Request[ConfigurationManager.AppSettings["Shibboleth.SessionID"].ToString()].ToString()))


                    {
                        bool authenticated = false;

                        String userName = Request[ConfigurationManager.AppSettings["Shibboleth.UserNameHeader"]].ToString(); //"025693078";
                        if (userName != null && userName.Trim().Length > 0)
                        {
                            Framework.Utilities.DebugLogging.Log("login - username " + userName);
                            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();
                            Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();

                            user.UserName = userName;
                            if (data.UserLoginExternal(ref user))
                            {
                                Framework.Utilities.DebugLogging.Log("login - data.userloginexternal " + userName);
                                authenticated = true;
                                RedirectAuthenticatedUser();
                            }
                        }
                        if (!authenticated)
                        {
                            Framework.Utilities.DebugLogging.Log("login - notauthenticated");

                            //Logout from shibboleth 
                            LogoutFromShibboleth();
                            // try and just put their name in the session.
                            //sm.Session().ShortDisplayName = Request.Headers.Get("ShibdisplayName");
                            RedirectAuthenticatedUser();
                        }








                    }

                    else
                    {
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

            if (ConfigurationManager.AppSettings["Shibboleth.LogoutURL"] != null)
            {
                var redirect = "return=" + Request.QueryString["redirectto"].ToString();
                var shibbolethlogout = ConfigurationManager.AppSettings["Shibboleth.LogoutURL"].ToString().Trim();


                Framework.Utilities.DebugLogging.Log("Shiboleth - logout  " + shibbolethlogout + HttpUtility.UrlEncode(redirect));

                Response.Redirect(shibbolethlogout + HttpUtility.UrlEncode( redirect));



            }
            else
            {
                Response.Redirect(Request.QueryString["redirectto"].ToString());
            }
            lblError.Text = "You currently donot have active faculty account. ";


        }

        private void RedirectAuthenticatedUser()
        {

            Framework.Utilities.DebugLogging.Log("redirectto " + Request.QueryString["redirectto"]);
            Framework.Utilities.DebugLogging.Log("editlink " + Request.QueryString["edit"]);

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
            sm = new Profiles.Framework.Utilities.SessionManagement();
            
        }

    }
}