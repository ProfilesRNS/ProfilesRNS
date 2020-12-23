using System;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;
using System.Globalization;
using Profiles.Edit.Utilities;
using System.Web.UI.HtmlControls;
using System.Configuration;

namespace Profiles.Edit.Modules.CustomEditSummary
{
    public partial class CustomEditSummary : BaseModule
    {
        Edit.Utilities.DataIO data;
        Profiles.Profile.Utilities.DataIO propdata;
        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private string PredicateURI { get; set; }

        private XmlDocument XMLData { get; set; }

        private XmlDocument PropertyListXML { get; set; }
        private string PropertyLabel { get; set; }
        private string MaxCardinality { get; set; }
        private string MinCardinality { get; set; }

        private string OriginalSummary { get; set; }


        protected void Page_Load(object sender, EventArgs e)
        {
            //In terms of WebForms lifecycle, this stuff gets called second
            // so here, we can make some decisions about whether we're loading fresh or posting back from a control
            if (!IsPostBack)
            {
                Session["pnlEditSummary.Visible"] = null;
            }
            else
            {
                // there are probably some postback behavior we want to take here, like when Save is invoked
            }

            // either way, we almost always have to assemble the stuff that will be used on the Form
        }

        public CustomEditSummary() { }
        public CustomEditSummary(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {
            //In terms of WebForms lifecycle, this stuff gets called first since
            // this class gets instantiated with each request

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            //appears this isn't really used
            SessionManagement sm = new SessionManagement();


            //initialize data access in the edit namespace
            data = new Profiles.Edit.Utilities.DataIO();

            //this is plucked off the querystring
            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            this.PredicateURI = predicateuri;

            this.initializeForm();

            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = predicateuri;
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);
        }

        protected void btnEditProperty_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlEditSummary.Visible"] != null)
            {
                Session["pnlEditSummary.Visible"] = null;
                pnlEditSummary.Visible = false;
                pnlViewSummary.Visible = true;
                pnlEditButton.Visible = true;
                pnlSaveCancel.Visible = false;
            }
            else
            {
                pnlEditSummary.Visible = true;
                pnlViewSummary.Visible = false;
                pnlEditButton.Visible = false;
                pnlSaveCancel.Visible = true;
                Session["pnlEditSummary.Visible"] = true;
            }
            upnlEditSection.Update();
        }

        protected void btnSave_OnClick(object sender, EventArgs e)
        {
            // only really need to do this when saving
            this.PredicateID = data.GetStoreNode(this.PredicateURI);
            var hasErrors = doSaveSummery();
            if (!hasErrors)
            {
                // we need to refresh the display now that we've saved since above, it was using the values before they got into the database
                // PropertyListXML still has the old values
                this.initializeForm(true);
            }
            // update panel visibility
            updatePanels();
        }

        protected void btnCancelEdit_OnClick(object sender, EventArgs e)
        {
            // update panel visibility
            updatePanels();
        }

        private void initializeForm(bool refresh=false)
        {
            // data access in the Profiles namespace 
            propdata = new Profiles.Profile.Utilities.DataIO();

            if (refresh)
            {
                base.GetSubjectProfile();
                this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, this.PredicateURI, false, true, false);
            }
            
            // the propertylistxml has some information that is useful for deciding what property we're deling with
            // so it's good to just it early here
            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, this.PredicateURI, false, true, false);

            PropertyLabel = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value;

            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID + "'>Edit Menu</a> &gt; <b>" + PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value + "</b>";

            XmlNode connectionNode = this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/Network/Connection");
            string propertyConnectionValue = connectionNode.InnerText;
            OriginalSummary = connectionNode.InnerText;

            txtSummaryInput.Text = propertyConnectionValue;
            litSummaryText.Text = propertyConnectionValue;
        }

        private void updatePanels()
        {
            pnlEditSummary.Visible = false;
            pnlViewSummary.Visible = true;
            pnlEditButton.Visible = true;
            pnlSaveCancel.Visible = false;
            Session["pnlEditSummary.Visible"] = null;
            upnlEditSection.Update();
        }

        private bool doSaveSummery()
        {
           return data.UpdateLiteral(this.SubjectID, this.PredicateID, data.GetStoreNode(this.OriginalSummary), data.GetStoreNode(txtSummaryInput.Text.Replace("\n", "").Trim()), this.PropertyListXML);
           
        }
    }
}