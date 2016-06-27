<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditResearcherRole.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditResearcherRole.CustomEditResearcherRole"
    EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<script type="text/javascript">
    var checkBoxSelector = '#<%=grdGrantSearchResults.ClientID%> input[id*="chkPubMed"]:checkbox';

    $(document).ready(function () {
        $('#btnCheckAll').live('click', function () {
            $(checkBoxSelector).attr('checked', true);
        });

        $('#btnUncheckAll').live('click', function () {
            $(checkBoxSelector).attr('checked', false);
        });
    });
    
</script>
<script type="text/javascript">
    $("[src*=expand]").live("click", function () {
        $(this).closest("tr").after("<tr><td colspan = '999'>" + $(this).next().html() + "</td></tr>")
        $(this).attr("src", "<%=GetURLDomain()%>/framework/images/collapse.gif");
    });
    $("[src*=collapse]").live("click", function () {
        $(this).attr("src", "<%=GetURLDomain()%>/framework/images/expand.gif");
        $(this).closest("tr").next().remove();
    });
</script>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 12px; left: 40%; top: 40%;">
                        <img alt="Loading..." src="<%=GetURLDomain()%>/edit/images/loader.gif" /><br />
                        <i>This operation might take several minutes to complete. Please do not close your browser.</i>
                    </span>
                </div>
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:Panel ID="pnlEditGrants" runat="server">
            <table id="tblEditGrants">
                <tr>
                    <td>
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
                        <asp:PlaceHolder ID="phAddGrant" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgAddGrant" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnAddNewGrant_OnClick" AlternateText="Add Grant" />&nbsp;
                                <asp:LinkButton ID="btnAddNewGrant" runat="server" OnClick="btnAddNewGrant_OnClick"
                                    CssClass="profileHypLinks">Add NIH Grant</asp:LinkButton>
                                &nbsp;(Search NIH grants.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddCustom" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgAddCustom" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnAddCustom_OnClick" AlternateText="Add Custom Funding" />&nbsp;
                                <asp:LinkButton ID="btnAddCustom" runat="server" OnClick="btnAddCustom_OnClick" CssClass="profileHypLinks">Add Custom Funding</asp:LinkButton>
                                &nbsp;(Enter your own funding information using an online form.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phDeleteGrant" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgDeleteGrant" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnDeleteGrant_OnClick" AlternateText="Delete" />&nbsp;
                                <asp:LinkButton ID="btnDeleteGrant" runat="server" OnClick="btnDeleteGrant_OnClick"
                                    CssClass="profileHypLinks">Delete all funding</asp:LinkButton>
                                &nbsp;(Remove multiple funding sources from your profile.)
                            </div>
                        </asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%--Start Add By Search--%>
                        <asp:Panel ID="pnlAddGrant" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                            border: solid 1px #999;" Visible="false" DefaultButton="cmdSubmit">
                            <div style="padding: 15px 0px 0px 5px;">
                                Search for NIH grants
                                <div>
                                    <table border='0' width='750px'>
                                        <tr height='30px' valign="bottom">
                                            <td  colspan='2' width="500px">                                            
                                                <b>Award ID</b> ( use '%' for wildcard, e.g. 3R01CA12921-04S1A1
                                                    or %RO1%)
                                            </td>
                                            <td width="225px" style="padding-left: 5px">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan='2' width="500px">
                                                <asp:TextBox Width='475px' TabIndex='4' runat="server" ID="txtProjectNumber" />
                                            </td>
                                            <td width="225px" style="padding-left: 5px">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr height='30px' valign="bottom">
                                            <td width="225px" >
                                                <b>Principal Investigator's Last Name</b>
                                            </td>
                                            <td width="225px">
                                                <b>Principal Investigator's First Name</b>
                                            </td>
                                            <td width="225px">
                                                <b>Project Year</b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:TextBox TabIndex='1' Width='225px' runat="server" ID='txtLastName' />
                                            </td>
                                            <td>
                                                <asp:TextBox TabIndex='2' Width='225px' runat="server" ID='txtFirstName' />
                                            </td>
                                            <td>
                                                <asp:DropDownList  TabIndex='12' Width='227px' runat="server" ID="ddlProjectYear">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr height='30px' valign="bottom">
                                            <td colspan='3'>
                                                <b>Awardee's Institution</b> (e.g., Harvard Medical School)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan='3'>
                                                <asp:TextBox runat="server" TabIndex='3' MaxLength='255' width="735px" ID='txtOrganization'/>
                                            </td>
                                        </tr>
                                        <tr height='30px' valign="bottom">
                                            <td colspan='3'>
                                                <b>Project Title</b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan='3'>
                                                <asp:TextBox width="735px" TabIndex='11' runat="server" ID='txtTitle' />
                                            </td>
                                        </tr>
                                    </table>
                                    <div style="padding: 10px 0px 10px 0px;" >
                                        <asp:LinkButton TabIndex='13' runat="server" ID="cmdSubmit" Text="Search" OnClick="btnSubmit_OnClick" />
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton TabIndex='14' runat="server" ID="cmdClear" Text="Reset" OnClick="btnClear_OnClick" />
                                        &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                        <asp:LinkButton TabIndex='15' runat="server" ID="cmdClose" Text="Cancel" OnClick="btnClose_OnClick" />
                                    </div>
                                </div>
                        </asp:Panel>
                        <%--End Add By Search--%>
                        <%--Start Search Results--%>
                        <asp:Panel ID="pnlAddGrantResults" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false" Width='750px' DefaultButton="lnkUpdateGrant">
                            <div style="padding: 5px;">
                                <div>
                                    <div style="width: 25px; float: left;">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Framework/Images/icon_alert.gif"
                                            AlternateText=" " />
                                    </div>
                                    <div style="margin-left: 25px;">
                                        Check the grants that are yours in the list below, and then click the Add Selected
                                        link at the bottom of the page.
                                    </div>
                                </div>
                                <asp:Panel runat="server" ID="pnlAddAll">
                                    <div style="padding: 10px 0px 5px 5px; background-color: #E2E6E8;">
                                        <b>Select:</b>&nbsp;&nbsp;
                                        <asp:LinkButton runat="server" ID="btnCheckAll" Text="All" OnClick="btnCheckAll_OnClick" />&nbsp;&nbsp;|&nbsp;&nbsp;
                                        <asp:LinkButton runat="server" ID="btnUncheckAll" Text="None" OnClick="btnUncheckAll_OnClick" />
                                    </div>
                                </asp:Panel>
                                <asp:GridView EnableViewState="true" ID="grdGrantSearchResults" runat="server" GridLines="None"
                                    EmptyDataText="No Funding Found." DataKeyNames="FundingID" AutoGenerateColumns="false"
                                    AllowPaging="false" OnRowDataBound="grdGrantSearchResults_RowDataBound" CellPadding="0"
                                    Width='745px'>
                                    <AlternatingRowStyle BackColor="#FFFFFF" />
                                    <RowStyle BackColor="#dde4ee" />
                                    <Columns>
                                        <asp:TemplateField ItemStyle-BorderStyle="None" ItemStyle-Width="20px">
                                            <ItemTemplate>
                                                <img alt="" style="cursor: pointer" src="<%=GetURLDomain()%>/framework/images/expand.gif" />
                                                <asp:Panel ID="pnlSearchResults" runat="server" Style="display: none">
                                                    <asp:GridView EnableViewState="true" ShowHeader="false" ID="grdSubGrantSearchResults"
                                                        runat="server" GridLines="None" DataKeyNames="FullFundingID" AutoGenerateColumns="false"
                                                        OnRowDataBound="grdSubGrantSearchResults_RowDataBound" ShowFooter="true" AllowPaging="false"
                                                        CellPadding="0">
                                                        <FooterStyle Height="2px" />
                                                        <Columns>
                                                            <asp:TemplateField ItemStyle-Width="30px" ItemStyle-VerticalAlign="Top">
                                                                <ItemTemplate>
                                                                    <div style="float: right; vertical-align: top;">
                                                                        <asp:Image runat="server" ID="imgArrow" /></div>
                                                                    <input type="hidden" id="hdCount" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:TemplateField ItemStyle-Width="20px">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkSubGrant" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField ItemStyle-Width="172px" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap="false"
                                                                DataField="FullFundingID" />
                                                            <asp:BoundField ItemStyle-Width="206px" DataField="AgreementLabel" />
                                                            <asp:BoundField ItemStyle-Width="150px" DataField="PrincipalInvestigatorName" />
                                                            <asp:BoundField ItemStyle-Width="75px" DataField="StartDate" />
                                                            <asp:BoundField ItemStyle-Width="75px" DataField="EndDate" />
                                                        </Columns>
                                                    </asp:GridView>
                                                </asp:Panel>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField ItemStyle-Width="20px">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkGrant" runat="server" /></ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField ItemStyle-Width="172px" ItemStyle-HorizontalAlign="left" ItemStyle-Wrap="false"
                                            DataField="FundingID" HeaderText="Award ID" />
                                        <asp:BoundField ItemStyle-Width="206px" DataField="AgreementLabel" HeaderText="Project Title" />
                                        <asp:BoundField ItemStyle-Width="150px" DataField="PrincipalInvestigatorName" HeaderText="Principal Investigator" />
                                        <asp:BoundField ItemStyle-Width="75px" DataField="StartDate" HeaderText="Start Date" />
                                        <asp:BoundField ItemStyle-Width="75px" DataField="EndDate" HeaderText="End Date" />
                                    </Columns>
                                </asp:GridView>
                                <div class="actionbuttons" style="background-color: #E2E6E8;">
                                    <table style="padding: 2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="lnkUpdateGrant" OnClick="btnGrantAddSelected_OnClick" runat="server"
                                                    ImageUrl="~/Edit/Images/button_save.gif" CausesValidation="False" CommandName="Update"
                                                    Text="Add Selected" AlternateText="Add Selected"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="lnkCancelGrant" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="btnGrantClose_OnClick"
                                                    Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Search Results--%>
                        <%--Start Custom Grant--%>
                        <asp:Panel ID="pnlAddCustomGrant" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <table border="0" cellspacing="2" width='750px'>
                                    <tr>
                                        <td colspan="3" style="padding: 10px 0px 0px 0px;">
                                            <div style="padding-top: 5px;">
                                                Enter the following funding information below.
                                                <asp:CompareValidator ID="dateValidator1" runat="server" Type="Date" Operator="DataTypeCheck"
                                                    ControlToValidate="txtStartYear" ErrorMessage="Please enter a valid date. (mm/dd/yyyy)">
                                                </asp:CompareValidator>
                                                <asp:CompareValidator ID="dateValidator2" runat="server" Type="Date" Operator="DataTypeCheck"
                                                    ControlToValidate="txtEndYear" ErrorMessage="Please enter a valid date. (mm/dd/yyyy)">
                                                </asp:CompareValidator>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr valign='bottom'>
                                        <td style="padding: 10px 0px 0px 0px;">
                                            <b>Award ID</b> (e.g. UL1TR001102)<br />
                                            <asp:TextBox ID="txtSponsorAwardID" runat="server" MaxLength="100" TabIndex="1" Width="200px"
                                                Title="Sponsor Award ID"></asp:TextBox>
                                        </td>
                                        <td style="padding: 10px 0px 0px 0px;">
                                            <b>Principal Investigator Name</b><br />
                                            <asp:TextBox ID="txtPIName" runat="server" TabIndex="2" Width="200px" Title="Principal Investigator Name"></asp:TextBox>
                                        </td>
                                        <td style="padding: 10px 0px 0px 0px;">
                                            <div style="float: left; width: 134px;">
                                                <b>Start Date</b><br />
                                                <asp:TextBox ID="txtStartYear" runat="server" Width="90px" TabIndex="3" Title="Start Date"></asp:TextBox>
                                                <asp:ImageButton ID="btnCalendar3" runat="server" ImageUrl="~/Edit/Images/cal.gif"
                                                    AlternateText="Calendar" />
                                                <asp:CalendarExtender ID="CalendarExtender5" runat="server" TargetControlID="txtStartYear"
                                                    PopupButtonID="btnCalendar3">
                                                </asp:CalendarExtender>
                                            </div>
                                            <div style='float: right; width: 128px;'>
                                                <b>End Date</b><br />
                                                <asp:TextBox ID="txtEndYear" runat="server" Width="90px" TabIndex="4" Title="End Date"></asp:TextBox>
                                                <asp:ImageButton ID="btnCalendar2" runat="server" ImageUrl="~/Edit/Images/cal.gif"
                                                    AlternateText="Calendar" />
                                                <asp:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtEndYear"
                                                    PopupButtonID="btnCalendar2">
                                                </asp:CalendarExtender>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='3' style="padding: 10px 0px 0px 0px;">
                                            <b>Funding Sponsor</b>&nbsp;(e.g. NIH/NCATS)<br />
                                            <asp:TextBox ID="txtGrantAwardedBy" runat="server" Width="748px" TabIndex="5" Title="Funding Sponsor"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='3' style="padding: 10px 0px 0px 0px;">
                                            <b>Project Title</b>&nbsp;<br />
                                            <asp:TextBox ID="txtProjectTitle" runat="server" Width="748px" TabIndex="6" Title="Project Title"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td valign="top" colspan='3' style="padding: 10px 0px 0px 0px;">
                                            <b>Brief Description</b> (e.g. The goal of this study is...)<br />
                                            <asp:TextBox ID="txtRoleDescription" runat="server" Columns="30" Width="748px" TextMode="MultiLine"
                                                TabIndex="7" Title="Role Description"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='3' valign="top" style="padding: 10px 0px 0px 0px;">
                                            <b>Your Role on Project</b> (e.g. Co-Investigator)<br />
                                            <asp:TextBox ID="txtRole" runat="server" TabIndex="8" Width="748px" Title="Role"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan='3' style="padding: 10px 0px 0px 0px;">
                                            <b>Abstract</b> (e.g. Specific aims of this study are...)<br />
                                            <asp:TextBox Rows='5' Columns="20" Style="resize: none;" ID="txtAbstract" runat="server"
                                                TabIndex="9" TextMode="MultiLine" Title="Abstract" Width="748px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="padding: 10px 0px 0px 0px;">
                                            <div style="padding-bottom: 5px; text-align: left;">
                                                <asp:LinkButton ID="btnInsertResearcherRole" runat="server" CausesValidation="False"
                                                    OnClick="btnInsert_OnClick" Text="Save and add another" TabIndex="10"></asp:LinkButton>
                                                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                                <asp:LinkButton ID="btnInsertResearcherRole2" runat="server" CausesValidation="False"
                                                    OnClick="btnInsertClose_OnClick" Text="Save and close" TabIndex="11"></asp:LinkButton>
                                                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                                <asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False" OnClick="btnInsertCancel_OnClick"
                                                    Text="Cancel" TabIndex="7"></asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </asp:Panel>
                        <%--End Custom Grant--%>
                        <%--Start Delete Grant--%>
                        <asp:Panel ID="pnlDeleteGrant" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                            border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    To delete a single grant, click the delete icon to the right of the funding information.
                                    To delete multiple grants, select one of the options below. Note that you cannot
                                    undo this!
                                </div>
                                <div style="padding: 10px 0px;">
                                    <asp:LinkButton ID="btnDeleteNIHOnly" runat="server" CausesValidation="False" OnClick="btnDeleteNIHOnly_OnClick"
                                        Text="Delete only NIH grants" OnClientClick="Javascript:return confirm('Are you sure you want to delete the NIH funding sources?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteCustomOnly" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteCustomOnly_OnClick" Text="Delete only custom funding sources"
                                        OnClientClick="Javascript:return confirm('Are you sure you want to delete the custom funding sources?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                                        Text="Delete all funding" OnClientClick="Javascript:return confirm('Are you sure you want to delete all grants?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteGrantClose" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteGrantClose_OnClick" Text="Close"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Delete grants--%>
                    </td>
                </tr>
            </table>
        </asp:Panel>
        <div>
            <asp:GridView ID="GridViewResearcherRole" runat="server" DataKeyNames="FundingRoleID"
                AutoGenerateColumns="False" CellPadding="4" GridLines="Both" OnRowDataBound="GridViewResearcherRole_RowDataBound"
                Width="100%">
                <HeaderStyle CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                <RowStyle BorderStyle="Solid" BorderWidth="1px" />
                <Columns>
                    <asp:TemplateField ShowHeader="False">
                        <ItemTemplate>
                            <div class='basicInfo' style="float: left">
                                <asp:Literal runat="server" ID="lblFundingItem"></asp:Literal>
                            </div>
                            <div style="float: right; top: 50%;" class="actionbuttons">
                                <table>
                                    <tr valign='top' align="left">
                                        <td>
                                            <asp:ImageButton ID="lnkEdit" OnClick="editOne_Onclick" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                                CausesValidation="False" CommandName="Select" Text="Edit" Visible="true" AlternateText="Edit">
                                            </asp:ImageButton>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                                CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete_Grant"
                                                Text="X" OnClientClick="Javascript:return confirm('Are you sure you want to delete this funding record?');"
                                                AlternateText="Delete"></asp:ImageButton>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <i>
            <asp:Label runat="server" ID="lblNoResearcherRole" Text="No funding records have been added."
                Visible="false"></asp:Label></i>
    </ContentTemplate>
    <Triggers>
    </Triggers>
</asp:UpdatePanel>
