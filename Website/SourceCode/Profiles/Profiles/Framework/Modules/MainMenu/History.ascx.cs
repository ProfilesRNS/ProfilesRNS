
using System;
using System.Collections.Generic;
using System.Xml;
using Profiles.Framework.Utilities;


namespace Profiles.Framework.Modules.MainMenu
{
    public partial class History : System.Web.UI.UserControl
    {
        UserHistory uh;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (this.RDFData != null)
            {
                uh = new UserHistory();
                if (this.RDFData.InnerXml != "")
                    RecordHistory();

                if (uh.GetItems() != null)
                {
                    DrawProfilesModule();
                }
                else { lblHistoryItems.Text = "<li class='main-nav'><a href='" + Root.Domain + "/history'>History (0)</a></li>"; }
            }
        }
        
        private void DrawProfilesModule()
        {
            
            int count = 0;

            int total = uh.GetItems().Count;
            lblHistoryItems.Text = "<li class='main-nav'><a href='" + Root.Domain + "/history'>History (" + total.ToString() + ")</a><ul class='drop'>";
            foreach (HistoryItem h in uh.GetItems(5))
            {                
                lblHistoryItems.Text += "<li><a  style='border-left:1px solid #383737;border-right:1px solid #383737;' href='" + h.URI + "'>" + h.ItemLabel + "</a></li>";                
                count++;
            }
            if (total > 1)
                lblHistoryItems.Text += "<li style='height:39px !important;'><a style='border-top:1px solid #ffffff;border-bottom:1px solid #383737;border-left:1px solid #383737;border-right:1px solid #383737;' href='" + Root.Domain + "/history'>See All " + total.ToString() + " Pages</a></li></ul></li>";
            else if (total ==1)
                lblHistoryItems.Text += "<li style='height:39px !important;'><a style='border-top:1px solid #ffffff;border-bottom:1px solid #383737;border-left:1px solid #383737;border-right:1px solid #383737;' href='" + Root.Domain + "/history'>See All Pages</a></li></ul></li>";            



        }
        private void RecordHistory()
        {


            try
            {
                if (this.PresentationXML != null)
                {
                    if (this.PresentationXML.SelectSingleNode("Presentation/@PresentationClass").Value.ToLower() == "profile" && !Request.RawUrl.ToLower().Contains("/search"))
                    {
                        UserHistory uh = new UserHistory();
                        HistoryItem hi;
                        List<string> types = new List<string>();

                        foreach (XmlNode x in this.RDFData.SelectNodes("rdf:RDF/rdf:Description[1]/rdf:type/@rdf:resource", this.Namespaces))
                        {
                            if (this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + x.Value + "']/rdfs:label", this.Namespaces) != null)
                            {
                                types.Add(this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + x.Value + "']/rdfs:label", this.Namespaces).InnerText);
                            }
                            else
                            {
                                string[] s = x.Value.Split('/');
                                types.Add(s[s.Length - 1]);
                            }
                        }


                        if (this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description/rdfs:label", this.Namespaces) != null)
                        {
                            hi = new HistoryItem(this.RDFData.SelectSingleNode("rdf:RDF/rdf:Description/rdfs:label", this.Namespaces).InnerText,
                                RDFData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", this.Namespaces).Value
                                , types);

                            uh.LoadItem(hi);
                        }

                    }
                }
            }
            catch (Exception ex)
            {
                Framework.Utilities.DebugLogging.Log(ex.Message + " " + ex.InnerException.Message);
            }
        }
        public XmlNamespaceManager Namespaces { get; set; }
        public XmlDocument PresentationXML { get; set; }
        public XmlDocument RDFData { get; set; }


    }
}