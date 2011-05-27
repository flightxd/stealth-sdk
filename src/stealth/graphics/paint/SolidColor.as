/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GraphicsSolidFill;
	import flash.display.IGraphicsFill;

	import flight.data.DataChange;

	public class SolidColor implements IFill
	{
		protected var solidFill:GraphicsSolidFill;
		
		public function SolidColor(color:uint = 0x000000, alpha:Number = 1)
		{
			_color = color;
			_alpha = alpha;
			solidFill = new GraphicsSolidFill(color, alpha);
		}
		
		[Bindable(event="colorChange", style="noEvent")]
		public function get color():uint { return _color; }
		public function set color(value:uint):void
		{
			solidFill.color = value;
			DataChange.change(this, "color", _color, _color = value);
		}
		private var _color:uint;
		
		[Bindable(event="alphaChange", style="noEvent")]
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			solidFill.alpha = value;
			DataChange.change(this, "alpha", _alpha, _alpha = value);
		}
		private var _alpha:Number;
		
		public function get graphicsFill():IGraphicsFill { return solidFill; }
	}
}
