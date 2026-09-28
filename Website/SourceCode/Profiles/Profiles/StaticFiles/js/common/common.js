function weirdRemoveExtraNav2Ids() {
    //$('#topNav2PersonsDropdown').find('a[id="nav2Persons1"]').remove();
}
async function setupPageStub(mainBodyStructure, title) {
    await loadBrandingAssets();
    let container = loadMainDataContainer();

    await setupHeadIncludesAndTabTitle(title);
    await emitBrandingHeader(container);
    await emitBrandingFooter(container);

    weirdRemoveExtraNav2Ids();

    initialCurtainsDown();

    adjustThisPageGlobals();

    setupSkipToContent();

    if (typeof emitPrefooter !== gCommon.undefined) { // supplied in myBranding.js
        emitPrefooter();
    }
    await setupTopOfPageItems();
    loggedInShowHide();

    if (mainBodyStructure) {
        mainBodyStructure();
    }
    createOrGetTopLhsDiv(); // some modules use topLhsDiv
    await resolveMoveables();

    initialCurtainsUp(); // main-data-container always shows up hidden at first
}
function adjustThisPageGlobals() {
    let href = encodeURIComponent(window.location.href);
    gCommon.loginUrl = gCommon.loginUrlSchema.replace(gCommon.schemaPlaceholder, href);
}
function resolveMoveables() {
    $('.moveable').each(function () {
        let that = $(this);
        let destination = that.attr('dest');
        destination = destination == 'body' ?
                                        destination :
                                        `#${destination}`;
        moveContentTo(that, $(destination));
    })
}
async function commonSetup(title) {
    let mainBodyStructure = setupMainStructure;
    await setupPageStub(mainBodyStructure, title);

    console.log("g values upon 'ready': ", g);
    console.log("sessionInfo values upon 'ready': ", sessionInfo);

    if (title) {
        h2Title(title);
    }
    else {
        addTitleFromPreLoad();
    }
}

function addTitleFromPreLoad() {
    let preLoadTitle;

    try {
        if (g.preLoad) {
            let preLoad = JSON.parse(g.preLoad).filter(m => m.DisplayModule.match(/Person.Label$/));
            let moduleData = preLoad[0].ModuleData[0];
            preLoadTitle = orNaProperty(moduleData, 'DisplayName',
                `DisplayName in? ${JSON.stringify(moduleData)}`);
            //preLoadTitle = ;
            h2Title(preLoadTitle);
            return preLoadTitle;
        }
    }
    catch (e) {
        console.log("=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=* Error: " + e);
    }
}
function h2Title(title) {
    $('div.topOfPageItems').append($(`<h2 class="preloaded page-title">${title}</h2>`));
}
async function setupJson(moduleCompareFn, doCurtainMainModuleRow) {
    if (doCurtainMainModuleRow) {
        let curtainTarget = getMainModuleRow();
        innerCurtainsDown(curtainTarget);
    }
    let pageJson = await myGetPageJson();

    let [lhsModules, rhsModules] = partitionModuleJsons(pageJson, moduleCompareFn);

    return [pageJson, lhsModules, rhsModules];
}
async function commonSetupWithJson(moduleCompareFn, doCurtainMainModuleRow) {
    await commonSetup();

    return await setupJson(moduleCompareFn, doCurtainMainModuleRow);
}

function setupScrolling() {

    // When the user scrolls down from the top of the document, show the button
    window.onscroll = function () {
        scrollFunction()
    };

    let buttonsDiv = $(`
    <div id="rtnButtonsDiv">
        <div class="rtnBtnDiv" id="rtnBtnLgDiv">
            <button type="button" id="rtnBtnLg" class="rtnBtn" title="Go to top">Return to Top</button>
        </div>
        <div class="rtnBtnDiv" id="rtnBtnSmDiv">
            <button type="button" id="rtnBtnSm" class="rtnBtn" title="To top">To Top</button>
        </div>
    </div>`);
    $('body').append(buttonsDiv);

    $('#rtnBtnLg').addClass(gCommon.hideXsSmallShowOthers);
    $('#rtnBtnSm').addClass(gCommon.showXsSmallHideOthers);

    $('.rtnBtn').on("click", topFunction);

    //https://stackoverflow.com/questions/42441370/link-to-dynamically-created-div-on-another-page
    let potentialScrollTo = $(window.location.hash);
    if (potentialScrollTo.length > 0) {
        $('html, body').animate({
            scrollTop: $(potentialScrollTo).offset().top
        }, gCommon.scrollTime);
    }

    topFunction();
}

function scrollFunction() {
    let scrollTriggerHeight;
    let rtnBtnDiv = $(".rtnBtnDiv:visible");
    let rtnBtnDivId = rtnBtnDiv.attr("id");
    if (rtnBtnDivId == "rtnBtnLgDiv") {
        scrollTriggerHeight = 100;
    } else {
        scrollTriggerHeight = 25;
    }

    let pagePosition = (document.body.scrollTop || document.documentElement.scrollTop);

    if (pagePosition > scrollTriggerHeight) {
        $(".rtnBtnDiv").show();
    } else {
        $(".rtnBtnDiv").hide();
    }
    return true;
}

// When the user clicks on the button, scroll to the top of the document
function topFunction(e) {
    $('body,html').animate({scrollTop: 0}, gCommon.scrollTime);
    window.scrollTo({top: 0, behavior: 'smooth'});

    scrollFunction(); // button does not show at top 'scroll position'
    return true;
}

function setTabTitleAndOrFavicon(title) {
    if (!title) {
        title = window.location.pathname
            .replace(/.*\//, "")
            .replace(".html", "");
    }

    document.title = title + gBrandingConstants.tabTitleSuffix;

    let faviconHref = `href="${gBrandingConstants.faviconUrl}"`;
    if (faviconHref) {
        let head = $('head');
        head.append(`<link rel="icon" type="image/x-icon" ${faviconHref}>`);
        head.append(`<link rel="shortcut icon" type="image/x-icon" ${faviconHref}>`);
    }
}

function setupMainStructure() {
    let mainDiv = $('#mainDiv');
    mainDiv.addClass(gCommon.mainDivClasses);

    let leftDiv = $('#modules-left-div');
    let rightDiv = $('#modules-right-div');

    leftDiv.addClass(gCommon.mainLeftCols);
    rightDiv.addClass(gCommon.mainRightCols);
}

function setupSkipToContent() {
    let skipButton = $(`<button id="skipButton" class="skip-to-main-content-link">Skip to main content</button>`);
    $('#main-data-container').prepend(skipButton);
    skipButton.on("click", function () {
        location.href = "#mainDiv";
    })
}

async function getJsonData(url) {
    let result;
    try {
        await $.getJSON(url, function (data) {
            result = data;
        })
    } catch {
        alert(`Oops, cannot load this page's Data, (url: <${url}>)`);
        console.trace();
        result = [];
    }
    return result;
}

function partitionModuleJsons(jsonArray, lhsCompareFn) {
    let lhs = [];
    let rhs = [];

    jsonArray.forEach(arr => {
        // todo: move this use-case to person.js
        if (arr.DisplayModule == "Person.Label") {
            let json = arr.ModuleData[0];

            // NB: person page gets corresponding info from its 'generalInfo'
            parseLabelInfo(json);
        }
        // todo: nicer to have consistent data structure, eg for explore
        else if (arr["ModuleData"][0]
            && (arr["ModuleData"][0]["ExploreLink"])) {
            rhs.push(arr);
        }
        // todo: nicer to have consistent data structure, eg for explore
        else if (arr["ModuleData"]["ExploreURL"]) {
            rhs.push(arr);
        }
        else if (   arr["DisplayModule"] == "Person.PhysicalNeighbour.Top5"
                 || arr["DisplayModule"] == "Person.SameDepartment.Top5") {
            rhs.push(arr);
        }
        else {
            lhs.push(arr);
        }
    })

    lhs = sortModules(lhs, lhsCompareFn);
    rhs = sortModules(rhs, compareExploreModules);

    return [lhs, rhs];
}

function makeModuleTitleDiv(moduleTitle) {
    let result = $(`<div id="${moduleTitle}"></div>`);
    return result;
}

function setupTopOfPageItems() {
    setUrlByAnchorId("loginA", gCommon.loginUrl + sessionInfo.sessionID);

    setupTopNav();
}

function loggedInShowHide() {
    gCommon.loggedIn = sessionInfo.userID > 0;

    if (g.bannerMessage) {
        $('#systemMessage').show();
        $('#systemMessage').append(g.bannerMessage);

        $('#inviteLoginDiv').hide();
        $('#topNavbar2').hide();
    } else if (gCommon.loggedIn) {
        $('#inviteLoginDiv').hide();
        $('#topNavbar2').show();
    } else {
        $('#inviteLoginDiv').show();
        $('#topNavbar2').hide();
    }
}

function makeRowWithColumns(target, idLabel, columnSpecArray, rowClass) {
    if (!rowClass) {
        rowClass = "";
    }
    let row = $(`<div id="${idLabel}Row" class="row ${rowClass}"></div>`);
    target.append(row);

    for (let i = 0; i < columnSpecArray.length; i++) {
        let colSpec = columnSpecArray[i];
        let col = $(`<div class="${colSpec.classes}" id="${idLabel}Col${i}"></div>`);
        col.append(colSpec.value)
        row.append(col);
    }
    return row; // may be useful in caller
}

function newColumnSpec(classes, value) {
    if (value === undefined) value = $('<span></span>');

    return {classes: classes, value: value};
}

function spanify(content, klass) {
    let klassAttr = klass ? `class="${klass}"` : "";
    let span = $(`<span ${klassAttr}>${content}</span>`);
    return span;
}

function divSpanifyTo(content, target, spanClass, divClass) {
    let elt = spanify(content, spanClass);
    return divEltTo(elt, target, divClass);
}

function divEltTo(elt, target, divClass) {
    let klassAttr = divClass ? `class="${divClass}"` : "";
    let div = $(`<div ${klassAttr}></div>`);
    div.append(elt);
    target.append(div);
    return div;
}

function toggleEltVisibility(togglingDiv, andThen) {

    if (togglingDiv.is(":visible")) {
        // may not need both of these two
        togglingDiv.hide();
        togglingDiv.addClass('d-none');

    } else {
        togglingDiv.removeClass('d-none');
        togglingDiv.show();
    }
    if (andThen) {
        andThen(togglingDiv);
    }
}

function getNodeId() {
    let result = '';

    try {
        let preLoad = JSON.parse(g.preLoad);
        let label = findModuleDataByName(preLoad, 'Label');
        if (label) {
            if (Array.isArray(label)) {
                label = label[0];
            }
            result = label.NodeID;
            if (!result) {
                throw "no label NodeID";
            }
        }
    }
    catch (error) {
        let sessionNI = sessionInfo.personNodeID;
        if (sessionNI) {
            result = sessionNI;
        }
    }
    return result;
}
function findModuleByName(modulesJson, displayName) {
    let result = modulesJson
            .find(m => m.DisplayModule.match(displayName));
    return result;
}
function findModuleDataByName(modulesJson, displayName) {
    let result = null;
    if (modulesJson) {
        let matchingModule = findModuleByName(modulesJson, displayName);
        if (matchingModule) {
            result = matchingModule.ModuleData;
            if (!result) {
                result = {};
            }
        }
    }
    return result;
}

function parseLabelInfo(json) {
    gCommon.fname = json.FirstName;
    gCommon.lname = json.LastName;
    gCommon.flName = `${json.FirstName} ${json.LastName}`;
    gCommon.displayName = json.DisplayName;
    gCommon.preferredPath = json.PreferredPath;
}

function getPersonLastname() {
    return gCommon.lname;
}

function getPersonFirstLastName() {
    return gCommon.flName;
}

function getPersonDisplayName() {
    return gCommon.displayName;
}

function setupExploreNetworks(rhsModules, postSkeleton) {
    if (! postSkeleton) {
        emitNameHeaderForExplores(gCommon.lname);
    }
    for (let i = 0; i < rhsModules.length; i++) {
        let moduleJson = rhsModules[i];

        // skip empty-data modules
        if (! moduleJson.ModuleData) {
            console.log("NO DATA FOR " + moduleJson.DisplayModule);
            continue;
        }
        exploreFullParser(moduleJson, postSkeleton);
    }
}


async function myGetPageJson() {
    if (!g.pageJSON) {
        await getPageJSON();
    }
    return g.pageJSON;
}

function rememberArraySizeOfJsonModule(pageJson, moduleName, sessionKey) {
    let jsonArray = findModuleDataByName(pageJson, moduleName);
    if (jsonArray) {
        toSession(sessionKey, String(jsonArray.length));
    }
}

function getEltBackTo(backUrl, backLabel) {
    let backArrow = "<img src='" + g.profilesRootURL + "/StaticFiles/img/common/arrowLeft.png' class='me-1' alt='backArrow'>";
    let returnA = createAnchorElement(`Back to ${backLabel}`, backUrl);
    returnA.prepend(backArrow);

    return returnA;
}

function emitCommonTopOfLhs(topLhsDiv, thingLabel, numThings, backUrl, backLabel, title) {
    if (title) {
        getMainModuleRow().prepend($(`<h2 class="page-title">${title}</h2>`));
    }

    let returnElt = getEltBackTo(backUrl, backLabel);
    let numThingsContent = numThings ? `(${numThings})` : "";

    let colspecs1 = [
        newColumnSpec(`${gCommon.cols6or12} page-subTitle`,
            spanify(`<strong>${thingLabel} ${numThingsContent}</strong>`)),
        newColumnSpec(`${gCommon.cols6or12} d-flex justify-content-end`,
            returnElt),
    ];
    let preTop = createOrGetPreTop(topLhsDiv);
    makeRowWithColumns(preTop, "topLhs", colspecs1);
}

function createFlavorTabs(flavorArray) {
    // see https://getbootstrap.com/docs/5.0/components/navs-tabs/

    let tabChoicesDiv = $(`<div id="tabChoicesDiv" class="tabChoices container ps-0 mb-2 pe-0"></div>`);

    let navUl = $('<ul class="nav"></ul>');

    tabChoicesDiv.append(navUl);

    for (flavor of flavorArray) {
        let li = $(`<li class="nav-item">
                        <a id="navTo${flavor.replace(/\s+/g, '')}" class="tabTopHat nav-link">${flavor}</a>
                    </li>`);
        navUl.append(li);
    }
    return tabChoicesDiv;
}

function createTimelineDiv(blurb) {
    let timelineDiv = $(`<div id="moveableContentDiv">
        <div id="divTimelineGraph">
            <div id="timelineGraphInner">
                <div class='tabInfoText mt-2 mb-2 pb-2'>
                    <div id="timelineBlurb" class="blurb hideTilReady">${blurb}</div>
                    <hr class="tightHr"/>
                </div>
            </div>
            <div class="hideTilReady">
                <div style="clear:both;text-align:left;">
                    <br/>
                    To see the data from this visualization as text,
                    <a id="toDivTimelineText" tabindex="0" class="link-ish">
                        click here.</a>
                </div>        
            </div>
        </div>
        <div id="divTimelineText" class="hideTilReady">
            <div id="timelineTextInner" class="mt-2">
            </div>
            <br/>
            To return to the timeline,
            <a id="toDivTimeline" tabindex="0" class="link-ish">
                click here.</a>
        </div>
    </div>`);

    return timelineDiv;
}

function createOrGetTopLhsDiv() {
    let topLhsDiv = $('#topLhsDiv');

    if (! topLhsDiv.length) {
        let lhsDiv = $('#modules-left-div');
        topLhsDiv = $(`<div id="topLhsDiv"></div>`);
        lhsDiv.append(topLhsDiv);
    }

    return topLhsDiv;
}

function createOrGetPreTop(target) {
    let preTop = $('#preTop');
    if ( ! preTop.length) {
        preTop = $('<div id="preTop"></div>"');
        target.prepend(preTop);
    }
    return preTop;
}
function emitTopAndTabs(params) {
    params.harvestTabSyms();

    let description = params.description;
    let whatAreConceptsDiv = $(`<div class="mb-3" id="whatAreConcepts">
        ${description}</div>`);

    let topLhsDiv = params.target;
    let numThings = fromSession(params.numThingsKey);

    let profileUrl = gCommon.preferredPath;
    emitCommonTopOfLhs(topLhsDiv, params.thingsLabel, numThings,
        profileUrl, 'Profile');

    let preTop = createOrGetPreTop(topLhsDiv);
    preTop.append(whatAreConceptsDiv);
    preTop.append(params.thingTabs);
}

function createAnchorElement(text, url, klass) {
    if (!url) {
        url = text;
    }
    let addClass = klass ? klass : "";
    let result = $(`<a class="link-ish ${addClass}" href="${url}">${text}</a>`);

    return result;
}

function moveContentTo(item, target) {
    item.detach().appendTo(target);
}

function moveContentByIdTo(itemId, target) {
    // let item = $(`#${itemId}`);
    // moveContentTo(item, target);
}

function hoverLight(elt, inThen, outThen) {
    elt.on('mouseenter', function () {
        $(this).addClass("hoverDark");
        $(this).find('.link-ish').addClass("hoverDark");
        if (inThen) {
            inThen();
        }
    })
        .on('mouseleave', function () {
            $(this).removeClass("hoverDark");
            $(this).find('.link-ish').removeClass("hoverDark");
            if (outThen) {
                outThen();
            }
        });
}

function makeArrowedConnectionLine() {
    let left = "<img class='connectionArrow' src='" + g.profilesRootURL + "/StaticFiles/img/common/connection_left.gif' alt='Left Arrow'/>";
    let line = $('<span class="w-100 connectionLine"></span>');
    let right = "<img class='connectionArrow' src='" + g.profilesRootURL + "/StaticFiles/img/common/connection_right.gif' alt='Right Arrow' />";

    let doubleArrow = $('<span class="w-100 d-flex justify-content-center"></span>');
    doubleArrow.append(left).append(line).append(right);

    return doubleArrow;
}

function emitAndHistoricizeTitle(title, targetId, mainDiv) {
    let target = $(`#${targetId}`);
    target.html(title);

    moveContentTo(target, mainDiv);

    setTabTitleAndOrFavicon(`${title}`);
    addItemToNavHistory(title, window.location.href);
}

function createNavItemSpan(id, text, clickFn, aClass) {
    if (!aClass) {
        aClass = "";
    }
    let span = $(`<span class="link-ish nav-link d-inline ${id} ${aClass}">
                                ${text}</span>`);

    if (clickFn) {
        span.on("click", clickFn);
    }
    return span;
}
function emitExploreButton(target, hrefOrFn) {
    // large/small variants
    let largeDiv = $(`<div class="mt-2 explore-parent"></div>`);
    let smallDiv = $(`<div class="mt-2 explore-parent"></div>`);
    let largeItem;
    let smallItem;
    let largeClass = `${gCommon.hideXsSmallShowOthers} link-ish greenButton explore_connection_link_bg`;
    let smallClass = `${gCommon.showXsSmallHideOthers} link-ish greenButton explore_connection_link_sm`;

    target.append(largeDiv);
    target.append(smallDiv);

    // too bad 'href="javascript:myFunction();"' does not seem to work
    if (typeof hrefOrFn === 'string') {
        largeItem = $(`<a href="${hrefOrFn}" class="${largeClass}">Explore</a>`);
        smallItem = $(`<a href="${hrefOrFn}" class="${smallClass}">Explore</a>`);
    } else { // it's a function
        largeItem = $(`<span class="${largeClass}">Explore</span>`);
        smallItem = $(`<span class="${smallClass}">Explore</span>`);

        largeItem.on('click', hrefOrFn);
        smallItem.on('click', hrefOrFn);
    }
    largeDiv.append(largeItem);
    smallDiv.append(smallItem);
}

function twoColumnInfo(target, leftSpan, rightElement, idLabel, wideVsNarrow) {
    let displayClass = wideVsNarrow ? "d-flex justify-content-end" : "";
    let margin = wideVsNarrow ? "" : "mb-2";

    let colSpecs = [
        newColumnSpec(`pe-1 ${gCommon.cols3or12} ${displayClass}`, leftSpan),
        newColumnSpec(`pe-1 ${gCommon.cols9or12} justify-content-start`, rightElement)
    ];

    let rowSuffix = wideVsNarrow ? '-wide' : '-narrow';
    makeRowWithColumns(target, idLabel + rowSuffix, colSpecs, `me-3 ${margin}`);
}

function compareLhsModules(m1, m2, prefix, whichInfo) {
    let m1Name = m1.DisplayModule.replace(`${prefix}.`, "");
    let m2Name = m2.DisplayModule.replace(`${prefix}.`, "");

    let m1Info = whichInfo(m1Name);
    let m2Info = whichInfo(m2Name);

    let m1Rank = m1Info ? m1Info.sort : 300; // big number
    let m2Rank = m2Info ? m2Info.sort : 300; // big number

    //console.log(`m1: ${m1Name}, ${m1Rank}. m2: ${m2Name}, ${m2Rank}. result: ${m1Rank - m2Rank}`)
    return m1Rank - m2Rank;
}

function asIdentifier(input) {
    let result = input.replace(/\W/g, "");
    return result;
}

function getTargetUntentavizeIfSo(title, fallbackDiv) {
    let div = gPerson.innerTargetCache[title];
    if (div) {
        div.removeClass(gCommon.tentative);
    }
    else {
        div = fallbackDiv;
    }
    return div;
}
function getModuleEltTitle(moduleJson) {
    let displayModule = moduleJson.DisplayModule;
    let moduleTitle = displayModule
        .replace(/^\w+\./, "")
        .replace(/\./g, "_");
    return moduleTitle;
}
function setupAnchorDivs(target) {
    let anchorLinksDiv = $(`<div id="anchorLinksDiv"></div>`);
    anchorLinksDiv.insertAfter(target);

    let anchorRhsLinksDiv = $(`<div id="anchorRhsLinksDiv" 
            class="${gCommon.showXsSmallHideOthers} anchorLinksDiv ${gCommon.anchorLinksDivSpacing}"></div>`);
    let anchorLhsLinksDiv = $(`<div id="anchorLhsLinksDiv" class="anchorLinksDiv ${gCommon.anchorLinksDivSpacing}"></div>`);

    anchorLinksDiv.append(anchorRhsLinksDiv).append(anchorLhsLinksDiv);
}
function addAnchorLinkToArray(array, refId, text) {
    let anchorHtml = `<a class="link-ish me-1" href="#${refId}">${text}</a>`;
    array.push(anchorHtml);
}
function populateAnchors(target, anchorsArray) {
    let comboAuthorModuleAnchors = anchorsArray.join(`<span class="me-1"> | </span>`);
    target.append(comboAuthorModuleAnchors);
}
function populateLhsAnchors() {
    let array = [];
    $('._lhs').each((i,elt) => {
        let id = $(elt).attr('id');
        let title = $(elt).attr('title');
        addAnchorLinkToArray(array, id, title);
    })
    let target = $('#anchorLhsLinksDiv');
    populateAnchors(target, array);
}
function populateRhsAnchors(makeHeader) {
    let array = [];
    $('._rhs').each((i,elt) => {
        let id = $(elt).attr('id');
        let title = $(elt).attr('title');
        addAnchorLinkToArray(array, id, title);
    })
    let target = $('#anchorRhsLinksDiv');
    populateAnchors(target, array);

    if (makeHeader) {
        let rhsHeader = $('<div></div>');
        $('#anchorLinksDiv').prepend(rhsHeader);
        let generalReference = createAnchorElement(`${gPerson.giLastName}'s Networks`,
            '#theirNetworkDiv', gCommon.showXsSmallHideOthers);
        divEltTo(generalReference, rhsHeader);
    }
}
function getValFromPropertyLabel(jsonArray, propertyKey, valKey) {
    let property = jsonArray.find(p => p.PropertyLabel == propertyKey);
    let result = gCommon.NA;

    if (property && property[valKey]) {
        result = property[valKey];
    }
    return result;
}
function getMainModuleRow() {
    return $('#mainDiv').find('.row.modulesRow');
}

function innerCurtainsDown(targetToHide, targetForMsg, messageOnly) {
    if (!targetForMsg) {
        targetForMsg = targetToHide;
    }
    if (!messageOnly) {
        targetToHide.addClass("d-none");
    }

    $(targetForMsg[0]).after($('<div class="loadInProgress">Loading</div>'));
}
function innerCurtainsUp(target) {
    $('.loadInProgress').remove();

    target.removeClass("d-none");
    unHideFooter();
}
function initialCurtainsDown() {
    //$('body').prepend($('<div class="loadInProgress">Loading</div>'));

    $('.moveable').addClass("d-none");
    $('.brandingBanner').addClass("d-none");
    $('.topOfPageItems').addClass("d-none");
}
function initialCurtainsUp() {
    $('.loadInProgress').remove();

    $('.moveable').removeClass("d-none");
    $('.brandingBanner').removeClass("d-none");
    $('.topOfPageItems').removeClass("d-none");

    $('#main-data-container').removeClass("d-none");
}
function initialCap(string) {
    // https://stackoverflow.com/questions/18379254/regex-to-split-camel-case
    let result = string.replace(/^./, function(str){ return str.toUpperCase(); });
    return result;
}