gEditProp.mentorJobOpportunities = [];

gEditProp.colSpecsJobOuterTwoCols = [
        newColumnSpec(`${gCommon.cols10or12} md_ebordE`),
        newColumnSpec(`${gCommon.cols2or12} d-flex justify-content-center align-items-center`)
];
gEditProp.colSpecsJobInnerTwoCols = [
        newColumnSpec(`${gCommon.cols5or12} wrap2`),
        newColumnSpec(`${gCommon.cols5or12} wrap2`)
];

function loadJobOpportunitiesDiv(target) {
    let div = $(`
        <div id="jobOpportunitiesOuterDiv">
            <div class="link-ish mt-2" id="createJobOppDiv"><span class="link-ish"><img id="createJobOppArrow" src="${gEditProp.rightArrow}"/></span>
                        Create New Job Opportunity</a>
            </div>
            <div id="jobOpportunityDetailsDiv" class="editPanel mt-2">
                <div class="moduleOptions">Enter the job opportunity information below:</div>
                <div class="inputLabel"><span class="red">*</span>Job Title</div>
                <div><input type="text" id="jobTitle" class="jobEditReq" aria-required="true"/></div>
                <div class="inputLabel"><span class="red">*</span>Job Description</div>
                <div><textarea rows="4" cols="40" id="jobDescription" class="jobEditReq" aria-required="true"></textarea></div>
                <div class="inputLabel">Job URL</div>
                <div><input type="text" id="jobURL" /></div>
                <div class="jobCategories mt-2" class="jobEditReq" aria-required="true">
                    <span class="inputLabel"><span class="red">*</span>Job Category</span>
                    <div class="mt-2">
                        <div class="ms-2"><input type="checkbox" id="students" class="jobEditReq /><span class="ms-1">Students</span></div>
                        <div class="ms-2"><input type="checkbox" id="faculty" class="jobEditReq /><span class="ms-1">Faculty</span></div>
 
                        <div class="ms-2"><input type="checkbox" id="fellowsAndPostDocs" class="jobEditReq /><span class="ms-1">Fellows and PostDocs</span></div>
                        <div class="ms-2"><input type="checkbox" id="researchStaff" class="jobEditReq /><span class="ms-1">Research Staff</span></div>
                    </div>
                </div>
                <div class="red mt-2"><span>*</span> indicates required field</div>
                <div><button class="link-ish mt-2 ps-0" id="saveJobOpp" disabled="true">Save</button>
                    <span class="pipe">|</span>
                    <button class="link-ish" id="cancelJobOppEdit">Cancel</button>
                </div>

            </div> <!-- jobOpportunityDetailsDiv -->
            <div id="moduleBody" class="container mt-2 ms-5">
                <div id="jobOpportunitiesDiv"></div>
            </div> <!-- moduleBody -->
        </div> <!-- jobOpportunitiesOuterDiv -->
    `);
    target.append(div);
    div.find('.jobEditReq').on('change', validateJobOpp);
}
function validateJobOpp() {
    let title =         $('#jobTitle').val()                       != '';
    let description =   $('#jobDescription').val()                  != '';
    let categories =    $('input[type="checkbox"]:checked').length  > 0;

    let valid = title && description && categories;

    $('#saveJobOpp').attr('disabled', valid ? false : true);
}
function emitJobOpportunities(jobOpportunities) {
    let numJobs = 0;

    if (Array.isArray(jobOpportunities)) {
        let jobOpportunitiesDiv = $('#jobOpportunitiesDiv');

        if (jobOpportunities.length != 0) {
            gEditProp.mentorJobOpportunities = jobOpportunities;
            numJobs = jobOpportunities.length;

            let rowId = 'jobOppHeader';
            let row = makeRowWithColumns(jobOpportunitiesDiv, rowId, gEditProp.colSpecsJobOuterTwoCols, 'ebordS ebordE ebordT ebordB topRow');
            row.find(`#${rowId}Col0`).append($(`<div>Job Opportunities</div>`));
            row.find(`#${rowId}Col1`).append($(`<div>Action</div>`));
        }
        else {
            jobOpportunitiesDiv.append("No job opportunities have been added.");
        }

        let numJobOpps = gEditProp.mentorJobOpportunities.length;
        for (let i=0; i<numJobOpps; i++) {
            let jobOpp = gEditProp.mentorJobOpportunities[i];

            let truthyJobCategories = prettyTruthyJobs(jobOpp);

            let oddEven = i%2 ? 'oddRow' : 'evenRow';

            let overallRowId = 'joRow2' + i;
            let overallRow = makeRowWithColumns(jobOpportunitiesDiv, overallRowId, gEditProp.colSpecsJobOuterTwoCols, oddEven + ' ebordS ebordE ebordB');
            let actionCol = createJobOppsActionColumn(i, jobOpp, numJobOpps);
            overallRow.find(`#${overallRowId}Col1`).append(actionCol);

            let jobTitleDiv = $(`<div class="bold">${i + 1}. ${jobOpp.title}</div>`);
            let jobDescDiv = $(`<div class="">${jobOpp.jobDescription}</div>`);
            let jobCategoryDiv = $(`<div class=""><span class="jobCategoryDisplayLabel">Job Category:</span>
                                        <span> ${truthyJobCategories}</span></div>`);

            let col0 = overallRow.find(`#${overallRowId}Col0`);
            col0.append(jobTitleDiv);
            col0.append(jobDescDiv);
            col0.append(jobCategoryDiv);

            let url = jobOpp.jobURL;
            if (url) {
                col0.append($(`<div class=""><span class="jobCategoryDisplayLabel">Job URL:</span> 
                                    <a target="_blank" rel="noopener noreferrer" href="${url}">${url}</a></div>`));
            }
        }
    }
    return numJobs;
}
function createJobOppsActionColumn(index, jobOpp, numJobOpps) {
    let editIcon = $(`<img alt="edit" src='${g.profilesRootURL}/edit/images/Icon_Edit.gif'/>`);
    let deleteIcon = $(`<img alt="delete" src='${g.profilesRootURL}/edit/images/Icon_delete.gif'/>`);

    let upIcon = $(`<img alt="up" src='${g.profilesRootURL}/edit/images/Icon_Up.gif'/>`);
    let downIcon = $(`<img alt="down" src='${g.profilesRootURL}/edit/images/Icon_Down.gif'/>`);
    let blankSpan = $(`<span class="w18"></span>`);

    let iconDiv = $(`<div class="ms-3 d-flex justify-content-end w-50">`);

    if (index > 0) {
        iconDiv.append(upIcon);
    }
    else {
        iconDiv.append(blankSpan);
    }

    if (index+1 < numJobOpps) {
        iconDiv.append(downIcon);
    }
    else {
        iconDiv.append(blankSpan);
    }

    iconDiv.append(editIcon)  ;
    iconDiv.append(deleteIcon);

    console.log('--------- oppId ---------', jobOpp.opportunityId);
    editIcon.on('click', function() {
        editJobOpportunity(jobOpp.opportunityId);
    });
    deleteIcon.on('click', function() {
        deleteJobOpportunity(jobOpp.opportunityId);
    });
    upIcon.on('click', function() {
        moveArrayItemUp(gEditProp.mentorJobOpportunities, index);
        saveAllJobOpportunities();
    });
    downIcon.on('click', function() {
        moveArrayItemDown(gEditProp.mentorJobOpportunities, index)
        saveAllJobOpportunities();
    });

    return iconDiv;
}

async function setupJobOpps(target) {
    loadJobOpportunitiesDiv(target);

    let subject = getSearchParam('subject');
    let url = gEditProp.getDataFunctionPrefix + subject + "&p=" + gEditProp.getJobOpportunitiesPrnsUrl;

    $('#jobOpportunityDetailsDiv').hide(); // at least initially
    $('#cancelJobOppEdit').on('click', clearAndCloseJobOpportunityForm);

    let numCurrentJobs = await getDataViaPost(url, emitJobOpportunities);
    await cardinalityPattern({
        createItemOverallDivId: 'createJobOppDiv',
        itemDetailsDivId:       'jobOpportunityDetailsDiv',
        currentItemsDivId:      'jobOpportunitiesDiv',
        togglingArrowImgId:     'createJobOppArrow',
        saveItemId:             'saveJobOpp',
        saveItemFn:             () => {saveJobOpportunity('')},
        createItemFn:           clearJobOpportunityForm,
        numItems:               numCurrentJobs }
    );
}
function cardinalityPattern(options) {
    // allow 'de-structuring' to tolerate options provided in any order
    let [createItemOverallDivId, itemDetailsDivId, currentItemsDivId,
            togglingArrowImgId, saveItemId, numItems] =
        [   options.createItemOverallDivId,
            options.itemDetailsDivId,
            options.currentItemsDivId,
            options.togglingArrowImgId,
            options.saveItemId,
            options.saveItemFn,
            options.createItemFn,
            options.numItems ];
    
    let maxCardinality = gEditProp.properties.maxCardinality;

    let currentItemsDiv = $(`#${currentItemsDivId}`);
    let createItemDiv = $(`#${createItemOverallDivId}`);
    let itemDetailsDiv = $(`#${itemDetailsDivId}`);
    let togglingArrowImg = $(`#${togglingArrowImgId}`);
    let saveItem = $(`#${saveItemId}`);

    if ( maxCardinality > 0 && numItems >= maxCardinality) {
        createItemDiv.remove();
        currentItemsDiv.addClass("mt-2"); // mind the gap
    }
    else {
        createItemDiv.on('click', function (e) {
            console.log('++++++++++++++++++++++++++++++ save will CREATE opp')
            options.createItemFn();
            saveItem.off('click').on('click', options.saveItemFn);
            toggleSrcIcon(togglingArrowImg, gEditProp.rightArrow, gEditProp.downArrow);
            visibilityFollowsArrow(itemDetailsDiv, togglingArrowImg, gEditProp.rightArrow)
        });
    }
}
function clearAndCloseJobOpportunityForm() {
    clearJobOpportunityForm();
    closeJobOpportunityForm();
}
function clearJobOpportunityForm() {
    // clear
    $("#jobTitle").val('');
    $("#jobDescription").val('');
    $("#jobURL").val('');
    $("#students").prop("checked", false);
    $("#faculty").prop("checked", false);
    $("#residentsAndFellows").prop("checked", false);
}
function closeJobOpportunityForm() {
    // close
    $("#jobOpportunityDetailsDiv").hide();
    $("#createJobOppArrow").attr('src', gEditProp.rightArrow);
}
function jobOpportunityInvalidities() {
    let validationMessages = [];
    let candidateUrl = $("#jobURL").val();
    if (candidateUrl && ! isValidURLRegex(candidateUrl)) {
        validationMessages.push('Please enter a URL, e.g., starting with http:// or https://');
    }
    return validationMessages;
}
function saveJobOpportunity(opportunityId) {
    let invalidities = jobOpportunityInvalidities();
    if (invalidities.length) {
        alert(invalidities.join('\n'));
        return;
    }

    if (gEditProp.mentorJobOpportunities.length != 0 && gEditProp.mentorJobOpportunities.find(x => x.opportunityId == opportunityId) != undefined) {
        //edit existing 

        const indexToEdit = gEditProp.mentorJobOpportunities.findIndex(x => x.opportunityId == opportunityId);
        gEditProp.mentorJobOpportunities[indexToEdit].title = $("#jobTitle").val();
        gEditProp.mentorJobOpportunities[indexToEdit].jobDescription = $("#jobDescription").val();
        gEditProp.mentorJobOpportunities[indexToEdit].jobURL = $("#jobURL").val();
        gEditProp.mentorJobOpportunities[indexToEdit].categoryStudents = $("#students").prop("checked");
        gEditProp.mentorJobOpportunities[indexToEdit].categoryFaculty = $("#faculty").prop("checked");
        gEditProp.mentorJobOpportunities[indexToEdit].categoryFellowsAndPostDocs = $("#fellowsAndPostDocs").prop("checked");
        gEditProp.mentorJobOpportunities[indexToEdit].categoryResearchStaff = $("#researchStaff").prop("checked");

    } else {
        //add new
        opportunityId = crypto.randomUUID();
        let jobOpportunity = {};
        jobOpportunity.opportunityId = opportunityId;
        jobOpportunity.title = $("#jobTitle").val();
        jobOpportunity.jobDescription = $("#jobDescription").val();
        jobOpportunity.jobURL = $("#jobURL").val();
        jobOpportunity.categoryStudents = $("#students").prop("checked");
        jobOpportunity.categoryFaculty = $("#faculty").prop("checked");
        jobOpportunity.categoryFellowsAndPostDocs = $("#fellowsAndPostDocs").prop("checked");
        jobOpportunity.categoryResearchStaff = $("#researchStaff").prop("checked");

        gEditProp.mentorJobOpportunities.push(jobOpportunity);
    }
    saveAllJobOpportunities();
}
function saveAllJobOpportunities() {
    let searchParams = window.location.search;
    const urlParams = new URLSearchParams(searchParams);

    let subject = urlParams.get('subject');
    let url = gEditProp.addUpdateDataFunctionPrefix + subject +  "&p=" + gEditProp.getJobOpportunitiesPrnsUrl;
    editSaveViaPost(url, gEditProp.mentorJobOpportunities);
}
function loadJobOpportunity(jobOpportunity) {
    $("#jobTitle").val(jobOpportunity.title);
    $("#jobDescription").val(jobOpportunity.jobDescription);
    $("#jobURL").val(jobOpportunity.jobURL);
    $("#students").prop("checked", jobOpportunity.categoryStudents);
    $("#faculty").prop("checked", jobOpportunity.categoryFaculty);
    $("#fellowsAndPostDocs").prop("checked", jobOpportunity.categoryFellowsAndPostDocs);
    $("#researchStaff").prop("checked", jobOpportunity.categoryResearchStaff);
    return true;

}
function prettyTruthyJobs(jobOpp) {
    function prettyJobCategory(category) {
        // handles single-word categories
        let result = category.replace('category', '');

        // break up multi-word categories
        if (result == 'FellowsAndPostDocs') {
            result = "Fellows and PostDocs";
        }
        if (result == 'ResearchStaff') {
            result = "Research Staff";
        }
        return result;
    }

    let truthyJobCategories = Object.keys(jobOpp)
        .filter(k => k.match(/^category/) && jobOpp[k])
        .map(k => prettyJobCategory(k));

    return truthyJobCategories.join(', ');
}
function maybePushPrettyJobCategory(array, jobOpp) {
    if (jobOpp.categoryStudents          ) {
        array.push("Students");
    }
    if (jobOpp.categoryFaculty           ) {
        array.push("Faculty");
    }
    if (jobOpp.categoryFellowsAndPostDocs) {
        array.push("Fellows and PostDocs");
    }
    if (jobOpp.categoryResearchStaff     ) {
        array.push("Research Staff");
    }

}
function editJobOpportunity(opportunityId) {
    closeJobOpportunityForm(); // eg, if in midst of creation
    let div = $("#jobOpportunityDetailsDiv")
    div.show();
    let jobOpportunity = gEditProp.mentorJobOpportunities.find(x => x.opportunityId == opportunityId);
    console.log('++++++++++++++++++++++++++++++ save will UPDATE opp')
    $("#saveJobOpp").off('click').on('click', function() {
        saveJobOpportunity(opportunityId);
    });
    loadJobOpportunity(jobOpportunity);
    validateJobOpp();
}
function deleteJobOpportunity(opportunityId) {

    gEditProp.mentorJobOpportunities = gEditProp.mentorJobOpportunities.filter(x => x.opportunityId != opportunityId);

    let searchParams = window.location.search;
    const urlParams = new URLSearchParams(searchParams);
    let subject = urlParams.get('subject');

    let url = gEditProp.addUpdateDataFunctionPrefix + subject +  "&p=" + gEditProp.getJobOpportunitiesPrnsUrl;

    editSaveViaPost(url, gEditProp.mentorJobOpportunities);
}