/*  
 
Copyright (c) 2008-2015 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.


Code licensed under a BSD License. 
For details, see: LICENSE.txt 
  
HTML5/d3-Based Network Visualizer  

Author(s): Nick Benik

*/
function RadialGraph_Visualization(svg_reference, config) {
		var that = this;
		var nid = 0;
		this.config = (typeof config === "undefined" ? {} : config);
		var svgDims = svg_reference.parentNode.getBoundingClientRect();
		this.svg = {
				ref: svg_reference,
				width: Math.round(svgDims.width),
				height: Math.round(svgDims.height),
				center_x: Math.round(svgDims.width / 2),
				center_y: Math.round(svgDims.height / 2)
		};
		this.svg.offset_x = Math.floor(this.svg.width/2);
		this.svg.offset_y = Math.floor(this.svg.height/2);
		this.data = {
			center_id: undefined,
			hover_el: null,
			hover_evt: null,
			hover_active: true,
			nodes: [],
			edges: [],
			adjmtx: {},
			ranges: {
				nodes: {},
				edges: {}
			},
			filters: {
				node: d3.map(null, function(d) {return d.attrib; }),
				edge: d3.map(null, function(d) {return d.attrib; })
			}
		};
		// this should be replaced for loading from remote data sources
		this.nid_func_DEFAULT = function(obj) { nid++; return nid;}
		this.nid_func = function(obj) { return parseInt(obj.id);}

		// attach the master mouse event handler
		var mouseMaster = this._handleMouseEvents.bind(this);
		d3.select(this.svg.ref).on({
//			mousemove: mouseMaster,
			mouseenter: mouseMaster,
			mouseover: mouseMaster
		});
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.setFilter = function(type, attribute, min, max) {
	// only one filter is allowed per element-addribute (elements being [NODE,EDGE])
	// anything within the filter range (inclusive) is NOT FILTERED
	if (type != 'edge' && type != 'node') { return false; }
	var f = this.data.filters[type];
	// delete the filter?
	if (min===null && max===null) {
		f.remove(attribute);
	} else {
		// update data values
		if (f.has(attribute)) {
			var t = f.get(attribute);
			t['min'] = min;
			t['max'] = max;
		} else {
			var t = {'min':min, 'max':max};
		}
		f.set(attribute,t);
	}

	// clear filtering
	d3.selectAll('.radialVizNode.filtered, .radialVizEdge.filtered').classed({filtered:false});

	// reapply filter criteria for nodes
	this.data.filters.node.forEach(function(attrib,range) {
		d3.selectAll('.radialVizNode').each(function(el) {
			var data = this.__data__;
			if (typeof data[attrib] !== undefined) {
				if (data[attrib] < range.min || data[attrib] < range.max) {
					d3.select(this).classed({filtered:true});
				}
			}
		});
	});
	
	// reapply filter criteria for edges
	this.data.filters.edge.forEach(function(attrib,range) {
		d3.selectAll('.radialVizEdge').each(function(el) {
			var data = this.__data__;
			if (typeof data[attrib] !== undefined) {
				if (data[attrib] < range.min || data[attrib] < range.max) {
					d3.select(this).classed({filtered:true});
				}
			}
		});
	});
	

};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.clearNetwork = function() {};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.loadNetwork = function(url, id) {
	this.data.center_id = id;
	d3.json(url, this.loadedNetwork.bind(this));
//		d3.text(url, this.loadedNetworkXML.bind(this));
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.loadedNetworkXML = function(error, retTxt) {
    // EXECUTE THIS USING d3.text() CALL!!! 
    // this allows us to assume the headers are mismatched to the MIME type

    if (typeof retTxt === "undefined") {
        alert("No data was retured from the site or your browser has incorrect security settings.");
        return true;
    }

    // load the text into an XML document (thanking IE as usual)
    if (window.DOMParser) {
        var xml = (new window.DOMParser()).parseFromString(retTxt, "text/xml");
    } else if (typeof window.ActiveXObject != "undefined" && new window.ActiveXObject("Microsoft.XMLDOM")) {
        var xml = new window.ActiveXObject("Microsoft.XMLDOM");
        xml.async = "false";
        xml.loadXML(retTxt);
    } else {
        var xml = null;
    }

    // clear previous data/visual elements
    this.clearNetwork();

    // processes nodes
    this.data.nodes = {};
    var nl = xml.getElementsByTagName('NetworkPerson');
    var l = nl.length;
    for (var i = 0; i < l; i++) {
        var nid = nl[i].getAttribute('id');
        this.data.nodes[nid] = {
            "nid": nid,
            "id": nid,
            "lid": nl[i].getAttribute('lid'),
            "uri": nl[i].getAttribute('uri'),
            "fn": nl[i].getAttribute('fn'),
            "ln": nl[i].getAttribute('ln'),
            "pubs": nl[i].getAttribute('pubs') * 1,
            "w2": nl[i].getAttribute('w2') * 1,
            "d": nl[i].getAttribute('d')
        };
        this.data.nodes[nid].label = this.data.nodes[nid]['ln'] + " " + this.data.nodes[nid]['fn'].substr(0, 1);
        this.data.nodes[nid].x = 0;
        this.data.nodes[nid].y = 0;
        this.data.nodes[nid].polar = { "new": [0, 0] };
    }

    // processes the edges and build adjacency matrix
    this.data.edges = [];
    this.data.adjmtx = {};
    var nl = xml.getElementsByTagName('NetworkCoAuthor');
    var l = nl.length;
    for (var i = 0; i < l; i++) {
        this.data.edges[i] = {
            "id1": nl[i].getAttribute('id1'),
            "id2": nl[i].getAttribute('id2'),
            "lid1": nl[i].getAttribute('lid1'),
            "lid2": nl[i].getAttribute('lid2'),
            "uri1": nl[i].getAttribute('uri1'),
            "uri2": nl[i].getAttribute('uri2'),
            "n": nl[i].getAttribute('n') * 1,
            "w": nl[i].getAttribute('w') * 1,
            "yr1": nl[i].getAttribute('y1') * 1,
            "yr2": nl[i].getAttribute('y2') * 1
        };
        var temp = this.data.edges[i];
        // we populate matrix using sub-objects (O^n) and later convert to sub-arrays
        if (typeof this.data.adjmtx[temp.id1] === 'undefined') { this.data.adjmtx[temp.id1] = {}; }
        this.data.adjmtx[temp.id1][temp.id2] = true;
        if (typeof this.data.adjmtx[temp.id2] === 'undefined') { this.data.adjmtx[temp.id2] = {}; }
        this.data.adjmtx[temp.id2][temp.id1] = true;
    }

    // convert adjacency matrix from sub-objects to sub-arrays
    var keylist = d3.keys(this.data.adjmtx);
    var l = keylist.length;
    for (var i = 0; i < l; i++) {
        this.data.adjmtx[keylist[i]] = d3.keys(this.data.adjmtx[keylist[i]]);
    }

    // Calculate the ranges needed for later use
    this.getDataRange('NODE', 'pubs', true);
    this.getDataRange('EDGE', 'w', true);
    this.getDataRange('EDGE', 'yr2', true);
    this.getDataRange('EDGE', 'n', true);


    // generate the visual elements
    this._generateEdges();
    this._generateNodes();
    this.centerOn(this.data.center_id, false);
    d3.select('#node' + this.data.center_id).classed({ 'central': true });
    this.svg.ref.style.visibility = 'visible';

    // connect the filter sliders
    this._connectSliders();
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.loadedNetwork = function(error, json) {
	this.clearNetwork();

	// processes nodes
	this.data.nodes ={};
	var l = json.NetworkPeople.length;
	for (var i=0; i<l; i++) {
		var node = json.NetworkPeople[i];
		node.nid = this.nid_func(node);
		node.label = node.fn + " " + node.ln;
		node.x = 0;
		node.y = 0;
		node.polar = {"new": [0,0]}; // in the form of [theta,radius]
		this.data.nodes[node.nid] = node;
	}
	
	// process edges (and adjacency matrix)
	this.data.edges ={};
	this.data.adjmtx = {};
	var l = json.NetworkCoAuthors.length;
	for (var i=0; i<l; i++) {
		var temp = json.NetworkCoAuthors[i];
		delete temp.source;
		delete temp.target;
		this.data.edges[i] = temp;
		
		// we populate matrix using sub-objects (O^n) and later convert to sub-arrays
		if (typeof this.data.adjmtx[temp.id1] === 'undefined') { this.data.adjmtx[temp.id1] = {}; }
		this.data.adjmtx[temp.id1][temp.id2] = true;
		if (typeof this.data.adjmtx[temp.id2] === 'undefined') { this.data.adjmtx[temp.id2] = {}; }
		this.data.adjmtx[temp.id2][temp.id1] = true;			
	}
	// remove convert adjacency matrix from sub-objects to sub-arrays
	var keylist = d3.keys(this.data.adjmtx);
	var l = keylist.length;
	for (var i=0; i<l; i++) {
		this.data.adjmtx[keylist[i]] = d3.keys(this.data.adjmtx[keylist[i]]);
	}

        // Calculate the ranges needed for later use
	this.getDataRange('NODE', 'pubs', true);
	this.getDataRange('EDGE', 'w', true);
	this.getDataRange('EDGE', 'y2', true);
	this.getDataRange('EDGE', 'n', true);
        
        // generate the visual elements        this._generateEdges();
        this._generateNodes();
        this.centerOn(this.data.center_id, false);
        d3.select('#node' + this.data.center_id).classed({ 'central': true });
        this.svg.ref.style.visibility = 'visible';

        // connect the filter sliders
        this._connectSliders();
    };
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._connectSliders = function() {
	network_sliders.Init(this);
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.centerOn = function (nodeID, animate) {
    // calculate the new layout
    var layout_eng = new RadialGraph_Layout(this.data.nodes, this.data.edges, this.data.adjmtx);
    layout_eng.plot(nodeID);

    // recalculate the hop radius based on the max hop distance
    this.config.radius = ((this.svg.width / 2) * 0.90) / layout_eng.getMaxHops();

    var polars = layout_eng.getLocationsPolar(this.config.radius);

    // copy the new layout to the nodes
    var keylist = d3.keys(polars);
    var l = keylist.length;
    for (var i = 0; i < l; i++) {
        if (keylist[i] == parseInt(keylist[i])) {
            // copy the new polar values to the old values
            this.data.nodes[polars[keylist[i]].id].polar.old = this.data.nodes[polars[keylist[i]].id].polar['new'];
            // update the new polar values [theta]
            this.data.nodes[polars[keylist[i]].id].polar['new'] = [polars[keylist[i]].t, polars[keylist[i]].r];
        } 
    }

    // update the global center node identifier
    this.data.center_id = nodeID;

    // nasty scope hacking closure functions
    var func_UpdateXY = (function (d) {
        var offset_x = this.svg.center_x;
        var offset_y = this.svg.center_y;
        var r = d.polar['new'][1];
        var a = (d.polar['new'][0] * Math.PI / 180);
        var x = Math.floor(r * Math.cos(a));
        var y = Math.floor(-r * Math.sin(a));
        d.x = offset_x + x;
        d.y = offset_y + y;
    }).bind(this);
    // (...see above)
    var func_UpdateEdges = (function (d) {
        var node = this.data.nodes[d.id1];
        d.x1 = node.x;
        d.y1 = node.y;
        var node = this.data.nodes[d.id2];
        d.x2 = node.x;
        d.y2 = node.y;
    }).bind(this);


    // are we doing an animation?
    if (animate == true) {
        // copy the old theta value for the new center node so that the animation is a straight line to center position
        this.data.nodes[nodeID].polar['new'][0] = this.data.nodes[nodeID].polar.old[0];

        // build the D3 transition animation
        var func_animateNodes = function (d, i, a) {
            var node_cnt = d3.values(this.data.nodes).length;
            var cx = this.svg.center_x;
            var cy = this.svg.center_y;
            var i1 = d3.interpolateRound(d.polar['old'][0], d.polar['new'][0]);
            var i2 = d3.interpolateRound(d.polar['old'][1], d.polar['new'][1]);
            return function (t) {
                var r = i2(t);
                var a = (i1(t) * Math.PI / 180);
                d.x = cx + Math.floor(r * Math.cos(a));
                d.y = cy + Math.floor(-r * Math.sin(a));
                if (i == node_cnt - 1) {
                    // once all the nodes have been updated for this frame
                    // we need to also update all the edges
                    d3.selectAll(".radialVizEdge")
						.each(func_UpdateEdges)
						.attr("x1", function (d) { return d.x1; })
						.attr("y1", function (d) { return d.y1; })
						.attr("x2", function (d) { return d.x2; })
						.attr("y2", function (d) { return d.y2; });
                }
                return "translate(" + d.x + "," + d.y + ")";
            };
        };

        d3.select(this.svg.ref).selectAll(".radialVizNode")
			.transition()
				.duration(1500)
				.attrTween("transform", func_animateNodes.bind(this));
    } else {
        // place the nodes [NO ANIMATION]
        var nodes = d3.select(this.svg.ref).selectAll(".radialVizNode")
			.each(func_UpdateXY)
			.attr("transform", function (d, i) { return "translate(" + d.x + "," + d.y + ")"; });

        // move the edges
        var edges = d3.select(this.svg.ref).selectAll(".radialVizEdge")
			.each(func_UpdateEdges)
			.attr("x1", function (d) { return d.x1; })
			.attr("y1", function (d) { return d.y1; })
			.attr("x2", function (d) { return d.x2; })
			.attr("y2", function (d) { return d.y2; });
    }
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._highlighter = function(type, element) {

	switch (type) {
		case "NONE":
			d3.select(this.svg.ref).selectAll('.hover, .focus').classed({hover:false, focus:false});
			$('graph_info').textContent = '';
			this.data.hover_active = true;
			break;
		case "NODE":
			// display info on node
			var d = element.__data__;
			var txt = d.fn + ' ' + d.ln + ' ('+d.pubs;
			if (d.pubs == 1) {
				txt = txt + ' publication)';
			} else {
				txt = txt + ' publications)';
			}
			$('graph_info').textContent = txt;

			// highlight node under mouse
			d3.select(element).classed({hover:false, focus:true});


			// nodes
			var targets = d3.selectAll('.radialVizNode')[0]
				.filter(function(n) { return (this.indexOf(String(n.__data__.nid)) > -1); }, this.data.adjmtx[d.nid]);
			d3.selectAll(targets)
				.classed({hover:true})
				.each(function(d) {
					this.parentNode.appendChild(this);
				});
			// edges
			var targets = d3.selectAll('.radialVizEdge')[0]
				.filter(function(n) { return (n.__data__.id1==this || n.__data__.id2==this)}, d.nid);
			d3.selectAll(targets)
				.classed({hover:true})
				.each(function(d) {
					this.parentNode.appendChild(this);
				});
			element.parentNode.appendChild(element);
			this.data.hover_active = true;
			break;
		case "EDGE":
			var d = element.__data__;
			var nd = this.data.nodes;
			var txt = nd[d.id1].fn + ' ' + nd[d.id1].ln;
			txt = txt + ' / ' + nd[d.id2].fn + ' ' + nd[d.id2].ln + ' (' + d.n;
			if (d.n == 1) {
				txt = txt + ' shared publication)';
			} else {
				txt = txt + ' shared publications)';
			}
			$('graph_info').textContent = txt;

			// highlight edge under mouse
			d3.select(element).classed({focus:true});

			d3.selectAll('#node'+d.id1+', #node'+d.id2)
				.classed({hover:true})
				.each(function(d) {
					this.parentNode.appendChild(this);
				});
			element.parentNode.appendChild(element);
			this.data.hover_active = true;
			break;
	}
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._handleMouseEvents = function() {
	var ev = d3.event;
	var el = ev.target;
	var action = ev.type;

	// classes and/or tags to look for
	var classes = ["radialVizNode", "radialVizEdge"];
	var tags = ["svg"];

	// traverse up the DOM tree until we hit an element with tag/class we want
	var done = false;
	do { 
		// check current element class name
		for (var i=0; i<classes.length; i++) {
			if (d3.select(el).classed(classes[i])) {
				// found it!
				action = action + "_" + classes[i];
				done = true;
				break;
			}
		}
		if (!done) {
			// check current element tag name
			if (tags.indexOf(el.tagName) != -1) {
				// found it!
				action = action + "_" + el.tagName;
				done = true;
				break;
			}
		}
		if (!done) {
			// take one step up the DOM tree			
			el = el.parentNode;
			if (el === null) {
				// we are at the top of the DOM tree - no interesting element was found
				done = true;
			}
		}
	} while (!done);

	// el now contains an element we are interested in or null if not.

	if (el === null) {
		// unhighlight all elements and exit
		d3.select(this.svg.ref).selectAll('.hover').classed({hover:false});
		$('graph_info').textContent = '';
		this.data.hover_el = null;
		this.data.hover_evt = null;
		return;
	}

	// collapse action codes (simplifies x-browser fixes)
	switch (action) {
		case 'mouseenter_svg':
			action = "mouseover_svg";
			break;
	}


	// determine if it's a redundent event on the same node or edge
	if (this.data.hover_el === el && this.data.hover_evt == action) { return; }
	
	// save state to prevent redundant calls
	this.data.hover_el = el;
	this.data.hover_evt = action;
	

	// process according to the event type
	switch (action) {
		case "mouseover_svg":
			this._highlighter("NONE", null);
			break;
		case "mouseover_radialVizNode":
			this._highlighter("NONE", null);
			this._highlighter("NODE", el);
			break;
		case "mouseover_radialVizEdge":
			this._highlighter("NONE", null);
			this._highlighter("EDGE", el);
			break;
	}
}
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._generateNodes = function() {
	
	var func_Recenter = (function(d) {
		if (d.nid != this.data.center_id) {
			// node has been clicked that is not the center node
			this.centerOn(d.nid, true);
		}
	}).bind(this);


	var data = d3.values(this.data.nodes);
	var nodes = d3.select(this.svg.ref).selectAll(".radialVizNode")
		.data(data)
		.enter().append("svg:g")
			.attr("class", "radialVizNode")
			.attr("id", function(d) { return "node"+d.nid; })
			.attr("transform",function(d,i) { return "translate("+(14*i)+","+(12*i)+")"; })
			.on("click", (function(d) {
				// handle alt and shift click functionality
				var evt = d3.event;
				if (evt.altKey) {
					console.warn('alt-click');
					return true;
				}
				if (evt.ctrlKey) {
					console.warn('ctrl-click');
					return true;
				}
				if (evt.shiftKey) {
					var targets = d3.selectAll('.radialVizEdge')[0].filter(function(n){ return this.indexOf(n.__data__.id1) != -1 && this.indexOf(n.__data__.id2) != -1}, this.data.adjmtx[d.nid]);
					d3.selectAll(targets)
						.classed({hover:true})
						.each(function(el) { this.parentNode.appendChild(this) });
					try {
						window.getSelection().empty();
					} catch(e) {}
					return true;
				}
				func_Recenter(d);
			}).bind(this));
			
	nodes.append("circle")
		.attr("r", (function (d) {
		    return (((d.pubs - this.data.ranges.nodes.pubs['min']) / (this.data.ranges.nodes.pubs['max'] - this.data.ranges.nodes.pubs['min'])) * 20); 
        }).bind(this));

	nodes.append("rect")
		.attr("x", "0")
		.attr("y", "0")
		.attr("height", "13")
		.attr("width", "50");
	
	nodes.append("title")
		.text(function(d) { return d.label; });		
		
	nodes.append("text")
		.attr("y",".3em")
		.text(function(d) { return d.label; });

	// resize the highlight box

	nodes.selectAll("rect")
		.attr("x", function() {return this.parentNode.childNodes[3].getBBox().x-4;} )
		.attr("y", function() {return this.parentNode.childNodes[3].getBBox().y-4;} )
		.attr("height", function() {return this.parentNode.childNodes[3].getBBox().height+6;} )
		.attr("width", function() {return this.parentNode.childNodes[3].getBBox().width+10;} );		
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._generateEdges = function() {
	var data = d3.values(this.data.edges);
	var edges = d3.select(this.svg.ref).append("svg:g")
			.selectAll(".radialVizEdge")
			.data(data)
			.enter()
				.append("line")
				.attr("stroke-width", (function(d) { return Math.round(2*Math.log(d.n))+1; }).bind(this))
				.attr("class", "radialVizEdge")
				.attr("x1","0")
				.attr("y1","0")
				.attr("x2","0")
				.attr("y2","0");
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.getDataRange = function(obj_name, attrib_name, recalc) {
	var ret = {max:null, min:null};
	switch(obj_name) {
		case 'NODE':
			if (typeof this.data.ranges.edges[attrib_name] == 'undefined' || recalc === true ) {
				var keys = d3.keys(this.data.nodes);
				var values = [];
				for(var i=0; i<keys.length; i++) {
					if (typeof this.data.nodes[keys[i]][attrib_name] !== 'undefined') values.push(this.data.nodes[keys[i]][attrib_name]);
				}
				ret['min'] = d3.min(values);
				ret['max'] = d3.max(values);
				this.data.ranges.nodes[attrib_name] = ret;
			} else {
				ret = this.data.ranges.nodes[attrib_name];
			}
			break;
		case 'EDGE':
			if (typeof this.data.ranges.edges[attrib_name] == 'undefined' || recalc === true ) {
				var values = [];
				var keys = d3.keys(this.data.edges);
				for(var i=0; i<keys.length; i++) {
					if (typeof this.data.edges[keys[i]][attrib_name] !== 'undefined') values.push(this.data.edges[keys[i]][attrib_name]);
				}
				ret['min'] = d3.min(values);
				ret['max'] = d3.max(values);
				this.data.ranges.edges[attrib_name] = ret;
			} else {
				ret = this.data.ranges.edges[attrib_name];
			}
			break;
		default:
			ret = false;
	}
	return ret;
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.configCallback = function(callback_ref) {};
RadialGraph_Visualization.prototype.configSetting = function(settingName, settingValue) {};
RadialGraph_Visualization.prototype.plot = function(center_nid) {};
RadialGraph_Visualization.prototype.defineID = function(function_def) { this.nid_func = function_def.bind(this); };
