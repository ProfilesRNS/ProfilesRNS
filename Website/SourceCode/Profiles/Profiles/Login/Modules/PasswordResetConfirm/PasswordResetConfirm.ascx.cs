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
using Profiles.Login.Objects;

namespace Profiles.Login.Modules.PasswordReset
{
    public partial class PasswordResetConfirm : System.Web.UI.UserControl
    {
        Framework.Utilities.SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                /* Get back the reset token from the querystring */
                string resetToken = Request.QueryString["token"];

                /* Look up the token in the database, verify that it exists */

                /* If it doesn't exist throw an error */ 

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

        public PasswordResetConfirm() { }
        public PasswordResetConfirm(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new Profiles.Framework.Utilities.SessionManagement();
            LoadAssets();
        }

        protected void cmdSubmit_Click(object sender, EventArgs e)
        {
            string password = txtPassword.Text;
            string passwordConfirm = txtPasswordConfirm.Text;
            if (!string.IsNullOrEmpty(password) && !string.IsNullOrEmpty(passwordConfirm))
            {

                /* Make sure the email address exists in the database. */

                /* */
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

    }
}