/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.containers.Group;
	import flight.layouts.DockLayout;
	import flight.layouts.ILayout;

	public class DockGroup extends Group
	{
		override protected function getDefaultLayout():ILayout
		{
			return new DockLayout();
		}
	}
}
