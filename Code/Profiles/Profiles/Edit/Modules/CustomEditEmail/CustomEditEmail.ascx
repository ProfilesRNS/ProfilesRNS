<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditEmail.ascx.cs" Inherits="Profiles.Edit.Modules.CustomEditEmail.CustomEditEmail" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server">
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
                        <table width="100%">
                            <tr class="topRow editTable">
                                <td>
                                    Email Address
                                </td>
                            </tr>
                            <tr class="editTable">
                                <td style="padding: 5px 10px">
                                    <asp:Literal runat="server" ID="litEmailAddress"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
