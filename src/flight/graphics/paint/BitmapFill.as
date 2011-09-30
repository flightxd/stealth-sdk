/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.BitmapData;
	import flash.display.GraphicsBitmapFill;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;

	import flight.data.DataChange;
	import flight.display.BitmapSource;
	import flight.geom.MatrixData;

	[DefaultProperty("source")]
	public class BitmapFill extends Paint implements IFill
	{
		protected var bitmapFill:GraphicsBitmapFill;
		
		public function BitmapFill(source:* = null, fillMode:String = BitmapFillMode.SCALE)
		{
			_fillMode = fillMode;
			paintData = bitmapFill = new GraphicsBitmapFill(null, null, _fillMode == BitmapFillMode.REPEAT);
			this.source = source;
		}
		
		// TODO: implement matrix transformation of Bitmap
		// TODO: implement 'clip' fillMode
		
		[Bindable("propertyChange")]
		public function get source():BitmapData { return _source; }
		public function set source(value:*):void
		{
			DataChange.change(this, "source", _source, bitmapFill.bitmapData = _source = BitmapSource.getInstance(value));
		}
		private var _source:BitmapData;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="scale,repeat")]
		public function get fillMode():String { return _fillMode; }
		public function set fillMode(value:String):void
		{
			bitmapFill.repeat = value == BitmapFillMode.REPEAT;
			DataChange.change(this, "fillMode", _fillMode, _fillMode = value);
		}
		private var _fillMode:String;
		
		[Bindable("propertyChange")]
		public function get smooth():Boolean { return _smooth; }
		public function set smooth(value:Boolean):void
		{
			bitmapFill.smooth = value;
			DataChange.change(this, "smooth", _smooth, _smooth = value);
		}
		private var _smooth:Boolean = false;
		
		[Bindable("propertyChange")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			DataChange.change(this, "x", _x, _x = value);
		}
		private var _x:Number;
		
		[Bindable("propertyChange")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			DataChange.change(this, "y", _y, _y = value);
		}
		private var _y:Number;
		
		[Bindable("propertyChange")]
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void
		{
			DataChange.change(this, "scaleX", _scaleX, _scaleX = value);
		}
		private var _scaleX:Number;
		
		[Bindable("propertyChange")]
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void
		{
			DataChange.change(this, "scaleY", _scaleY, _scaleY = value);
		}
		private var _scaleY:Number;
		
		[Bindable("propertyChange")]
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void
		{
			DataChange.change(this, "rotation", _rotation, _rotation = value);
		}
		private var _rotation:Number;
		
		[Bindable("propertyChange")]
		public function get transformX():Number { return _transformX; }
		public function set transformX(value:Number):void
		{
			DataChange.change(this, "transformX", _transformX, _transformX = value);
		}
		private var _transformX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get transformY():Number { return _transformY; }
		public function set transformY(value:Number):void
		{
			DataChange.change(this, "transformY", _transformY, _transformY = value);
		}
		private var _transformY:Number = 0;
		
		[Bindable("propertyChange")]
		public function get matrix():Matrix { return _matrix; }
		public function set matrix(value:Matrix):void
		{
			DataChange.change(this, "matrix", _matrix, _matrix = value);
		}
		private var _matrix:Matrix = new MatrixData();
		
		override public function paint(graphicsData:Vector.<IGraphicsData>):void
		{
			if (_source) {
				super.paint(graphicsData);
			}
		}
	}
}
