<%@ Control Language="C#" AutoEventWireup="true" 
CodeBehind="EditVisibilityOnly.ascx.cs" Inherits="Profiles.Edit.Modules.EditVisibilityOnly.EditVisibilityOnly" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<asp:UpdatePanel ID="upnlEditSection" runat="server">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span><img alt="Loading..." src="../edit/images/loader.gif" /></span>
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
