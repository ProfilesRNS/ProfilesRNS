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

        private static Random random = new Random();

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
            if (this.RDFData.SelectSingleNode("rdf:RDF[1]/rdf:Description[1]/foaf:firstName", base.RDFNamespaces) != null)
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
                Canonical.Href = Root.Domain + Request.Url.AbsolutePath.ToLower();
                Canonical.Attributes["rel"] = "canonical";
                Page.Header.Controls.Add(Canonical);

                // email tracking
                HtmlGenericControl trackMailClickJs = new HtmlGenericControl("script");
                trackMailClickJs.Attributes.Add("type", "text/javascript");
                trackMailClickJs.InnerHtml =
                    "\n   // per http://stackoverflow.com/a/8570258/31100\n" +
                    "       function handleMailto(link, email) {\n" +
                    "       _gaq.push(['_trackEvent', 'Profile Page Interaction', 'activate_email_link', email, , false]);\n" +
                    "       _gaq.push(function () { document.location = link.href });\n" +
                    "       return false;\n" +
                    "   }\n";
                Page.Header.Controls.Add(trackMailClickJs);
            }
            else
            {
                // Tell the bots that this is slow moving data, add an exires at some random date up to 30 days out
                DateTime expires = DateTime.Now.Add( TimeSpan.FromDays( random.NextDouble() * 29 + 1 ));
                Response.AddHeader("Expires", expires.ToUniversalTime().ToString("r"));
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

            HtmlLink UCSFcss = new HtmlLink();
            UCSFcss.Href = Root.Domain + "/Profile/CSS/UCSF.css";
            UCSFcss.Attributes["rel"] = "stylesheet";
            UCSFcss.Attributes["type"] = "text/css";
            UCSFcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(UCSFcss);

            HtmlGenericControl UCSFjs = new HtmlGenericControl("script");
            UCSFjs.Attributes.Add("type", "text/javascript");
            UCSFjs.Attributes.Add("src", Root.Domain + "/Profile/JavaScript/UCSF.js");
            Page.Header.Controls.Add(UCSFjs);
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
