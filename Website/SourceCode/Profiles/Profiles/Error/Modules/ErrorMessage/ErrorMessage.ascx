<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ErrorMessage.ascx.cs" Inherits="Profiles.Error.Modules.ErrorMessage" %>
<div>
        
        This error has been logged to the server event log and should be reviewed.
        
        <b>Error Message:</b>&nbsp;<asp:label ID="litError" runat="server" Width="800px"></asp:label>
    </div>