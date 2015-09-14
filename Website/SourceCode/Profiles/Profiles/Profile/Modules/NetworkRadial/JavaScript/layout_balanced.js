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

function RadialGraph_Layout(nodes,edges, adjacency) {
	// source data 
	this.n = nodes;
	this.e = edges;
	this.ax = adjacency;
	// algo variables
	this.depths = {};
	this.parents = {};
	this.subtreeSizes = {};
	this.percentAngles = {};
	this.angles = {};
	this.thetas = {};
		
	// initalize to defaults
	var k = d3.keys(this.n);
	var l = k.length;
	for (var i=0; i<l; i++) {
		var key = this.n[k[i]].nid;
		this.depths[key] = 999;
		this.parents[key] = undefined;
		this.subtreeSizes[key] = 0;
		this.percentAngles[key] = 0;
		this.angles[key] = 0;
		this.thetas[key] = 0;
	}
	
	// rebuild the adjacency matrix if needed
	if (typeof adjacency == "undefined") {
		this.ax = {};
		var l = this.e.length;
		for (var i=0; i<l; i++) {
			var temp = this.e[i];
			// we populate matrix using sub-objects (O^n) and later convert to sub-arrays
			if (typeof this.ax[temp.id1] === 'undefined') { this.ax[temp.id1] = {}; }
			this.ax[temp.id1][temp.id2] = true;
			if (typeof this.ax[temp.id2] === 'undefined') { this.ax[temp.id2] = {}; }
			this.ax[temp.id2][temp.id1] = true;			
		}
		// remove convert adjacency matrix from sub-objects to sub-arrays
		var keylist = d3.keys(this.ax);
		var l = keylist.length;
		for (var i=0; i<l; i++) {
			this.ax[keylist[i]] = d3.keys(this.ax[keylist[i]]);
		}
	}
}

RadialGraph_Layout.prototype.getMaxHops = function() {
	// return the number of hops
	return d3.values(this.depths).max();
};

RadialGraph_Layout.prototype.plot = function(center_nid) {
		center_nid = String(center_nid);
		this.buildTree([center_nid],0);
		// kill any nodes that have no parents since they are not connected to the tree 
		for(var i in this.parents) {
			if (typeof this.parents[i] == "undefined") {
				delete this.depths[i];
				delete this.parents[i];
				delete this.subtreeSizes[i];
				delete this.percentAngles[i];
				delete this.angles[i];
				delete this.thetas[i];
			}
		}
		// update the subtree sizes
		this.sizeSubtrees();
		
		this.calcPercentAngle(center_nid);
		this.angles[center_nid] = 360;
		this.calcAngle(center_nid);
		this.thetas[center_nid] = 180;
		this.calcTheta(center_nid);
};

RadialGraph_Layout.prototype.sizeSubtrees = function() {
	// DON'T assume the spanning tree has already been setup, only that parents array is correct
	var activeset = d3.entries(this.parents);

	// initialize the child count numbers for suming
	activeset.each(function(d) {d.c=1;});
	this.subtreeSizes = {};

	// functions for adding/updating parent data to the records (using scope-binding hack)
	var parentfind_func = function(d) {d.value = this.parents[d.key]};
	var childcntupdate_func = function(d) { this.subtreeSizes[d.key] = d.c + (typeof this.subtreeSizes[d.key] !== "undefined" ? this.subtreeSizes[d.key] : 0) };

	// reductive suming while updating subtree counts
	while (activeset.length > 1) {
		// update the subtree sizes
		activeset.each(childcntupdate_func.bind(this));
		// nest down by one level by parent node [with summing]
		activeset = d3.nest()
			.key(function(d) {return d.value})
			.rollup(function(children) {
				return d3.sum(children, function(child){return child.c})
			})
			.entries(activeset);
		// swizzle some attribute names
		activeset.each(function(d) {
			d.c = d.values;
			delete d.values;
		});
		// filter out invalid nodes (no assigned parents / fake ROOT node)
		activeset = activeset.filter(function(d) { return (d.key!="ROOT" && d.key!="undefined")});

		// re-add parent node value to the nested groups
		activeset = activeset.each(parentfind_func.bind(this));

	}

	// update the final (root) node
	activeset.each(childcntupdate_func.bind(this));
};


RadialGraph_Layout.prototype.buildTree = function(propagation_front, hop) {
	// "propagation_front" SHOULD BE AN ARRAY OF STRINGS!!!
	// build the hierarchical order via shortest distance to center node
	if (typeof hop == "undefined") {
		var hopLevel = 0;
	} else {
		var hopLevel = hop;
	}
	
	if (hopLevel==0) {
		var tid = propagation_front[0];
		this.depths[tid] = 0;
		this.parents[tid] = "ROOT";
		hopLevel = 1;
		this.center_id = tid;
	}
	
	// build a list of nodes adjacent to the propagation front
	var targets = [];
	var l1 = propagation_front.length;
	for (var i1=0; i1<l1; i1++) {
		// get the front node's list
		targets = targets.concat(this.ax[propagation_front[i1]]);
	}
	// deduplicate the list
	targets = targets.uniq();
	var prop_extend = targets.clone();
		
	// main connection/calculation loop
	while (targets.length) {
		// remove any nodes that are already placed
		var temp = [];
		while (targets.length) {
			var t = targets.pop();
			// is the node already joined to the growing tree?
			if (typeof this.parents[t] == "undefined") {
				// node not is already handled
				temp.push(t);
			}
		}
		targets = temp;
		delete temp;
		
		// no processing if no targets found
		if (targets.length > 0) {
		
			// build a metric for each node targeted for attachment to the tree based upon how 
			// many location options it has to attach to the propagation front.
			var connectivity = [];
			for (var i1=0; i1<targets.length; i1++) {
				if (typeof this.ax[targets[i1]] === "undefined")  {
					connectivity[i1] = 0;
				} else {
					// calculate adjacency members INTERSECT propagation_front members
					var intersect = this.ax[targets[i1]].filter(function(n) { return (this.indexOf(n) != -1) }, propagation_front);
					connectivity[i1] = intersect.length;
				}
			}

			// connect one adjacent node with the lowest placement options
			// while we are at it, connect all adjacent nodes with ONLY ONE placement option	
			var temp = [];
			var was_placed = false;
			var hid, hc = undefined;
			while (targets.length > 0) {
				var tid = targets.pop();
				var tc = connectivity.pop();
				if (tc == 1) {
					// only has one node on the propagation front to connect to so we have to at this point
					this.parents[tid] = this.ax[tid].filter(function(n) { return (this.indexOf(n) != -1) }, propagation_front);
					this.parents[tid] = this.parents[tid][0];
					this.depths[tid] = hopLevel;
					this.subtreeSizes[this.parents[tid]]++;
				} else {
					// see if current target is better canidate that what we have already found
					if (typeof hc === "undefined") {
						// nothing found previously
						hc = tc;
						hid = tid;
					} else if (hc > tc) {
						// current one is better option
						temp.push(hid);
						hc = tc;
						hid = tid;
					} else {
						// one already found is same or better option
						temp.push(tid);
					}
				}
			}
			targets = temp;
			delete temp;
		
			// idiocy check
			if (typeof hid !== "undefined" && typeof this.parents[hid] === "undefined") {	
				// "hid" contains the id the next node we are going to attach.  Of it's possible 
				// parent options in the propagation front, connect it to the parent with the LEAST number of children
				connectivity = this.ax[hid].filter(function(n) { return (this.indexOf(n) != -1) }, propagation_front);
				tc = 99999;
				var tid = undefined;
				var l = connectivity.length;
				for (var i=0; i<l; i++) {
					if (this.subtreeSizes[connectivity[i]] < tc) {
						tc = this.subtreeSizes[connectivity[i]];
						tid = i;
					}
				}
				// at this point tid is the index to the least connected parent of the propagation front
				if (typeof tid !== "undefined") {
					this.parents[hid] = connectivity[tid];
					this.depths[hid] = hopLevel;
					this.subtreeSizes[connectivity[tid]]++;
				}
			}
		} else {
			// no more targets
			return true;
// TODO: UPDATE subtreeSizes!
		}
	}
	// exit recursion or propagate the activation front one more hop
	if (prop_extend.length == 0) {
		return this.center_id;
	} else {
		// recurse into our next hop
		hopLevel++;
		if (hopLevel > 20) return this.center_id;
		this.buildTree(prop_extend, hopLevel);
	}
	return this.center_id;
};

RadialGraph_Layout.prototype.calcPercentAngle = function(center_nid) {
	var k = this.subtreeSizes[center_nid];
	if (k > 1) k--;
	var children = d3.values(this.ax[center_nid]).filter(function(n) { return (this[n] == center_nid); }, this.parents);
	
	for (var i=0; i<children.length; i++) {
		this.percentAngles[children[i]] = this.subtreeSizes[children[i]]/k;
		this.calcPercentAngle(children[i]);
	}
};
RadialGraph_Layout.prototype.calcAngle = function(center_nid) {
	var children = d3.values(this.ax[center_nid]).filter(function(n) { return (this[n] == center_nid); }, this.parents);
	
	for (var i=0; i<children.length; i++) {
		this.angles[children[i]] = this.angles[center_nid] * this.percentAngles[children[i]];
		this.calcAngle(children[i]);
	}
};
RadialGraph_Layout.prototype.calcTheta = function(center_nid) {
	var z = this.thetas[center_nid];
	z = z - this.angles[center_nid]/2;
	var children = d3.values(this.ax[center_nid]).filter(function(n) { return (this[n] == center_nid); }, this.parents);
	for (var i=0; i<children.length; i++) {
		this.thetas[children[i]] = z + this.angles[children[i]]/2;
		this.calcTheta(children[i]);
		z = z + this.angles[children[i]];
	}
};
RadialGraph_Layout.prototype.getLocationsPolar = function(hop_dist) {
	// return array of objects with polar coordinates
	hop_dist = parseInt(hop_dist);
	if (isNaN(hop_dist)) { hop_dist = 10; } // hand holding
	var ret = [];
	var ids = d3.keys(this.thetas);
	var l = ids.length;
	for (var i=0; i<l;i++) {
		var obj = {
			id: ids[i],
			r: hop_dist * this.depths[ids[i]],
			t: this.thetas[ids[i]]
		};
		ret.push(obj);
	}
	return ret;
};