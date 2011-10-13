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
	import flash.filters.DropShadowFilter;

	import flight.events.PropertyEvent;

	public class DropShadowFilter extends EventDispatcher implements IBitmapFilter
	{
		public function DropShadowFilter(distance:Number = 4.0, angle:Number = 45, color:uint = 0, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0,
										 strength:Number = 1.0, quality:int = BitmapFilterQuality.LOW, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false)
		{
			_bitmapFilter = new flash.filters.DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout, hideObject);
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
		private var _bitmapFilter:flash.filters.DropShadowFilter;
		
		
		[Bindable("propertyChange")]
		public function get distance():Number { return _bitmapFilter.distance; }
		public function set distance(value:Number):void
		{
			PropertyEvent.change(this, "distance", _bitmapFilter.distance, _bitmapFilter.distance = value);
		}
		
		[Bindable("propertyChange")]
		public function get angle():Number { return _bitmapFilter.angle; }
		public function set angle(value:Number):void
		{
			PropertyEvent.change(this, "angle", _bitmapFilter.angle, _bitmapFilter.angle = value);
		}
		
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
		
		[Bindable("propertyChange")]
		public function get hideObject():Boolean { return _bitmapFilter.hideObject; }
		public function set hideObject(value:Boolean):void
		{
			PropertyEvent.change(this, "hideObject", _bitmapFilter.hideObject, _bitmapFilter.hideObject = value);
		}
	}
}
