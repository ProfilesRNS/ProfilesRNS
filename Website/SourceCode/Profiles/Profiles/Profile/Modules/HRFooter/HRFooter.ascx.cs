using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Profile.Modules
{
    public partial class HRFooter : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public HRFooter() : base() { }
        public HRFooter(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
           

        }
        private void DrawProfilesModule()
        {

            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            SqlDataReader reader;

            // Get support text
            using (reader = data.GetPublicationSupportHtml(base.RDFTriple, base.MasterPage.CanEdit))
            {
                while (reader.Read())
                {
                    supportText.Text = reader["HTML"].ToString();
                }
                reader.Close();
            }
        }

    }
}



