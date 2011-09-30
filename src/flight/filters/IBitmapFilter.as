/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

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
