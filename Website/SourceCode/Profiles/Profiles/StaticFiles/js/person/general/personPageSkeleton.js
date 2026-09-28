async function personPreload() {
    let modulesPreview = JSON.parse(g.preLoad);
    //let modulesPreview = gPerson.preLoad;

    if (!modulesPreview) {
        return; // skip to handling the 'full' modules, no skeletons
    }

    let [lhModules, rhModules, hiddenModules] = partitionSkeletonModules(modulesPreview);

    await commonSetup();

    for (let i=0; i<lhModules.length; i++) {
        let moduleJson = lhModules[i];
        emitModulePreviewMaybeData(
            moduleJson,
            skeletonLhsParser);

        if (moduleJson.DisplayModule == "Person.GeneralInfo") {
            gPerson.giLastName = moduleJson.ModuleData[0].LastName;
        }
    }

    let lastname = gPerson.giLastName;
    emitNameHeaderForExplores(lastname);

    for (let i=0; i<rhModules.length; i++) {
        let moduleJson = rhModules[i];
        emitModulePreviewMaybeData(
            moduleJson,
            skeletonRhsParser);
    }

    return [lhModules, rhModules, hiddenModules];
}
function partitionSkeletonModules(jsonArray) {
    renameTwitter(jsonArray);

    // patch data -- nicer if data came with Panels, and those with uppercase
    jsonArray.forEach(m => { if (m.Panel) m.Panel = m.Panel.toUpperCase(); });

    let giModule = findModuleByName(jsonArray, "Person.GeneralInfo");
    giModule.Panel = gPreloadable.main;
    let labelModule = findModuleByName(jsonArray, "Person.Label");
    labelModule.Panel = gPreloadable.none;

    let lhModules = jsonArray.filter(m => m.Panel && m.Panel == gPreloadable.main);
    let rhModules = jsonArray.filter(m => m.Panel && m.Panel == gPreloadable.rhs);
    let hiddenModules = jsonArray.filter(m => m.Panel && m.Panel == gPreloadable.none);

    lhModules = sortArrayViaSortLabel(lhModules, 'SortOrder');
    rhModules = sortArrayViaSortLabel(rhModules, 'SortOrder');

    gPreloadable.modulePanels = new Map();
    jsonArray.forEach(m => gPreloadable.modulePanels.set(m.DisplayModule, m.Panel));

    return [lhModules, rhModules, hiddenModules];
}
function renameTwitter(jsonArray) {
    jsonArray.forEach(m => {
        if (m.DisplayModule.match(/\.Twitter$/)) {
            m.DisplayModule = m.DisplayModule.replace(/Twitter$/, gCommon.twitter);
        }
        if (m.PropertyLabel) {
            m.PropertyLabel = m.PropertyLabel.replace(/twitter/i, gCommon.twitter);
        }
    });
}
function  partitionFullModules(jsonArray) {
    renameTwitter(jsonArray);

    let lhModules = jsonArray.filter(m => gPreloadable.modulePanels.get(m.DisplayModule) == gPreloadable.main);
    let rhModules = jsonArray.filter(m => gPreloadable.modulePanels.get(m.DisplayModule) == gPreloadable.rhs);
    let hiddenModules = jsonArray.filter(m => gPreloadable.modulePanels.get(m.DisplayModule) == gPreloadable.none);

    return [lhModules, rhModules, hiddenModules];
}
function getParser(moduleTitle) {
    if (!gPerson.parserMap) {
        gPerson.parserMap = new Map();
        
        let map = gPerson.parserMap;
        map.set("Mentoring_JobOpportunities", mentorJobOpportunityParser);
        map.set("Mentoring_Overview", mentorOverviewParser);
        map.set("GeneralInfo", generalInfoParser);
        map.set("CurrentStudentOpportunities", opportunityParser);
        map.set("CompletedStudentProjects", completedProjectParser);
        map.set("HasMemberRole", memberRoleParser);
        map.set("EducationAndTraining", educationParser);
        map.set("AwardOrHonor", awardParser);
        map.set("Overview", overviewParser);
        map.set("FreetextKeyword", keywordParser);
        map.set("Websites", websitesParser);
        map.set("MediaLinks", mediaParse);
        map.set("ResearcherRole", researcherParser);
        map.set("ClinicalTrialRole", trialsParser);
        map.set("FeaturedPresentations", presentationsParser);
        map.set("FeaturedVideos", videosParser);
        map.set(gCommon.twitter, twitterParser);
        map.set("AuthorInAuthorship", authorshipParser);
    }
    let candidate = gPerson.parserMap.get(moduleTitle);
    let parser = candidate ? candidate : defaultLeftSideParser;

    return parser;
}

function emitModulePreviewMaybeData(
    moduleJson,
    skeletonParser) {

    let outerTargetCache = gPerson.outerTargetCache;
    let whichPanel = moduleJson.Panel;
    let panelElt = whichPanel == gPreloadable.rhs ? $('#modules-right-div') : $('#modules-left-div');

    let moduleTitle = getModuleEltTitle(moduleJson);

    let parser = getParser(moduleTitle);
    let bannerText = moduleJson.PropertyLabel;
    let groupLabel = moduleJson.GroupLabel;

    let outerTargetDiv = outerTargetCache[groupLabel];

    if (!outerTargetDiv) {
        if (groupLabel && whichPanel == gPerson.MAIN) {
            let parentInfo = makeOuterModuleDiv(groupLabel);
            outerTargetDiv = parentInfo.payload;
            outerTargetCache[groupLabel] = outerTargetDiv;
            panelElt.append(parentInfo.outerDiv);
        }
        else {
            let nonAccordion = $(`<div class="nonAccordion" id="${asIdentifier(moduleTitle)}-top"></div>`);
            panelElt.append(nonAccordion);
            outerTargetDiv = nonAccordion;
            outerTargetCache[moduleTitle] = outerTargetDiv;
        }
    }

    let moduleData = moduleJson.ModuleData;
    let parsedDataDiv;

    if (moduleData) {
        // data presented early. Bake it in
        parsedDataDiv = parser(moduleData, moduleTitle, bannerText);
        gPerson.fleshySkeleton.set(moduleTitle, true);
    }
    else {
        parsedDataDiv = skeletonParser(moduleJson, bannerText);
    }
    outerTargetDiv.append(parsedDataDiv);
}
function innerCacheAndTentavize(title, div) {
    div.addClass(gCommon.tentative);
    gPerson.innerTargetCache[title] = div;
}
function skeletonLhsParser(moduleJson, subtitle) {
    let moduleTitle = getModuleEltTitle(moduleJson)
    let accordionBannerTitle = subtitle;

    let innerAccordionInfo = makeAccordionDiv(moduleTitle, accordionBannerTitle, AccordionNestingOption.Nested);
    innerAccordionInfo.outerDiv.addClass("_lhs");
    innerAccordionInfo.outerDiv.attr("title", accordionBannerTitle);
    innerAccordionInfo.outerDiv.append($('<div class="loadInProgress">Loading</div>'));

    innerCacheAndTentavize(moduleTitle, innerAccordionInfo.payload);

    return innerAccordionInfo.outerDiv;
}
function skeletonRhsParser(moduleJson) {
    let moduleTitle = getModuleEltTitle(moduleJson)
    let targetDiv = gPerson.outerTargetCache[moduleTitle];

    let dataDiv = makeModuleTitleDiv(moduleTitle);
    let exploreDiv = $(`<div class="exploreDiv"></div>`);

    dataDiv.append(exploreDiv);
    dataDiv.append($('<div class="loadInProgress">Loading</div>'));

    exploreDiv.append($("<hr class='tightHr'>"));

    let propertyLabel = moduleJson.PropertyLabel;

    let titleDiv = $(`<div class="explore_title">${propertyLabel}</div>`);
    exploreDiv.append(titleDiv);

    let blurbDiv = $(`<div class="exploreBlurbDiv">${propertyLabel}</div>`);
    exploreDiv.append(blurbDiv);
    blurbDiv.hide();

    let moreInfoButton = $(`<img src="${gBrandingConstants.jsCommonImageFiles}info.png" 
                                    alt="moreInfo" class="noBorder">`);
    titleDiv.append(spanify(" "))
        .append(moreInfoButton);

    moreInfoButton.on("click", function() {
        toggleEltVisibility(blurbDiv);
    })

    targetDiv.append(dataDiv);

    innerCacheAndTentavize(moduleTitle, exploreDiv);

    return dataDiv;
}



