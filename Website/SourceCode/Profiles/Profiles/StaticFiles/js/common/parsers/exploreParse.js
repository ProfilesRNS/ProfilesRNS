
function exploreFullParser(moduleJson, postSkeleton) {
    let moduleTitle = getModuleEltTitle(moduleJson);
    let exploreDiv;

    if (postSkeleton) {
        exploreDiv = gPerson.innerTargetCache[moduleTitle];
        exploreDiv.empty();
        exploreDiv.removeClass(gCommon.tentative);
    }
    else {
        exploreDiv = $(`<div id=${asIdentifier(moduleTitle)}-top></div>`);
        $('#modules-right-div').append(exploreDiv);
    }

    exploreDiv.append($("<hr class='tightHr'>"));

    let elt = moduleJson.ModuleData[0];

    if ( !elt.Count && !elt.Connections) {
        return;
    }

    let blurb = exploreModuleInfo(moduleTitle).blurb;

    let eltCount = elt.Count ? `(${elt.Count})` : "";
    let eltTitle = elt.Title ? `${elt.Title}` : "";
    let titleId = asIdentifier(eltTitle);
    let title = $(`<div id="rhs_${titleId}" title="${eltTitle}" class="_rhs explore_title">${eltTitle} ${eltCount}</div>`);

    exploreDiv.append(title);

    if (blurb) {
        let blurbDiv = $(`<div class="exploreBlurbDiv">${blurb}</div>`);
        exploreDiv.append(blurbDiv);
        blurbDiv.hide();

        let moreInfoButton = $(`<img src="${gBrandingConstants.jsCommonImageFiles}info.png" 
                    class="noBorder" alt=""moreInfo">`);
        title.append(spanify(" "))
            .append(moreInfoButton);

        moreInfoButton.on("click", function() {
            toggleEltVisibility(blurbDiv);
        })
    }

    if (elt.Connections) {
        let sortedConnections = sortArrayViaSortLabel(elt.Connections, "Sort");

        for (let i = 0; i < sortedConnections.length; i++) {
            let connection = sortedConnections[i];
            let label = connection.Label;
            let url = connection.URL;

            exploreDiv.append($(`<div><a href="${url}" class="link-ish explore_connection_label">${label}</a></div>`));
        }
    }
    if (moduleTitle != 'PhysicalNeighbour.Top5') {
        if (elt.ExploreLink) {
            emitExploreButton(exploreDiv, elt.ExploreLink);
        }
        else { // same department is missing the explore link,
                // build the search from its info
            emitExploreButton(exploreDiv, function() {
                minimalPeopleSearchByDept(
                    elt.SearchQuery.Institution.toString(),
                    elt.SearchQuery.Department.toString(),
                    elt.SearchQuery.DepartmentName);
            });
        }
    }
}
function emitNameHeaderForExplores(name) {
    if ($('#theirNetworkDiv').length) {
        // prepopulated in skeleton
        return;
    }
    let theirNetworkDiv = $(`<div id="theirNetworkDiv" class="theirNetworkDiv ">                                                            
                             </div>`);

    let theirNetworkTitle = $(`<div class="boldNetworks">${name}'s Networks</div>`);
    let theirNetworkBlurb = $('<div class="theirNetworkBlurb">Click the <span class="green bold">Explore</span> buttons for ' +
        'more information and interactive visualizations!</div>');

    $('#modules-right-div').append(theirNetworkDiv);
    theirNetworkDiv.append(theirNetworkTitle)
        .append(theirNetworkBlurb);
}

