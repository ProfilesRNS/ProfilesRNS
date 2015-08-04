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
using System.DirectoryServices.AccountManagement;
using System.Configuration;

using Profiles.Login.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Login.Modules.ADLogin
{
    public partial class ADLogin : System.Web.UI.UserControl
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
                    Response.Redirect(Root.Domain + "/search");
                }
                else if (Request.QueryString["method"].ToString() == "login" && sm.Session().PersonID > 0)
                {
                    if (Request.QueryString["redirectto"] == null && Request.QueryString["edit"] == "true")
                    {
                        if (Request.QueryString["editparams"] == null)
                            Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
                        else
                            Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + sm.Session().NodeID + "&" + Request.QueryString["editparams"]);
                    }
                    else
                        Response.Redirect(Request.QueryString["redirectto"].ToString());
                }
            }


        }

        public ADLogin() { }
        public ADLogin(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {
            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();

            if (Request.QueryString["method"].ToString() == "login")
            {
                Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();
                user.UserName = txtUserName.Text.Trim();
                user.Password = txtPassword.Text.Trim();

                String adDomain = ConfigurationSettings.AppSettings["AD.Domain"];
                String adUser = null;
                String adPassword = null;
                try
                {
                    adUser = ConfigurationSettings.AppSettings["AD.User"];
                    adPassword = ConfigurationSettings.AppSettings["AD.Password"];
                }
                catch (Exception ex) { }

                String admin = null;
                try
                {
                    admin = ConfigurationSettings.AppSettings["AD.AccessContact"];
                }
                catch (Exception ex) { }

                using (PrincipalContext pc = new PrincipalContext(ContextType.Domain, adDomain, adUser, adPassword))
                {
                    // validate the credentials
                    if (pc.ValidateCredentials(user.UserName, user.Password))
                    {
                        if (data.UserLoginExternal(ref user))
                        {
                            if (Request.QueryString["edit"] == "true")
                                Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID.ToString());
                            else
                                Response.Redirect(Request.QueryString["redirectto"].ToString());

                        }
                        else
                        {
                            lblError.Text = user.UserName + " is not an authorized user of the Profiles Research Networking Software application.";
                            if (admin != null) lblError.Text = lblError.Text + "<br>Please contact " + admin + " to obtain access.";
                            txtPassword.Text = "";
                            txtPassword.Focus();
                        }
                    }
                    else
                    {
                        lblError.Text = "Login failed, please try again";
                        txtPassword.Text = "";
                        txtPassword.Focus();
                    }
                }
            }
        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

            // Inject script into HEADER
            Literal script = new Literal();
            script.Text = "<script>var _path = \"" + Root.Domain + "\";</script>";
            Page.Header.Controls.Add(script);

            //Response.Write("<script>var _path = \"" + Root.Domain + "\";</script>");


        }


    }
}