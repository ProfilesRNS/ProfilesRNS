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
	
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NodePosition;
	
	public class RadialLayoutPositioner {

		public var depths:Object;
		public var parents:Object;
		public var subtreeSizes:Object;
		public var percentAngles:Object;
		public var angles:Object;
		public var thetas:Object;
		public var allNodes:Object;
		public var allEdges:Array;

		public function RadialLayoutPositioner(nodes, edges):void {
			// save references to global node/edge arrays
			allNodes = nodes;
			allEdges = edges;

			this.depths = new Object();
			this.parents = new Object();
			this.subtreeSizes = new Object();
			this.percentAngles = new Object();
			this.angles = new Object();
			this.thetas = new Object();

			// initialize data
			for each (var node in nodes) {
				this.depths[node.id] = 999;
				this.parents[node.id] = undefined;
				this.subtreeSizes[node.id] = 0;
				this.percentAngles[node.id] = 0;
				this.angles[node.id] = 0;
				this.thetas[node.id] = 0;
			}
		}
		
		public function plot(centerNodeID:String):Object {
			this.findChildren(centerNodeID);
			this.sizeOfSubtree(centerNodeID);
			for (var i:String in this.subtreeSizes) {
				this.subtreeSizes[i] += 1;
			}
			this.calcPercentAngle(centerNodeID);
			this.angles[centerNodeID] = 360;
			this.calcAngle(centerNodeID);
			this.thetas[centerNodeID] = 180;
			this.calcTheta(centerNodeID);
			
			// return the nodes' coordinates
			var coords:Object = new Object();
			for (var id in this.depths) {
				var temp = new NodePosition();
				temp.theta = this.thetas[id];
				temp.hop = this.depths[id];
				coords[id] = temp;
			}
			return coords;
		}		
		
		private function findChildren(centerNodeID:String):void {
			// build the hierarchical order via shortest distance to center node			
			var hopLevel:Number = 0;
			var done:Boolean = false;
			
			this.depths[centerNodeID] = 0;
			do {
				done = true;
				for each (var netnode in this.allNodes) {
					var id:String = netnode.id;
					if (this.parents[id] == undefined && this.depths[id] == 999) {
						// we found an unassigned node, try to see if an edge can link it to the current hop distance we are working at
						for each (var netedge in allEdges) {
							// is this node is "relevant to my interests..."
							if (netedge.node1 == netnode) {
								if (this.depths[netedge.node2.id] == hopLevel) {
									// attach current node to distance node
									this.parents[id] = netedge.node2.id;
									this.depths[id] = hopLevel + 1;
									done = false;
								}
							} else if (netedge.node2 == netnode) {
								if (this.depths[netedge.node1.id] == hopLevel) {
									// attach current node to distance node
									this.parents[id] = netedge.node1.id;
									this.depths[id] = hopLevel + 1;
									done = false;
								}
							}
						}
					}
				}
				hopLevel++;
			} while (!done);
			
			// save the parent node data back to the nodes
			for (var id in this.parents) {
				this.allNodes[id].parent_node = this.allNodes[this.parents[id]];
			}
			
			// BUG FIX: Kill any nodes that still have a depth of 999 at this point since they are not related to the center node
			for (var id in this.depths) {
				if (this.depths[id] == 999) {
					try {
						delete this.angles[id];
						delete this.depths[id];
						delete this.parents[id];
						delete this.percentAngles[id];
						delete this.subtreeSizes[id];
						delete this.thetas[id];
						this.allNodes[id].destroy();
						delete this.allNodes[id];
					} catch(e) {}
				}
			}
			
		}
		
		private function sizeOfSubtree(inID:String):int {
			// this function returns the number of branches that occurn in a particular subtree
			var children = this.getChildren(inID);
			if (children.length > 1) {
				var z = children.length - 1;
			} else {
				var z = 0;
			}
			for each (var child in children) {
				z += this.sizeOfSubtree(child);
			}
			this.subtreeSizes[inID] = z;
			return z;
		}
		
		private function calcPercentAngle(inID:String):void {
			var k = 0;
			var children = this.getChildren(inID);
			for each (var id in children) {
				k += this.subtreeSizes[id];
			}
			for each (var id in children) {
				this.percentAngles[id] = this.subtreeSizes[id]/k;
				this.calcPercentAngle(id);
			}
		}
		
		private function calcAngle(inID:String):void {
			var children = this.getChildren(inID);
			for each (var id in children) {
				this.angles[id] = this.angles[inID] * this.percentAngles[id];
				this.calcAngle(id);
			}
		}
		
		private function calcTheta(inID:String):void {
			var z = this.thetas[inID] - this.angles[inID] / 2;
			var children = this.getChildren(inID);
			for each (var id in children) {
				this.thetas[id] = z + this.angles[id]/2;
				this.calcTheta(id);
				z += this.angles[id];
			}
		}
		
		private function getChildren(inID:String):Array {
			var ret = new Array();
			for (var id in this.parents) {
				if (this.parents[id] == inID) {
					ret.push(id);
				}
			}
			return ret;
		}
	}
}