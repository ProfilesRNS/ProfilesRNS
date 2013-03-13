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
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;
using System.Xml.Xsl;
using System.Globalization;

using Profiles.Edit.Utilities;
using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Edit.Modules.EditObjectTypeProperty
{
    public partial class EditObjectTypeProperty : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["pnlAddBySearch.Visible"] = null;
                Session["pnlAddByURI.Visible"] = null;
                Session["pnlAddNew.Visible"] = null;
            }
            DrawProfilesModule();
            
        }
        public EditObjectTypeProperty() { }
        public EditObjectTypeProperty(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

            Edit.Utilities.DataIO data;
            SessionManagement sm = new SessionManagement();

            Profiles.Profile.Utilities.DataIO propdata = new Profiles.Profile.Utilities.DataIO();
            data = new Profiles.Edit.Utilities.DataIO();

            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            this.PredicateURI = Request.QueryString["predicateuri"].Replace("!", "#");

            GetSubjectProfile();

            this.PropertyListXML = propdata.GetPropertyList(this.BaseData, base.PresentationXML, PredicateURI, false, true, false);
            this.PropertyLabel = PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@Label").Value;
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + this.PropertyLabel + "</b>";


            securityOptions.Subject = this.SubjectID;
            securityOptions.PredicateURI = PredicateURI;
            this.PredicateID = data.GetStoreNode(this.PredicateURI);
            securityOptions.PrivacyCode = Convert.ToInt32(this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@ViewSecurityGroup").Value);
            securityOptions.SecurityGroups = new XmlDataDocument();
            securityOptions.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

        }
        public void LoadEntityGrid(bool reload)
        {
            if (reload)
                GetSubjectProfile();


            List<EntityState> es = new List<EntityState>();

            foreach (XmlNode entity in base.BaseData.SelectNodes("rdf:RDF/rdf:Description/" + this.PropertyListXML.SelectSingleNode("PropertyList/PropertyGroup/Property/@TagName").Value + "/@rdf:resource", base.Namespaces))
            {
                try
                {
                    es.Add(new EntityState(base.BaseData.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + entity.Value + "']/rdfs:label", base.Namespaces).InnerText,
                        entity.Value));
                }
                catch (Exception ex) { }
            }

            if (es.Count > 0)
            {
                gridEntities.DataSource = es;
                gridEntities.DataBind();
                lblNoItems.Visible = false;
                gridEntities.Visible = true;
            }
            else
            {
                gridEntities.Visible = false;
                lblNoItems.Text = "<i>No items have been added.</i>";
                lblNoItems.Visible = true;
            }

        }
        public void DrawProfilesModule()
        {
            Framework.Utilities.DataIO data = new Profiles.Framework.Utilities.DataIO();

            if (Request.Form["hdnSelectedURI"] != string.Empty && Request.Form["hdnSelectedURI"] != null)
            {

                Edit.Utilities.DataIO editdata = new Profiles.Edit.Utilities.DataIO();

                string newentity = string.Empty;

                newentity = Request.Form["hdnSelectedURI"].Trim();

                Int64 _object = Convert.ToInt64(editdata.GetStoreNode(newentity));

                editdata.AddExistingEntity(this.SubjectID, this.PredicateID, _object);
                Session["pnlAddBySearch.Visible"] = null;
                this.LoadEntityGrid(true);

            }
            else
            {
                LoadEntityGrid(false);
            }

            XmlDocument list = data.GetPropertyRangeList(this.PredicateURI);
            List<GenericListItem> propertylist = new List<GenericListItem>();
            string space = string.Empty;


            foreach (XmlNode property in list.SelectNodes("PropertyRangeList/PropertyRange"))
            {
                for (int i = 0; i < Convert.ToInt16(property.SelectSingleNode("@Depth").Value); i++)
                {
                    space += Server.HtmlDecode("&nbsp;&nbsp;&nbsp;");
                }
                propertylist.Add(new GenericListItem(space + property.SelectSingleNode("@Label").Value, property.SelectSingleNode("@ClassURI").Value));
                space = string.Empty;
            }

            PropertyList = propertylist;

            if (ddlPropertyList.SelectedValue == string.Empty)
            {
                ddlPropertyList.DataSource = propertylist;
                ddlPropertyList.DataTextField = "Text";
                ddlPropertyList.DataValueField = "Value";
                ddlPropertyList.DataBind();
                ddlPropertyList.Items.Insert(0, new ListItem("--- Select ---", ""));
                ddlPropertyList.SelectedValue = "";
                ddlPropertyList.EnableViewState = true;

            }

            if (ddlAddNewPropertyList.SelectedValue == string.Empty)
            {
                ddlAddNewPropertyList.DataSource = propertylist;
                ddlAddNewPropertyList.DataTextField = "Text";
                ddlAddNewPropertyList.DataValueField = "Value";
                ddlAddNewPropertyList.DataBind();
                ddlAddNewPropertyList.Items.Insert(0, new ListItem("--- Select ---", ""));
                ddlAddNewPropertyList.SelectedValue = "";
                ddlAddNewPropertyList.EnableViewState = true;
            }

        }

        protected void cmdAddNew_OnClick(object sender, ImageClickEventArgs e)
        {
            AddNewEntity();
        }
        protected void cmdAddNewCancel_onclick(object sender, ImageClickEventArgs e)
        {
            pnlAddNew.Visible = false;
            imgAddNew.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
            ShowAllPanels();
        }

        protected void ibUp_Click(object sender, EventArgs e)
        {
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            gridEntities.EditIndex = -1;
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            Int64 _object = Convert.ToInt64(data.GetStoreNode(gridEntities.DataKeys[row.RowIndex].Values[0].ToString()));

            data.MoveTripleDown(this.SubjectID, this.PredicateID, _object);

            this.LoadEntityGrid(true);

            upnlEditSection.Update();


        }

        protected void ibDown_Click(object sender, EventArgs e)
        {

            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            gridEntities.EditIndex = -1;
            GridViewRow row = ((ImageButton)sender).Parent.Parent as GridViewRow;
            Int64 _object = Convert.ToInt64(data.GetStoreNode(gridEntities.DataKeys[row.RowIndex].Values[0].ToString()));

            data.MoveTripleUp(this.SubjectID, this.PredicateID, _object);

            this.LoadEntityGrid(true);
            upnlEditSection.Update();

        }

        protected void gridEntities_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            Int64 _object = Convert.ToInt64(data.GetStoreNode(gridEntities.DataKeys[e.RowIndex].Values[0].ToString()));

            data.DeleteTriple(this.SubjectID, this.PredicateID, _object);
            this.LoadEntityGrid(true);

            upnlEditSection.Update();
        }




        protected void btnAddByURI_OnClick(object sender, EventArgs e)
        {
            pnlAddBySearch.Visible = false;
            pnlAddNew.Visible = false;


            if (Session["pnlAddByURI.Visible"] == null)
            {
                pnlAddByURI.Visible = true;
                imgAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlAddByURI.Visible"] = true;
                phAddBySearch.Visible = false;
                phAddNew.Visible = false;
                phSecuritySettings.Visible = false;
            }
            else
            {
                pnlAddByURI.Visible = false;
                imgAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlAddByURI.Visible"] = null;
                phAddBySearch.Visible = true;
                phAddNew.Visible = true;
                phSecuritySettings.Visible = true;

            }
        }
        protected void btnAddNew_OnClick(object sender, EventArgs e)
        {
            pnlAddByURI.Visible = false;
            pnlAddBySearch.Visible = false;

            if (Session["pnlAddNew.Visible"] == null)
            {
                pnlAddNew.Visible = true;
                imgAddNew.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlAddNew.Visible"] = true;
                phAddBySearch.Visible = false;
                phAddByURL.Visible = false;
                phSecuritySettings.Visible = false;
            }
            else
            {
                pnlAddNew.Visible = false;
                imgAddNew.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlAddNew.Visible"] = null;
                phAddBySearch.Visible = true;
                phAddByURL.Visible = true;
                phSecuritySettings.Visible = true;
            }
        }
        protected void btnAddBySearch_OnClick(object sender, EventArgs e)
        {
            pnlAddByURI.Visible = false;
            pnlAddNew.Visible = false;

            if (Session["pnlAddBySearch.Visible"] == null)
            {
                pnlAddBySearch.Visible = true;
                imgAddSearch.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                Session["pnlAddBySearch.Visible"] = true;
                phAddByURL.Visible = false;
                phAddNew.Visible = false;
                phSecuritySettings.Visible = false;
            }
            else
            {
                pnlAddBySearch.Visible = false;
                imgAddSearch.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
                Session["pnlAddBySearch.Visible"] = null;
                phAddByURL.Visible = true;
                phAddNew.Visible = true;
                phSecuritySettings.Visible = true;
            }
        }


        protected void cmdSearch_OnClick(object sender, EventArgs e)
        {
            pnlAddBySearch.Visible = true;
            pnlAddByURI.Visible = false;

            if (ddlPropertyList.SelectedValue != string.Empty)
                Search();

            Session["search"] = true;
        }

        private void Search()
        {
            XmlDocument searchresults;

            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();

            List<EntityState> es = new List<EntityState>();

            string searchuri = string.Empty;

            searchuri = ddlPropertyList.SelectedValue;

            searchresults = data.Search(data.SearchRequest(txtKeyword.Text.Trim(),"false", "", searchuri, "100", "0"), true);

            foreach (XmlNode x in searchresults.SelectNodes("SearchResults/Network/Connection"))
            {
                es.Add(new EntityState(x.InnerText, x.SelectSingleNode("@URI").Value));
            }

            gridSearchResults.DataSource = es;
            gridSearchResults.DataBind();
            pnlProxySearchResults.Visible = true;

        }

        #region "Add By URI"

        protected void cmdSaveByURI_onclick(object sender, ImageClickEventArgs e)
        {
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();

            if (txtURI.Text.ToLower().Trim() != string.Empty)
            {
                string uri = string.Empty;
                bool validuri = false;
                bool urifound = false;
                XmlNamespaceManager nmsmanager = null;                

                pnlAddByURI.Visible = false;



                    //you need to get back the actual URI that is discovered during the post.  
                    //The post might be to an HTML document where I have to look for an alt link to RDF data.
                    //Plus the URI we get back from this method needs to be used to create a triple in our Database so dont lose it.
                    XmlDocument rtndata = data.GetURIRelLink(txtURI.Text.Trim(), ref uri);

                    if (rtndata.InnerXml != string.Empty)
                        urifound = true;

                    if (urifound)
                    {
                        Framework.Utilities.Namespace namespaces = new Namespace();
                        nmsmanager = namespaces.LoadNamespaces(rtndata);

                        if (rtndata.SelectSingleNode("rdf:RDF/rdf:Description/rdf:type[@rdf:resource='" + PropertyList[0].Value + "']", nmsmanager) != null)
                            validuri = true;
                    }

                    if (uri.Trim() != string.Empty)
                    {
                        litAddByURIConfirmLabel.Text = rtndata.SelectSingleNode("rdf:RDF/rdf:Description[@rdf:about='" + uri + "']/rdfs:label", nmsmanager).InnerText;
                        hdnURI.Value = uri;
                    }
                    else
                    {
                        litAddByURIConfirmLabel.Text = txtURI.Text.Trim();
                        hdnURI.Value = txtURI.Text.Trim();

                    }

                    if (validuri)
                        litAddByURIConfirmType.Text = PropertyList[0].Text;
                    else if (!urifound)
                        litAddByURIConfirmType.Text = "The item could not be found. Do you still want to add this URL?";
                    else if (!validuri)
                        litAddByURIConfirmType.Text = "The item type is invalid. Do you want to add this item anyway?";


                    pnlAddByURIConfirm.Visible = true;
                    pnlAddBySearch.Visible = false;
                    pnlAddNew.Visible = false;
                    pnlAddByURI.Visible = false;
                    phAddBySearch.Visible = false;
                    phAddNew.Visible = false;
                    phAddByURL.Visible = true;
                    imgAddArror.ImageUrl = "~/Framework/Images/icon_squareDownArrow.gif";
                    Session["pnlAddByURI.Visible"] = true;

                }

                      
        }
        protected void cmdSaveByURICancel_onclick(object sender, ImageClickEventArgs e)
        {
            pnlAddByURI.Visible = false;
            imgAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
            ShowAllPanels();
        }

        protected void cmdSaveByURIConfirm_onclick(object sender, ImageClickEventArgs e)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();

            //   data.AddNewEntity("", this.PredicateURI);

            // Cant get the lable to match the URI.


            SaveEntityByURI(hdnURI.Value.Trim());
            ShowAllPanels();
            this.LoadEntityGrid(true);



        }
        protected void cmdSaveByURIConfirmCancel_onclick(object sender, ImageClickEventArgs e)
        {
            pnlAddByURIConfirm.Visible = false;
            imgAddArror.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
            ShowAllPanels();
        }


        #endregion


        protected void cmdSearchCancel_onclick(object sender, ImageClickEventArgs e)
        {
            pnlAddBySearch.Visible = false;
            ShowAllPanels();
            imgAddSearch.ImageUrl = "~/Framework/Images/icon_squareArrow.gif";
        }



        protected void gridEntities_RowDataBound(Object sender, GridViewRowEventArgs e)
        {

            switch (e.Row.RowType)
            {
                case DataControlRowType.Header:

                    e.Row.Cells[0].Text = this.PropertyLabel;
                    break;
                case DataControlRowType.DataRow:
                    HiddenField hdf = (HiddenField)e.Row.FindControl("hdnURI");
                    hdf.Value = ((EntityState)e.Row.DataItem).URI;

                    e.Row.Cells[0].Text = "<a href='" + hdf.Value + "'>" + e.Row.Cells[0].Text + "</a>";

                    break;

            }
        }

        protected void gridSearchResults_RowDataBound(Object sender, GridViewRowEventArgs e)
        {
            switch (e.Row.RowType)
            {
                case DataControlRowType.DataRow:

                    HiddenField hdnURI = (HiddenField)e.Row.FindControl("hdnURI");
                    hdnURI.Value = ((EntityState)e.Row.DataItem).URI;

                    if (e.Row.RowState == DataControlRowState.Alternate)
                    {
                        e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                        e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,0);");
                        e.Row.Attributes.Add("class", "evenRow");
                    }
                    else
                    {
                        e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                        e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,1);");
                        e.Row.Attributes.Add("class", "oddRow");
                    }

                    e.Row.Attributes["onclick"] = "JavaScript:EntitySelected('" + hdnURI.Value + "')";
                    e.Row.Cells[0].Attributes.Add("style", "border-left:#999 1px solid;padding-left:6px;");
                    e.Row.Cells[1].Attributes.Add("style", "border-right:#999 1px solid;padding-left:6px;");

                    break;
                case DataControlRowType.Footer:

                    e.Row.Style.Add("style", "border:none");
                    break;
                case DataControlRowType.Header:

                    e.Row.Style.Add("style", "border-right:#999 1px solid;border-left:#999 1px solid;border-top:#999 1px solid;");
                    break;
            }
        }

        protected void gridSearchResults_SelectedIndexChanged(object sender, EventArgs e)
        {

            GridViewRow row = gridSearchResults.SelectedRow;
            HiddenField hd = (HiddenField)row.FindControl("hdnURI");
            this.SaveEntityByURI(hd.Value);
            this.LoadEntityGrid(true);

        }

        private void SaveEntityByURI(string uri)
        {
            Int64 objectid = 0;
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            objectid = data.GetStoreNode(uri.Trim());

            Session["pnlAddBySearch.Visible"] = null;
            Session["pnlAddByURI.Visible"] = null;

            data.AddExistingEntity(SubjectID, PredicateID, objectid);

            this.LoadEntityGrid(true);
        }
        private void AddNewEntity()
        {

            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            string newentity = txtNewEntity.Text.Trim();
            string entityclassuri = ddlAddNewPropertyList.SelectedValue.Trim();

            Session["pnlAddBySearch.Visible"] = null;
            Session["pnlAddByURI.Visible"] = null;
            Int64 entityid = 0;
            entityid = data.AddNewEntity(newentity, entityclassuri);

            data.AddExistingEntity(this.SubjectID, this.PredicateID, entityid);

            this.LoadEntityGrid(true);

        }

        private void ShowAllPanels()
        {
            phSecuritySettings.Visible = true;
            phAddByURL.Visible = true;
            phAddBySearch.Visible = true;

            Session["pnlAddBySearch.Visible"] = null;
            Session["pnlAddByURI.Visible"] = null;
            Session["pnlAddNew.Visible"] = null;
        }

        private Int64 SubjectID { get; set; }
        private Int64 PredicateID { get; set; }
        private string PredicateURI { get; set; }
        private XmlDocument PropertyListXML { get; set; }

        private Int32 TotalRowCount { get; set; }
        private Int32 CurrentPage { get; set; }
        private Int32 TotalPages { get; set; }
        private Int64 Subject { get; set; }
        private Int32 Offset { get; set; }
        private string PropertyLabel { get; set; }

        private List<GenericListItem> PropertyList { get; set; }

        private class EntityState
        {

            public EntityState(string label, string uri)
            {
                this.Label = label;
                this.URI = uri;
            }
            public string Label { get; set; }
            public string URI { get; set; }



        }










    }
}