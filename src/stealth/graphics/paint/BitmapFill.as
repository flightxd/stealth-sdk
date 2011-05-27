/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsFill;
	import flash.geom.Matrix;

	import flight.data.DataChange;

	public class BitmapFill implements IFill
	{
		protected var bitmapFill:GraphicsBitmapFill;
		
		public function BitmapFill()
		{
		}
		
		[Bindable(event="matrixChange", style="noEvent")]
		public function get matrix():Matrix { return _matrix; }
		public function set matrix(value:Matrix):void
		{
			DataChange.change(this, "matrix", _matrix, _matrix = value);
		}
		private var _matrix:Matrix;
		
		[Bindable(event="xChange", style="noEvent")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			DataChange.change(this, "x", _x, _x = value);
		}
		private var _x:Number;
		
		[Bindable(event="yChange", style="noEvent")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			DataChange.change(this, "y", _y, _y = value);
		}
		private var _y:Number;
		
		[Bindable(event="scaleXChange", style="noEvent")]
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void
		{
			DataChange.change(this, "scaleX", _scaleX, _scaleX = value);
		}
		private var _scaleX:Number;
		
		[Bindable(event="scaleYChange", style="noEvent")]
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void
		{
			DataChange.change(this, "scaleY", _scaleY, _scaleY = value);
		}
		private var _scaleY:Number;
		
		[Bindable(event="rotationChange", style="noEvent")]
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void
		{
			DataChange.change(this, "rotation", _rotation, _rotation = value);
		}
		private var _rotation:Number;
		
		[Bindable(event="sourceChange", style="noEvent")]
		public function get source():BitmapData { return _source; }
		public function set source(value:BitmapData):void
		{
			DataChange.change(this, "source", _source, _source = value);
		}
		private var _source:BitmapData;
		
		[Bindable(event="fillModeChange", style="noEvent")]
		public function get fillMode():String { return _fillMode; }
		public function set fillMode(value:String):void
		{
			DataChange.change(this, "fillMode", _fillMode, _fillMode = value);
		}
		private var _fillMode:String;
		
		public function get graphicsFill():IGraphicsFill { return bitmapFill; }
	}
}
