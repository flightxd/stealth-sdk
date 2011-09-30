/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.CapsStyle;
	import flash.display.GraphicsStroke;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	import flight.data.DataChange;

	public class BitmapStroke extends BitmapFill implements IStroke
	{
		protected var stroke:GraphicsStroke;
		
		public function BitmapStroke(weight:Number = 1, source:* = null, fillMode:String = BitmapFillMode.SCALE, pixelHinting:Boolean = false)
		{
			_weight = weight;
			_pixelHinting = pixelHinting;
			super(source, fillMode);
			paintData = stroke = new GraphicsStroke(_weight, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit, bitmapFill);
		}
		
		[Bindable("propertyChange")]
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void
		{
			stroke.thickness = value;
			DataChange.change(this, "weight", _weight, _weight = value);
		}
		private var _weight:Number;
		
		[Bindable("propertyChange")]
		public function get pixelHinting():Boolean { return _pixelHinting; }
		public function set pixelHinting(value:Boolean):void
		{
			stroke.pixelHinting = value;
			DataChange.change(this, "pixelHinting", _pixelHinting, _pixelHinting = value);
		}
		private var _pixelHinting:Boolean = false;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="normal,horizontal,vertical,none")]
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value:String):void
		{
			stroke.scaleMode = value;
			DataChange.change(this, "scaleMode", _scaleMode, _scaleMode = value);
		}
		private var _scaleMode:String = LineScaleMode.NORMAL;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="round,square,none")]
		public function get caps():String { return _caps; }
		public function set caps(value:String):void
		{
			stroke.caps = value;
			DataChange.change(this, "caps", _caps, _caps = value);
		}
		private var _caps:String = CapsStyle.ROUND;
		
		[Bindable("propertyChange")]
		[Inspectable(enumeration="round,bevel,miter")]
		public function get joints():String { return _joints; }
		public function set joints(value:String):void
		{
			stroke.joints = value;
			DataChange.change(this, "joints", _joints, _joints = value);
		}
		private var _joints:String = JointStyle.ROUND;
		
		[Bindable("propertyChange")]
		public function get miterLimit():Number { return _miterLimit; }
		public function set miterLimit(value:Number):void
		{
			stroke.miterLimit = value;
			DataChange.change(this, "miterLimit", _miterLimit, _miterLimit = value);
		}
		private var _miterLimit:Number = 3;
	}
}
