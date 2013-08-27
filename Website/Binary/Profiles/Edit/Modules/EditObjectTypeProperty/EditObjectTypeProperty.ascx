<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditObjectTypeProperty.ascx.cs"
    Inherits="Profiles.Edit.Modules.EditObjectTypeProperty.EditObjectTypeProperty" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">

    var _page = 0;
    var _offset = 0;
    var _totalrows = 0;
    var _totalpages = 0;
    var _root = "";
    var _subject = 0;
    var _fname = '';
    var _lname = '';
    var _department = '';
    var _institution = '';


    function GotoNextPage() {

        _page++;
        NavToPage();
    }
    function GotoPreviousPage() {

        _page--;
        NavToPage();
    }
    function GotoFirstPage() {

        _page = 1;
        NavToPage();
    }
    function GotoLastPage() {

        _page = _totalpages;
        NavToPage();
    }
    function NavToPage() {

        window.location = _root + '/proxy/default.aspx?method=search&currentpage=' + _page +
                '&totalrows=' + _totalrows + '&offset=' + _offset + '&totalpages=' + _totalpages + '&subject=' + _subject +
                '&fname=' + _fname + '&lname=' + _lname + '&institution=' + _institution + '&department=' + _department;
    }


    function EntitySelected(uri) {

        document.getElementById("hdnSelectedURI").value = uri;
        document.forms[0].submit();

    }  
    
    
    
</script>

<input type="hidden" id="hdnSelectedURI" name="hdnSelectedURI" />
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
        <asp:HiddenField ID="hiddenSubjectID" runat="server" />
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" /></span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <table id="tblEditProperty" width="100%">
            <tr>
                <td align="left" style="padding-right: 12px">
                    <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:PlaceHolder ID="phSecuritySettings" runat="server">
                        <div style="padding-bottom: 10px;">
                            <security:Options runat="server" ID="securityOptions"></security:Options>
                        </div>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phAddByURL" runat="server">
                        <div style="padding-bottom: 10px;">
                            <asp:ImageButton runat="server" ID="imgAddArror" ImageUrl="../../../Framework/Images/icon_squareArrow.gif"
                                OnClick="btnAddByURI_OnClick" />&nbsp;
                            <asp:LinkButton ID="btnEditProperty" runat="server" CommandArgument="Show" OnClick="btnAddByURI_OnClick"
                                CssClass="profileHypLinks">Add Item By URL</asp:LinkButton>
                            (Add existing item by entering its URL.)
                        </div>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phAddBySearch" runat="server">
                        <div style="padding-bottom: 10px;">
                            <asp:ImageButton runat="server" ID="imgAddSearch" ImageUrl="../../../Framework/Images/icon_squareArrow.gif"
                                OnClick="btnAddBySearch_OnClick" />&nbsp;
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandArgument="Show" OnClick="btnAddBySearch_OnClick"
                                CssClass="profileHypLinks">Add Item by Search</asp:LinkButton>
                            (Add existing item by searching for it.)
                        </div>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder ID="phAddNew" runat="server">
                        <div style="padding-bottom: 10px;">
                            <asp:ImageButton runat="server" ID="imgAddNew" ImageUrl="../../../Framework/Images/icon_squareArrow.gif"
                                OnClick="btnAddNew_OnClick" />&nbsp;
                            <asp:LinkButton ID="lnkAddNew" runat="server" CommandArgument="Show" OnClick="btnAddNew_OnClick"
                                CssClass="profileHypLinks">Add New Item</asp:LinkButton>
                            (Add a new item that you create.)
                        </div>
                    </asp:PlaceHolder>
                </td>
            </tr>
        </table>
        <asp:Panel runat="server" ID="pnlAddByURI" Visible="false">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table class="searchForm">
                            <tr>
                                <td>
                                    <b>URL:</b>&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox ID="txtURI" runat="server" Width="300px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <table style="padding: 2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="cmdSaveByURI" OnClick="cmdSaveByURI_onclick" runat="server"
                                                    ImageUrl="~/Edit/Images/button_search.gif" CausesValidation="False" Text="Add Selected">
                                                </asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="cmdCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="cmdSaveByURICancel_onclick"
                                                    Text="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <asp:RegularExpressionValidator EnableClientScript="true"  ID="RegularExpressionValidator1" runat="Server" ControlToValidate="txtURI"
                            ValidationExpression="(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?" ErrorMessage="Please enter a valid URI."
                            Display="Dynamic"/>
                    </div>
                </div>
            </div>
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlAddByURIConfirm" Visible="false">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table class="searchForm">
                            <tr>
                                <td colspan="2">
                                    <b>Item Name:</b>
                                    <asp:Literal runat="server" ID="litAddByURIConfirmLabel"></asp:Literal>
                                    <br />
                                    <b>Item Type:</b>
                                    <asp:Literal runat="server" ID="litAddByURIConfirmType"></asp:Literal>
                                    <asp:HiddenField runat="server" ID="hdnURI" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan='2'>
                                    <br />
                                    <table style="padding: 2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="cmdAddByURIConfirm" OnClick="cmdSaveByURIConfirm_onclick" runat="server"
                                                    ImageUrl="~/Edit/Images/button_save.gif" CausesValidation="False" Text="Add Selected">
                                                </asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="cmdCancelByURIConfirm" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="cmdSaveByURIConfirmCancel_onclick"
                                                    Text="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel runat="server" ID="pnlAddBySearch" Visible="false">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table class="searchForm">
                            <tr>
                                <td>
                                    </b>Keyword:</b>&nbsp;
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="txtKeyword" Width="251px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    </b>Item Type:</b>&nbsp;
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="searchselect" ID="ddlPropertyList" runat="server" Width="252px">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Type of Item is required"
                                        ControlToValidate="ddlPropertyList" Display="Dynamic" InitialValue="" SetFocusOnError="True">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="padding: 2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="cmdSearch" runat="server" ImageUrl="~/Edit/Images/button_search.gif"
                                                    OnClick="cmdSearch_OnClick" Text="search"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="cmdSearchCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="cmdSearchCancel_onclick"
                                                    Text="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel ID="pnlProxySearchResults" runat="server" Visible="false">
                            Select an item from the list below.
                            <div style="margin-top: 8px; padding: 6px">
                                <asp:GridView Width="100%" ID="gridSearchResults" runat="server" DataKeyNames="URI"
                                    AllowPaging="false" PageSize="100" EmptyDataText="&nbsp;Nothing found." AutoGenerateColumns="False"
                                    OnRowDataBound="gridSearchResults_RowDataBound">
                                    <AlternatingRowStyle CssClass="evenRow" />
                                    <HeaderStyle CssClass="topRow" />
                                    <Columns>
                                        <asp:BoundField DataField="Label" HeaderText="Search Results" />
                                        <asp:TemplateField Visible="false">
                                            <ItemTemplate>
                                                <asp:HiddenField runat="server" ID="hdnURI" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlAddNew" runat="server" Visible="false">
            <div class="tabContainer" style="margin-top: 0px;">
                <div class="searchForm">
                    <div class="searchSection">
                        <table class="searchForm">
                            <tr>
                                <td>
                                    <b>Item Name:</b>
                                </td>
                                <td>
                                    <asp:TextBox runat="server" ID="txtNewEntity" Width="251px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Item Type:</b>
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="searchselect" ID="ddlAddNewPropertyList" runat="server"
                                        Width="252px">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Type of Item is required"
                                        ControlToValidate="ddlAddNewPropertyList" Display="Dynamic" InitialValue="" SetFocusOnError="True">
                                    </asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table style="padding: 2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="cmdAddNew" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                                    OnClick="cmdAddNew_OnClick" Text="Save"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="cmdAddNewCancel" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="cmdAddNewCancel_onclick"
                                                    Text="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            </div>
        </asp:Panel>
        <div style="margin-top: 8px;">
            <asp:GridView Width="100%" CellPadding="4" ID="gridEntities" runat="server" DataKeyNames="URI"
                AllowPaging="true" PageSize="25" AutoGenerateColumns="False" OnRowDataBound="gridEntities_RowDataBound"
                OnRowDeleting="gridEntities_RowDeleting" GridLines="Both">
                <RowStyle CssClass="edittable" />
                <AlternatingRowStyle CssClass="evenRow" />
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:BoundField DataField="Label" HeaderText="Items" NullDisplayText="--" SortExpression="" />
                    <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center">
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
                                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                                CausesValidation="False" CommandName="Delete" OnClientClick="Javascript:return confirm('Are you sure you want to delete this entity?');"
                                                Text="X"></asp:ImageButton>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <asp:HiddenField runat="server" ID="hdnURI" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Label runat="server" ID="lblNoItems" Visible="false"></asp:Label>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<asp:Literal runat="server" ID="litPagination"></asp:Literal>