/*
	HTML5/d3-Based Network Visualizer  
	(C)opyright 2015, Harvard Medical School
	All Rights Reserved.

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
			circles: {
				svgGroupEl: undefined,
				anipos: []
			},
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
			mouseover: mouseMaster,
			click: mouseMaster,
			dblclick: mouseMaster
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
RadialGraph_Visualization.prototype.loadedNetwork = function(error, json) {
	this.clearNetwork();

	// processes nodes
	this.data.nodes ={};
	var l = json.NetworkPeople.length;
	for (var i=0; i<l; i++) {
		var node = json.NetworkPeople[i];
		node.nid = this.nid_func(node);
		node.label = node.ln + " " + node.fn.substr(0,1);
		node.xy = {
			x: 0,
			y: 0
		};
//		node.x = 0;
//		node.y = 0;
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
		temp.xy = {
			x1: 0,
			y1: 0,
			x2: 0,
			y2: 0
		};
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
        
    // generate the visual elements
    this._generateEdges();
	this._generateCircles(false);
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
    watchdog.cancel();
};
// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype.centerOn = function (nodeID, animate) {
    // calculate the new layout
    var layout_eng = new RadialGraph_Layout(this.data.nodes, this.data.edges, this.data.adjmtx);
    layout_eng.plot(nodeID);

    // recalculate the hop radius based on the max hop distance
	this.data.circles.maxHops = layout_eng.getMaxHops();
    this.config.radius = ((this.svg.width / 2) * 0.75) / this.data.circles.maxHops;

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

	// extract the hop rings' information
	var ringO = {};
	var ringN = {};
	var keylist = d3.keys(this.data.nodes);
	// loop through list and extract the ring distances
	var l = keylist.length;
	for (var i=0; i<l; i++) {
		ringN[this.data.nodes[keylist[i]].polar.new[1]] = true;
		ringO[this.data.nodes[keylist[i]].polar.old[1]] = true;	
	}
	// delete the center node coordinate
	delete ringN[0];
	delete ringO[0];
	// twizzling out sorted values
	ringN = d3.keys(ringN);
	ringO = d3.keys(ringO);
	var func_sortInt = function(a,b) { return (parseInt(a) > parseInt(b)); };
	ringN.sort(func_sortInt);
	ringO.sort(func_sortInt);
	if (ringN.length != ringO.length) {
		if (ringN.length < ringO.length) {
			var i = ringN;
			var l = ringO;
			ringN.unshift("0");
		} else {
			var i = ringO;
			var l = ringN;
		}
		while (i.length < l.length) { i.unshift("0"); }
	}
	// output is circles.anipos[circleNum][0|1] where 0 = new positions & 1 = old positions
	this.data.circles.anipos = d3.zip(ringN, ringO);
	this._generateCircles(animate);
	
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
        d.xy.x = offset_x + x;
        d.xy.y = offset_y + y;
    }).bind(this);
    // (...see above)
    var func_UpdateEdges = (function (d) {
        var node = this.data.nodes[d.id1];
        d.xy.x1 = node.xy.x;
        d.xy.y1 = node.xy.y;
        var node = this.data.nodes[d.id2];
        d.xy.x2 = node.xy.x;
        d.xy.y2 = node.xy.y;
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
                d.xy.x = cx + Math.floor(r * Math.cos(a));
                d.xy.y = cy + Math.floor(-r * Math.sin(a));
                if (i == node_cnt - 1) {
                    // once all the nodes have been updated for this frame
                    // we need to also update all the edges and the circles
                    d3.selectAll(".radialVizEdge")
						.each(func_UpdateEdges)
						.attr("x1", function (d) { return d.xy.x1; })
						.attr("y1", function (d) { return d.xy.y1; })
						.attr("x2", function (d) { return d.xy.x2; })
						.attr("y2", function (d) { return d.xy.y2; });
                }
                return "translate(" + d.xy.x + "," + d.xy.y + ")";
            };
        };

		// animate the circles
        d3.select(this.svg.ref).selectAll(".radialVizNode")
			.transition()
				.duration(1500)
				.attrTween("transform", func_animateNodes.bind(this));
		
        d3.select(this.svg.ref).selectAll(".radialVizCircles circle")
			.transition()
				.duration(1500)
				.attrTween("r", function(d,i,j) {
					return d3.interpolateRound(parseInt(d[1]), parseInt(d[0]));
				});
				
        d3.select(this.svg.ref).selectAll(".radialVizCircles circle").style({visibility: "visible"});

    } else {
		
		
        // place the nodes [NO ANIMATION]
        var nodes = d3.select(this.svg.ref).selectAll(".radialVizNode")
			.each(func_UpdateXY)
			.attr("transform", function (d, i) { return "translate(" + d.xy.x + "," + d.xy.y + ")"; });

        // move the edges
        var edges = d3.select(this.svg.ref).selectAll(".radialVizEdge")
			.each(func_UpdateEdges)
			.attr("x1", function (d) { return d.xy.x1; })
			.attr("y1", function (d) { return d.xy.y1; })
			.attr("x2", function (d) { return d.xy.x2; })
			.attr("y2", function (d) { return d.xy.y2; });
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
	var el_type = 'BACKGROUND';
	var signal = [];

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
				if (classes[i] == 'radialVizNode') { el_type = 'NODE'; }
				if (classes[i] == 'radialVizEdge') { el_type = 'EDGE'; }
				done = true;
				break;
			}
		}
		// check current element tag name		
		if (!done) {
			if (tags.indexOf(el.tagName) != -1) {				
				// found it!
				el_type = 'BACKGROUND';
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
		// fire an OUT command for the last element that had focus
		if (this.data.hover_el_type === null) {
			// fire mouse out event for the last element type we were over
			action = "OUT";
		}
		// unhighlight all elements and exit
		d3.select(this.svg.ref).selectAll('.hover').classed({hover:false});
		$('graph_info').textContent = '';
		this.data.hover_el = null;
		this.data.hover_evt = null;
		return;
	}

	// extract the modifier keys SHIFT_ALT_CTRL
	switch (action) {
		case "mouseover":
		case "mouseenter":
			action = "IN";
			signal.push(action);
			break;
		case "mouseout":
			action = "OUT";
			signal.push(action);
			break;
		case "click":
			action = "CLICK";
			if (ev.shiftKey === true) { signal.push("SHIFT"); }
			if (ev.altKey === true) { signal.push("ALT"); }
			if (ev.ctrlKey === true) { signal.push("CTRL"); }
			signal.push(action);
			// unhighlight browser selection
			try {
				window.getSelection().empty();
			} catch(e) {}
			break;
//		default:
//			alert(action);
	}

	// create the final event signal string
	signal.unshift(el_type);
	action = signal.join("_");

	// determine if it's a redundent event on the same node or edge
	if (this.data.hover_el === el && this.data.hover_evt == action) { return; }
	
	// save state to prevent redundant calls
	this.data.hover_el = el;
	this.data.hover_evt = action;
	
	var func_Recenter = (function(d) {
		if (d.nid != this.data.center_id) {
			// node has been clicked that is not the center node
			this.centerOn(d.nid, true);
		}
	}).bind(this);
	var func_noSelect = function() {
		try { window.getSelection().empty(); } catch(e) {}
	};
	
	
	// process according to the event type
	var dataObject = el.__data__;
	switch (action) {
		case "BACKGROUND_IN":
			this._highlighter("NONE", null);
			break;
		case "NODE_IN":
			this._highlighter("NONE", null);
			this._highlighter("NODE", el);
			break;
		case "EDGE_IN":
			this._highlighter("NONE", null);
			this._highlighter("EDGE", el);
			break;
		case "NODE_CLICK":
			func_noSelect();
			func_Recenter(dataObject);
			break;
		case "NODE_SHIFT_CLICK":
			func_noSelect();
			var targets = d3.selectAll('.radialVizEdge')[0].filter(function(n){ return this.indexOf(String(n.__data__.id1)) != -1 && this.indexOf(String(n.__data__.id2)) != -1}, this.data.adjmtx[dataObject.nid]);
			d3.selectAll(targets)
				.classed({hover:true})
				.each(function(el) { this.parentNode.appendChild(this) });
			break;
		case "NODE_CTRL_CLICK":
			func_noSelect();
			func_Recenter(dataObject);
			window.open(dataObject.uri + "/network/coauthors/radial", "_self");
			break;
		case "NODE_ALT_CLICK":
			func_noSelect();
			func_Recenter(dataObject);
			window.open(dataObject.uri, "_self");
			break;
	}
}

// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._generateCircles = function(animate) {
	var t = d3.select(this.svg.ref).select(".radialVizCircles");
	if (t[0][0] === null) {
		var circleGrp = d3.select(this.svg.ref).append("svg:g")
			.classed("radialVizCircles", true)
			.style({visibility: "hidden"});
		return true;
	} else {
		var circleGrp = d3.select(t[0][0]);
	}
		
	var circles = circleGrp.selectAll('circle').data(this.data.circles.anipos);
	circles.enter()
		.append("circle")
		.attr("transform",(function(d, i) { return "translate("+this.svg.center_x+","+this.svg.center_y+")"; }).bind(this));
	
	if (animate === true) {
		circles.attr('r', function(d) {return String(d[1]);});
	} else {
		circles.attr('r', function(d) {return String(d[0]);})
			.style({visibility: "visible"});
	}
	circles.exit().remove();
}

// ----------------------------------------------------------------------------
RadialGraph_Visualization.prototype._generateNodes = function() {
	
	var data = d3.values(this.data.nodes);
	var nodes = d3.select(this.svg.ref).selectAll(".radialVizNode")
		.data(data)
		.enter().append("svg:g")
			.attr("class", "radialVizNode")
			.attr("id", function(d) { return "node"+d.nid; })
			.attr("transform",function(d,i) { return "translate("+(14*i)+","+(12*i)+")"; });
			
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
RadialGraph_Visualization.prototype.configCallback = function(callback_ref) {
		console.debug(typeof callback_ref);
		this.callback_func = callback_ref;
};
RadialGraph_Visualization.prototype.configSetting = function(settingName, settingValue) {};
RadialGraph_Visualization.prototype.plot = function(center_nid) {};
RadialGraph_Visualization.prototype.defineID = function(function_def) { this.nid_func = function_def.bind(this); };
