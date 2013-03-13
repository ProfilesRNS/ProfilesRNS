/*  
 
Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.


Code licensed under a BSD License. 
For details, see: LICENSE.txt 

----==================================================----
    Radial Network Viewer - Javascript Control Class
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

network_browser = {



	sliders: { ranges: {}, callbacks: {} },
	_swf_moviename: 'network_browserFLASH',
	_swf_ref: false,
	center_id: false,
	over_node: false,
	over_edge: false,
	_cfg: {
		profile_network_path: "/345/cluster"  // (predicate) 345 = coauthor of (i.e. /display/<<nodeid>>/network/coauthor/<<tab>>
	},
	Init: function(baseURL) {
		if (baseURL) {
			this._cfg.baseURL = baseURL;
		} else {
			if (!this._swf_ref) {
				var movName = this._swf_moviename;
				var isIE = navigator.appName.indexOf("Microsoft") != -1;
				//this._swf_ref = (isIE) ? window[movName] : document[movName];
				this._swf_ref = document[movName];
				if (this._swf_ref == undefined)
					this._swf_ref = window[movName];
			}
			this._swf_ref.registerCallback("network_browser._flashEventHandler");
			if (this._cfg.baseURL && this.center_id) {
				// automatically load the network
				this.loadNetwork.call(this, this.center_id, 2);
			}
		}
	},
	loadNetwork: function(centerID) {
		// has the flash fired it's Init signal?
		if (!this._swf_ref) {
			// store the info to be used later
			this.center_id = centerID;
		} else {
			if (!this._cfg.baseURL) {
				alert("The BaseURL interface has not been set!");
				return false;
			} else {
				this._swf_ref.loadNetwork(this._cfg.baseURL, centerID, 2);
			}
		}
	},
	//centerOn: function(nodeID) {
	//	this._swf_ref.centerOn(nodeID);
	//},	
	clearNetwork: function() {
		this._swf_ref.clearNetwork();
	},
	pauseGraph: function() {
		this._swf_ref.pauseGraph();
	},
	playGraph: function() {
		this._swf_ref.playGraph();
	},
	getDataRange: function(objType, objAttrib) {
		this._swf_ref.getDataAttributeRange(objType, objAttrib);
	},
	dumpEdges: function() {
		this._swf_ref.dumpEdges();
	},
	dumpNodes: function() {
		this._swf_ref.dumpNodes();
	},
	_flashEventHandler: function(eventName, dataObject) {
		switch (eventName) {

			case "NODE_CTRL_CLICK":
				//parent.GoNetwork(dataObject.id, dataObject.display_name_long);
				document.location = dataObject.uri + network_browser._cfg.profile_network_path;
				break;
			case "NODE_ALT_CLICK":
				//parent.GoPerson(dataObject.id);
				document.location = dataObject.uri
				break;
			case "NODE_CLICK":
			case "NODE_SHIFT_CLICK":
			case "NODE_SHIFT_ALT_CLICK":
			case "NODE_SHIFT_CTRL_CLICK":
			case "NODE_ALT_CTRL_CLICK":
			case "NODE_SHIFT_ALT_CTRL_CLICK":
				//document.getElementById("person_name").innerHTML = dataObject.id+" ["+eventName+"]";
				break;
			case "NODE_IN":
				if (dataObject.pubs == 1) {
					document.getElementById("person_name").innerHTML = dataObject.display_name_long + ' (' + dataObject.pubs + ' publication)';
				} else {
					document.getElementById("person_name").innerHTML = dataObject.display_name_long + ' (' + dataObject.pubs + ' publications)';
				}
				//document.getElementById("person_name").innerHTML = dataObject.id+" [NODE_IN]";



				$('nodeData').style.background = "#9BD1FA";
				var data = "";
				for (var attrib in dataObject) {
					data = data + attrib + " = " + dataObject[attrib] + "<br />";
				}
				$('nodeData').innerHTML = data;
				break;
			case "NODE_OUT":
				document.getElementById("person_name").innerHTML = '';
				//document.getElementById("person_name").innerHTML = dataObject.id+" [NODE_OUT]";
				$('nodeData').style.background = "#999999";
				break;
			case "EDGE_CLICK":
				//document.getElementById("person_name").innerHTML = dataObject.id1+" + "+dataObject.id2+" [EDGE_CLICK]";
				break;
			case "EDGE_SHIFT_CLICK":
				//document.getElementById("person_name").innerHTML = dataObject.id2+" + "+dataObject.id2+" [EDGE_SHIFT_CLICK]";
				break;
			case "EDGE_IN":
				if (dataObject.n == 1) {
					document.getElementById("person_name").innerHTML = dataObject.Person1.display_name_long + ' / ' + dataObject.Person2.display_name_long + ' (' + dataObject.n + ' shared publication)';
				} else {
					document.getElementById("person_name").innerHTML = dataObject.Person1.display_name_long + ' / ' + dataObject.Person2.display_name_long + ' (' + dataObject.n + ' shared publications)';
				}

				//document.getElementById("person_name").innerHTML = dataObject.id1+" + "+dataObject.id2+" [EDGE_IN]";
				$('edgeData').style.background = "#9BD1FA";
				var data = "";
				for (var attrib in dataObject) {
					data = data + attrib + " = " + dataObject[attrib] + "<br />";
				}
				$('edgeData').innerHTML = data;
				break;
			case "EDGE_OUT":
				//document.getElementById("person_name").innerHTML = '';
				//document.getElementById("person_name").innerHTML = dataObject.id1+" + "+dataObject.id2+" [EDGE_OUT]";
				$('edgeData').style.background = "#999999";
				break;
			case "DATA_RANGE":
				if (dataObject.invalidAttribute) {
					alert("Invalid data attribute: [" + dataObject.attribute + "]");
					//					$('minVal').innerHTML = "null";
					//					$('maxVal').innerHTML = "null";
				} else {
					//					$('minVal').innerHTML = String(dataObject.min);
					//					$('maxVal').innerHTML = String(dataObject.max);
					network_browser.sliders.ranges[dataObject.attribute] = dataObject;
					var t = network_browser.sliders.ranges;
					if (t.pubs && t.y2 && t.n) {
						// initialize the scriptaculous sliders
						this.sliders.copubs = new Control.Slider('copubs_handle', 'copubs', {
							range: $R(t.pubs.min, t.pubs.max),
							maximum: 180,
							onChange: network_browser.sliders.callbacks.pubs,
							onSlide: network_browser.sliders.callbacks.pubs
						});
						this.sliders.pub_cnt = new Control.Slider('pub_cnt_handle', 'pub_cnt', {
							range: $R(t.n.min, t.n.max + 1),
							maximum: 180,
							onChange: network_browser.sliders.callbacks.n,
							onSlide: network_browser.sliders.callbacks.n
						});
						this.sliders.recent_copubs = new Control.Slider('pub_date_handle', 'pub_date', {
							range: $R(t.y2.min, t.y2.max),
							maximum: 180,
							onChange: network_browser.sliders.callbacks.y2,
							onSlide: network_browser.sliders.callbacks.y2
						});
					}
				}
				break;
			case "DUMP_NODES":
				//				console.dir(dataObject);
				break;
			case "DUMP_EDGES":
				//				console.dir(dataObject);
				break;
			case "NETWORK_LOADED":
				// network is now loaded, get the proper data ranges to initialize the sliders
				//this.sliders.ranges = {};
				//this.getDataRange.call(this, "NODE", "pubs");
				//this.getDataRange.call(this, "EDGE", "n");
				//this.getDataRange.call(this, "EDGE", "y2");
				break;
			default:
				//alert(eventName + " is unhandled.");
				//debugger;
				break;
		}
	}
};


// ----------------------------------------------------------------------------------------------
//   Filter Sliders
// ----------------------------------------------------------------------------------------------

network_browser.sliders.callbacks = {
	pubs: function(val, sldr) {
		var v = Math.ceil(val) - 1;
		if (network_browser.sliders.ranges.pubs.min >= v) {
			network_browser._swf_ref.removeFilter("NODE", "EXCLUDE", "pubs");
			$('lbl_pubs').innerHTML = "any number";
		} else {
			$('lbl_pubs').innerHTML = parseInt(v) + " or more";
			network_browser._swf_ref.addFilter("NODE", "EXCLUDE", "pubs", network_browser.sliders.ranges.pubs.min, v);
		}
	},
	n: function(val, sldr) {
		var v = Math.ceil(val) - 1;
		if (network_browser.sliders.ranges.n.min >= v) {
			network_browser._swf_ref.removeFilter("EDGE", "EXCLUDE", "n");
			$('lbl_copubs').innerHTML = "any collaboration";
		} else {
			network_browser._swf_ref.addFilter("EDGE", "EXCLUDE", "n", network_browser.sliders.ranges.n.min, v);
			$('lbl_copubs').innerHTML = v + " or more";
		}
	},
	y2: function(val, sldr) {
		var v = Math.ceil(val) - 1;
		if (network_browser.sliders.ranges.y2.min >= v) {
			network_browser._swf_ref.removeFilter("EDGE", "EXCLUDE", "y2");
			$('lbl_recent').innerHTML = "any year";
		} else {
			network_browser._swf_ref.addFilter("EDGE", "EXCLUDE", "y2", network_browser.sliders.ranges.y2.min, v);
			$('lbl_recent').innerHTML = "during or after " + v;
		}
	}
};
