<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditResearcherRole.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditResearcherRole.CustomEditResearcherRole"
    EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server" DynamicLayout="true" DisplayAfter="1000">
            <ProgressTemplate>
                <div class="modalupdate">
                    <div class="modalcenter">
                        <img alt="Updating..." src="<%=Profiles.Framework.Utilities.Root.Domain%>/edit/images/loader.gif" /><br/>
                            <i>This operation might take several minutes to complete. Please do not close your browser.</i>
                    </div>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <div class="editBackLink">
            <asp:Literal runat="server" ID="litBackLink"></asp:Literal>
        </div>
        <asp:Panel ID="phSecuritySettings" runat="server">
            <security:Options runat="server" ID="securityOptions"></security:Options>
        </asp:Panel>
        <asp:Panel ID="phAddGrant" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton ID="btnImgAddGrant" CssClass="EditMenuLinkImg" runat="server" ImageUrl="~/Edit/Images/icon_squareArrow.gif" OnClick="btnAddNewGrant_OnClick" AlternateText="Add Grant" />
                <asp:LinkButton ID="btnAddNewGrant" runat="server" OnClick="btnAddNewGrant_OnClick">Add NIH Grant</asp:LinkButton>&nbsp;(Search NIH grants.)                                
            </div>
        </asp:Panel>
        <asp:Panel ID="phAddCustom" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton ID="btnEditGrant" runat="server" OnClick="btnAddCustom_OnClick" CssClass="EditMenuLinkImg" ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnEditGrant2" runat="server" OnClick="btnAddCustom_OnClick">Add Custom Funding</asp:LinkButton>&nbsp;(Enter your own funding information using an online form.) 
            </div>
        </asp:Panel>
        <asp:Panel ID="phDisableDisambig" runat="server">
            <div class="EditMenuItem">                      
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnDisableDisambig_OnClick" runat="server" ID="btnImgDisableDisambig" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" Visible="true" />
                <asp:LinkButton ID="btnDisableDisambig" runat="server" OnClick="btnDisableDisambig_OnClick" Enabled="true">Configure Automatic Import</asp:LinkButton>
                (<asp:Label runat="server" ID="lblDisambigStatus" />)
            </div>
        </asp:Panel>
        <asp:Panel ID="phDeleteGrant" runat="server">
            <div class="EditMenuItem">
                <asp:Image runat="server" CssClass="EditMenuLinkImg" ID="btnImgDeleteGrant2" AlternateText=" " ImageUrl="~/Edit/Images/Icon_square_ArrowGray.png" Visible="false" />
                <asp:ImageButton ID="btnImgDeleteGrant" runat="server" ImageUrl="~/Edit/Images/icon_squareArrow.gif"
                    OnClick="btnDeleteGrant_OnClick" AlternateText="Delete" CssClass="EditMenuLinkImg" />
                <asp:LinkButton ID="btnDeleteGrant" runat="server" OnClick="btnDeleteGrant_OnClick">Delete All Funding</asp:LinkButton>
                <asp:Literal ID="btnDeleteGrantGray" Visible="false" runat="server" Text="Delete All Funding" />&nbsp;(Remove multiple funding sources from your profile.)                               
            </div>
        </asp:Panel>
        <%--Start Add By Search--%>
        <asp:Panel ID="pnlAddGrant" runat="server" CssClass="EditPanel" Visible="false" DefaultButton="cmdSubmit">
            <div style="padding-bottom: 10px;">Search for NIH grants</div>
            <div style="padding-bottom: 5px">
                <b>Award ID</b> ( use '%' for wildcard, e.g. 3R01CA12921-04S1A1
                                                    or %RO1%)
            </div>
            <div style="padding-bottom: 5px">
                <asp:TextBox Width='475px' TabIndex='4' runat="server" ID="txtProjectNumber" />
            </div>
            <div style="padding-bottom: 5px">
                <span style="padding-right: 25px"><b>Principal Investigator's Last Name</b>
                </span>
                <span style="padding-right: 20px;"><b>Principal Investigator's First Name</b></span>
                <b>Project Year</b>
            </div>
            <div style="padding-bottom: 5px">
                <span style="padding-right: 10px">
                    <asp:TextBox TabIndex='1' Width='225px' runat="server" ID='txtLastName' />
                </span>
                <span style="padding-right: 10px">
                    <asp:TextBox TabIndex='2' Width='225px' runat="server" ID='txtFirstName' />
                </span>
                <asp:DropDownList TabIndex='12' Width='227px' Height="21px" runat="server" ID="ddlProjectYear">
                </asp:DropDownList>
            </div>
            <div style="padding-bottom: 5px">
                <b>Awardee's Institution</b> (e.g., Harvard Medical School)
            </div>
            <div style="padding-bottom: 5px">
                <asp:TextBox runat="server" TabIndex='3' MaxLength='255' Width="735px" ID='txtOrganization' />
            </div>
            <div style="padding-bottom: 5px">
                <b>Project Title</b>
            </div>
            <div>
                <asp:TextBox Width="735px" TabIndex='11' runat="server" ID='txtTitle' />
            </div>
            <div class="actionbuttons">
                <asp:LinkButton TabIndex='13' runat="server" ID="cmdSubmit" Text="Search" OnClick="btnSubmit_OnClick" />
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton TabIndex='14' runat="server" ID="cmdClear" Text="Reset" OnClick="btnClear_OnClick" />
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton TabIndex='15' runat="server" ID="cmdClose" Text="Cancel" OnClick="btnClose_OnClick" />
            </div>
        </asp:Panel>
        <%--End Add By Search--%>
        <%--Start Search Results--%>
        <asp:Panel ID="pnlAddGrantResults" runat="server" CssClass="EditPanel" Visible="false">
            <img class="img-information-pubs" src="<%=ResolveUrl("~/edit/Images/icon_alert.gif") %>" alt=" " />Check the grants that are yours in the list below, and then click the Add Selected link at the bottom of the page.            
            <div class="actionbuttons">
                <b>Select:</b>&nbsp;&nbsp; <a tabindex="0" style="cursor: pointer" onclick="javascript:checkall(); return false;" id="btnCheckAll">All</a> &nbsp;&nbsp;|&nbsp;&nbsp;<a tabindex="0" style="cursor: pointer" id="btnUncheckAll" onclick="javascript:uncheckall(); return false;">None</a>
            </div>
            <asp:GridView EnableViewState="true" ID="grdGrantSearchResults" runat="server"
                GridLines="None" EmptyDataText="No Funding Found." DataKeyNames="FundingID"
                OnRowDataBound="grdGrantSearchResults_RowDataBound" Width="100%" AutoGenerateColumns="false">
                <EmptyDataRowStyle CssClass="edit360Padding10" />
                <RowStyle BackColor="#dde4ee" />
                <AlternatingRowStyle BackColor="#ffffff" />
                <Columns>
                    <asp:TemplateField ItemStyle-BorderStyle="None" ItemStyle-Width="20px">
                        <ItemTemplate>
                            <img alt="" style="cursor: pointer; padding-bottom: 7px; padding-left: 13px;" src="<%=GetURLDomain()%>/framework/images/expand.gif" />
                            <div class="grant-sub-row" style="display: none;">
                                <asp:GridView EnableViewState="true" ShowHeader="false" ID="grdSubGrantSearchResults"
                                    runat="server" GridLines="None" DataKeyNames="FullFundingID"
                                    OnRowDataBound="grdSubGrantSearchResults_RowDataBound" ShowFooter="true" AutoGenerateColumns="false">
                                    <FooterStyle Height="2px" />
                                    <Columns>
                                        <asp:TemplateField ItemStyle-Width="10px" ItemStyle-CssClass="grant-sub-arrow">
                                            <ItemTemplate>
                                                <asp:Image runat="server" ID="imgArrow" />
                                                <input type="hidden" id="hdCount" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ItemStyle-Width="20px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSubGrant" CssClass="checked" runat="server" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField ItemStyle-Width="172px" ItemStyle-CssClass="grant-sub-col-padding" DataField="FullFundingID" />
                                        <asp:BoundField ItemStyle-Width="206px" DataField="AgreementLabel" ItemStyle-CssClass="grant-sub-col-padding" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="PrincipalInvestigatorName" ItemStyle-CssClass="grant-sub-col-padding" />
                                        <asp:BoundField ItemStyle-Width="75px" DataField="StartDate" />
                                        <asp:BoundField ItemStyle-Width="75px" DataField="EndDate" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-Width="27px" ItemStyle-CssClass="grant-checkbox-cell">
                        <ItemTemplate>
                            <asp:CheckBox CssClass="chk-pubmed" ID="chkGrant" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField ItemStyle-Width="172px" DataField="FundingID" HeaderText="Award ID" />
                    <asp:BoundField ItemStyle-Width="206px" DataField="AgreementLabel" HeaderText="Project Title" />
                    <asp:BoundField ItemStyle-Width="150px" DataField="PrincipalInvestigatorName" HeaderText="Principal Investigator" />
                    <asp:BoundField ItemStyle-Width="75px" DataField="StartDate" HeaderText="Start Date" />
                    <asp:BoundField ItemStyle-Width="75px" DataField="EndDate" HeaderText="End Date" />
                </Columns>
            </asp:GridView>
            <div class="actionbuttons" id="add-div">
                <asp:LinkButton ID="lnkUpdateGrant" OnClick="btnGrantAddSelected_OnClick" runat="server"
                    CausesValidation="False" CommandName="Update"
                    Text="Add Selected" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                            <asp:LinkButton ID="lnkCancelGrant" runat="server"
                                CausesValidation="False" CommandName="Cancel" OnClick="btnGrantClose_OnClick"
                                Text="Cancel" />
            </div>
            <asp:Literal runat="server" ID="searchresultsJS"></asp:Literal>
        </asp:Panel>
        <%--End Search Results--%>
        <%--Start Custom Grant--%>
        <asp:Panel ID="pnlAddCustomGrant" runat="server" CssClass="EditPanel" Visible="false">
            Enter the following funding information below.
            <div style="margin-left: 5px;">
                <asp:CompareValidator ID="dateValidator1" runat="server" Type="Date" Operator="DataTypeCheck" ControlToValidate="txtStartYear" ErrorMessage="Please enter a valid date. (mm/dd/yyyy)" />&nbsp;&nbsp;
                <asp:CompareValidator ID="dateValidator2" runat="server" Type="Date" Operator="DataTypeCheck" ControlToValidate="txtEndYear" ErrorMessage="Please enter a valid date. (mm/dd/yyyy)" />
            </div>
            <div style="display: inline-flex;">
                <div style="margin-right: 5px;">
                    <div><b>Award ID</b> (e.g. UL1TR001102)</div>
                    <asp:TextBox ID="txtSponsorAwardID" runat="server" MaxLength="100" TabIndex="1" Width="200px" />
                </div>
                <div style="margin-right: 55px;">
                    <div><b>Principal Investigator Name</b></div>
                    <asp:TextBox ID="txtPIName" runat="server" TabIndex="2" Width="200px" Title="Principal Investigator Name" />
                </div>
                <div style="margin-right: 55px;">
                    <div><b>Start Date</b></div>
                    <div style="width: 110px;">
                        <asp:TextBox ID="txtStartYear" runat="server" Width="90px" TabIndex="3" Title="Start Date" />
                        <asp:ImageButton ID="btnCalendar3" runat="server" ImageUrl="~/Edit/Images/cal.png" Width="15px" AlternateText="Calendar" />
                        <asp:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtStartYear" PopupButtonID="btnCalendar3" />
                    </div>
                </div>
                <div>
                    <div><b>End Date</b></div>
                    <div style="width: 110px;">
                        <asp:TextBox ID="txtEndYear" runat="server" Width="90px" TabIndex="4" Title="End Date" />
                        <asp:ImageButton ID="btnCalendar2" runat="server" ImageUrl="~/Edit/Images/cal.png" Width="15px" AlternateText="Calendar" />
                        <asp:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtEndYear" PopupButtonID="btnCalendar2" />
                    </div>
                </div>
            </div>
            <div class="custom-grant-row">
                <b>Funding Sponsor</b>&nbsp;(e.g. NIH/NCATS)<br />
                <asp:TextBox ID="txtGrantAwardedBy" runat="server" Width="748px" TabIndex="5" Title="Funding Sponsor" />
            </div>
            <div class="custom-grant-row">
                <b>Project Title</b>&nbsp;<br />
                <asp:TextBox ID="txtProjectTitle" runat="server" Width="748px" TabIndex="6" Title="Project Title" />
            </div>
            <div class="custom-grant-row">
                <b>Brief Description</b> (e.g. The goal of this study is...)<br />
                <asp:TextBox ID="txtRoleDescription" runat="server" Columns="30" Width="748px" TextMode="MultiLine"
                    TabIndex="7" Title="Role Description" />
            </div>
            <div class="custom-grant-row">
                <b>Your Role on Project</b> (e.g. Co-Investigator)<br />
                <asp:TextBox ID="txtRole" runat="server" TabIndex="8" Width="748px" Title="Role" />
            </div>
            <div class="custom-grant-row">
                <b>Abstract</b> (e.g. Specific aims of this study are...)<br />
                <asp:TextBox Rows='5' Columns="20" Style="resize: none;" ID="txtAbstract" runat="server"
                    TabIndex="9" TextMode="MultiLine" Title="Abstract" Width="748px" />
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnInsertResearcherRole2" runat="server" CausesValidation="False"
                    OnClick="btnInsertClose_OnClick" Text="Save" TabIndex="11" />
                <asp:Literal runat="server" ID="lblInsertResearcherRolePipe">&nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;</asp:Literal>
                <asp:LinkButton ID="btnInsertResearcherRole" runat="server" CausesValidation="False"
                    OnClick="btnInsert_OnClick" Text="Save and Add Another" TabIndex="10" />
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;<asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                    Text="Cancel" TabIndex="7" />
            </div>
        </asp:Panel>
        <%--End Custom Grant--%>
        <%--Start Delete Grant--%>
        <asp:Panel ID="pnlDeleteGrant" runat="server" CssClass="EditPanel" Visible="false">
            To delete a single grant, click the delete icon to the right of the funding information.  To delete multiple grants, select one of the options below.  Note that you cannot undo this.
            <div class="actionbuttons">
                <asp:LinkButton ID="btnDeleteNIHOnly" runat="server" CausesValidation="False" OnClick="btnDeleteNIHOnly_OnClick"
                    Text="Delete only NIH grants" OnClientClick="Javascript:return confirm('Are you sure you want to delete the NIH funding sources?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteCustomOnly" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteCustomOnly_OnClick" Text="Delete Only Custom Funding Sources"
                                        OnClientClick="Javascript:return confirm('Are you sure you want to delete the custom funding sources?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                                        Text="Delete All Funding" OnClientClick="Javascript:return confirm('Are you sure you want to delete all grants?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteGrantClose" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteGrantClose_OnClick" Text="Cancel" />
            </div>
        </asp:Panel>
        <%--End Delete grants--%>
        <%--Start Disable disambiguation--%>
        <asp:Panel ID="pnlDisableDisambig" runat="server" CssClass="EditPanel" Visible="false">      
            <div style="margin-top: 10px" class="disambig-radio-label">
                <asp:RadioButtonList ID="rblDisambiguationSettings" runat="server">
                    <asp:ListItem Text="" Value="enable">Automatically add funding to my profile.</asp:ListItem>
                    <asp:ListItem Text="" Value="disable" >Do not automatically add funding to my profile.</asp:ListItem>
                </asp:RadioButtonList>
            </div>
            <div class="actionbuttons">               
                                    <asp:LinkButton ID="btnSaveDisambig" runat="server" CausesValidation="False" OnClick="btnSaveDisambig_OnClick"
                                        Text="Save"/>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnCancelDisambig" runat="server" CausesValidation="False"
                                        OnClick="btnCancel_OnClick" Text="Cancel" />
            </div>
          
        </asp:Panel>
        <%--End Disable disambiguation--%>
        <div class="editPage">
            <asp:GridView ID="GridViewResearcherRole" runat="server" DataKeyNames="FundingRoleID"
                AutoGenerateColumns="False" OnRowDataBound="GridViewResearcherRole_RowDataBound">
                <HeaderStyle CssClass="topRow" />
                <Columns>
                    <asp:TemplateField HeaderText="Funding" HeaderStyle-CssClass="alignLeft" ItemStyle-CssClass="alignLeft">
                        <ItemTemplate>
                            <asp:Literal runat="server" ID="lblFundingItem"></asp:Literal>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderStyle-CssClass="alignCenterAction" ItemStyle-CssClass="alignCenterAction" HeaderText="Action">
                        <ItemTemplate>
                            <asp:ImageButton ID="lnkEdit" OnClick="editOne_Onclick" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                CausesValidation="False" CommandName="Select" Text="Edit" Visible="true" AlternateText="Edit"></asp:ImageButton>
                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete_Grant"
                                OnClientClick="Javascript:return confirm('Are you sure you want to delete this funding record?');"
                                AlternateText="Delete"></asp:ImageButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div style="text-align: left; padding-top: 22px;">
            <asp:Label runat="server" ID="lblNoResearcherRole" Text="No funding records have been added." Visible="false"></asp:Label>
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
<script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.4.2.min.js"></script>
<script type="text/javascript">

    function checkall() {
        $("[id*='_chkGrant']").attr('checked', true);
        $("[id*='_chkGrant']").prop('checked', true);
        return false;
    }
    function uncheckall() {
        $("[id*='_chkGrant']").attr('checked', false);
        $("[id*='_chkGrant']").prop('checked', false);
        return false;
    }
   
</script>

<script type="text/javascript">
    var $jQuery_1_4_2 = $.noConflict(true);
    $jQuery_1_4_2("[src*=expand]").live("click", function () {
        $(this).closest("tr").after("<tr><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
        $(this).attr("src", "<%=GetURLDomain()%>/framework/images/collapse.gif");
    });
    $jQuery_1_4_2("[src*=collapse]").live("click", function () {
        $(this).attr("src", "<%=GetURLDomain()%>/framework/images/expand.gif");
        $(this).closest("tr").next().remove();
    });
</script>
