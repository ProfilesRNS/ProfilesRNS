<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="CreationConfirmation.aspx.cs" Inherits="Profiles.ORCID.CreationConfirmation" %>

<%@ Register Src="~/ORCID/Modules/CreationConfirmation/CreationConfirmation.ascx" TagName="CreationConfirmation"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:CreationConfirmation ID="CreationConfirmation1" runat="server" />
</asp:Content>