
async function setupSearchForm() {

    let data = await getJsonData(gSearch.searchFormParamsUrl);
    gSearch.formData = data;
    console.log("========> formData", data);

    await setupPageStub(searchBodyStructure);
    setTabTitleAndOrFavicon(`Search`);

    let mainDiv = $('#mainDiv');
    mainDiv.addClass(gCommon.mainDivClasses);
    moveContentByIdTo("searchPageMarkup", mainDiv);

    let searchPageMarkup = $('#searchPageMarkup');
    innerCurtainsDown(searchPageMarkup);

    setupRightAndLeftSides();

    // now mid-section
    gSearch.midSectionColspecs = [
        newColumnSpec(`${gCommon.cols3or12} d-flex justify-content-end pt-1 searchLabel`),
        newColumnSpec(`${gCommon.cols5or12} d-flex justify-content-start`),
        newColumnSpec(`${gCommon.cols4or12} d-flex justify-content-start `)
    ];

    setupSearchSubmitAndNameSections();
    setupDropdowns();

    respectPriorCriteria(gSearch.people);
    respectPriorCriteria(gSearch.allElse);

    let searchType = tryMatchPathParam(`(/${gSearch.allElse})$`) ? gSearch.allElse : gSearch.people;
    console.log("searchTab: ", searchType);
    $(`#${searchType}-tab`).click();
   
    $("#allSearchButton").on('click', function () { $("#mainDiv").css("cursor", "progress"); });
    $("#peopleSearchButton").on('click', function () {
        $("#mainDiv").css("cursor", "progress");
    });
    $("#allElseSearchButton").on('click', function () { $("#mainDiv").css("cursor", "progress"); });

    innerCurtainsUp(searchPageMarkup);
}
function respectPriorCriteria(prefix) {
    let priorResultsKey = makeSearchResultsKey(prefix);
    let priorResults = JSON.parse(fromSession(priorResultsKey));

    // search input might come from session, or perhaps from traffic related to 'search other institutions'
    let searchInput = tryMatchPathParam(`(/${gDirect.searchFor})$`);
    let exactCheckbox = !! tryMatchPathParam(`(/${gDirect.exactPhrase})$`);

    if (priorResults && priorResults.SearchQuery) { // bullet-proofing, in case results were json error}
        searchInput = priorResults.SearchQuery.Keyword;
        exactCheckbox = priorResults.SearchQuery.KeywordExact;
        if (searchInput) {
            restoreText(`${prefix}SearchInput`, searchInput);
            restoreCheck(`${prefix}ExactCheckbox`, !! exactCheckbox);
        }

        if (prefix == gSearch.people) {
            let lnameInput = priorResults.SearchQuery.LastName;
            let fnameInput = priorResults.SearchQuery.FirstName;
            let institution = priorResults.SearchQuery.Institution;
            let institutionAllExcept = priorResults.SearchQuery.InstitutionExcept;
            let department = priorResults.SearchQuery.Department;
            let departmentAllExcept = priorResults.SearchQuery.DepartmentExcept;
            let facultyTypes = priorResults.SearchQuery.FacultyType;
            let otherOptions = priorResults.SearchQuery.OtherOptions;
            let profileContains = priorResults.SearchQuery.ProfileContains;

            restoreText('lnameInput', lnameInput);
            restoreText('fnameInput', fnameInput);

            restoreCheck('institutionsAllExceptCheck', institutionAllExcept);
            restoreCheck('departmentsAllExceptCheck', departmentAllExcept);

            let nodesToClick = [];
            pushForRestore(institution, nodesToClick);
            pushForRestore(department, nodesToClick);
            pushForRestore(facultyTypes, nodesToClick);
            pushForRestore(otherOptions, nodesToClick);
            pushForRestore(profileContains, nodesToClick);

            restoreDropdowns(nodesToClick);
        }
    }
}
function pushForRestore(candidate, target) {
    if (candidate) {
        // https://stackoverflow.com/questions/4059147/check-if-a-variable-is-a-string-in-javascript
        if (isArray(candidate)) {
            target.push(...candidate);
        }
        // https://stackoverflow.com/questions/767486/how-do-i-check-if-a-variable-is-an-array-in-javascript
        else if (typeof candidate === 'string') {
            target.push(candidate);
        }
    }
}
function restoreDropdowns(nodesToClick) {
    for (let i = 0; i < nodesToClick.length; i++) {
        let node = nodesToClick[i];
        if (node) {
            $(`#${node}`).closest('li').click();
        }
    }
    $('#dropbox2Col2').click(); // close the dropdowns by clicking outside
}
function restoreText(targetId, text) {
    if (text) {
        $(`#${targetId}`).val(text);
    }
}
function restoreCheck(targetId, checked) {
    if (checked) {
        $(`#${targetId}`).click();
    }
}
function emitMoreUpdatesLink(target) {
    let anchor = createAnchorElement(`<img src="${gBrandingConstants.jsSearchImageFiles}icon_squareArrow.gif" alt='squareArrow'/> See more updates`,
        gSearch.moreUpdatesUrl);

    let colspecs = [newColumnSpec(`${gCommon.cols12} ps-0 d-flex justify-content-start`,
        anchor)];
    let row = makeRowWithColumns(target, "moreUpdates", colspecs, "ms-0")

    target.append(row);
}

function setupRightAndLeftSides() {
    emitSidebarRecentUpdates();

    let mostTodayStr = 'MostViewedDay';
    let mostMonthStr = 'MostViewedMonth'
    gSearch.rhsDiv.addClass("t30s"); // but not added in corresponding results page
    gSearch.rhsDiv.append($(`<div id="${mostTodayStr}" class="bold mb-2 searchPassivePanel">Most viewed (today)</div>`));
    gSearch.rhsDiv.append($(`<hr class="tightHr"/>`));
    gSearch.rhsDiv.append($(`<div id="${mostMonthStr}" class="bold mt-2 searchPassivePanel">Most viewed (month)</div>`));

    emitMosts(mostTodayStr);
    emitMosts(mostMonthStr);
}
function emitMosts(whichMost) {
    if (gSearch.formData) { // bullet-proofing
        if (gSearch.formData[whichMost]) {
            let data = sortArrayViaSortLabel(gSearch.formData[whichMost], 'NumberOfQueries', true);
            let target = $(`#${whichMost}`);

            for (let i = 0; i < data.length; i++) {
                let item = data[i];
                let searchTerm = item.Phrase;
                let nameSpan = $(`<span class="link-ish unbold">${searchTerm}</span>`);
                nameSpan.on('click', function () {
                    minimalPeopleSearchByTerm(searchTerm);
                })
                let div = $('<div class="mt-1"></div>');
                div.append(nameSpan);
                target.append(div);
            }
        }
    }
}
function setupSearchSubmitAndNameSections() {
    setupOneSearchSubmitSection(
        gSearch.people,
        `<label for="peopleSearchInput" class="researchTopics">Research Topics</label>`,
        'Find People by Research Topic or Name',
        searchPeopleFn);

    setupOneSearchSubmitSection(
        gSearch.allElse,
        'Keywords',
        'Find Publications, Projects, Concepts and More',
        searchEverythingFn);
}

function collectNames(lnameInput, fnameInput, selections) {
    selections.LastName = lnameInput.val();
    selections.FirstName = fnameInput.val();
}
function searchPeopleFn(searchInput, exactCheckbox, lnameInput, fnameInput) {
    let selections = collectKeywordSelections(searchInput, exactCheckbox);
    collectNames(lnameInput, fnameInput, selections);

    collectDropdownSelections(selections);

    collectMiscInitialPeopleSelections(selections);

    //alert(`Json (from people tab): ${JSON.stringify(selections)}`);
    searchPost(
        gSearch.findPeopleUrl,
        gSearch.people,
        selections,
        g.profilesPath + "/search/?PersonResults");
}

function setupOneSearchSubmitSection(idPrefix, label, title, searchFn) {
    let outerTarget = $(`#${idPrefix}`);
    let boxTarget = $(`#${idPrefix}Box`);
    let rowId = `${idPrefix}1`;

    let titleDiv = $(`<div class="bigTitle mb-2">${title}</div>`);
    outerTarget.prepend(titleDiv);

    let row = makeRowWithColumns(boxTarget, rowId, gSearch.midSectionColspecs,  "pb-1 mt-0 mb-2");

    let searchInput = $(`<input id="${idPrefix}SearchInput" class="w-100 ps-2 inputSearch" type="search" aria-label="Search">`);
    let searchButton = $(`<img id="${idPrefix}SearchButton" src="${gBrandingConstants.jsSearchImageFiles}search.jpg" alt="Search">`);
    let exactCheckbox = $(`<input id="${idPrefix}ExactCheckbox" type="checkbox" aria-label="Exact match"/>`);
    // separate label for checkbox, so only precise clicks on box have effect
    let checkboxLabel = $(`<label class="ms-2 searchExactLabel"> Search for <b>exact</b> phrase</label>`);

    let checkboxSpan = $('<span></span>');
    checkboxSpan.append(exactCheckbox);
    checkboxSpan.append(checkboxLabel);

    row.find(`#${rowId}Col0`).html(label);
    row.find(`#${rowId}Col1`).append(searchInput);
    row.find(`#${rowId}Col2`).append(searchButton);

    rowId = `${idPrefix}2`;
    row = makeRowWithColumns(boxTarget, rowId, gSearch.midSectionColspecs,  "pb-1 mt-0 mb-2");
    row.find(`#${rowId}Col1`).append(checkboxSpan);

    let fname, lname; // undef for allElse, but present for people
    if (idPrefix == gSearch.people) {
        [lname, fname] = emitTwoNamesInput(boxTarget);
    }

    boxTarget.find('.inputSearch').on('keypress',function(e) {
        e.stopPropagation();

        if (e.which == 13) {
            searchFn(searchInput, exactCheckbox, lname, fname);
        }
    });
    searchButton.on('click', function() {
        searchFn(searchInput, exactCheckbox, lname, fname);
    });
}
function emitTwoNamesInput(target) {
    let rowId = `${gSearch.lnameInputSt}`;
    let row = makeRowWithColumns(target, rowId, gSearch.midSectionColspecs,  "pb-1 mt-0 mb-2");

    let lnameInput = $(`<input id="${gSearch.lnameInputSt}" class="w-100 inputSearch">`);
    row.find(`#${rowId}Col0`).html('<label for="lnameInput">Last Name</label>');
    row.find(`#${rowId}Col1`).append(lnameInput);

    rowId = `${gSearch.fnameInputSt}`;
    row = makeRowWithColumns(target, rowId, gSearch.midSectionColspecs,  "pb-1 mt-0 mb-2");

    let fnameInput = $(`<input id="${gSearch.fnameInputSt}" class="w-100 inputSearch">`);
    row.find(`#${rowId}Col0`).html('<label for="fnameInput">First Name</label>');
    row.find(`#${rowId}Col1`).append(fnameInput);

    return [lnameInput, fnameInput];
}

