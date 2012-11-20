<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ManageProxies.ascx.cs"
    Inherits="Profiles.Proxy.Modules.ManageProxies.ManageProxies" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Literal ID="litBackLink" runat="server"></asp:Literal>
<br />
<br />
Proxies are people who can edit other people's profiles on their behalf. For example,
faculty can designate their assistants as proxies to edit their profiles. If you
have a profile, then one or more proxies might be assigned to you automatically
by your department or institution. You also have the option of designation your
own proxies.
<br />
<br />
If one of the people listed below has a icon in the Delete column, then you may
remove that person as your proxy.
<br />
<h3>
    Users who can edit your profile</h3>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 36px; left: 40%; top: 40%;">Loading ...</span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:GridView Width="100%" ID="gvMyProxies" EmptyDataText="None" AutoGenerateColumns="false"
            CellSpacing="-1" runat="server" OnRowDataBound="gvMyProxies_OnRowDataBound" GridLines="Both">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litName"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Institution" HeaderText="Institution" ReadOnly="true" />
                <asp:TemplateField HeaderText="Email">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litEmail"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Delete">
                    <ItemTemplate>
                        <asp:ImageButton OnClick="lnkDelete_OnClick" ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                            OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                            Text="X"></asp:ImageButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <br />
        <table>
            <tr>
                <td valign="middle">
                    <asp:Image runat="server" ID="imgAdd" OnClick="lnkAddProxy_OnClick" />&nbsp;
                </td>
                <td style="padding-bottom: 4px" valign="middle">                    
                    <asp:Literal runat="server" ID='lnkAddProxyTmp' Text = "Add A Proxy"></asp:Literal>
                </td>
            </tr>
        </table>
        <br />
        <br />
        <h3>
            Users who have given you permission to edit their profiles</h3>
        <asp:GridView Width="100%" ID="gvWhoCanIEdit" EmptyDataText="None" AutoGenerateColumns="false"
            GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="gvWhoCanIEdit_OnRowDataBound">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litName"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Institution" HeaderText="Institution" ReadOnly="true" />
                <asp:TemplateField HeaderText="Email">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litEmail"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
        <h3>
            Groups of users whose profiles you can edit</h3>
        You can edit the profiles of any user belonging to any of the organizations listed
        below. The Visible column indicates whether users in an organization can see that
        you have permission to edit their profiles.
        <br />
        <br />
        <asp:GridView Width="100%" ID="gvYouCanEdit" EmptyDataText="None" AutoGenerateColumns="false"
            GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="gvYouCanEdit_OnRowDataBound">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:BoundField DataField="Institution" HeaderText="Institution" ReadOnly="true" />
                <asp:BoundField DataField="Department" HeaderText="Department" ReadOnly="true" />
                <asp:BoundField DataField="Division" HeaderText="Division" ReadOnly="true" />
                <asp:BoundField DataField="Visible" HeaderText="Visible" ReadOnly="true" />
            </Columns>
        </asp:GridView>
    </ContentTemplate>
</asp:UpdatePanel>
