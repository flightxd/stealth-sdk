/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flight.display.IInvalidating;

	public interface IMeasureable extends IInvalidating
	{
		/**
		 * The default bounds of this layout instance, based on the measured
		 * size of this layout's contents.
		 */
		function get measured():IBounds;
	}
}
