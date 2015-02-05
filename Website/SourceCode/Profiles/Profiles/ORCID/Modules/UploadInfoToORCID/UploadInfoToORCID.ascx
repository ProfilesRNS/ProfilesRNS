<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UploadInfoToORCID.ascx.cs"
    Inherits="Profiles.ORCID.Modules.UploadInfoToORCID.UploadInfoToORCID" %>

<div id="divResearchExpertiseAndProfessionalInterests" runat="server" style="padding-bottom: 5px">
    <table width="100%" class="PropertyGroupItem">
        <tr style="width: 100%">
            <td>
                <input type='hidden' id='imgontrOverview' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/minusSign.gif'
                    width='9' />
                <input type='hidden' id='imgofftrOverview' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif' />
                <div class='PropertyItemHeader' style='cursor: pointer;'>
                    <img alt="min" id="imgOverviewtrOverview" src="<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif"
                        onclick="javascript:toggleBlock('imgOverview','trOverview');" onkeypress="if (event.keyCode == 13) javascript:toggleBlock('imgOverview','trOverview');" tabIndex="0" />
                    Biography 
                </div>
            </td>
        </tr>
        <tr id='trOverview' class='PropertyGroupData' style="display: none">
            <td>
                <div style="padding: 5px">
                    <b>Note:</b> Your Profiles 'Overview' field has been copied here as a starting point.
                    You can change this text for ORCID and it will not affect Profiles. ORCID's maximum
                    number of characters allowed is 5000. By default this section will be public but
                    you have the option of excluding it from being sent. If you send this to ORCID,
                    it will overwrite what you currently have in your ORCID biography. For more information
                    on privacy settings <a href='ORCIDPrivacySettingsandProfiles.pdf' target='_blank'>click
                        here </a>(opens in new window).
                </div>
                <br />
                <table border="0" class="data">
                    <tr style="border-top: 1px">
                        <th>
                            <asp:Label ID="Label5" runat="server" AssociatedControlID="txtResearchExpertiseAndProfessionalInterests">Overview</asp:Label>Overview
                        </th>
                        <th>
                            <asp:DropDownList ID="ddlResearchExpertiseAndProfessionalInterestsVis" runat="server"
                                class="visibility" title="visibilty">
                                <asp:ListItem Value="1">Public</asp:ListItem>
                                <asp:ListItem Value="4">Exclude</asp:ListItem>
                            </asp:DropDownList>
                        </th>
                    </tr>
                    <tr>
                        <td>
                            <asp:TextBox ID="txtResearchExpertiseAndProfessionalInterests" runat="server" Height="195px"
                                CssClass="multiline" TextMode="MultiLine" Width="650px" onkeyup="textCounter(this, document.getElementById('remLen'), 5000);"
                                onkeydown="textCounter(this, document.getElementById('remLen'), 5000);" EnableViewState="true" />
                            <br />
                            <label id="remLen" class='counter'>
                            </label>
                            <asp:Label ID="lblResearchExpertiseAndProfessionalInterestsErrors" runat="server"
                                EnableViewState="false" CssClass="uierror" />
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
                <script type="text/javascript">
                    textCounter(document.getElementById('<%= txtResearchExpertiseAndProfessionalInterests.ClientID %>'), document.getElementById('remLen'), 5000);
                </script>
            </td>
        </tr>
    </table>
</div>
<div id="divAffiliations" runat="server" style="padding-bottom: 5px">
    <table width="100%" class="PropertyGroupItem">
        <tr>
            <td style="width: 100%">
                <input type='hidden' id='imgontrAffiliations' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/minusSign.gif'
                    width='9' />
                <input type='hidden' id='imgofftrAffiliations' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif' />
                <div class='PropertyItemHeader'>
                    <img alt="min" id="imgAffiliationstrAffiliations" src="<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif"
                        onclick="javascript:toggleBlock('imgAffiliations','trAffiliations');" onkeypress="if (event.keyCode == 13) javascript:toggleBlock('imgAffiliations','trAffiliations');" tabIndex="0"/>
                    ORCID Affiliations (Employment and Education)
                </div>
            </td>
        </tr>
        <tr id='trAffiliations' class='PropertyGroupData' style="display: none">
            <td>
                <div style="padding: 5px">
                    <span class="uierror">Note:</span>
                    <asp:Label ID="AffiliationsMessageWhenORCIDExists" runat="server" Text="The list below will not include any positions that you have already pushed via this site. " />.
                    Only positions that have a title, city, state, and country can be sent to ORCID.
                    For more information on privacy settings <a href='<%=RootDomain()%>/ORCID/ORCIDPrivacySettingsandProfiles.pdf'
                        target='_blank'>click here </a>(opens in new window).
                </div>
                <asp:Repeater runat="server" ID="rptPersonAffiliations">
                    <HeaderTemplate>
                        <table class="data">
                            <thead>
                                <tr class="header">
                                    <th>
                                        Type
                                    </th>
                                    <th>
                                        Description
                                    </th>
                                    <th>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="item">
                            <td>
                                <%# Eval("AffiliationTypeCapitalized")%>
                            </td>
                            <td>
                                <asp:Label ID="lblWebPageTitle" runat="server" Text='<%# Eval("DescriptionHTML")%>' />
                                <asp:Label ID="lblProfilesID" runat="server" Visible="false" Text='<%# Eval("ProfilesID")%>' />
                                <asp:Label ID="lblAffiliationTypeID" runat="server" Visible="false" Text='<%# Eval("AffiliationTypeID")%>' />
                                <asp:Label ID="lblDepartmentName" runat="server" Visible="false" Text='<%# Eval("DepartmentName")%>' />
                                <asp:Label ID="lblRoleTitle" runat="server" Visible="false" Text='<%# Eval("RoleTitle")%>' />
                                <asp:Label ID="lblStartDate" runat="server" Visible="false" Text='<%# Eval("StartDateDesc")%>' />
                                <asp:Label ID="lblEndDate" runat="server" Visible="false" Text='<%# Eval("EndDateDesc")%>' />
                                <asp:Label ID="lblOrganizationName" runat="server" Visible="false" Text='<%# Eval("OrganizationName")%>' />
                                <asp:Label ID="lblOrganizationCity" runat="server" Visible="false" Text='<%# Eval("OrganizationCity")%>' />
                                <asp:Label ID="lblOrganizationRegion" runat="server" Visible="false" Text='<%# Eval("OrganizationRegion")%>' />
                                <asp:Label ID="lblOrganizationCountry" runat="server" Visible="false" Text='<%# Eval("OrganizationCountry")%>' />
                                <asp:Label ID="lblDisambiguationID" runat="server" Visible="false" Text='<%# Eval("DisambiguationID")%>' />
                                <asp:Label ID="lblDisambiguationSource" runat="server" Visible="false" Text='<%# Eval("DisambiguationSource")%>' />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlEmpVis" runat="server" class="visibility" title="Privacy">
                                    <asp:ListItem Value="1">Public</asp:ListItem>
                                    <asp:ListItem Value="2">Limited</asp:ListItem>
                                    <asp:ListItem Value="3">Private</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="alt">
                            <td>
                                <%# Eval("AffiliationTypeCapitalized")%>
                            </td>
                            <td>
                                <asp:Label ID="lblWebPageTitle" runat="server" Text='<%# Eval("DescriptionHTML")%>' />
                                <asp:Label ID="lblProfilesID" runat="server" Visible="false" Text='<%# Eval("ProfilesID")%>' />
                                <asp:Label ID="lblAffiliationTypeID" runat="server" Visible="false" Text='<%# Eval("AffiliationTypeID")%>' />
                                <asp:Label ID="lblDepartmentName" runat="server" Visible="false" Text='<%# Eval("DepartmentName")%>' />
                                <asp:Label ID="lblRoleTitle" runat="server" Visible="false" Text='<%# Eval("RoleTitle")%>' />
                                <asp:Label ID="lblStartDate" runat="server" Visible="false" Text='<%# Eval("StartDateDesc")%>' />
                                <asp:Label ID="lblEndDate" runat="server" Visible="false" Text='<%# Eval("EndDateDesc")%>' />
                                <asp:Label ID="lblOrganizationName" runat="server" Visible="false" Text='<%# Eval("OrganizationName")%>' />
                                <asp:Label ID="lblOrganizationCity" runat="server" Visible="false" Text='<%# Eval("OrganizationCity")%>' />
                                <asp:Label ID="lblOrganizationRegion" runat="server" Visible="false" Text='<%# Eval("OrganizationRegion")%>' />
                                <asp:Label ID="lblOrganizationCountry" runat="server" Visible="false" Text='<%# Eval("OrganizationCountry")%>' />
                                <asp:Label ID="lblDisambiguationID" runat="server" Visible="false" Text='<%# Eval("DisambiguationID")%>' />
                                <asp:Label ID="lblDisambiguationSource" runat="server" Visible="false" Text='<%# Eval("DisambiguationSource")%>' />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlEmpVis" runat="server" class="visibility">
                                    <asp:ListItem Value="1">Public</asp:ListItem>
                                    <asp:ListItem Value="2">Limited</asp:ListItem>
                                    <asp:ListItem Value="3">Private</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </tbody> </table>
                    </FooterTemplate>
                </asp:Repeater>
            </td>
        </tr>
    </table>
</div>
<div id="divWebsites" runat="server" style="padding-bottom: 5px">
    <table width="100%" class="PropertyGroupItem">
        <tr>
            <td style="width: 100%">
                <input type='hidden' id='imgontrWebsites' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/minusSign.gif'
                    width='9' />
                <input type='hidden' id='imgofftrWebsites' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif' />
                <div class='PropertyItemHeader'>
                    <img alt="min" id="imgWebsitestrWebsites" src="<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif"
                        onclick="javascript:toggleBlock('imgWebsites','trWebsites');" onkeypress="if (event.keyCode == 13) javascript:toggleBlock('imgWebsites','trWebsites');" tabIndex="0"/>
                    Web Sites
                </div>
            </td>
        </tr>
        <tr id='trWebsites' class='PropertyGroupData' style="display: none">
            <td>
                <div style="padding: 5px">
                    <span class="uierror">Note:</span> ORCID allows a privacy setting for the URLs section
                    but not for individual websites. The default privacy for your URLs section will
                    be public unless you change it. For particular websites you have the option of including
                    or excluding them from being sent to ORCID. For more information on privacy settings
                    <a href='<%=RootDomain()%>/ORCID/ORCIDPrivacySettingsandProfiles.pdf' target='_blank'>click here </a>(opens
                    in new window).
                </div>
                <asp:Repeater runat="server" ID="rptPersonURLs">
                    <HeaderTemplate>
                        <table class="data">
                            <thead>
                                <tr class="header">
                                    <th>
                                        Name
                                    </th>
                                    <th>
                                        URL
                                    </th>
                                    <th>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="item">
                            <td>
                                <asp:Label ID="lblWebPageTitle" runat="server" Text='<%# Eval("URLName")%>' />
                            </td>
                            <td>
                                <asp:HyperLink ID="hlURL" NavigateUrl='<%# Eval("URL")%>' Text='<%# Eval("URL")%>'
                                    runat="server" Target="_blank" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlPushType" runat="server" class="visibility" title="Visibility">
                                    <asp:ListItem Value="5">Include</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="alt">
                            <td>
                                <asp:Label ID="lblWebPageTitle" runat="server" Text='<%# Eval("URLName")%>' />
                            </td>
                            <td>
                                <asp:HyperLink ID="hlURL" NavigateUrl='<%# Eval("URL")%>' Text='<%# Eval("URL")%>'
                                    runat="server" Target="_blank" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlPushType" runat="server" class="visibility" title="Visibility">
                                    <asp:ListItem Value="5">Include</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </tbody> </table>
                    </FooterTemplate>
                </asp:Repeater>
            </td>
        </tr>
    </table>
</div>
<div id="divPublications" runat="server" style="padding-bottom: 5px">
    <table width="100%" class="PropertyGroupItem">
        <tr>
            <td style="width: 100%">
                <input type='hidden' id='imgontrPublications' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/minusSign.gif'
                    width='9' />
                <input type='hidden' id='imgofftrPublications' value='<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif' />
                <div class='PropertyItemHeader'>
                    <img alt="min" id="imgPublicationstrPublications" src="<%=RootDomain()%>/Profile/Modules/PropertyList/images/plusSign.gif"
                        onclick="javascript:toggleBlock('imgPublications','trPublications');" onkeypress="if (event.keyCode == 13) javascript:toggleBlock('imgPublications','trPublications');" tabIndex="0"/>
                    Publications <span style="float: right">
                            <select id="selPrivacy" runat="server" title="Privacy">
                                <option value="1">Public</option>
                                <option value="2">Limited</option>
                                <option value="3">Private</option>
                                <option value="4">Exclude</option>
                            </select>&nbsp;
                        </span>
                </div>
            </td>
        </tr>
        <tr id='trPublications' class='PropertyGroupData' style="display: none">
            <td>
                <div style="padding: 5px">
                    <span class="uierror">Note:</span>
                    <asp:Label ID="PublicationMessageWhenORCIDExists" runat="server" Text="The list below will not include any publications that you have already pushed via this site. " />
                    For more information on privacy settings <a href='<%=RootDomain()%>/ORCID/ORCIDPrivacySettingsandProfiles.pdf'
                        target='_blank'>click here </a>(opens in new window). 
                </div>
                <asp:Repeater ID="rptPublications" runat="server" OnItemDataBound="rptPublications_ItemDataBound">
                    <HeaderTemplate>
                        <table class="data">
                            <thead>
                                <tr class="header">
                                    <th>
                                        #
                                    </th>
                                    <th>
                                        Publication
                                    </th>
                                    <th>
                                        Visibility
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr class="item">
                            <td>
                                <%#Container.ItemIndex + 1%>
                            </td>
                            <td>
                                <asp:Label ID="lblArticleTitle" runat="server" Text='<%# Eval("WorkTitle") %>' Visible="false" />
                                <strong>Citation:</strong>
                                <asp:Label ID="lblCitation" runat="server" Text='<%# Eval("WorkCitation") %>' /><br />
                                <strong>Pub Date:</strong>
                                <asp:Label ID="lblPubDate" runat="server" Text='<%# Eval("PubDateDesc") %>' /><br />
                                <strong>Pub Med Id:</strong>
                                <asp:Label ID="lblPMID" runat="server" Text='<%# Eval("PMIDDesc") %>' />
                                <asp:Label ID="lblPubID" runat="server" Text='<%# Eval("PubID") %>' Visible="false" /><br />
                                <strong>DOI:</strong>
                                <asp:Label ID="lblDOI" runat="server" Text='<%# Eval("DOI") %>' />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlPubVis" runat="server" class="visibility" title="Privacy">
                                    <asp:ListItem Value="1">Public</asp:ListItem>
                                    <asp:ListItem Value="2">Limited</asp:ListItem>
                                    <asp:ListItem Value="3">Private</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr class="alt">
                            <td>
                                <%#Container.ItemIndex + 1%>
                            </td>
                            <td>
                                <asp:Label ID="lblArticleTitle" runat="server" Text='<%# Eval("WorkTitle") %>' Visible="false" />
                                <strong>Citation:</strong>
                                <asp:Label ID="lblCitation" runat="server" Text='<%# Eval("WorkCitation") %>' /><br />
                                <strong>Pub Date:</strong>
                                <asp:Label ID="lblPubDate" runat="server" Text='<%# Eval("PubDateDesc") %>' /><br />
                                <strong>Pub Med Id:</strong>
                                <asp:Label ID="lblPMID" runat="server" Text='<%# Eval("PMIDDesc") %>' />
                                <asp:Label ID="lblPubID" runat="server" Text='<%# Eval("PubID") %>' Visible="false" /><br />
                                <strong>DOI:</strong>
                                <asp:Label ID="lblDOI" runat="server" Text='<%# Eval("DOI") %>' />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddlPubVis" runat="server" class="visibility" title="Visibility">
                                    <asp:ListItem Value="1">Public</asp:ListItem>
                                    <asp:ListItem Value="2">Limited</asp:ListItem>
                                    <asp:ListItem Value="3">Private</asp:ListItem>
                                    <asp:ListItem Value="4">Exclude</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <FooterTemplate>
                        </tbody> </table>
                    </FooterTemplate>
                </asp:Repeater>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">

    

    $(document).ready(function () {
        $("select[id*=selPrivacy]").change(
        function () {
            
            $("select[id*=ddlPubVis]").val(this.value);
        }
      );

    });

    $(document).ready(function () {
        jQuery('.myClickDisabledElm').bind('click', function (e) {
            toggleBlock('imgPublications', 'trPublications');

            var e = document.getElementById('trPublications');
            if (e.style.display == 'block') {
                e.style.display = 'none';
            }

            var object = document.getElementById('imgPublicationstrPublications');

            if (object.src == document.getElementById("imgon" + 'trPublications').value) {

                object.src = document.getElementById("imgoff" + 'trPublications').value;
            }

            ShowStatus();
        })

    });



    
</script>