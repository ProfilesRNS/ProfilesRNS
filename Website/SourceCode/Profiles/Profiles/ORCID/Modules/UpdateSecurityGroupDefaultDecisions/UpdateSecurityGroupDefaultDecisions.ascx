<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateSecurityGroupDefaultDecisions.ascx.cs"
    Inherits="Profiles.ORCID.Modules.UpdateSecurityGroupDefaultDecisions.UpdateSecurityGroupDefaultDecisions" %>

<p>
<asp:Label class="lblDirections" runat="server" Text="Please review the the security groups listed below and determine the default visibility in ORCID for items with these permissions." />
<span class="uierror">Note:</span> When a user selects owner for the privacy settings in Profiles, the default setting for ORCID will always be private.
</p>

<asp:Repeater ID="rptSecurityGroups" runat="server" OnItemDataBound="rptSecurityGroups_ItemDataBound">
    <HeaderTemplate>
        <table class="data">
            <thead>
                <tr>
                    <th>
                        Security Group in Profiles
                    </th>
                    <th>
                        Default Permissions in ORCID
                    </th>
                </tr>
            </thead>
            <tbody>
    </HeaderTemplate>
    <ItemTemplate>
        <tr class="item">
            <td>
                <%# Eval("Label")%>
                <asp:Label ID="lblSecurityGroupID" Text='<%# Eval("SecurityGroupID")%>' runat="server" Visible="false" />
            </td>
            <td>
                <asp:DropDownList ID="ddlDefaultORCIDDecisionID" runat="server">
                    <asp:ListItem Value="1" Text="Public"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Limited"></asp:ListItem>
                    <asp:ListItem Value="3" Text="Private"></asp:ListItem>
                    <asp:ListItem Value="4" Text="Exclude"></asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
    </ItemTemplate>
    <AlternatingItemTemplate>
        <tr class="alt">
            <td>
                <%# Eval("Label")%>
                <asp:Label ID="lblSecurityGroupID" Text='<%# Eval("SecurityGroupID")%>' runat="server" Visible="false" />
            </td>
            <td>
                <asp:DropDownList ID="ddlDefaultORCIDDecisionID" runat="server">
                    <asp:ListItem Value="1" Text="Public"></asp:ListItem>
                    <asp:ListItem Value="2" Text="Limited"></asp:ListItem>
                    <asp:ListItem Value="3" Text="Private"></asp:ListItem>
                    <asp:ListItem Value="4" Text="Exclude"></asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="lblGroupError" runat="server" EnableViewState="false" />
            </td>
        </tr>
    </AlternatingItemTemplate>
    <FooterTemplate>
        </tbody> </table>
    </FooterTemplate>
</asp:Repeater>

<br />
<asp:Button ID="btnSaveChanges" runat="server" Text="Save Changes" 
    onclick="btnSaveChanges_Click" />

