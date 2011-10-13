/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	import flight.display.Invalidation;

	public class InvalidationEvent extends Event
	{
		public static const COMMIT:String = "commit";
		Invalidation.registerPhase(COMMIT, InvalidationEvent, 200, false);
		
		public static const VALIDATE:String = "validate";
		Invalidation.registerPhase(VALIDATE, InvalidationEvent, 0, true);
		
		public static const READY:String = "ready";
		Invalidation.registerPhase(READY, InvalidationEvent, -10, true);
		
		public function InvalidationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var constructor:Class = this["constructor"];
			return new constructor(type, bubbles, cancelable);
		}
	}
}
