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


namespace Profiles.ActiveNetwork
{
    public partial class Default : System.Web.UI.Page
    {
        private Profiles.Framework.Template masterpage;

        protected void Page_Load(object sender, EventArgs e)
        {
            masterpage = (Framework.Template)base.Master;

            this.LoadAssets();

            this.LoadPresentationXML();

            masterpage.PresentationXML = this.PresentationXML;
        }

        private void LoadAssets()
        {

        }

        public void LoadPresentationXML()
        {
            string presentationxml = string.Empty;

            presentationxml = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "/ActiveNetwork/PresentationXML/MyNetwork.xml");
            
            this.PresentationXML = new XmlDocument();
            this.PresentationXML.LoadXml(presentationxml);
            Framework.Utilities.DebugLogging.Log(presentationxml);

        }
        public XmlDocument PresentationXML { get; set; }
        public Profiles.Framework.Template Master { get; set; }
    }
}
