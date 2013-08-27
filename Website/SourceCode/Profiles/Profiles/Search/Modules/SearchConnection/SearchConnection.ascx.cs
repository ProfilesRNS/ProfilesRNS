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
namespace Profiles.Search.Modules
{
    public partial class SearchConnection : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public SearchConnection() { }
        public SearchConnection(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }
        private void DrawProfilesModule()
        { 
            
            Literal backlink = (Literal)base.MasterPage.FindControl("litBackLink");
            
                                   
            List<DirectConnection> directconnections = new List<DirectConnection>();
            List<IndirectConnection> indirectconnections = new List<IndirectConnection>();

            string nodeuri = Request.QueryString["nodeuri"].ToString();
            string url = Request.RawUrl.Split('?')[1];
            bool person = false;

            XmlNode node = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + nodeuri + "']", base.Namespaces);

            if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:nodeID='SearchResults']/vivo:overview/SearchOptions/MatchOptions/ClassURI",base.Namespaces)!=null)
            {
                if (base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:nodeID='SearchResults']/vivo:overview/SearchOptions/MatchOptions/ClassURI", base.Namespaces).InnerText == "http://xmlns.com/foaf/0.1/Person")
                    person = true;
            }

            //Need to strip the two querystring params so they fall out of the search process in the SearchResults.ascx and search/default.aspx processes.
            url = url.Replace("nodeuri=", "_nodeuri=");
            url = url.Replace("nodeid=", "_nodeid=");

            if (person)
            {
                url = url.Replace("searchtype=whypeople", "searchtype=people");
            }
            else
            {
                url = url.Replace("searchtype=whyeverything", "searchtype=everything");
            }

            backlink.Text = "<a href='" + Root.Domain + "/search/default.aspx?" + url + "'><img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/> Back to Search Results</a>";
            litSearchURL.Text = "<a href='" + Root.Domain + "/search/default.aspx?" + url + "'>Search Results</a>";

            litPersonURI.Text = "<a href='" + nodeuri + "'>" + node.SelectSingleNode("rdfs:label", base.Namespaces).InnerText + "</a>";

            litNodeURI.Text = "<a href='" + nodeuri + "'>" + node.SelectSingleNode("rdfs:label", base.Namespaces).InnerText + "</a>";

            if (node != null)
            {
                if (person)
                {
                    foreach (XmlNode n in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:overview/DirectMatchList/Match/PropertyList/Property", base.Namespaces))
                    {
                       // if (n.SelectSingleNode("Name", base.Namespaces).InnerText == "fullName" || n.SelectSingleNode("Name", base.Namespaces).InnerText == "perferredTitle" || n.SelectSingleNode("Name", base.Namespaces).InnerText == "overview")
                            directconnections.Add(new DirectConnection(n.SelectSingleNode("Name", base.Namespaces).InnerText, n.SelectSingleNode("Value", base.Namespaces).InnerText, nodeuri));
                    }
                }
                else
                {
                    foreach (XmlNode n in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:overview/DirectMatchList/Match/PropertyList/Property", base.Namespaces))
                    {
                        directconnections.Add(new DirectConnection(n.SelectSingleNode("Name", base.Namespaces).InnerText, n.SelectSingleNode("Value", base.Namespaces).InnerText, nodeuri));
                    }
                }

                if (directconnections.Count > 0)
                {
                    gvConnectionDetails.DataSource = directconnections;
                    gvConnectionDetails.DataBind();
                    pnlDirectConnection.Visible = true;
                }

            }

            if (base.BaseData.SelectNodes("rdf:RDF/rdf:Description[@rdf:NodeID='ConnectionDetails']/vivo:overview/IndirectMatchList/Match", base.Namespaces).Count > 0)
            {
                pnlIndirectConnection.Visible = true;

                litSubjectName.Text = "<a href='" + nodeuri + "'>" + node.SelectSingleNode("rdfs:label", base.Namespaces).InnerText + "</a>";                   

                    foreach (XmlNode item in base.BaseData.SelectNodes("rdf:RDF/rdf:Description[@rdf:NodeID='ConnectionDetails']/vivo:overview/IndirectMatchList/Match", base.Namespaces))
                    {
                        indirectconnections.Add(new IndirectConnection(item.SelectSingleNode("ClassName").InnerText, item.SelectSingleNode("Label").InnerText, item.SelectSingleNode("URI").InnerText));
                    }

                gvIndirectConnectionDetails.DataSource = indirectconnections;
                gvIndirectConnectionDetails.DataBind();
            }

        }

        protected void gvConnectionDetails_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Literal litProperty = (Literal)e.Row.FindControl("litProperty");
                Literal litValue = (Literal)e.Row.FindControl("litValue");
                DirectConnection dc = (DirectConnection)e.Row.DataItem;

                string urlproperty = dc.Property;
                string urlvalue =  dc.Value;

                litProperty.Text = urlproperty;
                litValue.Text = urlvalue;

                if (e.Row.RowState == DataControlRowState.Alternate)
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,0);");
                    e.Row.Attributes.Add("class", "evenRow");

                }
                else
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,1);");
                    e.Row.Attributes.Add("class", "oddRow");
                }


                e.Row.Attributes.Add("onclick", "document.location.href='" + dc.URI + "'");

            }
        }


        protected void gvIndirectConnectionDetails_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Literal litProperty = (Literal)e.Row.FindControl("litProperty");
                Literal litValue = (Literal)e.Row.FindControl("litValue");
                IndirectConnection dc = (IndirectConnection)e.Row.DataItem;

                string urlproperty = dc.ItemType;
                string urlvalue =  dc.Name;

                litProperty.Text = urlproperty;
                litValue.Text = urlvalue;


                if (e.Row.RowState == DataControlRowState.Alternate)
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,0);");
                    e.Row.Attributes.Add("class", "evenRow");

                }
                else
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,1);");
                    e.Row.Attributes.Add("class", "oddRow");
                }
                e.Row.Attributes.Add("onclick", "document.location.href='" + dc.URI + "'");
            }
        }


        private class DirectConnection
        {
            public DirectConnection(string property, string value, string uri)
            {
                this.Property = property;
                this.Value = value;
                this.URI = uri;

            }
            public string Property { get; set; }
            public string Value { get; set; }
            public string URI { get; set; }


        }
        private class IndirectConnection
        {
            public IndirectConnection(string itemtype, string name, string uri)
            {
                this.ItemType = itemtype;
                this.Name = name;
                this.URI = uri;
            }
            public string ItemType { get; set; }
            public string Name { get; set; }
            public string URI { get; set; }
        }
        public string GetURLDomain()
        {
            return Root.Domain;
        }



    }
}