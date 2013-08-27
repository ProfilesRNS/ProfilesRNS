<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewPersonGeneralInfo.ascx.cs"
    Inherits="Profiles.Profile.Modules.CustomViewPersonGeneralInfo.CustomViewPersonGeneralInfo" %>
<table>
    <tr>
        <td>
            <asp:Literal runat="server" ID="litPersonalInfo"></asp:Literal>
        </td>
        <td style="width:250px;padding-left:25px" align="right" valign="top">
            <asp:Image itemprop="image" runat="server" ID="imgPhoto" />
        </td>
    </tr>
</table>
