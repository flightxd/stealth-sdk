package flight.filters
{
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	
	import flight.data.DataChange;
	
	public class BlurFilter extends EventDispatcher implements IBitmapFilter
	{
		public function BlurFilter(blurX:Number = 4.0, blurY:Number = 4.0, quality:int = BitmapFilterQuality.LOW)
		{
			_bitmapFilter = new flash.filters.BlurFilter(blurX, blurY, quality);
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
		private var _bitmapFilter:flash.filters.BlurFilter;
		
		
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
		public function get quality():int { return _bitmapFilter.quality; }
		public function set quality(value:int):void
		{
			DataChange.change(this, "quality", _bitmapFilter.quality, _bitmapFilter.quality = value);
		}
	}
}
