/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	import flight.display.Invalidation;

	public class InvalidationEvent extends Event
	{
		public static const VALIDATE:String = "validate";
		Invalidation.registerPhase(VALIDATE, InvalidationEvent, 0);
		
		public static const COMMIT:String = "commit";
		Invalidation.registerPhase(COMMIT, InvalidationEvent, 200);
		
		public function InvalidationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var constructor:Class = Object(this).constructor;
			return new constructor(type, bubbles, cancelable);
		}
	}
}
