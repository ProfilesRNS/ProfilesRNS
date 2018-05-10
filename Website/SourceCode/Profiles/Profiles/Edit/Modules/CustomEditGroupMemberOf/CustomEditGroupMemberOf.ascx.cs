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
using System.Xml;

using Profiles.Framework.Utilities;

namespace Profiles.Edit.Modules.CustomEditGroupMemberOf
{
    public partial class CustomEditGroupMemberOf : BaseModule
    {
        SessionManagement session;

        Edit.Utilities.DataIO data;
        Profile.Utilities.DataIO propdata;
        private ModulesProcessing mp;
          
        override protected void OnInit(EventArgs e)
        {
            string method = string.Empty;

            session = new SessionManagement();

            DrawProfilesModule();

        }

        protected void Page_Load(object sender, EventArgs e)
        {


        }

        public CustomEditGroupMemberOf() : base() { }
        public CustomEditGroupMemberOf(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            this.XMLData = pagedata;

            data = new Edit.Utilities.DataIO();
            propdata = new Profiles.Profile.Utilities.DataIO();

            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);
            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else
                Response.Redirect(Root.Domain + "/search");

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

        }
        private void DrawProfilesModule()
        {
       
            this.EntityName = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").InnerText;
            this.TagName = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@TagName").Value;
     
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + EntityName + "</b>";

     
        }
      
        private string EntityName { get; set; }
        private string TagName { get; set; }
        private Int64 SubjectID { get; set; }
        private XmlDocument XMLData { get; set; }
        private XmlDocument PropertyListXML { get; set; }


     

    }
}