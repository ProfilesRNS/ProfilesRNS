<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewConceptPublication.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewConceptPublication" %>

<div class="PropertyGroupItem"  style='margin-bottom: 10px;'>
	<div class="PropertyItemHeader">
		<a href="javascript:toggleBlock('propertyitem','conceptPub')"> 
			<img id='plusImage' runat='server' style="border: none; text-decoration: none !important" border="0" /></a>
			publications
	</div>
	<div class="PropertyGroupData">
		<div id="conceptPub" class='publicationList'>

			<div class="anchor-tab">
				<a class='selected' rel="#timelineContainer" href='javascript:void(0)'>Timeline</a>
				&nbsp; | &nbsp; 
				<% if (ShowOtherPub) { %>
				<a rel="#cited">Most Cited</a> 
				&nbsp; | &nbsp; 
				<% } %>
				<a rel="#newest">Most Recent</a> 
				<% if (ShowOtherPub){ %>
				&nbsp; | &nbsp; 
				<a rel="#oldest">Earliest</a> 
				<% } %>
			</div>
			
			<div id="timelineContainer" class='toggle-vis' style='margin-top: 6px;'>		
				<div style='padding-right: 3px;'><%= this.GetModuleParamString("TimelineCaption").Replace("@ConceptName", this.ConceptName) %></div>
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
	</div>
</div>
<script type="text/javascript">
	$(function() {
		// Add style to the first LI
		$("div.publications ol").find("li:first").addClass("first");
		// Remove timeline graph if no image found.
		if ($('#publicationTimelineGraph img').attr('src') == undefined)
			$('#publicationTimelineGraph img').remove();

		$(".publicationList .anchor-tab a").bind("click", function() {
			var $this = $(this);
			if ($this.get(0).className != "selected") {
				// Toggle link classes
				$this.toggleClass("selected").siblings("a.selected").removeClass("selected");

				// Show target element hiding currently visible
				var target = $this.attr('rel');				
				$("div.publicationList .toggle-vis:visible").hide();
				$(target).fadeIn("fast");
			}
		});
	});
</script>
       