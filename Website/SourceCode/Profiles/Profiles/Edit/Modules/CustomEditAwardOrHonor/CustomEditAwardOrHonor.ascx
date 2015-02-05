<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditAwardOrHonor.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditAwardOrHonor.CustomEditAwardOrHonor" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>   
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" /></span>
                </div>
            </ProgressTemplate>                        
        </asp:UpdateProgress>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        
        <table id="tblEditAwardsHonors" width="100%">
            <tr>
                <td>
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td>
                    <div style="padding: 10px 0px;">
                        <asp:Panel runat="server" ID="pnlSecurityOptions">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                        </asp:Panel>
                        <br />
                        <asp:Panel runat="server" ID="pnlEditAwards">
                            <asp:LinkButton ID="btnEditAwards" runat="server" OnClick="btnEditAwards_OnClick" 
                                CssClass="profileHypLinks"><asp:Image runat="server" ID="imbAddArror" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Add award(s)</asp:LinkButton>
                        </asp:Panel>
                    </div>
                </td>
            </tr>
            <tr>
                <td>                   
                    <asp:Repeater ID="RptrEditAwards" runat="server" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblEditAwards" runat="server" Text='<%#Eval("AwardsHonors").ToString() %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlInsertAward" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                        border: solid 1px #ccc;" Visible="false" >
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td colspan="3">
                                    <div style="padding-top: 5px;">
                                        Enter the year(s), name and institution.
                                    </div>
                                    <div style="padding-top: 3px;">
                                        For Award Year(s), enter both fields only if awarded for consecutive years.
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Award Year(s)</b><br />
                                    <asp:TextBox ID="txtStartYear" runat="server" MaxLength="4" Width="60px" title="start year"></asp:TextBox>
                                    &nbsp;<b>-</b>&nbsp;
                                    <asp:TextBox ID="txtEndYear" runat="server" MaxLength="4" Width="60px" title="end year"></asp:TextBox>
                                </td>
                                <td>
                                    <b>Name (required)</b><br />
                                    <asp:TextBox ID="txtAwardName" runat="server" MaxLength="100" Width="220px" title="award name"></asp:TextBox>
                                </td>
                                <td>
                                    <b>Institution</b><br />
                                    <asp:TextBox ID="txtInstitution" runat="server" MaxLength="100" Width="220px" title="institution"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div style="padding-bottom: 5px; text-align: left;">
                                        <asp:LinkButton ID="btnInsertAward" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                            Text="Save and add another" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertAward2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Close"></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div>
                        <asp:GridView ID="GridViewAwards" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            DataKeyNames="SubjectURI,Predicate, Object" GridLines="Both"
                            OnRowCancelingEdit="GridViewAwards_RowCancelingEdit" OnRowDataBound="GridViewAwards_RowDataBound"
                            OnRowDeleting="GridViewAwards_RowDeleting" OnRowEditing="GridViewAwards_RowEditing"
                            OnRowUpdated="GridViewAwards_RowUpdated" OnRowUpdating="GridViewAwards_RowUpdating"
                            Width="100%">
                            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                            <RowStyle BorderStyle="Solid" BorderWidth="1px" />
                            <Columns>
                                <asp:TemplateField HeaderText="Year&nbsp;of Award">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtYr1" runat="server" MaxLength="4" Text='<%# Bind("StartDate") %>' title="Year of award"></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("StartDate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ControlStyle Width="35px" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Thru Year">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtYr2" runat="server" MaxLength="4" Text='<%# Bind("EndDate") %>' title="Through year"></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ControlStyle Width="35px" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Name">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtAwardName" runat="server" MaxLength="100" Text='<%# Bind("Name") %>' title="Name"></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="true" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Institution">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtAwardInst" runat="server" MaxLength="100" Text='<%# Bind("Institution") %>' title="Institution"></asp:TextBox>
                                        <asp:HiddenField runat="server" ID="hdURI" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Institution") %>'></asp:Label>
                                        <asp:HiddenField runat="server" ID="hdURI" />
                                    </ItemTemplate>
                                    <ItemStyle Wrap="true" />
                                </asp:TemplateField>
                                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" HeaderText="Action"
                                    ShowHeader="False">
                                    <EditItemTemplate>
                                        <table class="actionbuttons">
                                            <tr>
                                                <td>
                                                    <asp:ImageButton ID="lnkUpdate" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                                        CausesValidation="True" CommandName="Update" Text="Update" AlternateText="Update"></asp:ImageButton>
                                                </td>
                                                <td>
                                                    <asp:ImageButton ID="lnkCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                        CausesValidation="False" CommandName="Cancel" Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
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
                                                            ID="ibUp" ImageUrl="~/Edit/Images/icon_up.gif" AlternateText="Move Up" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton runat="server" OnClick="ibDown_Click" ID="ibDown" CommandArgument="down"
                                                            CommandName="action" ImageUrl="~/Edit/Images/icon_down.gif" AlternateText="Move Down" />
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                                            CausesValidation="False" CommandName="Edit" Text="Edit" AlternateText="Edit"></asp:ImageButton>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                                            CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                                                            Text="X" AlternateText="Delete"></asp:ImageButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>                        
                    </div>
                    <i><asp:Label runat="server" ID="lblNoAwards" Text="No awards have been added." Visible ="false"></asp:Label></i>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
