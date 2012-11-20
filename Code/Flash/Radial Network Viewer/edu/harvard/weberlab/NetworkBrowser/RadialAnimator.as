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
	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import fl.motion.*;
	import fl.motion.easing.*;
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NetworkEdge;	
	import edu.harvard.weberlab.NetworkBrowser.NodePosition;
	
	public class RadialAnimator extends EventDispatcher {
		
		public var allNodes:Object;
		public var allEdges:Array;
		public var done:Boolean;
		protected var stageRef:Stage;
		protected var framesTotal:int;
		protected var framesCurrent:int;
		protected var rendering:Boolean;
		protected var oldPositions:Object;
		protected var newPositions:Object;
		protected var oldMaxHops:int;
		protected var newMaxHops:int;
		protected var oldCircles:Object;
		protected var newCircles:Object;
		protected var circleRef:Sprite;
		protected var tweenObj;
		protected var AnimateFunction:Function;
		protected var configObject:Object; 
		
// -----------------------------------------------------------------------------------------------------------------------------------
		public function RadialAnimator(inStageRef:Stage, inCircleRef:Sprite, inNodes:Object, inEdges:Array, configObject:Object) {
			this.rendering = false;
			this.done = true;
			this.stageRef = inStageRef;
			this.circleRef = inCircleRef;
			this.configObject = configObject;
			this.framesCurrent = 0;
			if (parseInt(this.configObject["animate_duration"]) == 0) { 
				var inDuration:int = 1000;
			} else {
				var inDuration:int = parseInt(this.configObject["animate_duration"]);
			}
			this.framesTotal = inDuration / (1000 / inStageRef.frameRate);
			this.allNodes = inNodes;
			this.allEdges = inEdges;
			
			// figure grab a reference to the easing calculation function
			var ease;
			var inAnimateType = this.configObject["animate_function"];
			switch (inAnimateType.toUpperCase()) {
				case "BACK":
					ease = Back;
					break;
				case "BOUNCE":
					ease = Bounce;
					break;
				case "CIRCULAR":
					ease = Circular;
					break;
				case "CUBIC":
					ease = Cubic;
					break;
				case "ELASTIC":
					ease = Elastic;
					break;
				case "EXPONENTIAL":
					ease = Exponential;
					break;
				case "LINEAR":
					ease = Linear;
					break;
				default:
				case "QUADRATIC":
					ease = Quadratic;
					break;
				case "QUARTIC":
					ease = Quartic;
					break;
				case "SINE":
					ease = Sine;
					break;
			}
			var inAnimateDirection = this.configObject["animate_direction"];
			switch (inAnimateDirection.toUpperCase()) {
				case "IN":
					this.AnimateFunction = ease.easeIn;
					break;
				case "OUT":
					this.AnimateFunction = ease.easeOut;
					break;
				case "INOUT":
				default:
					this.AnimateFunction = ease.easeInOut;
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function SetPositions(inPositionsOld, inPositionsNew):void {
			this.oldPositions = inPositionsOld;
			var max_hops:Number = 0;
			for each (var position in inPositionsOld) {
				if (position.hop > max_hops) { max_hops  = position.hop; }
			}
			this.oldMaxHops = max_hops;
			
			this.newPositions = inPositionsNew;
			var max_hops:Number = 0;
			for each (var position in inPositionsNew) {
				if (position.hop > max_hops) { max_hops  = position.hop; }
			}
			this.newMaxHops = max_hops;
			// create our start and end animation values
			this.oldCircles = new Object();
			this.newCircles = new Object();
			if (this.oldMaxHops > this.newMaxHops) {
				max_hops = this.oldMaxHops;
				var old_shift = 0;
				var new_shift = this.oldMaxHops - this.newMaxHops;
			} else {
				max_hops = this.newMaxHops;
				var new_shift = 0;
				var old_shift = this.newMaxHops - this.oldMaxHops;
			}
			if (this.stageRef.width < this.stageRef.height) {
				var t = (this.stageRef.stageWidth * .6 - 150);
			} else {
				var t = (this.stageRef.stageHeight * .6 - 150);
			}

			var old_hop_size:Number = t / this.oldMaxHops;
			var new_hop_size:Number = t / this.newMaxHops;
			for (var t = max_hops; t > 0; t--) {
				if (t-old_shift > 0) {
					this.oldCircles[t] = (t - old_shift) * old_hop_size;
				} else {
					this.oldCircles[t] = 0;
				}
				if (t-new_shift > 0) {
					this.newCircles[t] = (t - new_shift) * new_hop_size;
				} else {
					this.newCircles[t] = 0;
				}
			}
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function animate():void {
			this.framesCurrent = 0;
			this.stageRef.quality = "LOW";
			this.dispatchEvent(new MouseEvent("ANIMATION_START"));
			this.done = false;
			this.stageRef.addEventListener(Event.ENTER_FRAME, animate_step);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		private function animate_step(evt:Event):void {
			var samePositions = false;
			if (this.framesCurrent == 1) {
				// on the first frame after initial positioning, see if any animation actually needs to be done
				samePositions = true;
				for (var id in this.oldPositions) {
					if (this.oldPositions[id].distance != this.newPositions[id].distance || this.oldPositions[id].theta != this.newPositions[id].theta) {
						samePositions = false;
						break;
					}
				}
			}
			this.framesCurrent++;
			if (this.rendering) { return; }
			if (samePositions || this.framesCurrent > this.framesTotal) {
				// disconnect the event listenter and set ourself to be done
				this.stageRef.removeEventListener(Event.ENTER_FRAME, animate_step);
				this.dispatchEvent(new MouseEvent("ANIMATION_END"));
				this.done = true;
				this.stageRef.quality = "BEST";
				return;
			}
			this.rendering = true;
			for (var id in this.oldPositions) {
				var newThetaPos = this.newPositions[id].theta - this.oldPositions[id].theta;
				if (newThetaPos > 180) {
					newThetaPos = newThetaPos - 360;
				}
				if (newThetaPos < -180) {
					newThetaPos = newThetaPos + 360;
				}
				var theta = this.AnimateFunction(this.framesCurrent, this.oldPositions[id].theta, newThetaPos, this.framesTotal);
				var dist = this.AnimateFunction(this.framesCurrent, this.oldPositions[id].distance, this.newPositions[id].distance - this.oldPositions[id].distance, this.framesTotal);
 				this.allNodes[id].setPolar(dist, theta);
			}
			for each (var edge in allEdges) {
				edge.redraw();
			}

			// redraw the distance circles
			var ringWidth:int = parseInt(this.configObject["ringWidth"]);
			if (ringWidth > 0) {
				this.circleRef.graphics.clear();
				this.circleRef.graphics.lineStyle(ringWidth, this.configObject["ringColor"]);
				for (var hop in this.newCircles) {
					var dist = this.AnimateFunction(this.framesCurrent, this.oldCircles[hop], this.newCircles[hop] - this.oldCircles[hop], this.framesTotal);
					this.circleRef.graphics.drawCircle(0,0, dist);
				}
			}
			this.rendering = false;
		}
		
// -----------------------------------------------------------------------------------------------------------------------------------
	}
}
