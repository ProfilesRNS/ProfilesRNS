/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Xml;
using System.Xml.Xsl;
using System.Xml.XPath;
using Profiles.Framework.Utilities;
using System.Data.SqlClient;
using System.Web.UI.HtmlControls;

namespace Profiles.ORCID.Utilities
{
    public abstract class ProfileData : System.Web.UI.Page
    {
        #region "Constructor"

        public ProfileData()
        {
            Init += new EventHandler(BasePage_Init);
        }

        #endregion

        public XmlDocument PresentationXML { get; set; }
        public abstract string PathToPresentationXMLFile { get; }
        public void Initialize()
        {
            RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));
            RDFTriple.Expand = true;
            RDFTriple.ShowDetails = true;

            LoadPresentationXML();
            LoadRDFData();

            masterpage.RDFData = RDFData;
            masterpage.RDFNamespaces = RDFNamespaces;
            masterpage.PresentationXML = PresentationXML;

            this.LoadAssets();
            masterpage.PresentationXML = this.PresentationXML;
        }
        public void BasePage_Init(object sender, EventArgs e)
        {
            //By default its expand true and showdetails true. Its set to Expand = false for external calls.

            this.RDFTriple = new RDFTriple(Convert.ToInt64(sm.Session().NodeID.ToString()));

            this.RDFTriple.Expand = true;
            this.RDFTriple.ShowDetails = true;
        }
        public void LoadRDFData()
        {
            Framework.Utilities.DebugLogging.Log("{Page Calling} Profile.ProfileData.LoadRDFData() start " + ((System.Web.UI.TemplateControl)(this)).AppRelativeVirtualPath);
            XmlDocument xml = new XmlDocument();
            Namespace rdfnamespaces = new Namespace();
            Profiles.Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();

            if (HttpContext.Current.Request.Headers["Offset"] != null)
                this.RDFTriple.Offset = HttpContext.Current.Request.Headers["Offset"];

            if (HttpContext.Current.Request.Headers["Limit"] != null)
                this.RDFTriple.Limit = HttpContext.Current.Request.Headers["Limit"];

            if (HttpContext.Current.Request.Headers["ExpandRDFList"] != null)
                this.RDFTriple.ExpandRDFList = HttpContext.Current.Request.Headers["ExpandRDFList"];

            xml = data.GetRDFData(this.RDFTriple);
            this.RDFData = xml;
            this.RDFNamespaces = rdfnamespaces.LoadNamespaces(xml);
            Framework.Utilities.DebugLogging.Log("{Page Calling} Profile.ProfileData.LoadRDFData() end" + ((System.Web.UI.TemplateControl)(this)).AppRelativeVirtualPath);

        }
        public XmlNamespaceManager RDFNamespaces { get; set; }
        public XmlDocument RDFData { get; set; }
        public RDFTriple RDFTriple { get; set; }
        public string Tab { get; set; }
        public string SessionID { get; set; }
        
        protected string LoggedInInternalUsername
        {
            get
            {
                return new Profiles.ORCID.Utilities.DataIO().GetInternalUserID();
            }
        }        
        protected Profiles.Framework.Template masterpage
        {
            get
            {
                if (_masterpage == null)
                {
                    _masterpage = (Framework.Template)base.Master;
                }
                return _masterpage;
            }
        }
        protected SessionManagement sm
        {
            get
            {
                if (_sm == null)
                {
                    _sm = new SessionManagement();
                }
                return _sm;
            }
        }

        private Profiles.Framework.Template _masterpage;
        private SessionManagement _sm = null;
        private void LoadPresentationXML()
        {
            string presentationxml = string.Empty;

            presentationxml = System.IO.File.ReadAllText(PathToPresentationXMLFile);

            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);
        }
        private void LoadAssets()
        {
            HtmlLink ORCIDcss = new HtmlLink();
            ORCIDcss.Href = Root.Domain + "/ORCID/CSS/ORCID.css";
            ORCIDcss.Attributes["rel"] = "stylesheet";
            ORCIDcss.Attributes["type"] = "text/css";
            ORCIDcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(ORCIDcss);

            HtmlGenericControl ORCIDjs = new HtmlGenericControl("script");
            ORCIDjs.Attributes.Add("type", "text/javascript");
            ORCIDjs.Attributes.Add("src", Root.Domain + "/ORCID/JavaScript/orcid.js?v=1");
            Page.Header.Controls.Add(ORCIDjs);
        }
    }
}