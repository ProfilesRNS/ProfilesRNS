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


namespace Profiles.Edit.Modules.CustomEditMainImage
{
    public partial class CustomEditMainImage : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.DrawProfilesModule();

            if (!IsPostBack)
                Session["pnlPhoto.Visible"] = null;

        }

        public CustomEditMainImage() : base() { }
        public CustomEditMainImage(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            Edit.Utilities.DataIO data;
            SessionManagement sm = new SessionManagement();
            this.XMLData = pagedata;

            data = new Edit.Utilities.DataIO();

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            this.PredicateURI = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = data.GetPropertyList(this.BaseData, base.PresentationXML, PredicateURI, false, true, false);
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = PredicateURI;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

        }
        private void DrawProfilesModule()
        {
            if (this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/Network/Connection/@ResourceURI") != null)
            {
                imgPhoto.ImageUrl = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/Network/Connection/@ResourceURI").Value;
                lblNoImage.Visible = false;
                imgPhoto.Visible = true;
            }
            else
            {
                imgPhoto.Visible = false;
                lblNoImage.Visible = true;
            }

        }

        protected void ProcessUpload(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
        {

            System.IO.Stream stream;
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            stream = AsyncFileUpload1.PostedFile.InputStream;


            byte[] imageBytes = new byte[AsyncFileUpload1.PostedFile.InputStream.Length + 1];
            AsyncFileUpload1.PostedFile.InputStream.Read(imageBytes, 0, imageBytes.Length);

            data.SaveImage(data.GetPersonID(this.SubjectID), imageBytes);
            base.GetSubjectProfile();
            this.PropertyListXML = data.GetPropertyList(this.BaseData, base.PresentationXML, this.PredicateURI, false, true, false);
            this.DrawProfilesModule();
            upnlEditSection.Update();


        }


        private Int64 SubjectID { get; set; }
        private XmlDocument XMLData { get; set; }
        private XmlDocument PropertyListXML { get; set; }
        private string PredicateURI { get; set; }

    }
}