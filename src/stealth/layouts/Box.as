/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.events.EventDispatcher;

	import flight.data.DataChange;

	public class Box extends EventDispatcher
	{
		[Bindable(event="leftChange", style="noEvent")]
		public function get left():Number { return _left }
		public function set left(value:Number):void
		{
			DataChange.change(this, "left", _left, _left = value);
		}
		private var _left:Number;
		
		[Bindable(event="topChange", style="noEvent")]
		public function get top():Number { return _top }
		public function set top(value:Number):void
		{
			DataChange.change(this, "top", _top, _top = value);
		}
		private var _top:Number;
		
		[Bindable(event="rightChange", style="noEvent")]
		public function get right():Number { return _right }
		public function set right(value:Number):void
		{
			DataChange.change(this, "right", _right, _right = value);
		}
		private var _right:Number;
		
		[Bindable(event="bottomChange", style="noEvent")]
		public function get bottom():Number { return _bottom }
		public function set bottom(value:Number):void
		{
			DataChange.change(this, "bottom", _bottom, _bottom = value);
		}
		private var _bottom:Number;
		
		[Bindable(event="horizontalChange", style="noEvent")]
		public function get horizontal():Number { return _horizontal }
		public function set horizontal(value:Number):void
		{
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		private var _horizontal:Number;
		
		[Bindable(event="verticalChange", style="noEvent")]
		public function get vertical():Number { return _vertical }
		public function set vertical(value:Number):void
		{
			DataChange.change(this, "vertical", _vertical, _vertical = value);
		}
		private var _vertical:Number;
		
		public function Box(left:Number = 0, top:Number = 0, right:Number = 0, bottom:Number = 0)
		{
			_left = left;
			_top = top;
			_right = right;
			_bottom = bottom;
		}
		
		public function merge(box:Box):Box
		{
			if (box) {
				DataChange.queue(this, "left", _left, _left = _left >= box._left ? _left : box._left);
				DataChange.queue(this, "top", _top, _top = _top >= box._top ? _top : box._top);
				DataChange.queue(this, "right", _right, _right = _right >= box._right ? _right : box._right);
				DataChange.change(this, "bottom", _bottom, _bottom = _bottom >= box._bottom ? _bottom : box._bottom);
			}
			return box;
		}
		
		public function equals(box:Box):Boolean
		{
			if (box) {
				return (_left == box._left && _right == box._right &&
						_top == box._top && _bottom == box._bottom &&
						_horizontal == box._horizontal && _vertical == box._vertical);
			}
			return false;
		}
		
		public function clone(box:Box = null):Box
		{
			if (!box) {
				box = new Box();
			}
			box._left = _left;
			box._top = _top;
			box._right = _right;
			box._bottom = _bottom;
			box._horizontal = _horizontal;
			box._vertical = _vertical;
			
			return box;
		}
		
		override public function toString():String
		{
			return '[Box(left="' + _left + '", top="' + _top + ', right="' + _right + '", bottom="' + _bottom + '")]'; 
		}
		
		public static function fromString(value:String, box:Box = null):Box
		{
			if (!box) {
				box = new Box();
			}
			
			if (value) {
				var values:Array = value.split(" ");
				switch (values.length) {
					case 1 :
						box._left = box._top = box._right = box._bottom = parseFloat( values[0] );
						break;
					case 2 :
						box._left = box._right = parseFloat( values[1] );
						box._top = box._bottom = parseFloat( values[0] );
						break;
					case 3 :
						box._left = box._right = parseFloat( values[1] );
						box._top = parseFloat( values[0] );
						box._bottom = parseFloat( values[2] );
						break;
					case 4 :
						box._left = parseFloat( values[3] );
						box._top = parseFloat( values[0] );
						box._right = parseFloat( values[1] );
						box._bottom = parseFloat( values[2] );
						break;
				}
			}
			return box;
		}
	}
}
