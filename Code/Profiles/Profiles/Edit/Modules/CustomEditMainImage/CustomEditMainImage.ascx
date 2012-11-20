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
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;">Loading ...</span>
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
                <br />
                    <asp:Panel runat="server" ID="pnlSecurityOptions">
                        <security:Options runat="server" ID="securityOptions"></security:Options>
                    </asp:Panel>
                  
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                                <asp:Image runat="server" ID="imgPhoto" />
                                <i><asp:label runat="server" ID="lblNoImage" Text="No photo found." Visible = "false"></asp:label></i>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br />
        <asp:Panel runat="server" ID="pnlUpload">
            <cc1:AsyncFileUpload ID="AsyncFileUpload1" runat="server" OnUploadedComplete="ProcessUpload"
                OnClientUploadComplete="showUploadConfirmation" ThrobberID="spanUploading" />
            <span id="spanUploading" runat="server">Uploading...</span>
            <br />
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
