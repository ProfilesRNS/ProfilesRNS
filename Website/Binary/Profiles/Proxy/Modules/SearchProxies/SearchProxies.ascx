<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchProxies.ascx.cs"
    Inherits="Profiles.Proxy.Modules.SearchProxies.SearchProxies" %>

<script type="text/javascript">

    var _page = 0;
    var _offset = 0;
    var _totalrows = 0;
    var _totalpages = 0;
    var _root = "";
    var _subject = 0;
    var _fname = '';
    var _lname = '';
    var _department = '';
    var _institution = '';
    


    function GotoNextPage() {
        
        _page++;
        NavToPage();
    }
    function GotoPreviousPage() {

        _page--;
        NavToPage();
    }
    function GotoFirstPage() {

        _page = 1;
        NavToPage();
    }
    function GotoLastPage() {

        _page = _totalpages;
        NavToPage();
    }
    function NavToPage() {

        
        
        window.location = _root + '/proxy/default.aspx?method=search&currentpage=' + _page +
                '&totalrows=' + _totalrows + '&offset=' + _offset + '&totalpages=' + _totalpages + '&subject=' + _subject +
                '&fname=' + _fname + '&lname=' + _lname + '&institution=' + _institution + '&department=' + _department;
    }
    

     function ShowStatus() {

         document.getElementById("divStatus").style.display = "block";

     }
 </script>
 
 
<div id="divStatus" style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
    right: 0; left: 0; z-index: 9999999; opacity: 0.7;display:none">
    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
        font-size: 36px; left: 40%; top: 40%;"><img alt="Loading..." src="<%=GetURLDomain()%>/Edit/Images/loader.gif" /></span>
</div>
<div class="pageTitle">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>
<br />
<br />
Proxies are people who can edit other people's profiles on their behalf. For example, 
faculty can designate their assistants as proxies to edit their profiles. If you
have a profile, then one or more proxies might be assigned to you automatically
by your department or institution. You also have the option of designation your
own proxies.
<br />
<div style="margin-top: 10px;">
    <asp:Panel ID="pnlProxySearch" runat="server">
        <div class="content_container">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table border="0" cellspacing="0" cellpadding="0" class="searchForm">
                            <tr>
                                <th>
                                    Last Name
                                </th>
                                <td>
                                    <asp:TextBox ID="txtLastName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    First Name
                                </th>
                                <td>
                                    <asp:TextBox ID="txtFirstName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: right;">
                                    Institution
                                </th>
                                <td>
                                    <asp:DropDownList ID="drpInstitution" runat="server" Width="255px" AutoPostBack="false" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    Department
                                </th>
                                <td>
                                    <asp:DropDownList ID="drpDepartment" runat="server" Width="255px" AutoPostBack="false" />
                                </td>
                            </tr>                           
                            <tr>
                                <th>
                                </th>
                                <td>
                                    <div style="padding: 12px 0px;">
                                        <asp:Button ID="btnProxySearch" runat="server" Text="Search" OnClick="btnProxySearch_Click" />&nbsp;&nbsp;
                                        <asp:Button ID="btnSearchReset" runat="server" Text="Reset" OnClick="btnSearchReset_Click" />&nbsp;&nbsp;
                                        <asp:Button ID="btnSearchCancel" runat="server" Text="Cancel" OnClick="btnSearchCancel_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="pnlProxySearchResults" runat="server" Visible="false">
    <br />
    <b>Proxy Search Results</b>
    <br />
        <div style="margin-top: 8px;">
            <asp:GridView Width="100%" ID="gridSearchResults" runat="server" DataKeyNames="UserID"
                AllowPaging="true" PageSize="25" EmptyDataText="No matching people could be found."
               AutoGenerateColumns="False" OnRowDataBound="gridSearchResults_RowDataBound" OnSelectedIndexChanged="gridSearchResults_SelectedIndexChanged">
                <RowStyle CssClass="edittable" />
                <AlternatingRowStyle CssClass="evenRow" />
                <HeaderStyle CssClass="topRow" />
                <PagerTemplate>
                    <div class="listTablePagination" style="width: 100%; border:0px; padding: 2px 0px">
                        <table style="border:none; margin:0px; padding:0px;">
                            <tr>
                                <td width="25%" align="left">
                                    <asp:Literal ID="litFirst" runat="server"></asp:Literal>
                                </td>
                                <td width="75%" align="center">
                                    <asp:Literal ID="litPage" runat="server"></asp:Literal>
                                </td>
                                <td width="25%" align="right">
                                    <asp:Literal ID="litLast" runat="server"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                    </div>
                </PagerTemplate>
                <Columns>
                    <asp:BoundField DataField="DisplayName" HeaderText="Name" NullDisplayText="--"  SortExpression="" />
                    <asp:BoundField DataField="Institution" HeaderText="Institution" NullDisplayText="--" SortExpression="" />
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
</div>
<asp:Literal runat="server" ID="litPagination"></asp:Literal>