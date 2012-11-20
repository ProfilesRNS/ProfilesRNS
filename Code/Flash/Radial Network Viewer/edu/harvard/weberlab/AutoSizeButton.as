// Taken from http://webroo.org/2009/04/19/auto-size-button-for-flash-components/
// Original Author: Matt Sweetman(?)

package edu.harvard.weberlab {
	
	import fl.controls.Button;
	import fl.core.InvalidationType;	
	import flash.text.TextFieldAutoSize;
	import flash.events.*;
	
// -----------------------------------------------------------------------------------------------------------------------------------
	public class AutoSizeButton extends Button implements IEventDispatcher {
		public function AutoSizeButton() {
			super();
		}
	
		protected var _autoSize:Boolean = true;
// -----------------------------------------------------------------------------------------------------------------------------------
		/**
		 * Whether auto sizing is turned on. Default is true.
		 */
		public function get autoSize():Boolean {
			return _autoSize;
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function set autoSize(value:Boolean):void {
			_autoSize = value;
			textField.autoSize = _autoSize ? TextFieldAutoSize.LEFT : TextFieldAutoSize.NONE;
			invalidate(InvalidationType.SIZE);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		override protected function drawLayout():void {
			if (autoSize) {
				// Set the component width by
				// calculating text & padding widths
				var txtPad:Number = Number(getStyleValue("textPadding"));
//				_width = (textField.textWidth + 4) + (2 * txtPad);
				_width = getAutoWidth();
			}
			super.drawLayout();
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		// Additional code via blog comment by jcfrog
		// contributor's address http://jeromechoain.wordpress.com/
		public function getAutoWidth(){
			// text & padding widths
			var txtPad:Number = Number(getStyleValue("textPadding"));
			return (textField.textWidth + 4) + (2 * txtPad);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
		public function addEventHandler(eventName, callback:Function):void {
//			super.addEventHandler(eventName, callback);
		}
// -----------------------------------------------------------------------------------------------------------------------------------
	}
}
