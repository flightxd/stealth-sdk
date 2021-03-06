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
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientBevelFilter;

	import flight.events.PropertyEvent;

	public class GradientBevelFilter extends EventDispatcher implements IBitmapFilter
	{
		public function GradientBevelFilter(distance:Number = 4.0, angle:Number = 45, colors:Array = null, alphas:Array = null, ratios:Array = null,
											blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = BitmapFilterQuality.LOW, type:String = BitmapFilterType.INNER, knockout:Boolean = false)
		{
			_bitmapFilter = new flash.filters.GradientBevelFilter(distance, angle, colors, alphas, ratios, blurX, blurY, strength, quality, type, knockout);
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
		private var _bitmapFilter:flash.filters.GradientBevelFilter;
		
		
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
		public function get colors():Array { return _bitmapFilter.colors; }
		public function set colors(value:Array):void
		{
			PropertyEvent.change(this, "colors", _bitmapFilter.colors, _bitmapFilter.colors = value);
		}
		
		[Bindable("propertyChange")]
		public function get alphas():Array { return _bitmapFilter.alphas; }
		public function set alphas(value:Array):void
		{
			PropertyEvent.change(this, "alphas", _bitmapFilter.alphas, _bitmapFilter.alphas = value);
		}
		
		[Bindable("propertyChange")]
		public function get ratios():Array { return _bitmapFilter.ratios; }
		public function set ratios(value:Array):void
		{
			PropertyEvent.change(this, "ratios", _bitmapFilter.ratios, _bitmapFilter.ratios = value);
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
		public function get quality():Number { return _bitmapFilter.quality; }
		public function set quality(value:Number):void
		{
			PropertyEvent.change(this, "quality", _bitmapFilter.quality, _bitmapFilter.quality = value);
		}
		
		[Inspectable(enumeration="inner,outer,full")]
		[Bindable("propertyChange")]
		public function get type():String { return _bitmapFilter.type; }
		public function set type(value:String):void
		{
			PropertyEvent.change(this, "type", _bitmapFilter.type, _bitmapFilter.type = value);
		}
		
		[Bindable("propertyChange")]
		public function get knockout():Boolean { return _bitmapFilter.knockout; }
		public function set knockout(value:Boolean):void
		{
			PropertyEvent.change(this, "knockout", _bitmapFilter.knockout, _bitmapFilter.knockout = value);
		}
	}
}
