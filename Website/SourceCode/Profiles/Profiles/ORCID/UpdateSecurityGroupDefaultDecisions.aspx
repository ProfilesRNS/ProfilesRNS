<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="UpdateSecurityGroupDefaultDecisions.aspx.cs" Inherits="Profiles.ORCID.UpdateSecurityGroupDefaultDecisions" %>

<%@ Register Src="~/ORCID/Modules/UpdateSecurityGroupDefaultDecisions/UpdateSecurityGroupDefaultDecisions.ascx" TagName="UpdateSecurityGroupDefaultDecisions"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:UpdateSecurityGroupDefaultDecisions ID="UpdateSecurityGroupDefaultDecisions1" runat="server" />
</asp:Content>