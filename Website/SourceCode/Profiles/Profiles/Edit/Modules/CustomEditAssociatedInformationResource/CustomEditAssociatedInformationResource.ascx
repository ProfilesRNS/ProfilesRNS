<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditAssociatedInformationResource.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditAssociatedInformationResource.CustomEditAssociatedInformationResource" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">
    var checkBoxSelector = '#<%=grdPubMedSearchResults.ClientID%> input[id*="chkPubMed"]:checkbox';

    function checkall() {
        $("[id*='chkPubMed']").attr('checked', true);
        $("[id*='chkPubMed']").prop('checked', true);

        return false;
    }
    function uncheckall() {
        $("[id*='chkPubMed']").attr('checked', false);
        $("[id*='chkPubMed']").prop('checked', false);
        return false;
    }

    function showdiv() {
        var divChkList = $('[id$=divChkList]').attr('id');
        var chkListItem = $('[id$=chkLstItem_0]').attr('id');
        document.getElementById(divChkList).style.display = "block";

        document.getElementById(chkListItem).focus()
    }

    function showdivonClick() {
        var objDLL = $('[id$=divChkList]').attr('id');// document.getElementById("divChkList");

        if (document.getElementById(objDLL).style.display == "block")
            document.getElementById(objDLL).style.display = "none";
        else
            document.getElementById(objDLL).style.display = "block";
    }

    function uncheckAllPeople() {
       var arr = document.getElementById($('[id$=chkLstItem]').attr('id')).getElementsByTagName('input');
        
        for (i = 0; i < arr.length; i++) {
            checkbox = arr[i];
            checkbox.checked = false;
       //     if (i == lstNo) {
       //         if (ctrlType == 'anchor') {
                        //checkbox.checked = false;
       //         }
        }
    }

    function getSelectedItem(lstValue, lstNo, lstID, ctrlType) {


        var noItemChecked = 0;
        var ddlChkList = document.getElementById($('[id$=ddlChkList]').attr('id'));
        var selectedItems = "";
        var selectedIDs = "";
        var arr = document.getElementById($('[id$=chkLstItem]').attr('id')).getElementsByTagName('input');
        var arrlbl = document.getElementById($('[id$=chkLstItem]').attr('id')).getElementsByTagName('label');
        var objLstId = document.getElementById($('[id$=hidList]').attr('id')); //document.getElementById('hidList');

        for (i = 0; i < arr.length; i++) {
            checkbox = arr[i];
            if (i == lstNo) {
                if (ctrlType == 'anchor') {
                    if (!checkbox.checked) {
                        checkbox.checked = true;
                    }
                    else {
                        checkbox.checked = false;
                    }
                }
            }

            if (checkbox.checked) {

                var buffer;
                if (arrlbl[i].innerText == undefined)
                    buffer = arrlbl[i].textContent;
                else
                    buffer = arrlbl[i].innerText;

                if (selectedItems == "") {

                    selectedItems = buffer;
                    
                }
                else {
                    selectedItems = selectedItems + "," + buffer;
                }
                selectedIDs = selectedIDs + i + ",";
                noItemChecked = noItemChecked + 1;
            }
        }

        ddlChkList.title = selectedItems;

        if (noItemChecked != "0")
            ddlChkList.options[ddlChkList.selectedIndex].text = selectedItems;
        else
            ddlChkList.options[ddlChkList.selectedIndex].text = "";

        var hidList = document.getElementById($('[id$=hidList]').attr('id'));
        //hidList.value = ddlChkList.options[ddlChkList.selectedIndex].text;
        hidList.value = selectedIDs;


    }

    document.onclick = check;
    function check(e) {
        var target = (e && e.target) || (event && event.srcElement);
        var obj = document.getElementById($('[id$=divChkList]').attr('id'));
        var obj1 = document.getElementById($('[id$=ddlChkList]').attr('id'));
        if (target.id != "alst" && !target.id.match($('[id$=chkLstItem]').attr('id'))) {
            if (!(target == obj || target == obj1)) {
                //obj.style.display = 'none'
            }
            else if (target == obj || target == obj1) {
                if (obj.style.display == 'block') {
                    obj.style.display = 'block';
                }
                else {
                    obj.style.display = 'none';
                    document.getElementById($('[id$=ddlChkList]').attr('id')).blur();
                }
            }
        }
    }
</script>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100px; width: 100px; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 12px; left: 40%; top: 40%;"><img alt="Loading..." src="../edit/images/loader.gif" /><br />
                        <i>This operation might take several minutes to complete. Please do not close your browser.</i>
                        </span>
                </div>
                
            </ProgressTemplate>
        </asp:UpdateProgress>
        <asp:Panel ID="pnlEditPublications" runat="server">
            <table id="tblEditPublications" width="100%">
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
                        <asp:PlaceHolder ID="phSyncMemberPubs" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:LinkButton ID="btnSyncMemberPubs" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgSyncMemberPubs" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Automatically Add Member Publications</asp:LinkButton>
                                &nbsp;<asp:Literal ID="litSyncMemberPubs" runat="server">(On / Off)</asp:Literal>
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddMemberPubs" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:LinkButton ID="btnAddMemberPub" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddMemberPub" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Manually Add Member Publications</asp:LinkButton>
                                &nbsp;(Manually add one or more articles authored by members of this group.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddPubMed" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:LinkButton ID="btnAddPubMed" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddPubMed" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Manually Add PubMed Articles</asp:LinkButton>
                                &nbsp;(Search PubMed and add multiple articles.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddPub" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:LinkButton ID="btnAddPub" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddPub" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Manually Add Publications by ID</asp:LinkButton>
                                &nbsp;(Add one or more articles using codes, e.g., PubMed ID.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddCustom" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:LinkButton ID="btnAddCustom" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgAddCustom" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Manually Add Custom Publications</asp:LinkButton>
                                &nbsp;(Enter publication details using an online form.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phDeletePub" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:Image CssClass="EditMenuLinkImg" runat="server" ID="btnImgDeletePub2" AlternateText=" " ImageUrl="~/Edit/Images/Icon_square_ArrowGray.png" Visible="false" />
                                <asp:LinkButton ID="btnDeletePub" runat="server" OnClick="menuBtn_OnClick" CssClass="profileHypLinks"><asp:Image runat="server" ID="btnImgDeletePub" AlternateText=" " ImageUrl="~/Framework/Images/icon_squareArrow.gif"/>&nbsp;Delete</asp:LinkButton>
                                <asp:Literal runat="server" ID="btnDeleteGray" Visible="false" Text="Delete"></asp:Literal>
                                &nbsp;(Remove manually added publications from this profile.)
                            </div>
                        </asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%--Start Sync Member Publications--%>
                        <asp:Panel ID="pnlSyncMemberPubs" runat="server" Style="margin-bottom: 15px;" Visible="false">
                            <asp:GridView  CellSpacing="-1" runat="server" ID="grdSyncMemberPubs" AutoGenerateColumns="false"
                                OnRowDataBound="grdSyncMemberPubs_OnDataBound" Width="100%">
                                <HeaderStyle BorderStyle="None" CssClass="EditMenuTopRow" />
                                <RowStyle BorderColor="#ccc" Width="1px" VerticalAlign="Middle" />
                                <AlternatingRowStyle CssClass="evenRow" />
                                <Columns>
                                    <asp:TemplateField HeaderStyle-HorizontalAlign="Center"  ItemStyle-HorizontalAlign="Center" HeaderText="Select"  ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <asp:RadioButton runat="server" ID="rdoGroupPublicationOption" GroupName="GroupPublicationOption" AutoPostBack="true" OnCheckedChanged="rdoGroupPublicationOption_OnCheckedChanged" />
                                            <asp:Literal runat="server" ID="litGroupPublicationOption"></asp:Literal>
                                            <asp:HiddenField runat="server" ID="hdnGroupPublicationOption" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField HeaderStyle-HorizontalAlign="Center"  ItemStyle-HorizontalAlign="left" DataField="Description" HeaderText="Description" ItemStyle-Width="500px" />
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                        <%--Start Add By Id--%>
                        <asp:Panel ID="pnlAddPubById" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                            border: solid 1px #999;" Visible="false">
                            <table border="0" cellspacing="2" cellpadding="4" width="100%">
                                <tr>
                                    <td>
                                        <div style="float: left; padding-right: 10px; padding-top: 3px;">
                                            <b>Enter one or more</b></div>
                                        <asp:DropDownList ID="drpPubIdType" runat="server" DataSourceID="PublicationTypeDS"
                                            DataTextField="name" DataValueField="pubidtype_id" title="publication identifier type">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPubId" runat="server" TextMode="MultiLine" Rows="4" Columns="50" title="publication identifiers"></asp:TextBox><br />
                                        (Separated by comma or semicolon, or one ID per line)
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="padding: 10px 0px;">
                                            <asp:ImageButton ID="lnkUpdate" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                                CausesValidation="False" Text="Save" AlternateText="Save" OnClick="btnSavePub_OnClick"></asp:ImageButton>
                                            &nbsp;
                                            <asp:ImageButton ID="lnkCancel" runat="server" OnClick="reset" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                CausesValidation="False" Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <asp:SqlDataSource ID="PublicationTypeDS" runat="server" ConnectionString="<%$ ConnectionStrings:ProfilesDB %>"
                                SelectCommand="SELECT pubidtype_id,name FROM [Profile.Data].[Publication.Type]">
                            </asp:SqlDataSource>
                        </asp:Panel>
                        <%--End Add By Id--%>
                        <%--Start Add By Search--%>
                        <asp:Panel ID="pnlAddPubMed" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                            border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    <b>Search PubMed</b>
                                </div>
                                <div style="padding-top: 10px;">
                                    <asp:RadioButton ID="rdoPubMedKeyword" GroupName="PubMedSearch" runat="server" Checked="true" /><asp:Label ID="Label18" runat="server" AssociatedControlID="rdoPubMedKeyword">Enter
                                    author, affiliation or keyword in the field below.</asp:Label></div>
                                <div style="margin: 10px 0px 0px 25px;">
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <asp:Label ID="Label4" runat="server" AssociatedControlID="txtSearchAuthor"><b>Author(s)</b></asp:Label><br />
                                            (One per line)
                                        </div>
                                        <asp:TextBox ID="txtSearchAuthor" runat="server" TextMode="MultiLine" Rows="4" CssClass="textBoxBig"></asp:TextBox>
                                    </div>
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <asp:Label ID="Label5" runat="server" AssociatedControlID="txtSearchAffiliation"><b>Affiliation</b></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtSearchAffiliation" runat="server" CssClass="textBoxBig"></asp:TextBox>&nbsp;&nbsp;<span
                                            style="color: #999;">Optional</span>
                                    </div>
                                    <div>
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <asp:Label ID="Label6" runat="server" AssociatedControlID="txtSearchKeyword"><b>Keyword</b></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="textBoxBig"></asp:TextBox>&nbsp;&nbsp;<span
                                            style="color: #999;">Optional</span>
                                    </div>
                                </div>
                                <div style="padding-top: 10px;">
                                    <asp:RadioButton ID="rdoPubMedQuery" GroupName="PubMedSearch" runat="server" /><asp:Label ID="Label7" runat="server" AssociatedControlID="rdoPubMedQuery">Or
                                    you can also search by an arbitrary PubMed query in the field below.</asp:Label>
                                </div>
                                <div style="margin: 10px 0px 0px 25px;">
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <asp:Label ID="Label17" runat="server" AssociatedControlID="txtPubMedQuery"><b>Query</b></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtPubMedQuery" runat="server" Style="width: 400px;"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="padding-top: 10px;">
                                    <asp:CheckBox ID="chkPubMedExclude" runat="server" Checked="true" Text="Exclude articles already added to my profile." />
                                </div>
                                <div style="padding: 10px 0px;">
                                    <asp:LinkButton ID="btnPubMedSearch" runat="server" CausesValidation="False" OnClick="btnPubMedSearch_OnClick"
                                        Text="Search"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnPubMedReset" runat="server" CausesValidation="False" OnClick="menuBtn_OnClick"
                                        Text="Reset"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnPubMedClose" runat="server" CausesValidation="False" OnClick="reset"
                                        Text="Close"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Add By Search--%>
                        <%--Start Group Member Filters--%>
                        <asp:Panel ID="pnlGroupMemberFilters" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    <div style="padding-bottom: 5px;">
                                        <b>Filter Member Publications</b>
                                    </div>
                                </div>
                                <div style="padding-bottom: 10px;">
                                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                        <asp:Label ID="lblGroupMemberFiltersDate" runat="server" AssociatedControlID="txtGroupMemberFiltersStartDate"><b>Date:</b></asp:Label>
                                    </div>
                                    <asp:TextBox ID="txtGroupMemberFiltersStartDate" runat="server" CssClass="textBoxDate" MaxLength="10"></asp:TextBox>
                                    <asp:ImageButton ID="btnGroupMemberFiltersStartCalendar" runat="server" width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                                    <asp:CalendarExtender ID="calExtGroupMemberFiltersStart" runat="server" TargetControlID="txtGroupMemberFiltersStartDate"
                                        PopupButtonID="btnGroupMemberFiltersStartCalendar">
                                    </asp:CalendarExtender>
                                    &nbsp;&nbsp;<sup>-</sup>&nbsp;&nbsp;
                                    <asp:TextBox ID="txtGroupMemberFiltersEndDate" runat="server" CssClass="textBoxDate"></asp:TextBox>
                                    <asp:ImageButton ID="btnGroupMemberFiltersEndCalendar" runat="server" width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                                    <asp:CalendarExtender ID="calExtGroupMemberFiltersEnd" runat="server" TargetControlID="txtGroupMemberFiltersEndDate"
                                        PopupButtonID="btnGroupMemberFiltersEndCalendar">
                                    </asp:CalendarExtender>
                                </div>
                                <div style="padding-bottom: 10px;">
                                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                        <asp:Label ID="Label21" runat="server" AssociatedControlID="txtGroupMemberFiltersStartDate"><b>Author:</b></asp:Label>
                                    </div>
                                    <table cellpadding="0">
                                        <tr>
                                            <td>
                                                <asp:PlaceHolder ID="phDDLCHK" runat="server"></asp:PlaceHolder>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:PlaceHolder ID="phDDLList" runat="server"></asp:PlaceHolder>
                                            </td>
                                        </tr>
                                    </table>
                                    <asp:Label ID="lblSelectedItem" runat="server"></asp:Label>
                                    <asp:HiddenField ID="hidList" runat="server" />
                                    <asp:HiddenField ID="hidURIs" runat="server" />
                                    <asp:Literal runat="server" ID="litGroupMemberScript"></asp:Literal>
                                </div>
                                <div style="padding: 10px 0px;">
                                    <asp:LinkButton ID="btnGroupMemberFiltersApply" runat="server" CausesValidation="False" OnClick="menuBtn_OnClick"
                                        Text="Apply"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnGroupMemberFiltersReset" runat="server" CausesValidation="False" OnClick="menuBtn_OnClick"
                                        Text="Reset"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnGroupMemberFiltersClose" runat="server" CausesValidation="False" OnClick="reset"
                                        Text="Close"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Group Member Filters--%>
                        <%--Start Search Results--%>
                        <asp:Panel ID="pnlAddPubMedResults" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    <div style="width: 25px; float: left;">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Framework/Images/icon_alert.gif" alt=" "/>
                                    </div>
                                    <div style="margin-left: 25px;">
                                        Check the articles that are yours in the list below, and then click the Add Selected
                                        link at the bottom of the page.
                                    </div>
                                </div>
                                <div style="padding: 10px 0px 5px 0px;">
                                    <asp:Label ID="lblPubMedResultsHeader" runat="server" Text="" Style="font-weight: bold;"></asp:Label>
                                </div>
                                <asp:Panel runat="server" ID="pnlAddAll">
                                    <div style="padding: 10px 0px 5px 5px; background-color: #E2E6E8;">
                                        <b>Select:</b>&nbsp;&nbsp; <a tabindex="0" style="cursor: pointer" id="btnCheckAll" onclick="javascript:checkall();">All</a> &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <a tabindex="0" style="cursor: pointer" id="btnUncheckAll" onclick="javascript:uncheckall();">None</a>
                                    </div>
                                </asp:Panel>
                                <div>
                                    <asp:GridView EnableViewState="true" ID="grdPubMedSearchResults" runat="server" GridLines="None"
                                        EmptyDataText="No PubMed Publications Found." DataKeyNames="pmid, mpid" AutoGenerateColumns="false"
                                        AllowPaging="false" PageSize="10" OnRowDataBound="grdPubMedSearchResults_RowDataBound"
                                        OnPageIndexChanging="grdPubMedSearchResults_PageIndexChanging" CellPadding="4">
                                        <PagerSettings Position="TopAndBottom" LastPageText="&gt;&gt;" FirstPageText="&lt;&lt;"
                                            Mode="NumericFirstLast" />
                                        <Columns>
                                            <asp:TemplateField ItemStyle-VerticalAlign="Top">
                                                <ItemTemplate>
                                                    <asp:CheckBox ID="chkPubMed" runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <asp:Label ID="lblCitation" Text='<%#Eval("citation") %>' runat="server" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div class="actionbuttons" style="background-color: #E2E6E8;">
                                    <table style="padding:2px;">
                                        <tr>
                                            <td>
                                                <asp:ImageButton ID="lnkUpdatePubMed" OnClick="btnPubMedAddSelected_OnClick" runat="server"
                                                    ImageUrl="~/Edit/Images/button_save.gif" CausesValidation="False" CommandName="Update"
                                                    Text="Add Selected" AlternateText="Add Selected"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="lnkCancelPubMed" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="reset"
                                                    Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Search Results--%>
                        <%--Start Custom Publication--%>
                        <asp:Panel ID="pnlAddCustomPubMed" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    <asp:Label ID="Label3" runat="server" AssociatedControlID="drpPublicationType"><b>Select the type of publication you would like to add</b>&nbsp;&nbsp;</asp:Label>
                                    <asp:DropDownList ID="drpPublicationType" runat="server" AutoPostBack="true" EnableViewState="true"
                                        OnSelectedIndexChanged="drpPublicationType_SelectedIndexChanged">
                                        <asp:ListItem Value="" Text="--Select--"></asp:ListItem>
                                        <asp:ListItem>Abstracts</asp:ListItem>
                                        <asp:ListItem>Books/Monographs/Textbooks</asp:ListItem>
                                        <asp:ListItem>Clinical Communications</asp:ListItem>
                                        <asp:ListItem>Educational Materials</asp:ListItem>
                                        <asp:ListItem>Non-Print Materials</asp:ListItem>
                                        <asp:ListItem>Original Articles</asp:ListItem>
                                        <asp:ListItem>Patents</asp:ListItem>
                                        <asp:ListItem>Proceedings of Meetings</asp:ListItem>
                                        <asp:ListItem>Reviews/Chapters/Editorials</asp:ListItem>
                                        <asp:ListItem>Thesis</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div style="padding: 5px 0px 0px 0px;">
                                    (Check if your publication is in
                                    <asp:LinkButton ID="btnPubMedById" runat="server" CssClass="profileHypLinks" OnClick="btnPubMedById_Click">PubMed</asp:LinkButton>
                                    before manually entering it.)
                                </div>
                                <div style="padding: 15px 0px 5px 0px;">
                                    <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                        OnClick="reset" CausesValidation="False" Text="Cancel" AlternateText="Cancel"></asp:ImageButton>
                                </div>
                                <asp:PlaceHolder Visible="false" ID="phMain" runat="server">
                                    <hr />
                                    <div style="padding-top: 5px;">
                                        <asp:Label ID="Label2" runat="server" AssociatedControlID="txtPubMedAuthors"><b>Author(s)</b></asp:Label> Enter the name of all the authors as they appear in the publication.<br />
                                        <asp:TextBox ID="txtPubMedAuthors" runat="server" Rows="4" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                    <div class="pubHeader">
                                        <asp:Label ID="lblTitle" runat="server" Text="" AssociatedControlID="txtPubMedTitle"></asp:Label>
                                    </div>
                                    <asp:TextBox ID="txtPubMedTitle" runat="server" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    <asp:PlaceHolder Visible="false" ID="phTitle2" runat="server">
                                        <div class="pubHeader">
                                            <asp:Label ID="lblTitle2" runat="server" Text="" AssociatedControlID="txtPubMedTitle2"></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtPubMedTitle2" runat="server" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phEdition" runat="server">
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label8" runat="server" Text="Edition" CssClass="pubSubHeader" AssociatedControlID="txtPubMedEdition"></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtPubMedEdition" runat="server"></asp:TextBox>
                                    </asp:PlaceHolder>
                                    <div class="pubHeader">
                                        Publication Information
                                    </div>
                                    <div class="pubSubSpacer">
                                        <div style="float: left; padding-right: 20px;">
                                            <asp:Label ID="Label9" runat="server" Text="Date (MM/DD/YYYY)" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublicationDate"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedPublicationDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
                                            <asp:ImageButton ID="btnCalendar" runat="server" width="15px"  ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtPubMedPublicationDate"
                                                PopupButtonID="btnCalendar">
                                            </asp:CalendarExtender>
                                        </div>
                                        <asp:PlaceHolder Visible="false" ID="phPubIssue" runat="server">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label10" runat="server" Text="Issue" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublicationIssue"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublicationIssue" runat="server" MaxLength="10" CssClass="textBoxSmall"></asp:TextBox>
                                            </div>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder Visible="false" ID="phPubVolume" runat="server">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label11" runat="server" Text="Volume" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublicationVolume"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublicationVolume" runat="server" MaxLength="10" CssClass="textBoxSmall"></asp:TextBox>
                                            </div>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder Visible="false" ID="phPubPageNumbers" runat="server">
                                            <div>
                                                <asp:Label ID="Label12" runat="server" Text="Page Numbers" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublicationPages"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublicationPages" runat="server"></asp:TextBox>
                                            </div>
                                        </asp:PlaceHolder>
                                    </div>
                                    <div style="clear: left;">
                                    </div>
                                    <asp:PlaceHolder Visible="false" ID="phNewsSection" runat="server">
                                        <div style="clear: left; padding: 20px 0px 5px 0px;">
                                            If the item was published in a newspaper, enter the following information.
                                        </div>
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label13" runat="server" Text="Section" CssClass="pubSubHeader" AssociatedControlID="txtPubMedNewsSection"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsSection" runat="server"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label14" runat="server" Text="Column" CssClass="pubSubHeader" AssociatedControlID="txtPubMedNewsColumn"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsColumn" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phNewsUniversity" runat="server">
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label15" runat="server" Text="University" CssClass="pubSubHeader" AssociatedControlID="txtPubMedNewsUniversity"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsUniversity" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label16" runat="server" Text="City" CssClass="pubSubHeader" AssociatedControlID="txtPubMedNewsCity"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsCity" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phPublisherInfo" runat="server">
                                        <div class="pubHeader">
                                            Publisher Information
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phPublisherName" runat="server">
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label19" runat="server" Text="Name" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublisherName"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherName" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label20" runat="server" Text="City" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublisherCity"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherCity" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phPublisherNumbers" runat="server">
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="lblPubMedPublisherReport" runat="server" Text="Report Number" CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublisherReport"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherReport" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="lblPubMedPublisherContract" runat="server" Text="Contract Number"
                                                    CssClass="pubSubHeader" AssociatedControlID="txtPubMedPublisherContract"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherContract" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phConferenceInfo" runat="server">
                                        <div class="pubHeader">
                                            Conference Information
                                        </div>
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label23" runat="server" Text="Conference Edition(s)" CssClass="pubSubHeader" AssociatedControlID="txtPubMedConferenceEdition"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedConferenceEdition" runat="server" TextMode="MultiLine"
                                                Rows="4" Width="550px"></asp:TextBox>
                                        </div>
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label24" runat="server" Text="Conference Name" CssClass="pubSubHeader" AssociatedControlID="txtPubMedConferenceName"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedConferenceName" runat="server" TextMode="MultiLine" Rows="4"
                                                Width="550px"></asp:TextBox>
                                        </div>
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label25" runat="server" Text="Conference Dates" CssClass="pubSubHeader" AssociatedControlID="txtPubMedConferenceDate"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedConferenceDate" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label26" runat="server" Text="Location" CssClass="pubSubHeader" AssociatedControlID="txtPubMedConferenceLocation"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedConferenceLocation" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phAdditionalInfo" runat="server">
                                        <div class="pubHeader">
                                            Additional Information
                                        </div>
                                        <asp:TextBox ID="txtPubMedAdditionalInfo" runat="server" Rows="4" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phAdditionalInfo2" runat="server">
                                        <div style="color: #666666; padding-top: 5px;">
                                            <asp:Label ID="lblAdditionalInfo" runat="server" Text="Label"></asp:Label>
                                        </div>
                                    </asp:PlaceHolder>
                                    <div style="padding-top: 20px;">
                                        <asp:Label runat="server" AssociatedControlID="txtPubMedAbstract"><b>Abstract</b> (Optional)<br /></asp:Label>
                                        <asp:TextBox ID="txtPubMedAbstract" runat="server" TextMode="MultiLine" Rows="4"
                                            Width="550px"></asp:TextBox>
                                    </div>
                                    <div style="padding-top: 20px;">
                                        <asp:Label ID="Label1" runat="server" AssociatedControlID="txtPubMedOptionalWebsite"><b>Website URL</b> (Optional)</asp:Label> Clicking the citation title will take the user to
                                        this website.<br />
                                        <asp:TextBox ID="txtPubMedOptionalWebsite" runat="server" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                    <div style="padding: 10px 0px;">
                                        <asp:LinkButton ID="btnPubMedSaveCustomAdd" runat="server" CausesValidation="False"
                                            OnClick="btnPubMedSaveCustom_OnClick" Text="Save and add another"></asp:LinkButton>
                                        &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnPubMedSaveCustom" runat="server" CausesValidation="False"
                                            OnClick="btnPubMedSaveCustom_OnClick" Text="Save and close"></asp:LinkButton>
                                        &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <asp:LinkButton ID="lnkCancelCustom" runat="server" OnClick="reset"
                                            CausesValidation="False" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                                    </div>
                                </asp:PlaceHolder>
                            </div>
                        </asp:Panel>
                        <%--End Custom Publication--%>
                        <%--Start Delete Publications--%>
                        <asp:Panel ID="pnlDeletePubMed" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    To delete a single publication, click the X to the right of the citation. To delete
                                    multiple publications, select one of the options below. Note that you cannot undo
                                    this!
                                </div>
                                <div style="padding: 10px 0px;">
                                    <asp:LinkButton ID="btnDeletePubMedOnly" runat="server" CausesValidation="False"
                                        OnClick="btnDeletePubMedOnly_OnClick" Text="Delete only PubMed citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete the PubMed citations?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteCustomOnly" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteCustomOnly_OnClick" Text="Delete only custom citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete the Custom citations?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                                        Text="Delete all citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete all citations?');"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeletePubMedClose" runat="server" CausesValidation="False"
                                        OnClick="reset" Text="Close"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Delete Publications--%>
                        <div style="padding-bottom: 5px;">
                        <asp:Literal runat="server">
                            <b>Publications Manually Added to this Group</b>&nbsp;(Automatic publications are not listed here.)<br />

                        </asp:Literal>
                            </div>
                        <%--Start Publications List--%>
                        <div style="padding-left: 0px;">
                            <asp:GridView BorderStyle="Solid" ID="grdEditPublications" runat="server" AutoGenerateColumns="False"
                                GridLines="none" CellSpacing="-1" HorizontalAlign="Left" 
                                CellPadding="4" DataSourceID="PublicationDS" Width="100%" DataKeyNames="PubID"
                                OnRowDataBound="grdEditPublications_RowDataBound" OnSelectedIndexChanged="grdEditPublications_SelectedIndexChanged"
                                PageSize="15">
                                <HeaderStyle HorizontalAlign="Left" CssClass="topRow" BorderStyle="Solid" BorderWidth="1px" />
                                <RowStyle CssClass="edittable" />
                                <Columns>
                                    <asp:TemplateField ItemStyle-VerticalAlign="Top" ShowHeader="false" ItemStyle-HorizontalAlign="Right">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCounter" runat="server" Text=''></asp:Label>
                                            <asp:HiddenField ID="hdnFromPubMed" runat="server" Value='<%# Bind("FromPubMed") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle/>
                                        <ItemStyle HorizontalAlign="Right" />
                                    </asp:TemplateField>
                                    <asp:BoundField ItemStyle-VerticalAlign="Top" DataField="Reference" ReadOnly="true" SortExpression="Reference" />
                                    <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <div class="actionbuttons">
                                                <table>
                                                    <tr align="right">
                                                        <td>
                                                            <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                                                CausesValidation="False" CommandName="Select" Text="Edit" AlternateText="edit" Visible="false"></asp:ImageButton>
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif" 
                                                                CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete" Text="X" AlternateText="delete"
                                                                OnClientClick="Javascript:return confirm('Are you sure you want to delete this citation?');">
                                                            </asp:ImageButton>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            <asp:HiddenField ID="hdnMPID" runat="server" Value='<%# Bind("mpid") %>' />
                                            <asp:HiddenField ID="hdnPMID" runat="server" Value='<%# Bind("pmid") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <SelectedRowStyle BackColor="#F0F4F6" />
                                <FooterStyle VerticalAlign="Middle"></FooterStyle>
                            </asp:GridView>
                        </div>
                        <asp:SqlDataSource ID="PublicationDS" runat="server" ConnectionString="<%$ ConnectionStrings:ProfilesDB %>"
                            SelectCommand="[Edit.Module].[CustomEditAssociatedInformationResource.GetList]" SelectCommandType="StoredProcedure"
                            ProviderName="System.Data.SqlClient"  OnSelected="PubsDataSource_Selecting" >
                            <SelectParameters>
                                <asp:SessionParameter Name="NodeID" Type="String" SessionField="NodeID" />
                                <asp:SessionParameter Name="SessionID" Type="String" SessionField="SessionID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:Label runat="server" Visible="false" ID="lblNoItems"></asp:Label>
                        <%--End Publications List--%>
                        
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </ContentTemplate>
    <Triggers>
    </Triggers>
</asp:UpdatePanel>
