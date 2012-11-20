/*  
 
Copyright (c) 2008-2010 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.

	Original Author : Nick Benik

Code licensed under a BSD License. 
For details, see: LICENSE.txt 

*/

package edu.harvard.weberlab.NetworkBrowser {
		
	import edu.harvard.weberlab.NetworkBrowser.NetworkBrowser;
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NodePosition;
	import flash.utils.*;
	
	public class FilterManager {
		
		private var refreshCountdown:uint;
		private var needsRefresh:Boolean;
		private var refNetBrowser:NetworkBrowser;
		private var filterIncludes:Object;
		private var filterExcludes:Object;
		private var filterGradient:Object;
		private var lock_var:Boolean;
		
// -----------------------------------------------------------------------------------------------------------------------------------
		public function FilterManager(refNetworkBrowser:NetworkBrowser) {
			this.refNetBrowser = refNetworkBrowser;
			this.filterIncludes = new Object();
			this.filterExcludes = new Object();
			this.filterGradient = new Object();
			this.lock_var = false;
			this.needsRefresh = false;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function AddFilter(target:String, type:String, attribute:String, startValue:*, endValue:*) {
			var insertObj:Object;
			var filterObj:Object = new Object();
			filterObj.target = target.toUpperCase();
			if (filterObj.target != "NODE" && filterObj.target != "EDGE") { return; }
			filterObj.type = type.toUpperCase();
			switch(filterObj.type) {
				case "INCLUDE":
					break;
					insertObj = this.filterIncludes;
					break;
				case "EXCLUDE":
					insertObj = this.filterExcludes;
					break;
				case "GRADIENT":
					insertObj = this.filterGradient;
					break;
				default:
					return;
			}
			filterObj.attribute = attribute;
			filterObj.start = startValue;
			filterObj.end = endValue;
			filterObj.hash = filterObj.target+filterObj.type+filterObj.attribute;
			this.needsRefresh = true;
			if (insertObj[filterObj.hash]) {
				// remove the old filter first
				this.RemoveFilter.call(this, target, type, attribute, false);
			}
			insertObj[filterObj.hash] = filterObj;
			try {
				clearTimeout(this.refreshCountdown);
			} catch(e) {}
			this.refreshCountdown = setTimeout(ApplyFilters, this.refNetBrowser.sysConfig["filter_refresh"])
			this.needsRefresh = true;
//			this.ApplyFilters(filterObj.hash);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function RemoveFilter(target:String, type:String, attribute:String, redraw:Boolean = true) {
			var removeObj:Object;

			target = target.toUpperCase();
			if (target != "NODE" && target != "EDGE") { return; }
			type = type.toUpperCase();
			switch(type) {
				case "INCLUDE":
					removeObj = this.filterIncludes;
					break;
				case "EXCLUDE":
					removeObj = this.filterExcludes;
					break;
				default:
					return;
			}
			var hash = target+type+attribute;
			delete removeObj[hash];
			// refresh if needed
			if (redraw) {
				try {
					clearTimeout(this.refreshCountdown);
				} catch(e) {}
				this.refreshCountdown = setTimeout(ApplyFilters, this.refNetBrowser.sysConfig["filter_refresh"])
				this.needsRefresh = true;
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function ApplyFilters(objHash:String = "") {			
			if (this.lock_var) {
				try {
					clearTimeout(this.refreshCountdown);
				} catch(e) {}
				this.refreshCountdown = setTimeout(ApplyFilters, this.refNetBrowser.sysConfig["filter_refresh"])
				this.needsRefresh = true;
				return;
			}
			this.lock_var = true;
			var statusNodes:Object = new Object;
			var statusEdges:Object = new Object;
			
			// connect to our data sources
			var refNodes:Object = this.refNetBrowser.dataNodes;
			var refEdges:Object = this.refNetBrowser.dataEdges;
			
			// initialize the processing arrays
			for (var id in refNodes) {
				statusNodes[id] = false;
			}
			for each (var edge:Object in refEdges) {
				var hash:String = edge.id1+"-"+edge.id2;
				statusEdges[hash] = false;
			}
			
			// CREATE AN INSTANT SNAPSHOT OF THE FILTERS
			var localSnapshot = new Object();
			var bytes : ByteArray = new ByteArray();
			bytes.writeObject(this.filterIncludes);
			bytes.position = 0;
			localSnapshot.filterIncludes = bytes.readObject();
			var bytes : ByteArray = new ByteArray();
			bytes.writeObject(this.filterExcludes);
			bytes.position = 0;
			localSnapshot.filterExcludes = bytes.readObject();
			var bytes : ByteArray = new ByteArray();
			bytes.writeObject(this.filterGradient);
			bytes.position = 0;
			localSnapshot.filterGradient = bytes.readObject();
			
			this.needsRefresh = false;

			// PROCESS NODES
			for (var id in refNodes) {
				var trgt:Object = refNodes[id];
				// check for exclusion
				for each (var filter in localSnapshot.filterExcludes) {
					if (filter.target == "NODE") {
						if (trgt.hasOwnProperty(filter.attribute)) {
							var attribVal = trgt[filter.attribute];
							if (attribVal >= filter.start && attribVal <= filter.end) {
								statusNodes[id] = true;
							}
						}
					}
				}
				// check for inclusion
				for each (var filter in localSnapshot.filterIncludes) {
					if (filter.target == "NODE") {
						if (trgt.hasOwnProperty(filter.attribute)) {
							var attribVal = trgt[filter.attribute];
							if (attribVal >= filter.start && attribVal <= filter.end) {
								statusNodes[id] = false;
							}
						}
					}
				}
			}
						
			// PROCESS EDGES
			for (var idx in refEdges) {
				var trgt:Object = refEdges[idx];
				var hash:String = trgt.id1+"-"+trgt.id2;
				// check for exclusion
				for each (var filter in localSnapshot.filterExcludes) {
					if (filter.target == "EDGE") {
						if (trgt.hasOwnProperty(filter.attribute)) {
							var attribVal = trgt[filter.attribute];
							if (attribVal >= filter.start && attribVal <= filter.end) {
								statusEdges[hash] = true;
								break;
							}
						}
					}
				}
				// check for inclusion
				for each (var filter in localSnapshot.filterIncludes) {
					if (filter.target == "EDGE") {
						if (trgt.hasOwnProperty(filter.attribute)) {
							var attribVal = trgt[filter.attribute];
							if (attribVal >= filter.start && attribVal <= filter.end) {
								statusEdges[hash] = false;
								break;
							}
						}
					}
				}
			}
					

			// apply Alpha filtering to the visual elements
			refNodes = this.refNetBrowser.allNodes;
			refEdges = this.refNetBrowser.allEdges;
			// process Nodes
			for (var id in refNodes) {
				var node:NetworkNode = refNodes[id];
				node.setFiltered(statusNodes[id]);
			}
			// process Edges
			for (var idx in refEdges) {
				var netedge:NetworkEdge = refEdges[idx];
				var hash:String = netedge.node1.id+"-"+netedge.node2.id;
				if (!statusEdges.hasOwnProperty(hash)) {
					var hash:String = netedge.node2.id+"-"+netedge.node1.id;
				}
				if (statusEdges.hasOwnProperty(hash)) {
					netedge.setFiltered(statusEdges[hash]);
				}
			}
			
			
			this.lock_var = false;
		}
// TEMP!! -----------------------------------------------------------------------------------------------------------------------------------
		public function calcRatio(dataValue, dataRangeMin, dataRangeMax, outputMin,  outputMax):Number {
			var r = (((dataValue - dataRangeMin) / (dataRangeMax - dataRangeMin)) * (outputMax - outputMin)) + outputMin;
			return r;
		}
		
// -----------------------------------------------------------------------------------------------------------------------------------
	}
}