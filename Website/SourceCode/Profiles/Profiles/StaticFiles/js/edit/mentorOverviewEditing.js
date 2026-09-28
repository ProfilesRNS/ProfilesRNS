gEditProp.mentorJobOpportunities = [];

function loadMentorOverviewDiv(target) {
    let div = $(`
    <div id="mentoringOverviewOuterDiv">
        <div id="mentoringDisplayEmpty" class="mentoringAlternateDivs mt-2 d-none">
<!--            <h2>display empty</h2>-->
            <a class="editMentorOverview mt-2"><span class="link-ish">
                <img src="${gEditProp.rightArrow}"/> Create Mentoring Overview</span>
            </a>
            <div class="mt-1 ms-5">No overview has been added.</div>
        </div>
        <div id="mentoringDisplayNonempty" class="mentoringAlternateDivs container d-none">
<!--              <h2>display non-empty</h2>-->
            <div class="row topRow ebordS ebordE ebordT mt-2 mt-2">
                <div class="${gCommon.cols10or12} ebordE">Mentoring Overview</div>
                <div class="${gCommon.cols2or12}" id="mentorEditAction">Action</div>            
            </div>
           <div class="row ebordT ebordS ebordE ebordB">
                <div class='${gCommon.cols10or12} ebordE'>
                    <div class="mt-2 ms-2 displayInner"></div>
                </div>
                <div class='${gCommon.cols2or12} d-flex justify-content-center align-items-center'>
                   <button class="editMentorOverview link-ish"><img alt="edit" src='${g.profilesRootURL}/edit/images/Icon_Edit.gif'/></button>
                   <button class="deleteMentorOverview link-ish"><img alt="delete" src='${g.profilesRootURL}/edit/images/Icon_delete.gif'/></a></button>
                </div>
        </div>
        </div>
        <div id="mentoringEdit" class="editPanel mentoringAlternateDivs d-none">
<!--                            <h2>edit</h2>-->
                <div class="mt-1 ms-2">Enter mentor information below:</div>
                <div class="editPanel container mt-2 mb-2 pt-0">
                    <div>
                        <span id="makeBold" title="bold the selection" class="italics link-ish ms-2">B</span>
                        <span id="makeLink" title="link the selection" class="italics link-ish ms-4">Link</span>
                    </div>
                     <div id="linkDetails" class="editPanel bold">
                        <div>Text: <input id="linkText"/></div>
                        <div class="mt-2">URL: <input id="linkUrl"/></div>
                        <div class="mt-2">
                            <span id="makeLinkAdd" class="link-ish ms-2">Add</span>
                            <span id="makeLinkCancel" class="link-ish ms-2">Cancel</span>
                        </div>
                    </div>
                   <div class="row">
                        <div class="col-12 ps-1 pt-1"><textarea rows="8" id="mentoringOverviewText"></textarea></div>
                    </div>
                    
                    <div class="ms-1 mb-1">I'm available to mentor:</div>
                    <div class="ms-2"><input type="checkbox" id="studentsOnResearch" /> Students on Research</div>
                    <div class="ms-2"><input type="checkbox" id="studentsOnCareerDevelopment" /> Students on Career Development</div>
                    <div class="ms-2"><input type="checkbox" id="studentsOnWorkLifeBalance" /> Students on Work/Life Balance</div>
                    <div class="ms-2"><input type="checkbox" id="facultyOnResearch" /> Faculty on Research</div>
                    <div class="ms-2"><input type="checkbox" id="facultyOnCareerDevelopment" /> Faculty on Career Development</div>
                    <div class="ms-2"><input type="checkbox" id="facultyOnWorkLifeBalance" /> Faculty on Work/Life Balance</div>
                    <div class="ms-2"><input type="checkbox" id="residentsAndFellowsOnResearch" /> Residents and Fellows on Research</div>
                    <div class="ms-2"><input type="checkbox" id="residentsAndFellowsOnCareerDevelopment" /> Residents and Fellows on Career Development</div>
                    <div class="ms-2"><input type="checkbox" id="residentsAndFellowsOnWorkLifeBalance" /> Residents and Fellows on Work/Life Balance</div>
                    
                    <div>
                        <button class="cancelEdit link-ish">Cancel</a></button>
                        <span class="ms-1 me-1">|</span>
                        <button class="saveMentorOverview link-ish save">Save</a></button>                    
                    </div>
                </div>
            </div>
    </div>
    `);

    target.append(div);

    $('#mentoringOverviewText').css('width', '100%');

    $('#linkDetails').hide();
    $('#makeBold').on('click', function() {
        wrapTextInTextArea('mentoringOverviewText', "[b]", "[/b]");
    });
    $('#makeLink').on('click', function() {
        let text = getTextAreaSelection('mentoringOverviewText').selection;
        $('#linkDetails').show();
        $('#linkText').val(text);
        $('#linkUrl').val(text);
    });
    $('#makeLinkAdd').on('click', makeLinkAdd);
    $('#makeLinkCancel').on('click', makeLinkCancel);

    return div;
}

function makeLinkInvalidities(text, candidateUrl) {
    let validationMessages = [];
    if (! isValidURLRegex(candidateUrl)) {
        validationMessages.push('Please enter a URL, e.g., starting with http:// or https://');
    }
    if (!text) {
        validationMessages.push('Please text to display for this link');
    }
    return validationMessages;
}
function makeLinkAdd() {
    let text = $('#linkText').val();
    let url = $('#linkUrl').val();

    let invalidities = makeLinkInvalidities(text, url);
    if (invalidities.length) {
        alert(invalidities.join('\n'));
    }
    else {
        let replacement = `[url=${url}]${text}[/url]`;
        replaceTextAreaSelection('mentoringOverviewText', replacement);
        $('#linkDetails').hide();
    }
}
function makeLinkCancel() {
    $('#linkDetails').hide();
}
async function setupMentorOverview(target) {
    loadMentorOverviewDiv(target);

    let subject = getSearchParam('subject');
    let url = gEditProp.getDataFunctionPrefix + subject + "&p=" + gEditProp.getMentorOverviewPrnsUrl;

    let mentoringJson = await getDataViaPost(url, emitMentor);

    $('.deleteMentorOverview').on('click', confirmDeleteMentorOverview);
    $('.saveMentorOverview').on('click', saveMentorOverview);
    $('.cancelEdit').on('click', function() {
        setupMentorOverview(target)});
    $('.editMentorOverview').on('click', function() {
        emitMentorOverviewEdit(mentoringJson)});
}
function emitMentor(mentoringJson) {
    emitMentorOverviewDisplay(mentoringJson);
    return mentoringJson;
}
function getMentoringTextAndAreasFromJson(mentoringJson, truthy) {
    let areas = Object.keys(mentoringJson)
        .filter(a => a != 'text');
    if (truthy) {
        areas = areas.filter(a => mentoringJson[a] == true);
    }

    let text = mentoringJson.text ? restoreBoldLinks(mentoringJson.text)
                                : '';

    return [text, areas];
}
function mentoringIsEmpty(mentoringJson) {
    let [blurb, areas] = getMentoringTextAndAreasFromJson(mentoringJson, true);
    return ( ! blurb && ! areas.length);
}
function emitMentorOverviewDisplay(mentoringJson, target) {
    let innerTarget = target;

    if (! target) { // specific to edit module
        $('.mentoringAlternateDivs').hide();

        let displayFlavor = mentoringIsEmpty(mentoringJson) ? 'Empty' : 'Nonempty'
        target = $(`#mentoringDisplay${displayFlavor}`);
        target.removeClass('d-none');
        target.show();

        innerTarget = target.find('.displayInner');
        innerTarget.empty();

        if (displayFlavor == 'Empty') {
            return; // our work here is done for now
        }
    }

    // innerTarget.append($('<h2>display .displayInner of non empty</h2>'))
    let [blurb, areas] = getMentoringTextAndAreasFromJson(mentoringJson, true);

    // The textarea source of blurb may have newlines
    // We don't clutter the textarea itself with explicit '<br/>' (or [br]) tags
    blurb = blurb.replace(/\n/g, "<br/>");
    let blurbDiv = $(`<div class="mb-2">${blurb}</div>`);
    innerTarget.append(blurbDiv);

    if (areas.length) {
        innerTarget.append($('<div>Available to mentor:</div>'));
        let list = $('<ul></ul>');
        innerTarget.append(list);
        for (let area of areas) {
            // https://stackoverflow.com/questions/18379254/regex-to-split-camel-case
            area = area.replace(/([a-z])([A-Z])/g, '$1 $2')
                .replace(/ On /, " on ");
            area = initialCap(area);
            list.append($(`<li>${area}</li>`));
        }
    }
}
function emitMentorOverviewEdit(mentoringOverview) {
    let newVsUpdate = mentoringIsEmpty(mentoringOverview);

    $('.mentoringAlternateDivs').hide();
    $('#mentoringEdit').removeClass('d-none');
    $('#mentoringEdit').show();
    if (newVsUpdate) {
        $('#mentorEditEmpty').show();
    }
    else {
        $('#mentorEditNonempty').show();
    }

    $("#mentoringOverviewText").val(mentoringOverview.text);
    $("#studentsOnResearch").prop("checked", mentoringOverview.studentsOnResearch);
    $("#studentsOnCareerDevelopment").prop("checked", mentoringOverview.studentsOnCareerDevelopment);
    $("#studentsOnWorkLifeBalance").prop("checked", mentoringOverview.studentsOnWorkLifeBalance);
    $("#facultyOnResearch").prop("checked", mentoringOverview.facultyOnResearch);
    $("#facultyOnResearchProjects").prop("checked", mentoringOverview.facultyOnResearchProjects);
    $("#facultyOnCareerDevelopment").prop("checked", mentoringOverview.facultyOnCareerDevelopment);
    $("#facultyOnWorkLifeBalance").prop("checked", mentoringOverview.facultyOnWorkLifeBalance);
    $("#residentsAndFellowsOnResearch").prop("checked", mentoringOverview.residentsAndFellowsOnResearch);
    $("#residentsAndFellowsOnResearchProjects").prop("checked", mentoringOverview.residentsAndFellowsOnResearchProjects);
    $("#residentsAndFellowsOnCareerDevelopment").prop("checked", mentoringOverview.residentsAndFellowsOnCareerDevelopment);
    $("#residentsAndFellowsOnWorkLifeBalance").prop("checked", mentoringOverview.residentsAndFellowsOnWorkLifeBalance);
}
function confirmDeleteMentorOverview() {
    if (confirm("Are you sure you want to delete the Mentor information?")) {
        deleteMentorOverview();
    } else {
        // Code to run if the user clicks "Cancel" (No)
    }
}
function deleteMentorOverview() {
    $("#mentoringOverviewText").val("");
    $("#studentsOnResearch").prop("checked", false);
    $("#studentsOnCareerDevelopment").prop("checked", false);
    $("#studentsOnWorkLifeBalance").prop("checked", false);
    $("#facultyOnResearch").prop("checked", false);
    $("#facultyOnResearchProjects").prop("checked", false);
    $("#facultyOnCareerDevelopment").prop("checked", false);
    $("#facultyOnWorkLifeBalance").prop("checked", false);
    $("#residentsAndFellowsOnResearch").prop("checked", false);
    $("#residentsAndFellowsOnResearchProjects").prop("checked", false);
    $("#residentsAndFellowsOnCareerDevelopment").prop("checked", false);
    $("#residentsAndFellowsOnWorkLifeBalance").prop("checked", false);

    saveMentorOverview();
}
function saveMentorOverview() {
    let searchParams = window.location.search;
    let urlParams = new URLSearchParams(searchParams);
    let subject = urlParams.get('subject');
    let mentoringOverview = {};

    mentoringOverview.text = $("#mentoringOverviewText").val();
    mentoringOverview.studentsOnResearch = $("#studentsOnResearch").prop("checked");
    mentoringOverview.studentsOnCareerDevelopment = $("#studentsOnCareerDevelopment").prop("checked");
    mentoringOverview.studentsOnWorkLifeBalance = $("#studentsOnWorkLifeBalance").prop("checked");
    mentoringOverview.facultyOnResearch = $("#facultyOnResearch").prop("checked");
    mentoringOverview.facultyOnResearchProjects = $("#facultyOnResearchProjects").prop("checked");
    mentoringOverview.facultyOnCareerDevelopment = $("#facultyOnCareerDevelopment").prop("checked");
    mentoringOverview.facultyOnWorkLifeBalance = $("#facultyOnWorkLifeBalance").prop("checked");
    mentoringOverview.residentsAndFellowsOnResearch = $("#residentsAndFellowsOnResearch").prop("checked");
    mentoringOverview.residentsAndFellowsOnResearchProjects = $("#residentsAndFellowsOnResearchProjects").prop("checked");
    mentoringOverview.residentsAndFellowsOnCareerDevelopment = $("#residentsAndFellowsOnCareerDevelopment").prop("checked");
    mentoringOverview.residentsAndFellowsOnWorkLifeBalance = $("#residentsAndFellowsOnWorkLifeBalance").prop("checked");
    let url = gEditProp.addUpdateDataFunctionPrefix + subject + "&p=" + gEditProp.getMentorOverviewPrnsUrl;

    editSaveViaPost(url, mentoringOverview);
}
