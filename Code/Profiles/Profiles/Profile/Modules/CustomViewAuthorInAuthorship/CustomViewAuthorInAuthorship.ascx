<%@ Control Language="C#" AutoEventWireup="True" CodeBehind="CustomViewAuthorInAuthorship.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewAuthorInAuthorship" %>


<div class='publicationList'>	
	<div class="sectionHeader">Publications</div>
	<div style="font-weight:bold;color:#888;padding:5px 0px;">
		Publications listed below are automatically derived from MEDLINE/PubMed and other sources, which might result in incorrect or missing publications. 
		Faculty can <asp:Literal runat='server' ID='loginLiteral'></asp:Literal> to make corrections and additions.
	</div>
	<div class="publicationMenu">
		<a class='selected' href='javascript:void(0)'>List All</a> 
		&nbsp; | &nbsp; 
		<a href='javascript:void(0)'>Timeline</a>
	</div>
	<asp:Repeater ID="rpPublication" runat="server" OnItemDataBound="rpPublication_OnDataBound">
		<HeaderTemplate>			
			<div id="publicationListAll" class="publications toggle-vis">
				<ol>
		</HeaderTemplate>
		<ItemTemplate>			
				<li>
					<div>
						<asp:Label runat="server" ID="lblPublication"></asp:Label>
					</div>
					<div class="viewIn">
						<asp:Literal runat="server" ID="litViewIn"></asp:Literal>
					</div>
				</li>
		</ItemTemplate>
		<FooterTemplate>
				</ol>	
			</div>				
		</FooterTemplate>
	</asp:Repeater>
	
	<div class='toggle-vis' style='display:none;margin-top: 6px;'>		
		This graph shows the total number of publications by year, by first, middle/unknown, or last author.
		<div id="publicationTimelineGraph">
			<img id='timelineBar' runat='server' border='0'/>
		</div>
	</div>	
</div>

<script type="text/javascript">
	$(function() {
		$("div.publicationList li:first").attr("class", "first");

		$("div.publicationMenu a").bind("click", function() {
			var $this = $(this);
			if ($this.get(0).className != "selected") {
				// Toggle link classes
				$this.toggleClass("selected").siblings("a").toggleClass("selected");
				// Show hide;
				$("div.publicationList .toggle-vis:visible").hide().siblings().show();
			}
		});
	});
</script>