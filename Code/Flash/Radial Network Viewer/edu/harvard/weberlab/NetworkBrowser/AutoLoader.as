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
	import flash.external.ExternalInterface;
	import flash.xml.*;
	import flash.net.*;
	import edu.harvard.weberlab.NetworkBrowser.NetworkNode;
	import edu.harvard.weberlab.NetworkBrowser.NetworkEdge;	
	
	public class AutoLoader extends EventDispatcher {
		
		public var networkEdges:Object;
		public var networkNodes:Object;
		public var nodeAttribRanges:Object;
		public var edgeAttribRanges:Object;
		public var currentCenterID:String;
		protected var baseURL:String;
		protected var httpLoader:URLLoader;
				
// --------------------------------------------------------------------------------
		public function AutoLoader(inURL:String) {
			// class constructor 
			this.baseURL = inURL;
		}
// --------------------------------------------------------------------------------
		public function GetNetworkFor(inCenterID:String) {
			this.networkNodes = new Object();
			this.networkEdges = new Object();
			this.nodeAttribRanges = new Object();
			this.edgeAttribRanges = new Object();
			
			this.currentCenterID = inCenterID;
			this.httpLoader = new URLLoader();
			// configure the event listeners
			configureListeners(this.httpLoader);
//			this.httpLoader.addEventListener(Event.COMPLETE, completeHandler);
			var request:URLRequest = new URLRequest(this.baseURL+this.currentCenterID);
trace("Loading from: "+this.baseURL+this.currentCenterID);
			request.method = URLRequestMethod.POST;
			try {
				this.httpLoader.load(request);
			} catch (e:Error) {
				  trace("Unable to load requested document.");
			}
		}
// --------------------------------------------------------------------------------
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
// --------------------------------------------------------------------------------
        private function completeHandler(event:Event):void {
trace("URLLoad Completed");
            var loader:URLLoader = URLLoader(event.target);
			var xmlDoc:XML = new XML(loader.data);
			
			// LOAD ALL NETWORK NODES
			for each (var person in xmlDoc.NetworkPeople.NetworkPerson) {
				var tempNode = new Object();
				// save data
				for each (var XMLAttrib:XML in person.attributes() ) {
					var attribName:String = XMLAttrib.name();
					tempNode[attribName] = XMLAttrib.toString();
					// VALUE RANGE CALCULATION / CACHE
					if (attribName != "fn" && attribName != "ln" && attribName != "id") {
						// conver to a number if numeric
						if (!isNaN(Number(tempNode[attribName]))) {
							var tempValue = Number(tempNode[attribName]);
						} else {
							var tempValue = tempNode[attribName];
						}
						// value range storage
						if (!this.nodeAttribRanges.hasOwnProperty(attribName)) {
							this.nodeAttribRanges[attribName] = new Object();
						}
						// min compare
						if (!this.nodeAttribRanges[attribName].hasOwnProperty('min')) {
							this.nodeAttribRanges[attribName].min = tempValue;
						} else {
							if (this.nodeAttribRanges[attribName].min > tempValue) {
								this.nodeAttribRanges[attribName].min = tempValue;
							}
						}
						// max compare
						if (!this.nodeAttribRanges[attribName].hasOwnProperty('max')) {
							this.nodeAttribRanges[attribName].max = tempValue;
						} else {
							if (this.nodeAttribRanges[attribName].max < tempValue) {
								this.nodeAttribRanges[attribName].max = tempValue;
							}
						}
					}
				}
				// validate required info
				if (tempNode.id && tempNode.fn && tempNode.ln) {					
					tempNode.display_name_short = tempNode.ln + " " + tempNode.fn.substr(0,1);
					tempNode.display_name_long = tempNode.fn + " " + tempNode.ln;
					this.networkNodes[tempNode.id] = tempNode;
				}
			}

			// LOAD ALL NETWORK EDGES
			for each (var edge in xmlDoc.NetworkCoAuthors.NetworkCoAuthor) {
				var tempEdge = new Object();
				// save data
				for each (var XMLAttrib:XML in edge.attributes() ) {
					var attribName:String = XMLAttrib.name();
					tempEdge[attribName] = XMLAttrib.toString();
					// VALUE RANGE CALCULATION / CACHE
					if (attribName != "id1" && attribName != "id2") {
						// conver to a number if numeric
						if (!isNaN(Number(tempEdge[attribName]))) {
							var tempValue = Number(tempEdge[attribName]);
						} else {
							var tempValue = tempEdge[attribName];
						}
						// value range storage
						if (!this.edgeAttribRanges.hasOwnProperty(attribName)) {
							this.edgeAttribRanges[attribName] = new Object();
						}
						// min compare
						if (!this.edgeAttribRanges[attribName].hasOwnProperty('min')) {
							this.edgeAttribRanges[attribName].min = tempValue;
						} else {
							if (this.edgeAttribRanges[attribName].min > tempValue) {
								this.edgeAttribRanges[attribName].min = tempValue;
							}
						}
						// max compare
						if (!this.edgeAttribRanges[attribName].hasOwnProperty('max')) {
							this.edgeAttribRanges[attribName].max = tempValue;
						} else {
							if (this.edgeAttribRanges[attribName].max < tempValue) {
								this.edgeAttribRanges[attribName].max = tempValue;
							}
						}
					}
				}
				// validate required info
				if (tempEdge.id1 && tempEdge.id2) {					
					tempEdge.hash = tempEdge.id1 + "-" + tempEdge.id2;
					this.networkEdges[tempEdge.hash] = tempEdge;
				}
			}
trace("XML Loaded");
			
			// SEND NOTIFICATION THAT THE DATA IS LOADED PROPERLY
			this.dispatchEvent(new Event("DATA_RETREIVED"));
        }
// --------------------------------------------------------------------------------
        private function openHandler(event:Event):void { trace("URLLoader OPEN"); }
        private function progressHandler(event:ProgressEvent):void {}
        private function httpStatusHandler(event:HTTPStatusEvent):void {}		
// -----------------------------------------------------------------------------------------------------------------------------------
        private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("URLLoader SECURITY ERROR");
			this.dispatchEvent(new Event("DATA_ERROR"));
        }
// -----------------------------------------------------------------------------------------------------------------------------------
        private function ioErrorHandler(event:IOErrorEvent):void {
			trace("URLLoader IO ERROR: "+event);
			this.dispatchEvent(new Event("DATA_ERROR"));
        }
		
// --------------------------------------------------------------------------------
	}
}
