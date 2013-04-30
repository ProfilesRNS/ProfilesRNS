<%@ Control Language="C#" AutoEventWireup="True" CodeBehind="CustomViewAuthorInAuthorship.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewAuthorInAuthorship" %>


<div class='publicationList'>	
	<div class='toggle-vis' style='margin-top: 6px;'>		
		Publications by year:
		<div id="publicationTimelineGraph">
			<img id='timelineBar' runat='server' border='0'/>
		</div>
	</div>
	
	<div style="font-weight:bold;color:#888;margin-bottom: 12px;">
		Publications listed below are automatically derived from MEDLINE/PubMed and other sources, which might result in incorrect or missing publications. 
		Researchers can <asp:Literal runat='server' ID='loginLiteral'></asp:Literal> to make corrections and additions, or <a href="mailto:profiles@ucsf.edu">contact us for help</a>.
	</div>
<!--
	<div class="anchor-tab">
		<a class='selected'>List All</a> 
		&nbsp; | &nbsp; 
		<a>Timeline</a>
	</div>
-->
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
	
</div>

<div class="SupportText">
	<asp:Literal runat='server' ID='supportText'></asp:Literal>
</div>

<script type="text/javascript">
    $(function() {
        $("div.publicationList li:first").attr("class", "first");

        $(".publicationList .anchor-tab a").bind("click", function() {
            var $this = $(this);
            if ($this.get(0).className != "selected") {
                // Toggle link classes
                $this.toggleClass("selected").siblings("a").toggleClass("selected");
                // Show hide;
                $("div.publicationList .toggle-vis:visible").hide().siblings().fadeIn("fast");
            }
        });
    });
</script>