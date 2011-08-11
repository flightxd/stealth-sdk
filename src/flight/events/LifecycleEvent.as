/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flight.display.Invalidation;

	public class LifecycleEvent extends InvalidationEvent
	{
		public static const READY:String = "ready";
		Invalidation.registerPhase(READY, LifecycleEvent, -10);
		
		public static const DESTROY:String = "destroy";
		Invalidation.registerPhase(DESTROY, LifecycleEvent, 290);
		
		public static const CREATE:String = "create";
		Invalidation.registerPhase(CREATE, LifecycleEvent, 300);
		
		public function LifecycleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
