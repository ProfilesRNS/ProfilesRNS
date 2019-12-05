using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml;
using Profiles.Framework.Utilities;
using Profiles.Lists.Utilities;


namespace Profiles.Lists.Modules.Lists
{
    public partial class ManageLists : System.Web.UI.UserControl
    {
        SessionManagement sm;
        protected void Page_Load(object sender, EventArgs e)
        {
            int page = (string.IsNullOrEmpty(Request.QueryString["page"]) ? 1 : Convert.ToInt32(Request.QueryString["page"]));

            this.Institution = (string.IsNullOrEmpty(Request.QueryString["institution"]) ? "" : Request.QueryString["institution"].ToString());
            this.FacultyRank = (string.IsNullOrEmpty(Request.QueryString["facultyrank"]) ? "" : Request.QueryString["facultyrank"].ToString());

            this.ProfilesList = new Utilities.DataIO.ProfilesList();
            this.ProfilesList = Profiles.Lists.Utilities.DataIO.GetPeople(this.Institution, this.FacultyRank);

            litJS.Text += string.Format("<script>$('.pageTitle').children('h2').html('My Person List ({0})')</script>", Profiles.Lists.Utilities.DataIO.GetListCount());

            this.Institution = (this.Institution.ToLower() == "(all institutions)" ? "" : this.Institution);
            this.FacultyRank = (this.FacultyRank.ToLower() == "(all faculty ranks)" ? "" : this.FacultyRank);


            switch (Request.QueryString["type"])
            {
                case "map":
                    if (Profiles.Lists.Utilities.DataIO.GetListCount() == "0")
                    {
                        NoList();
                    }
                    else
                    {
                        pnlMap.Visible = true;
                        GetMap();
                        SetTabs("map");
                    }

                    break;

                case "removefromsearch":

                    Profiles.Lists.Utilities.DataIO.AddRemoveSearchResults(true);

                    Response.Redirect(Root.Domain + "/search/default.aspx?showcolumns=1&searchtype=people&otherfilters=");

                    //Response.Redirect(Root.Domain + "/lists/default.aspx?type=view");



                    break;
                case "search":
                    Profiles.Lists.Utilities.DataIO.AddRemoveSearchResults(false);

                    //need a lable to display that the user added x number of humans to their list

                    // litJS.Text += string.Format("<script type='text/javascript'>jQuery('#navMyLists ul').remove();jQuery('#list-count').html('{0}');</script>", this.ProfilesList.ListItems.Count.ToString());
                    Response.Redirect(Root.Domain + "/search/default.aspx?showcolumns=1&searchtype=people&otherfilters=");

                    break;
                case "summary":

                    if (Profiles.Lists.Utilities.DataIO.GetListCount() == "0")
                    {
                        NoList();
                    }
                    else
                    {
                        string summarytype = "institution";
                        if (!string.IsNullOrEmpty(Request.QueryString["summarytype"]))
                            summarytype = Request.QueryString["summarytype"];

                        pnlSummary.Visible = true;

                        BuildStatForDimension(summarytype);
                        GetSummary(summarytype);
                        SetTabs("summary");
                    }


                    break;
                case "view":
                default:

                    if (Profiles.Lists.Utilities.DataIO.GetListCount() == "0")
                    {
                        NoList();
                    }
                    else
                    {
                        pnlPeople.Visible = true;

                        EditList(page);
                        SetTabs("view");
                    }

                    break;

                case "deletefilter":
                    ApplyFilters();

                    Profiles.Lists.Utilities.DataIO.DeleteFildered(ListID, (this.Institution == "" ? null : this.Institution), (this.FacultyRank == "" ? null : this.FacultyRank));

                    Response.Redirect(Root.Domain + "/lists/default.aspx?type=view");
                    break;
                case "remove":

                    if (!string.IsNullOrEmpty(Request.QueryString["persons"]))
                    {
                        Profiles.Lists.Utilities.DataIO.DeleteSelected(ListID, Request.QueryString["persons"]);
                    }

                    Response.Redirect(Root.Domain + "/lists/default.aspx?type=view");
                    break;
                case "export":

                    if (!string.IsNullOrEmpty(Request.QueryString["ok"]))
                    {
                        switch (Request.QueryString["exporttype"])
                        {

                            case "persons":
                                Profiles.Lists.Utilities.DataIO.GetPersons(ListID);
                                break;

                            case "publications":
                                Profiles.Lists.Utilities.DataIO.GetPublications(ListID);
                                break;
                            case "coconnections":
                                Profiles.Lists.Utilities.DataIO.GetCoauthorConnections(ListID);
                                break;
                        }


                    }

                    SetTabs("export");
                    pnlExport.Visible = true;
                    break;



                case "coviz":


                    if (Profiles.Lists.Utilities.DataIO.GetListCount() == "0")
                    {
                        NoList();
                    }
                    else
                    {
                        pnlCluster.Visible = true;
                        SetTabs("coviz");
                        GetCoViz();
                    }
                    break;
            }
        }

        private void SetTabs(string tab)
        {

            litJS.Text += string.Format("<script>$('#tabmenu li').removeClass('selected');$('#tab-{0}').addClass('selected');</script>", tab);

        }
        public ManageLists() { }
        public ManageLists(XmlDocument pagedata, List<ModuleParams> moduleparams, XmlNamespaceManager pagenamespaces)
        {
            sm = new SessionManagement();
            this.ListID = sm.Session().ListID;
            LoadAssets();
        }


        private void GetSummary(string summarytype)
        {
            litSummaryJS.Text = "<script>$('.modalupdate').show();$(window).on('load', function() {drawChart('" + Profiles.Lists.Utilities.DataIO.GetSummary(this.ListID, summarytype) + "','" + summarytype + "');$('.modalupdate').hide();});</script>";
        }

        private void ApplyFilters()
        {            
            if (!string.IsNullOrEmpty(this.Institution))
                this.ProfilesList.ListItems = this.ProfilesList.ListItems.FindAll(x => x.InstitutionName == this.Institution).ToList();
            if (!string.IsNullOrEmpty(this.FacultyRank))
                this.ProfilesList.ListItems = this.ProfilesList.ListItems.FindAll(x => x.FacultyRank == (this.FacultyRank == "--" ? "" : this.FacultyRank)).ToList();
            
        }

        private void BuildStatForDimension(string dimension)
        {
            List<Profiles.Lists.Utilities.DataIO.SummaryItem> si = Profiles.Lists.Utilities.DataIO.GetSummaryRaw(this.ListID, dimension);

            StringBuilder sb = new StringBuilder();
            int totalitems = Convert.ToInt32(Profiles.Lists.Utilities.DataIO.GetListCount());

            switch (dimension)
            {
                case "institution":

                    litSumHeader.Text = "<div style='display: table-row'><div class='throw tdborderleft thborderright'>Institution</div><div class='throw'>People</div><div class='throw tdborderleft thborderright'>Percent</div></div>";
                    break;

                case "facultyrank":

                    litSumHeader.Text = "<div style='display: table-row'><div class='throw tdborderleft thborderright'>Faculty Rank</div><div class='throw'>People</div><div class='throw tdborderleft thborderright'>Percent</div></div>";


                    break;
                case "department":

                    litSumHeader.Text = "<div style='display: table-row'><div class='throw tdborderleft thborderright'>Department</div><div class='throw'>People</div><div class='throw tdborderleft thborderright'>Percent</div></div>";


                    break;


            }
            foreach (Profiles.Lists.Utilities.DataIO.SummaryItem i in si)
            {
                sb.Append(string.Format("<div style = 'display: table-row'><div class='tdrow tdborderleft  thborderright'>{0}</div><div class='tdrow' style='text-align:center;'>{1}</div><div class='tdrow tdborderleft thborderright' style='text-align:center;'>{2}%</div></div>", i.Value.Replace("\\'", "\'"), i.n, System.Math.Round(((decimal)i.n / (decimal)totalitems) * 100, 1)));
            }


            litSumItem.Text = sb.ToString();

        }
        private void EditList(int page)
        {
            ddlFacultyRank.Text = BuildDropdown("facultyrank", "190", this.FacultyRank, "(all faculty ranks)");
            ddlInstitution.Text = BuildDropdown("institution", "300", this.Institution, "(all institutions)");

            ApplyFilters();
            int totalitems = Convert.ToInt32(Profiles.Lists.Utilities.DataIO.GetListCount());
            int totalfiltered = 0;

            totalfiltered = this.ProfilesList.ListItems.Count;


            this.ListPager = new Pager(this.ProfilesList.ListItems.Count, page, 15);
            litListStats.Text = string.Format("There are currently <span style='font-weight:bold; color:#900;'>{0}</span> people in your list.  Filter the list by institution or faculty rank.  <a href='#' onclick=\"$('.modalupdate').show(); removefilter();\">Remove all {1} people shown</a> or just the selected people from your list.", totalitems.ToString(), totalfiltered.ToString());


            litPagination.Text = "<script type='text/javascript'>" +
                    "_page = " + this.ListPager.CurrentPage + ";" +
                    "_totalpages = " + (this.ListPager.PageSize > this.ProfilesList.ListItems.Count ? 1 : this.ListPager.TotalPages) + ";" +
                    "</script>";

            if (this.ProfilesList.ListItems.Count > 0)
            {
                gridSearchResults.PageIndex = this.ListPager.CurrentPage;
                gridSearchResults.DataSource = this.ProfilesList.ListItems.Skip((page - 1) * this.ListPager.PageSize).Take(this.ListPager.PageSize).ToList();
                gridSearchResults.DataBind();
                gridSearchResults.BottomPagerRow.Visible = true;
            }
            else
            {

                NoList();
            }
        }


        public string BuildDropdown(string type, string width, string defaultitem, string emptylabel)
        {
            StringBuilder output = new StringBuilder();

            output.Append(string.Format("<option value=''>{0}</option>", emptylabel));
            if (type == "institution")
            {
                foreach (GenericListItem item in this.ProfilesList.Institutions)
                {
                    if (!defaultitem.IsNullOrEmpty() && defaultitem == item.Text)
                        output.Append(string.Format("<option selected=\"true\" value=\"{0}\">{1} ({2})</option>", item.Text, (item.Text == "" ? "--" : item.Text), item.Value));
                    else
                        output.Append(string.Format("<option value=\"{0}\">{1} ({2})</option>", item.Text, (item.Text == "" ? "--" : item.Text), item.Value));
                }
            }
            else
            {
                foreach (GenericListItem item in this.ProfilesList.FacultyRanks)
                {
                    if (!defaultitem.IsNullOrEmpty() && defaultitem == (item.Text == "" ? "--" : item.Text))
                        output.Append(string.Format("<option selected=\"true\" value=\"{0}\">{1} ({2})</option>", (item.Text == "" ? "--" : item.Text), (item.Text == "" ? "--" : item.Text), item.Value));
                    else
                        output.Append(string.Format("<option value=\"{0}\">{1} ({2})</option>", (item.Text == "" ? "--" : item.Text), (item.Text == "" ? "--" : item.Text), item.Value));
                }
            }

            return string.Format("<select onChange='javascript:ApplyFilter()' style='margin-bottom:6px;width:{0}px;' id='ddl{1}' class='form-control input-sm' title='{1}'>{2}</select>", width, type, output.ToString());

        }

        protected void gridSearchResults_RowDataBound(Object sender, GridViewRowEventArgs e)
        {
            switch (e.Row.RowType)
            {
                case DataControlRowType.Header:
                    e.Row.Cells[3].Attributes.Add("style", "text-align:center;");
                    break;
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

                    e.Row.Cells[0].Attributes.Add("onclick", string.Format("Javascript:NavToProfile('{0}')", ((Profiles.Lists.Utilities.DataIO.ProfilesListItem)e.Row.DataItem).PersonID));
                    e.Row.Cells[1].Attributes.Add("onclick", string.Format("Javascript:NavToProfile('{0}')", ((Profiles.Lists.Utilities.DataIO.ProfilesListItem)e.Row.DataItem).PersonID));
                    e.Row.Cells[2].Attributes.Add("onclick", string.Format("Javascript:NavToProfile('{0}')", ((Profiles.Lists.Utilities.DataIO.ProfilesListItem)e.Row.DataItem).PersonID));
                    e.Row.Cells[3].Attributes.Add("style", "text-align:center;");
                    e.Row.Cells[2].Attributes.Add("style", "padding-left:6px;");
                    e.Row.Cells[1].Attributes.Add("style", "padding-left:6px;");
                    CheckBox ck = (CheckBox)e.Row.Cells[3].FindControl("chkRemove");
                    ck.Attributes.Add("name", ((Profiles.Lists.Utilities.DataIO.ProfilesListItem)e.Row.DataItem).PersonID);

                    break;
                case DataControlRowType.Pager:

                    Literal litFirst = (Literal)e.Row.FindControl("litFirst");
                    Literal litLast = (Literal)e.Row.FindControl("litLast");
                    Literal litPage = (Literal)e.Row.FindControl("litPage");

                    if (this.ListPager.CurrentPage > 1)
                        litFirst.Text = "<a onClick='JavaScript:GotoFirstPage(); return false;'><img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_first.gif" + "'/></a><a href='JavaScript:GotoPreviousPage();'><img style='margin-left:5px;;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_prev.gif" + "'/><span style='padding-left:5px;font-size:11px;'>Prev</span></a>";
                    else
                        litFirst.Text = "<img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_first_d.gif" + "' /> <img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_prev_d.gif" + "' /><span style='padding-left:5px;font-size:11px;'>Prev</span>";


                    if (this.ListPager.CurrentPage <= (this.ListPager.TotalPages - 1))
                        litLast.Text = "<a onClick='javascript:GotoNextPage();return false;'>Next<img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_next.gif'/></a><a href='JavaScript:GotoLastPage();' ><img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_last.gif'/></a>";
                    else
                        litLast.Text = "<img style='margin-left:5px;margin-bottom:2px;' src='" + Root.Domain + "/framework/images/arrow_next_d.gif" + "'/><img style='margin-left:5px;margin-bottom:2px;'  src='" + Root.Domain + "/framework/images/arrow_last_d.gif" + "'/><span style='padding-left:5px;font-size:11px;'>Next</span>";

                    int displaypage = 1;
                    if (this.ListPager.CurrentPage != 0)
                        displaypage = this.ListPager.CurrentPage;

                    litPage.Text = "<span style='padding-left:20px;padding-right:20px;'>" + (displaypage).ToString() + " of " + (this.ListPager.TotalPages).ToString() + " pages</span>";

                    break;
            }

        }



        private void LoadAssets()
        {

            HtmlLink editcss = new HtmlLink();
            editcss.Href = Root.Domain + "/edit/CSS/edit.css";
            editcss.Attributes["rel"] = "stylesheet";
            editcss.Attributes["type"] = "text/css";
            editcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(editcss);


            HtmlLink searchcss = new HtmlLink();
            searchcss.Href = Root.Domain + "/search/CSS/search.css";
            searchcss.Attributes["rel"] = "stylesheet";
            searchcss.Attributes["type"] = "text/css";
            searchcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(searchcss);

            HtmlLink listcss = new HtmlLink();
            listcss.Href = Root.Domain + "/lists/CSS/lists.css";
            listcss.Attributes["rel"] = "stylesheet";
            listcss.Attributes["type"] = "text/css";
            listcss.Attributes["media"] = "all";
            Page.Header.Controls.Add(listcss);

        }

        private void GetCoViz()
        {
            litCluster.Text = "<script>$(window).on('load', function() {" + string.Format("$('#iframe-cluster').attr('src','{0}/lists/modules/Networkclusterlist/Networkclusterlist.aspx?listid={1}');", Root.Domain, this.ListID) + "});</script>";
        }

        private void GetMap()
        {
            litMap.Text = "<script>$(window).on('load', function() {" + string.Format("$('#iframe-map').attr('src','{0}/lists/modules/NetworkMapList/NetworkMapList.aspx?listid={1}');", Root.Domain, this.ListID) + "});</script>";
        }
        private void NoList()
        {
            NoLists.Text = "<script>$('.content-main').remove();</script> <div style='margin-top:16px;font-weight:bold;text-align:left;float:left;'>You currently have no people on your list.</div>";
            NoLists.Visible = true;
        }

        private Profiles.Lists.Utilities.DataIO.ProfilesList ProfilesList { get; set; }
        public string ListID { get; set; }

        private Pager ListPager { get; set; }
        private string Institution { get; set; }
        private string FacultyRank { get; set; }
    }
}