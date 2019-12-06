<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditFeaturedPresentations.ascx.cs" Inherits="Profiles.Edit.Modules.EditSocialMedia.FeaturedPresentations.FeaturedPresentations" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<asp:Literal ID="litjs" runat="server"></asp:Literal>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
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
<div class="editBackLink">
    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
</div>
<asp:Panel ID="phSecuritySettings" runat="server">
    <security:Options runat="server" ID="securityOptions"></security:Options>
</asp:Panel>
<asp:Panel runat="server" ID="pnlAddEdit">
    <div class="EditMenuItem">
        <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddEdit_OnClick" runat="server" ID="imbAddArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnAddEditEdit" runat="server" OnClick="btnAddEdit_OnClick">Add SlideShare</asp:LinkButton>
    </div>
</asp:Panel>
<asp:Panel runat="server" ID="pnlDelete">
    <div class="EditMenuItem">
        <asp:Image runat="server" CssClass="EditMenuLinkImgGray" ID="btnImgDeleteGray" AlternateText=" " ImageUrl="~/Edit/Images/Icon_square_ArrowGray.png" Visible="false" />
        <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnDelete_OnClick" runat="server" ID="imbDeleteArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
        <asp:LinkButton ID="btnDelete" runat="server" OnClick="btnDelete_OnClick">Delete SlideShare</asp:LinkButton>
        <asp:Literal ID="btnDeleteGray" Visible="false" runat="server" Text="Delete SlideShare" />&nbsp;(Remove SlideShare account from your profile.)                               
    </div>
</asp:Panel>
<asp:Panel ID="pnlImportSlides" runat="server" CssClass="EditPanel" Visible="false">
    <div>Attach SlideShare Presentations</div>
    <div style="padding: 5px 0px 10px 0px;">
        Display presentations that you have uploaded to <a href="https://www.SlideShare.net" target="_blank">SlideShare.net</a> on your profile.  If you do not currently have a SlideShare account, please visit <a href="https://www.SlideShare.net" target="_blank">SlideShare.net</a> to create an account and upload presentations.  Then enter your SlideShare Username, not the display name, in the space below to link your SlideShare account to your profile.  User names cannot contain special characters or spaces. 
    </div>
    <div style="padding-top: 3px;">
        <div>
            <b>SlideShare Username</b>
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
<asp:Panel ID="pnlDeleteSlides" runat="server" CssClass="EditPanel" Visible="false">
    Remove SlideShare Presentations
           <div style="padding: 5px 0px 8px 0px;">
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
           </div>
</asp:Panel>
<div id="divNoSlideshare" style="text-align: left;margin-top:8px;" runat="server"><i>There is currently no SlideShare account on your profile.</i></div>
<div runat="server" id="divShowSlideShare" style="margin-top: 8px">
    <!-- ==================== START PROFILE VIEW =================== -->
       <div class="profile-view-slideshare">
               <div style="padding-top:11px;padding-bottom:5px;"> <b>Slides for:</b>
        <asp:Literal runat="server" ID="lblUsername"></asp:Literal></div>
        <div id="slideshow-canvas">
            <iframe src="" width="440" height="440" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe>
            <div style="margin-bottom: 5px; overflow: hidden;"></div>
        </div>
    </div>
</div>

