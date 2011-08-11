/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.display.Invalidation;

	public class LayoutEvent extends InvalidationEvent
	{
		public static const RESIZE:String = "resize";
		Invalidation.registerPhase(RESIZE, LayoutEvent, 80);
		
		public static const LAYOUT:String = "layout";
		Invalidation.registerPhase(LAYOUT, LayoutEvent, 90, false);
		
		public static const MEASURE:String = "measure";
		Invalidation.registerPhase(MEASURE, LayoutEvent, 100);
		
		public function LayoutEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
