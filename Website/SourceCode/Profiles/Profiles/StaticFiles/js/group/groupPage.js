async function setupGroupPage() {
    let [jsonArray, lhsModules, rhsModules] = await setupGroup();

    setupScrolling();
    initAuthorNodeId(jsonArray, "Group.Label");

    await parseGroup(jsonArray, lhsModules, rhsModules);
    await setupGroupExploreRhs(rhsModules[0]); // we expect unit-array for rhs

    setupAnchorDivs($('#groupImgDiv'));
    setupGroupAnchors();

    innerCurtainsUp(getMainModuleRow());
}

async function parseGroup(jsonArray, lhsModules) {

    for (let i = 0; i < lhsModules.length; i++) {
        let moduleJson = lhsModules[i];
        await parseGroupModulesAndData(moduleJson);
    }
}
async function parseGroupModulesAndData(moduleWithDataJson) {

    let moduleTitle = getModuleEltTitle(moduleWithDataJson);

    let moduleData = moduleWithDataJson.ModuleData;

    let moduleMainDiv = $('#modules-left-div');

    let parserInfo = whichGroupMiscInfo(moduleTitle, moduleMainDiv);

    let parser = parserInfo.parser;
    let target = parserInfo.target;
    let parentContainerName = parserInfo.parentContainerName;

    if (!target) {
        let parentInfo = makeOuterModuleDiv(parentContainerName);
        target = parentInfo.payload;
        target.addClass("_lhs");
        target.attr("title", parentContainerName);

        gGroup.cachedParentDiv[parentContainerName] = target;
        moduleMainDiv.append(parentInfo.outerDiv);
    }

    let subtitle = asIdentifier(parserInfo.misc.bannerText);
    if (subtitle) {
        let innerAccordionInfo = makeAccordionDiv(moduleTitle, subtitle, AccordionNestingOption.Nested);
        innerAccordionInfo.outerDiv.addClass("_lhs");
        innerAccordionInfo.outerDiv.attr("title", subtitle);

        /* outer */ target.append(innerAccordionInfo.outerDiv);
        /* and reassigned */ target = innerAccordionInfo.payload;
    }
    let parsedData = parser(moduleData, moduleTitle, parserInfo.misc, target);

    await target.append(parsedData);
}
function compareGroupLhsModules(m1, m2) {
    return compareLhsModules(m1, m2, "Group", whichGroupMiscInfo);
}

async function setupGroup() {
    gGroup.cachedParentDiv = {};

    let [jsonArray, lhsModules, rhsModules] =
        await commonSetupWithJson(compareGroupLhsModules, true);

    return [jsonArray, lhsModules, rhsModules];
}

function whichGroupMiscInfo(moduleTitle, target) {
    let parser = defaultLeftSideParser;
    let sort = 2000; // high number
    let parentContainerName = "";
    let misc = {bannerText: "", blurb: ""};

    switch (moduleTitle) {
        case
        "Label":
            parser = grLabelParser;
            sort = 1;
            break;
        case
        "MainImage":
            parser = grImageParser;
            sort = 11;
            break;
        case
        "Welcome":
            parser = grBlurbParser;
            sort = 21;
            parentContainerName = "Introduction";
            misc.bannerText = 'welcome';
            break;
        case
        "AboutUs":
            parser = grBlurbParser;
            sort = 31;
            parentContainerName = "Introduction";
            misc.bannerText = 'about us';
            break;
        case
        "ContactInformation":
            parser = grBlurbParser;
            sort = 41;
            parentContainerName = "Introduction";
            misc.bannerText = 'contact information';
            break;
        case
        "Overview":
            parser = grBlurbParser;
            sort = 51;
            parentContainerName = "Overview";
            misc.bannerText = 'overview';
            break;
        case
        "Webpage":
            parser = websitesParser;
            sort = 71;
            parentContainerName = "Overview";
            misc.bannerText = 'webpage';
            break;
        case
        "FeaturedPresentations":
            parser = presentationsParser;
            sort = 81;
            parentContainerName = "Featured Content";
            misc.bannerText = 'featured presentations';
            break;
        case
        "FeaturedVideos":
            parser = videosParser;
            parentContainerName = "Featured Content";
            sort = 91;
            misc.bannerText = 'featured videos';
            break;
        case
        "MediaLinks":
            parser = mediaParse;
            sort = 101;
            parentContainerName = "Featured Content";
            misc.bannerText = 'media links';
            break;
        case
        gCommon.twitter:
            parser = twitterParser;
            sort = 111;
            parentContainerName = "Featured Content";
            misc.bannerText = gCommon.twitter;
            break;
        case
        "AssociatedInformationResource":
            parser = authorshipParser;
            parentContainerName = "Publications";
            sort = 121;
            misc.bannerText = "associated information resource";
            misc.ignore3Tabs = true;
            break;

        // No explicit default. Will use default values above
    }

    if (parentContainerName) {
        target = gGroup.cachedParentDiv[parentContainerName];
    }
    return {
        target: target,
        parser: parser,
        parentContainerName: parentContainerName,
        sort: sort,
        misc: misc
    };
}
function setupGroupAnchors() {
    populateLhsAnchors();
    populateRhsAnchors();
}
async function setupGroupExploreRhs(module) {
    let moduleTitle = 'Group Members';
    let sortedMembers = sortArrayViaSortLabel(module.ModuleData.Members, "LastName");

    let dataDiv = makeModuleTitleDiv('Members');
    dataDiv.addClass("_rhs");
    dataDiv.attr("title", moduleTitle);

    let exploreDiv = $(`<div class="exploreDiv"></div>`);
    dataDiv.append(exploreDiv);

    let blurb = 'Members of this Group.';

    let title = $(`<div class="explore_title">${moduleTitle} (${sortedMembers.length})</div>`);
    let blurbDiv = $(`<div class="exploreBlurbDiv">${blurb}</div>`);
    exploreDiv.append(title);
    exploreDiv.append(blurbDiv);
    blurbDiv.hide();

    let moreInfoButton = $(`<img src="${gBrandingConstants.jsCommonImageFiles}info.png" 
                                alt="moreInfo" class="noBorder">`);
    title.append(spanify(" "))
        .append(moreInfoButton);

    moreInfoButton.on("click", function () {
        toggleEltVisibility(blurbDiv);
    });

    let i = 0;
    for (; i<gGroup.membersListUpperLimit && i<sortedMembers.length; i++) {
        member = sortedMembers[i];
        let name = `${member.LastName}, ${member.FirstName}`;
        let a = createAnchorElement(name, member.URL);
        divEltTo(a, exploreDiv);
    }
    if (i==gGroup.membersListUpperLimit && i<sortedMembers.length) {
        divSpanifyTo(". . .", exploreDiv, 'bold');
    }

    emitExploreButton(exploreDiv, module.ModuleData.ExploreURL);

    let mainRightDivId = $('#modules-right-div');
    await mainRightDivId.append(dataDiv);
}

function grImageParser(moduleData) {
    let imageDiv = $(`<div id="groupImgDiv" class="w-100 d-flex justify-content-center mb-2">
                        <img src="${moduleData.label}" alt="moduleLabel" />
                    </div>`);
    return imageDiv;
}

function grBlurbParser(moduleData, moduleTitle, miscInfo, target) {
    let blurb = moduleData.label.replace(/\n/g, "<br/>");
    target.html(blurb);
}

function grLabelParser(moduleData) {
    let label = moduleData.label;
    setTabTitleAndOrFavicon(`${label}`);

    let bigTitleDiv = $(`<div class="page-title mt-2 mb-3">${label}</div>`);
    return bigTitleDiv;
}
