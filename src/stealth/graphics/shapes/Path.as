/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.shapes
{
	import stealth.graphics.GraphicShape;

	public class Path extends GraphicShape
	{
		public var data:*;
		
		public function Path()
		{
		}
		/*
		[Bindable(event="dataChange", style="noEvent")]
		public function get data():Object { return _data }
		public function set data(value:Object):void
		{
			DataChange.change(this, "data", _data, _data = value);
		}
		private var _data:Object;
		

		public static function fromString(value:String):Array
		{
			return null;
		}
		
		private var currentX:Number = 0;
		private var currentY:Number = 0;
		private var previousX:Number = 0;
		private var previousY:Number = 0;
		
		private var _data:ArrayList;
		
		public function Path()
		{
		}
		
		[ElementType("flight.drawing.shapes.commands.CommandElement")]
		[Bindable(event="dataChange")]
		public function get data():ArrayList
		{
			if (_data == null)
				_data = new ArrayList(new Vector.<CommandElement>);
			return _data;
		}
		public function set data(value:*):void
		{
			if (_data == value)
				return;
			
			if (value is String)
				value = fromString(value);
			
			PropertyEvent.dispatchChange(this, "data", _data, _data = value as ArrayList);
		}
		
		public function moveTo(x:Number, y:Number, relative:Boolean = false):void
		{
			if (relative)
			{
				x += currentX;
				y += currentY;
			}
			previousX = currentX;
			previousY = currentY;
			data.addItem(new MoveTo(currentX = x, currentY = y));
		}
		
		public function closePath():void
		{
			data.addItem(new ClosePath());
		}
		
		public function lineTo(x:Number, y:Number, relative:Boolean = false):void
		{
			if (relative)
			{
				x += currentX;
				y += currentY;
			}
			previousX = currentX;
			previousY = currentY;
			data.addItem(new LineTo(currentX = x, currentY = y));
		}
		
		public function curveTo(x1:Number, y1:Number, x2:Number, y2:Number, x:Number, y:Number, relative:Boolean = false):void
		{
			if (relative)
			{
				x1 += currentX;
				y1 += currentY;
				x2 += currentX;
				y2 += currentY;
				x += currentX;
				y += currentY;
			}
			previousX = x2;
			previousY = y2;
			data.addItem(new CurveTo(x1, y1, x2, y2, currentX = x, currentY = y));
		}
		
		public function curveToShort(x2:Number, y2:Number, x:Number, y:Number, relative:Boolean = false):void
		{
			var x1:Number = previousX;
			var y1:Number = previousY;
			if (relative)
			{
				x2 += currentX;
				y2 += currentY;
				x += currentX;
				y += currentY;
			}
			curveTo(x1, y1, x2, y2, x, y);
		}
		
		public function quadradicCurveTo(x1:Number, y1:Number, x:Number, y:Number, relative:Boolean = false):void
		{
			if (relative)
			{
				x1 += currentX;
				y1 += currentY;
				x += currentX;
				y += currentY;
			}
			previousX = x1;
			previousY = y1;
			data.addItem(new QuadradicCurveTo(x1, y1, currentX = x, currentY = y));
		}
		
		public function quadradicCurveToShort(x:Number, y:Number, relative:Boolean = false):void
		{
			var x1:Number = previousX;
			var y1:Number = previousY;
			if (relative)
			{
				x += currentX;
				y += currentY;
			}
			quadradicCurveTo(x1, y1, x, y);
		}
		
		public function arcTo(rx:Number, ry:Number, rotation:Number, largeArc:Boolean,
							  sweep:Boolean, x:Number, y:Number, relative:Boolean = false):void
		{
			if (relative)
			{
				x += currentX;
				y += currentY;
			}
			previousX = currentX;
			previousY = currentY;
			data.addItem(new ArcTo(rx, ry, rotation, largeArc, sweep, currentX = x, currentY = y));
		}
		
		override protected function updatePath(width:Number, height:Number):void
		{
		}
		*/		
	}
}
