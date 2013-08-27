<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditMainImage.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditMainImage.CustomEditMainImage" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">
    function showUploadConfirmation() {
        document.forms[0].submit();
    }
</script>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table>
            <tr>
                <td>
                    <asp:Literal ID="litBackLink" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>
                        <div style="padding: 10px 0px;">
                    <asp:Panel runat="server" ID="pnlSecurityOptions">
                    <div style="padding-bottom: 10px;">
                        <security:Options runat="server" ID="securityOptions"></security:Options>                        
                        </div>
                    </asp:Panel>
                    <asp:PlaceHolder ID="phAddCustomPhoto" runat="server">
                        <div style="padding-bottom: 10px;">
                            <asp:ImageButton ID="btnImgAddCustomPhoto" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                OnClick="btnAddCustomPhoto_OnClick" />&nbsp;
                            <asp:LinkButton ID="btnAddCustomPhoto" runat="server" OnClick="btnAddCustomPhoto_OnClick"
                                CssClass="profileHypLinks">Add/Edit Custom Photo</asp:LinkButton>
                        </div>
                    </asp:PlaceHolder>
                    </div>
                </td>
            </tr>
        </table>
        <table>
            <tr>
                <td>
                    <asp:Image runat="server" ID="imgPhoto" />
                    <i>
                        <asp:Label runat="server" ID="lblNoImage" Text="No photo found." Visible="false"></asp:Label></i>
                </td>
            </tr>
        </table>
        <div runat="server" ID="pnlUpload" visible="false">
        <br />
            Select custom photo for upload
            <cc1:AsyncFileUpload ID="AsyncFileUpload1" runat="server" OnUploadedComplete="ProcessUpload"
                OnClientUploadComplete="showUploadConfirmation" ThrobberID="spanUploading" />                        
            <span id="spanUploading" runat="server">Uploading...</span>
            <br />
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
