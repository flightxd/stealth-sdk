/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;

	import flight.states.IStateful;

	public interface ISkin extends IStateful, IEventDispatcher
	{
		function get target():Sprite;
		function set target(value:Sprite):void;
	}
}
