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
using Profiles.Search.Utilities;

namespace Profiles.Login
{
    public partial class Default : System.Web.UI.Page
    {
        Profiles.Framework.Template masterpage;

        public void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;

            LoadPresentationXML();
            this.LoadAssets();
            masterpage.PresentationXML = this.PresentationXML;

        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);

        }

        public void LoadPresentationXML()
        {
            string presentationxml = string.Empty;
            
                    presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/Login/PresentationXML/LoginFormPresentation.xml");
            

            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);

        }
        public XmlDocument PresentationXML { get; set; }

      
    }



}
