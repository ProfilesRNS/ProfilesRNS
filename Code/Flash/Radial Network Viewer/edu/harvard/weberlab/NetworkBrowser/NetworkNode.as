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
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import edu.harvard.weberlab.AutoSizeButton;
	import flash.events.*;
	import fl.controls.*;
	import flash.text.*;
	import fl.motion.Color;

	public class NetworkNode extends EventDispatcher {
		
		public var selected:Boolean;
		public var highlight_level:int;
		public var id:String;
		public var text:String;
		public var filtered:Boolean;
		public var text_ref:AutoSizeButton;
		public var parent_node:NetworkNode;
		protected var visualContainer:DisplayObjectContainer;
		protected var network_browser_ref:Object;
		protected var coord_theta:Number;
		protected var coord_radus:Number;
		protected var i_am_owner:Boolean;
		internal var coord_x:Number;
		internal var coord_y:Number;
		internal var cached_child_count:Number;
		public var label_ref:Label;

// -----------------------------------------------------------------------------------------------------------------------------------
		public function NetworkNode(networkBrowser:Object, node_id:String, nodeText:String, container:DisplayObjectContainer, isCenterNode:Boolean = false) {
			this.i_am_owner = isCenterNode;
			this.network_browser_ref = networkBrowser;
			this.id = node_id;
			this.text = nodeText;
			this.filtered = false;
			cached_child_count = -1;
			this.highlight_level = 0;

			label_ref = new Label();
			label_ref.autoSize = "center";
			label_ref.textField.text = nodeText;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.bold = this.network_browser_ref.sysConfig["nodeBold"];			
			txtFormat.rightMargin = this.network_browser_ref.sysConfig["nodeMargin"];
			txtFormat.leftMargin = this.network_browser_ref.sysConfig["nodeMargin"];
			txtFormat.italic = this.network_browser_ref.sysConfig["nodeItalic"];
			txtFormat.font = "Arial";
			txtFormat.size = 11;
// REFACTOR: network owner's style
			if(this.i_am_owner) {
				txtFormat.bold = true;
			}
			label_ref.setStyle("disabledTextFormat", txtFormat);
			label_ref.setStyle("textFormat",txtFormat);
			label_ref.textField.text = nodeText;
			// create the text display object and save reference
			visualContainer = container;
			visualContainer.addChild(label_ref);

			// add event handlers
			label_ref.addEventListener(MouseEvent.CLICK, ReceiveNodeEvent_FromInternal);
			label_ref.addEventListener(MouseEvent.MOUSE_OVER, ReceiveNodeEvent_FromInternal);
			label_ref.addEventListener(MouseEvent.MOUSE_OUT, ReceiveNodeEvent_FromInternal);
			
			label_ref.textField.setTextFormat(txtFormat);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function destroy() {
			// remove event handlers
			label_ref.removeEventListener(MouseEvent.CLICK, ReceiveNodeEvent_FromInternal);
			label_ref.removeEventListener(MouseEvent.MOUSE_OVER, ReceiveNodeEvent_FromInternal);
			label_ref.removeEventListener(MouseEvent.MOUSE_OUT, ReceiveNodeEvent_FromInternal);
			// remove label
			visualContainer.removeChild(label_ref);
			label_ref = null;
			visualContainer = null;
			// notify all that they should destroy references to this object
			var nodeEvent:MouseEvent = new MouseEvent("DESTROY_NODE", false, false, 0, 0, null, false, false, false, false, 0);
			this.dispatchEvent(nodeEvent);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function getCoAuthors():Array {
			var transform1 = function(edge:*, idx:int, src_array:Array) {
				if (edge.node1.id == id || edge.node2.id == id) {
					return true;
				}
			}
			var tArray:Array = network_browser_ref.allEdges.filter(transform1, this);
			var transform2 = function(edge:*, idx:int, src_array:Array) {
				if (edge.node1.id == id) {
					return edge.node2;
				} else {
					return edge.node1;
				}
			}
			tArray = tArray.map(transform2, this);
			return tArray;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function setFiltered(isFiltered:Boolean) {
			filtered = isFiltered;
			var a = 1;
			if (isFiltered) {
				if (highlight_level > 0) {
					// filtered but selected
					a = this.network_browser_ref.sysConfig["s_nodeFilteredAlpha"];
				} else {
					// filtered
					a = this.network_browser_ref.sysConfig["nodeFilteredAlpha"];
				}
			} else {
				if (highlight_level > 0) {
					// unfiltered and selected
					a = this.network_browser_ref.sysConfig["s_nodeUnfilteredAlpha"];
				} else {
					// unfiltered
					a = this.network_browser_ref.sysConfig["nodeUnfilteredAlpha"];
				}
			}
			this.label_ref.alpha = a;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function highlight(inLevel:int) {
			var color_cfg = this.network_browser_ref.sysConfig;

			// node circle
			var myData = this.network_browser_ref.dataNodes[this.id];
			var maxPubs = this.network_browser_ref.rangesNode['pubs'].max;
			var dataRangeMin = this.network_browser_ref.rangesNode['pubs'].min;
			var dataRangeMax = this.network_browser_ref.rangesNode['pubs'].max;
			var outputMax = 20;
			var outputMin = 1
			var cir_size = (((myData.pubs - dataRangeMin) / (dataRangeMax - dataRangeMin)) * (outputMax - outputMin)) + outputMin;
			this.label_ref.graphics.clear();

			if (cir_size > 3) {
				this.label_ref.graphics.beginFill(color_cfg["nodeCircleColorNorm"],.3);
				this.label_ref.graphics.lineStyle(1, color_cfg["nodeCircleColorNorm"]);
				this.label_ref.graphics.drawCircle(50, 0.6 * label_ref.textField.textHeight, cir_size);
			}

			switch(inLevel) {
				case 1:
					// set to node of focus
					label_ref.textField.border = true;
					this.label_ref.textField.textColor = color_cfg["c_nodeForeground"];
					if (color_cfg["c_nodeBackground"] == undefined || color_cfg["c_nodeBackground"] < 0) {
						this.label_ref.textField.background = false;
					} else {
						this.label_ref.textField.backgroundColor = color_cfg["c_nodeBackground"];
						this.label_ref.textField.background = true;
					}
					var txtFormat:TextFormat = this.label_ref.textField.getTextFormat();
					txtFormat.bold = true;
					this.label_ref.textField.setTextFormat(txtFormat);
					this.highlight_level = 1;
					break;
				case 2:
					// set to secondary focus
					label_ref.textField.border = true;
					this.label_ref.textField.textColor = color_cfg["h_nodeForeground"];
					if (color_cfg["h_nodeBackground"] == undefined || color_cfg["h_nodeBackground"] < 0) {
						this.label_ref.textField.background = false;
					} else {
						this.label_ref.textField.backgroundColor = color_cfg["h_nodeBackground"];
						this.label_ref.textField.background = true;
					}
					var txtFormat:TextFormat = this.label_ref.textField.getTextFormat();
					txtFormat.bold = true;
// REFACTOR: network owner's style
					if(this.i_am_owner) {
						txtFormat.bold = true;
					}
					this.label_ref.textField.setTextFormat(txtFormat);
					this.highlight_level = 2;
					break;
				default:
					label_ref.textField.border = false;
					if (this.selected) {
						// if the node is force-highlighted then fall back to secondary highlight settings
						this.label_ref.textField.textColor = color_cfg["s_nodeForeground"];
						if (color_cfg["s_nodeBackground"] == undefined || color_cfg["s_nodeBackground"] < 0) {
							this.label_ref.textField.background = false;
						} else {
							this.label_ref.textField.backgroundColor = color_cfg["s_nodeBackground"];
							this.label_ref.textField.background = true;
						}
						var txtFormat:TextFormat = this.label_ref.textField.getTextFormat();
						txtFormat.bold = true;
// REFACTOR: network owner's style
						if(this.i_am_owner) {
							txtFormat.bold = true;
						}
						this.label_ref.textField.setTextFormat(txtFormat);
						this.highlight_level = 2;
					} else {
						// set to no focus
						this.label_ref.textField.textColor = color_cfg["nodeForeground"];
						if (color_cfg["nodeBackground"] == undefined || color_cfg["nodeBackground"] < 0) {
							this.label_ref.textField.background = false;
						} else {
							this.label_ref.textField.backgroundColor = color_cfg["nodeBackground"];
							this.label_ref.textField.background = true;
						}
						var txtFormat:TextFormat = label_ref.textField.getTextFormat();
						txtFormat.bold = this.network_browser_ref.sysConfig["nodeBold"];
						txtFormat.rightMargin = this.network_browser_ref.sysConfig["nodeMargin"];
						txtFormat.leftMargin = this.network_browser_ref.sysConfig["nodeMargin"];
						txtFormat.italic = this.network_browser_ref.sysConfig["nodeItalic"];
// REFACTOR: network owner's style
						if(this.i_am_owner) {
							txtFormat.bold = true;
						}
						this.label_ref.textField.setTextFormat(txtFormat);
						this.highlight_level = 0;
					}
					break;
			}
			// ALPHA VALUES
			var a = 1;
			if (this.filtered) {
				if (inLevel > 0) {
					// filtered but selected
					a = this.network_browser_ref.sysConfig["s_nodeFilteredAlpha"];
				} else {
					// filtered
					a = this.network_browser_ref.sysConfig["nodeFilteredAlpha"];
				}
			} else {
				if (inLevel > 0) {
					// unfiltered and selected
					a = this.network_browser_ref.sysConfig["s_nodeUnfilteredAlpha"];
				} else {
					// unfiltered
					a = this.network_browser_ref.sysConfig["nodeUnfilteredAlpha"];
				}
			}
			this.label_ref.alpha = a;			
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		private function ReceiveNodeEvent_FromInternal(evt:MouseEvent) {
			var eventName:String;
			switch (evt.type) {
				case "mouseOver":
					eventName = "NODE_IN";
					break;
				case "mouseOut":
					eventName = "NODE_OUT";
					break;
				case "click":
					eventName = "NODE_CLICK";
					break;
			}
			// copy modifier keys and send
			var nodeEvent:MouseEvent = new MouseEvent(eventName, evt.bubbles, evt.cancelable, evt.localX, evt.localY, evt.relatedObject, evt.ctrlKey, evt.altKey, evt.shiftKey, evt.buttonDown, evt.delta);
			this.dispatchEvent(nodeEvent);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function setPolar(radius:Number, theta:Number) {
			// converts a polar coordinate into a cartesian and moves the icon there
			var r:Number = radius;
			var a:Number = (theta * Math.PI / 180);
			var x:Number = Math.floor(r * Math.cos(a));
			var y:Number = Math.floor(-r * Math.sin(a));
			setXYCoord(x,y);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function setXYCoord(x:Number, y:Number) {
			var real_x:Number = x;
			var real_y:Number = y;
			this.coord_x = x;
			this.coord_y = y;
			label_ref.move(real_x - 50, real_y - 10);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function zIndex(inOrder:int) {
			this.label_ref.parent.setChildIndex(this.label_ref, inOrder - 1);
		}

// -----------------------------------------------------------------------------------------------------------------------------------
	}
}