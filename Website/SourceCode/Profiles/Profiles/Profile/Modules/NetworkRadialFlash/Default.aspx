<%@ Page Title=""  MasterPageFile="NetworkRadialTemplate.Master" Language="C#" ValidateRequest="false" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Profiles.Profile.Modules.NetworkRadialFlash.Default" %>
 <%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%> 

 <%@ Register Src="~/Profile/Modules/NetworkRadialFlash/NetworkRadial.ascx" TagName="NetworkRadial"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:NetworkRadial ID="NetworkRadial" runat="server" />
</asp:Content>