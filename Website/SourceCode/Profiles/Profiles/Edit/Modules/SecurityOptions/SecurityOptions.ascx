<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="SecurityOptions.ascx.cs"
    Inherits="Profiles.Edit.Modules.SecurityOptions.SecurityOptions" %>
<script type="text/javascript">           
    $("[id*=pnlSecurityOptions]").keypress(function (e) {
        if (e.which == 13) {
                $("[id*=rdoSecurityOption]").click(function () {
                    $("[id*=rdoSecurityOption]").removeAttr('checked');
                    $(this).attr('checked');
                });
            }
        });    
</script>
<div class="EditMenuItem">
    <asp:ImageButton ID="imbAddArrow" CssClass="EditMenuLinkImg" runat="server" ImageUrl="~/Edit/Images/icon_squareArrow.gif" OnClick="imbSecurityOptions_OnClick" AlternateText=" " />
    <asp:LinkButton ID="imbSecurityOptions" runat="server" OnClick="imbSecurityOptions_OnClick"/>                    
</div>
<asp:Panel runat="server" ID="pnlSecurityOptions" ClientIDMode="static" CssClass="editPage EditMenuItem" Visible="false">
    <asp:GridView runat="server" ID="grdSecurityGroups" AutoGenerateColumns="false"
        OnRowDataBound="grdSecurityGroups_OnDataBound">
        <AlternatingRowStyle CssClass="evenRow" />
        <HeaderStyle CssClass="topRow" />
        <Columns>
            <asp:TemplateField HeaderText="Select" ItemStyle-Width="50px" HeaderStyle-CssClass="CenterSelect" ItemStyle-CssClass="CenterSelect">
                <ItemTemplate>
                    <asp:RadioButton runat="server" ID="rdoSecurityOption" GroupName="SecurityOption"
                        AutoPostBack="true" OnCheckedChanged="rdoSecurityOption_OnCheckedChanged" />
                    <asp:HiddenField runat="server" ID="hdnPrivacyCode" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Privacy" HeaderStyle-CssClass="alignLeft"
                ItemStyle-CssClass="alignLeft" DataField="Label"
                ItemStyle-Width="50px" />
            <asp:BoundField HeaderStyle-CssClass="alignLeft" HeaderText="Description" ItemStyle-CssClass="alignLeft"
                DataField="Description" ItemStyle-Width="500px" ControlStyle-BorderStyle="None" />
        </Columns>
    </asp:GridView>
</asp:Panel>
<div runat="server" id="divHidden" style='border: 1px solid #333; background-color: #FFD; text-align: left; font-weight: bold; padding: 5px; margin-top: 8px;'>
    Note: This feature's visibility is currently set to Hidden and is not visible on your profile.
</div>
