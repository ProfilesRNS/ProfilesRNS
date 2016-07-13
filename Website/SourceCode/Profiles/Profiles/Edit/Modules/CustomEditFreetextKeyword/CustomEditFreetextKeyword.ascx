<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditFreetextKeyword.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditFreetextKeyword.CustomEditFreetextKeyword" %>
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
                    <span><img alt="Loading..." src="../edit/Images/loader.gif" width="400" height="213"/></span>
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
                        <asp:PlaceHolder ID="phSecurityOptions" runat="server">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                            <br />
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phEditProperty" runat="server">
                            <asp:LinkButton ID="btnEditProperty" runat="server" OnClick="btnEditProperty_OnClick" 
                                CssClass="profileHypLinks"><asp:Image runat="server" ID="imbAddArror" AlternateText=" " ImageUrl="../../../Framework/Images/icon_squareArrow.gif"/>&nbsp;Add Keyword(s)</asp:LinkButton>
                            <br /><br />
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phDelAll" runat="server">
                            <asp:LinkButton ID="btnDelAll" runat="server" OnClick="btnDelAll_OnClick" 
                                CssClass="profileHypLinks"><asp:Image runat="server" ID="imbDelArrow" AlternateText=" " ImageUrl="../../../Framework/Images/icon_squareArrow.gif"/>&nbsp;Delete All Keyword(s)</asp:LinkButton>
                        </asp:PlaceHolder>
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
                        <p class="edithelp">Please enter your research, academic, and/or clinical interests as keywords. <br />Set the visibility to Public to display your Interests to others and make them searchable.
                        <!--<br />To import a list of keywords <asp:LinkButton ID="btnBulkInsert" runat="server" CommandArgument="Show" OnClick="btnBulkInsert_OnClick" CssClass="profileHypLinks">click here</asp:LinkButton>.-->
                        </p>
                        <table border="0" cellspacing="2" cellpadding="4">
                            <tr>
                                <td>
                                    <asp:TextBox ID="txtLabel" runat="server" Rows="1" Width="300px" TextMode="SingleLine" onfocus="updateDropdown(this)" onkeyup="updateDropdown(this)"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                <div style="padding-bottom: 5px; text-align: left;">
                                    <asp:LinkButton ID="btnInsertAward" runat="server" CausesValidation="False" OnClick="btnInsert_OnClick"
                                            Text="Save and add another" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                    
                                        <asp:LinkButton ID="btnInsertProperty" runat="server" CausesValidation="False" OnClick="btnInsertClose_OnClick"
                                            Text="Save and Close" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnEditProperty_OnClick"
                                            Text="Close" ></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlInsertPropertyBulk" runat="server" Style="background-color: #EEE;
                        margin-bottom: 5px; border: solid 1px #ccc;" 
                        Visible="false">
<p class="edithelp">Please enter your research, academic, and/or clinical interests <strong><span class="notice">as keywords separated by commas or new lines</span></strong>. <br />Set the visibility to Public to display your Interests to others and make them searchable.<br />To import a individual keywords 
                        <asp:LinkButton ID="btnSingleInsert" runat="server" CommandArgument="Show" OnClick="btnSingleInsert_OnClick"
                            CssClass="profileHypLinks">click here</asp:LinkButton>.</p></p>
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
                                            Text="Save and Close" ></asp:LinkButton>
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnInsertCancelBulk" runat="server" CausesValidation="False" OnClick="btnEditProperty_OnClick"
                                            Text="Close" ></asp:LinkButton>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlDeleteAll" runat="server" Style="background-color: #EEE;
                        margin-bottom: 5px; border: solid 1px #ccc;" 
                        Visible="false">
                        <p class="edithelp">To delete a single keyword, click the X to the right of the citation. To delete all keywords, click the link below. Note that you cannot undo this! 
                        </p>
                        <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                                            Text="Delete All Keywords" ></asp:LinkButton>
                    </asp:Panel>
                    <div style="border-left: solid 1px #ccc;">
                        <asp:GridView ID="GridViewProperty" runat="server" AutoGenerateColumns="False" CellPadding="4"
                            DataKeyNames="Subject,Predicate,Object" OnRowCancelingEdit="GridViewProperty_RowCancelingEdit"
                            OnRowDataBound="GridViewProperty_RowDataBound" OnRowDeleting="GridViewProperty_RowDeleting"
                            OnRowEditing="GridViewProperty_RowEditing" OnRowUpdated="GridViewProperty_RowUpdated"
                            OnRowUpdating="GridViewProperty_RowUpdating" Width="100%">
                            <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                            <RowStyle CssClass="edittable" />
                            <Columns>
                                <asp:TemplateField HeaderText="">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtLabelGrid" Rows="1" runat="server" TextMode="SingleLine" Width="300px" onfocus="updateDropdown(this)" onkeyup="updateDropdown(this)"
                                            Text='<%# Bind("Literal") %>'></asp:TextBox>     
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
                                                            ID="ibUp" ImageUrl="~/Edit/Images/icon_up.gif" AlternateText="move up"/>
                                                    </td>
                                                    <td>
                                                        <asp:ImageButton runat="server" OnClick="ibDown_Click" ID="ibDown" CommandArgument="down"
                                                            CommandName="action" ImageUrl="~/Edit/Images/icon_down.gif" AlternateText="move down" />
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