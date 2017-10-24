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

namespace Profiles.ProfileDetailsError
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;
            this.LoadAssets();

            masterpage.Tab = "";
            masterpage.RDFData = null;
            XmlDocument presentationxml = new XmlDocument();
            presentationxml.LoadXml(System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/ProfileDetailsError/PresentationXML/ProfileDetailsErrorPresentation.xml"));
            masterpage.PresentationXML = presentationxml;

        }

        private void LoadAssets()
        {
            HtmlLink ProfileDetailsErrorcss = new HtmlLink();
            ProfileDetailsErrorcss.Href = Root.Domain + "/ProfileDetailsError/CSS/ProfileDetailsError.css";
            ProfileDetailsErrorcss.Attributes["rel"] = "stylesheet";
            ProfileDetailsErrorcss.Attributes["type"] = "text/css";
            ProfileDetailsErrorcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(ProfileDetailsErrorcss);
        }
    }
}
