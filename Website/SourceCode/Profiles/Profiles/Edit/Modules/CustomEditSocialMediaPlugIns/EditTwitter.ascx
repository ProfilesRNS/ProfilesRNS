<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditTwitter.ascx.cs" Inherits="Profiles.Edit.Modules.CustomEditSocialMediaPlugIns.Twitter" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<script type="text/JavaScript">
    Twitter = {
        init: function (username) {

            $("div#twitter-link").html('');
            $("div#twitter-link").append("<a data-height='150' data-width='400' class='twitter-timeline' data-tweet-limit='1' href='https://twitter.com/" + username + "'>Tweets by " + username + "</a>");
        }
    }

</script>
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

        <div class="editBackLink">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </div>
        <asp:Panel ID="phSecuritySettings" runat="server">
            <security:Options runat="server" ID="securityOptions"></security:Options>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlAddEdit">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddEdit_OnClick" runat="server" ID="imbAddArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnAddEditEdit" runat="server" OnClick="btnAddEdit_OnClick">Add Twitter</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlDelete">
            <div class="EditMenuItem">
                <asp:Image runat="server" CssClass="EditMenuLinkImgGray" ID="btnImgDeleteGray" AlternateText=" " ImageUrl="~/Edit/Images/Icon_square_ArrowGray.png" Visible="false" />
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnDelete_OnClick" runat="server" ID="imbDeleteArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_OnClick">Delete Twitter</asp:LinkButton>
                <asp:Literal ID="btnDeleteGray" Visible="false" runat="server" Text="Delete Twitter" />&nbsp;(Remove Twitter account from your profile.)                               
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlImportTwitter" runat="server" CssClass="EditPanel" Visible="false">
            <div>Attach Twitter Account</div>
            <div style="padding: 5px 0px 10px 0px;">
                Display your most recent tweets from <a href="https://www.Twitter.com" target="_blank">Twitter.net</a> on your profile.  If you do not currently have a Twitter account, you can select one you follow.
            </div>
            <div style="padding-top: 3px;">
                <div>
                    <b>Twitter Username</b>
                    <asp:TextBox runat="server" ID="txtUsername"></asp:TextBox>
                    <div class="actionbuttons">
                        <asp:LinkButton ID="btnSaveAndClose" runat="server" CausesValidation="False"
                            OnClick="btnSaveAndClose_OnClick" Text="Save" TabIndex="11" />
                        <asp:Literal runat="server" ID="lblInsertResearcherRolePipe">&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;</asp:Literal>
                        <asp:LinkButton ID="btnCancel" runat="server" CausesValidation="False" OnClick="btnCancel_OnClick"
                            Text="Cancel" TabIndex="7" />
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlDeleteTwitter" runat="server" CssClass="EditPanel" Visible="false">
            Remove Twitter           
               <div style="padding-top: 3px; margin-bottom: 10px;">
                   <asp:Label runat="server" ID="txtUidToDelete"></asp:Label>
                   <div class="actionbuttons">
                       <asp:LinkButton ID="lnkbtnDeleteClose" runat="server" CausesValidation="False"
                           OnClick="btnDeleteClose_OnClick" Text="Delete" TabIndex="11" />
                       <asp:Literal runat="server" ID="Literal1">&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;</asp:Literal>
                       <asp:LinkButton ID="lnkbtnCancel" runat="server" CausesValidation="False" OnClick="btnDeleteCancel_OnClick"
                           Text="Cancel" TabIndex="7" />
                   </div>
               </div>
        </asp:Panel>
        <div id="divNoTwitter" style="text-align: left; margin-top: 8px;" runat="server"><i>There is currently no twitter account on your profile.</i></div>
        <div runat="server" id="divShowTwitter" style="margin-top: 8px">
            <b>Your most recent tweets:&nbsp;</b><asp:Label runat="server" ID="lblUsername"></asp:Label>
            <div id="twitter-link">
            </div>
            <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
        </div>
        <asp:Literal runat="server" ID="litjs"></asp:Literal>
    </ContentTemplate>

</asp:UpdatePanel>
