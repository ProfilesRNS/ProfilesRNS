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
    import fl.managers.StyleManager;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import fl.controls.Button;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.xml.*;
	import fl.motion.Color;
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NetworkEdge;	
	import edu.harvard.weberlab.NetworkBrowser.RadialLayoutPositioner;
	import edu.harvard.weberlab.NetworkBrowser.NodePosition;
	import edu.harvard.weberlab.NetworkBrowser.RadialAnimator;
	import edu.harvard.weberlab.NetworkBrowser.HiSelectMgr;
	import edu.harvard.weberlab.NetworkBrowser.AutoLoader;
	import edu.harvard.weberlab.NetworkBrowser.FilterManager;

	public class NetworkBrowser {
		
		public var allNodes:Object;
		public var allEdges:Array;
		public var dataNodes:Object;
		public var dataEdges:Object;
		public var rangesNode:Object;
		public var rangesEdge:Object;
		
		public var cntNodes:int;
		public var cntEdges:int;
		public var animatorObj:RadialAnimator;
		public var HighlightSelectMgr:HiSelectMgr;
		public var myAutoLoader:AutoLoader;
		public var myFilterManager:FilterManager;
		protected var stageRef:Stage;
		protected var coord_center_x:Number;
		protected var coord_center_y:Number;
		protected var mc_OffsetPosition:MovieClip;
		public var jsCallback:String;
		public var sysConfig:Object;
		public var currentPositions:Object;
		public var centerNode:NetworkNode;
		public var ownerNode_id:String;
		private var CircleLayer:Sprite;
		public var focusedNode:NetworkNode;
		public var b_highlightExpandedLocalNetwork:Boolean;

// -----------------------------------------------------------------------------------------------------------------------------------
		public function NetworkBrowser(inStageRef:Stage, allowHighlightSelection:Boolean = false) {
			this.stageRef = inStageRef;
			this.allNodes = new Object();
			this.allEdges = new Array();
			this.sysConfig = new Object();
			this.jsCallback = "network_browser._flashEventHandler";

			// NODE TEXT (normal)
			sysConfig["nodeForeground"] = 0x000000;
			sysConfig["nodeBackground"] = -1;
			sysConfig["nodeItalic"] = false;
			sysConfig["nodeBold"] = false;
			sysConfig["nodeMargin"] = 8;
			sysConfig["nodeBorder"] = false;
			
			// NODE TEXT (highlighted - secondary)
			sysConfig["h_nodeForeground"] = 0x000000;
			sysConfig["h_nodeBackground"] = 0x8aa9e6;
			sysConfig["h_nodeBorder"] = true;
			sysConfig["h_nodeItalic"] = false;
			sysConfig["h_nodeBold"] = true;
			
			// NODE TEXT (highlighted)
			sysConfig["c_nodeForeground"] = 0xffffff;
			sysConfig["c_nodeBackground"] = 0x3366cc;
			sysConfig["c_nodeBorder"] = true;
			sysConfig["c_nodeItalic"] = false;
			sysConfig["c_nodeBold"] = true;
			
			// NODE TEXT (selected)
			sysConfig["s_nodeForeground"] = 0xffffff;
			sysConfig["s_nodeBackground"] = 0xEE9988;
			sysConfig["s_nodeBorder"] = true;
			sysConfig["s_nodeItalic"] = false;
			sysConfig["s_nodeBold"] = true;

			// NODE CIRCLE
			sysConfig["nodeCircleSize"] = 20;
			sysConfig["nodeCircleColorNorm"] = 0xAC1B30;
			sysConfig["nodeCircleColorHigh"] = 0xAC1B30;

			// FILTERING ALPHAs
			sysConfig["nodeUnfilteredAlpha"] = 1;
			sysConfig["nodeFilteredAlpha"] = 0.05;
			sysConfig["edgeUnfilteredAlpha"] = 0.5;
			sysConfig["edgeFilteredAlpha"] = 0.05;
			sysConfig["s_nodeUnfilteredAlpha"] = 1;
			sysConfig["s_nodeFilteredAlpha"] = 0.50;
			sysConfig["s_edgeUnfilteredAlpha"] = 0.75;
			sysConfig["s_edgeFilteredAlpha"] = 0.25;

			// RINGS
			sysConfig["ringWidth"] = 6;
			sysConfig["ringColor"] = 0xebebeb;

			// EDGE SCHEME
			sysConfig['edge_color_norm'] = 0xd2ab6d; //0xf7eedc;
			sysConfig['edge_color_highlight'] = 0x668cd9;
			sysConfig['edge_color_selected'] = 0xAAAAAA;
			sysConfig['edge_color_Bi1'] = 0x4444ff;
			sysConfig['edge_color_Bi2'] = 0xbbbbdd;
			sysConfig['edge_color_Tri1'] = 0xff9999;
			sysConfig['edge_color_Tri2'] = 0xdddd55;
			sysConfig['edge_color_Tri3'] = 0x99ff99;
			
			// ANIMATION SETTINGS
			sysConfig["animate_function"] = "Quadratic";
			sysConfig["animate_direction"] = "InOut";
			sysConfig["animate_duration"] = "1000";

			// FILTER SETTINGS
			sysConfig["filter_refresh"] = 10;
			
			coord_center_x = stageRef.stageWidth / 2;
			coord_center_y = stageRef.stageHeight / 2;
			
			cntNodes = 0;
			cntEdges = 0;

			mc_OffsetPosition = new MovieClip();
			stageRef.addChild(mc_OffsetPosition);
			mc_OffsetPosition.x = coord_center_x;
			mc_OffsetPosition.y = coord_center_y;
			stageRef.setChildIndex(mc_OffsetPosition, 1);
			
			this.CircleLayer = new Sprite();
			stageRef.addChild(CircleLayer);			
			this.CircleLayer.x = coord_center_x;
			this.CircleLayer.y = coord_center_y;
			stageRef.setChildIndex(CircleLayer, 0);
			this.CircleLayer.opaqueBackground = sysConfig["stage_background"];
			
			this.animatorObj = new RadialAnimator(this.stageRef, this.CircleLayer, this.allNodes, this.allEdges, sysConfig);
			this.HighlightSelectMgr = new HiSelectMgr(this, mc_OffsetPosition, animatorObj);
			this.myFilterManager = new FilterManager(this);			
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function WindowedValue(value:Number, valRangeMin:Number, valRangeMax:Number, outRangeMin:Number, outRangeMax:Number):Number {
			return 	(((value - valRangeMin) / (valRangeMax - valRangeMin)) * (outRangeMax - outRangeMin)) + outRangeMin;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function HSLtoRGBcolor(H, S, L):Color {
			var ret = new Color();
			var myColor = this.HSLtoRGB(H, S, L);
			ret.redOffset = myColor.R;
			ret.greenOffset = myColor.G;
			ret.blueOffset = myColor.B;
			return ret;
		}
// --------------------------------------------------------------------------------
		public function HSLtoRGB(H, S, L):Object {
			var ret = new Object();
			if ( S == 0 ) {		//HSL from 0 to 1
				ret.R = L * 255;	//RGB results from 0 to 255
				ret.G = L * 255;
				ret.B = L * 255;
			} else {
				if ( L < 0.5 ) {
					var var_2 = L * ( 1 + S );
				} else {
					var var_2 = ( L + S ) - ( S * L );
				}

				var var_1 = 2 * L - var_2;
				
				ret.R = 255 * Hue_2_RGB( var_1, var_2, H + ( 1 / 3 ) );
				ret.G = 255 * Hue_2_RGB( var_1, var_2, H );
				ret.B = 255 * Hue_2_RGB( var_1, var_2, H - ( 1 / 3 ) );
			}
			return ret;
		}
// --------------------------------------------------------------------------------
		private function Hue_2_RGB(v1, v2, vH) {
			if ( vH < 0 ) vH += 1;
			if ( vH > 1 ) vH -= 1;
			if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
			if ( ( 2 * vH ) < 1 ) return ( v2 );
			if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
			return ( v1 );
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function loadNetwork(base_url:String, initial_ID:String) {
			this.ownerNode_id = initial_ID;
			// get the network
			if (!this.myAutoLoader) {
				// setup new autoload & event handlers
				this.myAutoLoader = new AutoLoader(base_url);
			}
			// send the request
			this.myAutoLoader.GetNetworkFor(initial_ID);
			this.myAutoLoader.addEventListener("DATA_RETREIVED", _networkLoaded);
		}		
// --------------------------------------------------------------------------------
		public function _networkLoaded(evt:Event) {
			// clear the old network info
			this.clearNetwork();
			// load the new network info
			this.dataNodes = this.myAutoLoader.networkNodes;
			this.dataEdges = this.myAutoLoader.networkEdges;
			this.rangesNode = this.myAutoLoader.nodeAttribRanges;
			this.rangesEdge = this.myAutoLoader.edgeAttribRanges;

			// create nodes
			for (var id in this.dataNodes) {
				this.addNode(id, this.dataNodes[id].display_name_short);
			}
			// create edges
			for each (var edge in this.dataEdges) {
				this.addEdge(edge.id1, edge.id2);
			}
			
			// initialize the zIndexes
			this.HighlightSelectMgr.initializeZIndex();
			
			// draw the network
			this.plot(this.myAutoLoader.currentCenterID);
			
			// send signal that we have loaded a new network
			try {
				ExternalInterface.call(this.jsCallback, "NETWORK_LOADED");
			} catch(e) {}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function getDataRange(objType:String, attribName:String) {
			var db:Object;
			var minValue:* = null;
			var maxValue:* = null;
			switch(objType.toUpperCase()) {
				case "NODE":
					db = this.rangesNode;
					break;
				case "EDGE":
					db = this.rangesEdge;
					break;
				default:
					return;
			}
			// send a single to the browser's JS callback function
			var msg:Object = new Object();
			msg.type = objType.toUpperCase();
			msg.attribute = attribName;
			if (db.hasOwnProperty(attribName)) {
				msg.min = db[attribName].min;
				msg.max = db[attribName].max;
			} else {
				msg.invalidAttribute = true;
			}
			try {
				ExternalInterface.call(this.jsCallback, "DATA_RANGE", msg);
			} catch(e) {}						
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function addNode(id:String, nodeText:String) {
			// make sure id is unique then add the node
			if (allNodes.hasOwnProperty(id)) {
				return false;
			}
			// create new node and add to storage list
			var tempNode:NetworkNode;
			tempNode = new NetworkNode(this, id, nodeText, mc_OffsetPosition, (id == this.ownerNode_id));
			allNodes[id] = tempNode;
			allNodes.setPropertyIsEnumerable(id, true);
			cntNodes++;
			
			// register the node with the highlight manager
			this.HighlightSelectMgr.RegisterNode(tempNode);
			
			// attach event listeners
			tempNode.addEventListener("NODE_IN", ReceiveNodeEvent_FromInternal);
			tempNode.addEventListener("NODE_OUT", ReceiveNodeEvent_FromInternal);
			tempNode.addEventListener("NODE_CLICK", ReceiveNodeEvent_FromInternal);
			
			// cause the screen to redraw
			if (this.centerNode) {
				this.plot(centerNode.id);
			}
			return tempNode;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function addEdge(id1:String, id2:String):NetworkEdge {
			if (allNodes.hasOwnProperty(id1) && allNodes.hasOwnProperty(id2)) {
				// both nodes exist
				var n1:NetworkNode = allNodes[id1];
				var n2:NetworkNode = allNodes[id2];
				// see if network edge already exists
				var AlreadyExists:Function = function(edge:NetworkEdge, index:int, array:Array):Boolean {
					if (edge.node1 == n1 && edge.node2 == n2) { return true; }
					if (edge.node1 == n2 && edge.node2 == n1) { return true; }
					return false;					
				};
				if (allEdges.some(AlreadyExists, this)) {
					// the network edge already exists
					return null;
				}
				var newEdge:NetworkEdge = new NetworkEdge(n1, n2, this, mc_OffsetPosition);
				allEdges.push(newEdge);
				cntEdges++;

				// register with the highligh/select controller
				this.HighlightSelectMgr.RegisterEdge(newEdge);

				// attach event listeners
				newEdge.addEventListener("EDGE_IN", ReceiveNodeEvent_FromInternal);
				newEdge.addEventListener("EDGE_OUT", ReceiveNodeEvent_FromInternal);
				newEdge.addEventListener("EDGE_CLICK", ReceiveNodeEvent_FromInternal);
				return newEdge;
			}
			return null; 
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function removeNode(id:String, doRedraw:Boolean = false):Boolean {
			if (this.centerNode && this.centerNode.id == id) { return false; }
			// remove the node
			if (allNodes.hasOwnProperty(id)) {
				allNodes[id].removeEventListener("NODE_IN", ReceiveNodeEvent_FromInternal);
				allNodes[id].removeEventListener("NODE_OUT", ReceiveNodeEvent_FromInternal);
				allNodes[id].removeEventListener("NODE_CLICK", ReceiveNodeEvent_FromInternal);
				allNodes[id].destroy();
				delete allNodes[id];
				// remove any edges that connect to this node
				this.removeEdge(id, '*');
			}			
			// redraw if requested
			if (this.centerNode && doRedraw) {
				this.plot(centerNode.id);
			}
			return true;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function removeEdge(id1:String,id2:String):Boolean {
			// remove any edges associated to the target node
			for (var idx in allEdges) {
				var edge = allEdges[idx];
				if ((edge.node1.id == id1 || edge.node2.id == id1) && (edge.node1.id == id2 || edge.node2.id == id2 || id2=='*')) {
					// edge to delete
					edge.destroy();
					allEdges[idx] = false;
					allEdges.splice(idx,1);
				}
			}
			cntEdges = allEdges.length;
			return true;
		}		
// -----------------------------------------------------------------------------------------------------------------------------------
		public function clearNetwork() {
			if (!centerNode) { return undefined; }
			for (var nodeID in allNodes) {
				this.removeNode(nodeID);
			}
			var id = centerNode.id;
			centerNode = undefined;
			this.removeNode(id);
			// sometimes edges are left over
			while (allEdges.length > 0) {
				allEdges[0].destroy();
				allEdges.splice(0,1);
			}
			// clear the old positions and fix counts
			this.currentPositions = undefined;
			this.cntNodes = 0;
			this.cntEdges = 0;
			this.CircleLayer.graphics.clear();

			// clear the network data
			this.dataNodes = new Object();
			this.dataEdges = new Object();
			this.rangesEdge = new Object();
			this.rangesNode = new Object();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function configJavascriptCallback(functionName:String):void {
			this.jsCallback = functionName;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function configSetting(settingName:String, settingValue:*) {
			if (sysConfig.hasOwnProperty(settingName)) {
				sysConfig[settingName] = settingValue;
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function plot(center_id:String) {
			// make sure center node exists
			if (!allNodes.hasOwnProperty(center_id)) { return false; }
			// don't re-render the center node
			if (this.centerNode === this.allNodes[center_id]) { return; }

			var HopCounts:Object;
			// get our new center node's reference and save the old center node (if set)
			if (this.centerNode) { var oldCenter = this.centerNode; } 
			this.centerNode = allNodes[center_id];

			var newPositioner = new RadialLayoutPositioner(allNodes, allEdges);
			var positions:Object = newPositioner.plot(center_id);

			// figure out the longest path so we scale our rings accordingly with the new positions
			var max_hop:int = 0;
			for each (var coord in positions) {
				if (coord.hop > max_hop) {
					max_hop = coord.hop;
				}
			}
			// figure out the longest path using the old positions (for distance rings)
			// figure out the longest path so we scale our rings accordingly with the new positions
			var old_max_hop:int = 0;
			for each (var coord in this.currentPositions) {
				if (coord.hop > old_max_hop) {
					old_max_hop = coord.hop;
				}
			}
			
			// calculate hop sizes
			if (this.stageRef.width < this.stageRef.height) {
				var hop_unit_size:Number = (this.stageRef.stageWidth * .6 - 150) / max_hop;
			} else {
				var hop_unit_size:Number = (this.stageRef.stageHeight * .6 - 150) / max_hop;
			}

			// convert hop distance to pixel distances
			for (var nodeID:String in positions) {
				positions[nodeID].distance = hop_unit_size*positions[nodeID].hop;
			}

			// generate original positions if needed
			if (this.currentPositions == undefined) {
				this.currentPositions = positions;
			} else {
				// visual animation tweaks
				positions[this.centerNode.id].theta = this.currentPositions[this.centerNode.id].theta;
				this.currentPositions[oldCenter.id].theta = positions[oldCenter.id].theta;
			}
			// animate from old positions to new positions
			this.animatorObj.SetPositions(this.currentPositions, positions);
			this.currentPositions = positions;  // old positions have been copied
			this.animatorObj.animate();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function ReceiveNodeEvent_FromInternal(evt:MouseEvent):void {			
			if (this.animatorObj && !this.animatorObj.done) { return; }

			var keyModifier:String = "";
			if (evt.shiftKey) { keyModifier = keyModifier+"_SHIFT"; }
			if (evt.altKey) { keyModifier = keyModifier+"_ALT"; }
			if (evt.ctrlKey) { keyModifier = keyModifier+"_CTRL"; }
			if (evt.type == "NODE_CLICK" && keyModifier != "") {
				var eventName = "NODE"+keyModifier+"_CLICK";
			} else {
				var eventName = evt.type;
			}
			switch(eventName) {
				case "NODE_CLICK":
					// animate to new position center person
					this.plot(evt.currentTarget.id);
					// send signal to the browser's JS callback function (by not using case-break here!)
				case "NODE_SHIFT_CLICK":
				case "NODE_ALT_CLICK":
				case "NODE_SHIFT_ALT_CLICK":
				case "NODE_CTRL_CLICK":
				case "NODE_SHIFT_CTRL_CLICK":
				case "NODE_ALT_CTRL_CLICK":
				case "NODE_SHIFT_ALT_CTRL_CLICK":
				case "NODE_IN":
				case "NODE_OUT":
					// send signal to the browser's JS callback function
					try {
						ExternalInterface.call(this.jsCallback, eventName, this.dataNodes[evt.currentTarget.id]);
					} catch(e) {}
					break;
				case "EDGE_IN":
				case "EDGE_OUT":
				case "EDGE_CLICK":
					// send signal to the browser's JS callback function
					try {
						var retObj = new Object(); 
						var edge = this.dataEdges[evt.currentTarget.node1.id+"-"+evt.currentTarget.node2.id];
						for (var prop in edge) {
							if (prop!="id1" && prop!="id2") {
								retObj[prop] = edge[prop];
							}
						}
						retObj.Person1 = dataNodes[edge.id1];
						retObj.Person2 = dataNodes[edge.id2];
						ExternalInterface.call(this.jsCallback, eventName, retObj);
					} catch(e) {}
					break;
			}			
		}
		
// --------------------------------------------------------------------------------
	}
}