/*  
 
Copyright (c) 2008-2012 by the President and Fellows of Harvard College. All rights reserved.  
Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD.,
and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the 
National Center for Research Resources and Harvard University.

	Original Author : Nick Benik

Code licensed under a BSD License. 
For details, see: LICENSE.txt 

*/

package edu.harvard.weberlab {
	
	public class ValueWindow {
		public var OutRangeMin:Number; 
		public var OutRangeMax:Number; 
		public var FunctionType:uint;
		public var InRangeMin:Number;
		public var InRangeMax:Number;
		public var ReverseOutput:Boolean;
		public var misc1:*;
		public var misc2:*;
		public var misc3:*;
		
		public static const WINDOW_FUNC_RATIO:uint    		= 1;
		public static const WINDOW_FUNC_RATIO_INVERT:uint 	= 2;
		public static const WINDOW_FUNC_EXP:uint    		= 3;
		public static const WINDOW_FUNC_EXP_INVERT:uint    	= 4;
		public static const WINDOW_FUNC_LOG:uint    		= 5;
		public static const WINDOW_FUNC_LOG_INVERT:uint    	= 6;
		

		public function ValueWindow(outputMin:Number, outputMax:Number, inputMin:Number, inputMax:Number, FuncType:uint, outputReversed:Boolean) {
			this.OutRangeMin = outputMin; 
			this.OutRangeMax = outputMax; 
			this.InRangeMin = inputMin;
			this.InRangeMax = inputMax;
			this.FunctionType = FuncType;
			this.ReverseOutput = outputReversed;
		}
		
		public function calculate(inValue):Number {
			// calculate the input position as % of range
			var rangedInput:Number =  (inValue - this.InRangeMin) / (this.InRangeMax - this.InRangeMin);
			if (rangedInput < 0 || rangedInput > 1) {
				// out of range error
				throw new RangeError("Input value is outside of the previously defined input value window.");
				return 0;
			}
			// handle reversing output
			if (this.ReverseOutput) { rangedInput = (1 - rangedInput); }
			var outRangeSize = (this.OutRangeMax - this.OutRangeMin);
			// main calculations
			switch(this.FunctionType) {
				case WINDOW_FUNC_RATIO:
					return ((outRangeSize * rangedInput) + this.OutRangeMin);
					break;
				case WINDOW_FUNC_RATIO_INVERT:
					return (this.OutRangeMax - (outRangeSize * rangedInput));
					break;
				case WINDOW_FUNC_EXP:
					return ((outRangeSize * ((rangedInput * 10)^2)) + this.OutRangeMin);
					break;
				case WINDOW_FUNC_EXP_INVERT:
					return (this.OutRangeMax - (outRangeSize * ((rangedInput * 10)^2)));
					break;
				case WINDOW_FUNC_LOG:
					var funcWindowMin = (1/Math.log(2));
					var funcWindowMax = (1/Math.log(12));
					var t = (1/Math.log((rangedInput * 10) + 2)) - funcWindowMin;
					var tRanged = t / (funcWindowMax - funcWindowMin);
					return (outRangeSize * tRanged) + OutRangeMin;
					break;
				case WINDOW_FUNC_LOG_INVERT:
					var funcWindowMin = (1/Math.log(2));
					var funcWindowMax = (1/Math.log(12));
					var t = (1/Math.log((rangedInput * 10) + 2)) - funcWindowMin;
					var tRanged = t / (funcWindowMax - funcWindowMin);
					return outRangeSize - (outRangeSize * tRanged);
					break;
			}
			return -1;
		}
	}
}