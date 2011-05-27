/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flight.data.DataChange;

	public class GradientEntry
	{
		public function GradientEntry(color:Number = 0x000000, alpha:Number = 1, ratio:Number = NaN)
		{
			_color = color;
			_alpha = alpha;
			_ratio = ratio;
		}
		
		[Bindable(event="colorChange", style="noEvent")]
		public function get color():Number { return _color; }
		public function set color(value:Number):void
		{
			DataChange.change(this, "color", _color, _color = value);
		}
		private var _color:Number;
		
		[Bindable(event="alphaChange", style="noEvent")]
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			DataChange.change(this, "alpha", _alpha, _alpha = value);
		}
		private var _alpha:Number;
		
		[Bindable(event="ratioChange", style="noEvent")]
		public function get ratio():Number { return _ratio; }
		public function set ratio(value:Number):void
		{
			DataChange.change(this, "ratio", _ratio, _ratio = value);
		}
		private var _ratio:Number;
	}
}
