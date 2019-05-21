using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.Profile.Modules.CustomViewPersonSameDepartment
{
    public partial class CustomViewPersonSameDepartment : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            DrawProfilesModule();
        }

        public CustomViewPersonSameDepartment() : base() { }
        public CustomViewPersonSameDepartment(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {
            Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            Search.Utilities.DataIO search = new Profiles.Search.Utilities.DataIO();

            XmlDocument xml = data.GetSameDepartment(base.RDFTriple);
            List<ListItem> items = new List<ListItem>();


            if (xml.SelectSingleNode("Network/NumberOfConnections").InnerText != "0")
            {
                string departmenturi = xml.SelectSingleNode("Network/DepartmentURI").InnerText;
                string insitutitionuri = xml.SelectSingleNode("Network/InstitutionURI").InnerText;
                string searchrequest = string.Empty;

                search.SearchRequest("", "", "", "", insitutitionuri, "", departmenturi, "", "", "", "http://xmlns.com/foaf/0.1/Person", "25", "0", "", "", "","", ref searchrequest);

                this.SearchRequest = searchrequest;

                foreach (XmlNode n in xml.SelectNodes("Network/Connection"))
                {
                    items.Add(new ListItem(n.InnerText, n.SelectSingleNode("@URI").Value));

                }

                rptSameDepartment.DataSource = items;
                rptSameDepartment.DataBind();

            }
            else
            {
                rptSameDepartment.Visible = false;
            }

        }

        protected void SameDepartmentItemBound(object sender, RepeaterItemEventArgs e)
        {
            ListItem x = (ListItem)e.Item.DataItem;
            Image img = (Image)e.Item.FindControl("imgQuestion");

            if (img != null)
                img.ImageUrl = Root.Domain + "/Framework/Images/info.png";

            Literal litListItem = (Literal)e.Item.FindControl("litListItem");
            if (litListItem != null)
                litListItem.Text = "<li><a href='" + x.URI + "'>" + x.Name + "</a></li>";

            if (e.Item.ItemType == ListItemType.Footer)
            {
                HyperLink moreurl = (HyperLink)e.Item.FindControl("moreurl");
                moreurl.NavigateUrl = Root.Domain + "/search/default.aspx?searchtype=people&searchfor=&action=department";

            }

        }

        public string SearchRequest { get; set; }

        public class ListItem
        {
            public ListItem(string name, string uri)
            {
                Name = name;
                URI = uri;
            }
            public string Name { get; set; }
            public string URI { get; set; }
        }


    }
}