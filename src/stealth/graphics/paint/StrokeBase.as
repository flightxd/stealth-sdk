/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsStroke;

	import flight.data.DataChange;

	public class StrokeBase implements IStroke
	{
		protected var stroke:GraphicsStroke;
		
		public function StrokeBase(thickness:Number, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3)
		{
			_weight = thickness;
			_pixelHinting = pixelHinting
			_scaleMode = scaleMode;
			_caps = caps;
			_joints = joints;
			_miterLimit = miterLimit;
			stroke = new GraphicsStroke(thickness, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
		[Bindable(event="weightChange", style="noEvent")]
		public function get weight():Number { return _weight; }
		public function set weight(value:Number):void
		{
			stroke.thickness = value;
			DataChange.change(this, "weight", _weight, _weight = value);
		}
		private var _weight:Number;
		
		[Bindable(event="pixelHintingChange", style="noEvent")]
		public function get pixelHinting():Boolean { return _pixelHinting; }
		public function set pixelHinting(value:Boolean):void
		{
			stroke.pixelHinting = value;
			DataChange.change(this, "pixelHinting", _pixelHinting, _pixelHinting = value);
		}
		private var _pixelHinting:Boolean;
		
		[Bindable(event="scaleModeChange", style="noEvent")]
		public function get scaleMode():String { return _scaleMode; }
		public function set scaleMode(value:String):void
		{
			stroke.scaleMode = value;
			DataChange.change(this, "scaleMode", _scaleMode, _scaleMode = value);
		}
		private var _scaleMode:String;
		
		[Bindable(event="capesChange", style="noEvent")]
		public function get caps():String { return _caps; }
		public function set caps(value:String):void
		{
			stroke.caps = value;
			DataChange.change(this, "caps", _caps, _caps = value);
		}
		private var _caps:String;
		
		[Bindable(event="jointsChange", style="noEvent")]
		public function get joints():String { return _joints; }
		public function set joints(value:String):void
		{
			stroke.joints = value;
			DataChange.change(this, "joints", _joints, _joints = value);
		}
		private var _joints:String;
		
		[Bindable(event="miterLimitChange", style="noEvent")]
		public function get miterLimit():Number { return _miterLimit; }
		public function set miterLimit(value:Number):void
		{
			stroke.miterLimit = value;
			DataChange.change(this, "miterLimit", _miterLimit, _miterLimit = value);
		}
		private var _miterLimit:Number;
		
		public function get graphicsStroke():IGraphicsStroke
		{
			return stroke;
		}
	}
}
