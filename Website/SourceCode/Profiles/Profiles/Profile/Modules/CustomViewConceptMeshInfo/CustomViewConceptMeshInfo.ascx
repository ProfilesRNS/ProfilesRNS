<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomViewConceptMeshInfo.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewConceptMeshInfo" %>

<p style='margin-bottom: 20px;'>
	"<%= this.ConceptName %>" is a descriptor in the National Library of Medicine's controlled vocabulary thesaurus, 
	<a href="http://www.nlm.nih.gov/mesh/" target="_blank">MeSH (Medical Subject Headings)</a>. Descriptors are arranged in a hierarchical structure, 
	which enables searching at various levels of specificity.
</p>

<div class="PropertyGroupItem">
	<div class="PropertyItemHeader">
		<a href="javascript:toggleBlock('propertyitem','meshInfo')"> 
			<img id="plusImage" runat='server' style="border: none; text-decoration: none !important" border="0" /></a>
			MeSH information
	</div>
	<div class="PropertyGroupData">
		<div id="meshInfo">

			<div class="anchor-tab">
				<a id='definitionLink' runat='server' class='selected' rel="#meshDefinition" href='javascript:void(0)'>Definition</a>
				&nbsp; | &nbsp; 
				<a id='detailsLink' runat='server' rel="#meshDetails" href='javascript:void(0)'>Details</a> 
				&nbsp; | &nbsp; 
				<a id='generalConceptLink' runat='server' rel="#meshGeneralConcepts" href='javascript:void(0)'>More General Concepts</a> 
				&nbsp; | &nbsp; 
				<a id='relatedConceptLink' runat='server' rel="#meshRelatedConcepts" href='javascript:void(0)'>Related Concepts</a> 	
				&nbsp; | &nbsp; 
				<a id='specificConceptLink' runat='server' rel="#meshSpecificConcepts" href='javascript:void(0)'>More Specific Concepts</a> 	
			</div>

			<div id="meshDefinition" class='toggle-vis'>
				<asp:Literal ID="litDefinition" runat="server"></asp:literal>
			</div>

			<div id="meshDetails" class='toggle-vis' style='display: none;'>
				<table>
				<tbody>
					<tr>
						<td class='label'>Descriptor ID</td>
						<td>				
							<asp:Literal ID="litDescriptorId" runat="server"></asp:Literal>
						</td>			
					</tr>
					<tr>
						<td class='label'>MeSH Number(s)</td>
						<td>
							<asp:Literal ID="litMeshNumbers" runat="server"></asp:Literal>
						</td>
					</tr>
					<tr>
						<td class='label'>Concept/Terms</td>
						<td>
							<asp:Literal ID="litConceptTerms" runat="server"></asp:Literal>
						</td>
					</tr>
				</tbody>	
				</table>
			</div>

			<div id="meshGeneralConcepts" class='toggle-vis' style='display: none;'>
				<p>Below are MeSH descriptors whose meaning is more general than "<%= this.ConceptName %>".</p>
				<div>
					<ul>
						<asp:Literal ID="litGeneralConcepts" runat="server"></asp:Literal>
					</ul>
				</div>
			</div>

			<div id="meshRelatedConcepts" class='toggle-vis' style='display: none;'>
				<p>Below are MeSH descriptors whose meaning is related to "<%= this.ConceptName %>".</p>
				<div>
					<ul>
						<asp:Literal ID="litRelatedConcepts" runat="server"></asp:Literal>
					</ul>
				</div>
			</div>

			<div id="meshSpecificConcepts" class='toggle-vis' style='display: none;'>
				<p>Below are MeSH descriptors whose meaning is more specific than "<%= this.ConceptName %>".</p>
				<div>
					<ul>
						<asp:Literal ID="litSpecificConcepts" runat="server"></asp:Literal>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<br /><br />
<script type="text/javascript">
	$(function() {

		$("#meshInfo .anchor-tab a").bind("click", function() {
			var $this = $(this);
			if ($this.get(0).className != "selected" && $this.get(0).className != "disabled") {
				// Toggle link classes
				$this.toggleClass("selected").siblings("a.selected").removeClass("selected");

				// Show target element hiding currently visible
				var target = $this.attr('rel');
				$("#meshInfo .toggle-vis:visible").hide();
				$(target).fadeIn("fast");
			}
		});

		$('#meshDetails a').bind('click', function() {
			var $this = $(this);
			$this.next('ul').toggle();
		});
	});
</script>