<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditFreetextKeyword.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditFreetextKeyword.CustomEditFreetextKeyword" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
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
        <asp:Panel ID="phSecurityOptions" runat="server">
            <security:Options runat="server" ID="securityOptions"></security:Options>
        </asp:Panel>
        <asp:Panel ID="phEditProperty" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton runat="server" ID="imbAddArrow" OnClick="btnEditProperty_OnClick" CssClass="EditMenuLinkImg" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton CssClass="EditMenuLinkImg" ID="btnEditProperty" runat="server" OnClick="btnEditProperty_OnClick">Add Keyword(s)</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Panel ID="phDelAll" runat="server" Visible="false">
            <div class="EditMenuItem">
                <asp:ImageButton runat="server" ID="imbDelArrow" CssClass="EditMenuLinkImg" OnClick="btnDelAll_OnClick" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton CssClass="EditMenuLinkImg" ID="btnDelAll" runat="server" OnClick="btnDelAll_OnClick">Delete All Keyword(s)</asp:LinkButton>
            </div>
        </asp:Panel>
        <asp:Repeater ID="RptrEditProperty" runat="server" Visible="false">
            <ItemTemplate>
                <asp:Label ID="lblEditProperty" runat="server" Text='<%#Eval("Label").ToString() %>' />
                <br />
            </ItemTemplate>
        </asp:Repeater>
        <asp:Panel ID="pnlInsertProperty" runat="server" CssClass="EditPanel"
            Visible="false">
            Please enter a word or phrase that describes your research, academic or clinical interests.<br />
            Set the visibility to Public to display your Interests to others and make them searchable.                    
            <div style="margin-top: 8px;">
                <asp:TextBox ID="txtLabel" runat="server" Rows="1" MaxLength="100" Width="600px" TextMode="SingleLine" />
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnInsertProperty" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick" Text="Save" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                <asp:LinkButton ID="btnInsertAward" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick" Text="Save and add another" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnEditProperty_OnClick" Text="Cancel" />
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlInsertPropertyBulk" runat="server" Style="background-color: #EEE; margin-bottom: 5px; border: solid 1px #ccc;"
            Visible="false">
            <p class="edithelp">
                Please enter your research, academic, and/or clinical interests <strong><span class="notice">as keywords separated by commas or new lines</span></strong>.
                <br />
                Set the visibility to Public to display your Interests to others and make them searchable.<br />
                To import a individual keywords 
                       
                <asp:LinkButton ID="btnSingleInsert" runat="server" CommandArgument="Show" OnClick="btnSingleInsert_OnClick"
                    CssClass="profileHypLinks">click here</asp:LinkButton>.
            </p>
            </p>
                       
            <table border="0" cellspacing="2" cellpadding="4">
                <tr>
                    <td>
                        <asp:TextBox ID="txtLabelBulk" runat="server" Rows="5" Width="500px" TextMode="MultiLine"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <div style="padding-bottom: 5px; text-align: left;">
                            <asp:LinkButton ID="btnInsertPropertyBulk" runat="server" CausesValidation="False" OnClick="btnInsertBulkClose_OnClick"
                                Text="Save and Close"></asp:LinkButton>
                            &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                       
                            <asp:LinkButton ID="btnInsertCancelBulk" runat="server" CausesValidation="False" OnClick="btnEditProperty_OnClick"
                                Text="Close"></asp:LinkButton>
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <asp:Panel ID="pnlDeleteAll" runat="server" CssClass="EditPanel" Visible="false">
            <p>To delete a single keyword, click on the <b>Trash Can Icon</b> to the right of the keyword.</p>
            <p>To delete all keywords, click the <b>Delete All Keywords</b> link below.</p>
            <p>(Note: These actions cannot be undone)</p>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                    Text="Delete All Keywords" />
            </div>
        </asp:Panel>
      <div class="editPage">
            <asp:GridView ID="GridViewProperty" runat="server" AutoGenerateColumns="False"
                DataKeyNames="Subject,Predicate,Object" OnRowCancelingEdit="GridViewProperty_RowCancelingEdit"
                OnRowDataBound="GridViewProperty_RowDataBound" OnRowDeleting="GridViewProperty_RowDeleting"
                OnRowEditing="GridViewProperty_RowEditing" OnRowUpdated="GridViewProperty_RowUpdated"
                OnRowUpdating="GridViewProperty_RowUpdating"
                CssClass="editBody">
                <HeaderStyle CssClass="topRow" />
                <RowStyle CssClass="oddRow" />
                <Columns>
                    <asp:TemplateField HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft" HeaderText="Keywords">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtLabelGrid" Rows="1" runat="server" TextMode="SingleLine" MaxLength="100" Width="600px" Text='<%# Bind("Literal") %>' />
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="lblLabel" runat="server"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="Action">
                        <EditItemTemplate>
                            <asp:LinkButton ID="lnkUpdate" runat="server"
                                CausesValidation="True" CommandName="Update" Text="Save" />&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;                                    
                                        <asp:LinkButton ID="lnkCancel" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                        </EditItemTemplate>
                        <ItemTemplate>
                        </ItemTemplate>
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
                                    AlternateText="X"></asp:ImageButton>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:Label runat="server" ID="lblNoItems" Text="<i>No items have been added.</i>" Visible="false"></asp:Label>

    </ContentTemplate>
</asp:UpdatePanel>

<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>
<script type="text/javascript" src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
<script type="text/javascript">
    function updateDropdown(el) {
        var keywordValue = el.value
        var url = el.getAttribute('data-autocomplete-url').toString()
        $(el).autocomplete({
            source: url + keywordValue,
            position: { my: "left bottom", at: "left top", collision: "flip" }
        });
    }
  </script>
