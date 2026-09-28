
async function setupMentorPage(pageTitle) {
    let [json] = await commonSetupWithJson();
    let data = json[0].ModuleData;

    let target = $('#modules-left-div');
    $('#modules-right-div').remove(); // just one (AKA 'left') side for this page

    emitPageTitle(target, pageTitle);

    return [target, data];
}

async function setupMentorCompleted() {
    let [target, data] = await setupMentorPage('Completed Student Project');
    emitCompletedProject(target, data);
}
async function setupMentorCurrent() {
    let [target, data] = await setupMentorPage('Current Student Opportunity');

    emitCurrentProject(target, data);
}

function emitCurrentProject(target, data) {
    emitProjectTitle(target, data, true);
    emitProjectInfo(target, data, true);
    emitProjectBlurb(target, data);
    emitProjectMentor(target, data);
}
function emitCompletedProject(target, data) {
    emitProjectTitle(target, data);
    emitProjectInfo(target, data);
    emitProjectMentor(target, data);
}
function emitProjectMentor(target, data) {
    let advisor = getValFromPropertyLabel(data, 'advisor', 'Value');
    let url = getValFromPropertyLabel(data, 'advisor', 'URL');

    let a = createAnchorElement(advisor, url);
    let mentorDiv = divSpanifyTo('Mentor: ', target);
    mentorDiv.append(a);
}
function emitProjectInfo(target, data, currentVsComplete) {
    let start = getValFromPropertyLabel(data, 'start date', 'Value');
    let end = getValFromPropertyLabel(data, 'end date', 'Value');

    start = dateStringToMDY_nums(start);
    end = dateStringToMDY_nums(end);

    let content = currentVsComplete ?
        `Available: ${start}. Expires: ${end}` :
        `${start} - ${end}`;

    divSpanifyTo(content, target);
}
function emitProjectBlurb(target, data) {
    let blurb = getValFromPropertyLabel(data, 'overview', 'Value');

    divSpanifyTo(blurb, target, "", 'mt-2 mb-2');
}
function emitProjectTitle(target, data, currentVsComplete) {
    let label = getValFromPropertyLabel(data, 'label', 'Value');

    let contentSpan;
    if (currentVsComplete) {
        let url = getValFromPropertyLabel(data, 'webpage', 'Value');
        let a = createAnchorElement(label, url);
        contentSpan = $('<span> [login at prompt]</span>');
        contentSpan.prepend(a);
    }
    else {
        contentSpan = spanify(label);
    }

    divEltTo(contentSpan, target);

}
function emitPageTitle(target, title) {
    let titleDiv = $(`<div class="page-title mt-2 mb-3">${title}</div>`);
    target.append(titleDiv);
}

