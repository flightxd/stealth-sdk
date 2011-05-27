/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GraphicsGradientFill;
	import flash.display.IGraphicsFill;
	import flash.geom.Matrix;

	import flight.collections.IList;
	import flight.data.DataChange;

	[DefaultProperty("entries")]
	public class LinearGradient implements IFill
	{
		protected var gradientFill:GraphicsGradientFill;
		
		public function LinearGradient()
		{
		}
		
		[Bindable(event="matrixChange", style="noEvent")]
		public function get matrix():Matrix { return _matrix; }
		public function set matrix(value:Matrix):void
		{
			DataChange.change(this, "matrix", _matrix, _matrix = value);
		}
		private var _matrix:Matrix;
		
		[Bindable(event="entriesChange", style="noEvent")]
		public function get entries():IList { return _entries; }
		public function set entries(value:IList):void
		{
			DataChange.change(this, "entries", _entries, _entries = value);
		}
		private var _entries:IList;
		
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
		
		[Bindable(event="rotationChange", style="noEvent")]
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void
		{
			DataChange.change(this, "rotation", _rotation, _rotation = value);
		}
		private var _rotation:Number;
		
		[Bindable(event="spreadMethodChange", style="noEvent")]
		public function get spreadMethod():String { return _spreadMethod; }
		public function set spreadMethod(value:String):void
		{
			DataChange.change(this, "spreadMethod", _spreadMethod, _spreadMethod = value);
		}
		private var _spreadMethod:String;
		
		[Bindable(event="interpolationMethodChange", style="noEvent")]
		public function get interpolationMethod():String { return _interpolationMethod; }
		public function set interpolationMethod(value:String):void
		{
			DataChange.change(this, "interpolationMethod", _interpolationMethod, _interpolationMethod = value);
		}
		private var _interpolationMethod:String;
		
		public function get graphicsFill():IGraphicsFill { return gradientFill; }
	}
}
