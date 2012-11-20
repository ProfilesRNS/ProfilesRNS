<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchConnection.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchConnection" %>
<div>
    <div class="connectionContainer">
        <table class="connectionContainerTable">
            <tbody>
                <tr>
                    <td class="connectionContainerItem">
                        <div>
                            <asp:Literal runat="server" ID="litSearchURL"></asp:Literal>
                        </div>
                    </td>
                    <td class="connectionContainerArrow">
                        <table class="connectionArrowTable">
                            <tbody>
                                <tr>
                                    <td />
                                    <td>
                                        <div class="connectionDescription">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
                                    </td>
                                    <td />
                                </tr>
                                <tr>
                                    <td class="connectionLine">
                                        <img src="<%=GetURLDomain()%>/Framework/Images/connection_left.gif" />
                                    </td>
                                    <td class="connectionLine">
                                        <div>
                                        </div>
                                    </td>
                                    <td class="connectionLine">
                                        <img src="<%=GetURLDomain()%>/Framework/Images/connection_right.gif" />
                                    </td>
                                </tr>
                                <tr>
                                    <td />
                                    <td>
                                        <div class="connectionSubDescription">
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        </div>
                                    </td>
                                    <td />
                                </tr>
                            </tbody>
                        </table>
                    </td>
                    <td class="connectionContainerItem">
                        <div>
                            <asp:Literal runat="server" ID="litNodeURI"></asp:Literal>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <br />
    One or more keywords matched the following properties of
    <asp:Literal runat="server" ID="litPersonURI"></asp:Literal>
    <br />
    <br />
    <div>
        <asp:GridView Width="100%" ID="gvConnectionDetails" AutoGenerateColumns="false" GridLines="Both"
            CellSpacing="-1" runat="server" OnRowDataBound="gvConnectionDetails_OnRowDataBound">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle CssClass="edittable" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:TemplateField ItemStyle-CssClass="connectionTableRow" HeaderText = "Property"
                 HeaderStyle-Width="200px">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litProperty"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-CssClass="connectionTableRow" HeaderText="Value">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litValue"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
    <br />
    <asp:Panel runat="server" ID="pnlIndirectConnection" Visible="false">
        One or more keywords matched the following items that are connected to
        <asp:Literal runat="server" ID="litSubjectName"></asp:Literal>
        <br />
        <br />
        <div>
            <asp:GridView Width="100%" ID="gvIndirectConnectionDetails" AutoGenerateColumns="false"
                GridLines="Both" CellSpacing="-1" runat="server" OnRowDataBound="gvIndirectConnectionDetails_OnRowDataBound">
                <HeaderStyle CssClass="topRow" BorderStyle="None" />
                <RowStyle CssClass="edittable" />
                <AlternatingRowStyle CssClass="evenRow" />
                <Columns>
                    <asp:TemplateField ItemStyle-CssClass="connectionTableRow" HeaderText="Item Type" HeaderStyle-Width="200px">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litProperty"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-CssClass="connectionTableRow" HeaderText="Name">
                    <ItemTemplate>
                        <asp:Literal runat="server" ID="litValue"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>
</div>
<br />
