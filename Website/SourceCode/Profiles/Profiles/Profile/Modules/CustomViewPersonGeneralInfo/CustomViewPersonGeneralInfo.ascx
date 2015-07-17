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
<div id="toc"><ul></ul><div style="clear:both;"></div></div>
<!-- for testing ORNG gadgets -->
<asp:Panel runat="server" ID="pnlSandboxGadgets" Visible="false">
    <div class= "PropertyGroup">Newly found "Sandbox" Gadgets</div>
    <div class="SupportText">Note that this section is only visible when you login in through the 
        <asp:HyperLink ID="hlORNG" NavigateUrl="~/ORNG" runat="server">ORNG</asp:HyperLink> interface with new gadgets that you want to test. Unrecognized Gadgets will be rendered in a "sandbox" view</div><p></p>
    <asp:Literal runat="server" ID="litSandboxGadgets" Visible="false"/>
</asp:Panel>
