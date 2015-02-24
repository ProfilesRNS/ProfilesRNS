<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditBasicORCID.ascx.cs"
    Inherits="Profiles.ORCID.Modules.CustomEditBasicORCID.CustomEditBasicORCID" %>
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
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                       font-size: 25px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/Images/loader.gif" /></span>
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
                        <asp:LinkButton ID="btnEditProperty" runat="server" CommandArgument="Show" OnClick="btnEditProperty_OnClick"
                            CssClass="profileHypLinks">
                            <asp:Image runat="server" ID="imbAddArror" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;
                            <asp:Literal runat="server" ID="litEditProperty">Add Property</asp:Literal>                           
                        </asp:LinkButton>
                        <br />
                        <asp:Panel runat="server" ID="pnlORCIDText" Visible="true">
                            <p>
                                ORCID provides a registry of unique researcher identifiers and a transparent method
                                of linking research activities and outputs to these identifiers. An ORCID iD is
                                a persistent unique identifier that follows an individual throughout their career,
                                and looks something like “0000-0003-0423-208X.”</p>
                            <p>
                                ORCID records hold non-sensitive information such as name, email, organization,
                                and activities such as publication, grants, patents and other scholarly works. ORCID
                                provides tools for individuals to manage data privacy.</p>
                        </asp:Panel>
                        <br />
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
                    <asp:Panel ID="pnlInsertProperty" runat="server" Style="background-color: #F0F4F6;
                        margin-bottom: 5px; border: solid 1px #ccc;" 
                        Visible="false">
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td>
                                    ORCID id: <asp:TextBox ID="txtLabel" runat="server" Rows="1" Width="150px" TextMode="SingleLine" MaxLength="19"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div style="padding-bottom: 5px; text-align: left;">
                                        <asp:LinkButton ID="btnInsertProperty" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                            Text="Save and add another&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;" ></asp:LinkButton>                                        
                                        <asp:LinkButton ID="btnInsertProperty2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Close" ></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div style="border-left: solid 1px #ccc;">
                        <asp:GridView ID="GridViewProperty" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            DataKeyNames="Subject,Predicate, Object" OnRowCancelingEdit="GridViewProperty_RowCancelingEdit"
                            OnRowDataBound="GridViewProperty_RowDataBound" OnRowDeleting="GridViewProperty_RowDeleting"
                            OnRowEditing="GridViewProperty_RowEditing" OnRowUpdated="GridViewProperty_RowUpdated"
                            OnRowUpdating="GridViewProperty_RowUpdating" Width="100%">
                            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                            <RowStyle CssClass="edittable" />
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtLabel" runat="server" Rows="1" Width="150px" TextMode="SingleLine" MaxLength="19"
                                            Text='<%# Bind("Literal") %>'></asp:TextBox>
                                        <asp:HiddenField ID="hdLabel" runat="server" Value='<%# Bind("Literal") %>'></asp:HiddenField>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblLabel" runat="server"></asp:Label>
                                    </ItemTemplate>
                                    <ControlStyle Width="600px" />
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>
                                  <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" HeaderText="Action"
                                    ShowHeader="False">
                                    <EditItemTemplate>
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
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                    </ItemTemplate>
                                    <ItemTemplate>
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
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <asp:Label runat="server" ID="lblNoItems" Text="<i>No items have been added.</i>" Visible = "false"></asp:Label>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
