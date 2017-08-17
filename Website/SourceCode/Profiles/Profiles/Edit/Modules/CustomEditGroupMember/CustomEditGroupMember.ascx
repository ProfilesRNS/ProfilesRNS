<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditGroupMember.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditGroupMember.CustomEditGroupMember" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
<asp:PlaceHolder ID="phAddPubMed" runat="server">
    <div style="padding-bottom: 10px;">
        <asp:LinkButton ID="btnAddGroupMembers" runat="server" OnClick="btnAddGroupMembers_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddGroupMembers" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;<asp:Literal runat="server" ID="btnLitAddGroupMembers"/></asp:LinkButton>
    </div>
</asp:PlaceHolder>
    <asp:Panel ID="pnlProxySearch" runat="server" Visible="false" >
        <div class="content_container">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table border="0" cellspacing="0" cellpadding="0" class="searchForm">
                            <tr>
                                <th>
                                    <asp:Label ID="Label1" runat="server" AssociatedControlID="txtLastName">Last Name</asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="txtLastName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="Label5" runat="server" AssociatedControlID="txtFirstName">First Name</asp:Label>
                                </th>
                                <td>
                                    <asp:TextBox ID="txtFirstName" runat="server" Width="250px" />
                                </td>
                            </tr>
                            <tr>
                                <th style="text-align: right;">
                                    <asp:Label ID="Label2" runat="server" AssociatedControlID="drpInstitution">Institution</asp:Label>
                                </th>
                                <td>
                                    <asp:DropDownList ID="drpInstitution" runat="server" Width="255px" AutoPostBack="false" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <asp:Label ID="Label3" runat="server" AssociatedControlID="drpDepartment">Department</asp:Label>
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
                                        <asp:Button ID="btnSearchReset" runat="server" Text="Reset" OnClick="btnSearchReset_Click" />
                                        &nbsp;&nbsp;<asp:Button ID="btnSearchCancel" runat="server" Text="Cancel" OnClick="btnAddGroupMembers_OnClick" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </asp:Panel>
        <asp:Panel ID="pnlProxySearchResults" runat="server" Visible="false" Style="background-color: #FFFFFF;
                            margin-bottom: 5px; border: solid 1px #999;">
        <div style="padding: 5px;">  
            <div>
                <div style="width: 25px; float: left;">
                    <asp:Image ID="Image1" runat="server" ImageUrl="~/Framework/Images/icon_alert.gif" alt=" "/>
                </div>
                <div style="margin-left: 25px;">
                    Check the people you wish to add to this group, and then click the Add Selected link at the bottom of the page.
                </div>
            </div>                
           <asp:GridView EnableViewState="true" Width="100%" ID="gridSearchResults" runat="server" DataKeyNames="UserID, PersonID"
                AllowPaging="true" PageSize="50" EmptyDataText="No matching people could be found."
               AutoGenerateColumns="False" >
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
                    <asp:TemplateField ItemStyle-VerticalAlign="Top">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkPubMed" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="DisplayName" HeaderText="Name" NullDisplayText="--"  SortExpression="" />
                    <asp:BoundField DataField="Institution" HeaderText="Institution" NullDisplayText="--" SortExpression="" />


                </Columns>
            </asp:GridView><br />
                                <asp:LinkButton ID="Button1" runat="server" CausesValidation="False" OnClick="gvSearchResults_RowAdd" Text="Add Selected"/>
                                &nbsp;&nbsp;<asp:LinkButton ID="btnSearchCancel2" runat="server" Text="Cancel" OnClick="btnAddGroupMembers_OnClick" />
</div>

    </asp:Panel>
    <br />
    <asp:UpdatePanel ID="pnlGridViewMembers" runat="server" Visible="false">
    <ContentTemplate>
        <asp:GridView ID="GridViewMembers" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="UserID" GridLines="Both"
            OnRowCancelingEdit="GridViewMembers_RowCancelingEdit" OnRowDataBound="GridViewMembers_RowDataBound"
            OnRowDeleting="GridViewMembers_RowDeleting" OnRowEditing="GridViewMembers_RowEditing"
            OnRowUpdated="GridViewMembers_RowUpdated" OnRowUpdating="GridViewMembers_RowUpdating"
            Width="100%">
            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
            <RowStyle BorderStyle="Solid" BorderWidth="1px" />
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <EditItemTemplate>
                        <asp:Label ID="Label2e" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle Wrap="true" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Title">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtMemberTitle" runat="server" MaxLength="100" Text='<%# Bind("Title") %>' title="Name"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle Wrap="true" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Institution">
                    <EditItemTemplate>
                        <asp:Label ID="Label4e" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle Wrap="true" />
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" HeaderText="Action"
                    ShowHeader="False">
                    <EditItemTemplate>
                        <table class="actionbuttons">
                            <tr>
                                <td>
                                    <asp:ImageButton ID="lnkUpdate" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                        CausesValidation="True" CommandName="Update" Text="Update" AlternateText="Update"></asp:ImageButton>
                                </td>
                                <td>
                                    <asp:ImageButton ID="lnkCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                        CausesValidation="False" CommandName="Cancel" Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                </td>
                            </tr>
                        </table>
                    </EditItemTemplate>
                    <ItemTemplate>
                    </ItemTemplate>
                    <ItemTemplate>
                        <div class="actionbuttons">
                            <table>
                                <tr>
                                    <td>
                                        <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                            CausesValidation="False" CommandName="Edit" Text="Edit" AlternateText="Edit"></asp:ImageButton>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                            CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                                            Text="X" AlternateText="Delete"></asp:ImageButton>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <i><asp:Label runat="server" ID="lblNoMembers" Text="No members have been added." Visible ="false"></asp:Label></i>     
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="pnlGridViewManagers" runat="server" Visible="false">
    <ContentTemplate>
        <asp:GridView ID="GridViewManagers" runat="server" AutoGenerateColumns="False" CellPadding="4"
            DataKeyNames="UserID" GridLines="Both"
            OnRowDataBound="GridViewManagers_RowDataBound"
            OnRowDeleting="GridViewManagers_RowDeleting"
            Width="100%">
            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
            <RowStyle BorderStyle="Solid" BorderWidth="1px" />
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle Wrap="true" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Institution">
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle Wrap="true" />
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" HeaderText="Action"
                    ShowHeader="False">
                    <ItemTemplate>
                        <div class="actionbuttons">
							<asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
								CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
								Text="X" AlternateText="Delete"></asp:ImageButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <i><asp:Label runat="server" ID="lblNoManagers" Text="No managers have been added." Visible ="false"></asp:Label></i>     
        </ContentTemplate>
    </asp:UpdatePanel>

</div>
<asp:Literal runat="server" ID="litPagination"></asp:Literal>