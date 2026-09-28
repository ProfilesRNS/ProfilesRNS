gEditProp.downArrow = `${g.profilesRootURL}/Edit/Images/icon_squaredownArrow.gif`;
gEditProp.rightArrow = `${g.profilesRootURL}/Edit/Images/icon_squareArrow.gif`;

gEditProp.visPublic = -1 ;
gEditProp.visNoBots = -10;
gEditProp.visUsers  = -20;

gEditProp.prettyVis = new Map();
gEditProp.prettyVis.set(gEditProp.visPublic, 'Public'   );
gEditProp.prettyVis.set(gEditProp.visNoBots, 'No Search');
gEditProp.prettyVis.set(gEditProp.visUsers , 'Users' );

gEditProp.updateVisibilityPrefix = g.editApiPath + "?function=UpdateVisibility&s=";
gEditProp.getDataFunctionPrefix = g.editApiPath + "?function=GetData&s=";
gEditProp.addUpdateDataFunctionPrefix = g.editApiPath + "?function=AddUpdateProperty&s=";

gEditProp.ontologyUrlPrnsPrefix = 'http://profiles.catalyst.harvard.edu/ontology/prns!';
gEditProp.ontologyMentoring = 'mentoringOverview';
gEditProp.ontologyHasJobOpps = 'hasMentoringJobOpportunity';

gEditProp.getMentorOverviewPrnsUrl = `${gEditProp.ontologyUrlPrnsPrefix}${gEditProp.ontologyMentoring}`;
gEditProp.getJobOpportunitiesPrnsUrl = `${gEditProp.ontologyUrlPrnsPrefix}${gEditProp.ontologyHasJobOpps}`;

async function editCommonReady() {
    gEditProp.subject = getSearchParam('subject');

    gEditProp.properties = JSON.parse(g.editPropertyParams);
    gEditProp.propertyName = gEditProp.properties.propertyName;

    console.log('=============editPropertyParams', gEditProp.properties);

    let title = getLastFirstFromPreload();
    await commonSetup(title);

    let mainDiv = $('#mainDiv');

    loadBreadcrumbs(gEditProp.propertyName, mainDiv);
    
    setupVisibilityTable(mainDiv);

    if (gEditProp.properties.propertyURI.toLowerCase().match(gEditProp.ontologyHasJobOpps.toLowerCase())) {
        await setupJobOpps(mainDiv);
    } else if (gEditProp.properties.propertyURI.toLowerCase().match(gEditProp.ontologyMentoring.toLowerCase())) {
        await setupMentorOverview(mainDiv);
    }

    setupScrolling();
}
function getLabelDataFromPreload() {
    let preLoad = JSON.parse(g.preLoad).filter(m => m.DisplayModule.match(/Person.Label$/));
    let moduleData = preLoad[0].ModuleData[0];
    return moduleData;
}
function getLastFirstFromPreload() {
    let moduleData = getLabelDataFromPreload();
    let lastFirst = moduleData.LastName + ', ' + moduleData.FirstName;
    return lastFirst;
}
function getPreferredPathFromPreload() {
    let moduleData = getLabelDataFromPreload();
    let result = moduleData.PreferredPath;
    return result;
}
function loadVisibilityDiv(target) {
    let div = $(`
        <div id="editVisibilityDiv" class="link-ish"><a class="editMenuLink">
            <img id="visibilityMenuIcon" src="${gEditProp.rightArrow}"/> Edit Visibility (<span
            id="currentVisibility"></span>)</a>
        </div>
        <table id="tblVisibility">
            <thead>
                <tr class="topRow"> 
                    <th class="CenterSelect">Select
                    <th class="alignLeft">Privacy</th>
                    <th class="alignLeft">Description</th>
                </tr>
            </thead>
            <tbody>
                <tr class="evenRow">
                    <td class="CenterSelect">
                        <input type="radio" name="visibility" value="${gEditProp.subject}" /></td>
                    <td>Only Me</td>
                    <td>Only me and special authorized users who manage this website.</td></tr>
                <tr class="oddRow"><td class="CenterSelect">
                        <input type="radio" name="visibility" value="${gEditProp.visUsers}" /></td>
                    <td>Users</td>
                    <td>Limited to people who have logged into website.</td></tr>
                <tr class="evenRow"><td class="CenterSelect">
                        <input type="radio" name="visibility" value="${gEditProp.visNoBots}" /></td>
                    <td>No Search</td>
                    <td>Open to the general public, but blocked to certain (but not all) search engines such as Google.</td></tr>
                <tr class="oddRow"><td class="CenterSelect">
                        <input type="radio" name="visibility" value="${gEditProp.visPublic}" /></td>
                    <td>Public</td>
                    <td>Open to the general public and may be indexed by search engines.</td></tr>
            </tbody>
        </table>
    `)
    target.append(div);
    return div;
}
function setupVisibilityTable(target) {
    let subject = getSearchParam('subject');
    let div = loadVisibilityDiv(target);
    let currentVisibility = gEditProp.properties.viewSecurityGroup;
    if (currentVisibility >= 0) {
        currentVisibility = subject; // workaround to get subject id
    }

    $(`input[name="visibility"][value="${currentVisibility}"]`).prop("checked", true);
    let prettyVis = gEditProp.prettyVis.get(currentVisibility) ? gEditProp.prettyVis.get(currentVisibility) : 'Only Me';
    $('#currentVisibility').html(prettyVis);
    console.log("======= visibility: --------", currentVisibility);

    let table = $('#tblVisibility');
    table.hide();

    div.on('click', toggleVisibilityTable);

    $('input[name="visibility"]').on('click', function() {
        let visibility = $('input[name="visibility"]:checked').val();
        gEditProp.visibility = visibility;
        let predicateURI = getSearchParam('predicateuri');
        let url = `${gEditProp.updateVisibilityPrefix}${subject}`
            + `&p=${predicateURI}&v=${visibility}`;

        editSaveViaPost(url);
    });
}
function toggleVisibilityTable() {
    let table = $('#tblVisibility');
    toggleEltVisibility(table);
    toggleSrcIcon($("#visibilityMenuIcon"), gEditProp.rightArrow, gEditProp.downArrow);
}
function loadBreadcrumbs(title, target) {
    let myProfileUrl = getPreferredPathFromPreload();
    let breadcrumbs = $(`<div class="row mb-2">
                        <div class='col-10 d-flex justify-content-start'>
                            <a class='editMenuLink' href='${g.profilesRootURL}/edit/default.aspx?subject=${getNodeId()}'>Edit Menu</a>
                            <span class='editMenuGT'>&nbsp;>&nbsp;</span><span><b>${title}</b></span>
                        </div>
                        <div class='col-2 d-flex justify-content-end'>
                            <a href='${myProfileUrl}'><img src='${g.profilesRootURL}/Framework/Images/arrowLeft.png' /> View Profile</a> 
                        </div>
                    </div>`);
    target.append(breadcrumbs);
}

function getSearchParam(param) {
    let urlParams = new URLSearchParams(window.location.search);
    let result = urlParams.get(param);
    return result;
}
function toggleSrcIcon(target, currentlyClosed, currentlyOpen) {
    if (target.attr('src') == currentlyClosed) {
        target.attr('src', currentlyOpen);
    }
    else {
        target.attr('src', currentlyClosed);
    }
}
function visibilityFollowsArrow(elt, src, closed) {
    if (src.attr('src') == closed) {
        elt.hide();
    }
    else {
        elt.show();
    }
}
async function editSaveViaPost(url, content, redirectTo) {
    let _content = JSON.stringify(content);
     await $.post(url, _content, function () {
         if (redirectTo) {
             window.location.href = redirectTo;
         }
         else {
             window.location.reload();
         }
     })
     .fail((response) => {
         ajaxPostFailure(response, url)
     });
}
 async function getDataViaPost(url, callback) {
    let result = 0;
    await $.post(url, function (results) {
        result = callback(results);
    })
    .fail((response) => ajaxPostFailure(response, url));
    return result;
}
function ajaxPostFailure(response, url) {
        alert(`${url} failed, saying: <${response.responseText}>.\n\nMaybe log in again at \n\n${gCommon.loginUrl}.`);
}
// https://www.google.com/search?q=js+move+one+item+up+in+an+array&sca_esv=db2351f46a6aa745&rlz=1C5GCCM_en&sxsrf=ANbL-n6FxPbqHcKF3RXZSpju5FgcnNmyEA%3A1772132954979&ei=WpqgadW-O5HY5NoPjY7ZkQo&biw=1066&bih=591&ved=0ahUKEwjV05ra7feSAxURLFkFHQ1HNqIQ4dUDCBE&uact=5&oq=js+move+one+item+up+in+an+array&gs_lp=Egxnd3Mtd2l6LXNlcnAiH2pzIG1vdmUgb25lIGl0ZW0gdXAgaW4gYW4gYXJyYXkyBRAhGKABMgUQIRigATIFECEYoAEyBRAhGKABMgUQIRigATIFECEYnwUyBRAhGJ8FMgUQIRifBTIFECEYnwUyBRAhGJ8FSNJbUJsWWJJZcAN4AZABAJgBugGgAcsbqgEEOS4yMbgBA8gBAPgBAZgCIKAC9BvCAgoQABiwAxjWBBhHwgINEAAYgAQYsAMYQxiKBcICBBAjGCfCAgoQABiABBhDGIoFwgIREAAYgAQYkQIYsQMYgwEYigXCAg0QABiABBixAxgUGIcCwgIFEAAYgATCAgsQABiABBiRAhiKBcICCxAuGIAEGMcBGK8BwgIKEAAYgAQYFBiHAsICBhAAGBYYHsICBRAAGO8FwgIIEAAYogQYiQXCAgcQIRigARgKwgIFECEYqwKYAwCIBgGQBgqSBwQ5LjIzoAeBzgGyBwQ2LjIzuAfiG8IHBzEuMTkuMTLIB1KACAA&sclient=gws-wiz-serp
function moveArrayItemUp(array, indexToMove) {
    if (indexToMove > 0) {
        // Swap the element with the one before it
        [array[indexToMove], array[indexToMove - 1]] = [array[indexToMove - 1], array[indexToMove]];
        return true; // if caller wants to know whether anything moved
    }
}
function moveArrayItemDown(array, indexToMove) {
    if (indexToMove+1 < array.length) {
        // Swap the element with the one before it
        [array[indexToMove], array[indexToMove + 1]] = [array[indexToMove + 1], array[indexToMove]];
        return true; // if caller wants to know whether anything moved
    }
}
function isValidURLRegex(url) {
    const pattern = new RegExp(
        "^(https?:\\/\\/)?" + // optional protocol
        "((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|" + // domain name
        "((\\d{1,3}\\.){3}\\d{1,3}))" + // OR ip (v4) address
        "(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*" + // port and path
        "(\\?[;&a-z\\d%_.~+=-]*)*" + // query string
        "(\\#[-a-z\\d_]*)?$", // fragment locator
        "i" // case-insensitive flag
    );
    return !!pattern.test(url);
}
// https://www.google.com/search?q=js+utility+to+support+links+and+bold+in+textarea&rlz=1C5GCCM_en&oq=js+utility+to+support+links+and+bold+in+textarea&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIHCAEQIRigATIHCAIQIRigATIHCAMQIRigATIHCAQQIRifBTIHCAUQIRifBTIHCAYQIRifBTIHCAcQIRifBTIHCAgQIRifBTIHCAkQIRifBdIBCTE0MzQ2ajBqN6gCCLACAfEFGIcOwW7BzXI&sourceid=chrome&ie=UTF-8
function getTextAreaSelection(textAreaId) {
    let docTextArea = document.getElementById(textAreaId);
    let selection = ""; // burden of proof

    let start = docTextArea.selectionStart;
    let end = docTextArea.selectionEnd;
    if (end > start) {
        let text = docTextArea.value;
        selection = text.substring(start, end);
    }
    return {docTextArea:docTextArea, selection:selection, start:start, end:end};
}
function replaceTextAreaSelection(textAreaId, replacement) {
    let {docTextArea, selection, start, end} = getTextAreaSelection(textAreaId);
    let text = docTextArea.value;
    docTextArea.value = text.substring(0, start) + replacement + text.substring(end);
}
function wrapTextInTextArea(textAreaId, beforeSelection, afterSelection) {
    let {docTextArea, selection, start, end} = getTextAreaSelection(textAreaId);
    if (selection) {
        let replacement = beforeSelection + selection + afterSelection;
        replaceTextAreaSelection(textAreaId, replacement);
    }
}
function restoreBoldLinks(text) {
    let result = text.replace(/\[\/b]/g, "</b>")
        .replace(/\[b]/g, "<b>");

    result = result.replace(/\[url=(.*?)]/g, "<a href='$1'>")
        .replace(/\[\/url]/g, "</a>");

    return result;
}