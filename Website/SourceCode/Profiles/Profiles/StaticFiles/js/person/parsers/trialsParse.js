
function trialsParser(json, moduleTitle, miscInfo, explicitTarget) {
    let innerPayloadDiv = getTargetUntentavizeIfSo(moduleTitle, explicitTarget);

    let numTrials = json.length;
    if (numTrials) {
        let colSpecsWide = [
            newColumnSpec(`${gCommon.cols1} trials-wide bold`),
            newColumnSpec(`${gCommon.cols3} trials-wide bold`, spanify('NCT')),
            newColumnSpec(`${gCommon.cols3} trials-wide bold`, spanify(`Short Title`)),
            newColumnSpec(`${gCommon.cols2} trials-wide bold`, spanify(`Overall Status`)),
            newColumnSpec(`${gCommon.cols1} trials-wide bold`, spanify(`Start`)),
            newColumnSpec(`${gCommon.cols2} trials-wide bold`, spanify(`Completion`))
        ];
        let wideDiv = $(`<div class="${gCommon.hideXsSmallShowOthers}"></div>`);
        innerPayloadDiv.append(wideDiv);

        makeRowWithColumns(wideDiv, `trials-wide-top`, colSpecsWide);
        innerPayloadDiv.append($('<hr class="thick2"/>'));

        for (let i = 0; i < numTrials; i++) {
            emitOneWideTrial(i, numTrials, json[i], innerPayloadDiv);
            emitOneNarrowTrial(i, numTrials, json[i], innerPayloadDiv);

            if (i < numTrials-1) {
                innerPayloadDiv.append($('<hr>'));
            }
        }
    }
}
function emitOneWideTrial(i, numTrials, elt, target) {
    let displayDiv = $(`<div class="${gCommon.hideXsSmallShowOthers}"></div>`);
    target.append(displayDiv);

    let start = yyyyDashMmDashDdStarTo(elt.start_date, fromMatchToMmmDdYyyy);
    let end = yyyyDashMmDashDdStarTo(elt.completion_date, fromMatchToMmmDdYyyy);

    let colSpecsWide = [
        newColumnSpec(`${gCommon.cols1} trials-wide trials-dots`, '...'),
        newColumnSpec(`${gCommon.cols3} trials-wide`, spanify(`${elt.ClinicalTrialID} (url: ${gCommon.NA})`)),
        newColumnSpec(`${gCommon.cols3} trials-wide`, spanify(`${elt.Brief_title}`)),
        newColumnSpec(`${gCommon.cols2} trials-wide`, spanify(`${elt.overall_status}`)),
        newColumnSpec(`${gCommon.cols1} trials-wide`, spanify(`${start}`)),
        newColumnSpec(`${gCommon.cols2} trials-wide`, spanify(`${end}`))
    ];
    let rowWide = makeRowWithColumns(displayDiv, `trials-wide${i}`, colSpecsWide);

    let togglingDiv = $(`<div class="toggle-div toggle-${i} trials-wide d-none" id="tr-toggle-wide${i}"></div>`);
    togglingDiv.append($('<hr>'));
    displayDiv.append(togglingDiv);

    displayDiv.find(`#tr-toggle-wide${i}`).hide();

    let conditions = elt.Conditions.map(c => c.Condition);
    let conditionsDiv = $('<div></div>');
    for (let j=0; j<conditions.length; j++) {
        let condition = conditions[j];
        conditionsDiv.append($(`<div>${condition}</div>`)); // each condition goes to conditionDiv
    }
    colSpecsWide = [
        newColumnSpec(`${gCommon.cols1}`),
        newColumnSpec(`${gCommon.cols2}`, spanify('<b>Condition</b>')),
        newColumnSpec(`${gCommon.cols9} ps-5`, conditionsDiv)
    ];
    makeRowWithColumns(togglingDiv, `tr-details1-wide-${i}`, colSpecsWide, `tr-details-${i} mb2i`);

    let interventions = elt.Interventions.map(n => n.InterventionName);
    let interventionsDiv = $('<div></div>');
    for (let j=0; j<interventions.length; j++) {
        let intervention = interventions[j];
        interventionsDiv.append($(`<div>${intervention}</div>`)); // each intervention goes to conditionDiv
    }
    colSpecsWide = [
        newColumnSpec(`${gCommon.cols1}`),
        newColumnSpec(`${gCommon.cols2}`, spanify('<b>Intervention</b>')),
        newColumnSpec(`${gCommon.cols9} ps-5`, interventionsDiv)
    ];
    makeRowWithColumns(togglingDiv, `tr-details2-wide${i}`, colSpecsWide, `tr-details-${i} mb2i`);

    colSpecsWide = [
        newColumnSpec(`${gCommon.cols1}`),
        newColumnSpec(`${gCommon.cols2}`, spanify('<b>Phase</b>')),
        newColumnSpec(`${gCommon.cols9} ps-5`, spanify(`${elt.Phase}`))
    ];
    makeRowWithColumns(togglingDiv, `tr-details3-wide${i}`, colSpecsWide, `tr-details-${i}`);

    let dots = rowWide.find('.trials-dots');

    setupTrialToggleDots(dots, displayDiv, i);
}
function emitOneNarrowTrial(i, numTrials, elt, target) {
    let displayDiv = $(`<div class="${gCommon.showXsSmallHideOthers}"></div>`);
    target.append(displayDiv);

    let start = yyyyDashMmDashDdStarTo(elt.start_date, fromMatchToMmmDdYyyy);
    let end = yyyyDashMmDashDdStarTo(elt.completion_date, fromMatchToMmmDdYyyy);

    let colSpecsNarrow = [
        newColumnSpec(`${gCommon.cols12} trials-narrow`, spanify(`NCT: ${elt.ClinicalTrialID} (url: ${gCommon.NA})`)),
        newColumnSpec(`${gCommon.cols12} trials-narrow`, spanify(`Short Title: ${elt.Brief_title}`)),
        newColumnSpec(`${gCommon.cols12} trials-narrow`, spanify(`Status: ${elt.overall_status}`)),
        newColumnSpec(`${gCommon.cols12} trials-narrow`, spanify(`Start: ${start}`)),
        newColumnSpec(`${gCommon.cols12} trials-narrow`, spanify(`Completion: ${end}`)),
        newColumnSpec(`${gCommon.cols12} trials-narrow trials-dots`, spanify('...'))
    ];
    let rowNarrow = makeRowWithColumns(displayDiv, `trials-narrow${i}`, colSpecsNarrow);

    let togglingDiv = $(`<div class="toggle-div toggle-${i} trials-narrow d-none" id="tr-toggle-narrow${i}"></div>`);
    togglingDiv.append($('<hr>'));
    displayDiv.append(togglingDiv);

    displayDiv.find(`#tr-toggle-narrow${i}`).hide();

    let conditions = elt.Conditions.map(c => c.Condition);
    let conditionsDiv = $('<div><b>Condition:</b> </div>');
    for (let j=0; j<conditions.length; j++) {
        let condition = conditions[j];
        conditionsDiv.append($(`<div>${condition}</div>`));
    }
    colSpecsNarrow = [
        newColumnSpec(`${gCommon.cols12}`, conditionsDiv)
    ];
    makeRowWithColumns(togglingDiv, `tr-details1-narrow-${i}`, colSpecsNarrow, `tr-details-${i} mb2i`);

    let interventions = elt.Interventions.map(n => n.InterventionName);
    let interventionsDiv = $('<div><b>Intervention: </b> </div>');
    for (let j=0; j<interventions.length; j++) {
        let intervention = interventions[j];
        interventionsDiv.append($(`<div>${intervention}</div>`));
    }
    colSpecsNarrow = [
        newColumnSpec(`${gCommon.cols12}`, interventionsDiv)
    ];
    makeRowWithColumns(togglingDiv, `tr-details2-narrow${i}`, colSpecsNarrow, `tr-details-${i} mb2i`);

    colSpecsNarrow = [
        newColumnSpec(`${gCommon.cols12}`, `<b>Phase: </b> ${elt.Phase}`)
    ];
    makeRowWithColumns(togglingDiv, `tr-details3-narrow${i}`, colSpecsNarrow, `tr-details-${i}`);

    let dots = rowNarrow.find('.trials-dots');

    setupTrialToggleDots(dots, displayDiv, i);
}
function setupTrialToggleDots(dots, target, i) {

    dots.attr("data-bs-toggle", "tooltip");
    dots.attr("data-bs-placement", "top");
    dots.attr("data-bs-original-title", "See More").tooltip('update').tooltip('show');

    dots.on("mouseenter mouseleave", function (e) {
        armTheTooltips();
    });

    //let togglingDiv = target.find(`.toggle-${i}`);
    let togglingDiv = dots.parent().next();
    dots.on("click", function () {
        toggleEltVisibility(togglingDiv, function () {
            if (togglingDiv.is(":visible")) {
                dots.attr("data-bs-original-title", "Show Less").tooltip('update').tooltip('show');
            } else {
                dots.attr("data-bs-original-title", "See More").tooltip('update').tooltip('show');
            }
        });
    });
}
