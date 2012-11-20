<%@ Page Title="" Language="C#" MasterPageFile="~/Framework/Template.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="Profiles.Error" %>
 <%--
    Copyright (c) 2008-2011 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%> 
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentHeader" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentActive" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentMain" runat="server">
 <div>
        <h2>
            Profiles error page</h2>
        <h4>
            An application error has occurred</h4>
        This error has been logged to the server event log and should be reviewed.
        <br />          
        <br />   
        <b>Error Message:</b>&nbsp;<asp:label ID="litError" runat="server" Width="800px"></asp:label>
    </div>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="ContentPassive" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="ContentFooter" runat="server">
</asp:Content>
