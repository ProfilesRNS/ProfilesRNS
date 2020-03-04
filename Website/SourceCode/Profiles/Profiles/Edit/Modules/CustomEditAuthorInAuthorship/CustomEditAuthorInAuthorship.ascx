<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomEditAuthorInAuthorship.ascx.cs"
    Inherits="Profiles.Edit.Modules.CustomEditAuthorInAuthorship.CustomEditAuthorInAuthorship" EnableViewState="true" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagName="Options" TagPrefix="security" Src="~/Edit/Modules/SecurityOptions/SecurityOptions.ascx" %>
<asp:UpdatePanel ID="upnlEditSection" runat="server" UpdateMode="Conditional" RenderMode="Inline">
    <ContentTemplate>
        <asp:UpdateProgress ID="updateProgress" runat="server" DynamicLayout="true" DisplayAfter="1000">
            <ProgressTemplate>
                <div class="modalupdate">
                    <div class="modalcenter">
                        <img alt="Updating..." src="<%=Profiles.Framework.Utilities.Root.Domain%>/edit/images/loader.gif" /><br />
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
        <asp:Panel ID="phAddPubMed" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddPubMed_OnClick" runat="server" ID="btnImgAddPubMed" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnAddPubMed" runat="server" OnClick="btnAddPubMed_OnClick">Add PubMed</asp:LinkButton>
                (Search PubMed and add multiple articles.)
            </div>
        </asp:Panel>
        <asp:Panel ID="phAddPub" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddPub_OnClick" runat="server" ID="btnImgAddPub" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnAddPub" runat="server" OnClick="btnAddPub_OnClick">Add by ID</asp:LinkButton>
                (Add one or more articles using codes, e.g., PubMed ID.)
            </div>
        </asp:Panel>
        <asp:Panel ID="phAddCustom" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnAddCustom_OnClick" runat="server" ID="btnImgAddCustom" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" />
                <asp:LinkButton ID="btnAddCustom" runat="server" OnClick="btnAddCustom_OnClick">Add Custom Publication</asp:LinkButton>
                (Enter your own publication using an online form.)
            </div>
        </asp:Panel>
        <asp:Panel ID="phDisableDisambig" runat="server">
            <div class="EditMenuItem">
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnDisableDisambig_OnClick" runat="server" ID="btnImgDisableDisambig" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" Visible="true" />
                <asp:LinkButton ID="btnDisableDisambig" runat="server" OnClick="btnDisableDisambig_OnClick" Enabled="true">Configure Automatic Import</asp:LinkButton>
                (<asp:Label runat="server" ID="lblDisambigStatus" />)
            </div>
        </asp:Panel>
        <asp:Panel ID="phDeletePub" runat="server">
            <div class="EditMenuItem">
                <asp:Image CssClass="EditMenuLinkImg" runat="server" ID="btnImgDeletePub2" AlternateText=" " ImageUrl="~/Edit/Images/Icon_square_ArrowGray.png" Visible="true" />
                <asp:ImageButton CssClass="EditMenuLinkImg" OnClick="btnDeletePub_OnClick" runat="server" ID="btnImgDeletePub" AlternateText=" " ImageUrl="~/Edit/Images/icon_squareArrow.gif" Visible="false" />
                <asp:LinkButton ID="btnDeletePub" runat="server" OnClick="btnDeletePub_OnClick" Enabled="false">Delete Publication(s)</asp:LinkButton><asp:Literal runat="server" ID="btnDeleteGray" Visible="false" Text="Delete Publication(s)"></asp:Literal>
                (Remove multiple publications from your profile.)
            </div>
        </asp:Panel>
        <%--Start Add By Id--%>
        <asp:Panel ID="pnlAddPubById" runat="server" CssClass="EditPanel" Visible="false">
            <div style="display: inline-flex;">
                <div style="padding-left: 10px; margin-right: 5px;">
                    <b>Enter one or more</b>
                </div>
                <div>
                    <div style="margin-bottom: 5px;">
                        <asp:DropDownList ID="drpPubIdType" runat="server" DataSourceID="PublicationTypeDS"
                            DataTextField="name" DataValueField="pubidtype_id" Width="200px">
                        </asp:DropDownList>
                    </div>
                    <div>
                        <asp:TextBox ID="txtPubId" runat="server" TextMode="MultiLine" Rows="4" Columns="50" /><br />
                        <div>(Separated by comma or semicolon, or one ID per line)</div>
                    </div>
                </div>
            </div>
            <div style="margin-top: 5px; margin-left: 10px;">
                <asp:LinkButton ID="lnkUpdate" runat="server" CausesValidation="False" Text="Save" OnClick="btnSavePub_OnClick" />
                &nbsp;&nbsp;<b>|</b>&nbsp;&nbsp;
                                            <asp:LinkButton ID="lnkCancel" runat="server" OnClick="btnDonePub_OnClick"
                                                CausesValidation="False" Text="Cancel" />
            </div>
            <asp:SqlDataSource EnableCaching="true" CacheDuration="Infinite" CacheExpirationPolicy="Absolute" ID="PublicationTypeDS" runat="server" ConnectionString="<%$ ConnectionStrings:ProfilesDB %>"
                SelectCommand="SELECT pubidtype_id,name FROM [Profile.Data].[Publication.Type] with (nolock)"></asp:SqlDataSource>
        </asp:Panel>
        <%--End Add By Id--%>
        <%--Start Add By Search--%>
        <asp:Panel ID="pnlAddPubMed" runat="server" CssClass="EditPanel" Visible="false">
            <div>
                Search PubMed
            </div>
            <div class="pub-med-search-radio">
                <p>
                    <asp:RadioButton ID="rdoPubMedKeyword" GroupName="PubMedSearch" runat="server" Checked="true" />Enter author, affiliation or keyword in the field below.
                </p>
            </div>
            <div class="pub-med-search-radio-child" id="divPubMedKeyword">
                <div style="padding-bottom: 10px;">
                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                        <b>Author(s)</b><br />
                        (One per line) 
                    </div>
                    <asp:TextBox ID="txtSearchAuthor" runat="server" TextMode="MultiLine" Rows="4" CssClass="textBoxBig" />
                </div>
                <div style="padding-bottom: 10px;">
                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                        <b>Affiliation</b>
                    </div>
                    <asp:TextBox ID="txtSearchAffiliation" runat="server" CssClass="textBoxBig" /><span style="color: #999; padding-left: 5px;">Optional</span>
                </div>
                <div>
                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                        <b>Keyword</b>
                    </div>
                    <asp:TextBox ID="txtSearchKeyword" runat="server" CssClass="textBoxBig" /><span style="color: #999; padding-left: 5px;">Optional</span>
                </div>
            </div>
            <div class="pub-med-search-radio">
                <p>
                    <asp:RadioButton ID="rdoPubMedQuery" GroupName="PubMedSearch" runat="server" />Or you can also search by an arbitrary PubMed query in the field below.
                </p>
            </div>
            <div class="pub-med-search-radio-child" id="divPubMedQuery">
                <div style="padding-bottom: 10px;">
                    <div style="width: 75px; float: left; text-align: right; padding-right: 10px; padding-top: 3px;">
                        <b>Query</b>
                    </div>
                    <asp:TextBox ID="txtPubMedQuery" runat="server" Style="width: 400px;" />
                </div>
            </div>
            <div class="pub-med-search-checkbox">
                <p>
                    <asp:CheckBox ID="chkPubMedExclude" runat="server" Checked="true" />Exclude articles already added to my profile.
                </p>
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnPubMedSearch" runat="server" CausesValidation="False" OnClick="btnPubMedSearch_OnClick" Text="Search" />&nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="#" onclick="javascript:$('.pub-med-search-radio-child').find('input:text, textarea').val(''); return false;">Reset</a>&nbsp;&nbsp;|&nbsp;&nbsp;
                <asp:LinkButton ID="btnPubMedClose" runat="server" CausesValidation="False" OnClick="btnPubMedClose_OnClick" Text="Cancel" />
            </div>
        </asp:Panel>
        <%--End Add By Search--%>
        <%--Start Search Results--%>
        <asp:Panel ID="pnlAddPubMedResults" runat="server" CssClass="EditPanel" Visible="false">
            <img class="img-information-pubs" src="<%=ResolveUrl("~/edit/Images/icon_alert.gif") %>" alt=" " />
            Check the articles that are yours in the list below, and then click the Add Selected link at the bottom of the page.                        
            <div style="margin-top: 5px;">
                <asp:Label ID="lblPubMedResultsHeader" runat="server" Text="" Style="font-weight: bold;" />
            </div>
            <div class="actionbuttons">
                <b>Select:</b>&nbsp;&nbsp; <a tabindex="0" style="cursor: pointer" onclick="javascript:checkall(); return false;" id="btnCheckAll">All</a> &nbsp;&nbsp;|&nbsp;&nbsp;
                                        <a tabindex="0" style="cursor: pointer" id="btnUncheckAll" onclick="javascript:uncheckall(); return false;">None</a>
            </div>
            <asp:GridView EnableViewState="true" ID="grdPubMedSearchResults" runat="server" GridLines="None"
                EmptyDataText="No PubMed Publications Found." DataKeyNames="pmid" AutoGenerateColumns="false"
                OnRowDataBound="grdPubMedSearchResults_RowDataBound" ShowHeader="false" CssClass="pubmed-search-results">
                <RowStyle CssClass="pubitemcheck" />
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox CssClass="chk-pubmed" ID="chkPubMed" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField ItemStyle-CssClass="pubitem">
                        <ItemTemplate>
                            <asp:Label ID="lblCitation" Text='<%#Eval("citation") %>' runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <div class="actionbuttons">
                <asp:LinkButton ID="lnkUpdatePubMed" OnClick="btnPubMedAddSelected_OnClick" runat="server" CausesValidation="False" CommandName="Update" Text="Add Selected" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                <asp:LinkButton ID="lnkCancelPubMed" runat="server" CausesValidation="False" CommandName="Cancel" OnClick="btnPubMedClose_OnClick" Text="Cancel" />
            </div>
        </asp:Panel>
        <%--End Search Results--%>
        <%--Start Custom Publication--%>
        <asp:Panel ID="pnlAddCustomPubMed" runat="server" CssClass="EditPanel" Visible="false">
            <div>
                (Check if your publication is in
                <asp:LinkButton ID="btnPubMedById" runat="server" OnClick="btnPubMedById_Click">PubMed</asp:LinkButton>
                before manually entering it.)
            </div>
            <div style="margin-top: 5px;">
                <b>Select the type of publication you would like to add</b>&nbsp;&nbsp;
                    <asp:DropDownList ID="drpPublicationType" runat="server" AutoPostBack="true" EnableViewState="true"
                        OnSelectedIndexChanged="drpPublicationType_SelectedIndexChanged" CssClass="input-padding">
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

            <div class="actionbuttons">
                <asp:LinkButton ID="ImageButton1" runat="server"
                    OnClick="btnPubMedFinished_OnClick" CausesValidation="False" Text="Cancel" />
            </div>
            <asp:PlaceHolder Visible="false" ID="phMain" runat="server">
                <div style="padding-top: 8px; margin-top: 5px; border-top: 1px solid #999999;">
                    <b>Author(s)</b>
                    Enter the name of all the authors as they appear in the publication.<br />
                    <asp:TextBox ID="txtPubMedAuthors" runat="server" Rows="4" Width="550px" TextMode="MultiLine" />
                </div>
                <div class="pubHeader">
                    <asp:Label ID="lblTitle" runat="server" Text="" AssociatedControlID="txtPubMedTitle"></asp:Label>
                </div>
                <asp:TextBox ID="txtPubMedTitle" runat="server" Width="550px" TextMode="MultiLine" />
                <asp:PlaceHolder Visible="false" ID="phTitle2" runat="server">
                    <div class="pubHeader">
                        <asp:Label ID="lblTitle2" runat="server" Text="" AssociatedControlID="txtPubMedTitle2"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtPubMedTitle2" runat="server" Width="550px" TextMode="MultiLine" />
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phEdition" runat="server">
                    <div class="pubHeader">
                        Edition
                    </div>
                    <asp:TextBox ID="txtPubMedEdition" runat="server" />
                </asp:PlaceHolder>
                <div class="pubHeader">
                    Publication Information
                </div>
                <div style="display: inline-flex; margin-top: 10px;">
                    <div style="padding-right: 20px;">
                        <div>Date (MM/DD/YYYY)</div>
                        <asp:TextBox ID="txtPubMedPublicationDate" runat="server" MaxLength="10" CssClass="textBoxDate" />
                        <asp:ImageButton ID="btnCalendar" runat="server" Width="15px" ImageUrl="~/Edit/Images/cal.png" AlternateText="Calendar picker" />
                        <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtPubMedPublicationDate" PopupButtonID="btnCalendar" />
                    </div>
                    <asp:PlaceHolder Visible="false" ID="phPubIssue" runat="server">
                        <div style="padding-right: 20px;">
                            <div>Issue</div>
                            <asp:TextBox ID="txtPubMedPublicationIssue" runat="server" MaxLength="10" CssClass="textBoxSmall" />
                        </div>
                        <div style="padding-right: 20px;">
                            <div>Volume</div>
                            <asp:TextBox ID="txtPubMedPublicationVolume" runat="server" MaxLength="10" CssClass="textBoxSmall" />
                        </div>
                    </asp:PlaceHolder>
                    <asp:PlaceHolder Visible="false" ID="phPubPageNumbers" runat="server">
                        <div>
                            <div>Page Numbers</div>
                            <asp:TextBox ID="txtPubMedPublicationPages" runat="server" />
                        </div>
                    </asp:PlaceHolder>
                </div>
                <asp:PlaceHolder Visible="false" ID="phNewsSection" runat="server">
                    <div style="clear: left; padding: 20px 0px 5px 0px;">
                        If the item was published in a newspaper, enter the following information.
                    </div>
                    <div class="pubSubSpacer">
                        <div style="float: left; padding-right: 20px;">
                            <div>Section</div>
                            <asp:TextBox ID="txtPubMedNewsSection" runat="server" />
                        </div>
                        <div>
                            <div>Column</div>
                            <asp:TextBox ID="txtPubMedNewsColumn" runat="server" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phNewsUniversity" runat="server">
                    <div class="pubSubSpacer">
                        <div style="float: left; padding-right: 20px;">
                            <div>University</div>
                            <asp:TextBox ID="txtPubMedNewsUniversity" runat="server" CssClass="textBoxBig" />
                        </div>
                        <div>
                            <div>City</div>
                            <asp:TextBox ID="txtPubMedNewsCity" runat="server" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phPublisherName" runat="server">
                    <div class="pubHeader">
                        Publisher Information
                    </div>
                    <div class="pubSubSpacer">
                        <div style="float: left; padding-right: 20px;">
                            <div>Name</div>
                            <asp:TextBox ID="txtPubMedPublisherName" runat="server" CssClass="textBoxBig" />
                        </div>
                        <div>
                            <div>City</div>
                            <asp:TextBox ID="txtPubMedPublisherCity" runat="server" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phPublisherNumbers" runat="server">
                    <div class="pubSubSpacer">
                        <div style="float: left; padding-right: 20px;">
                            <div id="div-report-number">Report Number</div>
                            <asp:TextBox ID="txtPubMedPublisherReport" runat="server" CssClass="textBoxBig" />
                        </div>
                        <div>
                            <div id="div-contract-number">Contract Number</div>
                            <asp:TextBox ID="txtPubMedPublisherContract" runat="server" CssClass="textBoxBig" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phConferenceInfo" runat="server">
                    <div class="pubHeader">
                        Conference Information
                    </div>
                    <div class="pubSubSpacer">
                        <div>Conference Edition(s)</div>
                        <asp:TextBox ID="txtPubMedConferenceEdition" runat="server" TextMode="MultiLine" Rows="4" Width="550px" />
                    </div>
                    <div class="pubSubSpacer">
                        <div>Conference Name</div>
                        <asp:TextBox ID="txtPubMedConferenceName" runat="server" TextMode="MultiLine" Rows="4" Width="550px" />
                    </div>
                    <div class="pubSubSpacer">
                        <div style="float: left; padding-right: 20px;">
                            <div>Conference Dates</div>
                            <asp:TextBox ID="txtPubMedConferenceDate" runat="server" CssClass="textBoxBig" />
                        </div>
                        <div>
                            <div>Location</div>
                            <asp:TextBox ID="txtPubMedConferenceLocation" runat="server" CssClass="textBoxBig" />
                        </div>
                    </div>
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phAdditionalInfo" runat="server">
                    <div class="pubHeader">
                        Additional Information
                    </div>
                    <asp:TextBox ID="txtPubMedAdditionalInfo" runat="server" Rows="4" Width="550px" TextMode="MultiLine" />
                </asp:PlaceHolder>
                <asp:PlaceHolder Visible="false" ID="phAdditionalInfo2" runat="server">
                    <div style="color: #666666; padding-top: 5px;">
                        <asp:Label ID="lblAdditionalInfo" runat="server" Text=""></asp:Label>
                    </div>
                </asp:PlaceHolder>
                <div style="padding-top: 20px;">
                    <div>
                        <b>Abstract</b> (Optional)
                    </div>
                    <asp:TextBox ID="txtPubMedAbstract" runat="server" TextMode="MultiLine" Rows="4" Width="550px" />
                </div>
                <div style="padding-top: 20px;">
                    <div>
                        <b>Website URL</b> (Optional) Clicking the citation title will take the user to
                                        this website.
                    </div>
                    <asp:TextBox ID="txtPubMedOptionalWebsite" runat="server" Width="550px" TextMode="MultiLine" />
                </div>
                <div class="actionbuttons">
                    <asp:LinkButton ID="btnPubMedSaveCustom" runat="server" CausesValidation="False"
                        OnClick="btnPubMedSaveCustom_OnClick" Text="Save" />&nbsp;&nbsp;|&nbsp;&nbsp;
                                        <asp:LinkButton ID="btnPubMedSaveCustomAdd" runat="server" CausesValidation="False"
                                            OnClick="btnPubMedSaveCustom_OnClick" Text="Save and add another" />&nbsp;&nbsp;|&nbsp;&nbsp;
                                        <asp:LinkButton ID="lnkCancelCustom" runat="server" OnClick="btnPubMedFinished_OnClick"
                                            CausesValidation="False" CommandName="Cancel" Text="Cancel" />
                </div>
            </asp:PlaceHolder>

        </asp:Panel>
        <%--End Custom Publication--%>
        <%--Start Delete Publications--%>
        <asp:Panel ID="pnlDeletePubMed" runat="server" CssClass="EditPanel" Visible="false">
            To delete a single publication, click the icon to the right of the citation.  To delete multiple publications, select one of the options below.  Note that you cannot undo this.
            <div class="actionbuttons">
                <asp:LinkButton ID="btnDeletePubMedOnly" runat="server" CausesValidation="False"
                    OnClick="btnDeletePubMedOnly_OnClick" Text="Delete only PubMed citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete the PubMed citations?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteCustomOnly" runat="server" CausesValidation="False"
                                        OnClick="btnDeleteCustomOnly_OnClick" Text="Delete only custom citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete the custom citations?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeleteAll" runat="server" CausesValidation="False" OnClick="btnDeleteAll_OnClick"
                                        Text="Delete all citations" OnClientClick="Javascript:return confirm('Are you sure you want to delete all citations?');" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnDeletePubMedClose" runat="server" CausesValidation="False"
                                        OnClick="btnDeletePubMedClose_OnClick" Text="Cancel" />
            </div>
        </asp:Panel>
        <%--End Delete Publications--%>
        <%--Start Disable Publications disambiguation--%>
        <asp:Panel ID="pnlDisableDisambig" runat="server" CssClass="EditPanel" Visible="false">
            <div style="margin-top: 10px" class="disambig-radio-label">
                <asp:RadioButtonList ID="rblDisambiguationSettings" runat="server">
                    <asp:ListItem Text="" Value="enable">Automatically add publications to my profile.</asp:ListItem>
                    <asp:ListItem Text="" Value="disable">Do not automatically add publications to my profile.</asp:ListItem>
                </asp:RadioButtonList>
            </div>
            <div class="actionbuttons">
                <asp:LinkButton ID="btnSaveDisambig" runat="server" CausesValidation="False" OnClick="btnSaveDisambig_OnClick"
                    Text="Save" />
                &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <asp:LinkButton ID="btnCancelDisambig" runat="server" CausesValidation="False"
                                        OnClick="btnCancel_OnClick" Text="Cancel" />
            </div>
           
        </asp:Panel>
        <%--End Disable Publications--%>
        <%--Start Publications List--%>
        <div class="editPage">
            <asp:GridView ID="grdEditPublications" runat="server" AutoGenerateColumns="False"
                DataSourceID="PublicationDS" DataKeyNames="PubID"
                OnRowDataBound="grdEditPublications_RowDataBound" OnSelectedIndexChanged="grdEditPublications_SelectedIndexChanged">
                <HeaderStyle CssClass="topRow" />
                <RowStyle CssClass="oddRow" />
                <Columns>
                    <asp:TemplateField ItemStyle-CssClass="alignLeft" HeaderStyle-CssClass="alignLeft" HeaderText="Publications">
                        <ItemTemplate>
                            <div style="display: inline-flex">
                                <div style="padding-top: 2px; width: 20px; text-align: right;">
                                    <asp:Label ID="lblCounter" runat="server" Text=''></asp:Label>
                                </div>
                                <div style="width: 5px; float: left;">&nbsp;</div>
                                <div style="padding-top: 2px; width: 100%; text-align: left;">
                                    <asp:Label ID="lblRef" runat="server" Text='<%# Bind("Reference") %>'></asp:Label>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdnFromPubMed" runat="server" Value='<%# Bind("FromPubMed") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Action" ItemStyle-CssClass="alignCenterAction" HeaderStyle-CssClass="alignCenterAction">
                        <ItemTemplate>
                            <span>
                                <asp:ImageButton ID="lnkDelete" runat="server" ImageUrl="~/Edit/Images/icon_delete.gif"
                                    CausesValidation="False" OnClick="deleteOne_Onclick" CommandName="Delete" AlternateText="delete"
                                    OnClientClick="Javascript:return confirm('Are you sure you want to delete this citation?');"></asp:ImageButton></span>
                            <span>
                                <asp:ImageButton ID="lnkEdit" runat="server" ImageUrl="~/Edit/Images/icon_blank.gif"
                                    CausesValidation="False" CommandName="Select" AlternateText="edit" Enabled="false" Visible="false"></asp:ImageButton></span>
                            <asp:HiddenField ID="hdnMPID" runat="server" Value='<%# Bind("mpid") %>' />
                            <asp:HiddenField ID="hdnPMID" runat="server" Value='<%# Bind("pmid") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <asp:SqlDataSource ID="PublicationDS" runat="server" ConnectionString="<%$ ConnectionStrings:ProfilesDB %>"
            SelectCommand="[Edit.Module].[CustomEditAuthorInAuthorship.GetList]" SelectCommandType="StoredProcedure"
            ProviderName="System.Data.SqlClient" OnSelected="PubsDataSource_Selecting">
            <SelectParameters>
                <asp:SessionParameter Name="NodeID" Type="String" SessionField="NodeID" />
                <asp:SessionParameter Name="SessionID" Type="String" SessionField="SessionID" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:Literal runat="server" Visible="false" ID="lblNoItems"></asp:Literal>
        <%--End Publications List--%>
    </ContentTemplate>
</asp:UpdatePanel>
<script type="text/javascript">




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
    window.setInterval(function () {
        if ($("[id*='drpPublicationType'] option:selected").text() == "Patents") {
            $("#div-report-number").html("Sponsor/Assignee");
            $("#div-contract-number").html("Patent Number");
        } else {
            $("#div-report-number").html("Report Number");
            $("#div-contract-number").html("Contract Number");
        }
    }, 500);
    
</script>

