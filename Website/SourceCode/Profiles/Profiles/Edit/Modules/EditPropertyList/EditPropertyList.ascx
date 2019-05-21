<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditPropertyList.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditPropertyList.EditPropertyList" %>
<div class="editBackLink">
    <b>Edit Menu</b>
</div>
<div style="text-align: left;">
Below are the types of content that can be included on this profile. Locked items
<asp:Image runat="server" ID="imgLock" alt=""/>
can be viewed but not edited. Information in the Address section of your profile,
including your titles, affiliations, telephone, fax, and email are managed by your
Human Resources office; however, you may upload a custom photo to your profile using
this website.
</div>
<div class="editPropertyPage">
<asp:Repeater runat="server" ID="repPropertyGroups" OnItemDataBound="repPropertyGroups_OnItemDataBound">
    <ItemTemplate>
        <asp:GridView runat="server" ID="grdSecurityGroups" AutoGenerateColumns="false" OnRowDataBound="grdSecurityGroups_OnDataBound"
            Width="100%">
          <HeaderStyle CssClass="EditMenuTopRow" />          
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                <asp:BoundField ItemStyle-CssClass="alignLeft" DataField="item" HeaderText="Item" HeaderStyle-CssClass="alignLeft" />
            <asp:TemplateField HeaderStyle-CssClass="alignCenter" ItemStyle-CssClass="alignCenter" HeaderText="Items">
                    <ItemTemplate>
                        <asp:Image runat="server" ID="imgBlank" Visible="false" ImageUrl="~/Edit/Images/icons_blank.gif" AlternateText=" " />
                        <asp:Label runat="server" ID="lblItems"></asp:Label>
                        <asp:Image runat="server" ID="imgLock" Visible="false" ImageUrl="~/Edit/Images/icons_lock.gif" AlternateText="locked" />
                        <asp:Image runat="server" ID="imgOrng" Visible="false" ImageUrl="~/ORNG/Images/orng-asterisk.png" AlternateText="ORNG Gadget"/>
                    </ItemTemplate>
                </asp:TemplateField>
            <asp:TemplateField HeaderStyle-CssClass="alignCenter" ItemStyle-CssClass="alignCenter" HeaderText="Privacy">
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
    </div>
<div style="padding-bottom: 16px; padding-top: 16px;"><b>Privacy Levels</b></div>
<asp:Literal runat="server" ID="litSecurityKey"></asp:Literal>
<script type="text/javascript">
    jQuery(window).load(function () {
        $(".editBackLink").css("margin-top", "0px");        
    });
</script>

