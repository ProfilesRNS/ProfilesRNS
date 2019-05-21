<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditAwardOrHonor.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditAwardOrHonor.CustomEditAwardOrHonor" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>    
          <asp:UpdateProgress ID="updateProgress" runat="server" DynamicLayout="true" DisplayAfter="1000">
            <ProgressTemplate>
                <div class="modalupdate">
                    <div class="modalcenter">
                        <img alt="Updating..." src="<%=Profiles.Framework.Utilities.Root.Domain%>/edit/images/loader.gif" /><br />
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
        <asp:Panel runat="server" ID="pnlEditAwards">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnEditAwards_OnClick" runat="server" ID="imbAddArrow" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnEditAwards" runat="server" OnClick="btnEditAwards_OnClick">Add Award(s)</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlInsertAward" runat="server" CssClass="EditPanel" Visible="false">
            <div>Enter the year(s), name and institution.</div>
            <div style="padding-top: 3px; margin-bottom: 10px;">For Award Year(s), enter both fields only if awarded for consecutive years.</div>
            <div style="display: inline-flex;">
                <div>
                    <div style="font-weight: bold;">Award Year(s)</div>
                    <asp:TextBox ID="txtStartYear" runat="server" MaxLength="4" Width="60px" title="start year" CssClass="editFieldTopMargin"/>
                    &nbsp;<b>-</b>&nbsp;<asp:TextBox ID="txtEndYear" runat="server" MaxLength="4" Width="60px" title="end year" CssClass="editFieldTopMargin"/>
                </div>
                <div style="padding-left: 10px">
                    <div style="font-weight: bold;">Name <span style="font-weight: normal;">(required)</span></div>
                    <asp:TextBox ID="txtAwardName" runat="server" MaxLength="100" Width="220px" title="award name" CssClass="editFieldTopMargin"/>
                </div>
                <div style="margin-left: 20px;">
                    <div style="font-weight: bold;">Institution</div>
                    <asp:TextBox ID="txtInstitution" runat="server" MaxLength="100" Width="220px" title="institution" CssClass="editFieldTopMargin"/>
                </div>
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnInsertAwardClose" runat="server" CausesValidation="False" Text="Save" OnClick="btnInsertClose_OnClick"/>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnInsertAward" runat="server" CausesValidation="False" Text="Save and add another" OnClick="btnInsert_OnClick"/>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick" Text="Cancel" OnClientClick="btnInsertCancel_OnClick"/>
            </div>
        </asp:Panel>
        <div class="editPage">
            <asp:GridView ID="GridViewAwards" runat="server" AutoGenerateColumns="False"
                DataKeyNames="SubjectURI,Predicate, Object"
                OnRowCancelingEdit="GridViewAwards_RowCancelingEdit" OnRowDataBound="GridViewAwards_RowDataBound"
                OnRowDeleting="GridViewAwards_RowDeleting" OnRowEditing="GridViewAwards_RowEditing"
                OnRowUpdated="GridViewAwards_RowUpdated" OnRowUpdating="GridViewAwards_RowUpdating" CssClass="editBody">
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:TemplateField HeaderText="Year of Award" HeaderStyle-CssClass="alignAwardsDates" ItemStyle-CssClass="alignAwardsDates">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtYr1" runat="server" MaxLength="4" Text='<%# Bind("StartDate") %>' title="Year of award"/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("StartDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Thru Year" HeaderStyle-CssClass="alignAwardsDates" ItemStyle-CssClass="alignAwardsDates">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEndDate" runat="server" MaxLength="4" Text='<%# Bind("EndDate") %>'/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Name" HeaderStyle-CssClass="AwardName" ItemStyle-CssClass="AwardName">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtAwardName" runat="server" MaxLength="100" Text='<%# Bind("Name") %>' title="Name"/>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("Name") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Institution" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtAwardInst" runat="server" MaxLength="100" Text='<%# Bind("Institution") %>'/>
                            <asp:HiddenField runat="server" ID="hdURI" />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("Institution") %>'></asp:Label>
                            <asp:HiddenField runat="server" ID="hdURI" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Save"/>
                            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel"/>
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
                                    AlternateText="Delete"></asp:ImageButton>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div class="editBody">
            <asp:Label runat="server" ID="lblNoAwards" Text="No awards have been added." Visible="false"></asp:Label>
        </div>


    </ContentTemplate>
</asp:UpdatePanel>

