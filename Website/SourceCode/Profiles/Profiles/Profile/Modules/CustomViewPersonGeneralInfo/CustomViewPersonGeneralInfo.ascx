<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewPersonGeneralInfo.ascx.cs"
    Inherits="Profiles.Profile.Modules.CustomViewPersonGeneralInfo.CustomViewPersonGeneralInfo" %>
<table style="margin-top: 15px;">
    <tr>
        <td style="padding-right:30px;padding-top:10px;" align="right" valign="top">
            <asp:Image itemprop="image" runat="server" ID="imgPhoto" />
        </td>
        <td valign="top">
            <asp:Literal runat="server" ID="litPersonalInfo"></asp:Literal>
        </td>
    </tr>
</table>
<div id="toc"><ul></ul></div>

