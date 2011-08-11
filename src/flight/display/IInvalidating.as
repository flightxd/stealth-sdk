/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.events.IEventDispatcher;

	[Event(name="validate", type="flight.events.InvalidationEvent")]

	public interface IInvalidating extends IEventDispatcher
	{
		function invalidate(phase:String = null):void;
		function validateNow(phase:String = null):void;
	}
}
