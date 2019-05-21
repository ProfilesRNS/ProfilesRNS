/*  
 
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
  
*/
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
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Xml;

using Profiles.Framework.Utilities;


namespace Profiles.GroupAdmin.Modules.GroupAdmin
{
    public partial class GroupAdmin : BaseModule
    {
        SessionManagement sm;
        Profiles.GroupAdmin.Utilities.DataIO data;
        protected void Page_Load(object sender, EventArgs e)
        {
            sm = new SessionManagement();

            DrawProfilesModule();
        }

        public GroupAdmin() : base() { }
        public GroupAdmin(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
            : base(pagedata, moduleparams, pagenamespaces)
        {


        }
        private void DrawProfilesModule()
        {

            if (sm.Session().UserID == 0)
                Response.Redirect(Root.Domain + "/search");

            data = new Profiles.GroupAdmin.Utilities.DataIO();



            List<Group> groups = new List<Group>();

            using (SqlDataReader reader = data.GetActiveGroups())
            {
                while (reader.Read())
                {
                    //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                    groups.Add(new Group(reader["GroupName"].ToString(), reader.GetInt64(reader.GetOrdinal("ViewSecurityGroup")), reader["ViewSecurityGroupName"].ToString(),
                        reader["EndDate"].ToString(), reader.GetInt32(reader.GetOrdinal("GroupID")), reader.GetInt64(reader.GetOrdinal("GroupNodeID"))));
                }
                if (!reader.IsClosed) reader.Close();

                gvGroups.DataSource = groups;
                gvGroups.DataBind();
            }



            List<Group> deletedGroups = new List<Group>();

            using (SqlDataReader deletedReader = data.GetDeletedGroups())
            {
                while (deletedReader.Read())
                {
                    //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                    deletedGroups.Add(new Group(deletedReader["GroupName"].ToString(), deletedReader.GetInt64(deletedReader.GetOrdinal("ViewSecurityGroup")), deletedReader["ViewSecurityGroupName"].ToString(),
                        deletedReader["EndDate"].ToString(), deletedReader.GetInt32(deletedReader.GetOrdinal("GroupID")), deletedReader.GetInt64(deletedReader.GetOrdinal("GroupNodeID"))));
                }
                if (!deletedReader.IsClosed) deletedReader.Close();

                gvDeletedGroups.DataSource = deletedGroups;
                gvDeletedGroups.DataBind();
            }
        }

        protected void fillGroupsGrid()
        {

            List<Group> groups = new List<Group>();

            using (SqlDataReader reader = data.GetActiveGroups())
            {
                while (reader.Read())
                {
                    //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                    groups.Add(new Group(reader["GroupName"].ToString(), reader.GetInt64(reader.GetOrdinal("ViewSecurityGroup")), reader["ViewSecurityGroupName"].ToString(),
                        reader["EndDate"].ToString(), reader.GetInt32(reader.GetOrdinal("GroupID")), reader.GetInt64(reader.GetOrdinal("GroupNodeID"))));
                }

                if (!reader.IsClosed) reader.Close();

                gvGroups.DataSource = groups;
                gvGroups.DataBind();

            }

            using (SqlDataReader deletedReader = data.GetDeletedGroups())
            {
                List<Group> deletedGroups = new List<Group>();
                while (deletedReader.Read())
                {
                    //public Group(string GroupName, int ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, string GroupID, string GroupNodeID)
                    deletedGroups.Add(new Group(deletedReader["GroupName"].ToString(), deletedReader.GetInt64(deletedReader.GetOrdinal("ViewSecurityGroup")), deletedReader["ViewSecurityGroupName"].ToString(),
                        deletedReader["EndDate"].ToString(), deletedReader.GetInt32(deletedReader.GetOrdinal("GroupID")), deletedReader.GetInt64(deletedReader.GetOrdinal("GroupNodeID"))));


                }

                gvDeletedGroups.DataSource = deletedGroups;
                gvDeletedGroups.DataBind();

                if (!deletedReader.IsClosed) deletedReader.Close();
            }
        }

        private void addGroupsReset()
        {
            txtGroupName.Text = "";
            txtEndDate.Text = "";
            pnlAddGroup.Visible = true;
        }

        protected void btnAddGroups_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlAddGroupMembers.Visible"] == null)
            {
                btnImgAddGroup.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                addGroupsReset();
                phDeletedGroups.Visible = false;
                Session["pnlAddGroupMembers.Visible"] = true;
            }
            else
            {
                Session["pnlAddGroupMembers.Visible"] = null;
                addGroupsReset();
                phDeletedGroups.Visible = true;
                pnlAddGroup.Visible = false;
            }

            if (Session["pnlDeletedGroups.Visible"] != null)
            {
                Session["pnlDeletedGroups.Visible"] = null;
                pnlDeletedGroups.Visible = false;
            }
        }

        protected void btnDeletedGroups_OnClick(object sender, EventArgs e)
        {
            if (Session["pnlDeletedGroups.Visible"] == null)
            {
                btnImgDeletedGroups.ImageUrl = Root.Domain + "/Framework/images/icon_squareDownArrow.gif";
                pnlDeletedGroups.Visible = true;
                phAddGroups.Visible = false;
                gvGroups.Visible = false;
                //addGroupsReset();
                Session["pnlDeletedGroups.Visible"] = true;
                lblNoGroups.Visible = (gvDeletedGroups.Rows.Count == 0 ? true : false);
            }
            else
            {
                Session["pnlDeletedGroups.Visible"] = null;
                //addGroupsReset();
                phAddGroups.Visible = true;
                gvGroups.Visible = true;
                pnlDeletedGroups.Visible = false;
            }

            if (Session["pnlAddGroupMembers.Visible"] != null)
            {
                Session["pnlAddGroupMembers.Visible"] = null;
                addGroupsReset();
                pnlAddGroup.Visible = false;
            }
        }

        protected void btnInsert_OnClick(object sender, EventArgs e)
        {
            string groupName = txtGroupName.Text;
            //int visibility = Convert.ToInt32(ddVisibility.SelectedValue);
            string endDate = txtEndDate.Text;
            Utilities.DataIO data = new Utilities.DataIO();
            addGroupsReset();
            data.AddGroup(groupName, endDate);
            fillGroupsGrid();
        }


        protected void btnInsertClose_OnClick(object sender, EventArgs e)
        {
            btnInsert_OnClick(sender, e);
            Session["pnlAddGroupMembers.Visible"] = null;
            pnlAddGroup.Visible = false;
        }

        protected void lnkDelete_OnClick(object sender, EventArgs e)
        {
            ImageButton lb = (ImageButton)sender;

            Profiles.Proxy.Utilities.DataIO data = new Profiles.Proxy.Utilities.DataIO();
            data.DeleteProxy(lb.CommandArgument);


            DrawProfilesModule();


        }

        protected void gvGroups_OnRowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Group proxy = (Group)e.Row.DataItem;

                ImageButton lnkDelete = (ImageButton)e.Row.FindControl("lnkDelete");
            }

            e.Row.Cells[3].Attributes.Add("style", "width:50px");
        }

        protected void gvGroups_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvGroups.EditIndex = -1;

            fillGroupsGrid();

        }

        protected void gvGroups_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvGroups.EditIndex = e.NewEditIndex;
            fillGroupsGrid();

        }

        protected void gvGroups_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int groupID = Convert.ToInt32(gvGroups.DataKeys[e.RowIndex].Values[0].ToString());
            long groupNodeID = Convert.ToInt64(gvGroups.DataKeys[e.RowIndex].Values[1].ToString());
            data.DeleteGroup(groupID, groupNodeID);
            fillGroupsGrid();

        }


        protected void gvGroups_RowUpdated(object sender, GridViewUpdatedEventArgs e)
        {
            fillGroupsGrid();

        }

        protected void gvGroups_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            TextBox txtGroupName = (TextBox)gvGroups.Rows[e.RowIndex].FindControl("txtGroupName");
            DropDownList ddEditVisibility = (DropDownList)gvGroups.Rows[e.RowIndex].FindControl("ddEditVisibility");
            TextBox txtEndDate = (TextBox)gvGroups.Rows[e.RowIndex].FindControl("txtEndDate");
            int groupID = Convert.ToInt32(gvGroups.DataKeys[e.RowIndex].Values[0].ToString());
            long groupNodeID = Convert.ToInt32(gvGroups.DataKeys[e.RowIndex].Values[1].ToString());

            string endDate = null;
            if (!txtEndDate.Text.Equals("")) endDate = txtEndDate.Text;


            data.UpdateGroup(groupID, groupNodeID, txtGroupName.Text, endDate);

            Session["pnlInsertAward.Visible"] = null;
            gvGroups.EditIndex = -1;
            fillGroupsGrid();

        }

        protected void gvDeletedGroups_RowEditing(object sender, GridViewEditEventArgs e)
        {
            int groupID = Convert.ToInt32(gvDeletedGroups.DataKeys[e.NewEditIndex].Values[0].ToString());
            data.RestoreGroup(groupID);
            Session["pnlDeletedGroups.Visible"] = null;
            fillGroupsGrid();

        }

        public string GetURLDomain()
        {
            return Root.Domain;
        }

        class Group
        {
            public Group(string GroupName, Int64 ViewSecurityGroup, string ViewSecurityGroupName, string EndDate, int GroupID, Int64 GroupNodeID)
            {
                this.GroupName = GroupName;
                this.ViewSecurityGroup = ViewSecurityGroup;
                this.ViewSecurityGroupName = ViewSecurityGroupName;
                this.EndDate = EndDate.Substring(0, EndDate.IndexOf(' '));
                this.GroupID = GroupID;
                this.GroupNodeID = GroupNodeID;
                this.GroupURI = Root.Domain + "/Profile/" + GroupNodeID;
            }


            public string GroupName { get; set; }
            public Int64 ViewSecurityGroup { get; set; }
            public string ViewSecurityGroupName { get; set; }
            public string EndDate { get; set; }
            public int GroupID { get; set; }
            public Int64 GroupNodeID { get; set; }
            public string GroupURI { get; set; }
        }

    }
}