<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPropertyList.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditPropertyList.EditPropertyList" %>
<asp:Literal runat="server" ID="litBackLink"></asp:Literal>

Below are the types of content that can be included on this profile. Locked items
<asp:Image runat="server" ID="imgLock" alt=""/>
can be viewed but not edited. Information in the Address section of your profile,
including your titles, affiliations, telephone, fax, and email, 
as well as education and training in the Biography section, are managed by your
Human Resources office; however, you may upload a custom photo to your profile using
this website.
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
                    ItemStyle-HorizontalAlign="Left" DataField="EditLink" HeaderText="Item" HtmlEncode="false" />
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center"
                    HeaderText="Items" >
                    <ItemTemplate>
                        <asp:Image runat="server" ID="imgBlank" Visible="false" ImageUrl="~/Edit/Images/icons_blank.gif" AlternateText=" " />
                        <asp:Label runat="server" ID="lblItems"></asp:Label>
                        <asp:Image runat="server" ID="imgLock" Visible="false" ImageUrl="~/Edit/Images/icons_lock.gif" AlternateText="locked" />
                        <asp:Image runat="server" ID="imgOrng" Visible="false" ImageUrl="~/ORNG/Images/orng-asterisk.png" AlternateText="ORNG Gadget"/>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" 
                    HeaderText="Privacy" >
                    <ItemTemplate>
                        <asp:HiddenField ID="hfPropertyURI" runat="server" />
                        <asp:DropDownList AutoPostBack="true" Visible="false" OnSelectedIndexChanged="updateSecurity" runat="server"
                            ID="ddlPrivacySettings">
                        </asp:DropDownList>
                        <asp:Literal runat="server" ID="litSetting"></asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <br />
    </ItemTemplate>
</asp:Repeater>
<div style="display:block">
    <h2>Privacy Levels</h2>
    <div style='border: solid 1px #ccc; margin-bottom: 2px; width: 100%'>
        <asp:Literal runat="server" ID="litSecurityKey"></asp:Literal>
    </div>
</div>
