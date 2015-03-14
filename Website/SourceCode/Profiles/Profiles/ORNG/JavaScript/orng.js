/*
Orng Shindig Helper functions for gadget-to-container commands

NOTE THAT WE minimize this via http://closure-compiler.appspot.com/home and save the results as orng.min.js to load!!!!!!!!!!!!!!!!!!!!!!!!!

*/

// IE8 Fix
if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function (obj, start) {
        for (var i = (start || 0), j = this.length; i < j; i++) {
            if (this[i] === obj) {
                return i;
            }
        }
        return -1;
    };
}

if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function () {
        return this.replace(/^\s+|\s+$/g, '');
    };
};
// IE8 END

var OrngContainer = OrngContainer || {};

my.orngRPCEndpoint = _rootDomain + "/ORNG/Default.aspx/CallORNGRPC";

my.init = function () {

    // 1. Create the OrngContainer object
    var tokens = {};
    for (var i = 0; i < my.gadgets.length; i++) {
        tokens[my.gadgets[i].url] = {};
        tokens[my.gadgets[i].url][osapi.container.TokenResponse.TOKEN] = my.gadgets[i].secureToken;
    }

    var orngConfig = {};
    orngConfig[osapi.container.ServiceConfig.API_PATH] = my.openSocialURL.substring(my.openSocialURL.lastIndexOf('/')) + "/rpc";
    orngConfig[osapi.container.ContainerConfig.RENDER_DEBUG] = my.debug;
    orngConfig[osapi.container.ContainerConfig.TOKEN_REFRESH_INTERVAL] = 0; // disable for now
    orngConfig[osapi.container.ContainerConfig.PRELOAD_TOKENS] = tokens; // hash keyed by chromeId seems to be the correct thing to put in here

    OrngContainer = new osapi.container.Container(orngConfig);

    // 2. Define the functions for the OrngContainer object
    // Need to pull these from values supplied in the dialog
    OrngContainer.init = function () {
        OrngContainer.rpcRegister('orng_hideShow', window.hideOrShowGadget);
        OrngContainer.rpcRegister('requestNavigateTo', OrngContainer.doProfilesNavigation);
        OrngContainer.rpcRegister('set_title', OrngContainer.setTitleHandler);
    };

    // create an array to help access our myGadget info. This seems like it should not be necessary given the data in gadgetSite
    // but doing this for now
    OrngContainer.gadgetsByGadgetSiteId = [];

    //Wrapper function to set the gadget site/id and default width.  Currently have some inconsistency with width actually being set. This
    //seems to be related to the pubsub2 feature.
    OrngContainer.navigateView = function (gadgetSite, myGadget) {
        // this is the only time we can populate this.
        // seems we should not need to do this, but I can find no other way to get myGadget data from a gadgetSite object
        OrngContainer.gadgetsByGadgetSiteId[gadgetSite.getId()] = myGadget;

        // Start with the params that we loaded from the AppViews table in the database.  
        var renderParms = myGadget.opt_params;
        renderParms[osapi.container.RenderParam.WIDTH] = '100%';
        renderParms[osapi.container.RenderParam.VIEW] = myGadget.view;
        renderParms[osapi.container.RenderParam.DEBUG] = my.debug;

        OrngContainer.navigateGadget(gadgetSite, myGadget.url, {}, renderParms);
    };

    //TODO:  Add in UI controls in portlet header to remove gadget from the canvas
    OrngContainer.collapseGadget = function (gadgetSite) {
        OrngContainer.closeGadget(gadgetSite);
    };

    // TODO: need to test and make work
    OrngContainer.setTitleHandler = function (rpcArgs, title) {
        var myGadget = OrngContainer.gadgetsByGadgetSiteId[rpcArgs.gs.getId()];
        if (myGadget.view == 'canvas') {
            document.getElementById("gadgets-title").innerHTML = cleanTitle(title);
        }
        else {
            document.getElementById(myGadget.appId + '_title').innerHTML = cleanTitle(title);
        }
    };

    OrngContainer.doProfilesNavigation = function (rpc, view, opt_params) {
        var urlTemplate = gadgets.config.get('views')[view].urlTemplate;
        var url = urlTemplate;

        url += window.location.search.substring(1);

        // remove appId if present
        url = removeParameterFromURL(url, 'appId');

        // Add appId if the URL Template begins with the word 'ORNG'
        if (urlTemplate.indexOf('ORNG') == 0) {
            var appId = OrngContainer.gadgetsByGadgetSiteId[rpc.gs.getId()].appId;
            url = addParameterToURL(url, "appId", appId);
        }

        // add ownerId if available. This is probably not the best way to do this, but it works
        if (rpc.a[2]) {
            url = addParameterToURL(url, "owner", encodeURIComponent(rpc.a[2]));
        }

        if (opt_params) {
            var paramStr = gadgets.json.stringify(opt_params);
            if (paramStr.length > 0) {
                url = addParameterToURL(url, "appParams", encodeURIComponent(paramStr));
            }
        }
        if (url && document.location.href.indexOf(url) == -1) {
            document.location.href = _rootDomain + '/' + url;
        }
    };

    // 3. Initialize the OrngContainer and build the gadgets
    OrngContainer.init();

    // this allows us to grab the metadata
    var gadgetURLs = [];
    for (var i = 0; i < my.gadgets.length; i++) {
        if (gadgetURLs.indexOf(my.gadgets[i].url) == -1) {
            gadgetURLs.push(my.gadgets[i].url);
        }
    }

    // draw these things out now
    OrngContainer.preloadGadgets(gadgetURLs, function (result) {
        for (var i = 0; i < my.gadgets.length; i++) {
            window.buildGadget(result, my.gadgets[i]);
        }
    });
};

// helper functions
my.findGadgetsAttachingTo = function (chromeId) {
    var retval = [];
    for (var i = 0; i < my.gadgets.length; i++) {
        if (my.gadgets[i].chrome_id == chromeId) {
            retval[retval.length] = my.gadgets[i];
        }
    }
    return retval;
};

my.removeGadgets = function (gadgetsToRemove) {
    for (var i = 0; i < gadgetsToRemove.length; i++) {
        for (var j = 0; j < my.gadgets.length; j++) {
            if (gadgetsToRemove[i].url == my.gadgets[j].url) {
                my.gadgets.splice(j, 1);
                break;
            }
        }
    }
};

//create a gadget based on metadata
window.buildGadget = function (result, myGadget) {
    result = result || {};
    //    var element = window.getNewGadgetElement(result, gadgetURL);
    //    $(element).data('gadgetSite', CommonContainer.renderGadget(gadgetURL, curId));

    var layoutRoot = document.getElementById(myGadget.chrome_id);
    if (layoutRoot) {
        // create div that holds title and iframe content
        var chrome = document.createElement('div');
        chrome.className = myGadget.opt_params.chrome_class || 'gadgets-gadget-chrome';
        chrome.setAttribute('id', 'gadgets-gadget-chrome-' + my.gadgets.indexOf(myGadget));
        var width = result[myGadget.url].views && result[myGadget.url].views[myGadget.view] ? result[myGadget.url].views[myGadget.view].preferredWidth : 0;
        var width = width || result[myGadget.url].modulePrefs.width;
        if (width) {
            chrome.style.width = width + 'px';
        }
        if (result[myGadget.url].modulePrefs && result[myGadget.url].modulePrefs.features && result[myGadget.url].modulePrefs.features['start-hidden']) {
            chrome.style.display = 'none';
        }
        layoutRoot.appendChild(chrome);

        // now for the title
        if (myGadget.opt_params.hide_titlebar != 1) {
            var title = cleanTitle(result[myGadget.url].modulePrefs.title);
            if (myGadget.view != 'canvas') {
                chrome.innerHTML = this.getTitleHtml(myGadget, title);
            }
            else {
                document.getElementById("gadgets-title").innerHTML = title;
            }
        }

        // finally, the iframe itself
        var framediv = document.createElement('div');
        framediv.className = 'gadgets-gadget-content';
        chrome.appendChild(framediv);
        var gadgetSite = OrngContainer.newGadgetSite(framediv);
        OrngContainer.navigateView(gadgetSite, myGadget);
    }
};

// TODO fix this legacy class stuff
window.getTitleHtml = function (myGadget, title) {
    return '<div id="gadgets-gadget-title-bar' + '-' + myGadget.appId +
	      '" class="gadgets-gadget-title-bar"><span class="gadgets-gadget-title-button-bar">' +
	      '</span> <span id="' + myGadget.appId + '_title" class="gadgets-gadget-title">' +
	      title +
          '</span><span id="' + myGadget.appId + '_status" class="gadgets-gadget-status"></span></div>';
};

window.hideOrShowGadget = function (rpc, hideOrShow, opt_params) {
    var myGadget = OrngContainer.gadgetsByGadgetSiteId[rpc.gs.getId()];
    var parentDiv = document.getElementById('gadgets-gadget-chrome-' + my.gadgets.indexOf(myGadget));
    if ("hide" === hideOrShow) {
        // get parent div as well
        OrngContainer.closeGadget(rpc.gs);
        parentDiv.style.display = 'none'
    }
    else {
        parentDiv.style.display = 'block'
    }
};

function log(message) {
    if (my.debug == 1) {
        try {
            document.getElementById('gadgets-log').innerHTML = gadgets.util.escapeString(message) + '<br/>' + document.getElementById('gadgets-log').innerHTML;
        } catch (e) {
            // TODO: error handling should be consistent with other OS gadget initialization error handling
            alert('ERROR in logging mechanism [' + e.message + ']');
        }
    }
};

function cleanTitle(title) {
    return (title || 'Gadget').replace(/&/g, '&amp;').replace(/</g, '&lt;');
};

function removeParameterFromURL(url, parameter) {
    var urlparts = url.split('?');   // prefer to use l.search if you have a location/link object
    if (urlparts.length >= 2) {
        var prefix = encodeURIComponent(parameter) + '=';
        var pars = urlparts[1].split(/[&;]/g);
        for (var i = pars.length; i-- > 0; )               //reverse iteration as may be destructive
            if (pars[i].lastIndexOf(prefix, 0) !== -1)   //idiom for string.startsWith
                pars.splice(i, 1);
        url = urlparts[0] + '?' + pars.join('&');
    }
    return url;
};

function addParameterToURL(url, parameter, value) {
    return url + ((url.slice(-1) !== "?" && url.slice(-1) !== "&") ? "&" : "") + parameter + "=" + value;
};
