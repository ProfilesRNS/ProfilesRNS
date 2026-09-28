function setupParseResultAndOverallResultDivs(moduleJson, moduleTitle, miscInfo) {
    let parseResultDiv = $('<div></div>');
    let overallResultDiv = parseResultDiv;

    if (miscInfo.bannerText) { // banner iff it's inner
        let innerAccordionInfo = makeAccordionDiv(moduleTitle, miscInfo.bannerText, AccordionNestingOption.Nested)
        parseResultDiv = innerAccordionInfo.payload;
        overallResultDiv = innerAccordionInfo.outerDiv
    }
    return [parseResultDiv, overallResultDiv];
}
function teaserDefaultParser(json, moduleTitle, miscInfo, explicitTarget, teaser) {
    let payloadDiv = getTargetUntentavizeIfSo(moduleTitle, explicitTarget);
    let resultDiv = defaultLeftSideParser(json, moduleTitle, miscInfo);
    payloadDiv.append(`<div><h4>${teaser}</h4></div>`);
    payloadDiv.append(resultDiv);
    return payloadDiv;
}
function defaultLeftSideParser(moduleJson, moduleTitle, miscInfo, teaser) {
    let [parseResultDiv, overallResultDiv] =
        setupParseResultAndOverallResultDivs(moduleJson, moduleTitle, miscInfo);

    if (teaser) {
        parseResultDiv.append(`<div><h2>${teaser}</h2></div>`)
    }
    let thisIsWhereDiv = $(`<div class="bold green">
        The following data (if any) is what we will display (nicely) for Module: ${moduleTitle}</div>`)
    parseResultDiv.append(thisIsWhereDiv);

    displayJsonFragment(parseResultDiv, moduleJson);

    return overallResultDiv;
}
function setupImgBigSmallAndLabel(target, rowId) {
    let colSpecsComplete = [
        newColumnSpec(`${gCommon.cols6or12} mediaDiv`),
        newColumnSpec(`${gCommon.cols6or12} thumbsDiv`)
    ];
    let completeRow = makeRowWithColumns(target, rowId, colSpecsComplete, `mt-2`);
    let lhSide = completeRow.find(`#${rowId}Col0`);
    let rhSide = completeRow.find(`#${rowId}Col1`);

    // 'axe tool': accessibility
    lhSide.attr('tabindex', '0');
    rhSide.attr('tabindex', '0');

    return [lhSide, rhSide];
}
function fillInBigSmallLabel(iframe, thumbImg, label, i, lhs, rhs, mediaClass) {
    lhs.append(iframe);

    let colSpecsRhs = [
        newColumnSpec(`${gCommon.cols5or12}`, thumbImg),
        newColumnSpec(`${gCommon.cols7or12} pt-2`, label)
    ];

    let rhsInnerRow = makeRowWithColumns(rhs, 'rhs-inner'+i, colSpecsRhs);
    rhs.append(rhsInnerRow);
    rhs.append($('<div class="mt-4"> </div>')); // mt-2, mb-2 in the 'real' divs don't do the trick for spacing

    thumbImg.on('click', function() {
        // https://stackoverflow.com/questions/15164942/stop-embedded-youtube-iframe
        $(`.${mediaClass}`).each(function(){
            let el_src = $(this).attr("src");
            $(this).attr("src",el_src);
        });
        $(`.${mediaClass}`).hide();
        iframe.show();
    });

    if (i != 0) {
        iframe.hide();
    }
}
function armTheTooltips() {
    // see https://stackoverflow.com/questions/67615880/tooltip-didnt-hide-after-click-on-element-bootstrap-v5-0
    $('[data-bs-toggle="tooltip"]').tooltip(); // enable BS tooltips
    $('[data-bs-toggle="tooltip"]').on('click', function () {
        $(this).tooltip('dispose');
    });
}
function pushStringSpan(targetArray, input,klass) {
    targetArray.push(spanify(input,klass));
}
function getAuthorNodeId() {
    return gCommon.authorId;
}
function initAuthorNodeId(json, name) {
    let labelData = findModuleDataByName(json, name);
    if (isArray(labelData)) { // argh! sometimes it's [0], sometimes direct
        labelData = labelData[0];
    }
    if (labelData.NodeID) { // argh! sometimes it's URL: /display/<id>
        gCommon.authorId = labelData.NodeID;
    }
    else {
        gCommon.authorId = labelData.URL.replace("/display/", "");
    }
}