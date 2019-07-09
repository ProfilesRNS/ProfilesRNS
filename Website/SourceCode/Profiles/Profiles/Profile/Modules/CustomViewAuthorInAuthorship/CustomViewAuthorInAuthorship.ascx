<%@ Control Language="C#" EnableViewState="true" AutoEventWireup="True" CodeBehind="CustomViewAuthorInAuthorship.ascx.cs" Inherits="Profiles.Profile.Modules.CustomViewAuthorInAuthorship.CustomViewAuthorInAuthorship" %>


<div class='publicationList'>
    <div style="font-weight: bold; color: #888; padding: 5px 0px;" id="divPubHeaderText" visible="true" runat="server">
        Publications listed below are automatically derived from MEDLINE/PubMed and other sources, which might result in incorrect or missing publications. 
		Faculty can
        <asp:Literal runat='server' ID='loginLiteral'></asp:Literal>
        to make corrections and additions.
    </div>
    <div class="anchor-tab" id="divDisplayType">
        <a class='selected' tabindex="0" id="aNewest">Newest</a>
        &nbsp; | &nbsp; 
        <a tabindex="0" id="aOldest">Oldest</a>
        &nbsp; | &nbsp; 
        <a tabindex="0" id="aMostCited">Most Cited</a>
        &nbsp; | &nbsp; 
              <a tabindex="0" id="aMostDiscussed">Most Discussed</a>
        &nbsp; | &nbsp; 
		<a tabindex="0" id="aTimeline" class="link-visualization">Timeline</a>
        &nbsp; | &nbsp; 
              <a tabindex="0" id="aFieldSummary" class="link-visualization">Field Summary</a>
        &nbsp; | &nbsp;
		<a tabindex="0" id="aPlainText">Plain Text</a>
    </div>
    <div id="divPubListDetails" class="details-text">
        <span class="details-text-highlight">PMC Citations</span> indicate the number of times the publication was cited by articles in PubMed Central, and the <span class="details-text-highlight">Altmetric</span> score represents citations in news articles and social media.
        (Note that publications are often cited in additional ways that are not shown here.)
        <span class="details-text-highlight">Fields</span> are based on how the National Library of Medicine (NLM) classifies the publication's journal and might not represent the specific topic of the publication.
        <span class="details-text-highlight">Translation</span> tags are based on the publication type and the MeSH terms NLM assigns to the publication.
        Some publications (especially newer ones and publications not in PubMed) might not yet be assigned Field or Translation tags.)
        Click a Field or Translation tag to filter the publications.
    </div>
    <div id="divPubList">
        <asp:Repeater ID="rpPublication" runat="server" OnItemDataBound="rpPublication_OnDataBound">
            <HeaderTemplate>
                <div id="publicationListAll" class="publications">
                    <ol>
            </HeaderTemplate>
            <ItemTemplate>
                <li runat="server" id="liPublication">
                    <div>
                        <asp:Label runat="server" ID="lblPublicationAuthors"></asp:Label>
                        <asp:Label runat="server" ID="lblPublication"></asp:Label>
                        <asp:Label runat="server" ID="lblPublicationIDs"></asp:Label>
                    </div>
                    <div runat="server" id="divArticleMetrics" class="article-metrics">
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
    <div id="divFiltered" style='display: none; margin-top: 6px;' class="publications">
        <ol id="ulFiltered">
        </ol>
    </div>

    <div id="divTimeline" style='display: none; margin-top: 6px;'>
        


		<div id="publicationTimelineGraph">
            <div class="details-text" style="margin-bottom: 10px;">
                This graph shows the total number of publications by year. To see the data as text, <a id="divShowTimelineTable" tabindex="0">click here</a>.
            </div>
            <img id='timelineBar' runat='server' border='0' />
        </div>

        <div id="divTimelineTable" class="listTable" style="display: none; margin-top: 12px; margin-bottom: 8px;">
            <div class="details-text" style="margin-bottom: 10px;">
                This graph shows the total number of publications by year. To return to the graph, <a id="dirReturnToTimeline" tabindex="0">click here</a>.
            </div>
            <asp:Literal runat="server" ID="litTimelineTable"></asp:Literal>
        </div>

    </div>

    <div id="divFieldSummary" style='display: none; margin-top: 6px;'>
        <div class="details-text" style="margin-bottom: 10px;">
            This graph shows the number and percent of publications by field.
            Fields are based on how the National Library of Medicine (NLM) classifies the publications' journals and might not represent the specific topics of the publications.
            Note that an individual publication can be assigned to more than one field. As a result, the publication counts in this graph might add up to more than the number of publications the person has written.
            To see the data as text, <a onclick="showFieldSummaryAlt()">click here</a>.
        </div>
		<div id="publicationJournalHeadings">
            <div id="piechart" style="width: 580px; height: 400px;"></div>
        </div>
    </div>
    <div id="divFieldSummaryAlt" style='display: none; margin-top: 6px;' class="listTable">
        <div class="details-text" style="margin-bottom: 10px;">
            This graph shows the number and percent of publications by field.
            Fields are based on how the National Library of Medicine (NLM) classifies the publications' journals and might not represent the specific topics of the publications.
            Note that an individual publication can be assigned to more than one field. As a result, the publication counts in this graph might add up to more than the number of publications the person has written.
            To see the data as text, <a onclick="showFieldSummary()">click here</a>.
        </div>
		<div id="publicationJournalHeadingsAlt">
        </div>
    </div>
    <div class="publications-plain-text-options" style="display:none">
       <label class="publications-plain-text-options">Start with:</label>
        <input class="form-check-input" type="radio" checked style="margin-left:5px;margin-right:2px;" id="rdoNewest" name="pubradios" onclick="generatePlainText()"/>newest
        <input class="form-check-input" type="radio" style="margin-left:5px;margin-right:2px;" id="rdoOldest" name="pubradios" onclick="generatePlainText()"/>oldest
        <label style="margin-left:30px;">Include:</label>
        <input class="form-check-input" type="checkbox" style="margin-left:5px;margin-right:2px;" id="chkLineNumbers" onclick="generatePlainText()" checked />line numbers
        <input class="form-check-input" type="checkbox" style="margin-left:5px;margin-right:2px;" id="chkDoubleSpacing" onclick="generatePlainText()" checked />double spacing
        <input class="form-check-input" type="checkbox" style="margin-left:5px;margin-right:2px;" id="chkAllAuthors" onclick="generatePlainText()" checked />all authors
        <input class="form-check-input" type="checkbox" style="margin-left:5px;margin-right:2px;" id="chkPubIDs" onclick="generatePlainText()" checked />publication IDs
        <textarea id="txtPublications-text-options" style="margin-top:10px;" rows="24" cols="100" readonly></textarea>
    </div>
    <div id="divPlainText"></div>
</div>

<div class="SupportText">
    <asp:Literal runat='server' ID='supportText'></asp:Literal>
</div>

<script type="text/javascript">
    var flipped = false;





    
    

    $("#divDisplayType a").on("click", function () {
        
        var $this = $(this);
        if ($this.get(0).className != "selected") {
            $this.addClass("selected");
            $this.siblings("a").removeClass("selected");

            $("#divPlainText").hide();
            $(".publications-plain-text-options").hide();
            $("#divTimeline").hide();
            $("#divFieldSummary").hide();
            $("#divPubList").hide();
            $("#divFiltered").hide();
            $("#divPubListDetails").hide();
            $("#divFieldSummaryAlt").hide();

            switch ($this.get(0).id) {
                case "aNewest":
                    sortby = "newest";
                    applyFilters();
                    break;
                case "aOldest":
                    sortby = "oldest";
                    applyFilters();
                    break;
                case "aMostCited":
                    sortby = "citations";
                    applyFilters();
                    break;
                case "aMostDiscussed":
                    sortby = "altmetric";
                    applyFilters();
                    break;
                case "aTimeline":
                    $("#divTimeline").show();                    
                    break;
                case "aFieldSummary":
                    $("#divFieldSummary").show();
                    drawChart();
                    break;
                case "aPlainText":
                    generatePlainText();
                    $("#divPlainText").show();
                    $(".publications-plain-text-options").show();                    
                    break;
            }


        }
    });

    function showFieldSummaryAlt()
    {
        $("#divFieldSummaryAlt").show();
        $("#divFieldSummary").hide();
    }

    function showFieldSummary() {
        $("#divFieldSummaryAlt").hide();
        $("#divFieldSummary").show();
    }

    $(".xxxpublicationList .anchor-tab a").bind("keypress", function (e) {
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



    $("#divShowTimelineTable").on("click", function () {
        $("#divTimelineTable").show();
        $("#publicationTimelineGraph").hide();
    });

    jQuery("#divShowTimelineTable").on("keypress", function (e) {
        if (e.keyCode == 13) {
            $("#divTimelineTable").show();
            $("#publicationTimelineGraph").hide();
        }
    });



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

    setTimeout(function () {
        
        $.getScript('//d1bxh8uas1mnw7.cloudfront.net/assets/embed.js');
    }, 1000);
/*
    var altmetricChanged = false;

    setTimeout(function () {
        $(function () {
            $('span.altmetric-embed').on('altmetric:show', function () {
                altmetricChanged = true;
                var y = document.getElementsByClassName('hiddenCitationsLabel');

            });
        });
    }, 1100);
    */
    setTimeout(function () {
        $(function () {
            $('span.altmetric-embed').on('altmetric:hide', function () {
                var y = document.getElementsByClassName('altmetric-hidden');
                for (var i = 0; i < y.length; i++) {
                    var pmid = y[i].attributes["data-pmid"].value;

                    var spn = document.getElementById("spnHideOnNoAltmetric" + pmid);
                    var parent = spn.parentNode;
                    if (parent.children.length == 1) parent.parentNode.removeChild(parent);
                    //else parent.removeChild(spn);
                    //y.classList.remove('altmetric-embed');
                    spn.innerHTML = '';
                }
            });           
            
        });

    }, 900);
    

    function toggleFilter(filterValue) {
        var addFilter = true;
        for (var i = 0; i < filterArray.length; i++) {
            if (filterArray[i] == filterValue) {
                filterArray.splice(i, 1);
                addFilter = false;
            }
        }
        if (addFilter) filterArray.push(filterValue);
        applyFilters();
    }

    var sortby = "newest";
    var filterArray = [];

    function applyFilters() {
        var lis = document.getElementById("publicationListAll").getElementsByTagName("li");
        var ulSorted = document.getElementById("ulFiltered");
        //if (ulSortByAltmetric.getElementsByTagName("li").length > 0) return;
        while (ulSorted.lastChild) {
            ulSorted.removeChild(ulSorted.lastChild);
        }
        var array = [];
        for (var i = 0; i < lis.length; i++) {
            var item = lis[i];
            var dateRank = 10000;
            var altmetricScore = 0;
            var pmcCitations = 0;
            try {

                var url = item.getElementsByTagName("img")[0].attributes["src"].value;
                var spl = url.split("/")
                var val = spl[spl.length - 1];
                altmetricScore = val.replace(".png", "");
            }
            catch (err) {
            }
            var item = lis[i].cloneNode(true);
            try {
                pmcCitations = item.attributes["data-citations"].value;
            }
            catch (err) {}
            if (filterArray.length > 0) {
                for (var j = 0; j < filterArray.length; j++) {
                    try {
                        var tmp = item.attributes[filterArray[j]].value;
                        if (tmp != 1) break;
                        var links = item.getElementsByTagName("a")
                        for (var k = 0; k < links.length; k++)
                        {
                            try {
                                if (links[k].getAttribute("onclick").indexOf(filterArray[j]) !== -1)
                                {
                                    var colour = links[k].attributes["data-color"].value;
                                    links[k].setAttribute("style", "border-color:" + colour + ";background-color:" + colour + ";color:#FFF");
                                }
                            } catch (err) { }
                        }
                        if (j == filterArray.length - 1) array.push({ altmetricScore: altmetricScore, pmcCitations: pmcCitations, dateRank: i, element: item });
                    }
                    catch (err) { break; }
                }
            }
            else {
                array.push({ altmetricScore: altmetricScore, pmcCitations: pmcCitations, dateRank: i, element: item });
            }
        }
        if (sortby == "newest") array.sort(function (a, b) { return a.dateRank - b.dateRank; })
        else if (sortby == "oldest") array.sort(function (a, b) { return b.dateRank - a.dateRank; })
        else if (sortby == "citations") array.sort(function (a, b) { if (b.pmcCitations == a.pmcCitations) return a.dateRank - b.dateRank; else return b.pmcCitations - a.pmcCitations; })
        else if (sortby == "altmetric") array.sort(function (a, b) { if (b.altmetricScore == a.altmetricScore) return a.dateRank - b.dateRank; else return b.altmetricScore - a.altmetricScore; })
        for (var i = 0; i < array.length; i++) {
            var el = array[i].element.cloneNode(true);
            if (i == 0) el.classList.add("first");
            else el.classList.remove("first");
            ulSorted.appendChild(el);
        }
        $("#divPubList").hide();
        $("#divFiltered").show();
        $("#divPubListDetails").show();
        $.getScript('//d1bxh8uas1mnw7.cloudfront.net/assets/embed.js');
    }


    function generatePlainText() {
        var newestFirst = document.getElementById("rdoNewest").checked;
        var lineNumbers = document.getElementById("chkLineNumbers").checked;
        var doubleSpacing = document.getElementById("chkDoubleSpacing").checked;
        var allAuthors = document.getElementById("chkAllAuthors").checked;
        var ids = document.getElementById("chkPubIDs").checked;

        var lis = document.getElementById("publicationListAll").getElementsByTagName("li");
        var text = "";
        for (var i = 0; i < lis.length; i++) {
            //text = text + i +  " aaa<br>";
            var item;
            if (newestFirst) item = lis[i];
            else item = lis[lis.length - i - 1];

            var dateRank = 10000;
            var altmetricScore = 0;
            var pmcCitations = 0;
            try {
                //jsonData.substring(jsonData.lastIndexOf('\"colors\": \"[#') + 12, jsonData.length - 4);
                var pubReference = item.getElementsByTagName("span")[1].textContent;
                var authors = pubReference.substring(0, pubReference.indexOf('.'));
                if (!allAuthors) {
                    var comma = authors.indexOf(",")
                    if (comma > 0) comma = authors.indexOf(",", comma + 1)
                    if (comma > 0) comma = authors.indexOf(",", comma + 1)
                    if (comma > 0/* && comma != authors.lastIndexOf(',')*/) authors = authors.substring(0, comma) + ", et al";
                    
                }
                var title = pubReference.substring(pubReference.indexOf('.') + 2, pubReference.length);

                if (lineNumbers) text = text + (i + 1) + ". ";
                text = text + authors + '. ';
                text = text + title;
                if (ids) text = text + item.getElementsByTagName("span")[2].textContent;
                text = text + "\r\n";
                if (doubleSpacing) text = text + "\r\n";

            }
            catch (err) {
            }
            var item = lis[i].cloneNode(true);
        }
        document.getElementById("txtPublications-text-options").textContent = text;
        
    }

</script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>
<script type="text/javascript">

    // Load the Visualization API and the piechart package.
    google.charts.load('current', { 'packages': ['corechart'] });

    // Set a callback to run when the Google Visualization API is loaded.
    //google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
        var jsonData = $.ajax({
            url: "<%= svcURL %><%= nodeID %>",
            dataType: "json",
            async: false
        }).responseText;

        // Create our data table out of JSON data loaded from server.
        var data = new google.visualization.DataTable(jsonData);

        var colors = jsonData.substring(jsonData.lastIndexOf('\"colors\": \"[#') + 12, jsonData.indexOf("]", jsonData.lastIndexOf('\"colors\": \"[#') + 12));     
        var colorArray = colors.split(",");
        //colorArray = ['#4E79A7', '#F28E2B', '#E15759', '#76B7B2', '#59A14F', '#EDC948', '#B07AA1', '#FF9DA7', '#9C755F', '#BAB0AC'];
        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('piechart'));
        chart.draw(data, { width: 680, height: 300, fontSize: 12, colors: colorArray, legend: {alignment: 'center'}, chartArea: {left:20,top:20,width:'90%',height:'90%'}, tooltip: { text: 'percentage' } });

        var altTableText = jsonData.substring(jsonData.lastIndexOf('\"altTxtTable\": \"') + 16, jsonData.indexOf("</table>", jsonData.lastIndexOf('\"altTxtTable\": \"') + 16) + 5);
        document.getElementById("publicationJournalHeadingsAlt").innerHTML = altTableText;

    }

</script>

