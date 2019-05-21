<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GroupAdmin.ascx.cs" Inherits="Profiles.GroupAdmin.Modules.GroupAdmin.GroupAdmin" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<script type="text/javascript">
    var verifyDate = (function () {
        var re = /^(0?\d|1[12])\/([012]?\d|3[01])\/\d\d\d\d/;
        return function () {
            var str = $(".textBoxDate").val();
            if (str == "") { return true; }
            if (!re.test(str)) { alert("End date format invalid. \n\nPlease edit your entry."); return false; }
            var d = new Date(str);
            var today = new Date();
            if (d > today) { return true; }
            if (d <= today) { alert("End date must be in the future. \n\nPlease edit your entry."); return false; }
            alert("End date format invalid. \n\nPlease edit your entry."); return false;
        }
        return true;
    })();
    $(".pageTitle").css("padding-bottom", "16px");
    $(document).ready(function () { $(".editPage input[type='image']").css("margin-bottom", "0px"); });
</script>


<asp:PlaceHolder ID="phAddGroups" runat="server">
    <div class="EditMenuItem">
        <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddGroups_OnClick" runat="server" ID="btnImgAddGroup" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnAddGroups" runat="server" OnClick="btnAddGroups_OnClick" CssClass="profileHypLinks">Create a New Group</asp:LinkButton>
    </div>
</asp:PlaceHolder>
<asp:PlaceHolder ID="phDeletedGroups" runat="server">
    <div class="EditMenuItem">
        <asp:ImageButton CssClass="EditMenuLinkImg" runat="server" ID="btnImgDeletedGroups" AlternateText=" " OnClick="btnDeletedGroups_OnClick" ImageUrl="~/Framework/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnDeletedGroups" runat="server" OnClick="btnDeletedGroups_OnClick" CssClass="profileHypLinks">Deleted Groups</asp:LinkButton>
    </div>
</asp:PlaceHolder>
<asp:Panel ID="pnlAddGroup" CssClass="EditPanel" runat="server" Visible="false">
    <div class="content_container">
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0; right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF; font-size: 36px; left: 40%; top: 40%;">
                        <img alt="Loading.." src="<%=GetURLDomain()%>/Edit/Images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>

        <div style="margin-bottom:8px;">
            Enter the Name End Date of the group.  The group will initially private, which you can change in later.
        </div>
        <div style="display:flex">
            <div style="padding-top: 3px;">
                <b>Group Name</b>
            </div>
            <div style="margin-bottom: 10px;margin-left:5px;">
                <asp:TextBox ID="txtGroupName" runat="server" MaxLength="250" Width="320px" title="Group Name"></asp:TextBox>
            </div>

            <div style="font-weight: bold;margin-left:8px;padding-top: 3px;">End Date (MM/DD/YYYY)  </div>
            <div style="margin-left:5px;">
                <asp:TextBox ID="txtEndDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
                <asp:ImageButton ID="btnCalendar" runat="server" Width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate" PopupButtonID="btnCalendar">
                </asp:CalendarExtender>
            </div>

        </div>
        <div class="actionbuttons">
            <asp:LinkButton ID="btnInsertGroupClose" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick" OnClientClick="Javascript:return verifyDate();"
                Text="Save"></asp:LinkButton>
            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                       
                        <asp:LinkButton ID="btnInsertGroup" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick" OnClientClick="Javascript:return verifyDate();"
                            Text="Save and Add Another"></asp:LinkButton>
            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                       
                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnAddGroups_OnClick"
                            Text="Cancel"></asp:LinkButton>
        </div>

    </div>
</asp:Panel>

<asp:Panel ID="pnlDeletedGroups" CssClass="editPage" runat="server" Visible="false">
    <asp:GridView ID="gvDeletedGroups" AutoGenerateColumns="false"
        DataKeyNames="GroupID, GroupNodeID"
        runat="server"
        OnRowEditing="gvDeletedGroups_RowEditing">
        <HeaderStyle CssClass="topRow" />
        <Columns>
            <asp:TemplateField HeaderStyle-CssClass="alignAwardsDates" ItemStyle-CssClass="alignAwardsDates" HeaderText="Group Name">
                <ItemTemplate>
                    <asp:Label ID="lblGroupName" runat="server" Text='<%# Bind("GroupName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="Visibility">
                <ItemTemplate>
                    <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="End Date">
                <ItemTemplate>
                    <asp:Label ID="lblEndDate" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="Action">
                <ItemTemplate>

                    <asp:LinkButton ID="lnkEdit" runat="server"
                        CausesValidation="False" CommandName="Edit" Text="Restore" AlternateText="Edit"></asp:LinkButton>

                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <div class="editBody">
        <asp:Label runat="server" ID="lblNoGroups" Text="No groups have been deleted." Visible="false"></asp:Label>
    </div>
</asp:Panel>
<div class="editPage">
    <asp:GridView ID="gvGroups" AutoGenerateColumns="false"
        DataKeyNames="GroupID, GroupNodeID" runat="server" OnRowDataBound="gvGroups_OnRowDataBound"
        OnRowCancelingEdit="gvGroups_RowCancelingEdit"
        OnRowDeleting="gvGroups_RowDeleting" OnRowEditing="gvGroups_RowEditing"
        OnRowUpdated="gvGroups_RowUpdated" OnRowUpdating="gvGroups_RowUpdating">
        <HeaderStyle CssClass="topRow" />
        <Columns>
            <asp:TemplateField HeaderStyle-CssClass="alignAwardsDates" ItemStyle-CssClass="alignAwardsDates" HeaderText="Group Name">
                <EditItemTemplate>
                    <asp:TextBox ID="txtGroupName" runat="server" MaxLength="250" Width="200" Text='<%# Bind("GroupName") %>' title="Group Name"></asp:TextBox>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:HyperLink ID="hlGroup" runat="server" Text='<%# Bind("GroupName") %>'
                        NavigateUrl='<%# Bind("GroupURI") %>'></asp:HyperLink>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="Visibility">
                <EditItemTemplate>
                    <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="End Date">
                <EditItemTemplate>
                    <asp:TextBox ID="txtEndDate" runat="server" MaxLength="50" Text='<%# Bind("EndDate") %>' title="End Date" CssClass="textBoxDate"></asp:TextBox>
                    <asp:ImageButton ID="btnCalendar" runat="server" Width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                    <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate"
                        PopupButtonID="btnCalendar">
                    </asp:CalendarExtender>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="lblEndDate" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="alignCenterAction" HeaderText="Action">
                <EditItemTemplate>
                    <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Save" OnClientClick="Javascript:return verifyDate();" />
                    &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </EditItemTemplate>
                <ItemTemplate>
                    <span style="margin-right:5px">
                        <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                            CausesValidation="False" CommandName="Edit" Text="Edit" AlternateText="Edit"></asp:ImageButton></span>
                    <span>
                        <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                            CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                            Text="X" AlternateText="Delete"></asp:ImageButton></span>

                    </div>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</div>
