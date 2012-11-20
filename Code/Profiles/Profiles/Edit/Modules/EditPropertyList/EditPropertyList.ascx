<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPropertyList.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditPropertyList.EditPropertyList" %>


<asp:Literal runat="server" ID="litBackLink"></asp:Literal>
<br />
<div class='editPage'>
    <h2>
        Content Type</h2>
</div>
Below are the types of content that can be included on this profile.
<br />
<br />
<asp:Repeater runat="server" ID="repPropertyGroups" OnItemDataBound="repPropertyGroups_OnItemDataBound">
    <ItemTemplate>
        <asp:GridView runat="server" ID="grdSecurityGroups" AutoGenerateColumns="false" OnRowDataBound="grdSecurityGroups_OnDataBound"
            Width="100%">
            <HeaderStyle BorderStyle="None" CssClass="EditMenuTopRow" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:BoundField HeaderStyle-CssClass="padding" ItemStyle-CssClass="padding" HeaderStyle-HorizontalAlign="Left"
                    ItemStyle-HorizontalAlign="Left" DataField="item" HeaderText="Item" ItemStyle-Width="400px" />
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Items" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="imgBlank" Visible="false" ImageUrl="~/Edit/Images/icons_blank.gif" />
                        <asp:Label runat="server" ID="lblItems"></asp:Label>
                        <asp:Image runat="server" ID="imgLock" Visible="false" ImageUrl="~/Edit/Images/icons_lock.gif" />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Privacy" ItemStyle-Width="100px">
                    <ItemTemplate>
                    
                        <asp:DropDownList AutoPostBack="true" OnSelectedIndexChanged="updateSecurity" runat="server"
                            ID="ddlPrivacySettings">
                        </asp:DropDownList>
                        <asp:Literal runat="server" ID="litSetting"></asp:Literal>
                        
                        <asp:HiddenField ID="hfPropertyURI" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
    </ItemTemplate>
</asp:Repeater>
<table width='100%'>
    <tr>
        <td colspan='3'>
            <div class='editPage'>
                <table width="100%">
                    <tr>
                        <td>
                            <h2>
                                *Privacy Levels</h2>
                        </td>
                        <td align="right">
                           <%-- <b>Set All</b>&nbsp;
                            <asp:DropDownList runat="server" ID="ddlSetAll" AutoPostBack="true" OnSelectedIndexChanged="ddlSetAll_IndexChanged">
                            </asp:DropDownList>--%>
                        </td>
                    </tr>
                </table>
            </div>
            <div style='border: solid 1px #ccc; margin-bottom: 2px; width:100%'>
                <asp:Literal runat="server" ID="litSecurityKey"></asp:Literal>
            </div>
        </td>
    </tr>
</table>
