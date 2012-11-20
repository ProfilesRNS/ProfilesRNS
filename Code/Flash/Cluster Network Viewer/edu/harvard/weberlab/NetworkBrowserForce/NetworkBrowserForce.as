/*  
 
Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.

	Original Author : Nick Benik

Code licensed under a BSD License. 
For details, see: LICENSE.txt

*/


package edu.harvard.weberlab.NetworkBrowserForce {
//    import fl.managers.StyleManager;
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.xml.*;
    import flash.geom.*;
	import fl.motion.Color;
	import edu.harvard.weberlab.NetworkBrowserForce.AutoLoader;
	import edu.harvard.weberlab.ValueWindow;
	import flare.util.*;
	import flare.vis.*;
	import flare.vis.data.*;
    import flare.vis.controls.*;
    import flare.vis.events.*;
	import flare.vis.operator.*;
	import flare.vis.operator.label.*;
	import flare.vis.operator.layout.*;
	import flare.physics.*;
	import flare.animate.Scheduler;


	public class NetworkBrowserForce {
		
		public static var _simulationSpeed:Number;
		public static var _simulationSpacer:Number;

		public var allNodes:Object;
		public var allEdges:Array;
		public var dataNodes:Object;
		public var dataEdges:Object;
		
		public var myAutoLoader:AutoLoader;
		protected var stageRef:Stage;
		protected var coord_center_x:Number;
		protected var coord_center_y:Number;
		protected var mc_OffsetPosition:MovieClip;
		public var jsCallback:String;
		public var sysConfig:Object;
		public var b_highlightExpandedLocalNetwork:Boolean;
		public var centerNode:NodeSprite;
		public var ownerNode_id:String;
		private var vis:Visualization;
		public var nodeLabeler:Labeler;
		public var forceLayout:*;
		private var frameTick:uint;
		private var frameTickThreshold:uint;
		private var networkEnergy:Array;
		private var _IsProcessing:Boolean;

// -----------------------------------------------------------------------------------------------------------------------------------
		public function NetworkBrowserForce(inStageRef:Stage, allowHighlightSelection:Boolean = false) {
			this.stageRef = inStageRef;
			this.allNodes = new Object();
			this.allEdges = new Array();
			this.sysConfig = new Object();
			this.networkEnergy = new Array();
			this._IsProcessing = false;
			
			// frame tick service
			this.frameTick = 0;
			this.frameTickThreshold = 1; //this.stageRef.frameRate * 1.5; // start frametick service 1.5 seconds into visualization
			this.stageRef.addEventListener(Event.ENTER_FRAME, FrameTick);

			
			// NODE CIRCLE
			sysConfig["nodeSizeDefault"] = 0.8;
			sysConfig["nodeSizeMax"] = 3;
			sysConfig["nodeSizeMin"] = 0.8;
			sysConfig["nodeSizeOn"] = "pubs";
			sysConfig["nodeSizeReversed"] = false;

			// NODE MASS
			sysConfig["nodeMassDefault"] = 2.0;
			sysConfig["nodeMassMax"] = 50;
			sysConfig["nodeMassMin"] = 10;
			sysConfig["nodeMassOn"] = "";
			sysConfig["nodeMassReversed"] = false;
			
			// EDGE LENGTH
			sysConfig["edgeSizeDefault"] = 15;
			sysConfig["edgeSizeMax"] = 100;
			sysConfig["edgeSizeMin"] = 20;
			sysConfig["edgeSizeOn"] = "";
			sysConfig["edgeSizeReversed"] = true;


			// EDGE WIDTH
			sysConfig["edgeWidthDefault"] = 1;
			sysConfig["edgeWidthMax"] = 10;
			sysConfig["edgeWidthMin"] = 1;
			sysConfig["edgeWidthOn"] = "n";
			sysConfig["edgeWidthReversed"] = false;


			// EDGE TENSION
			sysConfig["edgeTensionDefault"] = 0.001;
			sysConfig["edgeTensionMax"] = 0.05;
			sysConfig["edgeTensionMin"] = 0.001;
			sysConfig["edgeTensionOn"] = "n";
			sysConfig["edgeTensionReversed"] = false;
			

			// Visualization padding from edge of stage (only utilized on startup and after resize)
			sysConfig["padFromEdge"] = 10;


			// NODE - Network Owner
			sysConfig["n_fColor0"] = 0xccf1ada0; //0x77EE9988;
			sysConfig["n_lColor0"] = 0xffa34e3d; //0xffFF0000;			
			// NODE - 1 hop distance from Network Owner
			sysConfig["n_fColor1"] = 0xccc2e587; //0x77B3DE69;
			sysConfig["n_lColor1"] = 0xff68931e; //0xff00FF00;
			// NODE - 2 hop distance from Network Owner
			sysConfig["n_fColor2"] = 0xcca1baeb; //0x778AA9E6;
			sysConfig["n_lColor2"] = 0xff3f5e9b; //0xff9988EE;

			sysConfig["nodeCircleColorNorm"] = 0xff9988EE;
			// sysConfig["edgeColorNorm"] = 0x7fD2AB6D;
			sysConfig["edgeColorNorm"] = 0x7fBBBBBB;
			
			// HIGHLIGHT STUFF [p=primary (mouseover), s=secondary]
			sysConfig["highliteNodeBGColor_p"] = 0xff3366CC
			sysConfig["highliteNodeBGColor_s"] = 0xff8AA9E6;
			// sysConfig["highliteEdgeColor"] = 0xff668CD9;
			// sysConfig["highliteEdgeColor"] = 0xbfB23F45;			
			sysConfig["highliteEdgeColor"] = 0xffff0000;			
						
			// sysConfig["nodeColorHighlight1"] = 0xff003399;
			// sysConfig["nodeColorHighlight1"] = 0xffB23F45;
			sysConfig["nodeColorHighlight1"] = 0xffff0000;
					

			this.coord_center_x = stageRef.stageWidth / 2;
			this.coord_center_y = stageRef.stageHeight / 2;
			
			// attach the resize handler
			stageRef.addEventListener(Event.RESIZE, _resize);

		}
		
// -----------------------------------------------------------------------------------------------------------------------------------
		private function _resize(evt:Event):void {
			var pad:Number = this.sysConfig["padFromEdge"];
			this.coord_center_x = stageRef.stageWidth / 2;
			this.coord_center_y = stageRef.stageHeight / 2;
			if (!this.vis) {
    	        this.vis.bounds = new Rectangle(pad, pad, this.stageRef.stageWidth - (2*pad), this.stageRef.stageHeight - (2*pad));
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function Pause():void {
			if (this.vis) {
				this.vis.continuousUpdates = false;
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function Play(simSpeed:Number=0):void {
			if (this.vis) {
				if (simSpeed > 0) {
					_simulationSpeed = simSpeed;
				}
				Scheduler.instance.timerInterval = _simulationSpeed;
				this.vis.continuousUpdates = true;
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------

		public function loadNetwork(base_url:String, initial_ID:String, simMultiplier:Number=1) {
			this.ownerNode_id = initial_ID;
			_simulationSpacer = simMultiplier;
			_simulationSpeed = 20;

			// get the network
			if (!this.myAutoLoader) {
				// setup new autoload & event handlers
				this.myAutoLoader = new AutoLoader(base_url);
			}
			// send the request
			this.myAutoLoader.GetNetworkFor(initial_ID);
			this.myAutoLoader.addEventListener("DATA_RETREIVED", _networkLoaded);
		}		
		public function _networkLoaded(evt:Event) {
			var data = this.myAutoLoader.visData;
            var tempNode:NodeSprite = null;
            this.dataNodes = {shape:Shapes.CIRCLE, lineColor:this.sysConfig["nodeCircleColorNorm"], lineWidth:1, visible:true, color:this.sysConfig["nodeCircleColorNorm"]};
            this.dataEdges = {lineColor:sysConfig["edgeColorNorm"], visible:true};
            this.nodeLabeler = new Labeler("data.name");
            this.nodeLabeler.textFormat = new TextFormat("Arial", 10, 0, false);
            this.nodeLabeler.xOffset = 0;
            this.nodeLabeler.yOffset = 0;
			
			if (!this.vis) {
				var pad:Number = this.sysConfig["padFromEdge"];
	            this.vis = new Visualization(data);				
    	        this.vis.bounds = new Rectangle(pad*3, pad, this.stageRef.stageWidth - (6*pad), this.stageRef.stageHeight - (2*pad));
// DON'T USE GPU ACCELERATED MODULE (experimental)
// this.forceLayout = new ForceDirectedLayoutPB(true);
        	    this.forceLayout = new ForceDirectedLayout(true);
	           	this.forceLayout.parameters = {defaultParticleMass:this.sysConfig["nodeMassDefault"], defaultSpringLength:this.sysConfig["edgeSizeDefault"], defaultSpringTension:this.sysConfig["edgeTensionDefault"], ticksPerIteration:4};
	            this.vis.operators.add(forceLayout);
    	        this.vis.operators.add(this.nodeLabeler);
        	    this.stageRef.addChild(this.vis);
			}
            this.vis.continuousUpdates = false;
            this.vis.controls.add(new ClickControl(NodeSprite, 1, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
            this.vis.controls.add(new ClickControl(EdgeSprite, 1, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
            this.vis.controls.add(new ClickControl(NodeSprite, 2, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
            this.vis.controls.add(new ClickControl(EdgeSprite, 2, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
            this.vis.controls.add(new HoverControl(NodeSprite, HoverControl.MOVE_TO_FRONT, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
            this.vis.controls.add(new HoverControl(EdgeSprite, HoverControl.DONT_MOVE, ReceiveNodeEvent_FromVisualization, ReceiveNodeEvent_FromVisualization));
			
			// Node Sizing is active
			if (this.sysConfig["nodeSizeOn"] && this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeSizeOn"]]) {
				var isReversed:Boolean = this.sysConfig["nodeSizeReversed"];
				var nodeSizer:ValueWindow = new ValueWindow(sysConfig["nodeSizeMin"],
															sysConfig["nodeSizeMax"],
															this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeSizeOn"]].min,
															this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeSizeOn"]].max,
															ValueWindow.WINDOW_FUNC_RATIO,
															isReversed);
				nodeSizer.misc1 = this.sysConfig["nodeSizeOn"];
			}

			// Node Mass is active
			if (this.sysConfig["nodeMassOn"] && this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeMassOn"]]) {
				var isReversed:Boolean = this.sysConfig["nodeMassReversed"];
				var nodeMasser:ValueWindow = new ValueWindow(sysConfig["nodeMassMin"],
															sysConfig["nodeMassMax"],
															this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeMassOn"]].min,
															this.myAutoLoader.nodeAttribRanges[this.sysConfig["nodeMassOn"]].max,
															ValueWindow.WINDOW_FUNC_RATIO,
															isReversed);
				nodeMasser.misc1 = this.sysConfig["nodeMassOn"];
			}


			// Edge spring tension is active
			if (this.sysConfig.hasOwnProperty("edgeTensionOn") && this.myAutoLoader.edgeAttribRanges.hasOwnProperty(this.sysConfig["edgeTensionOn"])) {
				var isReversed:Boolean = this.sysConfig["edgeTensionReversed"];
				var edgeTensioner:ValueWindow = new ValueWindow(sysConfig["edgeTensionMin"],
															sysConfig["edgeTensionMax"],
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeTensionOn"]].min,
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeTensionOn"]].max,
															ValueWindow.WINDOW_FUNC_RATIO,
															isReversed);
				edgeTensioner.misc1 = this.sysConfig["edgeTensionOn"];
			}


			// edge sizing is active
			if (this.sysConfig.hasOwnProperty("edgeSizeOn") && this.myAutoLoader.edgeAttribRanges.hasOwnProperty(this.sysConfig["edgeSizeOn"])) {
				var isReversed:Boolean = this.sysConfig["edgeSizeReversed"];
				var edgeSizer:ValueWindow = new ValueWindow(sysConfig["edgeSizeMin"],
															sysConfig["edgeSizeMax"],
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeSizeOn"]].min,
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeSizeOn"]].max,
															ValueWindow.WINDOW_FUNC_RATIO,
															isReversed);
				edgeSizer.misc1 = this.sysConfig["edgeSizeOn"];
			}


			// edge width is active
			if (this.sysConfig.hasOwnProperty("edgeWidthOn") && this.myAutoLoader.edgeAttribRanges.hasOwnProperty(this.sysConfig["edgeWidthOn"])) {
				var isReversed:Boolean = this.sysConfig["edgeWidthReversed"];
				var edgeWidth:ValueWindow = new ValueWindow(sysConfig["edgeWidthMin"],
															sysConfig["edgeWidthMax"],
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeWidthOn"]].min,
															this.myAutoLoader.edgeAttribRanges[this.sysConfig["edgeWidthOn"]].max,
															ValueWindow.WINDOW_FUNC_RATIO,
															isReversed);
				edgeWidth.misc1 = this.sysConfig["edgeWidthOn"];
			}


			var foundMaxLinks=0;
			var foundMinLinks=5000;
            for each (tempNode in this.vis.data.nodes) {
                tempNode.x = this.coord_center_x;
                tempNode.y = this.coord_center_y;
				tempNode.buttonMode = true;
				// deal with node size processing
				if (nodeSizer) {
					try {
						tempNode.size = nodeSizer.calculate(tempNode.data[nodeSizer.misc1]);
					} catch(e) {
						tempNode.size = this.sysConfig["nodeSizeDefault"];
					}
				} else {
					tempNode.size = this.sysConfig["nodeSizeDefault"];
				}
				foundMaxLinks = Math.max(foundMaxLinks, tempNode.childDegree);
				foundMinLinks = Math.min(foundMinLinks, tempNode.childDegree);
            }
			
            this.vis.controls.add(new DragControl(NodeSprite));
            this.vis.update();
			
            for each (tempNode in this.vis.data.nodes) {
				var props:Object = new Object();
				if (tempNode.data.id == this.ownerNode_id) {
					// center node
					var ncode = "c";
					this.centerNode = tempNode;
					tempNode.data.d = 0;
				} else {
					var ncode = "n";
				}
				// adjust the mass according to number of links the node has
				if (nodeMasser) {
					try {
						tempNode.props.particle.mass = nodeMasser.calculate(tempNode.data[nodeMasser.misc1]);
					} catch(e) {
						tempNode.props.particle.mass = sysConfig["nodeMassDefault"];
					}
				} else {
					tempNode.props.particle.mass = sysConfig["nodeMassDefault"];
				}
				tempNode.props.label.text = tempNode.data["display_name_short"];
				tempNode.props.label.buttonMode = true;
				tempNode.fillColor = this.sysConfig["n_fColor"+tempNode.data.d];
				tempNode.lineColor = this.sysConfig["n_lColor"+tempNode.data.d];
			}

			for each (var tempEdge in this.vis.data.edges) {
				// SPRING LENGTH
				try {
					if (edgeSizer) {
						tempEdge.props.spring.restLength = edgeSizer.calculate(tempEdge.data[edgeSizer.misc1]);
					} else {
						tempEdge.props.spring.restLength = this.sysConfig["edgeSizeDefault"];
					}
				} catch(e) {
					tempEdge.props.spring.restLength = this.sysConfig["edgeSizeDefault"];
				}
				// SPRING TENSION
				try {
					if (edgeTensioner) {
						tempEdge.props.spring.tension = edgeTensioner.calculate(tempEdge.data[edgeTensioner.misc1]);
					} else {
						tempEdge.props.spring.tension = sysConfig["edgeTensionDefault"];
					}
				} catch(e) {
					tempEdge.props.spring.tension = sysConfig["edgeTensionDefault"];
				}
				// EDGE WIDTH
				try {
					if (edgeWidth) {
						tempEdge.lineWidth = edgeWidth.calculate(tempEdge.data[edgeWidth.misc1]);
					} else {
						tempEdge.lineWidth = sysConfig["edgeWidthDefault"];
					}
				} catch(e) {
					tempEdge.lineWidth = sysConfig["edgeWidthDefault"];
				}
				
				// FORCE CORRECT EDGE COLOR AND BLENDING
				tempEdge.lineColor = this.sysConfig["edgeColorNorm"];
				tempEdge.props.blendMode = BlendMode.DARKEN;
			}


			Scheduler.instance.timerInterval = _simulationSpeed;
            this.vis.continuousUpdates = true;
			this.frameTick = 1;

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
					db = this.myAutoLoader.nodeAttribRanges;
					break;
				case "EDGE":
					db = this.myAutoLoader.edgeAttribRanges;
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
		public function clearNetwork() {
			try { this.vis.data.clear(); } catch(e) {}
		}

// -----------------------------------------------------------------------------------------------------------------------------------
		public function configJavascriptCallback(functionName:String):void {
			this.jsCallback = functionName;
		}
		
// -----------------------------------------------------------------------------------------------------------------------------------
		public function configSetting(settingName:String, settingValue:*) {
			if (sysConfig.hasOwnProperty(settingName)) { sysConfig[settingName] = settingValue; }
		}

// -----------------------------------------------------------------------------------------------------------------------------------
	public function FrameTick(evt:*):void {
		if (this._IsProcessing) { return; }
		this._IsProcessing = true;
		if (this.frameTick > 0) {
// UNUSED CODE TO DETERMINE WHEN THE GRAPH HAS FOUND A LOCAL MINIMUM AND CAN STOP THE SIMULATION
//			if (!this.vis.continuousUpdates) { return; }
			this.frameTick++;
			if (this.frameTick > 4294967294) { this.frameTick = this.frameTickThreshold +1;}
			// see if we are over the initial 1.5 second processing pause
			if (this.frameTick > this.frameTickThreshold ) { //&& (this.frameTick % 2) == 0) {
// UNUSED CODE TO DETERMINE WHEN THE GRAPH HAS FOUND A LOCAL MINIMUM AND CAN STOP THE SIMULATION
//				if (this.frameTick % 3 == 0) {
//					if (this.vis.continuousUpdates == false) {
//						this.vis.continuousUpdates = true;
//					} else {
//						this.vis.continuousUpdates = false;
//					}
//				}
//
//				if (this.frameTick % 15 <= 2) {
//						this.vis.continuousUpdates = true;
//				} else {
//					this.vis.continuousUpdates = false;
//				}
//
				if (this.vis.continuousUpdates == false) { 
					this._IsProcessing = false;
					return;
				}
				// Perform per Frame processing... (autocenter the network)
				var data = this.myAutoLoader.visData;
				// find min/max bounds for current network
				var xmin:int=this.stageRef.stageWidth;
				var xmax:int=0; 
				var ymin:int=this.stageRef.stageHeight;
				var ymax:int=0;
// UNUSED CODE TO DETERMINE WHEN THE GRAPH HAS FOUND A LOCAL MINIMUM AND CAN STOP THE SIMULATION
//				var sEnergy:Number = 0;
				for each (var tempNode in data.nodes) {
					xmax = Math.max(tempNode.x, xmax);
					xmin = Math.min(tempNode.x, xmin);
					ymax = Math.max(tempNode.y, ymax);
					ymin = Math.min(tempNode.y, ymin);
// UNUSED CODE TO DETERMINE WHEN THE GRAPH HAS FOUND A LOCAL MINIMUM AND CAN STOP THE SIMULATION
//					sEnergy = sEnergy + Math.abs(tempNode.props.particle.vx) + Math.abs(tempNode.props.particle.vy);
				}
				
// UNUSED CODE TO DETERMINE WHEN THE GRAPH HAS FOUND A LOCAL MINIMUM AND CAN STOP THE SIMULATION
//				// calculate the average network energy over the last second)
//				this.networkEnergy.push(sEnergy/(data.nodes.length*2));
//				if (this.networkEnergy.length > 30) {
//					this.networkEnergy.shift();
//				}
//				var i=0;
//				var l=this.networkEnergy.length;
//				sEnergy = 0;
//				for (i=0; i<l; i++) {
//					sEnergy = sEnergy + this.networkEnergy[i]; 
//				}
//				sEnergy = (sEnergy/l);
//				if (sEnergy < 0.0045) {
//					// suspend rendering of network
//		            this.vis.continuousUpdates = false;
//				}

				// bounding box size
				var hBounds = ymax - ymin;
				var wBounds = xmax - xmin;
				// global adjustments
				var dX = (((this.stageRef.stageWidth - wBounds)/2) - xmin);
				var t = Math.abs(dX);
				var t2 = Math.floor(t);
				if (t2 > 3) { t2 = 3; }
				if (dX == t) {
					dX = t2;
				} else {
					dX = -1 * t2;
				}
				var dY = (((this.stageRef.stageHeight - hBounds)/2) - ymin);
				var t = Math.abs(dY);
				var t2 = Math.floor(t);
				if (t2 > 3) { t2 = 3; }
				if (dY == t) {
					dY = t2;
				} else {
					dY = -1 * t2;
				}
				// offset the positions
				for each (var tempNode in data.nodes) {
					tempNode.x = tempNode.x + dX;
					tempNode.y = tempNode.y + dY;
				}
			}
		}
		this._IsProcessing = false;		
	}


// -----------------------------------------------------------------------------------------------------------------------------------	
	private function deselectAll():void {
		for (var id in this.myAutoLoader.networkNodes) {
			var trgt = this.myAutoLoader.networkNodes[id];
			trgt.fillColor = sysConfig["n_fColor"+trgt.data.d];
			trgt.lineColor = sysConfig["n_lColor"+trgt.data.d];
			trgt.data.selected = false;
		}
		for (var id in this.myAutoLoader.networkEdges) {
			var trgt = this.myAutoLoader.networkEdges[id];
			trgt.lineColor = sysConfig["edgeColorNorm"];
			trgt.data.selected = false;
		}
	}
	
// -----------------------------------------------------------------------------------------------------------------------------------	
	private function node_Select(trgtNode:NodeSprite) {
		// select node
		trgtNode.data.selected = true;
		trgtNode.lineColor = sysConfig["nodeColorHighlight1"];
		trgtNode.fillAlpha = 1;
		trgtNode.lineWidth = 2;
//		trgtNode.props.label.textFormat.bold = true;
		// select child nodes
		trgtNode.visitNodes(
			function (pa:NodeSprite):void {
				pa.lineColor = sysConfig["nodeColorHighlight1"];
				pa.fillAlpha = 1;
				pa.lineWidth = 2;
				//pa.props.label.bold = true;
				//pa.props.label.textFormat.bold = true;
				//pa.props.label.textField.border = true;
				//pa.props.label.textField.borderColor = 0x000000;
				//pa.props.label.textField.background = true;
				//pa.props.label.textField.backgroundColor = 0x8aa9e6;
//				pa.props.label.setStyle("textFormat",pa.props.label.textField);
				//pa.props.label.opaqueBackground = 0x8aa9e6;
				return;
			}
		, NodeSprite.ALL_LINKS);
		// highlight edges
		trgtNode.visitEdges(
			function (pa:EdgeSprite):void {
				pa.lineColor = sysConfig["highliteEdgeColor"];
				return;
			}// end function
		, NodeSprite.ALL_LINKS);
	}
	private function node_Deselect(trgtNode:NodeSprite) {
		// deselect node
		trgtNode.data.selected = false;
		trgtNode.lineColor = sysConfig["n_lColor"+trgtNode.data.d];
		trgtNode.fillColor = sysConfig["n_fColor"+trgtNode.data.d];
		trgtNode.lineWidth = 1;
		trgtNode.props.label.textFormat.bold = false;
		// deselect child nodes
		trgtNode.visitNodes(
			function (pa:NodeSprite):void {
				if (!pa.data.selected) {
					pa.lineColor = sysConfig["n_lColor"+pa.data.d];
					pa.fillColor = sysConfig["n_fColor"+pa.data.d];
					pa.lineWidth = 1;
					//pa.props.label.textFormat.bold = false;
					//pa.props.label.opaqueBackground = null;
//					pa.props.label.textField.border = false;
//					pa.props.label.textField.background = false;					
				}
				return;
			}
		, NodeSprite.ALL_LINKS);
		// revert edges
		trgtNode.visitEdges(
			function (pa:EdgeSprite):void {
				pa.lineColor = sysConfig["edgeColorNorm"];
				return;
			}
		, NodeSprite.ALL_LINKS);
	}
	private function edge_Select(trgtEdge:EdgeSprite) {
		// deselect node
		trgtEdge.data.selected = true;
		trgtEdge.lineColor = sysConfig["nodeColorHighlight1"];
		
		trgtEdge.target.lineColor = sysConfig["nodeColorHighlight1"];
		trgtEdge.target.fillAlpha = 1;
		trgtEdge.target.lineWidth = 2;		
		
		trgtEdge.source.lineColor = sysConfig["nodeColorHighlight1"];
		trgtEdge.source.fillAlpha = 1;
		trgtEdge.source.lineWidth = 2;		
	}
	private function edge_Deselect(trgtEdge:EdgeSprite) {
		trgtEdge.data.selected = false;
		trgtEdge.lineColor = sysConfig["edgeColorNorm"];
		
		trgtEdge.target.lineColor = sysConfig["n_lColor"+trgtEdge.target.data.d];
		trgtEdge.target.fillColor = sysConfig["n_fColor"+trgtEdge.target.data.d];
		trgtEdge.target.lineWidth = 1;
		
		trgtEdge.source.lineColor = sysConfig["n_lColor"+trgtEdge.source.data.d];
		trgtEdge.source.fillColor = sysConfig["n_fColor"+trgtEdge.source.data.d];
		trgtEdge.source.lineWidth = 1;
	}
// -----------------------------------------------------------------------------------------------------------------------------------	
	private function toggleNodeHighlight(trgtNode:NodeSprite) {
		if (trgtNode.data.selected) {
			node_Deselect(trgtNode);
		} else {
			node_Select(trgtNode);
		}
	}

// -----------------------------------------------------------------------------------------------------------------------------------	
	public function ReceiveNodeEvent_FromVisualization(evt:SelectionEvent):void {
		var keyModifier:String = "";
		if (evt.shiftKey) { keyModifier = keyModifier+"_SHIFT"; }
		if (evt.altKey) { keyModifier = keyModifier+"_ALT"; }
		if (evt.ctrlKey) { keyModifier = keyModifier+"_CTRL"; }
		if (evt.target is HoverControl) {
			if (evt.type == "select") {
				var eventName = "IN";
			} else {
				var eventName = "OUT";
			}
		} 
		if (evt.target is ClickControl) {
			if (evt.currentTarget.numClicks > 1) {
				var eventName = "DBLCLICK";
			} else {
				var eventName = "CLICK";
			}
		}
		if (evt.object is NodeSprite) {
			var nodeType = "NODE";
			var retObj = new Object(); 
			var node = evt.object.data;
			for (var prop in node) {
				retObj[prop] = node[prop];
			}
		}
		if (evt.object is EdgeSprite) {
			var nodeType = "EDGE";
			var retObj = new Object(); 
			var edge = evt.object.data;
			for (var prop in edge) {
				if (prop!="id1" && prop!="id2") { retObj[prop] = edge[prop]; }
			}
			retObj.Person1 = this.myAutoLoader.networkNodes[edge.id1].data;
			retObj.Person2 = this.myAutoLoader.networkNodes[edge.id2].data;
		}
		// main event processor
		var fullEvtName = nodeType+keyModifier+"_"+eventName;
trace(fullEvtName);
		switch (fullEvtName) {
			case "NODE_CLICK":
				// force the simulation to start again (node was probably moved)
				this.vis.continuousUpdates = true;
				this.networkEnergy = new Array();
				this.networkEnergy.push(0.05);
				break;
			case "NODE_IN":
			case "NODE_SHIFT_IN":
			case "NODE_ALT_IN":
			case "NODE_SHIFT_ALT_IN":
			case "NODE_CTRL_IN":
			case "NODE_SHIFT_CTRL_IN":
			case "NODE_ALT_CTRL_IN":
			case "NODE_SHIFT_ALT_CTRL_IN":
				// toggle node nightlight
				node_Select(evt.node);
				try {
					ExternalInterface.call(this.jsCallback, "NODE_IN", retObj); 
				} catch(e) {}
				break;
			case "NODE_OUT":
			case "NODE_SHIFT_OUT":
			case "NODE_ALT_OUT":
			case "NODE_SHIFT_ALT_OUT":
			case "NODE_CTRL_OUT":
			case "NODE_SHIFT_CTRL_OUT":
			case "NODE_ALT_CTRL_OUT":
			case "NODE_SHIFT_ALT_CTRL_OUT":
				node_Deselect(evt.node);
				try {
					ExternalInterface.call(this.jsCallback, "NODE_OUT", retObj); 
				} catch(e) {}
				break;
			case "EDGE_IN":
			case "EDGE_SHIFT_IN":
			case "EDGE_ALT_IN":
			case "EDGE_SHIFT_ALT_IN":
			case "EDGE_CTRL_IN":
			case "EDGE_SHIFT_CTRL_IN":
			case "EDGE_ALT_CTRL_IN":
			case "EDGE_SHIFT_ALT_CTRL_IN":
				edge_Select(evt.edge);
				try {
					ExternalInterface.call(this.jsCallback, "EDGE_IN", retObj); 
				} catch(e) {}
				break;
			case "EDGE_OUT":
			case "EDGE_SHIFT_OUT":
			case "EDGE_ALT_OUT":
			case "EDGE_SHIFT_ALT_OUT":
			case "EDGE_CTRL_OUT":
			case "EDGE_SHIFT_CTRL_OUT":
			case "EDGE_ALT_CTRL_OUT":
			case "EDGE_SHIFT_ALT_CTRL_OUT":
				edge_Deselect(evt.edge);
				try {
					ExternalInterface.call(this.jsCallback, "EDGE_OUT", retObj); 
				} catch(e) {}
				break;
			default:
				try {
					ExternalInterface.call(this.jsCallback, fullEvtName, retObj);
				} catch(e) {}
				break;
			}
		}
	}
}