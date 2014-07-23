<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Profiles.ORCID.Default" %>

<%@ Register Src="~/ORCID/Modules/Default/Default.ascx" TagName="Default"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:Default ID="Default1" runat="server" />
</asp:Content>
