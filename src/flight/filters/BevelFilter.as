/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.filters
{
	import flash.events.EventDispatcher;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterType;

	import flight.data.DataChange;

	public class BevelFilter extends EventDispatcher implements IBitmapFilter
	{
		public function BevelFilter(distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 16777215, highlightAlpha:Number = 1.0, shadowColor:uint = 0, shadowAlpha:Number = 1.0,
									blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = BitmapFilterType.INNER, knockout:Boolean = false)
		{
			_bitmapFilter = new flash.filters.BevelFilter(distance, angle, highlightColor, highlightAlpha, shadowColor, shadowAlpha, blurX, blurY, strength, quality, type, knockout);
		}
		
		
		[Bindable("propertyChange")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			DataChange.change(this, "enabled", _enabled, _enabled = value);
		}
		private var _enabled:Boolean = true;
		
		
		public function get bitmapFilter():BitmapFilter
		{
			return _bitmapFilter;
		}
		private var _bitmapFilter:flash.filters.BevelFilter;
		
		
		[Bindable("propertyChange")]
		public function get distance():Number { return _bitmapFilter.distance; }
		public function set distance(value:Number):void
		{
			DataChange.change(this, "distance", _bitmapFilter.distance, _bitmapFilter.distance = value);
		}
		
		[Bindable("propertyChange")]
		public function get angle():Number { return _bitmapFilter.angle; }
		public function set angle(value:Number):void
		{
			DataChange.change(this, "angle", _bitmapFilter.angle, _bitmapFilter.angle = value);
		}
		
		[Bindable("propertyChange")]
		public function get highlightColor():Number { return _bitmapFilter.highlightColor; }
		public function set highlightColor(value:Number):void
		{
			DataChange.change(this, "highlightColor", _bitmapFilter.highlightColor, _bitmapFilter.highlightColor = value);
		}
		
		[Bindable("propertyChange")]
		public function get highlightAlpha():Number { return _bitmapFilter.highlightAlpha; }
		public function set highlightAlpha(value:Number):void
		{
			DataChange.change(this, "highlightAlpha", _bitmapFilter.highlightAlpha, _bitmapFilter.highlightAlpha = value);
		}
		
		[Bindable("propertyChange")]
		public function get shadowColor():Number { return _bitmapFilter.shadowColor; }
		public function set shadowColor(value:Number):void
		{
			DataChange.change(this, "shadowColor", _bitmapFilter.shadowColor, _bitmapFilter.shadowColor = value);
		}
		
		[Bindable("propertyChange")]
		public function get shadowAlpha():Number { return _bitmapFilter.shadowAlpha; }
		public function set shadowAlpha(value:Number):void
		{
			DataChange.change(this, "shadowAlpha", _bitmapFilter.shadowAlpha, _bitmapFilter.shadowAlpha = value);
		}
		
		[Bindable("propertyChange")]
		public function get blurX():Number { return _bitmapFilter.blurX; }
		public function set blurX(value:Number):void
		{
			DataChange.change(this, "blurX", _bitmapFilter.blurX, _bitmapFilter.blurX = value);
		}
		
		[Bindable("propertyChange")]
		public function get blurY():Number { return _bitmapFilter.blurY; }
		public function set blurY(value:Number):void
		{
			DataChange.change(this, "blurY", _bitmapFilter.blurY, _bitmapFilter.blurY = value);
		}
		
		[Bindable("propertyChange")]
		public function get strength():Number { return _bitmapFilter.strength; }
		public function set strength(value:Number):void
		{
			DataChange.change(this, "strength", _bitmapFilter.strength, _bitmapFilter.strength = value);
		}
		
		[Bindable("propertyChange")]
		public function get quality():Number { return _bitmapFilter.quality; }
		public function set quality(value:Number):void
		{
			DataChange.change(this, "quality", _bitmapFilter.quality, _bitmapFilter.quality = value);
		}
		
		[Inspectable(enumeration="inner,outer,full")]
		[Bindable("propertyChange")]
		public function get type():String { return _bitmapFilter.type; }
		public function set type(value:String):void
		{
			DataChange.change(this, "type", _bitmapFilter.type, _bitmapFilter.type = value);
		}
		
		[Bindable("propertyChange")]
		public function get knockout():Boolean { return _bitmapFilter.knockout; }
		public function set knockout(value:Boolean):void
		{
			DataChange.change(this, "knockout", _bitmapFilter.knockout, _bitmapFilter.knockout = value);
		}
	}
}
