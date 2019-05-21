<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditGroupMember.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditGroupMember.CustomEditGroupMember" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<script type="text/javascript">
    $(document).ready(function () {
        $("input[type='radio']").css("padding-top", "6px !important");
    });


    function ShowStatus() {

        document.getElementById("divStatus").style.display = "block";
        $(".editPage input[type='image']").attr("style", "margin-bottom:0px")
    }
</script>


<div id="divStatus" style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; opacity: 0.7; display: none">
    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">
        <img alt="Loading..." src="<%=GetURLDomain()%>/Edit/Images/loader.gif" /></span>
</div>
<div class="editBackLink">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>
<asp:Panel ID="phAddPubMed" runat="server">
    <div class="EditMenuItem">
        <asp:ImageButton CssClass="EditMenuLinkImg" runat="server" ID="btnImgAddGroupMembers" OnClick="btnAddGroupMembers_OnClick" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnAddGroupMembers" runat="server" OnClick="btnAddGroupMembers_OnClick">
            <asp:Literal runat="server" ID="btnLitAddGroupMembers" />
        </asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel ID="pnlProxySearch" CssClass="EditPanel" runat="server" Visible="false">
    <div class="searchForm">

        <table>
            <tr>
                <th>
                    <asp:Label ID="Label1" runat="server" AssociatedControlID="txtLastName">Last Name</asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="txtLastName" runat="server" Width="255px" />
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label5" runat="server" AssociatedControlID="txtFirstName">First Name</asp:Label>
                </th>
                <td>
                    <asp:TextBox ID="txtFirstName" runat="server" Width="255px" />
                </td>
            </tr>
            <tr>
                <th style="text-align: right;">
                    <asp:Label ID="Label2" runat="server" AssociatedControlID="drpInstitution">Institution</asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="drpInstitution" runat="server" Width="255px" Height="25px" AutoPostBack="false" />
                </td>
            </tr>
            <tr>
                <th>
                    <asp:Label ID="Label3" runat="server" AssociatedControlID="drpDepartment">Department</asp:Label>
                </th>
                <td>
                    <asp:DropDownList ID="drpDepartment" runat="server" Width="255px" Height="25px" AutoPostBack="false" />
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

</asp:Panel>
<asp:Panel ID="pnlProxySearchResults" runat="server" Visible="false" CssClass="editPage">
    <div class="editPage">

        <div style="width: 25px; float: left;">
            <img src="<%=Profiles.Framework.Utilities.Root.Domain%>/Edit/Images/icon_alert.gif" />
        </div>
        <div style="margin-left: 25px; margin-top: 3px;">
            Check the people you wish to add to this group, and then click the Add Selected link at the bottom of the page.               
        </div>
        <div style="margin-top: 5px;">
            <asp:GridView EnableViewState="true" OnRowDataBound="gridSearchResults_RowDataBound"
                ID="gridSearchResults" runat="server" DataKeyNames="UserID, PersonID"
                AllowPaging="false" PageSize="100" AutoGenerateColumns="false" EmptyDataRowStyle-BorderStyle="None" EmptyDataRowStyle-BorderWidth="0"  EmptyDataText="<div style='margin:10px'>No matching people could be found.</div>">
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Select" ItemStyle-CssClass="alignCenterAction">
                        <ItemTemplate>
                            <asp:CheckBox ID="chkPubMed" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="DisplayName" HeaderText="Name" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution" NullDisplayText="--" />
                    <asp:BoundField DataField="Institution" HeaderText="Institution" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution" NullDisplayText="--" />
                </Columns>
            </asp:GridView>
            <div class="actionbuttons">
                <asp:LinkButton ID="Button1" runat="server" CausesValidation="False" OnClick="gvSearchResults_RowAdd" Text="Add Selected" />
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnSearchCancel2" runat="server" Text="Cancel" OnClick="btnAddGroupMembers_OnClick" />
            </div>
        </div>
    </div>

</asp:Panel>

<asp:Panel ID="pnlGridViewMembers" runat="server" Visible="false" CssClass="editPage">
    <asp:GridView ID="GridViewMembers" runat="server" AutoGenerateColumns="False"
        DataKeyNames="UserID" GridLines="Both"
        OnRowCancelingEdit="GridViewMembers_RowCancelingEdit" OnRowDataBound="GridViewMembers_RowDataBound"
        OnRowDeleting="GridViewMembers_RowDeleting" OnRowEditing="GridViewMembers_RowEditing"
        OnRowUpdated="GridViewMembers_RowUpdated" OnRowUpdating="GridViewMembers_RowUpdating"
        Width="100%">
        <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
        <RowStyle BorderStyle="Solid" BorderWidth="1px" />
        <Columns>
            <asp:TemplateField HeaderText="Name" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                <EditItemTemplate>
                    <asp:Label ID="Label2e" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle Wrap="true" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Title" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                <EditItemTemplate>
                    <asp:TextBox ID="txtMemberTitle" runat="server" MaxLength="100" Text='<%# Bind("Title") %>' title="Name"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Title") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle Wrap="true" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Institution" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                <EditItemTemplate>
                    <asp:Label ID="Label4e" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle Wrap="true" />
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                <EditItemTemplate>
                    <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Save" OnClientClick="Javascript:return verifyDate();" />
                    &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />

                </EditItemTemplate>
                <ItemTemplate>
                </ItemTemplate>
                <ItemTemplate>

                    <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                        CausesValidation="False" CommandName="Edit" Text="Edit" AlternateText="Edit"></asp:ImageButton>
                    <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                        CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                        Text="X" AlternateText="Delete"></asp:ImageButton>

                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <i>
        <asp:Label runat="server" ID="lblNoMembers" Text="No members have been added." Visible="false"></asp:Label></i>

</asp:Panel>
<asp:Panel ID="pnlGridViewManagers" runat="server" Visible="false" CssClass="editPage">

    <asp:GridView ID="GridViewManagers" runat="server" AutoGenerateColumns="False"
        DataKeyNames="UserID"
        OnRowDataBound="GridViewManagers_RowDataBound"
        OnRowDeleting="GridViewManagers_RowDeleting">
        <HeaderStyle CssClass="topRow" />
        <Columns>
            <asp:TemplateField HeaderText="Name" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("DisplayName") %>'></asp:Label>
                </ItemTemplate>

            </asp:TemplateField>
            <asp:TemplateField HeaderText="Institution" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                <ItemTemplate>
                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("InstitutionName") %>'></asp:Label>
                </ItemTemplate>

            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                <ItemTemplate>
                    <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                        CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                        Text="X" AlternateText="Delete"></asp:ImageButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <i>
        <asp:Label runat="server" ID="lblNoManagers" Text="No managers have been added." Visible="false"></asp:Label></i>

</asp:Panel>


<asp:Literal runat="server" ID="litPagination"></asp:Literal>