/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.filters
{
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;

	import flight.events.PropertyEvent;

	public class GlowFilter extends EventDispatcher implements IBitmapFilter
	{
		public function GlowFilter(color:uint = 16711680, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0,
								   strength:Number = 2, quality:int = BitmapFilterQuality.LOW, inner:Boolean = false, knockout:Boolean = false)
		{
			_bitmapFilter = new flash.filters.GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		
		[Bindable("propertyChange")]
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			PropertyEvent.change(this, "enabled", _enabled, _enabled = value);
		}
		private var _enabled:Boolean = true;
		
		
		public function get bitmapFilter():BitmapFilter
		{
			return _bitmapFilter;
		}
		private var _bitmapFilter:flash.filters.GlowFilter;
		
		
		[Bindable("propertyChange")]
		public function get color():uint { return _bitmapFilter.color; }
		public function set color(value:uint):void
		{
			PropertyEvent.change(this, "color", _bitmapFilter.color, _bitmapFilter.color = value);
		}
		
		[Bindable("propertyChange")]
		public function get alpha():Number { return _bitmapFilter.alpha; }
		public function set alpha(value:Number):void
		{
			PropertyEvent.change(this, "alpha", _bitmapFilter.alpha, _bitmapFilter.alpha = value);
		}
		
		[Bindable("propertyChange")]
		public function get blurX():Number { return _bitmapFilter.blurX; }
		public function set blurX(value:Number):void
		{
			PropertyEvent.change(this, "blurX", _bitmapFilter.blurX, _bitmapFilter.blurX = value);
		}
		
		[Bindable("propertyChange")]
		public function get blurY():Number { return _bitmapFilter.blurY; }
		public function set blurY(value:Number):void
		{
			PropertyEvent.change(this, "blurY", _bitmapFilter.blurY, _bitmapFilter.blurY = value);
		}
		
		[Bindable("propertyChange")]
		public function get strength():Number { return _bitmapFilter.strength; }
		public function set strength(value:Number):void
		{
			PropertyEvent.change(this, "strength", _bitmapFilter.strength, _bitmapFilter.strength = value);
		}
		
		[Bindable("propertyChange")]
		public function get quality():int { return _bitmapFilter.quality; }
		public function set quality(value:int):void
		{
			PropertyEvent.change(this, "quality", _bitmapFilter.quality, _bitmapFilter.quality = value);
		}
		
		[Bindable("propertyChange")]
		public function get inner():Boolean { return _bitmapFilter.inner; }
		public function set inner(value:Boolean):void
		{
			PropertyEvent.change(this, "inner", _bitmapFilter.inner, _bitmapFilter.inner = value);
		}
		
		[Bindable("propertyChange")]
		public function get knockout():Boolean { return _bitmapFilter.knockout; }
		public function set knockout(value:Boolean):void
		{
			PropertyEvent.change(this, "knockout", _bitmapFilter.knockout, _bitmapFilter.knockout = value);
		}
	}
}
