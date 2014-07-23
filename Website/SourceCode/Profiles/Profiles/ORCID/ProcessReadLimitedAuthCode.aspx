<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="ProcessReadLimitedAuthCode.aspx.cs" Inherits="Profiles.ORCID.ProcessReadLimitedAuthCode" %>
<%@ Register Src="~/ORCID/Modules/ProcessReadLimitedAuthCode/ProcessReadLimitedAuthCode.ascx" TagName="ProcessReadLimitedAuthCode"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:ProcessReadLimitedAuthCode ID="ProcessReadLimitedAuthCode1" runat="server" />
</asp:Content>