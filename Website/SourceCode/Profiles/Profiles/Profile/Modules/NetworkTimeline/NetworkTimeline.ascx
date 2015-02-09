<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="NetworkTimeline.ascx.cs" Inherits="Profiles.Profile.Modules.NetworkTimeline.NetworkTimeline" %>
<asp:Panel runat="server" ID="pnlData" Visible="true">
<div class='tabInfoText'>
	<%= InfoCaption %>
</div>

<div class="keywordTimeline">
	<img runat='server' id='timelineImage' class="keywordTimelineImage"/>
</div>

<div class="keywordTimelineLabels" runat='server' id='timelineDetails'>


</div>
<div style="clear:both;">
</br>
    To see the data from this visualization as text, <asp:LinkButton ID="btnShowText" runat="server" OnClick="btnShowText_OnClick" CssClass="profileHypLinks">click here.</asp:LinkButton>
    </div>
     </asp:Panel>   
    <asp:Panel runat="server" ID="pnlDataText" Visible="false">
        <asp:Literal runat="server" ID="litNetworkText"></asp:Literal> 
        </br>
        To return to the timeline, <asp:LinkButton ID="btnHideText" runat="server" OnClick="btnHideText_OnClick" CssClass="profileHypLinks">click here.</asp:LinkButton>                       
    </asp:Panel>