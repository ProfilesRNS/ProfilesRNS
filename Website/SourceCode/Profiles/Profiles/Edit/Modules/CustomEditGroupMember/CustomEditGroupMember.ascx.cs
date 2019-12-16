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
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Web.UI.HtmlControls;
using Profiles.Edit.Utilities;


using Profiles.Framework.Utilities;
using System.Web;

namespace Profiles.Edit.Modules.CustomEditGroupMember
{
    public partial class CustomEditGroupMember : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (IsPostBack)
            {
                if (MyDataSet.Tables.Count > 0)
                {
                    gridSearchResults.DataSource = MyDataSet;
                    gridSearchResults.DataBind();
                }
            }
            else
            {
                if (!IsPostBack)
                    Session["pnlAddGroupMembers.Visible"] = null;
            }
               
            string predicateuri = Request.QueryString["predicateuri"].Replace("!", "#");
            isManagerPage = predicateuri.Equals("http://profiles.catalyst.harvard.edu/ontology/prns#hasGroupManager");

            LoadAssets();
            DrawProfilesModule();
            if (isManagerPage) fillManagerGrid();
            else fillMemberGrid();
            
        }

        public CustomEditGroupMember() { }
        public CustomEditGroupMember(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }
        private void DrawProfilesModule()
        {
            if (Request.QueryString["subject"] != null)
                this.SubjectID = Convert.ToInt64(Request.QueryString["subject"]);
            else if (base.GetRawQueryStringItem("subject") != null)
                this.SubjectID = Convert.ToInt64(base.GetRawQueryStringItem("subject"));
            else
                Response.Redirect("~/search");

            Edit.Utilities.DataIO data2 = new Edit.Utilities.DataIO();
            Proxy.Utilities.DataIO data = new Proxy.Utilities.DataIO();
            SessionManagement sm = new SessionManagement();
            string subject = sm.Session().SessionID.ToString();


            if (sm.Session().UserID == 0)
                Response.Redirect(Root.Domain + "/search");
      
            string predicateName;
            if (isManagerPage) predicateName = "Group Managers";
            else predicateName = "Group Members";
            litBackLink.Text = "<a href='" + Root.Domain + "/edit/default.aspx?subject=" + this.SubjectID.ToString() + "'>Edit Menu</a> &gt; <b>" + predicateName + "</b>";
            btnLitAddGroupMembers.Text = "Add " + predicateName;

            if (Request.QueryString["fname"] != null)
            {
                txtFirstName.Text = Request.QueryString["fname"];
                this.Fname = Request.QueryString["fname"];
            }

            if (Request.QueryString["lname"] != null)
            {
                txtLastName.Text = Request.QueryString["lname"];
                this.Lname = Request.QueryString["lname"];
            }

            drpInstitution.DataSource = data2.GetInstitutions(isManagerPage);
            drpInstitution.DataTextField = "Text";
            drpInstitution.DataValueField = "Value";
            drpInstitution.DataBind();
            drpInstitution.Items.Insert(0, new ListItem("--Select--"));

            if (Request.QueryString["institution"] != null)
            {
                drpInstitution.SelectedIndex = drpInstitution.Items.IndexOf(drpInstitution.Items.FindByText(Request.QueryString["institution"]));
                this.Institution = Request.QueryString["institution"];
            }

            drpDepartment.DataSource = data.GetDepartments();
            drpDepartment.DataTextField = "Text";
            drpDepartment.DataValueField = "Value";
            drpDepartment.DataBind();
            drpDepartment.Items.Insert(0, new ListItem("--Select--"));

            if (Request.QueryString["department"] != null)
            {
                drpDepartment.SelectedIndex = drpDepartment.Items.IndexOf(drpDepartment.Items.FindByText(Request.QueryString["department"]));
                this.Department = Request.QueryString["department"];
            }

            this.Subject = Convert.ToInt64(Request.QueryString["subject"]);

            if (Request.QueryString["offset"] != null && Request.QueryString["totalrows"] != null)
            {
                this.ExecuteSearch(false);
            }
        }

        public void fillMemberGrid()
        {
            pnlGridViewMembers.Visible = true;

            List<GroupMemberState> groupMemberState = new List<GroupMemberState>();

            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            SqlDataReader reader = data.GetGroupMembers(SubjectID);
            while (reader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                groupMemberState.Add(new GroupMemberState(reader.GetInt32(reader.GetOrdinal("UserID")), reader["PersonURI"].ToString(), reader["Title"].ToString(),
                    reader["DisplayName"].ToString(), reader["InstitutionName"].ToString()));
            }
            reader.Close();

            if (groupMemberState.Count > 0)
            {


                GridViewMembers.DataSource = groupMemberState;
                GridViewMembers.DataBind();
            }
            else
            {

                lblNoMembers.Visible = true;
                GridViewMembers.Visible = false;

            }
        }

        public void fillManagerGrid()
        {
            pnlGridViewManagers.Visible = true;
            List<GroupMemberState> groupManagerState = new List<GroupMemberState>();

            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            SqlDataReader reader = data.GetGroupManagers(SubjectID);
            while (reader.Read())
            {
                //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                groupManagerState.Add(new GroupMemberState(reader.GetInt32(reader.GetOrdinal("UserID")), "", "",
                    reader["DisplayName"].ToString(), reader["Institution"].ToString()));
            }
            reader.Close();

            if (groupManagerState.Count > 0)
            {


                GridViewManagers.DataSource = groupManagerState;
                GridViewManagers.DataBind();
            }
            else
            {

                lblNoManagers.Visible = true;
                GridViewManagers.Visible = false;

            }
        }

        protected void GridViewManagers_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }

        protected void GridViewManagers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            int userID = Convert.ToInt32(GridViewManagers.DataKeys[e.RowIndex].Values[0].ToString());
            data.DeleteGroupManager(userID, Subject);
            GridViewManagers.DataBind();
            fillManagerGrid();
        }

        protected void GridViewMembers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewMembers.EditIndex = -1;
            GridViewMembers.DataBind();
        }

        protected void GridViewMembers_RowDataBound(object sender, GridViewRowEventArgs e)
        {

        }

        protected void GridViewMembers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            int userID = Convert.ToInt32(GridViewMembers.DataKeys[e.RowIndex].Values[0].ToString());
            data.DeleteGroupMember(userID, Subject);
            fillMemberGrid();
        }

        protected void GridViewMembers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            Session["pnlAddGroupMembers.Visible"] = null;
            searchReset();
            pnlProxySearch.Visible = false;
            GridViewMembers.EditIndex = e.NewEditIndex;
            GridViewMembers.DataBind();
            //pnlGridViewMembers.Update();
        }

        protected void GridViewMembers_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {

        }

        protected void GridViewMembers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();
            int userID = Convert.ToInt32(GridViewMembers.DataKeys[e.RowIndex].Values[0].ToString());
            TextBox txtTitle = (TextBox)GridViewMembers.Rows[e.RowIndex].FindControl("txtMemberTitle");
            string title = txtTitle.Text;
            data.UpdateGroupMember(userID, Subject, title);
            GridViewMembers.EditIndex = -1;
            fillMemberGrid();
        }

        protected override void Render(HtmlTextWriter writer)
        {
            Page.ClientScript.RegisterForEventValidation(pnlProxySearchResults.UniqueID);
            base.Render(writer);
        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }
        public DataSet MyDataSet
        {
            get
            {
                if (Session["MyDataSet"] == null)
                { Session["MyDataSet"] = new DataSet(); }
                return (DataSet)Session["MyDataSet"];
            }
            set
            {
                Session["MyDataSet"] = value;
            }

        }

        protected void btnProxySearch_Click(object sender, EventArgs e)
        {
            try
            {
                this.TotalPages = 0;
                this.TotalRowCount = 0;
                this.CurrentPage = 0;
                this.Offset = 0;

                this.ExecuteSearch(true);
                if (Session["pnlAddGroupMembers.Visible"] != null) btnImgAddGroupMembers.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
            }
            catch (Exception ex)
            {
                string err = ex.Message;
            }
        }
        private void ExecuteSearch(bool button)
        {
            Utilities.DataIO data = new Profiles.Edit.Utilities.DataIO();
                       
            if (drpDepartment.SelectedItem.Text != "--Select--")
                this.Department = drpDepartment.SelectedItem.Value;
            else
                this.Department = string.Empty;

            if (drpInstitution.SelectedItem.Text != "--Select--")
                this.Institution = drpInstitution.SelectedItem.Value;
            else
                this.Institution = string.Empty;

            this.Fname = txtFirstName.Text;
            this.Lname = txtLastName.Text;

            

            if (this.TotalPages == 0)
            {
                MyDataSet = data.SearchPeople(Lname, Fname, Institution, Department, isManagerPage, 0, 1000000);
                this.TotalRowCount = MyDataSet.Tables[0].Rows.Count;
            }
            
            gridSearchResults.DataSource = MyDataSet;
            gridSearchResults.DataBind();
                      

            pnlProxySearchResults.Visible = true;

             }


        protected void btnSearchReset_Click(object sender, EventArgs e)
        {
            searchReset();
        }

        protected void searchReset()
        {
            txtLastName.Text = "";
            txtFirstName.Text = "";
            drpInstitution.SelectedIndex = -1;
            drpDepartment.SelectedIndex = -1;
            gridSearchResults.DataBind();
            pnlProxySearchResults.Visible = false;
            pnlProxySearch.Visible = true;
            if (Session["pnlAddGroupMembers.Visible"] != null) btnImgAddGroupMembers.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
        }

        protected void btnSearchCancel_Click(object sender, EventArgs e)
        {
            Session["pnlAddGroupMembers.Visible"] = null;
            searchReset();
            pnlProxySearch.Visible = false;
        }

        protected void gridSearchResults_RowDataBound(Object sender, GridViewRowEventArgs e)
        {

            switch (e.Row.RowType)
            {
                case DataControlRowType.DataRow:

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
                    e.Row.Cells[0].Attributes.Add("style", "padding-top:3px !important");
                 
                    break;

                    
                
            }

        }


        protected void gvSearchResults_RowAdd(object sender, EventArgs e)
        {
            Edit.Utilities.DataIO data = new Edit.Utilities.DataIO();

            foreach (GridViewRow row in gridSearchResults.Rows)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkPubMed");
                if (cb.Checked)
                {
                    int userID = Convert.ToInt32(gridSearchResults.DataKeys[row.RowIndex].Values[0].ToString());
                    int personID = Convert.ToInt32(gridSearchResults.DataKeys[row.RowIndex].Values[1].ToString());
                    if (isManagerPage) data.AddGroupManager(userID, Subject);
                    else data.AddGroupMember(userID, personID, Subject);
                }
            }
            btnAddGroupMembers_OnClick(sender, e);
            if (isManagerPage) Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + Request.QueryString["subject"] + "&predicateuri=http://profiles.catalyst.harvard.edu/ontology/prns!hasGroupManager&module=DisplayItemToEdit&ObjectType=Entity");
            else Response.Redirect(Root.Domain + "/edit/default.aspx?subject=" + Request.QueryString["subject"] + "&predicateuri=http%3a%2f%2fvivoweb.org%2fontology%2fcore!contributingRole&module=DisplayItemToEdit&ObjectType=Entity");
        }

       
        protected void btnAddGroupMembers_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlAddGroupMembers.Visible"] == null)
            {
                btnImgAddGroupMembers.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                searchReset();
                Session["pnlAddGroupMembers.Visible"] = true;
            }
            else
            {
                Session["pnlAddGroupMembers.Visible"] = null;
                searchReset();
                pnlProxySearch.Visible = false;
            }
        }

        private void LoadAssets()
        {
            HtmlLink Searchcss = new HtmlLink();
            Searchcss.Href = Root.Domain + "/Search/CSS/search.css";
            Searchcss.Attributes["rel"] = "stylesheet";
            Searchcss.Attributes["type"] = "text/css";
            Searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(Searchcss);
        }

        private Int64 SubjectID { get; set; }
        private Int32 TotalRowCount { get; set; }
        private Int32 CurrentPage { get; set; }
        private Int32 TotalPages { get; set; }
        private Int64 Subject { get; set; }
        private Int32 Offset { get; set; }
        private string Fname { get; set; }
        private string Lname { get; set; }
        private string Institution { get; set; }
        private string Department { get; set; }
        private string Division { get; set; }
        private bool isManagerPage { get; set; }


    }
}
