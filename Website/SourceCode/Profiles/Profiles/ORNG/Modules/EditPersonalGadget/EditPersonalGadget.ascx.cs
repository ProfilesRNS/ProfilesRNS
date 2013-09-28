﻿/*  
 
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
using Profiles.ORNG.Utilities;
using System.Web.UI.HtmlControls;


namespace Profiles.ORNG.Modules.Gadgets
{

    public partial class EditPersonalGadget : BaseModule
    {
        private OpenSocialManager om;
        private string uri;
        private int appId;
        private PreparedGadget gadget;
        private Profiles.ORNG.Utilities.DataIO data;

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

            data = new Profiles.ORNG.Utilities.DataIO();
            Profiles.Edit.Utilities.DataIO editdata = new Profiles.Edit.Utilities.DataIO();
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
            base.RDFTriple = new RDFTriple(this.SubjectID, editdata.GetStoreNode(this.PredicateURI));

            base.RDFTriple.Expand = true;
            base.RDFTriple.ShowDetails = true;
            base.GetDataByURI();//This will reset the data to a Network.

            // Profiles OpenSocial Extension by UCSF
            uri = this.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/@rdf:about", base.Namespaces).Value;
            uri = uri.Substring(0, uri.IndexOf(Convert.ToString(this.SubjectID)) + Convert.ToString(this.SubjectID).Length);
            appId = Convert.ToInt32(base.GetModuleParamString("AppId"));
            om = OpenSocialManager.GetOpenSocialManager(uri, Page, true);
            gadget = om.AddGadget(appId, base.GetModuleParamString("View"), base.GetModuleParamString("OptParams"));

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = this.PredicateURI;
            securityOptions.PrivacyCode = data.HasPersonalGadget(uri, appId) ?
                Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value) : 0;
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

        }

        private void DrawProfilesModule()
        {
            if (gadget == null || !om.IsVisible())
            {
                pnlSecurityOptions.Visible = false;
                litGadget.Text = "This feature is currently turned off on your system";
            }
            else if (gadget.RequiresRegistration() && !data.IsRegistered(uri, appId))
            {
                pnlSecurityOptions.Visible = false;
                litGadget.Text = gadget.GetUnavailableMessage();
            }
            else 
            {
                litGadget.Text = "<div id='" + gadget.GetChromeId() + "' class='gadgets-gadget-parent'></div>";
                om.LoadAssets();
            }
        }


        public Int64 SubjectID { get; set; }
        public XmlDocument PropertyListXML { get; set; }
        public string PredicateURI { get; set; }

    }

}