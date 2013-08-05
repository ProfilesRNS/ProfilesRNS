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
using System.Web.UI.HtmlControls;

using Profiles.Profile.Utilities;
using Profiles.Framework.Utilities;

namespace Profiles.Profile
{
    public partial class Display : ProfileData
    {
        private Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            UserHistory uh = new UserHistory();

            masterpage = (Framework.Template)base.Master;
            this.Master = masterpage;

            this.LoadAssets();

            this.LoadPresentationXML();

            XmlNode x = this.PresentationXML.SelectSingleNode("Presentation[1]/ExpandRDFList[1]");

            if (x != null)
                base.RDFTriple.ExpandRDFList = x.OuterXml;
            
            if (base.RDFTriple.Subject != 0 && base.RDFTriple.Predicate != 0 && base.RDFTriple.Object == 0)
                base.RDFTriple.Limit = "1";

            base.LoadRDFData();

            Framework.Utilities.DebugLogging.Log("Page_Load Profile 1: " + DateTime.Now.ToLongTimeString());

            masterpage.Tab = base.Tab;
            masterpage.RDFData = base.RDFData;
            masterpage.RDFNamespaces = base.RDFNamespaces;
            masterpage.PresentationXML = this.PresentationXML;
            Framework.Utilities.DebugLogging.Log("Page_Load Profile 2: " + DateTime.Now.ToLongTimeString());

            // UCSF added schema.org info
            // Only do this for a person only version of this page !
            XmlNode presentationClass = PresentationXML.SelectSingleNode("//Presentation/@PresentationClass", base.RDFNamespaces);
            if (presentationClass != null && "profile".Equals(presentationClass.InnerText.ToLower()) &&
                this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/foaf:firstName", base.RDFNamespaces) != null &&
                this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/foaf:lastName", base.RDFNamespaces) != null)
            {
                ((HtmlGenericControl)masterpage.FindControl("divProfilesContentMain")).Attributes.Add("itemscope", "itemscope");
                ((HtmlGenericControl)masterpage.FindControl("divProfilesContentMain")).Attributes.Add("itemtype", "http://schema.org/Person");

                HtmlMeta Description = new HtmlMeta();
                Description.Name = "Description";
                string name = this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/foaf:firstName", base.RDFNamespaces).InnerText + " " +
                     this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/foaf:lastName", base.RDFNamespaces).InnerText;
                Description.Content = name + "'s profile, publications, research topics, and co-authors";
                Page.Header.Controls.Add(Description);

                HtmlLink Canonical = new HtmlLink();
                Canonical.Href = Request.Url.AbsoluteUri.IndexOf('?') == -1 ? Request.Url.AbsoluteUri.ToLower() : Request.Url.AbsoluteUri.ToLower().Substring(0, Request.Url.AbsoluteUri.IndexOf('?'));
                Canonical.Attributes["rel"] = "canonical";
                Page.Header.Controls.Add(Canonical);
            }
        }


        private void LoadAssets()
        {

            HtmlLink Displaycss = new HtmlLink();
            Displaycss.Href = Root.Domain + "/Profile/CSS/display.css";
            Displaycss.Attributes["rel"] = "stylesheet";
            Displaycss.Attributes["type"] = "text/css";
            Displaycss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Displaycss);
        }

        public void LoadPresentationXML()
        {
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            this.PresentationXML = data.GetPresentationData(this.RDFTriple);
        }

        public XmlDocument PresentationXML { get; set; }
        public Profiles.Framework.Template Master { get; set; }

    }
}
