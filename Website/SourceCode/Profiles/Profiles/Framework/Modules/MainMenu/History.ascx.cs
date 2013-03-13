/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using System.Data;
using System.Drawing;
using System.IO;
using System.Drawing.Imaging;
using System.Text;

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

                DrawProfilesModule();
            }
        }

        private void DrawProfilesModule()
        {
            rptHistory.DataSource = uh.GetItems(5);
            rptHistory.DataBind();

            if (rptHistory.DataSource != null)
                litSeeAll.Text = "<a href='" + Root.Domain + "/history'><font style='font-size:10px'>See All (" + uh.GetItems().Count.ToString() + ") pages</font></a>";


        }
        private void RecordHistory()
        {


            try
            {
                if (this.PresentationXML != null)
                {
                    if (this.PresentationXML.SelectSingleNode("Presentation/@PresentationClass").Value.ToLower() == "profile")
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

        protected void rptHistoryOnItemBound(object sender, RepeaterItemEventArgs e)
        {
            HistoryItem userHistory = (HistoryItem)e.Item.DataItem;
            if (userHistory != null)
            {
                Literal lblHistoryItem = (Literal)e.Item.FindControl("lblHistoryItem");
                string label = string.Empty;

                if (userHistory.ItemLabel.Length > 21)
                {
                    label = userHistory.ItemLabel.Substring(0, 22);
                }
                else
                {
                    label = userHistory.ItemLabel;
                }

                lblHistoryItem.Text = "<a href=" + userHistory.URI + ">" + label + "</a><br/>";
            }
        }
    }
}