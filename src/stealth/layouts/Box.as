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
		public function Box(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0)
		{
			_top = top;
			_right = right;
			_bottom = bottom;
			_left = left;
		}
		
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
		
		[Bindable(event="leftChange", style="noEvent")]
		public function get left():Number { return _left }
		public function set left(value:Number):void
		{
			DataChange.change(this, "left", _left, _left = value);
		}
		private var _left:Number;
		
		[Bindable(event="verticalChange", style="noEvent")]
		public function get vertical():Number { return _vertical }
		public function set vertical(value:Number):void
		{
			DataChange.change(this, "vertical", _vertical, _vertical = value);
		}
		private var _vertical:Number = 0;
		
		[Bindable(event="horizontalChange", style="noEvent")]
		public function get horizontal():Number { return _horizontal }
		public function set horizontal(value:Number):void
		{
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		private var _horizontal:Number = 0;
		
		public function merge(box:Box):Box
		{
			if (box) {
				left = _left >= box._left ? _left : box._left;
				top = _top >= box._top ? _top : box._top;
				right = _right >= box._right ? _right : box._right;
				bottom = _bottom >= box._bottom ? _bottom : box._bottom;
			}
			return this;
		}
		
		public function equals(box:Box):Boolean
		{
			return (_right == box._right && _top == box._top &&
					_bottom == box._bottom && _left == box._left &&
					_vertical == box._vertical && _horizontal == box._horizontal);
		}
		
		public function copy(box:Box = null):Box
		{
			if (!box) {
				box = new Box();
			}
			box.top = _top;
			box.right = _right;
			box.bottom = _bottom;
			box.left = _left;
			box.vertical = _vertical;
			box.horizontal = _horizontal;
			
			return box;
		}
		
		override public function toString():String
		{
			return '[Box(top="' + _top + ', right="' + _right + '", bottom="' + _bottom + '", left="' + _left + '")]'; 
		}
		
		public static function getInstance(value:*, box:Box = null):Box
		{
			if (!box) {
				box = new Box();
			}
			
			if (value is Number) {
				box.top = box.right = box.bottom = box.left = Number(value);
			} else if (value is String) {
				value = value.replace(/[,\s]+/g, " ");
				var values:Array = value.split(" ");
				switch (values.length) {
					case 1 :
						box.top = box.right = box.bottom = box.left = Number(values[0]);
						break;
					case 2 :
						box.top = box.bottom = Number(values[0]);
						box.right = box.left = Number(values[1]);
						break;
					case 3 :
						box.top = Number(values[0]);
						box.right = box.left = Number(values[1]);
						box.bottom = Number(values[2]);
						break;
					case 4 :
						box.top = Number(values[0]);
						box.right = Number(values[1]);
						box.bottom = Number(values[2]);
						box.left = Number(values[3]);
						break;
				}
			}
			return box;
		}
	}
}
