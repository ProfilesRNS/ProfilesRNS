<%@ Control Language="C#" AutoEventWireup="true" 
    CodeBehind="EditFeaturedVideos.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditSocialMediaPlugIns.FeaturedVideos" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server" DynamicLayout="true" DisplayAfter="1000">
            <ProgressTemplate>
                <div class="modalupdate">
                    <div class="modalcenter">
                        <img alt="Updating..." src="<%=Profiles.Framework.Utilities.Root.Domain%>/edit/images/loader.gif" /><br />
                        <i>Updating...</i>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:HiddenField runat="server" ID="hdnURL" />

<div class="editBackLink">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>
<asp:Panel ID="phSecuritySettings" runat="server">
    <security:Options runat="server" ID="securityOptions"></security:Options>
</asp:Panel>
<asp:Panel runat="server" ID="pnlAddEdit">
    <div class="EditMenuItem">
        <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddEdit_OnClick" runat="server" ID="imbAddArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnAddEditEdit" runat="server" OnClick="btnAddEdit_OnClick">Add YouTube</asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel ID="pnlImportYouTube" runat="server" CssClass="EditPanel" Visible="false">
    <div style="margin-bottom: 10px;">
        Display videos in a playlist from <a href="https://www.YouTube.com" target="_blank">YouTube.com</a> on your profile. 
    </div>
    <div style="padding-top: 3px;">
        <div style="margin-bottom: 5px;">
            <div style="margin-bottom: 4px"><b>Description</b></div>
            <asp:TextBox Width="400px" runat="server" MaxLength="55" ID="txtName"></asp:TextBox>
        </div>
        <div style="margin-bottom: 5px;">
            <div style="margin-bottom: 4px"><b>YouTube URL</b></div>
            <asp:TextBox Width="400px" runat="server" ID="txtURL"></asp:TextBox>
        </div>
        <div class="actionbuttons">
            <asp:LinkButton ID="btnSaveAndClose" runat="server" CausesValidation="False"
                OnClick="btnSaveAndClose_OnClick" Text="Save" TabIndex="11" />
            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" OnClick="btnCancel_OnClick"
                    Text="Cancel" TabIndex="7" />
        </div>
    </div>
</asp:Panel>
<div class="editPage">
    <asp:GridView ID="GridViewVideos" runat="server" AutoGenerateColumns="False"
        DataKeyNames="name,id, url" GridLines="Both"
        OnRowCancelingEdit="GridViewVideos_RowCancelingEdit" OnRowDataBound="GridViewVideos_RowDataBound"
        OnRowDeleting="GridViewVideos_RowDeleting" OnRowEditing="GridViewVideos_RowEditing"
        OnRowUpdating="GridViewVideos_RowUpdating" OnRowUpdated="GridViewVideos_RowUpdated"
        CssClass="editBody">
        <HeaderStyle CssClass="topRow" />
        <Columns>
            <asp:TemplateField HeaderText="Description" ItemStyle-CssClass="alignLeft" HeaderStyle-CssClass="alignLeft">
                <EditItemTemplate>
                    <asp:TextBox ID="txtVideoDescription" runat="server" MaxLength="400" Width="450px" Text='<%# Bind("Name") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label5" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Url" HeaderStyle-CssClass="alignCenter" ItemStyle-CssClass="alignCenter">
                <EditItemTemplate>
                    <asp:Literal ID="litPreview" runat="server" Text='<%# Bind("Url") %>'></asp:Literal>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Literal ID="litPreview" runat="server" Text='<%# Bind("Url") %>'></asp:Literal>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                <EditItemTemplate>
                    <asp:LinkButton ID="lnkUpdate" runat="server"
                        CausesValidation="True" CommandName="Update" Text="Save" />
                    &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp
                                <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </EditItemTemplate>
                <ItemTemplate>
                    <span>
                        <asp:ImageButton OnClick="ibUp_Click" runat="server" CommandArgument="up" CommandName="action"
                            ID="ibUp" ImageUrl="~/Edit/Images/icon_up.gif" AlternateText="Move Up" />
                        <asp:ImageButton runat="server" ID="ibUpGray" Enabled="false" Visible="false" ImageUrl="~/Edit/Images/Icon_rounded_ArrowGrayUp.png" AlternateText="Move Up" />
                    </span>
                    <span>
                        <asp:ImageButton runat="server" OnClick="ibDown_Click" ID="ibDown" CommandArgument="down"
                            CommandName="action" ImageUrl="~/Edit/Images/icon_down.gif" AlternateText="Move Down" />
                        <asp:ImageButton runat="server" ID="ibDownGray" Enabled="false" Visible="false" ImageUrl="~/Edit/Images/Icon_rounded_ArrowGrayDown.png" AlternateText="Move Down" />
                    </span>
                    <span>
                        <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                            CausesValidation="False" CommandName="Edit" AlternateText="Edit"></asp:ImageButton>
                    </span>
                    <span>
                        <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                            CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                            AlternateText="Delete"></asp:ImageButton>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <div class="editBody" style="text-align: left;" id="divNoVideos" runat="server">
        <i></i>
        <asp:Label runat="server" ID="lblNoVideos" Text="No videos have been added to your playlist."></asp:Label>
    </div>
</div>

<script>
    $("#<%=txtURL.ClientID%>").on("focusout", function () {
        var r, rx = /^.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*/;
        var s = $("#<%=txtURL.ClientID%>").val();
        r = s.match(rx);
        $("#<%=hdnURL.ClientID%>").val((r[1]));
    });
</script>
