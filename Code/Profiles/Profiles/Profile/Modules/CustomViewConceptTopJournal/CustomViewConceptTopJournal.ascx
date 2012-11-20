<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewConceptTopJournal.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewConceptTopJournal" %>

<div class="passiveSectionHead">
    <div style="white-space: nowrap; display: inline">
        <%= this.GetModuleParamString("InfoCaption") %> <a href="JavaScript:toggleVisibility('topJournal');">
            <asp:Image runat="server" ID="imgQuestion" />
        </a>
    </div>
    <div id="topJournal" class="passiveSectionHeadDescription" style="display: none;">
        <%= this.GetModuleParamString("Description") %>
    </div>
</div>
<div class="passiveSectionBody">
	<ul>
		<asp:Literal runat="server" ID="lineItemLiteral"></asp:Literal>
	</ul>
</div>
       