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
using System.Web.UI.HtmlControls;


using Profiles.Framework.Utilities;
using Profiles.Profile.Utilities;

namespace Profiles.Proxy.Modules.SearchProxies
{
    public partial class SearchProxies : BaseModule
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadAssets();
            DrawProfilesModule();

        }

        public SearchProxies() { }
        public SearchProxies(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {

        }
        private void DrawProfilesModule()
        {
            Search.Utilities.DataIO data = new Profiles.Search.Utilities.DataIO();
            SessionManagement sm = new SessionManagement();
            string subject = sm.Session().SessionID.ToString();


            if (sm.Session().UserID == 0)
                Response.Redirect(Root.Domain + "/search");

            litBackLink.Text = "<b>Search Proxies</b>";

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

            drpInstitution.DataSource = data.GetInstitutions();
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
            
            drpDivision.DataSource = data.GetDivisions();
            drpDivision.DataTextField = "Text";
            drpDivision.DataValueField = "Value";
            drpDivision.DataBind();
            drpDivision.Items.Insert(0, new ListItem("--Select--"));

            if (Request.QueryString["division"] != null)
            {
                drpDivision.SelectedIndex = drpDivision.Items.IndexOf(drpDivision.Items.FindByText(Request.QueryString["division"]));
                this.Division = Request.QueryString["division"];
            }

            this.Subject = Convert.ToInt64(Request.QueryString["subject"]);

            if (Request.QueryString["offset"] != null && Request.QueryString["totalrows"] != null)
            {
                this.ExecuteSearch();
            }
        }

        public DataSet MyDataSet
        {
            get
            {
                if (ViewState["MyDataSet"] == null)
                    ViewState["MyDataSet"] = new DataSet();
                return (DataSet)ViewState["MyDataSet"];
            }
            set { ViewState["MyDataSet"] = value; }
        }

        protected void btnProxySearch_Click(object sender, EventArgs e)
        {
            try
            {
                this.ExecuteSearch();
            }
            catch (Exception ex)
            {
                string err = ex.Message;
            }
        }
        private void ExecuteSearch()
        {
            Utilities.DataIO data = new Profiles.Proxy.Utilities.DataIO();


            Int32 totalpageremainder = 0;

            if (drpDepartment.SelectedItem.Text != "--Select--")
                this.Department = drpDepartment.SelectedItem.Text;

            if (drpInstitution.SelectedItem.Text != "--Select--")
                this.Institution = drpInstitution.SelectedItem.Text;

            if (drpDivision.SelectedItem.Text != "--Select--")
                this.Division = drpDivision.SelectedItem.Text;


            this.Fname = txtFirstName.Text;
            this.Lname = txtLastName.Text;


            if (Request.QueryString["offset"] != null)
                this.Offset = Convert.ToInt32(Request.QueryString["offset"]);

            if (Request.QueryString["totalrows"] != null)
                this.TotalRowCount = Convert.ToInt32(Request.QueryString["totalrows"]);

            if (Request.QueryString["CurrentPage"] != null)
                this.CurrentPage = Convert.ToInt32(Request.QueryString["CurrentPage"]);

            if (Request.QueryString["TotalPages"] != null)
                this.TotalPages = Convert.ToInt32(Request.QueryString["TotalPages"]);


            if (this.TotalPages == 0)
            {
                MyDataSet = data.SearchProxies(Lname, Fname, Institution, Department, Division, 0, 1000000);
                this.TotalRowCount = MyDataSet.Tables[0].Rows.Count;
            }

            if (this.CurrentPage <= 0)
            {
                this.CurrentPage = 1;
            }


            if (this.TotalPages == 0)
                this.TotalPages = Math.DivRem(this.TotalRowCount, 25, out totalpageremainder);

            if (totalpageremainder > 0) { this.TotalPages = this.TotalPages + 1; }

            this.Offset = ((Convert.ToInt32(this.CurrentPage) * 25) + 1) - 25;

            if (this.Offset < 0)
                this.Offset = 0;


            MyDataSet = data.SearchProxies(Lname, Fname, Institution, Department, Division, this.Offset - 1, 25);

            gridSearchResults.PageIndex = 0;
            gridSearchResults.DataSource = MyDataSet;
            gridSearchResults.DataBind();

            if (MyDataSet.Tables[0].Rows.Count > 0)
                gridSearchResults.BottomPagerRow.Visible = true;

            pnlProxySearchResults.Visible = true;

            litPagination.Text = "<script type='text/javascript'>" +
                "_page = " + this.CurrentPage + ";" +
                "_offset = " + this.Offset + ";" +
                "_totalrows = " + this.TotalRowCount + ";" +
                "_totalpages =" + this.TotalPages + ";" +
                "_root = '" + Root.Domain + "';" +
                "_subject = '" + Subject + "';" +
                "_fname = '" + this.Fname + "';" +
                "_lname = '" + this.Lname + "';" +
                "_department = '" + this.Department + "';" +
                "_institution = '" + this.Institution + "';" +
                "_division = '" + this.Division + "';" +
                "</script>";
        }


        protected void btnSearchReset_Click(object sender, EventArgs e)
        {
            txtLastName.Text = "";
            txtFirstName.Text = "";
            drpInstitution.SelectedIndex = -1;
            drpDepartment.SelectedIndex = -1;
            drpDivision.SelectedIndex = -1;
            gridSearchResults.DataBind();
            pnlProxySearchResults.Visible = false;
        }

        protected void btnSearchCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect(Root.Domain + "/proxy/default.aspx?subject=" + Request.QueryString["subject"]);
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

                    e.Row.Attributes["onclick"] = Page.ClientScript.GetPostBackClientHyperlink((GridView)sender, "Select$" + e.Row.RowIndex);
                    
                    e.Row.Cells[0].Attributes.Add("style", "border-left:#999 1px solid;padding-left:6px;");
                    e.Row.Cells[1].Attributes.Add("style", "border-right:#999 1px solid;padding-left:6px;");

                    break;
                case DataControlRowType.Footer:

                    e.Row.Style.Add("style", "border:none");
                    break;
                case DataControlRowType.Header:

                    e.Row.Style.Add("style", "border-right:#999 1px solid;border-left:#999 1px solid;border-top:#999 1px solid;");
                    break;
                case DataControlRowType.Pager:

                    Literal litFirst = (Literal)e.Row.FindControl("litFirst");

                    Literal litLast = (Literal)e.Row.FindControl("LitLast");

                    if (CurrentPage > 1)
                        litFirst.Text = "<a href='JavaScript:GotoPreviousPage();' class='listTablePaginationPN listTablePaginationP listTablePaginationA'><img src='" + Root.Domain + "/framework/images/arrow_prev.gif'/>Prev</a>" +
                        "<a href='JavaScript:GotoFirstPage();' class='listTablePaginationFL listTablePaginationA'><img src='" + Root.Domain + "/framework/images/arrow_first.gif'/></a>";
                    else
                        litFirst.Text = "<div class='listTablePaginationPN listTablePaginationP'><img src='" + Root.Domain + "/framework/images/arrow_prev_d.gif'/>Prev</div><div class='listTablePaginationFL'>" +
                        "<img src='" + Root.Domain + "/framework/images/arrow_first_d.gif'/></div>";


                    if (this.CurrentPage < this.TotalPages)
                    {
                        litLast.Text = "<a href='JavaScript:GotoLastPage();' class='listTablePaginationFL listTablePaginationA'><img src='" + Root.Domain + "/framework/images/arrow_last.gif'/></a>" +
                        "<a href='javascript:GotoNextPage();' class='listTablePaginationPN listTablePaginationN listTablePaginationA'>Next<img src='" + Root.Domain + "/framework/images/arrow_next.gif'/></a>";
                    }
                    else
                    {
                        litLast.Text = "<div class='listTablePaginationFL'><img src='" + Root.Domain + "/framework/images/arrow_last_d.gif'/></div><div class='listTablePaginationPN listTablePaginationN'>" +
                        "Next<img src='" + Root.Domain + "/framework/images/arrow_next_d.gif'/></div>";
                    }

                    break;
            }

        }

        protected void gridSearchResults_SelectedIndexChanged(object sender, EventArgs e)
        {
            Utilities.DataIO data = new Profiles.Proxy.Utilities.DataIO();
            data.InsertProxy(gridSearchResults.DataKeys[gridSearchResults.SelectedIndex]["UserID"].ToString());
            Response.Redirect(Root.Domain + "/proxy/default.aspx?subject=" + HttpContext.Current.Request.QueryString["subject"]);
        }

        protected void gridSearchResults_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gridSearchResults.PageIndex = e.NewPageIndex;
            gridSearchResults.DataSource = MyDataSet;
            gridSearchResults.DataBind();
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


    }
}
