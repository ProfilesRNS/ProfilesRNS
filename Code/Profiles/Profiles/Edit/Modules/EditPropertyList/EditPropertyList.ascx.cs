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


namespace Profiles.Edit.Modules.EditPropertyList
{
    public partial class EditPropertyList : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DrawProfilesModule();
        }

        public EditPropertyList() : base() { }
        public EditPropertyList(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {

        }
        private void DrawProfilesModule()
        {
            List<GenericListItem> gli = new List<GenericListItem>();
            bool canedit = false;
            Profile.Utilities.DataIO data = new Profiles.Profile.Utilities.DataIO();
            List<List<SecurityItem>> si = new List<List<SecurityItem>>();
            List<SecurityItem> singlesi;
            this.Dropdown = new List<GenericListItem>();
            this.PropertyList = data.GetPropertyList(this.BaseData, base.PresentationXML, "", true, true, false);

            this.Subject = Convert.ToInt64(Request.QueryString["subject"]);

            this.SecurityGroups = new XmlDocument();
            this.SecurityGroups.LoadXml(base.PresentationXML.DocumentElement.LastChild.OuterXml);

            litBackLink.Text = "<b>Edit Menu</b>";


            foreach (XmlNode group in this.PropertyList.SelectNodes("//PropertyList/PropertyGroup"))
            {
                singlesi = new List<SecurityItem>();

                foreach (XmlNode node in group.SelectNodes("Property"))
                {
                    if (node.SelectSingleNode("@EditExisting").Value == "false"
                        && node.SelectSingleNode("@EditAddExisting").Value == "false"
                        && node.SelectSingleNode("@EditAddNew").Value == "false"
                        && node.SelectSingleNode("@EditDelete").Value == "false")
                    {
                        canedit = false;
                    }
                    else
                    {
                        canedit = true;
                    }

                    singlesi.Add(new SecurityItem(node.ParentNode.SelectSingleNode("@Label").Value, node.SelectSingleNode("@Label").Value,
                        node.SelectSingleNode("@URI").Value,
                        Convert.ToInt32(node.SelectSingleNode("@NumberOfConnections").Value),
                        Convert.ToInt32(node.SelectSingleNode("@ViewSecurityGroup").Value),
                        this.SecurityGroups.SelectSingleNode("SecurityGroupList/SecurityGroup[@ID='" + node.SelectSingleNode("@ViewSecurityGroup").Value + "']/@Label").Value,
                        node.SelectSingleNode("@ObjectType").Value, canedit));


                }
                si.Add(singlesi);
            }

            foreach (XmlNode securityitem in this.SecurityGroups.SelectNodes("SecurityGroupList/SecurityGroup"))
            {
                this.Dropdown.Add(new GenericListItem(securityitem.SelectSingleNode("@Label").Value,
                    securityitem.SelectSingleNode("@ID").Value));

                gli.Add(new GenericListItem(securityitem.SelectSingleNode("@Label").Value, securityitem.SelectSingleNode("@Description").Value));
            }

            repPropertyGroups.DataSource = si;
            repPropertyGroups.DataBind();

            BuildSecurityKey(gli);

        }
        protected void repPropertyGroups_OnItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
            {
                GridView grdSecurityGroups = (GridView)e.Item.FindControl("grdSecurityGroups");
                List<SecurityItem> si = (List<SecurityItem>)e.Item.DataItem;
                grdSecurityGroups.DataSource = si;
                grdSecurityGroups.DataBind();
                grdSecurityGroups.HeaderRow.Cells[0].Text = "<b>Category</b>: " + si[0].ItemLabel;
            }

        }
        protected void grdSecurityGroups_OnDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {

                DropDownList ddl = (DropDownList)e.Row.FindControl("ddlPrivacySettings");
                HiddenField hf = (HiddenField)e.Row.FindControl("hfPropertyURI");
                Label items = (Label)e.Row.FindControl("lblItems");
                Image lockimage = (Image)e.Row.FindControl("imgLock");
                Image blankimage = (Image)e.Row.FindControl("imgBlank");
                SecurityItem si = (SecurityItem)e.Row.DataItem;
                LinkButton lb = (LinkButton)e.Row.FindControl("lbUpdate");
                Literal litSetting = (Literal)e.Row.FindControl("litSetting");

                string objecttype = string.Empty;

                items.Text = si.ItemCount.ToString();

                if (!si.CanEdit)
                {
                    lockimage.Visible = true;
                    blankimage.Visible = true;
                }

                ddl.DataSource = this.Dropdown;
                ddl.DataTextField = "Text";
                ddl.DataValueField = "Value";
                ddl.DataBind();
                ddl.SelectedValue = si.PrivacyCode.ToString();
                ddl.Visible = false;
                litSetting.Text = si.PrivacyLevel;

                //ddl.Attributes.Add("onchange", "JavaScript:showstatus()");
                hf.Value = si.ItemURI;

                if (e.Row.RowState == DataControlRowState.Alternate)
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,0);");
                    e.Row.Attributes.Add("class", "evenRow");
                    blankimage.ImageUrl = Root.Domain + "/edit/images/icons_blankAlt.gif";
                    blankimage.Attributes.Add("style", "opacity:0.0;filter:alpha(opacity=0);");
                }
                else
                {
                    e.Row.Attributes.Add("onmouseover", "doListTableRowOver(this);");
                    e.Row.Attributes.Add("onmouseout", "doListTableRowOut(this,1);");
                    e.Row.Attributes.Add("class", "oddRow");
                    blankimage.ImageUrl = Root.Domain + "/edit/images/icons_blankAlt.gif";
                    blankimage.Attributes.Add("style", "opacity:0.0;filter:alpha(opacity=0);");
                }

                switch (si.ObjectType)
                {
                    case "1":
                        objecttype = "Literal";
                        break;
                    case "0":
                        objecttype = "Entity";                       
                        break;
                }

                string editlink = "javascript:GoTo('" + Root.Domain + "/edit/default.aspx?subject=" + this.Subject.ToString() + "&predicateuri=" + hf.Value.Replace("#", "!") + "&module=DisplayItemToEdit&ObjectType=" + objecttype + "')";


                e.Row.Cells[0].Attributes.Add("onclick", editlink);
                e.Row.Cells[1].Attributes.Add("onclick", editlink);
            }

        }
        protected void BuildSecurityKey(List<GenericListItem> gli)
        {
            System.Text.StringBuilder table = new StringBuilder();


            table.Append("<table style='width:100%;'>");

            foreach (GenericListItem item in gli)
            {
                table.Append("<tr style='height:25px;'>");
                table.Append("<td style='padding-left:6px;white-space:nowrap'>");
                table.Append("<p align='right'>");
                table.Append("<b>");
                table.Append(item.Text);
                table.Append("</b>");
                table.Append("</p>");
                table.Append("</td>");
                table.Append("<td style='padding-left:10px;' align='left'>");
                table.Append(item.Value);
                table.Append("</td>");
                table.Append("</tr>");
            }

            table.Append("</table>");

            litSecurityKey.Text = table.ToString();

            //ddlSetAll.DataTextField = "Text";
            //ddlSetAll.DataValueField = "Value";
            //ddlSetAll.DataSource = this.Dropdown;            
            //ddlSetAll.DataBind();
            //ddlSetAll.Enabled = false;

            //ddlSetAll.Items.Insert(0, new ListItem("-- Select One --", String.Empty));
            //ddlSetAll.SelectedIndex = 0;

        }

        protected void ddlSetAll_IndexChanged(object sender, EventArgs e)
        {
            GridView gv;
            foreach (RepeaterItem item in repPropertyGroups.Items)
            {
                gv = (GridView)item.FindControl("grdSecurityGroups");

                foreach (GridViewRow gvr in gv.Rows)
                {
                    this.PredicateURI = ((HiddenField)gvr.FindControl("hfPropertyURI")).Value;
                    //  this.UpdateSecuritySetting(ddlSetAll.SelectedValue);
                }
            }

            Response.Redirect(Root.Domain + "/edit/" + this.Subject.ToString());
        }
        protected void updateSecurity(object sender, EventArgs e)
        {
            GridViewRow grow = (GridViewRow)((Control)sender).NamingContainer;
            DropDownList hdn = (DropDownList)grow.FindControl("ddlPrivacySettings");
            HiddenField hf = (HiddenField)grow.FindControl("hfPropertyURI");
            this.PredicateURI = hf.Value;
            this.UpdateSecuritySetting(hdn.SelectedValue);
            Response.Redirect(Root.Domain + "/edit/" + this.Subject.ToString());
        }

        private void UpdateSecuritySetting(string securitygroup)
        {
            Edit.Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
            data.UpdateSecuritySetting(this.Subject, data.GetStoreNode(this.PredicateURI), Convert.ToInt32(securitygroup));
        }
        private Int64 Subject { get; set; }
        private string PredicateURI { get; set; }


        private XmlDocument PropertyList { get; set; }
        private XmlDocument SecurityGroups { get; set; }
        private List<GenericListItem> Dropdown { get; set; }

    }

    public class SecurityItem
    {
        public SecurityItem(string itemlabel, string item, string itemuri, int itemcount, int privacycode, string privacylevel, string objecttype, bool canedit)
        {
            
            this.ItemLabel = itemlabel;
            this.Item = item;
            this.ItemURI = itemuri;
            this.ItemCount = itemcount;
            this.PrivacyCode = privacycode;
            this.ObjectType = objecttype;
            this.CanEdit = canedit;
            this.PrivacyLevel = privacylevel;

        }
        public string ItemLabel { get; set; }
        public string Item { get; set; }
        public string ItemURI { get; set; }
        public int ItemCount { get; set; }
        public int PrivacyCode { get; set; }
        public string PrivacyLevel { get; set; }
        public string ObjectType { get; set; }
        public bool CanEdit { get; set; }
    }
}