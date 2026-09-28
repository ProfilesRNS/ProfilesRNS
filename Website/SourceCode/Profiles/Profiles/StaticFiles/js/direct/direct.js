gDirect.colSpecs = [
    newColumnSpec(`${gCommon.cols9or12} ps-1`),
    newColumnSpec(`${gCommon.cols3or12} ps-2 d-flex justify-content-center`)
];
gDirect.keyword = tryMatchUrlParam(/keyword=(.*?)(&|$)/i);
gDirect.resultUrl = 'search-results-URL';

async function setupDirectPage() {
    await commonSetup('Search Other Institutions');
    $('#modules-right-div').addClass("passiveNetwork");

    emitTopItems();
    setupSites();
    setupForTable();
    emitTable();

    setupScrolling();
    $('.rtnBtn').css('bottom', '100px');
}
function emitTopLeft() {
    let target = $('#modules-left-div');

    let backToRow = makeRowWithColumns(target, 'backTo', gDirect.colSpecs, "ps-2 mb-2 mb-lg-0 w-100");
    let backToElt = getEltBackTo('/search', 'Search');
    backToRow.find('#backToCol1').html(backToElt);

    let titleDiv = $('<div class="w-100"></div>');
    target.append(titleDiv);
    titleDiv.append('<span class="me-4">Find experts across multiple institutions.</span>');

    let keywordsDiv = $('<div id="keywordSearch" class="p-2 bordCcc w-75 mt-2 mb-3"></div>');
    keywordsDiv.append('<label class="bold" for="keywordInput">Keywords</label>');
    let keywordInput = $('<input id="keywordInput" type="text" class="ms-4"/></input>');
    keywordsDiv.append(keywordInput);
    keywordInput.on('keydown', (e) => {
        if (e.keyCode == 13) {
            emitTable();
        }
    })

    let searchSpan = $('<span class="ms-3" alt="Search"></span>');
    let searchButton = $(`<img class="directSearchButton" src="${gBrandingConstants.jsSearchImageFiles}search.jpg"/>`);
    keywordsDiv.append(searchSpan);
    keywordsDiv.append(searchButton);
    searchButton.on('click', emitTable);

    target.append(keywordsDiv);
    let keyword = gDirect.keyword ? gDirect.keyword : "";
    $('#keywordInput').val(decodeURI(keyword));

    target.append('<div class="me-4">Below are the number of matching people at each institution. Click an institution\'s name to view the list of people.</div>');
}
function emitTopRight() {
    let target = $('#modules-right-div');
    let aboutDiv = $('<div class="boldCcc p-1"></div>');
    target.append(aboutDiv);

    aboutDiv.append($('<div class="bold mb-1">About This Page</div>'));

    aboutDiv.append($('<div>This page is powered by DIRECT2Experts, a multi-institution initiative to foster scientific collaboration.</div>'));

    aboutDiv.append(createAnchorElement('Learn more.', gDirect.directWebsite));

}
function emitTopItems() {
    emitTopRight();
    emitTopLeft();
}
function setupForTable() {
    let target = $('#modules-left-div');
    let siteTable = $('<div class="mt-4"></div>');
    target.append(siteTable);
    gDirect.table = siteTable;
}
function setupSites() {
    gDirect.sites = JSON.parse(g.preLoad);
}
function emitTable() {
    gDirect.table.empty(); // start fresh

    let keyword = encodeURI($('#keywordInput').val());
    let baseDirectUrl = "http://localhost:55956/DIRECT/DIRECTSVC.aspx/getdata?";

    let sites = gDirect.sites;
    let siteTable = gDirect.table;

    for (sites of sites) {
        let siteID = sites.SiteID;
        let SiteName = sites.SiteName;

        let rowId = `row${siteID}`;
        let row = makeRowWithColumns(siteTable, rowId, gDirect.colSpecs, "ps-2 w-100 bordCcc");
        row.find(`#${rowId}Col0`).html(SiteName);
        row.find(`#${rowId}Col0`).addClass('bendCcc');

        let resultDiv = row.find(`#${rowId}Col1`);
        resultDiv.html($(`<img class="directSearchButton" src="${gBrandingConstants.jsSearchImageFiles}directSearch-loading.gif"/>`));

        let queryString = `siteID=${siteID}&searchQuery=${keyword}`;
        let url = baseDirectUrl + queryString;
        $.ajax({
            url: url,
            success: (data) => {
                console.log("Success: ", url, data);
                let resultLink = createAnchorElement(data.count, data[gDirect.resultUrl]);
                resultDiv.empty().append(resultLink);
                },
            timeout: gDirect.timeout,
            error: (jqXHR, textStatus, errorThrown) => {
                resultDiv.html(`0 (${errorThrown})`);
                }
        });
    }
}




