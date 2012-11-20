<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchOptions.ascx.cs"
    Inherits="Profiles.Search.Modules.SearchOptions.SearchOptions" %>
<div id="divSearchCriteria" style="padding-top: 10px">
    <div class="passiveSectionHead">
        <div style="white-space: nowrap; display: inline">
            Search Options            
        </div>
    </div>    
    <div class="passiveSectionBody">
        <div style='margin-bottom:4px;margin-top:4px;'><asp:Literal runat="server" ID="litModifySearch"></asp:Literal></div>
        <div><asp:Literal runat="server" ID="litSearchOtherInstitutions"></asp:Literal></div>
        <div class="passiveSectionLine"></div>              
    </div>
</div>
