<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreationConfirmation.ascx.cs"
    Inherits="Profiles.ORCID.Modules.CreationConfirmation.CreationConfirmation" %>
<h3>
    ORCID Creation Confirmation</h3>
<asp:Label ID="lblErrors" runat="server" EnableViewState="false" CssClass="uierror" />
<p>
    Congratulations! you have successfully created your ORCID.
</p>
<p>
    You will receive an email from ORCID with further instructions on using your ORCID.
</p>
<p>
    <span id="spanYourORCID" runat="server">Your public ORCID record can be viewed at:
        <img src="/Framework/Images/orcid_16x16(1).gif" class="orcidsymbol" alt="ORCID Symbol" />
        <asp:HyperLink ID="hlORCIDUrl" NavigateUrl="~/ORCID/UploadInfoToORCID.aspx" runat="server">Transfer biographical information & publications to ORCID</asp:HyperLink>
    </span>
    <p>
<br />
