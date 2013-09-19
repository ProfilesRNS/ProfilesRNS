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
using System.Collections;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Globalization;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using Profiles.Edit.Utilities;
using Profiles.ORNG.Utilities;


namespace Profiles.ORNG.Modules.Gadgets
{

    public partial class ViewOntologyGadget : BaseModule
    {
        private OpenSocialManager om;
        private string chromeId;

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public ViewOntologyGadget() : base() { }

        public ViewOntologyGadget(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            // UCSF OpenSocial items
            string uri = null;
            // code to convert from numeric node ID to URI
            if (base.Namespaces.HasNamespace("rdf"))
            {
                XmlNode node = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces);
                uri = node != null ? node.Value : null;
            }
            new Responder(uri, Page);
            om = OpenSocialManager.GetOpenSocialManager(uri, Page, false, true);
            chromeId = om.AddGadget(base.GetModuleParamString("GadgetName"), base.GetModuleParamString("View"), base.GetModuleParamString("OptParams"));
        }

        private void DrawProfilesModule()
        {
            litGadgetDiv.Text = "<div id='" + chromeId + "' class='gadgets-gadget-parent'></div>";
            om.LoadAssets();
            //litEmailAddress.Text = this.Email;
        }
    }

    public class Responder : ORNGCallbackResponder
    {
        string uri;

        public Responder(string uri, Page page)
            : base(uri, page, false, ORNGCallbackResponder.JSON_PERSONID_REQ)
        {
            this.uri = uri;
        }

        public override string getCallbackResponse()
        {
            return BuildJSONPersonIds(uri, "one person");
        }
    }

}