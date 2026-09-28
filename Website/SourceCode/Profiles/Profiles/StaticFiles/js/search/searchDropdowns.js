function prepareDropdownData(data) {
    let result = [];
    let sortedOtherOptionsData = prepareTwoLevelOptionsData(data.OtherOptions);
    let sortedHasSectionsData = prepareTwoLevelOptionsData(data.HasSections);

    if (sortedOtherOptionsData && ! sortedOtherOptionsData.length) {
        $('#otherOptionsUlDiv').addClass('d-none');
    }
    if (sortedHasSectionsData && ! sortedHasSectionsData.length) {
        $('#hasSectionsUlDiv').addClass('d-none');
    }
    result.push ({
        label: 'Institution',
        prefix: 'institutions',
        displayProperty: "InstitutionName",
        singular: true,
        list: data.Institutions});
    result.push({
        label: 'Department',
        prefix: 'departments',
        displayProperty: "DepartmentName",
        singular: true,
        list: data.Departments});
    result.push({
        label: 'Faculty Type',
        prefix: 'facultyTypes',
        displayProperty: "FacultyRank",
        list: data.FacultyType,
        useMultiCheckbox: true});
    result.push({
        label: 'Profile Contains',
        prefix: 'hasSections',
        displayProperty: "PersonFilter",
        list: sortedHasSectionsData,
        useMultiCheckbox: true,
        categoryProperty: "PersonFilterCategory"});
    result.push({
        label: 'Other Options',
        prefix: 'otherOptions',
        displayProperty: "PersonFilter",
        list: sortedOtherOptionsData,
        useMultiCheckbox: true,
        categoryProperty: "PersonFilterCategory"});

    return result;
}
function prepareTwoLevelOptionsData(data) {
    let result = [];

    if (data) {
        let categories = sortArrayViaSortLabel(data, 'CategorySort');

        for (let i = 0; i < categories.length; i++) {
            let category = categories[i];
            let categoryName = category.PersonFilterCategory;
            let filters = sortArrayViaSortLabel(category.PersonFilters, "PersonFilterSort");
            for (let i = 0; i < filters.length; i++) {
                let filter = filters[i];
                let item = {
                    "NodeID": filter.NodeID,
                    "PersonFilter": filter.PersonFilter,
                    "PersonFilterCategory": categoryName,
                };
                result.push(item);
            }
        }
    }
    return result;
}

function adjustedSelections(dropdownPrefix, list) {
    gSearch[dropdownPrefix].rawSelections = list;
    gSearch[dropdownPrefix].selectedIndices = list;

    showSearchFilterSelections(dropdownPrefix);
}

// applicable only for Find People tab
function setupDropdowns() {

    let peoplePaneBox = $(`#${gSearch.people}Box`);
    
    peoplePaneBox.on('click', hideLiItems);

    let selectDataLists = prepareDropdownData(gSearch.formData);

    let dropdownsAndNames = $(`#dropdownsAndNames`);
    moveContentTo(dropdownsAndNames, peoplePaneBox);

    gSearch.dropdownPrefixes = [];
    gSearch.prefix2jsonLabel ={};
    gSearch.prefix2singular = {};

    for (let j=0; j<selectDataLists.length; j++) {
        let data = selectDataLists[j];

        let items = data.list;
        if (data.label == 'Department') {
            items = sortArrayViaSortLabel(items, "DepartmentName");
        }

        // no dropdown if no items to list!
        if ( ! items.length) {
            continue;
        }

        let displayProperty = data.displayProperty;

        let dropdownPrefix = data.prefix;
        gSearch[dropdownPrefix] = { items: items, displayProperty: displayProperty };
        gSearch.dropdownPrefixes.push(dropdownPrefix);
        gSearch.prefix2jsonLabel[dropdownPrefix] = data.label.replaceAll(" ", "");
        gSearch.prefix2singular[dropdownPrefix] = data.singular;

        let currentCategory = "";
        let categoryProperty = data.categoryProperty;
        let useMultiCheckbox = data.useMultiCheckbox;

        let ulDiv = $(`#${data.prefix}UlDiv`);

        let rowId = `dropbox${j}`;
        let row = makeRowWithColumns(dropdownsAndNames, rowId, gSearch.midSectionColspecs,  "pb-1 mt-0 mb-2");

        // https://stackoverflow.com/questions/56968976/creating-multiselect-checkbox
        let dropdownColumnLabel = row.find(`#${rowId}Col0`);
        let dropdownColumnOptions = row.find(`#${rowId}Col1`);
        let dropdownColumnCheckbox = row.find(`#${rowId}Col2`);

        dropdownColumnLabel.addClass("pt-1"); // tweak vertical
        dropdownColumnCheckbox.addClass("pt-2 dropdownCheckbox"); // tweak vertical

        moveContentTo(ulDiv, dropdownColumnOptions);
        dropdownColumnLabel.html(data.label);

        let ul = ulDiv.find('ul');
        let theChosen = ul.find('.theChosen');
        theChosen.html(gSearch.noneSt + gSearch.selectedSt);
        theChosen.parent().on('click', function(e) {
            e.stopPropagation();
            $(`.li-item:not(.${dropdownPrefix})`).hide();
            $(`.li-item.${dropdownPrefix}`).toggle();

            if ( ! $(`.li-item.${dropdownPrefix}`).is(':visible')) {
                setTimeout(function() {
                    $('.ulDiv').show();
                }, 10);
            }
        })

        // if no multi-checkboxes, then there are all-except checkboxes
        if ( ! data.useMultiCheckbox) {
            let allExceptCheckbox = $(`<input type="checkbox" class="allExceptCheck" id="${dropdownPrefix}AllExceptCheck" aria-label="All except"/>`);
            let label = $(`<label class="ms-2"> All <span class="bold">except</span> the one selected</label>`);

            // separate label - checkbox, so only precise clicks on box have effect
            dropdownColumnCheckbox.append(allExceptCheckbox);
            dropdownColumnCheckbox.append(label);

            gSearch[dropdownPrefix].allExceptCheckbox = allExceptCheckbox;

            let li = $(`<li class="dropdown-no-bullet ${dropdownPrefix} li-item">${gSearch.noneSt} ${gSearch.selectedSt}</li>`);
                li.on('click', function() {
                    adjustedSelections(dropdownPrefix, []);
                })
            ul.append(li);
        }

        gSearch[dropdownPrefix].rawSelections = []; // clean initial value
        gSearch[dropdownPrefix].selectedIndices = []; // clean initial value
        let numItems = items.length;
        for (let i = 0; i < numItems; i++) {
            let item = items[i];
            let nodeId = item.NodeID;

            if (categoryProperty) {
                let itemCategory = item[categoryProperty];
                if (itemCategory != currentCategory) {
                    currentCategory = itemCategory;
                    let catLi = $(`<li class="dropdown-no-bullet categoryDivider ${dropdownPrefix} li-item ps-3">${itemCategory}</li>`);
                    ul.append(catLi);
                }
            }

            let itemDisplay = item[displayProperty];
            let li = $(`<li id="${nodeId}" value="${i}" class="dropdown-no-bullet ${dropdownPrefix} li-item">${itemDisplay}</li>`);
            ul.append(li);
            if (data.singular) {
                li.on('click', function() {
                    adjustedSelections(dropdownPrefix, []);
                    ul.find('.theChosen').click();
                })
            }

            if (useMultiCheckbox) {
                let check = $(`<input id="${nodeId}" class="${dropdownPrefix} me-1" 
                                    type='checkbox'
                                    value="${i}"/>`);
                li.prepend(check);
                check.on('click', function(e) {
                    e.stopPropagation();
                    li.toggleClass('selected');
                    let selections =  harvestCheckedOptions(dropdownPrefix);
                    gSearch[dropdownPrefix].rawSelections = selections;
                    gSearch[dropdownPrefix].selectedIndices = selections;
                    showSearchFilterSelections(dropdownPrefix);
                });
                li.on('click', function(e) {
                    e.stopPropagation();
                    check.click();
                })
            }
            else {
                li.on('click', function(e) {
                    e.stopPropagation();

                    $(`li.${dropdownPrefix}`).removeClass('selected');

                    li.toggleClass('selected');

                    adjustedSelections(dropdownPrefix, [i]);
                });
            }
        }
    }
    hideLiItems();
    dropdownVisibilityAdjustToOverlaps();

    // tighten up selectDisplay box
    $('#hasSectionsUlDiv').find('.gradient').addClass('mt-1 pt-0 pb-0');
    $('#peopleBox').find('#dropbox4Row').addClass('mt-3');
}
function showSearchFilterSelections(dropdownPrefix, target) {
    let displayProperty = gSearch[dropdownPrefix].displayProperty;
    let selectedIndices = gSearch[dropdownPrefix].rawSelections;
    let items = gSearch[dropdownPrefix].items;

    if (! target) {
        let itemDiv = $(`#${dropdownPrefix}UlDiv`);
        target = itemDiv.find('.theChosen');
    }

    let list = selectedIndices.map(i => items[i][displayProperty]);
    let howMuch = list.length;
    let result = gSearch.selectedSt;
    let addEllipsis = false;

    if (howMuch == 0) {
        result = gSearch.noneSt + result;
    }
    else if (howMuch > 2) {
        result = howMuch + result;
    }
    else {
        let joinStr = `<span class="bold"> ${(dropdownPrefix == 'facultyTypes' ? 'or ' : 'and ')}</span>`;
        let truncateAt = 65;
        let fullResult = list.join(joinStr);
        let truncatedResult = fullResult.substring(0, truncateAt);
        if (fullResult != truncatedResult) {
            addEllipsis = true;
        }
        result = truncatedResult;
    }

    target.html(result);
    if (addEllipsis) {
        target.append($('<span class="bold">...</span>'))
    }
}
function indicesToItems(items, indices) {
    let result = indices.map(i => items[i]);
    return result;
}
function collectDropdownSelections(selections) {
    for (let dropdownPrefix of gSearch.dropdownPrefixes) {
        let items = gSearch[dropdownPrefix].items;

        let jsonNodeIDLabel = gSearch.prefix2jsonLabel[dropdownPrefix];
        let jsonNameLabel = jsonNodeIDLabel + 'Name';
        let singular = gSearch.prefix2singular[dropdownPrefix];

        let indices = gSearch[dropdownPrefix].selectedIndices;

        let selectedItems = indicesToItems(items, indices);
        let selectedNodeIDs = selectedItems.map(item => item.NodeID);
        let selectedNames = selectedItems.map(item => item[gSearch[dropdownPrefix].displayProperty]);
        if (singular) {
            selectedNodeIDs = selectedItems.length > 0 ? `${selectedNodeIDs[0]}` : '';
            selectedNames = selectedItems.length > 0 ? `${selectedNames[0]}` : '';
            let allExceptCheckbox = gSearch[dropdownPrefix].allExceptCheckbox;
            selections[`${jsonNodeIDLabel}Except`] = allExceptCheckbox.is(':checked');

            selections[jsonNodeIDLabel] = selectedNodeIDs;
            selections[jsonNameLabel] = selectedNames;
        }
        else {
            // post ProfileContains piggy-backed on OtherOptions
            if (jsonNodeIDLabel == "ProfileContains") {
                jsonNodeIDLabel = "OtherOptions";
                jsonNameLabel = "OtherOptionsName";
            }
            // in case we process ProfileContains before seeing OtherOptions
            if (!selections[jsonNodeIDLabel]) {
                selections[jsonNodeIDLabel] = [];
                selections[jsonNameLabel] = [];
            }
            selections[jsonNodeIDLabel] = selections[jsonNodeIDLabel].concat(selectedNodeIDs);
            selections[jsonNameLabel] = selections[jsonNameLabel].concat(selectedNames);
        }
    }
}