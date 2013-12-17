/*
Orng Shindig Helper functions for gadget-to-container commands

NOTE THAT WE minimize this via http://closure-compiler.appspot.com/home and save the results as orng.min.js to load!!!!!!!!!!!!!!!!!!!!!!!!!

*/

// This allows us to use Google Analytics when present, but not throw errors when not.
var _gaq = _gaq || {};

// pubsub
gadgets.pubsubrouter.init(function (id) {
    return my.gadgets[shindig.container.gadgetService.getGadgetIdFromModuleId(id)].url;
}, {
    onSubscribe: function (sender, channel) {
        setTimeout("my.callORNGResponder('" + channel + "')", 3000);
        // return true to reject the request.
        return false;
    },
    onUnsubscribe: function (sender, channel) {
        //alert(sender + " unsubscribes from channel '" + channel + "'");
        // return true to reject the request.
        return false;
    },
    onPublish: function (sender, channel, message) {
        // return true to reject the request.

        // track with google analytics
        if (sender != '..') {
            var moduleId = shindig.container.gadgetService.getGadgetIdFromModuleId(sender);
        }

        if (channel == 'status') {
            // message should be of the form 'COLOR:Message Content'
            var statusId = document.getElementById(sender + '_status');
            if (statusId) {
                var messageSplit = message.split(':');
                if (messageSplit.length == 2) {
                    statusId.style.color = messageSplit[0];
                    statusId.innerHTML = messageSplit[1];
                }
                else {
                    statusId.innerHTML = message;
                }
            }
        }
        else if (channel == 'analytics') {
            // publish to google analytics
            // message should be JSON encoding object with required action and optional label and value 
            // as documented here: http://code.google.com/apis/analytics/docs/tracking/eventTrackerGuide.html
            // note that event category will be set to the gadget label automatically by this code
            // Note: message will be already converted to an object 
            if (message.hasOwnProperty('value')) {
                _gaq.push(['_trackEvent', my.gadgets[moduleId].label, message.action, message.label, message.value]);
            }
            else if (message.hasOwnProperty('label')) {
                _gaq.push(['_trackEvent', my.gadgets[moduleId].label, message.action, message.label]);
            }
            else {
                _gaq.push(['_trackEvent', my.gadgets[moduleId].label, message.action]);
            }
        }
        else if (channel == 'profile') {
            _gaq.push(['_trackEvent', my.gadgets[moduleId].label, 'go_to_profile', message]);
            document.location.href = '/' + location.pathname.split('/')[1] + '/display/n' + message;
        }
        else if (channel == 'JSONPersonIds') {
            // do nothing, no need to alert
        }
        else if (channel == 'hide') { // still used by Knode search
            document.getElementById(sender).parentNode.parentNode.style.display = 'none';
        }
        else {
            alert(sender + " publishes '" + message + "' to channel '" + channel + "'");
        }
        return false;
    }
});

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

my.callORNGResponder = function (channel) {
    // send an ajax command to the server letting them know we need data
    var event = { "guid": my.guid, "request": channel };
    var makeRequestParams = {
        "CONTENT_TYPE": "JSON",
        "METHOD": "POST",
        "POST_DATA": gadgets.json.stringify(event)
    };

    gadgets.io.makeNonProxiedRequest(_rootDomain + "/ORNG/Default.aspx/CallORNGResponder",
      function (data) {
          gadgets.pubsubrouter.publish(channel, data.data.d);
      },
      makeRequestParams,
      "application/json"
    );
  };

my.removeParameterFromURL = function (url, parameter) {
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

// publish the people
my.CallSuccess = function (result) {
    gadgets.pubsubrouter.publish('person', result);
};

// alert message on some failure
my.CallFailed = function (error) {
    alert(error.get_message());
};

my.requestGadgetMetaData = function (view, opt_callback) {
    var request = {
        context: {
            country: "default",
            language: "default",
            view: view,
            ignoreCache: my.noCache,
            container: "default"
        },
        gadgets: []
    };

    for (var moduleId = 0; moduleId < my.gadgets.length; moduleId++) {
        // only add those with matching views
        if (my.gadgets[moduleId].view == view) {
            request.gadgets[request.gadgets.length] = { 'url': my.gadgets[moduleId].url, 'moduleId': moduleId };
        }
    }

    var makeRequestParams = {
        "CONTENT_TYPE": "JSON",
        "METHOD": "POST",
        "POST_DATA": gadgets.json.stringify(request)
    };

    gadgets.io.makeNonProxiedRequest(my.openSocialURL + "/gadgets/metadata",
      function (data) {
          data = data.data;
          if (opt_callback) {
              opt_callback(data);
          }
      },
      makeRequestParams,
      "application/javascript"
    );
};

my.renderableGadgets = [];

my.generateGadgets = function (metadata) {
    // put them in moduleId order
    for (var i = 0; i < metadata.gadgets.length; i++) {
        var moduleId = metadata.gadgets[i].moduleId;
        // Notes by Eric.  Not sure if I should have to calculate this myself, but I will.
        var height = metadata.gadgets[i].height;
        var width = metadata.gadgets[i].width;
        if (metadata.gadgets[i].views) {
            var viewPrefs = metadata.gadgets[i].views[my.gadgets[moduleId].view];
            if (viewPrefs) {
                height = viewPrefs.preferredHeight || height;
                width = viewPrefs.preferredWidth || width;
            }
        }

        var opt_params = { 'specUrl': metadata.gadgets[i].url, 'secureToken': my.gadgets[moduleId].secureToken,
            'title': metadata.gadgets[i].title, 'userPrefs': metadata.gadgets[i].userPrefs,
            'height': height, 'width': width, 'debug': my.debug
        };

        // do a shallow merge of the opt_params from the database.  This will overwrite anything with the same name, and we like that 
        for (var attrname in my.gadgets[moduleId].opt_params) {
            opt_params[attrname] = my.gadgets[moduleId].opt_params[attrname];
        }

        my.renderableGadgets[moduleId] = shindig.container.createGadget(opt_params);
        // set the metadata for easy access
        my.renderableGadgets[moduleId].setMetadata(metadata.gadgets[i]);
    }
    // this will be called multiple times, only render when all gadgets have been processed
    var ready = my.renderableGadgets.length == my.gadgets.length;
    for (var i = 0; ready && i < my.renderableGadgets.length; i++) {
        if (!my.renderableGadgets[i]) {
            ready = false;
        }
    }

    if (ready) {
        shindig.container.addGadgets(my.renderableGadgets);
        shindig.container.renderGadgets();
    }
};

my.init = function () {
    // overwrite this RPC function.  Do it at this level so that rpc.f (this.f) is accessible for getting module ID
    //    gadgets.rpc.register('requestNavigateTo', doProfilesNavigation);
    shindig.container = new ORNGContainer();

    shindig.container.gadgetService = new ORNGGadgetService();
    shindig.container.layoutManager = new ORNGLayoutManager();

    shindig.container.setNoCache(my.noCache);

    // since we render multiple views, we need to do somethign fancy by swapping out this value in getIframeUrl
    shindig.container.setView('REPLACE_THIS_VIEW');

    // do multiple times as needed if we have multiple views
    // find out what views are being used and call requestGadgetMetaData for each one
    var views = {};
    for (var moduleId = 0; moduleId < my.gadgets.length; moduleId++) {
        var view = my.gadgets[moduleId].view;
        if (!views[view]) {
            views[view] = view;
            my.requestGadgetMetaData(view, my.generateGadgets);
        }
    }

    // create dummy function if necessary so google analytics does not break for institutions who do not use it
    if (typeof _gaq.push != 'function') {
        _gaq.push = function (data) { };
    }
};

//ORNGContainer

ORNGContainer = function () {
    shindig.IfrContainer.call(this);
};

ORNGContainer.inherits(shindig.IfrContainer);

ORNGContainer.prototype.createGadget = function (opt_params) {
    if (opt_params.gadget_class) {
        return new window[opt_params.gadget_class](opt_params);
    }
    else {
        return new ORNGGadget(opt_params);
    }
}

// ORNGLayoutManager. 
ORNGLayoutManager = function () {
    shindig.LayoutManager.call(this);
};

ORNGLayoutManager.inherits(shindig.LayoutManager);

ORNGLayoutManager.prototype.getGadgetChrome = function (gadget) {
    var layoutRoot = document.getElementById(my.gadgets[gadget.id].chrome_id);
    if (layoutRoot) {
        var chrome = document.createElement('div');
        chrome.className = 'gadgets-gadget-chrome';
        layoutRoot.appendChild(chrome);
        return chrome;
    } else {
        return null;
    }
};

// ORNGGadgetService
ORNGGadgetService = function () {
    shindig.IfrGadgetService.call(this);
};

ORNGGadgetService.inherits(shindig.IfrGadgetService);

ORNGGadgetService.prototype.setTitle = function (title) {
    var moduleId = shindig.container.gadgetService.getGadgetIdFromModuleId(this.f);
    if (my.gadgets[moduleId].view == 'canvas') {
        ORNGGadgetService.setCanvasTitle(title);
    }
    else {
        var element = document.getElementById(this.f + '_title');
        if (element) {
            element.innerHTML = my.renderableGadgets[moduleId].getTitleHtml(title);
        }
    }
};

ORNGGadgetService.setCanvasTitle = function (title) {
    document.getElementById("gadgets-title").innerHTML = title.replace(/&/g, '&amp;').replace(/</g, '&lt;');
}

ORNGGadgetService.prototype.requestNavigateTo = function (view, opt_params) {
    var urlTemplate = gadgets.config.get('views')[view].urlTemplate;
    var url = urlTemplate || 'OpenSocial.aspx?';

    url += window.location.search.substring(1);

    // remove appId if present
    url = my.removeParameterFromURL(url, 'appId');

    // Add appId if the URL Template begins with the word 'ORNG'
    if (urlTemplate.indexOf('ORNG') == 0) {
        var moduleId = shindig.container.gadgetService.getGadgetIdFromModuleId(this.f);
        var appId = my.gadgets[moduleId].appId;
        url += '&appId=' + appId;
    }

    if (opt_params) {
        var paramStr = gadgets.json.stringify(opt_params);
        if (paramStr.length > 0) {
            url += '&appParams=' + encodeURIComponent(paramStr);
        }
    }
    if (url && document.location.href.indexOf(url) == -1) {
        document.location.href = _rootDomain + '/' + url;
    }
};

// ORNGGadget
ORNGGadget = function (opt_params) {
    //shindig.BaseIfrGadget.call(this, opt_params);  need to override
    shindig.Gadget.call(this, opt_params);
    this.serverBase_ = my.openSocialURL + "/gadgets/";
    this.queryIfrGadgetType_();
    // done with override
    this.debug = my.debug;
    var gadget = this;
    var subClass = shindig.IfrGadget;
    this.metadata = {};
    for (var name in subClass) if (subClass.hasOwnProperty(name)) {
        if (name == 'getIframeUrl') {
            // we need to keep this old one
            gadget['originalGetIframeUrl'] = subClass[name];
        }
        else if (name != 'finishRender') {
            gadget[name] = subClass[name];
        }
    }
};

ORNGGadget.inherits(shindig.BaseIfrGadget);

ORNGGadget.prototype.setMetadata = function (metadata) {
    this.metadata = metadata;
};

ORNGGadget.prototype.hasFeature = function (feature) {
    for (var i = 0; i < this.metadata.features.length; i++) {
        if (this.metadata.features[i] == feature) {
            return true;
        }
    }
    return false;
};

ORNGGadget.prototype.getAdditionalParams = function () {
    var params = '';
    for (var key in my.gadgets[this.id].additionalParams) {
        params += '&' + key + '=' + my.gadgets[this.id].additionalParams[key];
    }
    return params;
};

ORNGGadget.prototype.getIframeUrl = function () {
    var url = this.originalGetIframeUrl();
    return url.replace('REPLACE_THIS_VIEW', my.gadgets[this.id].view);
};

ORNGGadget.prototype.getTitleHtml = function (title) {
    return title ? title.replace(/&/g, '&amp;').replace(/</g, '&lt;') : 'Gagdget';
};

ORNGGadget.prototype.getTitleBarContent = function (continuation) {
    if (my.gadgets[this.id].view == 'canvas') {
        ORNGGadgetService.setCanvasTitle(this.title);
        continuation('<span class="gadgets-gadget-canvas-title"></span>');
    }
    else {
        continuation();
    }
};

ORNGGadget.prototype.finishRender = function (chrome) {
    window.frames[this.getIframeId()].location = this.getIframeUrl();
    if (chrome && this.width) {
        // set the gadget box width, and remember that we always render as open
        chrome.style.width = this.width + 'px';
    }
};

// ORNGTitleBarGadget
ORNGTitleBarGadget = function (opt_params) {
    ORNGGadget.call(this, opt_params);
};

ORNGTitleBarGadget.inherits(ORNGGadget);

ORNGTitleBarGadget.prototype.getTitleHtml = function (title) {
    return title ? title.replace(/&/g, '&amp;').replace(/</g, '&lt;') : 'Gagdget';
};

ORNGTitleBarGadget.prototype.getTitleBarContent = function (continuation) {
    if (my.gadgets[this.id].view == 'canvas') {
        ORNGGadgetService.setCanvasTitle(this.title);
        continuation('<span class="gadgets-gadget-canvas-title"></span>');
    }
    else {
        continuation(
	      '<div id="' + this.cssClassTitleBar + '-' + this.id +
	      '" class="' + this.cssClassTitleBar + '"><span class="' +
	      this.cssClassTitleButtonBar + '">' +
	      '</span> <span id="' +
	      this.getIframeId() + '_title" class="' + this.cssClassTitle + '">' +
	      this.getTitleHtml(this.title) + '</span><span id="' +
		  this.getIframeId() + '_status" class="gadgets-gadget-status"></span></div>');
    }
};