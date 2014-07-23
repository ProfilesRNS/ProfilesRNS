<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="CreateMyORCID.aspx.cs" Inherits="Profiles.ORCID.CreateMyORCID" %>

<%@ Register Src="~/ORCID/Modules/CreateMyORCID/CreateMyORCID.ascx" TagName="CreateMyORCID"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:CreateMyORCID ID="CreateMyORCID1" runat="server" />
</asp:Content>