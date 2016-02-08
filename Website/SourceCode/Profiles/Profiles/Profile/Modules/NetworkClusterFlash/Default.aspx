<%@ Page Title=""  MasterPageFile="NetworkClusterTemplate.Master" Language="C#" ValidateRequest="false" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Profiles.Profile.Modules.NetworkClusterFlash.Default" %>
 <%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%> 

 <%@ Register Src="~/Profile/Modules/NetworkClusterFlash/NetworkCluster.ascx" TagName="NetworkCluster"
    TagPrefix="uc1" %>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
    <uc1:NetworkCluster ID="NetworkCluster" runat="server" />
</asp:Content>