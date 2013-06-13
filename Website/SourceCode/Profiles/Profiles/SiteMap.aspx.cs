using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Compilation;
using System.Web.UI;
using System.Web.UI.WebControls;

using Profiles.Framework.Utilities;

namespace Profiles
{
    public partial class SiteMap : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + Environment.NewLine +
                                    "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"" + Environment.NewLine +
                                    "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" + Environment.NewLine +
                                    "xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About/AboutUCSFProfiles.aspx</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About/ForDevelopers.aspx</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About/GadgetLibrary.aspx</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About/Help.aspx</loc></url>" + Environment.NewLine +
                                    "<url><loc>" + Root.Domain + "/About/HowProfilesWorks.aspx</loc></url>" + Environment.NewLine);

            using (System.Data.SqlClient.SqlDataReader reader = new Framework.Utilities.DataIO().GetRESTApplications())
            {
                while (reader.Read())
                {
                    // if it has a . then it's a pretty name for a user
                    if (reader[0].ToString().Contains("."))
                        Response.Write("<url><loc>" + Root.Domain + "/" + reader[0].ToString() + "</loc></url>" + Environment.NewLine);

                }
            }

            Response.Write("</urlset>");
            Response.ContentType = "application/xml";
            Response.Charset = "charset=UTF-8";
            Response.End();
        }
    }

}
