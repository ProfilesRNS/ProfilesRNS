
const PubsSortOption = Object.freeze({
    Newest: Symbol("Newest"),
    Oldest: Symbol("Oldest"),
    MostCited: Symbol("MostCited"),
    MostDiscussed: Symbol("MostDiscussed")
});
const PubsLimitedSortParam = Object.freeze({
    Oldest: Symbol("pubsOldest"),
    MostCited: Symbol("pubsCited"),
    MostDiscussed: Symbol("pubsDiscussed"),
    All: Symbol("pubsAll")
});
const PubsLimitOption = Object.freeze({
    Limit: Symbol("Limit"),
    All: Symbol("All")
});
const AccordionNestingOption = Object.freeze({
    Nested: Symbol("nested"),
    Unnested: Symbol("unnested")
});
///////////////////////////////////////

let gCommon = {};
gCommon.twitter = 'X_formerlyKnownAsTwitter';

gCommon.historyKey = 'profilesNavHistory';
gCommon.undefined = 'undefined';

gCommon.loggedIn = null;
gCommon.numPersons = sessionInfo.listSize;

gCommon.NA = "N/A";
gCommon.monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
];
gCommon.scrollTime = 500;

gCommon.anchorLinksDivSpacing = 'pt-1 pe-2 pb-1 ps-2 ms-2 mb-2';

gCommon.showXsHideOthers = "d-block d-sm-none d-md-none d-lg-none d-xl-none d-xxl-none";
gCommon.hideXsShowOthers = "d-none d-sm-block d-md-block d-lg-block d-xl-block d-xxl-block";

gCommon.showXsSmallHideOthers = "d-block d-sm-block d-md-none d-lg-none d-xl-none d-xxl-none";
gCommon.hideXsSmallShowOthers = "d-none d-sm-none d-md-block d-lg-block d-xl-block d-xxl-block";

gCommon.showXsSmMdHideOthers = "d-block d-sm-block d-md-block d-lg-none d-xl-none d-xxl-none";
gCommon.hideXsSmMdShowOthers = "d-none d-sm-none d-md-none d-lg-block d-xl-block d-xxl-block";

gCommon.large = "Lg";
gCommon.small = "Sm";

gCommon.cols1 = " col-1 col-sm-1 col-md-1 col-lg-1 col-xl-1 col-xxl-1 ";
gCommon.cols2 = " col-2 col-sm-2 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ";
gCommon.cols3 = " col-3 col-sm-3 col-md-3 col-lg-3 col-xl-3 col-xxl-3 ";
gCommon.cols4 = " col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xxl-4 ";
gCommon.cols5 = " col-5 col-sm-5 col-md-5 col-lg-5 col-xl-5 col-xxl-5 ";
gCommon.cols6 = " col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6 col-xxl-6 ";
gCommon.cols7 = " col-7 col-sm-7 col-md-7 col-lg-7 col-xl-7 col-xxl-7 ";
gCommon.cols8 = " col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8 col-xxl-8 ";
gCommon.cols9 = " col-9 col-sm-9 col-md-9 col-lg-9 col-xl-9 col-xxl-9 ";
gCommon.cols10 = " col-10 col-sm-10 col-md-10 col-lg-10 col-xl-10 col-xxl-10 ";
gCommon.cols12 = " col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xxl-12 ";
gCommon.cols12or12 = gCommon.cols12;

gCommon.cols2or6 = " col-6 col-sm-6 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ";
gCommon.cols5or6 = " col-6 col-sm-6 col-md-5 col-lg-5 col-xl-5 col-xxl-5 ";

gCommon.cols1or12 = " col-12 col-sm-12 col-md-1 col-lg-1 col-xl-1 col-xxl-1 ";
gCommon.cols2or12 = " col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ";
gCommon.cols3or12 = " col-12 col-sm-12 col-md-3 col-lg-3 col-xl-3 col-xxl-3 ";
gCommon.cols4or12 = " col-12 col-sm-12 col-md-4 col-lg-4 col-xl-4 col-xxl-4 ";
gCommon.cols5or12 = " col-12 col-sm-12 col-md-5 col-lg-5 col-xl-5 col-xxl-5 ";
gCommon.cols6or12 = " col-12 col-sm-12 col-md-6 col-lg-6 col-xl-6 col-xxl-6 ";
gCommon.cols7or12 = " col-12 col-sm-12 col-md-7 col-lg-7 col-xl-7 col-xxl-7 ";
gCommon.cols8or12 = " col-12 col-sm-12 col-md-8 col-lg-8 col-xl-8 col-xxl-8 ";
gCommon.cols9or12 = " col-12 col-sm-12 col-md-9 col-lg-9 col-xl-9 col-xxl-9 ";
gCommon.cols10or12 = " col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 col-xxl-10 ";

gCommon.cols6or12Lg = " col-12 col-sm-12 col-md-12 col-lg-12 col-xl-6 col-xxl-6 ";
gCommon.cols5or12Lg = " col-12 col-sm-12 col-md-12 col-lg-5 col-xl-5 col-xxl-5 ";
gCommon.cols7or12Lg = " col-12 col-sm-12 col-md-12 col-lg-7 col-xl-7 col-xxl-7 ";

gCommon.cols11or12 = " col-12 col-sm-12 col-md-11 col-lg-11 col-xl-11 col-xxl-11";

gCommon.bsMarginVarying = "ms-1 ms-sm-1 ms-md-0 ms-lg-3 ms-xl-0 ms-xxl-0";
gCommon.bsMarginsPaddingIncreasing = `ms-0 ms-sm-0 ms-md-2 ms-lg-2 ms-xl-4 ms-xxl-4
                        ps-0 ps-sm-0 ps-md-2 ps-lg-2 ps-xl-4 ps-xxl-4`;

gCommon.personThumbnailSchema = `${g.profilesRootURL}/profile/Modules/CustomViewPersonGeneralInfo/PhotoHandler.ashx?NodeID=%%FOO%%&Thumbnail=True&Width=45`;
gCommon.personEmailToImageUrlPrefix = `${g.profilesRootURL}/Profile/Modules/CustomViewPersonGeneralInfo/EmailHandler.ashx?msg=`;
gCommon.personOrcidUrlPrefix = "https://orcid.org/";

function setupBrandingDependentVals() {
    gCommon.helpUrl = `${g.profilesRootURL}/about/default.aspx?type=Help`;
    gCommon.overviewAUrl = `${g.profilesRootURL}/about/default.aspx?type=About`;
    gCommon.openSourceSoftwareAUrl = `${g.profilesRootURL}/about/default.aspx?type=OpenSourceSoftware`;
    gCommon.useOurDataAUrl = `${g.profilesRootURL}/about/default.aspx?type=UseOurData`;

    gSearch.searchFormUrl = `${g.profilesRootURL}/search/`;
    gSearch.searchFormPeopleUrl =      `${gSearch.searchFormUrl}`;
    gSearch.searchFormAllElseUrl =     `${gSearch.searchFormUrl}/all`;

    gSearch.moreUpdatesUrl =        `${g.profilesPath}/Activity/Modules/ActivityHistory/ActivityDetails.aspx`;

    gAbout.griffinUrl = `${gBrandingConstants.staticRoot}display/Person/32213`;
    gAbout.licenseUrl = `${gBrandingConstants.staticRoot}LICENSE.txt`;

    // possibly override default of google-maps
    if (gBrandingConstants.mapProvider) {
        let lcProvider = gBrandingConstants.mapProvider.toLowerCase();
        if (g.mapProviderOptions[lcProvider]) {
            g.mapProvider = g.mapProviderOptions[lcProvider];
        }
    }
}
g.mapProviderOptions = {google: "google", leaflet: "leaflet"};
g.mapProvider = g.mapProviderOptions.google;
g.mapProviderOptions.leafletLoadingDelay = 500;
g.mapProviderOptions.googleLoadingDelay = 500;

gCommon.schemaPlaceholder = "%%FOO%%";
gCommon.schemaPlaceholder2 = "%%FOO2%%";

// catalyst logout is probably closer to the following:
// gCommon.logoutUrl = `${g.profilesPath}/profiles/logout.aspx`;

gCommon.loginUrlSchema = `${g.profilesPath}/Login/default.aspx?method=login&redirectto=${gCommon.schemaPlaceholder}&sessionid=`;
gCommon.seeAllPagesAUrl = `${g.profilesPath}/history`;
gCommon.logoutUrl = `${g.profilesPath}/login/default.aspx?method=logout&redirectto=${encodeURIComponent(g.profilesRootURL)}`;
gCommon.editProfileUrl = `${g.profilesPath}/edit/default.aspx?subject=`;
gCommon.viewMyListUrl = `${g.profilesPath}/lists/default.aspx`;
gCommon.dashboardUrl = `${g.profilesPath}/dashboard/default.aspx?subject=`
gCommon.manageProxiesUrl = `${g.profilesPath}/proxy/default.aspx?subject=`;
gCommon.opportunitySearch = `${g.profilesPath}/studentopportunities/index`;

gCommon.mainDivClasses = ` col-12 ms-3 ms-sm-3 ms-md-4 ms-lg-5 ms-xl-5 ms-xxl-5 
                               pe-0 pe-sm-1 pe-md-4 pe-lg-5 pe-xl-5 pe-xxl-5   `;
gCommon.mainLeftCols = " col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 col-xxl-10 ";
gCommon.mainRightCols = " col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 col-xxl-2 ";

gCommon.spanTriangleDown = `<span> &#9662;</span>`;

//////////////////////////////

let gMapTab = {};

let gTimelineTab = {};
gTimelineTab.yearWidth = 22;      // eg 2014
gTimelineTab.shortYearWidth = 13; // smaller for '14

let gConcepts = {};
gConcepts.conceptsKey = "numConcepts";

let gSimilars = {};
gSimilars.similarsKey = "numSimilars";

let gPerson = {};

gPerson.etlFieldAbbrevs = {};
gPerson.etlFieldStyleClasses = {};
gPerson.etlFieldFilterClasses = {};

gPerson.waitForDimensions = 500;
gPerson.waitForAltmetric = 2000;

gPerson.altmetricScores = {};
gPerson.gotAltmetrics = false;

gPerson.limitOption = PubsLimitOption.Limit;
gPerson.sort = PubsSortOption.Newest;

gPerson.fieldFilters = [];
gPerson.translationFilters = [];

gPerson.pmcUrlStart = "https://www.ncbi.nlm.nih.gov/pmc/articles/";
gPerson.pucbtPlaceholder = "%%%%";
gPerson.pmcUrlCitedByTemplate = `https://pubmed.ncbi.nlm.nih.gov/?linkname=pubmed_pubmed_citedin&from_uid=`;
gPerson.pmUrlStart = "https://www.ncbi.nlm.nih.gov/pubmed/";

gPerson.slideshareUrlStart = "https://weberdemo.hms.harvard.edu/nick/Profiles40Webservice/getSlideShare/";

// fixed number in DB schema: 5 translation types
gPerson.translations = [
    { className: "TranslationHumans",        abbr: "Humans"   ,        ttip: "" },  // no popup on prod
    { className: "TranslationAnimals",       abbr: "Animals"  ,        ttip: ""},   // no popup on prod
    { className: "TranslationCells",         abbr: "Cells"    ,        ttip: ""  }, // no popup on prod
    { className: "TranslationPublicHealth",  abbr: "<i><b>PH</b></i>", ttip: "Public Health"},
    { className: "TranslationClinicalTrial", abbr: "<i><b>CT</b></i>", ttip: "Clinical Trials"}
];

gPerson.defaultFieldClass = 'defaultFieldClass';
gPerson.altPmidSelector = '.altmetric-embed[data-pmid]';

gPerson.plain = {};
gPerson.plain.shortNumOfAuthors = 2;
gPerson.plain.old = "old";
gPerson.plain.new = "new";

gPerson.outerTargetCache = {};
gPerson.innerTargetCache = {};
gPerson.fleshySkeleton = new Map();
gPerson.MAIN = "MAIN";
gPerson.RHS = "RHS";
gCommon.tentative = "tentative";

gPerson.maxAltMetricScoreTries = 5;

gPerson.researcherNumRecent = 5;
gPerson.researcherUseRecent = true;

gPerson.supportHowMsg = "How to update my information?";

///////////////////////////////////////
let gConnections = {};
gConnections.details = "Details";
gConnections.pubMedUrlSchema = "https://www.ncbi.nlm.nih.gov/pubmed/%%FOO%%";

let gCoauthor = {};
gCoauthor.whichTabKey = "whichCoauthTab";
gCoauthor.coAuthsKey = "numCoauths";
gCoauthor.coauthorsWithDash = 'Co-Authors'

let gSearch = {};
let gGroup = {};
gGroup.membersListUpperLimit = 20;
gGroup.maxBeforeColumnSplit = 20;

gSearch.people = 'people';
gSearch.allElse = 'all';
gSearch.whyPrefix = 'why';

gSearch.searchFormParamsUrl = `${g.searchApiPath}?SearchType=params`;

gSearch.searchForm = `${g.profilesRootURL}/search`;
gSearch.otherInstitutions = `${g.profilesRootURL}/direct/default.aspx?searchtype=people`;
gSearch.findPeopleUrl = `${g.searchApiPath}?SearchType=person`;
gSearch.findEverythingElseUrl = `${g.searchApiPath}?SearchType=everything`;
gSearch.whyUrl = `${g.searchApiPath}?SearchType=why`;
gSearch.activityDetailsUrl = `${g.activityApiPath}?count=%%FOO%%&lastActivityLogID=%%FOO2%%`;

gSearch.peopleResultsUrl = `${g.profilesPath}/search/?PersonResults`;
gSearch.everythingElseResultsUrl = `${g.profilesPath}/search/?EverythingResults`;

gSearch.selectedSt = " selected";
gSearch.noneSt = "None";
gSearch.peopleResultDisplay = {};
gSearch.peopleResultDisplay['Weight'] = 'Query Relevance';
gSearch.peopleResultDisplay['DisplayName'] = 'Name';
gSearch.peopleResultDisplay['InstitutionName'] = 'Institution';
gSearch.peopleResultDisplay['DepartmentName'] = 'Department';
gSearch.peopleResultDisplay['FacultyRank'] = 'Faculty&nbsp;Rank';

gSearch.selectedOptionalPeopleShowsKey = 'selectedOptionalShows';
gSearch.defaultOptionalPeopleShows = ['InstitutionName'];

gSearch.selectedSortValueKey = 'selectedSortValueKey';

gSearch.sortableSt = "sortable";
gSearch.omitOptionalColumnSt = "omitOptionalColumn";
gSearch.sortDisplaySt = "sortDisplay";
gSearch.directionSt = "direction";
gSearch.descendingSt = "Desc";
gSearch.ascendingSt = "Asc";
gSearch.descendingValReSt = "(za)|(desc)";
gSearch.columnNameSt = "columnName";

gSearch.sortPeopleIconInfoKey = "sortPeopleIconInfoKey";

gSearch.fnameInputSt = 'fnameInput';
gSearch.lnameInputSt = 'lnameInput';

gSearch.allFilterLabel = 'All';
gSearch.defaultFilterLabel = gSearch.allFilterLabel;
gSearch.currentFilterKey = 'currentFilterKey';

gSearch.recentUpdateTokens = {}; // see recentUpdates.js

gSearch.activityDetailsCount = 10;
gSearch.activityPreviewCount = 3;
gSearch.activityInitialHighId = 50000000;
gSearch.activityCurrentHighId = gSearch.activityInitialHighId;

gSearch.defaultPeopleSort = 'relevance';

let gPage = {};
gPage.sizes = [15, 25, 50, 100];
gPage.defaultPageSize = gPage.sizes[0];

gAbout = {};
gAbout.rnsUrl = 'http://profiles.catalyst.harvard.edu/';

gConcepts.meshSiteUrl = 'http://www.nlm.nih.gov/mesh/';
gConcepts.meshSiteText = 'MeSH (Medical Subject Headings)';

let gPreloadable = {};
gPreloadable.main = "MAIN";
gPreloadable.rhs = "RHS";
gPreloadable.none = "NONE";

gDirect = {
    timeout: 10000, // ms
    directWebsite: 'http://direct2experts.org/'
};
gDirect.exactPhrase = 'exactPhrase';
gDirect.searchFor = 'searchFor';

let gEditProp = {};







