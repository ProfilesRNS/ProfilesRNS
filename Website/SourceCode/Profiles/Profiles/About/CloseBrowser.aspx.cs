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
using System.Xml;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;

namespace Profiles.About
{
    public partial class CloseBrowser : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;
            this.LoadAssets();

            masterpage.Tab = "";
            masterpage.RDFData = null;
            XmlDocument presentationxml = new XmlDocument();
            presentationxml.LoadXml(System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/About/PresentationXML/CloseBrowser.xml"));
            masterpage.PresentationXML = presentationxml;

        }

        private void LoadAssets()
        {
            HtmlLink Aboutcss = new HtmlLink();
            Aboutcss.Href = Root.Domain + "/About/CSS/about.css";
            Aboutcss.Attributes["rel"] = "stylesheet";
            Aboutcss.Attributes["type"] = "text/css";
            Aboutcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Aboutcss);

            HtmlLink UCSFcss = new HtmlLink();
            UCSFcss.Href = Root.Domain + "/About/CSS/UCSF.css";
            UCSFcss.Attributes["rel"] = "stylesheet";
            UCSFcss.Attributes["type"] = "text/css";
            UCSFcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(UCSFcss);

            HtmlGenericControl UCSFjs = new HtmlGenericControl("script");
            UCSFjs.Attributes.Add("type", "text/javascript");
            UCSFjs.Attributes.Add("src", Root.Domain + "/About/JavaScript/UCSF.js");
            Page.Header.Controls.Add(UCSFjs);
        }
    }
}
