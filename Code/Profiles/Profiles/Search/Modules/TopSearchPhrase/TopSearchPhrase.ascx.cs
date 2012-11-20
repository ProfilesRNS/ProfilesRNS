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

namespace Profiles.Search.Modules.TopSearchPhrase
{
    public partial class TopSearchPhrase : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
         DrawProfilesModule();
        }

        public TopSearchPhrase() { }
        public TopSearchPhrase(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            :base(pagedata,moduleparams,pagenamespaces)
        {


        }
        private void DrawProfilesModule()
        {

            System.Text.StringBuilder list = new StringBuilder();
            Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();
            SqlDataReader reader = data.TopSearchPhrase(base.GetModuleParamString("TimePeriod"));


            litDescription.Text = base.GetModuleParamString("Description");

            list.Append("<ul>");

            string classuri = "http://xmlns.com/foaf/0.1/Person";
            string searchtype = string.Empty;

            if (base.MasterPage.Tab.ToLower() == "all")
            {
                classuri = string.Empty;
                searchtype = "everything";
            }
            else
            {
                searchtype = "people";
            }



            while (reader.Read())
            {
                list.Append("<li>");
                list.Append("<a href=\"JavaScript:searchThisPhrase('" + reader["phrase"].ToString() + "','" + classuri + "','" + searchtype + "')\">" + reader["phrase"] + "</a>");
                list.Append("</li>");
            }
            list.Append("</ul>");



            litTopSearchPhrase.Text = list.ToString();

        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }
    }
}