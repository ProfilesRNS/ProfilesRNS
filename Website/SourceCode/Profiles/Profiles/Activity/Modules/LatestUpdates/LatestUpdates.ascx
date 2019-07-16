<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LatestUpdates.ascx.cs"
    Inherits="Profiles.Activity.Modules.LatestUpdates.LatestUpdates" %>
<%@ Register TagName="Activity" TagPrefix="ActivityHistory" Src="~/Activity/Modules/ActivityHistory/ActivityHistory.ascx" %>
<%@ Register TagName="Statistics" TagPrefix="Statistics" Src="~/Activity/Modules/Statistics/Statistics.ascx"  %>
<div class="activeContainer" id="defaultmenu">
    <div class="activeContainerTop"></div>
    <div class="activeContainerCenter">
        <div class="activeSection">
            <div class="act-heading">Profiles Stats</div>
            <div class="activeSectionBody">
                <Statistics:Statistics runat="server" ID="Statistics" Visible="true" />  
                <ActivityHistory:Activity runat="server" ID="ActivityHistory" Visible="true" />  
            </div>
        </div>
    </div>
    <div class="activeContainerBottom"></div>
</div>