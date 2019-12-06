<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditWebsite.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditWebsite.CustomEditWebsite" %>
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
                <asp:LinkButton ID="btnEditAwards" runat="server" OnClick="btnEditAwards_OnClick">Add websites(s)</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlInsertAward" runat="server" CssClass="EditPanel" Visible="false">
            <div>
                <asp:Literal ID="litMediaText" runat="server">
                                        Add links to news stories, blogs or other media that feature your research. Links can be hosted on any external site that is open to the public. 
                                        Enter the title or headline as you want it to appear on your Harvard Catalyst Profiles page, and the related URL. Add a date of publication if applicable. 
                                        Once you've added a story, remember to click "Save" below. 
                </asp:Literal>
                <asp:Literal ID="litWebsiteText" runat="server">
                                        Add websites to your profile. Enter the website name, as you want it to appear on your profile, and its URL. Some samples include a link to your lab web site, your research program or your research blog. 
                </asp:Literal>
            </div>
            <div style="display: inline-flex;">
                <div>
                    <div style="font-weight: bold;">Title</div>
                    <asp:TextBox ID="txtTitle" runat="server" MaxLength="100" Width="220px" title="Title"></asp:TextBox>
                </div>
                <div style="padding-left: 10px">
                    <div style="font-weight: bold;">URL</div>
                    <asp:TextBox ID="txtURL" runat="server" MaxLength="100" Width="220px" title="URL"></asp:TextBox>
                </div>
                <div style="padding-left: 10px">
                    <asp:Literal ID="litPubDateLabel" runat="server"><div style="font-weight: bold;">Publication Date</div></asp:Literal>
                    <asp:TextBox ID="txtPubDate" runat="server" MaxLength="10" Width="75px" title="Publication Date"></asp:TextBox>
                </div>
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnInsertAward" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick" Text="Save and add another"></asp:LinkButton>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnInsertAward2" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick" Text="Save and Close"></asp:LinkButton>
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnEditAwards_OnClick" Text="Close"></asp:LinkButton>
            </div>
        </asp:Panel>
        <div class="editPage">
            <asp:GridView ID="GridViewWebsites" runat="server" AutoGenerateColumns="False" CssClass="editBody"
                DataKeyNames="URLID"
                OnRowCancelingEdit="GridViewAwards_RowCancelingEdit" OnRowDataBound="GridViewAwards_RowDataBound"
                OnRowDeleting="GridViewAwards_RowDeleting" OnRowEditing="GridViewAwards_RowEditing"
                OnRowUpdated="GridViewAwards_RowUpdated" OnRowUpdating="GridViewAwards_RowUpdating">
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:TemplateField HeaderText="Title" HeaderStyle-CssClass="AwardName" ItemStyle-CssClass="AwardName">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtTitleEdit" runat="server" MaxLength="500" Text='<%# Bind("WebPageTitle") %>' title="Title"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Bind("WebPageTitle") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="URL" HeaderStyle-CssClass="AwardInstitution" ItemStyle-CssClass="AwardInstitution">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtURL" runat="server" MaxLength="500" Text='<%# Bind("URL") %>' title="URL"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label3" runat="server" Text='<%# Bind("URL") %>'></asp:Label>
                        </ItemTemplate>                        
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Publication Date" HeaderStyle-CssClass="alignAwardsDates" ItemStyle-CssClass="alignAwardsDates">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtDate" runat="server" MaxLength="100"  Text='<%# Bind("PublicationDate") %>' title="Institution"></asp:TextBox>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label4" runat="server" Text='<%# Bind("PublicationDate") %>'></asp:Label>
                        </ItemTemplate>                        
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" HeaderText="Action" ItemStyle-CssClass="alignCenterAction">
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="True" CommandName="Update" Text="Save" />
                            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
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
            <asp:Label runat="server" ID="lblNoAwards" Text="No websites have been added." Visible="false"></asp:Label></i>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
