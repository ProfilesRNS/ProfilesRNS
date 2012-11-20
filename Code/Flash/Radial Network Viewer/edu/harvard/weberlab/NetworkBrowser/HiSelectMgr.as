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

	import flash.events.*;
	import flash.display.*;
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NetworkEdge;

	class HiSelectMgr {
		
		protected var hiNodes:Array;
		protected var selNodes:Array;
		protected var hiEdges:Array;
		protected var selEdges:Array;
		protected var registeredNodes:Array;
		protected var registeredEdges:Array;
		protected var visualContainer:DisplayObjectContainer;
		protected var refNetworkBrowser:NetworkBrowser;
		protected var requiresRefresh:Boolean;
		protected var currentFocus:Object;
		protected var keyStatusMap:Object;
		public var enabled:Boolean;
		public var allowSelections:Boolean;
		public var allowShiftFullNet:Boolean;
		public var defaultFullNet:Boolean;
// --------------------------------------------------------------------------------
		public function HiSelectMgr(refNetBrowser:NetworkBrowser, refDisplayContainer:DisplayObjectContainer, refAnimator:RadialAnimator) {
			this.hiNodes = new Array();
			this.selNodes = new Array();
			this.hiEdges = new Array();
			this.selEdges = new Array();
			this.registeredNodes = new Array();
			this.registeredEdges = new Array();
			this.visualContainer= refDisplayContainer;
			this.refNetworkBrowser = refNetBrowser;
			this.allowSelections = false;
			this.allowShiftFullNet = true;
			this.defaultFullNet = false;
			this.requiresRefresh = true;
			this.enabled = true;
			refAnimator.addEventListener("ANIMATION_START", ReceiveEvent_FromInternal);
			refAnimator.addEventListener("ANIMATION_END", ReceiveEvent_FromInternal);
			this.visualContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN, ReceiveEvent_FromKeyboard);
			this.visualContainer.stage.addEventListener(KeyboardEvent.KEY_UP, ReceiveEvent_FromKeyboard);
			this.keyStatusMap = new Object();
		}
// --------------------------------------------------------------------------------
		public function RegisterEdge(inEdge:NetworkEdge):void {
			// attach event listeners
			inEdge.addEventListener("EDGE_IN", ReceiveEvent_FromInternal);
			inEdge.addEventListener("EDGE_OUT", ReceiveEvent_FromInternal);
			inEdge.addEventListener("EDGE_CLICK", ReceiveEvent_FromInternal);
			inEdge.addEventListener("DESTROY_EDGE", ReceiveEvent_FromInternal);
			// save reference
			this.registeredEdges.push(inEdge);
		}
// --------------------------------------------------------------------------------
		public function RegisterNode(inNode:NetworkNode):void {
			inNode.highlight(0);
			// attach event listeners
			inNode.addEventListener("NODE_IN", ReceiveEvent_FromInternal);
			inNode.addEventListener("NODE_OUT", ReceiveEvent_FromInternal);
			inNode.addEventListener("NODE_CLICK", ReceiveEvent_FromInternal);
			inNode.addEventListener("DESTROY_NODE", ReceiveEvent_FromInternal);
			// save reference
			this.registeredNodes.push(inNode);
		}
// --------------------------------------------------------------------------------
		public function UnregisterEdge(inEdge:*):void {
			// attach event listeners
			inEdge.removeEventListener("EDGE_IN", ReceiveEvent_FromInternal);
			inEdge.removeEventListener("EDGE_OUT", ReceiveEvent_FromInternal);
			inEdge.removeEventListener("EDGE_CLICK", ReceiveEvent_FromInternal);
			inEdge.removeEventListener("DESTROY_EDGE", ReceiveEvent_FromInternal);
			// remove edge references
			for (var idx in this.hiEdges) {
				if (this.hiEdges[idx] === inEdge) {
					this.hiEdges.splice(idx,1);
					break;
				}
			}
			for (var idx in this.selEdges) {
				if (this.selEdges[idx] === inEdge) {
					this.selEdges.splice(idx,1);
					break;
				}
			}
			for (var idx in this.registeredEdges) {
				if (this.registeredEdges[idx] === inEdge) {
					this.registeredEdges.splice(idx,1);
					break;
				}
			}
		}
// --------------------------------------------------------------------------------
		public function UnregisterNode(inNode:*):void {
			// attach event listeners
			inNode.removeEventListener("NODE_IN", ReceiveEvent_FromInternal);
			inNode.removeEventListener("NODE_OUT", ReceiveEvent_FromInternal);
			inNode.removeEventListener("NODE_CLICK", ReceiveEvent_FromInternal);
			inNode.removeEventListener("DESTROY_NODE", ReceiveEvent_FromInternal);
			// remove node references
			for (var idx in this.hiNodes) {
				if (this.hiNodes[idx] === inNode) {
					this.hiNodes.splice(idx,1);
					break;
				}
			}
			for (var idx in this.selNodes) {
				if (this.selNodes[idx] === inNode) {
					this.selNodes.splice(idx,1);
					break;
				}
			}
			for (var idx in this.registeredNodes) {
				if (this.registeredNodes[idx] === inNode) {
					this.registeredNodes.splice(idx,1);
					break;
				}
			}
		}
// --------------------------------------------------------------------------------
		public function HighlightNode(inNode, onlyThis:Boolean, keyShift:Boolean, overrideColor:String = ""):void {
			if (inNode === null) { return; }
			
			// when a node is highlighted it eliminates old highlight
			var nodeZIndex = this.registeredNodes.length + this.registeredEdges.length;
			
			// set this node equal be center of highlights
			inNode.highlight(1);
			inNode.zIndex(nodeZIndex);
			this.hiNodes.push(inNode);
			// we want all other highlights to be below this one
			nodeZIndex--;
			
			if (onlyThis) { return; }
			
			// highlight node's child nodes
			var children:Array = inNode.getCoAuthors();
			while(children.length > 0) {
				var child:NetworkNode = children.pop();
				child.highlight(2);
				child.zIndex(nodeZIndex);
				this.hiNodes.push(child);
			}
			
			// highlight the inter-node edges
			var topEdgeZIndex = this.registeredEdges.length;
			if (allowShiftFullNet && ((defaultFullNet && !keyShift) || (!defaultFullNet && keyShift))) {
				// highlight the full network
				for (var i=0; i < this.registeredEdges.length; i++) {
					var edge = this.registeredEdges[i];
					if (edge.node1.highlight_level > 0 && edge.node2.highlight_level > 0 ) {
						// both nodes are highlighted
						edge.highlighted = true;
						edge.zIndex(topEdgeZIndex);
						// figure out which color to highlight the link as
						if (edge.node1 == inNode || edge.node2 == inNode) {
							// primary link to node
							edge.redraw("edge_color_Bi1");
						} else {
							// secondary link to between child nodes
							edge.redraw("edge_color_Bi2");
						}
						this.hiEdges.push(edge);
					}
				}
			} else {
			   // highlight radial network
				for (var i=0; i < this.registeredEdges.length; i++) {
					var edge = this.registeredEdges[i];
					if (edge.node1 === inNode || edge.node2 === inNode) {
						// both nodes are highlighted
						edge.highlighted = true;
						edge.zIndex(topEdgeZIndex);
						edge.redraw(overrideColor);
						this.hiEdges.push(edge);
					}
				}
			}
		}
// --------------------------------------------------------------------------------
		public function HighlightEdge(inEdge, keyShift:Boolean):void {
			// highlight edge
			var topEdgeZIndex = this.registeredEdges.length;
			inEdge.highlighted = true;
			inEdge.zIndex(topEdgeZIndex);
			this.hiEdges.push(inEdge);
			inEdge.redraw();
			// highlight 2 parent nodes 
			this.HighlightNode(inEdge.node1, !keyShift, false, "edge_color_Tri1");
			this.HighlightNode(inEdge.node2, !keyShift, false, "edge_color_Tri3");
			// rehighlight node1 as the correct color
			this.HighlightNode(inEdge.node1, true, false);
			// override edge color if we are doing expanded view
			if (keyShift) {
				inEdge.redraw("edge_color_Tri2");
			}
		}
// --------------------------------------------------------------------------------
		public function UnhighlightAll():void {
			// unhighlight the nodes
			this.requiresRefresh = false;
			var nodeZIndex = this.registeredNodes.length + this.registeredEdges.length - this.hiNodes.length - this.selNodes.length;
			while (this.hiNodes.length > 0) {
				var node:NetworkNode = this.hiNodes.pop();
				node.highlight(0);
				if (!node.selected) {
					node.zIndex(nodeZIndex);
				}
			}
			
			// unhighlight the edges
			var edgeZIndex =  this.registeredEdges.length - this.selEdges.length - this.hiEdges.length;
			while (this.hiEdges.length > 0) {
				var edge:NetworkEdge = this.hiEdges.pop();
				edge.highlighted = false;
				if (!edge.selected) {
					edge.zIndex(edgeZIndex);
				}
				edge.redraw();
			}
		}
// --------------------------------------------------------------------------------
		public function SelectNode(inNode):void {
			// select a network node
			inNode.selected = true;
			// highlight node
			inNode.highlight(1);
			// save its selected status
			this.selNodes.push(inNode);
			// fix the zIndex
			var topSelectZIndex = this.registeredNodes.length + this.registeredEdges.length - this.hiNodes.length;
			var lbl = inNode.label_ref;
			lbl.parent.setChildIndex(lbl, topSelectZIndex);
		}
// --------------------------------------------------------------------------------
		public function SelectEdge(inEdge):void {}
		public function DeselectNode(inNode):void {}
		public function DeselectEdge(inEdge:NetworkEdge):void {}
		public function DeselectAllNodes(inNode:NetworkNode):void {}
		public function DeselectAllEdges(inEdge:NetworkEdge):void {}
// --------------------------------------------------------------------------------
		public function initializeZIndex():void {
			var topSelectZIndex = this.registeredNodes.length + this.registeredEdges.length;
			var l = this.registeredNodes.length;
			for each (var item in this.registeredNodes) {
				item.zIndex(topSelectZIndex);
				topSelectZIndex--;
			}
			for each (var item in this.registeredEdges) {
				item.zIndex(topSelectZIndex);
				topSelectZIndex--;
			}
		}
// --------------------------------------------------------------------------------
		public function ReceiveEvent_FromKeyboard(evt:KeyboardEvent) {
			if (evt.keyCode == 16 || evt.keyCode == 17) {
				if (this.keyStatusMap["SHIFT"] != evt.shiftKey || this.keyStatusMap["CTRL"] != evt.ctrlKey) {
					this.keyStatusMap["SHIFT"] = evt.shiftKey;
					this.keyStatusMap["CTRL"] = evt.ctrlKey;					
					if (this.currentFocus is NetworkEdge) {
						var eventName = "EDGE_IN";
					} else {
						var eventName = "NODE_IN";						
					}
					this.requiresRefresh = true;
					var injectEvent = new MouseEvent(eventName, true, false, 0, 0, null, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0);
					this.ReceiveEvent_FromInternal(injectEvent);
				}
			}
		}
// --------------------------------------------------------------------------------
		public function ReceiveEvent_FromInternal(evt:MouseEvent):void {
			if (evt.type == "ANIMATION_END") { this.enabled = true; }
			if (!this.enabled) { return; }
			switch(evt.type) {
				case "ANIMATION_START":
					this.enabled = false;
					break;
				case "ANIMATION_END":
					this.enabled = true;
					this.requiresRefresh = true;
					this.UnhighlightAll();
					break;
				case "NODE_CLICK":
				case "NODE_SHIFT_CLICK":
					if (this.requiresRefresh) {
						this.UnhighlightAll();
					}
					if (evt.currentTarget !== null) {
						this.currentFocus = evt.currentTarget;
					}
					this.HighlightNode(this.currentFocus, false, evt.shiftKey);
					break;
				case "NODE_IN":
					if (this.requiresRefresh) {
						this.UnhighlightAll();
					}
					if (evt.currentTarget !== null) {
						this.currentFocus = evt.currentTarget;
					}
//					this.HighlightNode(this.currentFocus, false, evt.shiftKey);
					this.HighlightNode(this.currentFocus, false, false);
					break;
				case "EDGE_IN":
					if (this.requiresRefresh) {
						this.UnhighlightAll();
					}
					if (evt.currentTarget !== null) {
						this.currentFocus = evt.currentTarget;
					}
//					this.HighlightEdge(this.currentFocus, evt.shiftKey);
					this.HighlightEdge(this.currentFocus, false);
					break;
				case "NODE_OUT":
				case "EDGE_OUT":
					this.currentFocus = null;
					this.UnhighlightAll();
					break;
				case "EDGE_CLICK":
					break;
				case "DESTROY_NODE":
					// remove event handlers and references to this node
					this.UnregisterNode(evt.currentTarget)
					break;
				case "DESTROY_EDGE":
					// remove event handlers and references to this edge
					this.UnregisterEdge(evt.currentTarget);
					break;
			}
		}
		
// --------------------------------------------------------------------------------		
	}
}