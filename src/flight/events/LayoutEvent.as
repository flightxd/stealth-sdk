/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.display.Invalidation;

	public class LayoutEvent extends InvalidationEvent
	{
		public static const UPDATE:String = "update";
		Invalidation.registerPhase(UPDATE, LayoutEvent, 100, false);
		
		public static const MEASURE:String = "measure";
		Invalidation.registerPhase(MEASURE, LayoutEvent, 110);
		
		public function LayoutEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
