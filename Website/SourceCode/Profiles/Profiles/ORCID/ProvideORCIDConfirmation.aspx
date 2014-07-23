<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="ProvideORCIDConfirmation.aspx.cs" Inherits="Profiles.ORCID.ProvideORCIDConfirmation" %>

<%@ Register Src="~/ORCID/Modules/ProvideORCIDConfirmation/ProvideORCIDConfirmation.ascx" TagName="ProvideORCIDConfirmation"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:ProvideORCIDConfirmation ID="ProvideORCIDConfirmation1" runat="server" />
</asp:Content>
