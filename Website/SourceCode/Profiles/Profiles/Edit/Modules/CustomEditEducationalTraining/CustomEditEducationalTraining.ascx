<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditEducationalTraining.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditEducationalTraining.CustomEditEducationalTraining" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>   
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div class="progress">
                    <span><img alt="Loading..." src="../edit/images/loader.gif" width="400" height="213"/></span>
                </div>
            </ProgressTemplate>                        
        </asp:UpdateProgress>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        
        <table id="tblEditEducationalTraining" width="100%">
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
                        <asp:Panel runat="server" ID="pnlEditEducation">
                            <asp:ImageButton runat="server" ID="imbAddArror" ImageUrl="../../../Framework/Images/icon_squareArrow.gif"
                                OnClick="btnEditEducation_OnClick" />&nbsp;
                            <asp:LinkButton ID="btnEditEducation" runat="server" OnClick="btnEditEducation_OnClick"
                                CssClass="profileHypLinks">Add Education and Training</asp:LinkButton>
                        </asp:Panel>
                    </div>
                </td>
            </tr>
            <tr>
                <td>                   
                    <asp:Repeater ID="RptrEditEducation" runat="server" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblEditEducation" runat="server" Text='<%#Eval("EducationalTraining").ToString() %>' />
                            <br />
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:Panel ID="pnlInsertEducationalTraining" runat="server" Style="background-color: #EEE; margin-bottom: 5px;
                        border: solid 1px #ccc;" Visible="false" >
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td colspan="3">
                                    <div style="padding-top: 5px;">
                                        Enter the institution, the name of the degree or training credential earned, the school or department and year completed, <br />e.g. Cambridge; MD; School of Medicine; 1992. 
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Institution</b><br />
                                    <asp:TextBox ID="txtInstitution" runat="server" MaxLength="100" TabIndex="4" Width="220px"></asp:TextBox>
                                </td>
                                <td>
                                    <b>Degree/Credential</b><br />
                                    <asp:TextBox ID="txtEducationalTrainingDegree" runat="server" MaxLength="100" TabIndex="3" Width="220px"></asp:TextBox>
                                </td>
                                <td>
                                    <b>School or Department</b><br />
                                    <asp:TextBox ID="txtEducationalTrainingSchool" runat="server" MaxLength="100" TabIndex="3" Width="220px"></asp:TextBox>
                                </td>
                                <td>
                                    <b>Year</b><br />
                                    <asp:TextBox ID="txtEndYear" runat="server" MaxLength="4" Width="60px" TabIndex="2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <div style="padding-bottom: 5px; text-align: left;">
                                        <asp:LinkButton ID="btnInsertEducationalTraining" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                            Text="Save and add another" TabIndex="5"></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertEducationalTraining2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close" TabIndex="6"></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Close" TabIndex="7"></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <div>
                        <asp:GridView ID="GridViewEducation" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            DataKeyNames="SubjectURI,Predicate, Object" GridLines="Both"
                            OnRowCancelingEdit="GridViewEducation_RowCancelingEdit" OnRowDataBound="GridViewEducation_RowDataBound"
                            OnRowDeleting="GridViewEducation_RowDeleting" OnRowEditing="GridViewEducation_RowEditing"
                            OnRowUpdated="GridViewEducation_RowUpdated" OnRowUpdating="GridViewEducation_RowUpdating"
                            Width="100%">
                            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                            <RowStyle BorderStyle="Solid" BorderWidth="1px" />
                            <Columns>
                                <asp:TemplateField HeaderText="Institution">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEducationalTrainingInst" runat="server" MaxLength="100" Text='<%# Bind("Institution") %>'></asp:TextBox>
                                        <asp:HiddenField runat="server" ID="hdURI" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text='<%# Bind("Institution") %>'></asp:Label>
                                        <asp:HiddenField runat="server" ID="hdURI" />
                                    </ItemTemplate>
                                    <ItemStyle Wrap="true" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Degree/Credential">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEducationalTrainingDegree" runat="server" MaxLength="100" Text='<%# Bind("Degree") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Degree") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="true" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="School or Department">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtEducationalTrainingSchool" runat="server" MaxLength="100" Text='<%# Bind("School") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("School") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle Wrap="true" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Year">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtYr2" runat="server" MaxLength="4" Text='<%# Bind("EndDate") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                                    </ItemTemplate>
                                    <ControlStyle Width="35px" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" />
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
                    <i><asp:Label runat="server" ID="lblNoEducation" Text="No education or training has been added." Visible ="false"></asp:Label></i>
                </td>
            </tr>
        </table>
    </ContentTemplate>
</asp:UpdatePanel>
