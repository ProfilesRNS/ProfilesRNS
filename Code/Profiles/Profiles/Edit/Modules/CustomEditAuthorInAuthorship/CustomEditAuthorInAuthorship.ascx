<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditAuthorInAuthorship.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditAuthorInAuthorship.CustomEditAuthorInAuthorship" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>

<script type="text/javascript">
    var checkBoxSelector = '#<%=grdPubMedSearchResults.ClientID%> input[id*="chkPubMed"]:checkbox';

    $(document).ready(function() {
        $('#btnCheckAll').live('click', function() {
            $(checkBoxSelector).attr('checked', true);
        });

        $('#btnUncheckAll').live('click', function() {
            $(checkBoxSelector).attr('checked', false);
        });
    });


    
</script>

<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server">
            <ProgressTemplate>
                <div style="position: fixed; text-align: center; height: 100%; width: 100%; top: 0;
                    right: 0; left: 0; z-index: 9999999; opacity: 0.7;">
                    <span style="border-width: 0px; position: fixed; padding: 50px; background-color: #FFFFFF;
                        font-size: 25px; left: 40%; top: 40%;">Loading ...</span>
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
                        <asp:PlaceHolder ID="phAddPubMed" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgAddPubMed" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnAddPubMed_OnClick" />&nbsp;
                                <asp:LinkButton ID="btnAddPubMed" runat="server" OnClick="btnAddPubMed_OnClick" CssClass="profileHypLinks">Add PubMed</asp:LinkButton>
                                &nbsp;(Search PubMed and add multiple articles.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddPub" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgAddPub" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnAddPub_OnClick" />&nbsp;
                                <asp:LinkButton ID="btnAddPub" runat="server" OnClick="btnAddPub_OnClick" CssClass="profileHypLinks">Add by ID</asp:LinkButton>
                                &nbsp;(Add one or more articles using codes, e.g., PubMed ID.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phAddCustom" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgAddCustom" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnAddCustom_OnClick" />&nbsp;
                                <asp:LinkButton ID="btnAddCustom" runat="server" OnClick="btnAddCustom_OnClick" CssClass="profileHypLinks">Add Custom</asp:LinkButton>
                                &nbsp;(Enter your own publication using an online form.)
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phDeletePub" runat="server">
                            <div style="padding-bottom: 10px;">
                                <asp:ImageButton ID="btnImgDeletePub" runat="server" ImageUrl="~/Framework/Images/icon_squareArrow.gif"
                                    OnClick="btnDeletePub_OnClick" />&nbsp;
                                <asp:LinkButton ID="btnDeletePub" runat="server" OnClick="btnDeletePub_OnClick" CssClass="profileHypLinks">Delete</asp:LinkButton>
                                &nbsp;(Remove multiple publications from your profile)
                            </div>
                        </asp:PlaceHolder>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%--Start Add By Id--%>
                        <asp:Panel ID="pnlAddPubById" runat="server" Style="background-color: #F0F4F6; margin-bottom: 5px;
                            border: solid 1px #999;" Visible="false">
                            <table border="0" cellspacing="2" cellpadding="4" width="100%">
                                <tr>
                                    <td>
                                        <div style="float: left; padding-right: 10px; padding-top: 3px;">
                                            <b>Enter one or more</b></div>
                                        <asp:DropDownList ID="drpPubIdType" runat="server" DataSourceID="PublicationTypeDS"
                                            DataTextField="name" DataValueField="pubidtype_id">
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPubId" runat="server" TextMode="MultiLine" Rows="4" Columns="50"></asp:TextBox><br />
                                        (Separated by comma or semicolon, or one ID per line)
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <div style="padding: 10px 0px;">
                                            <asp:ImageButton ID="lnkUpdate" TabIndex="5" runat="server" ImageUrl="~/Edit/Images/button_save.gif"
                                                CausesValidation="False" Text="Save" OnClick="btnSavePub_OnClick"></asp:ImageButton>
                                            &nbsp;
                                            <asp:ImageButton ID="lnkCancel" runat="server" OnClick="btnDonePub_OnClick" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                CausesValidation="False" Text="Close"></asp:ImageButton>
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
                                    <asp:RadioButton ID="rdoPubMedKeyword" GroupName="PubMedSearch" runat="server" Checked="true" />Enter
                                    author, affiliation or keyword in the field below.</div>
                                <div style="margin: 10px 0px 0px 25px;">
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <b>Author(s)</b><br />
                                            (One per line)
                                        </div>
                                        <asp:TextBox ID="txtSearchAuthor" runat="server" TextMode="MultiLine" Rows="4" CssClass="textBoxBig"></asp:TextBox>
                                    </div>
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <b>Affiliation</b>
                                        </div>
                                        <asp:TextBox ID="txtSearchAffiliation" runat="server" CssClass="textBoxBig"></asp:TextBox>&nbsp;&nbsp;<span
                                            style="color: #999;">Optional</span>
                                    </div>
                                    <div>
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <b>Keyword</b>
                                        </div>
                                        <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="textBoxBig"></asp:TextBox>&nbsp;&nbsp;<span
                                            style="color: #999;">Optional</span>
                                    </div>
                                </div>
                                <div style="padding-top: 10px;">
                                    <asp:RadioButton ID="rdoPubMedQuery" GroupName="PubMedSearch" runat="server" />Or
                                    you can also search by an arbitrary PubMed query in the field below.
                                </div>
                                <div style="margin: 10px 0px 0px 25px;">
                                    <div style="padding-bottom: 10px;">
                                        <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                                            <b>Query</b>
                                        </div>
                                        <asp:TextBox ID="txtPubMedQuery" runat="server" Style="width: 400px;"></asp:TextBox>
                                    </div>
                                </div>
                                <div style="padding-top: 10px;">
                                    <asp:CheckBox ID="chkPubMedExclude" runat="server" Checked="true" Text="Exclude articles already added to my profile." />
                                </div>
                                <div style="padding: 10px 0px;">
                                    <asp:LinkButton ID="btnPubMedSearch" runat="server" CausesValidation="False" OnClick="btnPubMedSearch_OnClick"
                                        Text="Search" TabIndex="5"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnPubMedReset" runat="server" CausesValidation="False" OnClick="btnPubMedReset_OnClick"
                                        Text="Reset" TabIndex="6"></asp:LinkButton>
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnPubMedClose" runat="server" CausesValidation="False" OnClick="btnPubMedClose_OnClick"
                                        Text="Close" TabIndex="6"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Add By Search--%>
                        <%--Start Search Results--%>
                        <asp:Panel ID="pnlAddPubMedResults" runat="server" Style="background-color: #F0F4F6;
                            margin-bottom: 5px; border: solid 1px #999;" Visible="false">
                            <div style="padding: 5px;">
                                <div>
                                    <div style="width: 25px; float: left;">
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Framework/Images/icon_alert.gif" />
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
                                        <b>Select:</b>&nbsp;&nbsp; <a style="cursor: pointer" id="btnCheckAll">All</a> &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <a style="cursor: pointer" id="btnUncheckAll">None</a>
                                    </div>
                                </asp:Panel>
                                <div>
                                    <asp:GridView EnableViewState="true" ID="grdPubMedSearchResults" runat="server" GridLines="None"
                                        EmptyDataText="No PubMed Publications Found." DataKeyNames="pmid" AutoGenerateColumns="false"
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
                                                    Text="Add Selected"></asp:ImageButton>
                                            </td>
                                            <td>
                                                <asp:ImageButton ID="lnkCancelPubMed" runat="server" ImageUrl="~/Edit/Images/button_cancel.gif"
                                                    CausesValidation="False" CommandName="Cancel" OnClick="btnPubMedClose_OnClick"
                                                    Text="Cancel"></asp:ImageButton>
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
                                    <b>Select the type of publication you would like to add</b>&nbsp;&nbsp;
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
                                        OnClick="btnPubMedFinished_OnClick" CausesValidation="False" Text="Close"></asp:ImageButton>
                                </div>
                                <asp:PlaceHolder Visible="false" ID="phMain" runat="server">
                                    <hr />
                                    <div style="padding-top: 5px;">
                                        <b>Author(s)</b> Enter the name of all the authors as they appear in the publication.<br />
                                        <asp:TextBox ID="txtPubMedAuthors" runat="server" Rows="4" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </div>
                                    <div class="pubHeader">
                                        <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
                                    </div>
                                    <asp:TextBox ID="txtPubMedTitle" runat="server" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    <asp:PlaceHolder Visible="false" ID="phTitle2" runat="server">
                                        <div class="pubHeader">
                                            <asp:Label ID="lblTitle2" runat="server" Text=""></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtPubMedTitle2" runat="server" Width="550px" TextMode="MultiLine"></asp:TextBox>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phEdition" runat="server">
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label8" runat="server" Text="Edition" CssClass="pubSubHeader"></asp:Label>
                                        </div>
                                        <asp:TextBox ID="txtPubMedEdition" runat="server"></asp:TextBox>
                                    </asp:PlaceHolder>
                                    <div class="pubHeader">
                                        Publication Information
                                    </div>
                                    <div class="pubSubSpacer">
                                        <div style="float: left; padding-right: 20px;">
                                            <asp:Label ID="Label9" runat="server" Text="Date" CssClass="pubSubHeader"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedPublicationDate" runat="server" MaxLength="10" CssClass="textBoxDate"></asp:TextBox>
                                            <asp:ImageButton ID="btnCalendar" runat="server" ImageUrl="~/Edit/Images/cal.gif" />
                                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtPubMedPublicationDate"
                                                PopupButtonID="btnCalendar">
                                            </asp:CalendarExtender>
                                        </div>
                                        <asp:PlaceHolder Visible="false" ID="phPubIssue" runat="server">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label10" runat="server" Text="Issue" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublicationIssue" runat="server" MaxLength="10" CssClass="textBoxSmall"></asp:TextBox>
                                            </div>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder Visible="false" ID="phPubVolume" runat="server">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label11" runat="server" Text="Volume" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublicationVolume" runat="server" MaxLength="10" CssClass="textBoxSmall"></asp:TextBox>
                                            </div>
                                        </asp:PlaceHolder>
                                        <asp:PlaceHolder Visible="false" ID="phPubPageNumbers" runat="server">
                                            <div>
                                                <asp:Label ID="Label12" runat="server" Text="Page Numbers" CssClass="pubSubHeader"></asp:Label><br />
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
                                                <asp:Label ID="Label13" runat="server" Text="Section" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsSection" runat="server"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label14" runat="server" Text="Column" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsColumn" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phNewsUniversity" runat="server">
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label15" runat="server" Text="University" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedNewsUniversity" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label16" runat="server" Text="City" CssClass="pubSubHeader"></asp:Label><br />
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
                                                <asp:Label ID="Label19" runat="server" Text="Name" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherName" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label20" runat="server" Text="City" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherCity" runat="server"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phPublisherNumbers" runat="server">
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="lblPubMedPublisherReport" runat="server" Text="Report Number" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherReport" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="lblPubMedPublisherContract" runat="server" Text="Contract Number"
                                                    CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedPublisherContract" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                        </div>
                                    </asp:PlaceHolder>
                                    <asp:PlaceHolder Visible="false" ID="phConferenceInfo" runat="server">
                                        <div class="pubHeader">
                                            Conference Information
                                        </div>
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label23" runat="server" Text="Conference Edition(s)" CssClass="pubSubHeader"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedConferenceEdition" runat="server" TextMode="MultiLine"
                                                Rows="4" Width="550px"></asp:TextBox>
                                        </div>
                                        <div class="pubSubSpacer">
                                            <asp:Label ID="Label24" runat="server" Text="Conference Name" CssClass="pubSubHeader"></asp:Label><br />
                                            <asp:TextBox ID="txtPubMedConferenceName" runat="server" TextMode="MultiLine" Rows="4"
                                                Width="550px"></asp:TextBox>
                                        </div>
                                        <div class="pubSubSpacer">
                                            <div style="float: left; padding-right: 20px;">
                                                <asp:Label ID="Label25" runat="server" Text="Conference Dates" CssClass="pubSubHeader"></asp:Label><br />
                                                <asp:TextBox ID="txtPubMedConferenceDate" runat="server" CssClass="textBoxBig"></asp:TextBox>
                                            </div>
                                            <div>
                                                <asp:Label ID="Label26" runat="server" Text="Location" CssClass="pubSubHeader"></asp:Label><br />
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
                                        <b>Abstract</b> (Optional)<br />
                                        <asp:TextBox ID="txtPubMedAbstract" runat="server" TextMode="MultiLine" Rows="4"
                                            Width="550px"></asp:TextBox>
                                    </div>
                                    <div style="padding-top: 20px;">
                                        <b>Website URL</b> (Optional) Clicking the citation title will take the user to
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
                                        <asp:LinkButton ID="lnkCancelCustom" runat="server" OnClick="btnPubMedFinished_OnClick"
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
                                        OnClick="btnDeletePubMedClose_OnClick" Text="Close"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                        <%--End Delete Publications--%>
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
                                    <asp:BoundField DataField="Reference" ReadOnly="true" SortExpression="Reference" />
                                    <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100px">
                                        <ItemTemplate>
                                            <div class="actionbuttons">
                                                <table>
                                                    <tr align="right">
                                                        <td>
                                                            <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_edit.gif"
                                                                CausesValidation="False" CommandName="Select" Text="Edit" Visible="false"></asp:ImageButton>
                                                        </td>
                                                        <td>
                                                            <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                                                CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete" Text="X"
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
                            SelectCommand="[Edit.Module].[CustomEditAuthorInAuthorship.GetList]" SelectCommandType="StoredProcedure"
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
