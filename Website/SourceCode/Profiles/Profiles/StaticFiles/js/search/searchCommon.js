function searchPost(url, prefix, selections, resultPage) {
    console.log("Searching: ", selections);
    let stringCriteria = JSON.stringify(selections);

    console.log('--------stringCriteria for post----------');
    console.log(stringCriteria);

    $.post(url, stringCriteria, function(results) {
        if (isArray(results)
            && results.length == 1
            && results[0].ErrorMessage !== gCommon.undefined) {

            console.log(`Error message from back-end: "${results[0].ErrorMessage}"
                    \nFrom Post of: 
                    <${stringCriteria}>`);
        }
        else {
            let stringResults = JSON.stringify(results);
            let resultsKey = makeSearchResultsKey(prefix);
            // https://stackoverflow.com/questions/13734893/javascript-how-do-i-open-a-new-page-and-pass-json-data-to-it
            toSession(resultsKey, stringResults);
            window.location.href = resultPage;
        }
    });
}
function searchBodyStructure() {
    let lhsDiv = $('#lhsDiv');
    gSearch.lhsDiv = lhsDiv;

    let midDiv = $('#midDiv');
    let outerRhs = $('#rhsDiv');
    gSearch.rhsDiv = outerRhs;

    lhsDiv.addClass("col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 col-xxl-2 statsUpdates");
    midDiv.addClass("col-12 col-sm-12 col-md-8 col-lg-8 col-xl-8 col-xxl-8 ");
    outerRhs.addClass("col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ps-1");
}
function searchResultsBodyStructure() {
    let midDiv = $('#midDiv');
    let outerRhs = $('#rhsDiv');
    gSearch.rhsDiv = outerRhs;

    midDiv.addClass("col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 col-xxl-10 ");
    outerRhs.addClass("col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ps-1 pe-0");

    let innerRhsDiv = $('<div id="innerRhsDiv" class="p-2 searchCriteriaDiv"></div>');
    outerRhs.append(innerRhsDiv);
    gSearch.outerRhs = outerRhs;
}
function hideLiItems() {
    $('.li-item').hide();
    $('.ulDiv').show();
}
function harvestCheckedOptions(prefix) {
    let result = [];

    let elts = $(`.${prefix}`); // prefix also used as class
    elts.each((i,c) =>
    {
        if ($(c).is(':checked')) {
            result.push($(c).attr('value'));
        }
    } );

    return result;
}
function fromResultsOrInit(results, pathKeys, init) {
    let candidateAtEoPath;

    if (typeof results !== 'undefined') {
        candidateAtEoPath = results;
        for (let i=0; i<pathKeys.length; i++) {
            let key = pathKeys[i];
            if ( typeof candidateAtEoPath[key] === 'undefined') {
                candidateAtEoPath = init;
                break;
            }
            candidateAtEoPath = candidateAtEoPath[key];
        }
    }
    return candidateAtEoPath;
}
function addUpdateSearchQueryKey(results, key, value) {
    addUpdateSearchQuery(results.SearchQuery, key, value);
}
function addUpdateSearchQuery(searchQuery, key, value) {
    searchQuery[key] = value;
}
function collectMiscInitialPeopleSelections(selections) {
    // misc addition: foreshadowing sorting
    selections.Sort = "relevance";
    selections.SearchType = gSearch.people;
    initializePagingValues(selections, gPage.defaultPageSize, 1);
}
function initializePagingValues(selections, size, offset1) {
    selections.Count = size;
    selections.Offset = offset1;
}
function createWhyLink(item, results) {
    let whySpan = spanify('Why?', 'link-ish');
    whySpan.on('click', function() {
        searchWhy(item, results);
    })
    return whySpan;
}
function searchEverythingFn(searchInput, exactCheckbox) {

    let selections = collectKeywordSelections(searchInput, exactCheckbox);

    selections.SearchType = gSearch.allElse;

    // new search starts with 'All' filter
    addUpdateSearchQuery(selections, gSearch.currentFilterKey, gSearch.allFilterLabel);
    initializePagingValues(selections, gPage.defaultPageSize, 1);

    //alert(`Json (from everything tab): ${JSON.stringify(selections)}`);
    searchPost(
        gSearch.findEverythingElseUrl,
        gSearch.allElse,
        selections,
        g.profilesPath + "/search/?EverythingResults");
}
function searchWhy(item, results) {
    let whyUrl = gSearch.whyUrl;
    let searchQuery = results.SearchQuery;
    searchQuery.NodeID = item.NodeID;

    searchPost(
        whyUrl,
        'Why',
        searchQuery,
        g.profilesPath + "/search/?WhyResults");
}
function collectKeywordSelections(searchInput, exactCheckbox) {
    let selections = {};
    selections.Keyword = searchInput.val();
    if (exactCheckbox) {
        selections.KeywordExact = exactCheckbox.is(':checked');
    } else {
        selections.KeywordExact = false;
    }

    return selections;
}
function makeSearchResultsKey(prefix) {
    return `search${initialCapital(prefix)}ResultsKey`;
}
function minimalPeopleSearchByTerm(term) {
    let selections = {};
    selections.Keyword = term;
    selections.LastName = "";
    selections.FirstName = "";
    selections.InstitutionName = "";
    selections.DepartmentName = "";
    selections.FacultyTypeName = [];
    selections.OtherOptionsName = [];

    selections.KeywordExact = false;
    selections.DepartmentExcept = false;
    selections.InstitutionExcept = false;

    collectMiscInitialPeopleSelections(selections);

    searchPost(
        gSearch.findPeopleUrl,
        gSearch.people,
        selections,
        gSearch.peopleResultsUrl);
}
function minimalPeopleSearchByDept(institution, dept, deptName) {
    let selections = {};
    selections.Institution = institution;
    selections.Department = dept;
    selections.DepartmentName = deptName;
    selections.Keyword = "";
    selections.LastName = "";
    selections.FirstName = "";
    selections.InstitutionName = "";
    selections.FacultyTypeName = [];
    selections.OtherOptionsName = [];

    selections.KeywordExact = false;
    selections.DepartmentExcept = false;
    selections.InstitutionExcept = false;

    collectMiscInitialPeopleSelections(selections);

    searchPost(
        gSearch.findPeopleUrl,
        gSearch.people,
        selections,
        gSearch.peopleResultsUrl);
}
function emitCriteriaOnRhs(results, withWhy) {
    let target = $('#innerRhsDiv');

    let titleDiv = $('<div class="mb-1"></div>');
    target.empty();
    target.append(titleDiv);
    titleDiv.append(spanify('Search Criteria', 'bold'));

    let eltType = 'div';
    let klass = 'wrap';
    let addedBreaks = [];

    addedBreaks.push(addIfPresent({text: results.SearchQuery.Keyword,
        target: target, klass: klass, eltType: eltType}));
    addedBreaks.push(addIfPresent({text: results.SearchQuery.LastName,
        target: target, klass: klass, eltType: eltType}));
    addedBreaks.push(addIfPresent({text: results.SearchQuery.FirstName,
        target: target, klass: klass, eltType: eltType}));
    addedBreaks.push(addIfPresent({text: results.SearchQuery.InstitutionName,
        target: target, klass: klass, eltType: eltType, except: results.SearchQuery.InstitutionExcept}));
    addedBreaks.push(addIfPresent({text: results.SearchQuery.DepartmentName,
        target: target, klass: klass, eltType: eltType, except: results.SearchQuery.DepartmentExcept}));

    for (let whichDropdown of ['FacultyTypeName', 'OtherOptionsName']) {
        for (let item of results.SearchQuery[whichDropdown]) {
            addedBreaks.push(addIfPresent({text: item,
                target: target, klass: klass, eltType: eltType}));
        }
    }
    if (withWhy) {
        target.append($('<hr class="tightHr"/>'));
        divSpanifyTo('Click "Why?" to see why a person matched the search.',
            target, 'fs12');
    }
}
function emitTitle(target, title) {
    setTabTitleAndOrFavicon(title);
    let titleSpan = $(`<div class="row page-title mt-3">${title}</div>`);
    target.prepend(titleSpan);
}
function emitLinkTo(target, linkText, url, leftVsRight) {
    let direction = leftVsRight ? "Left" : "Right";
    let arrow = $(`<img src="${gBrandingConstants.jsSearchImageFiles}arrow${direction}.png" 
                             alt="arrow${direction}" class="me-1"/>`);
    let toAnchor = createAnchorElement(linkText, url);
    let anchorDiv = $('<div class="d-flex justify-content-end"></div>');

    anchorDiv.append(arrow).append(toAnchor);
    target.append(anchorDiv);
}
function emitSearchResultCountAndRelatedLinks(
                                    results,
                                    url,
                                    backText,
                                    count,
                                    insertBeforeId) {
    let target = $('#midDiv');

    let countDetail = (typeof count !== gCommon.undefined) ? ` (${count})` : "";
    let titleContent = `Search Results Details${countDetail}`;

    emitTitle(target, titleContent);

    let beforeTarget = $('<div id="beforeResults"></div>');
    beforeTarget.insertBefore($(`#${insertBeforeId}`));
    emitLinkTo(beforeTarget, backText, url, true);
}
function addIfPresent(options) {
    let text   = options.text   ;
    let target = options.target ;
    let klass  = options.klass  ;
    let except = options.except ;
    let eltType = options.eltType ;
    let noBreak = options.noBreak ;

    let maybeAddedBreak = '';

    if (typeof text !== gCommon.undefined && text) {
        if (!eltType) {
            eltType = 'span';
        }
        let elt = $(`<${eltType} class="${klass}"></${eltType}>`);
        target.append(elt);

        if (except) {
            text = `(Except) ${text}`;
        }
        maybeAddedBreak = noBreak ? '' : $('<br/>');
        elt.html(text);
        if (maybeAddedBreak) {
            elt.append(maybeAddedBreak);
        }
    }
    return maybeAddedBreak;
}
function activityUrlFromSchema(urlSchema, desiredCount, lastId) {
    let result = urlSchema
        .replace(gCommon.schemaPlaceholder, desiredCount)
        .replace(gCommon.schemaPlaceholder2, lastId);
    return result;
}
function dropdownVisibilityAdjustToOverlaps() {
    $('.ulDiv li').on('click', function(e) {
        $(e.target).closest('.ulDiv').show();
        let targetPositionString = $(e.target).closest('.ulDiv').attr('position');
        let targetPosition = Number(targetPositionString);
        $('.ulDiv').each(function() {
            let that = $(this);
            let positionString = that.attr('position');
            let position = Number(positionString);
            if (position > targetPosition) {
                that.hide();
            }
        })
    });
}
