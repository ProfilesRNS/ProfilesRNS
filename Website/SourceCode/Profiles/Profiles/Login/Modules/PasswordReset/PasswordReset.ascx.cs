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

namespace Profiles.Login.Modules.PasswordReset
{
    public partial class PasswordReset : System.Web.UI.UserControl
    {
        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                /*
                if (Request.QueryString["method"].ToString() == "login" && sm.Session().PersonID > 0)
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
                } */
            } 

        }

        public PasswordReset() { }
        public PasswordReset(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {


            Profiles.Login.Utilities.DataIO data = new Profiles.Login.Utilities.DataIO();

            if (false && Request.QueryString["method"].ToString() == "login")
            {
                Profiles.Login.Utilities.User user = new Profiles.Login.Utilities.User();
                //user.UserName = txtUserName.Text.Trim();
                //user.Password = txtPassword.Text.Trim();

                if (data.UserLogin(ref user))
                {
                    if (Request.QueryString["edit"] == "true")
                        if (Request.QueryString["editparams"] == null)
                            Response.Redirect(Root.Domain + "/edit/" + sm.Session().NodeID);
                        else
                            Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + sm.Session().NodeID + "&" + Request.QueryString["editparams"]);
                    else
                        Response.Redirect(Request.QueryString["redirectto"].ToString());

                }
                else
                {
                    lblError.Text = "Login failed, please try again";
                    //txtPassword.Text = "";
                    //txtPassword.Focus();
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
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        protected void cmdSendResetEmail_Click(object sender, EventArgs e)
        {
            string resetEmailText = txtEmailAddress.Text;
            if (!string.IsNullOrEmpty(resetEmailText))
            {
                string emailAddress = txtEmailAddress.Text;

                /* Generate the resetToken and add it to the database table */
                string resetToken = Guid.NewGuid().ToString();

                PasswordResetEmail passwordResetEmail = new PasswordResetEmail(emailAddress, resetToken);
                passwordResetEmail.Send();
            }
        }
    }
}