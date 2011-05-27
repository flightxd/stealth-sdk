/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flight.data.DataChange;

	public class Line
	{
		public function Line()
		{
		}
		
		[Bindable(event="xFromChange", style="noEvent")]
		public function get xFrom():Number { return _xFrom; }
		public function set xFrom(value:Number):void
		{
			DataChange.change(this, "xFrom", _xFrom, _xFrom = value);
		}
		private var _xFrom:Number = 0;
		
		[Bindable(event="yFromChange", style="noEvent")]
		public function get yFrom():Number { return _yFrom; }
		public function set yFrom(value:Number):void
		{
			DataChange.change(this, "yFrom", _yFrom, _yFrom = value);
		}
		private var _yFrom:Number = 0;
		
		[Bindable(event="xToChange", style="noEvent")]
		public function get xTo():Number { return _xTo; }
		public function set xTo(value:Number):void
		{
			DataChange.change(this, "xTo", _xTo, _xTo = value);
		}
		private var _xTo:Number = 0;
		
		[Bindable(event="yToChange", style="noEvent")]
		public function get yTo():Number { return _yTo; }
		public function set yTo(value:Number):void
		{
			DataChange.change(this, "yTo", _yTo, _yTo = value);
		}
		private var _yTo:Number = 0;
	}
}
