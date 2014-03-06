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

    public partial class ViewPersonalGadget : BaseModule
    {
        private OpenSocialManager om;
        private string uri = null;
        private PreparedGadget gadget;

        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public ViewPersonalGadget() : base() { }

        public ViewPersonalGadget(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            // code to convert from numeric node ID to URI
            if (base.Namespaces.HasNamespace("rdf"))
            {
                XmlNode node = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces);
                uri = node != null ? node.Value : null;
            }
            om = OpenSocialManager.GetOpenSocialManager(uri, Page);
            gadget = om.AddGadget(Convert.ToInt32(base.GetModuleParamString("AppId")), base.GetModuleParamString("View"), base.GetModuleParamString("OptParams"));
            new LimitResponder(this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/foaf:firstName", base.Namespaces).InnerText, Page);  // for some reason doing this in DrawProfilesModule (remove that???) fails!
            new PersonResponder(uri, Page);  // for some reason doing this in DrawProfilesModule (remove that???) fails!
        }

        private void DrawProfilesModule()
        {
            // UCSF OpenSocial items
            if (gadget != null && om.IsVisible())
            {
                litGadget.Text = "<div id='" + gadget.GetChromeId() + "' class='gadgets-gadget-parent'></div>";
                om.LoadAssets();
            }
        }

        public class LimitResponder : ORNGCallbackResponder
        {
            string name;

            public LimitResponder(string name, Page page)
                : base(null, page, false, ORNGCallbackResponder.CURRENT_PAGE_ITEMS_METADATA)
            {
                this.name = name;
            }

            public override string getCallbackResponse()
            {
                return name;
            }
        }

        public class PersonResponder : ORNGCallbackResponder
        {
            string uri;

            public PersonResponder(string uri, Page page)
                : base(uri, page, false, ORNGCallbackResponder.CURRENT_PAGE_ITEMS)
            {
                this.uri = uri;
            }

            public override string getCallbackResponse()
            {
                return BuildJSONPersonIds(uri, "one person");
            }
        }

    }

}