<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MainMenu.ascx.cs"
    Inherits="Profiles.Framework.Modules.MainMenu.MainMenu" %>
<%@ Register TagName="Networks" TagPrefix="RelationshipType" Src="~/Framework/Modules/MainMenu/SetActiveNetworks.ascx" %>
<%@ Register TagName="History" TagPrefix="HistoryItem" Src="~/Framework/Modules/MainMenu/History.ascx"  %>
<%--
    Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
    Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
    and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
    National Center for Research Resources and Harvard University.


    Code licensed under a BSD License. 
    For details, see: LICENSE.txt 
 --%>

<div class="activeContainer" id="defaultmenu">
    <div class="activeContainerTop"></div>
    <div class="activeContainerCenter">
        <div class="activeSection">
            <div class="activeSectionHead">Menu</div>
            <div class="activeSectionBody">
                <div runat="server" id="panelMenu" visible="true"></div>
            </div>
        </div>
        <RelationshipType:Networks runat="server" ID="ActiveNetworkRelationshipTypes" Visible="false" />        
        <HistoryItem:History runat="server" ID="ProfileHistory" Visible="false" />        
    </div>
    <div class="activeContainerBottom"></div>
</div>
