function mentorJobOpportunityParser(json, moduleTitle, miscInfo, explicitTarget) {
    let innerPayloadDiv = getTargetUntentavizeIfSo(moduleTitle, explicitTarget);

    if (gBrandingConstants.studentOpportunitiesNote) {
        let noteDiv = $(`<div class="mb-2 xxSmall bold">${gBrandingConstants.studentOpportunitiesNote}</div>`);
        innerPayloadDiv.append(noteDiv);
    }

    let list = $('<ol></ol>');
    innerPayloadDiv.append(list);

    for (let i=0; i<json.length; i++) {
        let elt = json[i];
        let li = $('<li class="mb-2"></li>');
        list.append(li);

        li.append($(`<div class="mb-2 bold">${elt.title}</div>`));
        li.append($(`<div class="mb-2">${elt.jobDescription}</div>`));

        let categories = prettyTruthyJobs(elt);

        let colSpecs = [
            newColumnSpec(gCommon.cols6or12, spanify(`Job Category: ${categories}`)),
            newColumnSpec(gCommon.cols6or12)
        ];
        let id = `mentorOpp-${i}`;
        let row = makeRowWithColumns(li, id, colSpecs, "ps-0");

        let url = elt.jobURL;
        if (url) {
            let anchor = createAnchorElement(elt.jobURL);
            row.find(`#${id}Col1`).append($('<span>Job URL: </span>')).append(anchor);
        }
    }
    return innerPayloadDiv;
}
function mentorOverviewParser(json, moduleTitle, miscInfo, explicitTarget) {
    let innerPayloadDiv = getTargetUntentavizeIfSo(moduleTitle, explicitTarget);

    emitMentorOverviewDisplay(json, innerPayloadDiv);
    return innerPayloadDiv;
}


