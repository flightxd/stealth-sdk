/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.filters
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;

	import flight.events.PropertyEvent;

	public class DisplacementMapFilter extends EventDispatcher implements IBitmapFilter
	{
		public function DisplacementMapFilter(mapBitmap:BitmapData = null, mapPoint:Point = null, componentX:uint = 0, componentY:uint = 0,
											  scaleX:Number = 0.0, scaleY:Number = 0.0, mode:String = DisplacementMapFilterMode.WRAP, color:uint = 0, alpha:Number = 0.0)
		{
			_bitmapFilter = new flash.filters.DisplacementMapFilter(mapBitmap, mapPoint, componentX, componentY, scaleX, scaleY, mode, color, alpha);
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
		private var _bitmapFilter:flash.filters.DisplacementMapFilter;
		
		
		[Bindable("propertyChange")]
		public function get mapBitmap():BitmapData { return _bitmapFilter.mapBitmap; }
		public function set mapBitmap(value:BitmapData):void
		{
			PropertyEvent.change(this, "mapBitmap", _bitmapFilter.mapBitmap, _bitmapFilter.mapBitmap = value);
		}
		
		[Bindable("propertyChange")]
		public function get mapPoint():Point { return _bitmapFilter.mapPoint; }
		public function set mapPoint(value:Point):void
		{
			PropertyEvent.change(this, "mapPoint", _bitmapFilter.mapPoint, _bitmapFilter.mapPoint = value);
		}
		
		[Bindable("propertyChange")]
		public function get componentX():uint { return _bitmapFilter.componentX; }
		public function set componentX(value:uint):void
		{
			PropertyEvent.change(this, "componentX", _bitmapFilter.componentX, _bitmapFilter.componentX = value);
		}
		
		[Bindable("propertyChange")]
		public function get componentY():uint { return _bitmapFilter.componentY; }
		public function set componentY(value:uint):void
		{
			PropertyEvent.change(this, "componentY", _bitmapFilter.componentY, _bitmapFilter.componentY = value);
		}
		
		[Bindable("propertyChange")]
		public function get scaleX():Number { return _bitmapFilter.componentY; }
		public function set scaleX(value:Number):void
		{
			PropertyEvent.change(this, "scaleX", _bitmapFilter.scaleX, _bitmapFilter.scaleX = value);
		}
		
		[Bindable("propertyChange")]
		public function get scaleY():Number { return _bitmapFilter.scaleY; }
		public function set scaleY(value:Number):void
		{
			PropertyEvent.change(this, "scaleY", _bitmapFilter.scaleY, _bitmapFilter.scaleY = value);
		}
		
		[Inspectable(enumeration="wrap,clamp,ignore,color")]
		[Bindable("propertyChange")]
		public function get mode():String { return _bitmapFilter.mode; }
		public function set mode(value:String):void
		{
			PropertyEvent.change(this, "mode", _bitmapFilter.mode, _bitmapFilter.mode = value);
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
	}
}
