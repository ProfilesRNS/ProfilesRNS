/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/

using System;
using System.Web.UI;
using System.Xml;
using System.Web.UI.HtmlControls;

using Profiles.Framework.Utilities;

namespace Profiles.GroupAdmin
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;
            this.LoadAssets();
            SessionManagement sm = new SessionManagement();
            Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();
            if (data.IsGroupAdmin(sm.Session().UserID))
            {
                masterpage.Tab = "";
                masterpage.RDFData = null;
                XmlDocument presentationxml = new XmlDocument();
                presentationxml.LoadXml(System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/GroupAdmin/PresentationXML/GroupAdminPresentation.xml"));
                masterpage.PresentationXML = presentationxml;
            }
            else
            {
                masterpage.Tab = "";
                masterpage.RDFData = null;
                XmlDocument presentationxml = new XmlDocument();
                presentationxml.LoadXml(System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/GroupAdmin/PresentationXML/GroupAdminAuthFailedPresentation.xml"));
                masterpage.PresentationXML = presentationxml;
            }
        }

        private void LoadAssets()
        {
            HtmlLink Aboutcss = new HtmlLink();
            Aboutcss.Href = Root.Domain + "/GroupAdmin/CSS/GroupAdmin.css";
            Aboutcss.Attributes["rel"] = "stylesheet";
            Aboutcss.Attributes["type"] = "text/css";
            Aboutcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Aboutcss);
        }
    }
}
