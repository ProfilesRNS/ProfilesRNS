<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true"
    CodeBehind="UploadInfoToORCID.aspx.cs" Inherits="Profiles.ORCID.UploadInfoToORCID" %>

<%@ Register Src="~/ORCID/Modules/UploadInfoToORCID/UploadInfoToORCID.ascx" TagName="UploadInfoToORCID"
    TagPrefix="uc1" %>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <br />
    <h1>
        Profiles &harr; ORCID Synchronization
    </h1>
    <asp:Button ID="Button1" runat="server" OnClick="btnSubmitToORCID_Click" Text="Submit to ORCID Profile"
        Width="189px" />
    <br />
    <br />
    <asp:Label ID="lblErrorsUpload" runat="server" EnableViewState="false" CssClass="uierror" />
    <uc1:UploadInfoToORCID ID="UploadInfoToORCID1" runat="server" />
    <br />
    <asp:Button ID="btnSubmitToORCID" runat="server" OnClick="btnSubmitToORCID_Click"
        Text="Submit to ORCID Profile" Width="189px" />
</asp:Content>
