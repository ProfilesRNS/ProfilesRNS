<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditSingleDataTypeProperty.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditSingleDataTypeProperty.EditSingleDataTypeProperty" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<table width="100%">
    <tr>
        <td align="left" style="padding-right: 12px">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </td>
    </tr>
</table>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span><img alt="Loading..." src="../edit/Images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table id="tblEditProperty" width="100%">
            <tr>
                <td colspan='3'>
                    <asp:Literal runat="server" ID="Literal1"></asp:Literal>                    
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding: 10px 0px;">
                        <security:Options runat="server" ID="securityOptions"></security:Options>
                        <br />
                        <asp:ImageButton runat="server" ID="imbAddArror" ImageUrl="../../../Framework/Images/icon_squareArrow.gif"
                            OnClick="btnEditProperty_OnClick" />&nbsp;
                        <asp:LinkButton ID="btnEditProperty" runat="server" CommandArgument="Show" OnClick="btnEditProperty_OnClick"
                            CssClass="profileHypLinks">Add Property</asp:LinkButton>
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
                    <asp:Panel ID="pnlInsertProperty" runat="server" Style="background-color: #EEE;
                        margin-bottom: 5px; border: solid 1px #ccc;" 
                        Visible="false">
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtLabel" runat="server" Rows="5" Width="500px" TextMode="MultiLine"
                                        TabIndex="1"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div style="padding-bottom: 5px; text-align: left;">
                                        <asp:LinkButton ID="btnInsertProperty2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close" TabIndex="6"></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Close" TabIndex="7"></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div style="border-left: solid 1px #ccc;">
                        <asp:HiddenField ID="hdLabel" runat="server" Value='<%# Bind("Literal") %>'></asp:HiddenField>
                        <asp:Label ID="lblLabel" runat="server"></asp:Label>
                        <table class="actionbuttons">
                            <tr>
                                <td>
                                    <asp:ImageButton ID="lnkUpdate" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                        CausesValidation="True" CommandName="Update" Text="Update"></asp:ImageButton>
                                </td>
                                <td>
                                    <asp:ImageButton ID="lnkCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                        CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:ImageButton>
                                </td>
                            </tr>
                        </table>
                        <div class="actionbuttons">
                            <table>
                                <tr>
                                    <td>
                                        <asp:ImageButton OnClick="ibUp_Click" runat="server" CommandArgument="up" CommandName="action"
                                            ID="ibUp" ImageUrl="~/Edit/Images/icon_up.gif" />
                                    </td>
                                    <td>
                                        <asp:ImageButton runat="server" OnClick="ibDown_Click" ID="ibDown" CommandArgument="down"
                                            CommandName="action" ImageUrl="~/Edit/Images/icon_down.gif" />
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                            CausesValidation="False" CommandName="Edit" Text="Edit"></asp:ImageButton>
                                    </td>
                                    <td>
                                        <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                            CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                                            Text="X"></asp:ImageButton>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <asp:Label runat="server" ID="lblNoItems" Text="<i>No item has been added.</i>" Visible = "false"></asp:Label>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
