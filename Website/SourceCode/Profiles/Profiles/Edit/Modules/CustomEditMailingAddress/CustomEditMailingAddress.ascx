<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditMailingAddress.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditMailingAddress.CustomEditMailingAddress" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span><img alt="Loading..." src="../edit/images/loader.gif" width="400" height="213"/></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table id="tblEditMailingAddress" width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding: 10px 0px;">
                        <asp:Panel runat="server" ID="pnlSecurityOptions">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                        </asp:Panel>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div class="editPage">
<!--
                        <table width="100%">
                            <tr class="topRow editTable">
                                <td>
                                    Mailing Address
                                </td>
                            </tr>
                            <tr class="editTable">
                                <td style="padding: 5px 10px">
                                    <asp:Literal runat="server" ID="litMailingAddress"></asp:Literal>
                                </td>
                            </tr>
                        </table>
-->
                        <br />
                        <br />
                         This info is drawn from the Campus Locator System. Please contact your HR representative for corrections.
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
