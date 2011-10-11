/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.events.IEventDispatcher;

	[Event(name="commit", type="flight.events.InvalidationEvent")]
	[Event(name="validate", type="flight.events.InvalidationEvent")]
	[Event(name="ready", type="flight.events.InvalidationEvent")]

	public interface IInvalidating extends IEventDispatcher
	{
		function invalidate(phase:String = null):void;
		function validateNow(phase:String = null):void;
	}
}
