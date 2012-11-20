<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewConceptPublication.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewConceptPublication" %>

<div class='publicationList'>

	<div class="sectionHeader">Publications</div>
	
	<div class="publicationMenu">
		<a class='selected' rel="#timelineContainer" href='javascript:void(0)'>Timeline</a>
		&nbsp; | &nbsp; 
		<% if (ShowOtherPub) { %>
		<a rel="#cited" href='javascript:void(0)'>Most Cited</a> 
		&nbsp; | &nbsp; 
		<% } %>
		<a rel="#newest" href='javascript:void(0)'>Most Recent</a> 
		<% if (ShowOtherPub){ %>
		&nbsp; | &nbsp; 
		<a rel="#oldest" href='javascript:void(0)'>Earliest</a> 
		<% } %>
	</div>
	
	<div id="timelineContainer" class='toggle-vis' style='margin-top: 6px;'>		
		<%= this.GetModuleParamString("TimelineCaption").Replace("@ConceptName", this.ConceptName) %>
		<div id="publicationTimelineGraph">
			<img id='timeline' runat='server' border='0'/>
		</div>
	</div>	
	
	<% if (ShowOtherPub) {%>
	<div id="cited" class="cited publications toggle-vis" style="display:none;">
		<div class='intro'><%= this.GetModuleParamString("CitedCaption").Replace("@ConceptName", this.ConceptName)%></div>
		<ol style="margin-top: 8px;">		
			<asp:Literal ID='cited' runat="server" />		
		</ol>	
	</div>	
	<% } %>
	
	<div id="newest" class="newest publications toggle-vis" style="display:none;">
		<div class='intro'><%= this.GetModuleParamString("NewestCaption").Replace("@ConceptName", this.ConceptName)%></div>
		<ol style="margin-top: 8px;">		
			<asp:Literal ID='newest' runat="server" />
		</ol>	
	</div>	
	
	<% if (ShowOtherPub) {%>
	<div id="oldest" class="oldest publications toggle-vis"  style="display:none;">
		<div class='intro'><%= this.GetModuleParamString("OldestCaption").Replace("@ConceptName", this.ConceptName)%></div>
		<ol style="margin-top: 8px;">		
			<asp:Literal ID='oldest' runat="server"	/>	
		</ol>	
	</div>
	<% } %>
</div>

<script type="text/javascript">
	$(function() {
		// Add style to the first LI
		$("div.publications ol").find("li:first").addClass("first");
		// Remove timeline graph if no image found.
		if ($('#publicationTimelineGraph img').attr('src') == undefined)
			$('#publicationTimelineGraph img').remove();

		$("div.publicationMenu a").bind("click", function() {
			var $this = $(this);
			if ($this.get(0).className != "selected") {
				// Toggle link classes
				$this.toggleClass("selected").siblings("a.selected").removeClass("selected");

				// Show target element hiding currently visible
				var target = $this.attr('rel');				
				$("div.publicationList .toggle-vis:visible").hide();
				$(target).show();
			}
		});
	});
</script>
       