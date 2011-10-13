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
	import flash.filters.ColorMatrixFilter;

	import flight.events.PropertyEvent;

	public class ColorMatrixFilter extends EventDispatcher implements IBitmapFilter
	{
		public function ColorMatrixFilter(matrix:Array = null)
		{
			_bitmapFilter = new flash.filters.ColorMatrixFilter(matrix);
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
		private var _bitmapFilter:flash.filters.ColorMatrixFilter;
		
		
		[Bindable("propertyChange")]
		public function get matrix():Array { return _bitmapFilter.matrix; }
		public function set matrix(value:Array):void
		{
			PropertyEvent.change(this, "matrix", _bitmapFilter.matrix, _bitmapFilter.matrix = value);
		}
	}
}
