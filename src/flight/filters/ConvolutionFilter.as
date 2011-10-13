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
	import flash.filters.ConvolutionFilter;

	import flight.events.PropertyEvent;

	public class ConvolutionFilter extends EventDispatcher implements IBitmapFilter
	{
		public function ConvolutionFilter(matrixX:Number = 0, matrixY:Number = 0, matrix:Array = null, divisor:Number = 1.0, bias:Number = 0.0,
										  preserveAlpha:Boolean = true, clamp:Boolean = true, color:uint = 0, alpha:Number = 0.0)
		{
			_bitmapFilter = new flash.filters.ConvolutionFilter(matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha);
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
		private var _bitmapFilter:flash.filters.ConvolutionFilter;
		
		
		[Bindable("propertyChange")]
		public function get matrixX():Number { return _bitmapFilter.matrixX; }
		public function set matrixX(value:Number):void
		{
			PropertyEvent.change(this, "matrixX", _bitmapFilter.matrixX, _bitmapFilter.matrixX = value);
		}
		
		[Bindable("propertyChange")]
		public function get matrixY():Number { return _bitmapFilter.matrixY; }
		public function set matrixY(value:Number):void
		{
			PropertyEvent.change(this, "matrixY", _bitmapFilter.matrixY, _bitmapFilter.matrixY = value);
		}
		
		[Bindable("propertyChange")]
		public function get matrix():Array { return _bitmapFilter.matrix; }
		public function set matrix(value:Array):void
		{
			PropertyEvent.change(this, "matrix", _bitmapFilter.matrix, _bitmapFilter.matrix = value);
		}
		
		[Bindable("propertyChange")]
		public function get divisor():Number { return _bitmapFilter.divisor; }
		public function set divisor(value:Number):void
		{
			PropertyEvent.change(this, "divisor", _bitmapFilter.divisor, _bitmapFilter.divisor = value);
		}
		
		[Bindable("propertyChange")]
		public function get bias():Number { return _bitmapFilter.bias; }
		public function set bias(value:Number):void
		{
			PropertyEvent.change(this, "bias", _bitmapFilter.bias, _bitmapFilter.bias = value);
		}
		
		[Bindable("propertyChange")]
		public function get preserveAlpha():Boolean { return _bitmapFilter.preserveAlpha; }
		public function set preserveAlpha(value:Boolean):void
		{
			PropertyEvent.change(this, "preserveAlpha", _bitmapFilter.preserveAlpha, _bitmapFilter.preserveAlpha = value);
		}
		
		[Bindable("propertyChange")]
		public function get clamp():Boolean { return _bitmapFilter.clamp; }
		public function set clamp(value:Boolean):void
		{
			PropertyEvent.change(this, "clamp", _bitmapFilter.clamp, _bitmapFilter.clamp = value);
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
