/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.paint
{
	import flash.display.GraphicsSolidFill;

	import flight.events.PropertyEvent;

	public class SolidFill extends Paint implements IFill
	{
		protected var solidFill:GraphicsSolidFill;
		
		public function SolidFill(color:uint = 0x000000, alpha:Number = 1)
		{
			_color = color;
			_alpha = alpha;
			paintData = solidFill = new GraphicsSolidFill(_color, _alpha);
		}
		
		[Bindable("propertyChange")]
		public function get color():uint { return _color; }
		public function set color(value:uint):void
		{
			solidFill.color = value;
			PropertyEvent.change(this, "color", _color, _color = value);
		}
		private var _color:uint;
		
		[Bindable("propertyChange")]
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			solidFill.alpha = value;
			PropertyEvent.change(this, "alpha", _alpha, _alpha = value);
		}
		private var _alpha:Number;
	}
}
