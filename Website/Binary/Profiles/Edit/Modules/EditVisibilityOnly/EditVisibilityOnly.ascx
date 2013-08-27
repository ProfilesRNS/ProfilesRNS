<%@ Control Language="C#" AutoEventWireup="true" 
CodeBehind="EditVisibilityOnly.ascx.cs" Inherits="Profiles.Edit.Modules.EditVisibilityOnly.EditVisibilityOnly" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<asp:UpdatePanel ID="upnlEditSection" runat="server">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 36px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table  width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding: 10px 0px;">
                        <security:Options runat="server" ID="securityOptions"></security:Options>
                    </div>
                </td>
            </tr>           
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
