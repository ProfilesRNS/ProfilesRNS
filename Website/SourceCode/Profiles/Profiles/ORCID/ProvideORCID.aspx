<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="ProvideORCID.aspx.cs" Inherits="Profiles.ORCID.ProvideORCID" %>

<%@ Register Src="~/ORCID/Modules/ProvideORCID/ProvideORCID.ascx" TagName="ProvideORCID"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:ProvideORCID ID="ProvideORCID1" runat="server" />
</asp:Content>