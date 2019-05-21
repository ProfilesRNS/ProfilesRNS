<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditEducationalTraining.ascx.cs" Inherits="Profiles.Edit.Modules.CustomEditEducationalTraining.CustomEditEducationalTraining" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
          <asp:UpdateProgress ID="updateProgress" runat="server" DynamicLayout="true" DisplayAfter="1000">
            <ProgressTemplate>
                <div class="modalupdate">
                    <div class="modalcenter">
                        <img alt="Updating..." src="<%=Profiles.Framework.Utilities.Root.Domain%>/edit/images/loader.gif" />
                        <br />
                        <i>Updating...</i>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <div class="editBackLink">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </div>
        <asp:Panel runat="server" ID="pnlSecurityOptions">
            <security:Options runat="server" ID="securityOptions"></security:Options>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlEditEducation">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" runat="server" OnClick="btnEditEducation_OnClick" ID="imbAddArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnEditEducation" runat="server" OnClick="btnEditEducation_OnClick">Add Education and Training</asp:LinkButton>
            </div>
        </asp:Panel>      
        <asp:Panel ID="pnlInsertEducationalTraining" runat="server" CssClass="EditPanel" Visible="false">
            <div style="display: inline-flex;">
                <div>
                    <div style="font-weight: bold;">Institution</div>
                    <asp:TextBox ID="txtInstitution" runat="server" MaxLength="100" Width="190px" />
                </div>
                <div style="margin-left: 10px;">
                    <div style="font-weight: bold;">Location</div>
                    <asp:TextBox ID="txtLocation" runat="server" MaxLength="100" Width="130px" />
                </div>
                <div style="margin-left: 10px;">
                    <div style="font-weight: bold;">Degree (if applicable)</div>
                    <asp:TextBox ID="txtEducationalTrainingDegree" runat="server" MaxLength="100" Width="55px" />
                </div>
                <div style="margin-left: 10px;">
                    <div style="font-weight: bold;">Completion Date (MM/YYYY)</div>
                    <asp:TextBox ID="txtEndYear" runat="server" MaxLength="7" Width="80px" />
                </div>
                <div style="margin-left: 20px;">
                    <div style="font-weight: bold;">Field Of Study</div>
                    <asp:TextBox ID="txtFieldOfStudy" runat="server" MaxLength="100" Width="175px" />
                </div>
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnInsertEducationalTraining2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                    Text="Save"/>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                         <asp:LinkButton ID="btnInsertEducationalTraining" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                             Text="Save and add another"/>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                            Text="Cancel"/>
            </div>

        </asp:Panel>
        <div class="editPage">
            <asp:GridView ID="GridViewEducation" runat="server" AutoGenerateColumns="False" DataKeyNames="SubjectURI,Predicate, Object" GridLines="Both"
                OnRowCancelingEdit="GridViewEducation_RowCancelingEdit" OnRowDataBound="GridViewEducation_RowDataBound"
                OnRowDeleting="GridViewEducation_RowDeleting" OnRowEditing="GridViewEducation_RowEditing"
                OnRowUpdated="GridViewEducation_RowUpdated" OnRowUpdating="GridViewEducation_RowUpdating"
                CssClass="editBody">
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:TemplateField HeaderText="Institution" ItemStyle-CssClass="alignLeft" HeaderStyle-CssClass="alignLeft">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEducationalTrainingInst" runat="server" MaxLength="100" Width="250px" Text='<%# Bind("Institution") %>'/>
                            <asp:HiddenField runat="server" ID="hdURI" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label5" runat="server" Text='<%# Bind("Institution") %>'></asp:Label>
                            <asp:HiddenField runat="server" ID="hdURI" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Location" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEducationalTrainingLocation" runat="server" MaxLength="100" Text='<%# Bind("Location") %>'/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label6" runat="server" Text='<%# Bind("Location") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Degree" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEducationalTrainingDegree" runat="server" Width="55px" MaxLength="100" Text='<%# Bind("Degree") %>'/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("Degree") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Completion Date" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEndDate" runat="server" MaxLength="7" Width="70px" Text='<%# Bind("EndDate") %>'/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Field of Study" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEducationalTrainingFieldOfStudy" runat="server" MaxLength="100" Text='<%# Bind("FieldOfStudy") %>'/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("FieldOfStudy") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                        <EditItemTemplate>                            
                                <asp:LinkButton ID="lnkUpdate" runat="server"
                                    CausesValidation="True" CommandName="Update" Text="Save"/>
                                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp
                                <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"/>                            
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
                                        CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entry?');"
                                        AlternateText="Delete"></asp:ImageButton>
                                </span>                            
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <div class="editBody">
                <asp:Label runat="server" ID="lblNoEducation" Text="No education or training has been added." Visible="false"></asp:Label>
            </div>
    </ContentTemplate>
</asp:UpdatePanel>
