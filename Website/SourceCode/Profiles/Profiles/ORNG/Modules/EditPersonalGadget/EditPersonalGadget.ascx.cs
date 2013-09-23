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

    public partial class EditPersonalGadget : BaseModule
    {
        private OpenSocialManager om;

        Edit.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public EditPersonalGadget() : base() { }
        public EditPersonalGadget(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            base.BaseData = pagedata;

            data = new Profiles.Edit.Utilities.DataIO();
            //this.Email = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:email", base.Namespaces).InnerText;


            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();


            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            this.PredicateURI = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, this.PredicateURI, false, true, false);
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";


            //create a new network triple request.
            base.RDFTriple = new RDFTriple(this.SubjectID, data.GetStoreNode(this.PredicateURI));

            base.RDFTriple.Expand = true;
            base.RDFTriple.ShowDetails = true;
            base.GetDataByURI();//This will reset the data to a Network.

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = this.PredicateURI;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
        }

        private void DrawProfilesModule()
        {
            // Profiles OpenSocial Extension by UCSF
            string uri = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces).Value;
            uri = uri.Substring(0, uri.IndexOf(Convert.ToString(this.SubjectID)) + Convert.ToString(this.SubjectID).Length);
            OpenSocialManager om = OpenSocialManager.GetOpenSocialManager(uri, Page, true, true);
            string chromeId = om.AddGadget(Convert.ToInt32(base.GetModuleParamString("AppId")), base.GetModuleParamString("View"), base.GetModuleParamString("OptParams"));
            // add the gadget, use appId
            if (om.IsVisible())
            {
                litGadget.Text = "<div id='" + chromeId + "' class='gadgets-gadget-parent'></div>";
                om.LoadAssets();
                new Responder(uri, Page);
            }
        }


        public Int64 SubjectID { get; set; }
        public XmlDocument PropertyListXML { get; set; }
        public string PredicateURI { get; set; }

        public class Responder : ORNGCallbackResponder
        {
            public Responder(string uri, Page page)
                : base(uri, page, true, ORNGCallbackResponder.CLEAR_OWNER_CACHE_REQ)
            {
            }

            public override string getCallbackResponse()
            {
                GetOpenSocialManager().ClearOwnerCache();
                return "Success";
            }
        }
    }

}