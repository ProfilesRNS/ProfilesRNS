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

namespace Profiles.Profile.Modules.CustomViewInformationResource
{
    public partial class CustomViewInformationResource : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }
        public CustomViewInformationResource() : base() { }
        public CustomViewInformationResource(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            base.RDFTriple = new RDFTriple(Convert.ToInt64(Request.QueryString["Subject"]));

        }
        private void DrawProfilesModule()
        {

            XsltArgumentList args = new XsltArgumentList();
            args.AddParam("root", "", Root.Domain);

            List<GenericListItem> subjectareas = new List<GenericListItem>();
            List<GenericListItem> authors = new List<GenericListItem>();
            
            foreach (XmlNode x in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:hasSubjectArea/@rdf:resource", base.Namespaces))
            {
                subjectareas.Add(new GenericListItem(base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + x.Value + "']/rdfs:label",base.Namespaces).InnerText, x.Value ));
            }

            subjectareas.Sort(delegate( GenericListItem p1, GenericListItem p2)
            {
                return p1.Text.CompareTo(p2.Text);
            });


            foreach (XmlNode x in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/vivo:linkedAuthor/@rdf:resource", base.Namespaces))
            {
                authors.Add(new GenericListItem(base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + x.Value + "']/prns:fullName", base.Namespaces).InnerText, x.Value));
            }


            imgSubjectArea.Src = Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif";

            imgAuthor.Src = Root.Domain + "/Profile/Modules/PropertyList/images/minusSign.gif";


            if (subjectareas.Count > 0)
            {
                rptSubjectAreas.DataSource = subjectareas;
                rptSubjectAreas.DataBind();
            }
            else
            {

                pnlSubjectAreas.Visible = false;
            }

            if (authors.Count > 0)
            {
                rptAuthors.DataSource = authors;
                rptAuthors.DataBind();
            }
            else
            {
                pnlAuthors.Visible = false;
            }

            litPublication.Text = "<a href=\"http://www.ncbi.nlm.nih.gov/pubmed/" + base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/bibo:pmid", base.Namespaces).InnerText + "\"target=\"_blank\">PubMed</a>";

            litinformationResourceReference.Text = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/prns:informationResourceReference", base.Namespaces).InnerText;

           


        }

        protected void rptSubjectAreas_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            GenericListItem gl = null;
            Literal subjectarea = null;


            if (e.Item.DataItem != null)
                gl = (GenericListItem)e.Item.DataItem;

            if (e.Item.FindControl("litAbout") != null)
                subjectarea = (Literal)e.Item.FindControl("litAbout");

            if (gl != null && subjectarea != null)
                subjectarea.Text = "<a href='" + gl.Value + "'>" + gl.Text + "</a>";




        }

        protected void rptAuthors_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {

            GenericListItem gl = null;
            Literal authors = null;


            if (e.Item.DataItem != null)
                gl = (GenericListItem)e.Item.DataItem;

            if (e.Item.FindControl("litAuthor") != null)
                authors = (Literal)e.Item.FindControl("litAuthor");

            if (gl != null && authors != null)
                authors.Text = "<a href='" + gl.Value + "'>" + gl.Text + "</a>";




        }

    }

    
}