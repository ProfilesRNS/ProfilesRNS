<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MyNetwork.ascx.cs" Inherits="Profiles.ActiveNetwork.Modules.MyNetwork.MyNetwork" %>
<table width="100%" cellpadding="10px">
    <tr valign="top">
        <td>
            <asp:Literal runat="server" ID="litCollaborators"></asp:Literal>
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvCollaborators" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" ImageUrl="~/Framework/Images/delete.png"
                                OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
        <td>
            <asp:Literal runat="server" ID="litAdvisorsCurrent"></asp:Literal>
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvAdvisorsCurrent" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" ImageUrl="~/Framework/Images/delete.png"
                                OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
        <td>
            <asp:Literal runat="server" ID="litAdviseesCurrent"></asp:Literal>
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvAdviseesCurrent" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" ImageUrl="~/Framework/Images/delete.png"
                                OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
    <tr valign="top">
        <td>
        </td>
        <td>
            <asp:Literal runat="server" ID="litAdvisorsPast"></asp:Literal>
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvAdvisorsPast" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" ImageUrl="~/Framework/Images/delete.png"
                                OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
        <td>
            <asp:Literal runat="server" ID="litAdviseesPast"></asp:Literal>
            <asp:GridView AutoGenerateColumns="false" runat="server" ID="gvAdviseesPast" EmptyDataText="None"
                GridLines="None" CellSpacing="-1" OnRowDataBound="gvActiveNetwork_OnRowDataBound"
                ShowHeader="False">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lbPerson"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-HorizontalAlign="Right">
                        <ItemTemplate>
                            <asp:ImageButton runat="server" ID="ibRemove" ImageUrl="~/Framework/Images/delete.png"
                                OnClick="ibRemove_OnClick" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
</table>
