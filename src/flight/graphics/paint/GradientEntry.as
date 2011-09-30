/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.events.EventDispatcher;

	import flight.data.DataChange;

	public class GradientEntry extends EventDispatcher 
	{
		public function GradientEntry(color:Number = 0x000000, alpha:Number = 1, ratio:Number = NaN)
		{
			_color = color;
			_alpha = alpha;
			_ratio = ratio;
		}
		
		[Bindable("propertyChange")]
		public function get color():Number { return _color; }
		public function set color(value:Number):void
		{
			DataChange.change(this, "color", _color, _color = value);
		}
		private var _color:Number;
		
		[Bindable("propertyChange")]
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			if (isNaN(value)) {
				value = 1;
			}
			DataChange.change(this, "alpha", _alpha, _alpha = value);
		}
		private var _alpha:Number;
		
		[Bindable("propertyChange")]
		public function get ratio():Number { return _ratio; }
		public function set ratio(value:Number):void
		{
			DataChange.change(this, "ratio", _ratio, _ratio = value);
		}
		private var _ratio:Number;
	}
}
