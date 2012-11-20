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
	import flash.display.*;
	import flash.events.*;
	import fl.motion.Color;
	
	public class NetworkEdge extends Sprite {
		
		public var node1:NetworkNode;
		public var node2:NetworkNode;
		public var highlighted:Boolean;
		public var filtered:Boolean;
		public var highlightColor;
		public var selected:Boolean;
		private var network_browser_ref:NetworkBrowser;
		public var hash:String;
		
// -----------------------------------------------------------------------------------------------------------------------------------
		public function NetworkEdge(node1_ref:NetworkNode, node2_ref:NetworkNode, netBrowser:NetworkBrowser, displayContainer:DisplayObjectContainer) {
			this.network_browser_ref = netBrowser;
			this.node1 = node1_ref;
			this.node2 = node2_ref;
			this.hash = node1_ref.id + "-" + node2_ref.id;
			this.filtered = false;
			displayContainer.addChild(this);
			// add event handlers
			this.addEventListener(MouseEvent.CLICK, ReceiveNodeEvent_FromInternal);
			this.addEventListener(MouseEvent.MOUSE_OVER, ReceiveNodeEvent_FromInternal);
			this.addEventListener(MouseEvent.MOUSE_OUT, ReceiveNodeEvent_FromInternal);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function setFiltered(isFiltered:Boolean) {
			if (isFiltered) {
				this.filtered = true;
			} else {
				this.filtered = false;
			}
			this.redraw();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function redraw(highlightColor:String = "") {
			var sysConfig = this.network_browser_ref.sysConfig;
			
			this.graphics.clear();

			// line thickness
			var nval = 2*Math.log(network_browser_ref.dataEdges[this.hash].n);

			var renderFiltered:Boolean = this.filtered;
			if (this.node1.filtered || this.node2.filtered) {
				renderFiltered = true;
			}
			
			if (this.highlighted) {
				if (renderFiltered) {
					var filter_alpha:Number = sysConfig["s_edgeFilteredAlpha"];
				} else {
					var filter_alpha:Number = sysConfig["s_edgeUnfilteredAlpha"];
				}
				this.graphics.lineStyle(nval, sysConfig['edge_color_highlight'], filter_alpha);
				this.blendMode = BlendMode.NORMAL;
			} else {
				if (renderFiltered) {
					var filter_alpha:Number = sysConfig["edgeFilteredAlpha"];
				} else {
					var filter_alpha:Number = sysConfig["edgeUnfilteredAlpha"];
				}
				this.graphics.lineStyle(nval, sysConfig['edge_color_norm'], filter_alpha);
				this.blendMode = BlendMode.NORMAL;
			}
			this.graphics.moveTo(node1.coord_x, node1.coord_y);
			this.graphics.lineTo(node2.coord_x, node2.coord_y);
			this.graphics.endFill();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function show() {
			this.redraw();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function destroy() {
			// remove event handlers
			this.removeEventListener(MouseEvent.CLICK, ReceiveNodeEvent_FromInternal);
			this.removeEventListener(MouseEvent.MOUSE_OVER, ReceiveNodeEvent_FromInternal);
			this.removeEventListener(MouseEvent.MOUSE_OUT, ReceiveNodeEvent_FromInternal);
			this.parent.removeChild(this);
			// tell everyone that they should destroy references to this edge
			var edgeEvent:MouseEvent = new MouseEvent("DESTROY_EDGE", false, false, 0, 0, this, false, false, false, false, 0);
			this.dispatchEvent(edgeEvent);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function zIndex(inOrder:int) {
			this.parent.setChildIndex(this,inOrder-1);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		private function ReceiveNodeEvent_FromInternal(evt:MouseEvent) {
			var eventName:String;
			switch (evt.type) {
				case "mouseOver":
					eventName = "EDGE_IN";
					break;
				case "mouseOut":
					eventName = "EDGE_OUT";
					break;
				case "click":
					eventName = "EDGE_CLICK";
					break;
			}
			// copy modifier keys and send
			var edgeEvent:MouseEvent = new MouseEvent(eventName, evt.bubbles, evt.cancelable, evt.localX, evt.localY, evt.relatedObject, evt.ctrlKey, evt.altKey, evt.shiftKey, evt.buttonDown, evt.delta);
			this.dispatchEvent(edgeEvent);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		private function HSLtoRGB(H, S, L) {
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
// -----------------------------------------------------------------------------------------------------------------------------------
		private function Hue_2_RGB(v1, v2, vH) {
			if ( vH < 0 ) vH += 1;
			if ( vH > 1 ) vH -= 1;
			if ( ( 6 * vH ) < 1 ) return ( v1 + ( v2 - v1 ) * 6 * vH );
			if ( ( 2 * vH ) < 1 ) return ( v2 );
			if ( ( 3 * vH ) < 2 ) return ( v1 + ( v2 - v1 ) * ( ( 2 / 3 ) - vH ) * 6 );
			return ( v1 );
		}

// -----------------------------------------------------------------------------------------------------------------------------------
	}
}