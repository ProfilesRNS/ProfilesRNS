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

<div style="margin-top: 16px">
    Proxies are people who can edit other people's profiles on their behalf. For example, 
faculty can designate their assistants as proxies to edit their profiles. If you
have a profile, then one or more proxies might be assigned to you automatically
by your department or institution. You also have the option of designation your
own proxies.
</div>
<div style="margin-top: 16px;">
    <asp:Panel ID="pnlProxySearch" runat="server">
        <div class="content_container">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table class="searchForm">
                            <tr>
                                <th>Last Name
                                </th>
                                <td style="border: none !important">
                                    <asp:TextBox ID="txtLastName" runat="server" Width="255px" />
                                </td>
                            </tr>
                            <tr>
                                <th>First Name
                                </th>
                                <td style="border: none !important">
                                    <asp:TextBox ID="txtFirstName" runat="server" Width="255px" />
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: right;">Institution
                                </th>
                                <td style="border: none !important">
                                    <asp:DropDownList ID="drpInstitution" runat="server" Width="255px" AutoPostBack="false" />
                                </td>
                            </tr>
                            <tr>
                                <th>Department
                                </th>
                                <td style="border: none !important">
                                    <asp:DropDownList ID="drpDepartment" runat="server" Width="255px" AutoPostBack="false" />
                                </td>
                            </tr>
                            <tr>
                                <th></th>
                                <td style="border: none !important">
                                    <div class="actionbuttons">
                                        <asp:LinkButton ID="btnProxySearch" runat="server" Text="Search" OnClick="btnProxySearch_Click" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnSearchReset" runat="server" Text="Reset" OnClick="btnSearchReset_Click" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnSearchCancel" runat="server" Text="Cancel" OnClick="btnSearchCancel_Click" />
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
        <div style="margin-top: 16px">
            <br />
            <b>Proxy Search Results</b>
            <div style="margin-top: 4px;">
                <asp:GridView Width="100%" ID="gridSearchResults" runat="server" DataKeyNames="UserID"
                    AllowPaging="true" PageSize="25" EmptyDataText="No matching people could be found."
                    AutoGenerateColumns="False" OnRowDataBound="gridSearchResults_RowDataBound" OnSelectedIndexChanged="gridSearchResults_SelectedIndexChanged">
                    <RowStyle CssClass="oddRow" />
                    <AlternatingRowStyle CssClass="evenRow" />
                    <HeaderStyle CssClass="topRow" />
                    <PagerTemplate>
                        <div class="listTablePagination" style="display:inline-flex;padding-left:200px; border-left:0px !important;border-bottom:0px !important;border-right:0px !important;">
                            <div style="vertical-align: middle;margin-left:12px;padding-left:130px;">
                                <asp:Literal ID="litFirst" runat="server"></asp:Literal>
                            </div>
                            <div style="margin-left:5px;">
                                <asp:Literal ID="litPage" runat="server"></asp:Literal>
                            </div>
                            <div style="vertical-align: middle;margin-left:5px;">
                                <asp:Literal ID="litLast" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </PagerTemplate>
                    <Columns>
                        <asp:BoundField ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="editLeftPaddedCol" DataField="DisplayName" HeaderText="Name" NullDisplayText="--" SortExpression="" />
                        <asp:BoundField ItemStyle-CssClass="editLeftPaddedCol" HeaderStyle-CssClass="editLeftPaddedCol" DataField="Institution" HeaderText="Institution" NullDisplayText="--" SortExpression="" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </asp:Panel>
</div>
<asp:Literal runat="server" ID="litPagination"></asp:Literal>