

function setupTopNav() {
    let topNavbar = $('#topNavbar, #topNavbar2');

    setUrlByAnchorId("overviewA", gCommon.overviewAUrl);
    setUrlByAnchorId("openSourceSoftwareA", gCommon.openSourceSoftwareAUrl);
   // setUrlByAnchorId("useOurDataA", gCommon.useOurDataAUrl);  //Open source only
    setUrlByAnchorId("seeAllPagesA", gCommon.seeAllPagesAUrl);
    setUrlByAnchorId("topHome", gSearch.searchFormPeopleUrl);
    setUrlByAnchorId("topNavHelpDropdown", gCommon.helpUrl);
    setUrlByAnchorId("logoutA", gCommon.logoutUrl);
    setUrlByAnchorId("viewMyProfileA", g.profilesRootURL + '/display/' + sessionInfo.personNodeID);

    $('#logoutA').on('click', emptyHistory);

    let nodeId;
    if (sessionInfo.canEditPage) {
        let firstPass = JSON.parse(g.dataURLs)[0].dataURL.split('=');
        nodeId = firstPass[1].slice(0, -2);
        setUrlByAnchorId("editThisProfileA", gCommon.editProfileUrl + nodeId);
    } else {
        $("#topNav2EditThis").remove();
    }

    if (sessionInfo.personNodeID.toString() === nodeId) {
        $("#topNav2EditThis").remove(); 
    }
    setUrlByAnchorId("editMyProfileA", gCommon.editProfileUrl + sessionInfo.personNodeID);
    setUrlByAnchorId("manageProxiesA", gCommon.manageProxiesUrl + "0");
    setUrlByAnchorId("dashboardA", gCommon.dashboardUrl + sessionInfo.personNodeID)
    setUrlByAnchorId("opportunitySearchA", gCommon.opportunitySearch);
    setUrlByAnchorId("viewMyListA", gCommon.viewMyListUrl)
    populateHistoryDropdown();

    setupNavSearch(topNavbar);

    $('#navbar1outerRow').addClass(`${gCommon.cols12}`);

    $('#fourOrSoItems').addClass(`${gCommon.cols5or12Lg}`);

    $(`#topNavHome`).addClass(`${gCommon.cols2or12}`);
    $(`#topNavAbout`).addClass(`${gCommon.cols2or12}`);
    $(`#topNavHelp`).addClass(`${gCommon.cols2or12}`);
    $(`#topNavHistory`).addClass(`${gCommon.cols3or12} ps-0`);
    $(`#longerItem`).addClass(`${gCommon.cols3or12}`);

    $(`#topNav2White`).addClass(`${gCommon.cols3or12}`);

    //if person does not have a profile they will not see the following menu items
    if (!sessionInfo.personNodeID>0) {
        $("#topNav2Edit").remove();        
        $("#topNav2View").remove();
        $("#topNav2Dashboard").remove();
    }

    adjustMyPersonList();

    topNavbar.find('div.dropdown').on("mouseenter", function (e) {
        showVsHideNavDropdown(e, true);
    });
    topNavbar.find('div.dropdown').on("mouseleave", function (e) {
        showVsHideNavDropdown(e, false);
    });
}

function addSearchForm(target, formClass, searchGlassClass, displayClass, sizeFlavor, justifyPos) {
    let sdId = `searchFormDiv-${sizeFlavor}`;
    if ($(`#${sdId}`).length) {
        // already displayed by skeleton
        return;
    }
    let displayDiv = $(`<div id="${sdId}" class="${displayClass}"></div>`);
    target.append(displayDiv);

    let form = $(`<form id="topBarSearchForm" class="top ${formClass} d-flex justify-content-${justifyPos}">
        <input class="form-control navSearchTerm ps-1" id="navSearchTerm${sizeFlavor}" type="search" aria-label="Search"
               placeholder=" Search Profiles">
        <div id="searchGlassDiv${sizeFlavor}" class="searchGlassDiv">                              
            <img id="navSearchGlass${sizeFlavor}" alt="searchGlass"
                class="navSearchGlass searchMagGlass 
                ${searchGlassClass} pt-2 pe-2"/>
        </div>
        <div class="dropdown">
            <a class="search dropdown-toggle" href="#" id="navbarDropdown3${sizeFlavor}" role="button"
               data-bs-toggle="dropdown" aria-expanded="false">
                <img alt="downArrow" class="downArrow downArrow${sizeFlavor}">
            </a>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown3">
                <li><a id="findPeopleA${sizeFlavor}" class="dropdown-item find-people-menu" href="#">Find People</a></li>
                <li><a id="findEverythingA${sizeFlavor}" class="dropdown-item find-everything-menu" href="#">Find Everything</a></li>
            </ul>
        </div>
        </form>`);
    displayDiv.append(form);
    setUrlByAnchorId(`findPeopleA${sizeFlavor}`, g.profilesRootURL + "/search");
    setUrlByAnchorId(`findEverythingA${sizeFlavor}`, g.profilesRootURL + "/search/all");
}

function setupNavSearch(topNavbar) {
    let navSearchItem = $('#topNavSearch');

    // large and small versions
    addSearchForm(navSearchItem, "formHeightDesktop",
        "searchMagGlassWide", gCommon.hideXsSmallShowOthers, gCommon.large, "end");
   // addSearchForm(navSearchItem, "formHeightPhone",
   //     "searchMagGlassNarrow", gCommon.showXsSmallHideOthers, gCommon.small, "start");

    let searchGlass = $('.navSearchGlass'); 
    let searchTerm = $('.navSearchTerm');  

    searchGlass.on("click", doNavSearch);

    searchTerm.on("keypress", function (e) {
        let keycode = e.keyCode || e.which;
        if (keycode == '13') {
            doNavSearch(e);
        }
    });

    topNavbar
        .find('.downArrow')
        .attr("src", `${gBrandingConstants.jsCommonImageFiles}arrowDown.png`);
    topNavbar
        .find('.searchMagGlass')
        .attr("src", `${gBrandingConstants.jsCommonImageFiles}blackMagnifyGlass.png`);
}

function doNavSearch(e) {
    e.preventDefault();
    e.stopPropagation();
    $("#topNavSearch").css("cursor", "progress");
    let searchTerm = $('.navSearchTerm:visible').val().trim();
    console.log(`searching: [${searchTerm}]`);

    minimalPeopleSearchByTerm(searchTerm);
}
function showVsHideNavDropdown(e, showVsHide) {
    let jqItem = $(e.target);

    // start from correct parent 'nav-item'
    if (!jqItem.hasClass('nav-item')) {
        jqItem = jqItem.closest('.nav-item');
    }

    // if parent has a toggle child
    if (jqItem.find('.dropdown-toggle')) {

        // find and affect the ul sibling(s)
        let ul = jqItem.find('ul');
        if (showVsHide) {
            ul.show();
        }
        else {
            ul.hide();
        }
    }
}
function setUrlByAnchorId(aid, url) {
    $(`#${aid}`).attr('href', url);
}
///////// history tab /////////
function getOrInitHistory() {
    let history = fromSession(gCommon.historyKey, true);
    if (!history || !Array.isArray(history)) {
        history = [];
        toSession(gCommon.historyKey, history, true);
    }
    return history;
}
function emptyHistory() {
    toSession(gCommon.historyKey, [], true);
}
function addItemToNavHistory(display, url) {
    let history = getOrInitHistory();

    let displays = history.map((item) => item.display);
    if (!displays.includes(display)) {
        history.push({ display: display, url: url });
        toSession(gCommon.historyKey, history, true);

        populateHistoryDropdown();
    }
}
function populateHistoryDropdown() {
    let history = getOrInitHistory();
    let ul = $('#topHistoryDropdown');
    ul.find('.history').remove();

    let numItems = history.length;

    for (let i = 0; i < numItems; i++) {
        let item = history[i];
        let li = $(`<li><a class="dropdown-item history" href="${item.url}">${item.display}</a></li>`);
        ul.prepend(li);
    }

    let historyHtml = 'History' + (numItems > 0 ? ` (${numItems})` : "");

    let dropdownHeader = ul.closest('.nav-item').find('.nav-link');
    dropdownHeader.html(historyHtml);
}
// for logged-in topBars
function adjustMyPersonList() {
    $('#nav2Persons1').html(`My Person List (${gCommon.numPersons})`);

    // todo: we might have more granular semantics based on 'this person'
    //   vis-a-vis elements of the list


    switch (g.pageContext) {
        case 'search-form':
            $('#addPersonList').hide();
            (gCommon.numPersons === 0 ? $('#clearPersonList').hide() : $('#clearPersonList').show());
            $('#removePersonList').hide();
            $("#addMatchingPeopleList").hide()
            $("#removeMatchingPeopleList").hide();
            break;
        case 'search-results':
            $('#addPersonList').hide();
            (gCommon.numPersons === 0 ? $('#clearPersonList').hide() : $('#clearPersonList').show());
            $('#removePersonList').hide();
            if (JSON.parse(fromSession(makeSearchResultsKey(gSearch.people))).Count > 0) {
                $("#addMatchingPeopleList").show();
                (gCommon.numPersons === 0 ? $("#removeMatchingPeopleList").hide() : $("#removeMatchingPeopleList").show());
            }
            else {
                $("#addMatchingPeopleList").hide();
                (gCommon.numPersons === 0 ? $("#removeMatchingPeopleList").hide() : $("#removeMatchingPeopleList").show());
            }
            break;
        case 'profile':
            $("#addMatchingPeopleList").hide();
            (gCommon.numPersons === 0 ? $("#removeMatchingPeopleList").hide() : $("#removeMatchingPeopleList").hide());
            $('#addPersonList').show();
            (gCommon.numPersons === 0 ? $('#clearPersonList').hide() : $('#clearPersonList').show());
            (gCommon.numPersons === 0 ? $('#removePersonList').hide() : $('#removePersonList').show());
            

            break;
        default:
            $("#addMatchingPeopleList").hide();
            $("#removeMatchingPeopleList").hide();
            $('#addPersonList').hide();
            (gCommon.numPersons === 0 ? $('#clearPersonList').hide() : $('#clearPersonList').show());
            $('#removePersonList').hide();

    }  


    $("#addPersonToListA").on("click", listsAddPerson);
    $("#removePersonFromListA").on("click", listsDeletePerson);
    $("#deleteAllFromListA").on("click", listsDeleteAll);
    $("#addMatchingPeopleA").on("click", listsAddSearch);
    $("#removeMatchingPeopleA").on("click", listsDeleteSearch);
    
}
function listsDeleteAll() {
    let listsUrl = g.listsApiPath + "?action=deleteall";
    var data = {};
    listsPost(listsUrl, data);
}
function listsDeletePerson() {
    let listsUrl = g.listsApiPath + "?action=deleteperson";
    var data = {};
    data.SubjectPersonID = g.pageJSON.find(x => x.DisplayModule == 'Person.Label').ModuleData[0].PersonID;
    listsPost(listsUrl, data);
}
function listsDeleteSearch() {
    let listsUrl = g.listsApiPath + "?action=deletesearch";
    var data = {};
    data = fromSession(makeSearchResultsKey(gSearch.people));
    listsPost(listsUrl, data);
}
function listsAddPerson() {
    let listsUrl = g.listsApiPath + "?action=addperson";
    var data = {};
    data.SubjectPersonID = g.pageJSON.find(x => x.DisplayModule == 'Person.Label').ModuleData[0].PersonID;
    listsPost(listsUrl, data);
}
function listsAddSearch() {
    let listsUrl = g.listsApiPath + "?action=addsearch";
    var data = {};
    var tmp = JSON.parse(fromSession(makeSearchResultsKey(gSearch.people)));
    data = tmp.SearchQuery;
    listsPost(listsUrl, data);
}

function listsPost(url, data) {
    console.log("listPost : ", url);
    console.log('--------listsPost data----------');
    console.log(data);

    let listsActionData = JSON.stringify(data);
    $.post(url, listsActionData, function (results) {
        if (isArray(results)
            && results.length == 1
            && results[0].ErrorMessage !== gCommon.undefined) {

            console.log(`Error message from back-end: "${results[0].ErrorMessage}"
                    \nFrom Post of: 
                    <${data}>`);
        }
        else {
            gCommon.numPersons = results.Size;
            adjustMyPersonList();
        }
    });

}

$(window).resize(function () {

    if ($(window).width() <= 770) {
        $('.myNavbar-nav2').removeClass('d-flex flex-row');   
        $('#topNavbarUser').addClass('topNavUserBarMax');
        $('#topNavbarUser').removeClass('topNavUserBarMin');
    
    }
    if ($(window).width() >= 770) {
        $('.myNavbar-nav2').addClass('d-flex flex-row');
      
    }
    if ($(window).width() <= 1115) {        
        $('#topNavbarUser').addClass('topNavUserBarMin');
        $('#topNavbarUser').removeClass('topNavUserBarMax');

    }
    if ($(window).width() >= 1115) {
        $('#topNavbarUser').addClass('topNavUserBarMax');
        $('#topNavbarUser').removeClass('topNavUserBarMin');
    }
});

  

