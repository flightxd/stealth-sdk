/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flight.data.IDataRenderer;

	public interface ISkinnable extends IDataRenderer
	{
		function get skin():ISkin;
		function set skin(value:ISkin):void;
	}
}
