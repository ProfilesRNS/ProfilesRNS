<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditDataTypeProperty.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditDataTypeProperty.EditDataTypeProperty" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<script type="text/javascript">
    var verifyChars = (function () {
        var re = /[^\x00-\x7F]/;
        return function () {
            var str = $(".text-entry-value").val();
            var val = re.test(str);
            if (val) { alert("Extended ASCII characters are not permitted. \n\nPlease edit your entry to remove these characters."); return false; }
            return true;
        }
    })();
</script>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <div class="editBackLink">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </div>
        <table id="tblEditProperty" width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="Literal1"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:Panel ID="phSecuritySettings" runat="server">
                        <security:Options runat="server" ID="securityOptions"></security:Options>
                    </asp:Panel>
                    <div class="EditMenuItem">
                        <asp:ImageButton runat="server" OnClick="btnEditProperty_OnClick" ID="imbAddArrow" AlternateText=" " CssClass="EditMenuLinkImg" ImageUrl="~/edit/Images/icon_squareArrow.gif" />
                        <asp:LinkButton ID="btnEditProperty" runat="server" CommandArgument="Show" OnClick="btnEditProperty_OnClick">Add Property</asp:LinkButton>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <asp:Repeater ID="RptrEditProperty" runat="server" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblEditProperty" runat="server" Text='<%#Eval("Label").ToString() %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlInsertProperty" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px; border: solid 1px #ccc;"
                        Visible="false">
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtInsertLabel" runat="server" Rows="5" Width="500px" TextMode="MultiLine" title="Enter Text"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div style="padding-bottom: 5px; text-align: left;">
                                        <asp:LinkButton ID="btnInsertProperty" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                            Text="Save and add another&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;"></asp:LinkButton>
                                        <asp:LinkButton ID="btnInsertProperty2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close"></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Close"></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div style="border-left: solid 1px #ccc;">
                        <asp:GridView ID="GridViewProperty" runat="server" AutoGenerateColumns="False"
                            DataKeyNames="Subject,Predicate, Object" OnRowCancelingEdit="GridViewProperty_RowCancelingEdit"
                            OnRowDataBound="GridViewProperty_RowDataBound" OnRowDeleting="GridViewProperty_RowDeleting"
                            OnRowEditing="GridViewProperty_RowEditing" OnRowUpdated="GridViewProperty_RowUpdated"
                            OnRowUpdating="GridViewProperty_RowUpdating">
                            <HeaderStyle CssClass="topRow" />
                            <Columns>
                                <asp:TemplateField HeaderText="" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtLabel" Rows="5" runat="server" TextMode="MultiLine" Width="100%" Height="400px" Text='<%# Bind("Literal") %>' />
                                        <asp:HiddenField ID="hdLabel" runat="server" Value='<%# Bind("Literal") %>'></asp:HiddenField>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblLabel" runat="server"></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="lnkUpdate" runat="server" OnClientClick="Javascript:return verifyChars();" CausesValidation="True" CommandName="Update" Text="Save" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <span>
                                            <asp:ImageButton OnClick="ibUp_Click" runat="server" CommandArgument="up" CommandName="action"
                                                ID="ibUp" ImageUrl="~/Edit/Images/icon_up.gif" AlternateText="Move Up" />
                                            <asp:ImageButton runat="server" ID="ibUpGray" Enabled="false" Visible="false" ImageUrl="~/Edit/Images/Icon_rounded_ArrowGrayUp.png" AlternateText="Move Up" />
                                        </span>
                                        <span>
                                            <asp:ImageButton runat="server" OnClick="ibDown_Click" ID="ibDown" CommandArgument="down"
                                                CommandName="action" ImageUrl="~/Edit/Images/icon_down.gif" AlternateText="Move Down" />
                                            <asp:ImageButton runat="server" ID="ibDownGray" Enabled="false" Visible="false" ImageUrl="~/Edit/Images/Icon_rounded_ArrowGrayDown.png" AlternateText="Move Down" />
                                        </span>
                                        <span>
                                            <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                                CausesValidation="False" CommandName="Edit" AlternateText="Edit"></asp:ImageButton>
                                        </span>
                                        <span>
                                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                                CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                                                AlternateText="delete"></asp:ImageButton>
                                        </span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <asp:Label runat="server" ID="lblNoItems" Text="<i>No items have been added.</i>" Visible="false"></asp:Label>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
