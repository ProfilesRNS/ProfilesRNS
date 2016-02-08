/*

Copyright (c) 2008-2015 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.


Code licensed under a BSD License. 
For details, see: LICENSE.txt 

----==================================================----
Cluster Network Viewer - Javascript Engine
----==================================================----

Events issued to the javascript callback by the Network Browser flash control
----------------------------------------------------
NODE_CLICK			- user clicked the node / control recenters graph
NODE_SHIFT_CLICK	- user shift clicked the node when the control is configured to disallow selections
NODE_SELECTED		- user shift clicked the node when the control is configured to allow selections
NODE_DESELECTED		- user shift clicked the node when the control is configured to allow selections
NODE_IN				- mouse cursor has entered the node
NODE_OUT			- mouse cursor has exited the node
EDGE_IN				- mouse cursor has entered the edge
EDGE_OUT			- mouse cursor has exited the edge
EDGE_CLICK			- user clicked the edge
EDGE_SHIFT_CLICK	- user shift clicked the edge when the control is configured to disallow selections
EDGE_SELECTED		- user shift clicked the edge when the control is configured to allow selections
EDGE_DESELECTED		- user shift clicked the edge when the control is configured to allow selections 
    
*/


ProfilesRNS_ClusterView = {
    cfg: {
        centerID: false,
        baseURL: false,
        width: 600,
        height: 485,
        svg_container: false,
        forces: {
            charge: -750, // Smaller charge, more repulsion.
            gravity: 0.8, // More gravity, stronger pull towards center.
            linkDist: 50		// Larger distance, more spread out.
        },
        callback: false
    },
    data: {
        active: true,
        colors: false,
        nodes: [],
        edges: [],
        adjacency: [],
        d3_force: false,
        d3_svg: false
    },
    // =========================== PUBLIC FUNCTION ===========================
    Init: function (width, height, targetElement) {
        // save info
        ProfilesRNS_ClusterView.cfg.width = width;
        ProfilesRNS_ClusterView.cfg.height = height;
        ProfilesRNS_ClusterView.cfg.svg_container = targetElement;
        ProfilesRNS_ClusterView.data.colors_fill = d3.scale.ordinal().domain([0, 1, 2]).range([d3.rgb("#F3BDB3"), d3.rgb("#CEEA9F"), d3.rgb("#B3C7EF")]);
        ProfilesRNS_ClusterView.data.colors_border = d3.scale.ordinal().domain([0, 1, 2]).range([d3.rgb("#A34E3D"), d3.rgb("#68931E"), d3.rgb("#3F5E9B")]);
        // create force engine
        var force = ProfilesRNS_ClusterView.cfg.forces;
        ProfilesRNS_ClusterView.data.d3_force = d3.layout.force()
			.charge(force.charge)
			.gravity(force.gravity)
			.linkDistance(force.linkDist)
			.size([width, height]);
        // create display element for the graph
        ProfilesRNS_ClusterView.data.d3_svg = d3.select(targetElement).append("svg")
			.attr("xmlns", "http://www.w3.org/2000/svg")
			.attr("width", width)
			.attr("height", height);
    },
    // =========================== PUBLIC FUNCTION ===========================
    loadNetwork: function (baseURL, centerID) {
        // save configuration
        ProfilesRNS_ClusterView.cfg.baseURL = baseURL;
        ProfilesRNS_ClusterView.cfg.centerID = centerID;
        // load the data
        d3.json(baseURL + centerID, function (error, json) {
            //		d3.json("data.json", function(error,json) {
            if (error) return console.warn(error);
            console.debug('loadNetwork called');

            // save the visualization data
            ProfilesRNS_ClusterView.data.nodes = json.NetworkPeople;
            ProfilesRNS_ClusterView.data.links = json.NetworkCoAuthors;

            // Define additional node variables.
            ProfilesRNS_ClusterView.data.nodes.forEach(function (d) {
                d.nodeText = d.ln + ' ' + d.fn.substring(0, 1);
                d.name = d.fn + ' ' + d.ln;
                d.fdgURL = ProfilesRNS_ClusterView.cfg.baseURL + d.id;
            });

            // Define additional link variables.
            ProfilesRNS_ClusterView.data.links.forEach(function (d) {
                d.infoText = ProfilesRNS_ClusterView.data.nodes[d.source].name;
                d.infoText += ' / '
                d.infoText += ProfilesRNS_ClusterView.data.nodes[d.target].name;
                d.infoText += ' (' + d.n + ' shared publication';
                d.infoText += (d.n != 1) ? 's)' : ')';
            });

            // at this point the graph should already be initialized so just start the animation
            ProfilesRNS_ClusterView.data.d3_force
				.nodes(ProfilesRNS_ClusterView.data.nodes)
				.links(ProfilesRNS_ClusterView.data.links)
				.start();

            // < Draw the visualization elements >

            var tSharedPubs = ProfilesRNS_ClusterView.getDataAttributeRange("EDGE", "n");
            var tPubs = ProfilesRNS_ClusterView.getDataAttributeRange("NODE", "pubs");
            // draw the links
            ProfilesRNS_ClusterView.data.d3_svg.selectAll(".link")
				.data(ProfilesRNS_ClusterView.data.links)
				.enter().append("line")
				.attr("class", "link")
				.style("stroke-width", function (d) {
				    return 1 + (d.n - tSharedPubs.min + 0.1) / (tSharedPubs.max - tSharedPubs.min + 0.1) * 9;
				});

            //					return (d.n / tSharedPubs.max) * 10 + 0.5; });
            //				.style("stroke-width", function (d) { return 0.5 + Math.min(Math.pow(d.w, 0.75), 15); });
            // draw the nodes
            var gnodes = ProfilesRNS_ClusterView.data.d3_svg.selectAll("g.gnode")
				.data(ProfilesRNS_ClusterView.data.nodes)
				.enter()
				.append('g')
				.classed('gnode', true)
				.attr('id', function (d) { return d.nodeid; })
				.on("dblclick", function (d) { window.open(d.uri, "_self"); })
				.call(ProfilesRNS_ClusterView.data.d3_force.drag);
            // Add a circle to each node group
            gnodes.append("circle")
				.attr("class", "node")
				.attr("r", function (d) {
				    return 5 + (d.pubs - tPubs.min + 0.1) / (tPubs.max - tPubs.min + 0.1) * 12;
				})
            //				.attr("r", function (d) { return 3 + Math.sqrt(d.pubs) / 2; })
				.style("stroke", function (d) { return ProfilesRNS_ClusterView.data.colors_border(d.d); })
				.style("fill-opacity", function (d) { return 0.8; })
				.style("fill", function (d) { return ProfilesRNS_ClusterView.data.colors_fill(d.d); });

            // Add a label to each node group.
            gnodes.append("text")
				.text(function (d) { return d.nodeText; })
				.attr("dy", "3px")
				.attr("text-anchor", "middle");

            // </ Draw the visualization elements >

            // generate an "Adjacency matrix"
            ProfilesRNS_ClusterView.data.adjacency = [];
            ProfilesRNS_ClusterView.data.links.forEach(function (d) {
                ProfilesRNS_ClusterView.data.adjacency[d.source.index + ',' + d.target.index] = 1;
                ProfilesRNS_ClusterView.data.adjacency[d.target.index + ',' + d.source.index] = 1;
                ProfilesRNS_ClusterView.data.adjacency[d.source.index + ',' + d.source.index] = 1;
                ProfilesRNS_ClusterView.data.adjacency[d.target.index + ',' + d.target.index] = 1;
            });

            // connect event handler (for force graph)
            ProfilesRNS_ClusterView.data.d3_force.on("tick", ProfilesRNS_ClusterView._force_tick);
            ProfilesRNS_ClusterView.data.d3_force.drag().on("dragstart", ProfilesRNS_ClusterView._eventRouter_dragstart);


            // connect event handler (for nodes)
            ProfilesRNS_ClusterView.data.d3_svg.selectAll("g.gnode")
				.on("mouseover", ProfilesRNS_ClusterView._eventRouter_mouseover)
				.on("mouseout", ProfilesRNS_ClusterView._eventRouter_mouseout)
				.on("mousedown", ProfilesRNS_ClusterView._eventRouter_mousedown);

            // connect event handler (for links)
            ProfilesRNS_ClusterView.data.d3_svg.selectAll(".link")
				.on("mouseover", ProfilesRNS_ClusterView._eventRouter_mouseover)
				.on("mouseout", ProfilesRNS_ClusterView._eventRouter_mouseout)
				.on("mousedown", ProfilesRNS_ClusterView._eventRouter_mousedown);


            // ++++ SEND EVENT SIGNAL TO USER CALLBACK FOR ADDITIONAL FUNCTIONALITY AND PROPER SEPARATION OF CODE ++++
            if (ProfilesRNS_ClusterView.cfg.callback !== false) {
                ProfilesRNS_ClusterView.cfg.callback.call(ProfilesRNS_ClusterView.cfg.callback, "NETWORK_LOADED", true);
            }

            // call watchdog.cancel() to prevent error message from showing in HTML
            watchdog.cancel();
        });
    },
    // =========================== PUBLIC FUNCTION ===========================
    centerOn: function (nodeID) {
        console.warn("centerOn() not finished");
    },
    // =========================== PUBLIC FUNCTION ===========================
    clearNetwork: function () {
        console.warn("clearNetwork() not finished");
    },
    // =========================== PUBLIC FUNCTION ===========================
    getDataAttributeRange: function (objType, objAttrib) {
        // make sure the callback is already set before doing all the data processing
        if (typeof ProfilesRNS_ClusterView.cfg.callback !== "function") { return false; }
        // which dataset?
        switch (objType) {
            case "NODE":
                var t = ProfilesRNS_ClusterView.data.nodes;
                break;
            case "EDGE":
                var t = ProfilesRNS_ClusterView.data.links;
                break;
            default:
                return false;
                break;
        }
        // find the max and min (and make note of missing attribute values)
        var l = t.length;
        var max = 0;
        var min = 999999;
        var invalid = false;
        for (var i = 0; i < l; i++) {
            if (typeof t[i][objAttrib] !== "undefined") {
                if (t[i][objAttrib] > max) { max = t[i][objAttrib]; }
                if (t[i][objAttrib] < min) { min = t[i][objAttrib]; }
            } else {
                invalid = true;
            }
        }
        // send the results using the callback function
        var ret = {
            type: objType,
            attribute: objAttrib,
            invalidAttribute: invalid,
            max: max,
            min: min
        }
        ProfilesRNS_ClusterView.cfg.callback("DATA_RANGE", ret);
        return ret;
    },
    // =========================== PUBLIC FUNCTION ===========================
    dumpEdges: function () {
        console.warn("dumpEdges() not implemented");
    },
    // =========================== PUBLIC FUNCTION ===========================
    dumpNodes: function () {
        console.warn("dumpNodes() not implemented");
    },
    // =========================== PUBLIC FUNCTION ===========================
    addFilter: function (objType, type, attribute, valueMin, valueMax) {
        console.warn("addFilter() not implemented");
    },
    // =========================== PUBLIC FUNCTION ===========================
    removeFilter: function (objType, type, attribute) {
        console.warn("removeFilter() not implemented");
    },
    // =========================== PUBLIC FUNCTION ===========================
    registerCallback: function (callbackRef) {
        if (typeof callbackRef === 'string') {
            alert('The HTML5 visualization requires that the [registerCallback] function receive the callback function as a reference not a string!');
            return false;
        }
        ProfilesRNS_ClusterView.cfg.callback = callbackRef;
    },
    // =========================== PRIVATE FUNCTION ===========================
    _GetGraphElementType: function (a) {
        if (typeof a.nodeText === 'undefined') {
            return "EDGE";
        } else {
            return "NODE";
        }
    },
    // =========================== PRIVATE FUNCTION ===========================
    _neighboring: function (a, b) {
        return ProfilesRNS_ClusterView.data.adjacency[a.index + ',' + b.index];
    },
    // =========================== PRIVATE FUNCTION ===========================
    _force_tick: function () {
        if (ProfilesRNS_ClusterView.data.active === false) { return; }
        // update link positions
        ProfilesRNS_ClusterView.data.d3_svg.selectAll('.link')
			.attr("x1", function (d) { return Math.max(Math.min(d.source.x, ProfilesRNS_ClusterView.cfg.width - 50), 50); })
			.attr("y1", function (d) { return Math.max(Math.min(d.source.y, ProfilesRNS_ClusterView.cfg.height - 20), 20); })
			.attr("x2", function (d) { return Math.max(Math.min(d.target.x, ProfilesRNS_ClusterView.cfg.width - 50), 50); })
			.attr("y2", function (d) { return Math.max(Math.min(d.target.y, ProfilesRNS_ClusterView.cfg.height - 20), 20); });
        // update node positions (specialized to force circlular orbits)
        ProfilesRNS_ClusterView.data.d3_svg.selectAll('g.gnode')
			.attr("transform", function (d) {
			    return 'translate(' + [Math.max(Math.min(d.x, ProfilesRNS_ClusterView.cfg.width - 50), 50), Math.max(Math.min(d.y, ProfilesRNS_ClusterView.cfg.height - 20), 20)] + ')';
			});
    },
    // =========================== PRIVATE FUNCTION (INTERACTION EVENT HANDLERS) ===========================
    _extractKeys: function (mouseEvent) {
        var temp = [];
        if (mouseEvent.shiftKey) { temp.push("SHIFT"); }
        if (mouseEvent.altKey) { temp.push("ALT"); }
        if (mouseEvent.ctrlKey) { temp.push("CTRL"); }
        temp = temp.join("_");
        return { alt: mouseEvent.altKey, ctrl: mouseEvent.ctrlKey, shift: mouseEvent.shiftKey, keyString: temp };
    },
    _eventRouter_dragstart: function (a) {
        ProfilesRNS_ClusterView._mouse_events.call(ProfilesRNS_ClusterView, "dragstart", ProfilesRNS_ClusterView._extractKeys(d3.event.sourceEvent), a, this);
    },
    _eventRouter_mouseover: function (a) {
        ProfilesRNS_ClusterView._mouse_events.call(ProfilesRNS_ClusterView, "mouseover", ProfilesRNS_ClusterView._extractKeys(d3.event), a, this);
    },
    _eventRouter_mouseout: function (a) {
        ProfilesRNS_ClusterView._mouse_events.call(ProfilesRNS_ClusterView, "mouseout", ProfilesRNS_ClusterView._extractKeys(d3.event), a, this);
    },
    _eventRouter_mousedown: function (a) {
        ProfilesRNS_ClusterView._mouse_events.call(ProfilesRNS_ClusterView, "mousedown", ProfilesRNS_ClusterView._extractKeys(d3.event), a, this);
    },
    _mouse_events: function (eventname, keys, obj, el) {
        // ++++ MAIN EVENT HANDLER ++++
        // build the event string
        var externEventName = [ProfilesRNS_ClusterView._GetGraphElementType(obj)];
        if (keys.keyString.length > 0) { externEventName.push(keys.keyString); }
        switch (eventname) {
            case 'mousedown':
                externEventName = externEventName.join("_") + "_CLICK";
                break;
            case 'mouseover':
                externEventName = externEventName.join("_") + "_IN";
                break;
            case 'mouseout':
                externEventName = externEventName.join("_") + "_OUT";
                break;
            case 'dragstart':
                externEventName = externEventName.join("_") + "_DRAGSTART";
                break;
            //            default: 
            //                console.warn('got event [' + eventname + ']'); 
            //                break; 
        }
        // now do any local GUI processing based on the event string value
        switch (externEventName) {
            case "NODE_IN":
            case "NODE_CTRL_IN":
            case "NODE_ALT_IN":
            case "NODE_SHIFT_IN":
                ProfilesRNS_ClusterView.data.d3_svg.selectAll(".link")
					.style('stroke', function (l) { return (obj === l.source || obj === l.target) ? '#F00' : '#BBB'; })
					.style('stroke-opacity', function (l) { return (obj === l.source || obj === l.target) ? 1 : 0.45; });
                ProfilesRNS_ClusterView.data.d3_svg.selectAll("g.gnode circle")
					.style('stroke', function (d) { return ProfilesRNS_ClusterView._neighboring(d, obj) ? '#F00' : ProfilesRNS_ClusterView.data.colors_border(d.d); })
					.style('stroke-width', function (d) { return ProfilesRNS_ClusterView._neighboring(d, obj) ? '2px' : '1px'; });
                break;
            case "NODE_OUT":
            case "EDGE_OUT":
            case "NODE_CTRL_OUT":
            case "EDGE_CTRL_OUT":
            case "NODE_ALT_OUT":
            case "EDGE_ALT_OUT":
            case "NODE_SHIFT_OUT":
            case "EDGE_SHIFT_OUT":
                ProfilesRNS_ClusterView.data.d3_svg.selectAll("g.gnode circle")
					.style('stroke', function (d) { return ProfilesRNS_ClusterView.data.colors_border(d.d); })
					.style('stroke-width', '1px');
                ProfilesRNS_ClusterView.data.d3_svg.selectAll(".link")
					.style('stroke', '#BBB')
					.style('stroke-opacity', 0.45);
                break;
            case "EDGE_IN":
            case "EDGE_CTRL_IN":
            case "EDGE_ALT_IN":
            case "EDGE_SHIFT_IN":
            case "EDGE_CLICK":
                // highlight link
                d3.select(el)
					.style('stroke', '#F00')
					.style('stroke-opacity', 1);
                // highlight the two nodes
                d3.select($("" + obj.nodeid1)).selectAll('circle')
					.style('stroke', '#F00')
					.style('stroke-width', '2px');
                d3.select($("" + obj.nodeid2)).selectAll('circle')
					.style('stroke', '#F00')
					.style('stroke-width', '2px');
                break;
            case "NODE_CLICK":
            case "NODE_DRAGSTART":
            case "NODE_SHIFT_DRAGSTART":
                if (keys.shift === true) {
                    obj.fixed |= 0x08;
                } else {
                    obj.fixed &= ~0x08;
                }
                break;
            case "NODE_CTRL_CLICK":
            case "NODE_ALT_CLICK":
                // stop the visualization in preparation of page naviation
                ProfilesRNS_ClusterView.data.active = false;
                break;
            //            default: 
            //                alert(externEventName); 
            //                break; 
        }

        //		console.warn(externEventName);
        // ++++ SEND EVENT SIGNAL TO USER CALLBACK FOR ADDITIONAL FUNCTIONALITY AND PROPER SEPARATION OF CODE ++++
        if (ProfilesRNS_ClusterView.cfg.callback !== false) {
            ProfilesRNS_ClusterView.cfg.callback(externEventName, obj);
        }
    }
}