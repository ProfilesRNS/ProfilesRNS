<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditMailingAddress.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditMailingAddress.CustomEditMailingAddress" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server">
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
                                    Mailing Address
                                </td>
                            </tr>
                            <tr class="editTable">
                                <td style="padding: 5px 10px">
                                    <asp:Literal runat="server" ID="litMailingAddress"></asp:Literal>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <br />
                         Mailing Address comes from an automatic data feed from Human Resources.
                    </div>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
