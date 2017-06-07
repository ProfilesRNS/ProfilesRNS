<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GroupAdmin.ascx.cs" Inherits="Profiles.GroupAdmin.Modules.GroupAdmin.GroupAdmin" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Literal ID="litBackLink" runat="server"></asp:Literal>
<br /><br />
<asp:PlaceHolder ID="phAddGroups" runat="server">
    <div style="padding-bottom: 10px;">
        <asp:LinkButton ID="btnAddGroups" runat="server" OnClick="btnAddGroups_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddGroups" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Create a New Group</asp:LinkButton>
    </div>
</asp:PlaceHolder>
    <asp:Panel ID="pnlAddGroup" Style="background-color: #F0F4F6; margin-bottom: 5px;
                        border: solid 1px #ccc;" runat="server" Visible="false" >
        <div class="content_container">
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 36px; left: 40%; top: 40%;"><img alt="Loading.." src="<%=GetURLDomain()%>/Edit/Images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
                <table border="0" cellspacing="2" cellpadding="4">
            <tr>
                <td colspan="3">
                    <div style="padding-top: 5px;">
                        Enter the Name, Visibility and End Date of the group
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <b>Group Name</b><br />
                    <asp:TextBox ID="txtGroupName" runat="server" MaxLength="250" Width="220px" title="Group Name"></asp:TextBox>

                </td>
 <!--               <td>
                    <b>Visibility</b><br />
                    <asp:DropDownList id="ddVisibility" runat="server"
                         AutoPostBack="False">

                       <asp:ListItem value="-1" selected="True">
                          Public
                       </asp:ListItem>
                       <asp:ListItem value="-10" selected="False">
                          No Search
                       </asp:ListItem>
                       <asp:ListItem value="-20" selected="False">
                          Users
                       </asp:ListItem>
                       <asp:ListItem value="-50" selected="False">
                          Private
                       </asp:ListItem>
                     </asp:DropDownList>
                </td>-->
                <td>
                    <asp:Label ID="txtEndDateLabel" runat="server" Text="<b>End Date</b> (MM/DD/YYYY)" AssociatedControlID="txtEndDate"></asp:Label><br />
                        <asp:TextBox ID="txtEndDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
                        <asp:ImageButton ID="btnCalendar" runat="server" ImageUrl="~/Edit/Images/cal.gif" AlternateText="Calendar picker" />
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate"
                            PopupButtonID="btnCalendar">
                        </asp:CalendarExtender>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div style="padding-bottom: 5px; text-align: left;">
                        <asp:LinkButton ID="btnInsertGroupClose" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                            Text="Save" ></asp:LinkButton>
                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnInsertGroup" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                            Text="Save and Add Another" ></asp:LinkButton>
                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnAddGroups_OnClick"
                            Text="Cancel"></asp:LinkButton>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</asp:Panel>
<br />
<asp:PlaceHolder ID="phDeletedGroups" runat="server">
    <div style="padding-bottom: 10px;">
        <asp:LinkButton ID="btnDeletedGroups" runat="server" OnClick="btnDeletedGroups_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgDeletedGroups" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Deleted Groups</asp:LinkButton>
    </div>
</asp:PlaceHolder>
    <asp:Panel ID="pnlDeletedGroups" Style="background-color: #F0F4F6; margin-bottom: 5px;
                        border: solid 1px #ccc;" runat="server" Visible="false" >
        <asp:GridView Width="100%" ID="gvDeletedGroups" EmptyDataText="No Deleted Groups Available" AutoGenerateColumns="false"
            DataKeyNames="GroupID, GroupNodeID"
            CellSpacing="-1" runat="server" OnRowDataBound="gvDeletedGroups_OnRowDataBound" 
			OnRowEditing="gvDeletedGroups_RowEditing"
            GridLines="Both">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                  <asp:TemplateField HeaderText="Group Name">
                    <ItemTemplate>
                        <asp:Label ID="lblGroupName" runat="server" Text='<%# Bind("GroupName") %>'></asp:Label>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Visibility">
                    <ItemTemplate>
                        <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="End Date">
                    <ItemTemplate>
                        <asp:Label ID="lblEndDate" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Action">
                    <ItemTemplate>
                         <div class="actionbuttons">
                            <asp:LinkButton ID="lnkEdit" runat="server" 
                                CausesValidation="False" CommandName="Edit" Text="Restore" AlternateText="Edit"></asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
</asp:Panel>
<br />
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:GridView Width="100%" ID="gvGroups" EmptyDataText="None" AutoGenerateColumns="false"
            DataKeyNames="GroupID, GroupNodeID"
            CellSpacing="-1" runat="server" OnRowDataBound="gvGroups_OnRowDataBound" 
            OnRowCancelingEdit="gvGroups_RowCancelingEdit"
            OnRowDeleting="gvGroups_RowDeleting" OnRowEditing="gvGroups_RowEditing"
            OnRowUpdated="gvGroups_RowUpdated" OnRowUpdating="gvGroups_RowUpdating"
            GridLines="Both">
            <HeaderStyle CssClass="topRow" BorderStyle="None" />
            <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
            <AlternatingRowStyle CssClass="evenRow" />
            <Columns>
                  <asp:TemplateField HeaderText="Group Name">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtGroupName" runat="server" MaxLength="250" Text='<%# Bind("GroupName") %>' title="Group Name"></asp:TextBox>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:HyperLink ID="hlGroup" runat="server" Text='<%# Bind("GroupName") %>'
                            NavigateUrl='<%# Bind("GroupURI") %>'></asp:HyperLink>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="Visibility">
                    <EditItemTemplate>
                     <!--<asp:DropDownList id="ddEditVisibility" runat="server"
                         AutoPostBack="False" SelectedValue='<%# Eval("ViewSecurityGroupName") %>' >

                       <asp:ListItem value="Public">
                          Public
                       </asp:ListItem>
                       <asp:ListItem value="No Search">
                          No Search
                       </asp:ListItem>
                       <asp:ListItem value="Users">
                          Users
                       </asp:ListItem>
                       <asp:ListItem value="Private">
                          Private
                       </asp:ListItem>
                     </asp:DropDownList>-->
                       <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblVisibility" runat="server" Text='<%# Bind("ViewSecurityGroupName") %>'></asp:Label>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField HeaderText="End Date">
                    <EditItemTemplate>
                        <asp:TextBox ID="txtEndDate" runat="server" MaxLength="50" Text='<%# Bind("EndDate") %>' title="End Date"></asp:TextBox>
                        <asp:ImageButton ID="btnCalendar" runat="server" ImageUrl="~/Edit/Images/cal.gif" AlternateText="Calendar picker" />
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtEndDate"
                            PopupButtonID="btnCalendar">
                        </asp:CalendarExtender>
                    </EditItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="lblEndDate" runat="server" Text='<%# Bind("EndDate") %>'></asp:Label>
                    </ItemTemplate>
                  </asp:TemplateField>
                  <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Action">
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
                         <div class="actionbuttons">
                            <table>
                                <tr>
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
        <asp:Panel runat="server" ID="pnlAddProxy" Visible='false'>
        <br />
        <br />
        <table>
            <tr>
                <td valign="middle">
                    <asp:Image runat="server" ID="imgAdd" alt=" "/>&nbsp;
                </td>
                <td style="padding-bottom: 4px" valign="middle">                    
                    <asp:Literal runat="server" ID='lnkAddProxyTmp' Text = "Add A Proxy"></asp:Literal>
                </td>
            </tr>
        </table>
        </asp:Panel>
    </ContentTemplate>
</asp:UpdatePanel>
