/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GradientType;
	import flash.display.GraphicsGradientFill;
	import flash.display.IGraphicsFill;
	import flash.geom.Matrix;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataChange;

	[DefaultProperty("entries")]
	public class Gradient implements IFill
	{
		public var gradientFill:GraphicsGradientFill;
		
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		
		public function Gradient()//(type:String, colors:Array, alphas:Array, ratios:Array)
									//matrix:Matrix = null, spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0)
		{
//			this.colors = colors;
//			this.alphas = alphas;
//			this.ratios = ratios;
//			_matrix = matrix;
//			_spreadMethod = spreadMethod;
//			_interpolationMethod = interpolationMethod;
//			_focalPointRatio = focalPointRatio;
			gradientFill = new GraphicsGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [1, 1], [0, 255]);
		}
		
		public function get graphicsFill():IGraphicsFill { return gradientFill; }
		
		[Bindable(event="typeChange", style="noEvent")]
		public function get type():String { return _type; }
		public function set type(value:String):void
		{
			DataChange.change(this, "type", _type, _type = value);
		}
		private var _type:String;
		
[ArrayElementType("flight.graphics.paint.GradientEntry")]
[Inspectable(category="General", arrayType="flight.graphics.paint.GradientEntry")]
		[Bindable(event="entriesChange", style="noEvent")]
		public function get entries():IList { return _entries; }
		public function set entries(value:*):void
		{
			_entries.queueChanges = true;
			_entries.removeAt();
			if (value is IList) {
				_entries.add( IList(value).get() );
			} else if (value is Array) {
				_entries.add(value);
			} else if (value === null) {
				_entries.removeAt();						// TODO: remove duplicate removeAt
			} else {
				_entries.add(value);
			}
			
			var colors:Array = [];
			var alphas:Array = [];
			var ratios:Array = [];
			for each (var entry:GradientEntry in _entries) {
				colors.push(entry.color);
				alphas.push(entry.alpha);
				ratios.push(entry.ratio);
			}
			
			gradientFill.colors = colors;
			gradientFill.alphas = alphas;
			gradientFill.ratios = ratios;
			trace(colors, alphas, ratios);
			var m:Matrix = new Matrix();
			m.createGradientBox(250, 250);
			trace(m);
			gradientFill.matrix = m;
			
			_entries.queueChanges = false;					// TODO: determine if List change AND propertychange should both fire
			DataChange.change(this, "entries", _entries, _entries, true);
		}
		private var _entries:ArrayList = new ArrayList();
		
		
		[Bindable(event="spreadMethodChange", style="noEvent")]
		public function get spreadMethod():String { return _spreadMethod; }
		public function set spreadMethod(value:String):void
		{
			gradientFill.spreadMethod = value;
			DataChange.change(this, "spreadMethod", _spreadMethod, _spreadMethod = value);
		}
		private var _spreadMethod:String;
		
		[Bindable(event="interpolationMethodChange", style="noEvent")]
		public function get interpolationMethod():String { return _interpolationMethod; }
		public function set interpolationMethod(value:String):void
		{
			gradientFill.interpolationMethod = value;
			DataChange.change(this, "interpolationMethod", _interpolationMethod, _interpolationMethod = value);
		}
		private var _interpolationMethod:String;
		
		[Bindable(event="focalPointRatioChange", style="noEvent")]
		public function get focalPointRatio():Number { return _focalPointRatio; }
		public function set focalPointRatio(value:Number):void
		{
			gradientFill.focalPointRatio = value;
			DataChange.change(this, "focalPointRatio", _focalPointRatio, _focalPointRatio = value);
		}
		private var _focalPointRatio:Number;
		
		
		
		
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
		
		[Bindable(event="matrixChange", style="noEvent")]
		public function get matrix():Matrix { return _matrix; }
		public function set matrix(value:Matrix):void
		{
			gradientFill.matrix = value;
			DataChange.change(this, "matrix", _matrix, _matrix = value);
		}
		private var _matrix:Matrix;
	}
}
