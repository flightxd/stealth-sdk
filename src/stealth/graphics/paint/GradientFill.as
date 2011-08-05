/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataChange;
	import flight.events.ListEvent;
	import flight.geom.MatrixData;

	[DefaultProperty("entries")]
	public class GradientFill extends Paint implements IFill
	{
		protected static const GRADIENT_DIMENSION:Number = 1638.4;
		
		protected var gradientFill:GraphicsGradientFill;
		
		public function GradientFill(type:String = GradientType.LINEAR, entries:* = null, rotation:Number = 0)
		{
			_type = type;
			_entries = new ArrayList();
			_entries.addEventListener(ListEvent.LIST_CHANGE, updateEntries);
			_entries.addEventListener(ListEvent.ITEM_CHANGE, updateEntries);
			this.rotation = rotation;
			
			// set default fill colors
			paintData = gradientFill = new GraphicsGradientFill(type, [0x000000, 0xFFFFFF], [1, 1], [0, 255], paintMatrix);
			if (entries) {
				this.entries = entries;
			}
		}
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="linear,radial")]
		public function get type():String { return _type; }
		public function set type(value:String):void
		{
			gradientFill.type = value;
			DataChange.change(this, "type", _type, _type = value);
		}
		private var _type:String;
		
		[ArrayElementType("stealth.graphics.paint.GradientEntry")]
		[Bindable("propertyChange")]
		public function get entries():IList { return _entries; }
		public function set entries(value:*):void
		{
			ArrayList.getInstance(value, _entries);
		}
		private var _entries:ArrayList;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="pad,reflect,repeat")]
		public function get spreadMethod():String { return _spreadMethod; }
		public function set spreadMethod(value:String):void
		{
			gradientFill.spreadMethod = value;
			DataChange.change(this, "spreadMethod", _spreadMethod, _spreadMethod = value);
		}
		private var _spreadMethod:String = SpreadMethod.PAD;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="rgb,linear")]
		public function get interpolationMethod():String { return _interpolationMethod; }
		public function set interpolationMethod(value:String):void
		{
			gradientFill.interpolationMethod = value;
			DataChange.change(this, "interpolationMethod", _interpolationMethod, _interpolationMethod = value);
		}
		private var _interpolationMethod:String = InterpolationMethod.RGB;
		
		[Bindable("propertyChange")]
		public function get focalPointRatio():Number { return _focalPointRatio; }
		public function set focalPointRatio(value:Number):void
		{
			gradientFill.focalPointRatio = value;
			DataChange.change(this, "focalPointRatio", _focalPointRatio, _focalPointRatio = value);
		}
		private var _focalPointRatio:Number = 0;
		
		[Bindable("propertyChange")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			_matrix.x = isNaN(value) ? 0 : value;
			DataChange.change(this, "x", _x, _x = value);
		}
		private var _x:Number;
		
		[Bindable("propertyChange")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			_matrix.y = isNaN(value) ? 0 : value;
			DataChange.change(this, "y", _y, _y = value);
		}
		private var _y:Number;
		
		[Bindable("propertyChange")]
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void
		{
			if (isNaN(value)) {
				value = 1;
			}
			_matrix.scaleX = value;
			DataChange.change(this, "scaleX", _scaleX, _scaleX = value);
		}
		private var _scaleX:Number = 1;
		
		[Bindable("propertyChange")]
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void
		{
			if (isNaN(value)) {
				value = 1;
			}
			_matrix.scaleY = value;
			DataChange.change(this, "scaleY", _scaleY, _scaleY = value);
		}
		private var _scaleY:Number = 1;
		
		[Bindable("propertyChange")]
		public function get rotation():Number { return _rotation; }
		public function set rotation(value:Number):void
		{
			if (isNaN(value)) {
				value = 0;
			}
			_matrix.rotation = value * (Math.PI/180);
			DataChange.change(this, "rotation", _rotation, _rotation = value);
		}
		private var _rotation:Number = 0;
		
		[Bindable("propertyChange")]
		public function get matrix():Matrix { return _matrix; }
		public function set matrix(value:Matrix):void
		{
			DataChange.queue(this, "matrix", _matrix.matrix, _matrix.matrix = value);
			if (value) {
				DataChange.queue(this, "x", _x, _x = _matrix.x);
				DataChange.queue(this, "y", _y, _y = _matrix.y);
				DataChange.queue(this, "scaleX", _scaleX, _scaleX = _matrix.scaleX);
				DataChange.queue(this, "scaleY", _scaleY, _scaleY = _matrix.scaleY);
				DataChange.change(this, "rotation", _rotation, _rotation = _matrix.rotation * (180/Math.PI));
			} else {
				_matrix.rotation = _rotation * (Math.PI/180);
				_matrix.scaleX = _scaleX;
				_matrix.scaleY = _scaleY;
				_matrix.x = isNaN(_x) ? 0 : _x;
				_matrix.y = isNaN(_y) ? 0 : _y;
			}
		}
		private var _matrix:MatrixData = new MatrixData();
		
		private function updateEntries(event:ListEvent):void
		{
			gradientFill.colors.length = 0;
			gradientFill.alphas.length = 0;
			gradientFill.ratios.length = 0;
			
			var ratios:Array = gradientFill.ratios;
			ratios.nan = 0;
			ratios.base = 0;
			for each (var entry:GradientEntry in _entries) {
				gradientFill.colors.push(entry.color);
				gradientFill.alphas.push(entry.alpha);
				addRatio(entry.ratio * 0xFF, ratios);
			}
			if (ratios.nan > 0) {
				--ratios.nan;
				addRatio(0xFF, ratios);
			}
			DataChange.change(this, "entries", _entries, _entries, true);
		}
		
		private function addRatio(ratio:Number, ratios:Array):void
		{
			if (isNaN(ratio)) {
				++ratios.nan;
			} else {
				if (ratios.nan > 0) {
					var space:Number = (ratio - ratios.base) / (ratios.nan);
					for (var i:int = 0; i < ratios.nan; i++) {
						ratios.push(Math.round(space * i));
					}
				}
				ratios.push(ratio);
				ratios.base = ratio;
			}
		}
		
		override public function update(graphicsPath:GraphicsPath, pathBounds:Rectangle, transform:Matrix = null):void
		{
			_matrix.x = isNaN(_x) ? pathBounds.x + pathBounds.width/2 : _x;
			_matrix.y = isNaN(_y) ? pathBounds.y + pathBounds.height/2 : _y;
			scaleMatrix.a = (pathBounds.width / GRADIENT_DIMENSION);
			scaleMatrix.d = (pathBounds.height / GRADIENT_DIMENSION);
		}
		private var scaleMatrix:Matrix = new Matrix();
		
		override public function paint(graphicsData:Vector.<IGraphicsData>):void
		{
			var m:Matrix = _matrix.matrix;
			paintMatrix.a = m.a;
			paintMatrix.b = m.b;
			paintMatrix.c = m.c;
			paintMatrix.d = m.d;
			paintMatrix.concat(scaleMatrix);
			paintMatrix.tx = m.tx;
			paintMatrix.ty = m.ty;
			super.paint(graphicsData);
		}
		private var paintMatrix:Matrix = new Matrix();
	}
}
