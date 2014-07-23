<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateBatch.ascx.cs"
    Inherits="Profiles.ORCID.Modules.CreateBatch.CreateBatch" %>
<asp:Label ID="lblErrors" runat="server" EnableViewState="false" CssClass="uierror" />
<h3>
    Create ORCIDs</h3>
<div class="section">
    <h4>
        Step 1: Search for profiles to push to ORCID</h4>

    <div class="directions">
        <span class="uierror">Restrictions: </span>An email address is required for pushing to ORCID.  A person will only show in the search results list below if he or she is active, visible, and has an email recorded in Profiles.
    </div>
    <asp:RadioButton ID="rbSearchTypeAll" runat="server" GroupName="rbSearchType" Text="Search for anyone who is active and visible in Profiles, but does not have an ORCID."
        Checked="true" OnCheckedChanged="rbSearchTypeAll_CheckedChanged" AutoPostBack="true" /><br />
    <asp:RadioButton ID="rbSearchTypeClass" runat="server" GroupName="rbSearchType" Text="Search by multiple criteria."
        OnCheckedChanged="rbSearchTypeClass_CheckedChanged" AutoPostBack="true" /><br />
    <asp:RadioButton ID="rbSearchTypeParticularPerson" runat="server" GroupName="rbSearchType"
        Text="Search for a particular person." OnCheckedChanged="rbSearchTypeParticularPerson_CheckedChanged"
        AutoPostBack="true" />
    <br />
    <br />
    <div class="section" id="divParticularPerson" runat="server">
        <table class="data">
            <tr>
                <th class="center">
                    Partial Name
                </th>
                <td>
                    <asp:TextBox ID="txtName" runat="server" />
                </td>
            </tr>
        </table>
    </div>
    <div class="section" id="divSearch" runat="server">
        <div class="directions">
            <span class="uierror">Note: </span>Please search the people for whom you would like
            to create an ORCID. You may search for people at a particular institution, department,
            or division. You may also search by type.
        </div>
        <table class="data">
            <tr>
                <th class="center">
                    Search Type
                </th>
                <td>
                    <asp:RadioButton ID="rbSearchTypePrimaryAffiliationOnly" runat="server" GroupName="rbSearchTypeAfilliation"
                        Text="Primary Affiliation Only" Checked="true" />
                    <asp:RadioButton ID="rbSearchTypeAnyAffiliation" runat="server" GroupName="rbSearchTypeAfilliation"
                        Text="Any Affiliation" />
                </td>
            </tr>
            <tr>
                <th class="center">
                    Institution
                </th>
                <td>
                    <asp:ListBox ID="listBoxInstitutionID" runat="server" DataValueField="InstitutionID"
                        DataTextField="InstitutionName" Rows="5" SelectionMode="Multiple" />
                </td>
            </tr>
            <tr>
                <th class="center">
                    Department
                </th>
                <td>
                    <asp:ListBox ID="listBoxDepartmentID" runat="server" DataValueField="DepartmentID"
                        DataTextField="DepartmentName" Rows="5" SelectionMode="Multiple" />
                </td>
            </tr>
            <tr>
                <th class="center">
                    Division
                </th>
                <td>
                    <asp:ListBox ID="listBoxDivisionID" runat="server" DataValueField="DivisionID" DataTextField="DivisionName"
                        Rows="5" SelectionMode="Multiple" />
                </td>
            </tr>
            <tr>
                <th class="center">
                    Faculty Type
                </th>
                <td>
                    <asp:ListBox ID="listBoxFacultyRankID" runat="server" DataValueField="FacultyRankID"
                        DataTextField="FacultyRank" Rows="5" SelectionMode="Multiple" />
                </td>
            </tr>
        </table>        
    </div>
    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
</div>
<div class="section" id="divSearchResults" runat="server" visible="false">
    <h4>
        Step 2: Select the profiles to push to ORCID</h4>
    <div>
        <div class="directions">
            <span class="uierror">Directions: </span>Select the people in the search results by checking
            the checkbox, then click the Create ORCID's button.  
        </div>

        <div class="directions">
            <span class="uierror">Restrictions: </span>A person's position can only be pushed if the position has a title and the corresponding institution has the city, state, and country fields populated in the '[Profile.Data].[Organization.Institution]' table.  
        </div>
        <asp:Label ID="lblSearchResultsNone" runat="server" CssClass="uierror" EnableViewState="false" />
        <asp:Label ID="lblSearhResultsCount" runat="server" CssClass="uimessage" />
        <br />
        <asp:Button ID="btnCreateORCIDs" runat="server" Text="Create ORCIDs" OnClick="btnCreateORCIDs_Click" />
        <br />
        <br />
        <asp:Repeater ID="rptSearchResults" runat="server">
            <HeaderTemplate>
                <table class="data">
                    <thead>
                        <tr class="header">
                            <th>
                                <input type="checkbox" id="chkAll" onclick="javascript: checkOrUncheckAll()" checked="checked" />
                            </th>
                            <th>#</th>
                            <th>
                                Institution<br />
                                Department<br />
                                Divsion
                            </th>
                            <th>Faculty Type</th>
                            <th>Name</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
            </HeaderTemplate>
            <ItemTemplate>
                <tr class="item">
                    <td>
                        <asp:CheckBox ID="chkSelected" runat="server" Checked="true" />
                        <asp:Label ID="lblPersonID" runat="server" Visible="false" Text='<%# Eval("PersonID")%>' />
                    </td>
                    <td><%#Container.ItemIndex + 1%></td>
                    <td>
                        <%# Eval("InstitutionName")%><br />
                        <%# Eval("DepartmentName")%><br />
                        <%# Eval("DivisionName")%>
                    </td>
                    <td>
                        <%# Eval("FacultyRank")%>
                    </td>
                    <td>
                        <%# Eval("DisplayName")%>
                    </td>
                    <td>
                        <asp:Label ID="lblErrors" runat="server" CssClass="uierror" />
                        <asp:Label ID="lblMessages" runat="server" CssClass="uimessage" />
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr class="alt">
                    <td>
                        <asp:CheckBox ID="chkSelected" runat="server" Checked="true" />
                        <asp:Label ID="lblPersonID" runat="server" Visible="false" Text='<%# Eval("PersonID")%>' />
                    </td>
                    <td><%#Container.ItemIndex + 1%></td>
                    <td>
                        <%# Eval("InstitutionName")%><br />
                        <%# Eval("DepartmentName")%><br />
                        <%# Eval("DivisionName")%>
                    </td>
                    <td>
                        <%# Eval("FacultyRank")%>
                    </td>
                    <td>
                        <%# Eval("DisplayName")%>
                    </td>
                    <td>
                        <asp:Label ID="lblErrors" runat="server" CssClass="uierror" />
                        <asp:Label ID="lblMessages" runat="server" CssClass="uimessage" />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            <FooterTemplate>
                </tbody> </table>
            </FooterTemplate>
        </asp:Repeater>
    </div>
</div>

