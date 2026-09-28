function parsePerson(jsonArray, lhsModules, rhsModules, andThen) {

    google.charts.load('current', {'packages':['corechart']});
    google.charts.load('current', {'packages':['bar']});
    google.charts.setOnLoadCallback(function() {
        console.log("charts loaded");
        console.log("gv: ", google, google.visualization);

        for (let i=0; i<lhsModules.length; i++) {
            let moduleJson = lhsModules[i];

            // skip empty-data modules
            if (! moduleJson.ModuleData) {
                console.log("NO DATA FOR " + moduleJson.DisplayModule);
                continue;
            }
            parsePersonModulesAndData(
                moduleJson,
                whichParserInfo,
                gPerson.outerTargetCache,
                armTheTooltips);
        }

        setupExploreNetworks(rhsModules, true);

        if (andThen) {
            andThen();
        }
    });
}

// todo We might nuke this fn, IFF (modules are mapped by
//    getParser() in personPageSkeleton.js, and all modules
//    come with a sortOrder in the Json)
function whichParserInfo(moduleTitle, defaultTarget) {
    let parser = defaultLeftSideParser;
    let sort = 2000; // high number
    let parentContainerName = "";
    let target = defaultTarget;
    let misc = { bannerText: "", blurb: ""};

    switch (moduleTitle) {
        case "Mentoring_JobOpportunities":
            parser = mentorJobOpportunityParser;
            sort = 66;
            break;
        case "Mentoring_Overview":
            parser = mentorOverviewParser;
            sort = 65;
            break;
        case "GeneralInfo":
            parser = generalInfoParser;
            sort = 1;
            break;
        case "CurrentStudentOpportunities":
            parser = opportunityParser;
            sort = 11;
            parentContainerName = "Mentoring";
            misc.bannerText = "current student opportunities";
            break;
        case "CompletedStudentProjects":
            parser = completedProjectParser;
            sort = 12;
            parentContainerName = "Mentoring";
            misc.bannerText = "completed student projects";
            break;
        case "HasMemberRole":
            parser = memberRoleParser;
            sort = 15;
            parentContainerName = "Affiliation";
            misc.bannerText = "groups";
            break;
        case "EducationAndTraining":
            parser = educationParser;
            sort = 21;
            parentContainerName = "Biography";
            misc.bannerText = "education and training";
            break;
        case "AwardOrHonor":
            parser = awardParser;
            sort = 31;
            parentContainerName = "Biography";
            misc.bannerText = "awards";
            break;
        case "Overview":
            parser = overviewParser;
            sort = 41;
            parentContainerName = "Overview";
            misc.bannerText = "overview";
            break;
        case "FreetextKeyword":
            parser = keywordParser;
            sort = 51;
            parentContainerName = "Overview";
            misc.bannerText = "keywords";
            break;
        case "Websites":
            parser = websitesParser;
            sort = 61;
            parentContainerName = "Overview";
            misc.bannerText = "webpage";
            break;
        case "MediaLinks":
            parser = mediaParse;
            sort = 71;
            parentContainerName = "Overview";
            misc.bannerText = "media";
            break;
        case "ResearcherRole":
            parser = researcherParser;
            sort = 111;
            parentContainerName = "Research";
            misc.bannerText = "research activities and funding";
            break;
        case "ClinicalTrialRole":
            parser = trialsParser;
            sort = 121;
            parentContainerName = "Research";
            misc.bannerText = "clinical trials";
            break;
        case "FeaturedPresentations":
            parser = presentationsParser;
            sort = 131;
            parentContainerName = "Featured Content";
            misc.bannerText = "presentations";
            break;
        case "FeaturedVideos":
            parser = videosParser;
            sort = 141;
            parentContainerName = "Featured Content";
            misc.bannerText = "videos";
            break;
        case gCommon.twitter:
            parser = twitterParser;
            sort = 151;
            parentContainerName = "Featured Content";
            misc.bannerText = gCommon.twitter;
            break;
        case "AuthorInAuthorship":
            parser = authorshipParser;
            sort = 161;
            parentContainerName = "Bibliographic";
            misc.bannerText = "selected publications";
            break;
        // No explicit default. Will use default values above
    }

    if (parentContainerName) {
        target = gPerson.outerTargetCache[parentContainerName];
    }
    return {
        parser: parser,
        target: target,
        parentContainerName:parentContainerName,
        sort: sort,
        misc: misc
        };
}






