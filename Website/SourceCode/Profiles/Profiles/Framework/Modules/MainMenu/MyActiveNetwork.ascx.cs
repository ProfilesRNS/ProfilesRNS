

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using Profiles.Framework.Utilities;
using System.Xml;
using Profiles.ActiveNetwork.Modules.MyNetwork;

namespace Profiles.Framework.Modules.MainMenu
{

    public partial class MyActiveNetwork : System.Web.UI.UserControl
    {
        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new SessionManagement();
            DrawProfilesModule();
        }

        private void DrawProfilesModule()
        {
            this.first = true;
            Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            List<NetworkItem> networkitem = new List<NetworkItem>();

            if (HttpContext.Current.Request.QueryString["subject"] != null)
                this.Subject = Convert.ToInt64(HttpContext.Current.Request.QueryString["subject"]);

            hdSubject.Value = this.Subject.ToString();

            using (SqlDataReader reader = data.GetActiveNetwork(0, false))
            {
                while (reader.Read())
                    networkitem.Add(new NetworkItem(reader[1].ToString(), Convert.ToInt64(reader[2]), reader[3].ToString()));

                if (!reader.IsClosed)
                    reader.Close();
            }


            if (networkitem.Count > 0)
            {
                gvActiveNetwork.DataSource = networkitem;
                gvActiveNetwork.DataBind();
                this.Count = networkitem.Count;
                string seeall = string.Empty;
                if (this.Count > 1)
                    seeall = "See all " + networkitem.Count.ToString() + " people";
                else
                    seeall = "See all people";
                litActiveNetworkDetails.Text = "<li  style='height: 25px !important'><a style='border-left:1px solid #383737;border-right:1px solid #383737;border-bottom:1px solid #383737;border-top:2px solid #383737;' href='" + Root.Domain + "/activenetwork/default.aspx'>" + seeall + "</a></li>";

            }
            else
            {
                gvActiveNetwork.Visible = false;
                litActiveNetworkDetails.Visible = false;
            }


            if (sm.Session().UserID != 0 && Subject > 0)
            {
                if (this.Subject != sm.Session().NodeID && (Root.AbsolutePath.Contains("/display/")))
                {
                    int count = RelationshipTypeUtils.GetRelationshipTypes(Convert.ToInt64(Subject)).Count;

                    if (count > 0)
                    {
                        rptRelationshipTypes.DataSource = RelationshipTypeUtils.GetRelationshipTypes(Convert.ToInt64(Subject));
                        rptRelationshipTypes.DataBind();
                        this.Count = count;
                        rptRelationshipTypes.Visible = true;
                    }
                    else
                        rptRelationshipTypes.Visible = false;
                }
            }
        }

        protected void rptRelationshipTypes_ItemBound(object sender, RepeaterItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Header)
                {
                    if (this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:firstName", this.Namespaces) != null)
                        this.PersonName = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:firstName", this.Namespaces).InnerText;

                    if (this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:lastName", this.Namespaces) != null)
                        this.PersonName += " " + this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:lastName", this.Namespaces).InnerText;

                    Literal lblName = (Literal)e.Item.FindControl("lblName");
                    lblName.Text = "<span>" + this.PersonName + " is my...</span>";


                }
                else
                {
                    string itemid = Guid.NewGuid().ToString();
                    string lastrow = string.Empty;

                    RelationshipType rt = (RelationshipType)e.Item.DataItem;
                    if (e.Item.ItemIndex < ((List<RelationshipType>)rptRelationshipTypes.DataSource).Count)
                    {

                        lastrow = "border-bottom:1px solid #383737;";

                    }


                    Literal lit = (Literal)e.Item.FindControl("litRelationshipType");
                    if (rt.Selected)
                        lit.Text = "<a style='" + lastrow + "padding-left:20px !important;border-left:1px solid #383737;border-right:1px solid #383737;padding-top:5px;' id='" + itemid + "' onclick = 'toggleSelectionRepeater(this);'><span class='checkmark'></span>" + rt.Text + "</a>";
                    else
                        lit.Text = "<a style='" + lastrow + "padding-left:20px !important;border-left:1px solid #383737;border-right:1px solid #383737;padding-top:5px;' id='" + itemid + "' onclick = 'toggleSelectionRepeater(this);'><span class='xcheckmark'></span>" + rt.Text + " </a>";
                }
            }
            catch (Exception ex) { Framework.Utilities.DebugLogging.Log(ex.Message); }


        }
        protected void gvActiveNetwork_ItemBound(object sender, RepeaterItemEventArgs e)
        {

            NetworkItem networkitem = (NetworkItem)e.Item.DataItem;
            Literal lbPerson = (Literal)e.Item.FindControl("lbPerson");
            if (this.first)
                lbPerson.Text = "<li  style='height: 25px !important; border-top:1px solid #383737'><a style='border-left:1px solid #383737;border-right:1px solid #383737;padding-top:5px;'  href='" + networkitem.URI + "'>" + networkitem.Name + "</a></li>";
            else
                lbPerson.Text = "<li style='height: 25px !important;'><a style='height: 25px !important; border-left:1px solid #383737;border-right:1px solid #383737;padding-top:5px;'  href='" + networkitem.URI + "'>" + networkitem.Name + "</a></li>";

            this.first = false;
        }



        public class NetworkItem
        {
            public NetworkItem(string name, Int64 nodeid, string uri)
            {
                this.Name = name;
                this.NodeID = nodeid;
                this.URI = uri;
            }

            public string Name { get; set; }
            public Int64 NodeID { get; set; }
            public string URI { get; set; }

        }
        public Int64 Subject
        {
            get
            {
                return Convert.ToInt64(Session["NETWORK"]);
            }
            set { Session.Add("NETWORK", value); }
        }
        public string PersonName { get; set; }
        public string ClassURI { get; set; }
        public int Count { get; set; }
        public bool first { get; set; }
        public XmlDocument BaseData { get; set; }
        public XmlNamespaceManager Namespaces { get; set; }

    }





}