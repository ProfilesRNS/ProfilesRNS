<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SecurityOptions.ascx.cs"
    Inherits="Profiles.Edit.Modules.SecurityOptions.SecurityOptions" %>

<script type="text/javascript">
    $(document).ready(function() {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

        $(document).keypress(function(e) {
            if (e.which != 13) {

                function EndRequestHandler(sender, args) {

                    $("[id*=rdoSecurityOption]").click(function() {
                        $("[id*=rdoSecurityOption]").removeAttr('checked');
                        $(this).attr('checked', 'checked');
                    });

                }
                $("[id*=rdoSecurityOption]").click(function() {
                    $("[id*=rdoSecurityOption]").removeAttr('checked');
                    $(this).attr(':checked');
                });
            }
        });

    });
</script>

<asp:ImageButton runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
    ID="imbSecurityOptions" OnClick="imbSecurityOptions_OnClick" />&nbsp;
<asp:LinkButton runat="server" ID="lbSecurityOptions" OnClick="imbSecurityOptions_OnClick"
    Text="Edit Visibility"></asp:LinkButton>    
    <br />
<asp:Panel runat="server" ID="pnlSecurityOptions" CssClass="editPage" Visible="false">
<br />
    <asp:GridView  CellSpacing="-1" runat="server" ID="grdSecurityGroups" AutoGenerateColumns="false"
        OnRowDataBound="grdSecurityGroups_OnDataBound" Width="100%">
        <HeaderStyle BorderStyle="None" CssClass="EditMenuTopRow" />
        <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
        <AlternatingRowStyle CssClass="evenRow" />
        <Columns>
            <asp:TemplateField HeaderStyle-HorizontalAlign="Center"  ItemStyle-HorizontalAlign="Center" HeaderText="Select" ItemStyle-Width="50px">
                <ItemTemplate>
                    <asp:RadioButton runat="server" ID="rdoSecurityOption" GroupName="SecurityOption" AutoPostBack="true" OnCheckedChanged="rdoSecurityOption_OnCheckedChanged" />
                    <asp:HiddenField runat="server" ID="hdnPrivacyCode" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField  HeaderStyle-HorizontalAlign="Center" HeaderText="Privacy" HeaderStyle-CssClass="padding" ItemStyle-CssClass="padding" 
                ItemStyle-HorizontalAlign="Left" DataField="Label" ItemStyle-Width="100px" />
            <asp:BoundField HeaderStyle-HorizontalAlign="Center" HeaderText="Description" ItemStyle-HorizontalAlign="left" DataField="Description" ItemStyle-Width="500px" />
        </Columns>
    </asp:GridView>
</asp:Panel>
