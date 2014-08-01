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


namespace Profiles.ORCID.Modules.CustomEditORCID
{
    public partial class CustomEditORCID : BaseModule, IPostBackEventHandler
    {

        protected global::Profiles.ORCID.Modules.CreateMyORCID.CreateMyORCID CreateMyORCID1;

        Edit.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["pnlInsertAward.Visible"] = null;
                Session["pnlCreateMyORCID.Visible"] = null;
                Session["pnlProvideMyORCID.Visible"] = null;
            }
            else
                loadSessionState();
        }


        private void loadSessionState()
        {
            if (Session["pnlCreateMyORCID.Visible"] != null) pnlCreateMyORCID.Visible = true;
            if (Session["pnlProvideMyORCID.Visible"] != null) pnlProvideMyORCID.Visible = true;
        }

        public CustomEditORCID() : base() { }
        public CustomEditORCID(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            SessionManagement sm = new SessionManagement();
            this.XMLData = pagedata;

            data = new Edit.Utilities.DataIO();
            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, predicateuri, false, true, false);

            this.PredicateID = data.GetStoreNode(predicateuri);

            base.GetNetworkProfile(this.SubjectID, this.PredicateID);

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";


            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            securityOptions.BubbleClick += SecurityDisplayed;
            string orcidHelpLink = string.Empty;
            string orcidInfoSite = Profiles.ORCID.Utilities.config.InfoSite;
            if (!string.IsNullOrEmpty(orcidInfoSite))
            {
                orcidHelpLink = "&nbsp;<a style='border: none;' href='" + orcidInfoSite + "' target='_blank'><img style='border-style: none' src='" + Root.Domain + "/Framework/Images/info.png'  border='0'></a>";
            }
            //litCreateProvideORCID.Text = "<img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/>&nbsp;<a href='" + Root.Domain + "/ORCID/CreateMyORCID.aspx'>Create My ORCID</a>" + orcidHelpLink + "<br><img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/>&nbsp;<a href='" + Root.Domain + "/ORCID/ProvideORCID.aspx'>Provide My ORCID</a>" + orcidHelpLink;
            //litUploatInfoToORCID.Text = "<img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/>&nbsp;<a href='" + Root.Domain + "/ORCID/UploadInfoToORCID.aspx'>Upload Info To ORCID</a>";
            string loggedInInternalUsername = new Profiles.ORCID.Utilities.DataIO().GetInternalUserID();
            //Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.Person().GetByInternalUsername(loggedInInternalUsername);

            lbCreateMyORCID.Text = "Create ORCID" + orcidHelpLink;
            lbProvideMyORCID.Text = "Provide My ORCID" + orcidHelpLink;

            String orcid = null;
            try { orcid = base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description/vivo:orcidId", base.Namespaces).InnerText; }
            catch (Exception ex) { }

            if (orcid == null)
            {
                pnlAddORCID.Visible = true;
                pnlEditORCID.Visible = false;
                orcidtable.Visible = false;
                pnlORCIDProxy.Visible = false;
            }
            else
            {
                litORCIDID.Text = "<a href='" + Profiles.ORCID.Utilities.config.ORCID_URL + "/" + orcid + "'>" + orcid + "</a>";
                pnlAddORCID.Visible = false;
                pnlEditORCID.Visible = true;
                orcidtable.Visible = true;
                pnlORCIDProxy.Visible = false;
            }

            if (Profiles.ORCID.Utilities.DataIO.getNodeIdFromInternalUserName(loggedInInternalUsername) != this.SubjectID)
            {
                pnlORCIDProxy.Visible = true;
                imbProvideMyORCID.Visible = false;
                lbProvideMyORCID.Visible = false;
                imbUploadToORCID.Visible = false;
                lbUploadToORCID.Visible = false;
            }

            if (data.GetSessionSecurityGroup() == -50)
            {
                pnlORCIDAdmin.Visible = true;
                litORCIDAdmin.Text = "<img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/>&nbsp;<a href='" + Root.Domain + "/ORCID/CreateBatch.aspx'>Batch Upload</a><br><img src='" + Root.Domain + "/framework/images/icon_squareArrow.gif' border='0'/>&nbsp;<a href='" + Root.Domain + "/ORCID/UpdateSecurityGroupDefaultDecisions.aspx'>ORCID Privacy Mapping</a></li>";
            }

        }

        #region Awards

        private void SecurityDisplayed(object sender, EventArgs e)
        {
        }


        protected void imbCreateMyORCID_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlCreateMyORCID.Visible"] == null)
            {
                pnlCreateMyORCID.Visible = true;
                imbCreateMyORCID.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlCreateMyORCID.Visible"] = true;
                Session["pnlProvideMyORCID.Visible"] = null;
                imbProvideMyORCID.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                imbProvideMyORCID.Visible = false;
                lbProvideMyORCID.Visible = false;
                pnlProvideMyORCID.Visible = false;
            }
            else
            {
                pnlCreateMyORCID.Visible = false;
                imbCreateMyORCID.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlCreateMyORCID.Visible"] = null;
                imbProvideMyORCID.Visible = true;
                lbProvideMyORCID.Visible = true;
            }
        }

        protected void imbProvideMyORCID_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlProvideMyORCID.Visible"] == null)
            {
                pnlProvideMyORCID.Visible = true;
                imbProvideMyORCID.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlProvideMyORCID.Visible"] = true;
                Session["pnlCreateMyORCID.Visible"] = null;
                imbCreateMyORCID.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                imbCreateMyORCID.Visible = false;
                lbCreateMyORCID.Visible = false;
                pnlCreateMyORCID.Visible = false;
            }
            else
            {
                pnlProvideMyORCID.Visible = false;
                imbProvideMyORCID.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlProvideMyORCID.Visible"] = null;
                imbCreateMyORCID.Visible = true;
                lbCreateMyORCID.Visible = true;
            }
        }

        protected void imbUploadToORCID_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlUploadToORCID.Visible"] == null)
            {
                pnlUploadToORCID.Visible = true;
                imbUploadToORCID.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlUploadToORCID.Visible"] = true;
            }
            else
            {
                pnlUploadToORCID.Visible = false;
                imbUploadToORCID.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlUploadToORCID.Visible"] = null;
            }
        }

        protected void btnSubmitToORCID_Click(object sender, EventArgs e)
        {
            String LoggedInInternalUsername = new Profiles.ORCID.Utilities.DataIO().GetInternalUserID();
            try
            {
                if (UploadInfoToORCID1.ResearchExpertiseAndProfessionalInterests.Length > 5000)
                {
                    UploadInfoToORCID1.ResearchExpertiseAndProfessionalInterestsErrors += "Error! Biography cannot be longer then 5000 characters";
                    return;
                }
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BO.ORCID.Person person = UploadInfoToORCID1.GetPersonWithPageData();
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage personMessageBLL = new Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.PersonMessage();
                personMessageBLL.CreateUploadMessages(person, LoggedInInternalUsername);
                Response.Redirect("~/ORCID/default.aspx");
                return;
            }
            catch (Exception ex)
            {
                lblErrorsUpload.Text = ex.Message;
                Profiles.ORCID.Utilities.ProfilesRNSDLL.BLL.ORCID.ErrorLog.LogError(ex, LoggedInInternalUsername);
            }
        }

        #endregion

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private XmlDocument XMLData { get; set; }
        private XmlDocument PropertyListXML { get; set; }





        public void RaisePostBackEvent(string eventArgument)
        {
            throw new NotImplementedException();
        }
    }
}