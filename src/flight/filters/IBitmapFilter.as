package flight.filters
{
	import flash.filters.BitmapFilter;

	public interface IBitmapFilter
	{
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		
		function get bitmapFilter():BitmapFilter;
	}
}