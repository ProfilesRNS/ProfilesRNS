<%@ Control Language="C#" AutoEventWireup="True" CodeBehind="CustomViewAuthorInAuthorship.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewAuthorInAuthorship" %>


<div class='publicationList'>	
	<div style="font-weight:bold;color:#888;padding:5px 0px;" id="divPubHeaderText" visible="true" runat="server">
		Publications listed below are automatically derived from MEDLINE/PubMed and other sources, which might result in incorrect or missing publications. 
		Faculty can <asp:Literal runat='server' ID='loginLiteral'></asp:Literal> to make corrections and additions.
	</div>
	<div class="anchor-tab">
		<a class='selected' tabindex="0">List All</a> 
		&nbsp; | &nbsp; 
		<a tabindex="0">Timeline</a>
	</div>
	<asp:Repeater ID="rpPublication" runat="server" OnItemDataBound="rpPublication_OnDataBound">
		<HeaderTemplate>			
			<div id="publicationListAll" class="publications toggle-vis">
				<ol>
		</HeaderTemplate>
		<ItemTemplate>			
				<li runat="server" id="liPublication">
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
            <div style="text-align:left">To see the data from this visualization as text, <a id="divShowTimelineTable" tabindex="0">click here.</a></div>
		</div>

        <div id="divTimelineTable" class="listTable" style="display:none;margin-top:12px;margin-bottom:8px;">
		    <asp:Literal runat="server" ID="litTimelineTable"></asp:Literal>
            To return to the timeline, <a id="dirReturnToTimeline" tabindex="0">click here.</a>
        </div>
             
	</div>	
</div>

<div class="SupportText">
	<asp:Literal runat='server' ID='supportText'></asp:Literal>
</div>

<script type="text/javascript">
    $(function () {
        $("div.publicationList li:first").attr("class", "first");

        $(".publicationList .anchor-tab a").bind("click", function () {
            var $this = $(this);
            if ($this.get(0).className != "selected") {
                // Toggle link classes
                $this.toggleClass("selected").siblings("a").toggleClass("selected");
                // Show hide;
                $("div.publicationList .toggle-vis:visible").hide().siblings().fadeIn("fast");
            }
        });

        $(".publicationList .anchor-tab a").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                var $this = $(this);
                if ($this.get(0).className != "selected") {
                    // Toggle link classes
                    $this.toggleClass("selected").siblings("a").toggleClass("selected");
                    // Show hide;
                    $("div.publicationList .toggle-vis:visible").hide().siblings().fadeIn("fast");
                }
            }
        });
    });

    $(function () {
        $("#divShowTimelineTable").bind("click", function () {

            $("#divTimelineTable").show();
            $("#publicationTimelineGraph").hide();
        });

        jQuery("#divShowTimelineTable").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#divTimelineTable").show();
                $("#publicationTimelineGraph").hide();
            }
        });
    });

    $(function () {
        $("#dirReturnToTimeline").bind("click", function () {

            $("#divTimelineTable").hide();
            $("#publicationTimelineGraph").show();
        });

        jQuery("#dirReturnToTimeline").bind("keypress", function (e) {
            if (e.keyCode == 13) {
                $("#divTimelineTable").hide();
                $("#publicationTimelineGraph").show();
            }
        });
    });

    setTimeout(function () {
        $("#publicationListAll li[data-pmid] div.viewIn").each(function () {
            var pmid = $(this).parent().attr('data-pmid');
            if (pmid && pmid[0]) {
                $(this).append(
                " <span class='altmetric-embed' data-badge-popover='bottom' data-badge-type='4' data-hide-no-mentions='true' data-pmid='" +
                pmid + "'></span>")
            }
        });
        $.getScript('//d1bxh8uas1mnw7.cloudfront.net/assets/embed.js');
    }, 7000);
</script>