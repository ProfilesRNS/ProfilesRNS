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

namespace Profiles.Profile.Modules.CustomViewExternalCoauthors
{
    public partial class CustomViewExternalCoauthors : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }

        public CustomViewExternalCoauthors() : base() { }
        public CustomViewExternalCoauthors(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {
            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            List<ListItem> items = new List<ListItem>();
            using (SqlDataReader dbreader = data.GetExternalCoauthors(base.RDFTriple.Subject))
            {                
                while (dbreader.Read())
                {
                    items.Add(new ListItem(dbreader[0].ToString(), dbreader[1].ToString(), dbreader[2].ToString(), dbreader.GetInt32(3)));
                }
            }

            if (items.Count > 0) 
            {
                rptExternalCoauthor.DataSource = items;
                rptExternalCoauthor.DataBind();
            }
            else
            {
                rptExternalCoauthor.Visible = false;
            }


        }

        protected void ExternalCoauthorItemBound(object sender, RepeaterItemEventArgs e)
        {
            ListItem x = (ListItem)e.Item.DataItem;
            Image img = (Image)e.Item.FindControl("imgQuestion");

            if (img != null)
            {
                img.ImageUrl = Root.Domain + "/Framework/Images/info.png";
                img.Width = 11;
                img.Height = 11;
            }
            Literal litListItem = (Literal)e.Item.FindControl("litListItem");
            if (litListItem != null)
                litListItem.Text = "<li><a href='" + x.URI + "' target='_blank'>" + 
                    x.Name + " (" + x.Affiliation + ")</a></li>";

        }

        public string SearchRequest { get; set; }

        public class ListItem
        {
            public ListItem(string uri, string name, string affiliation, int publicationCount)
            {
                URI = uri;
                Name = name;
                Affiliation = affiliation;
                PublicationCount = publicationCount;
            }
            public string URI { get; set; }
            public string Name { get; set; }
            public string Affiliation { get; set; }
            public int PublicationCount { get; set; }
        }


    }
}