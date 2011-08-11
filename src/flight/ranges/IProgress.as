/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	import flash.events.IEventDispatcher;

	[Event(name="positionChange", type="flight.events.PositionEvent")]
	
	public interface IProgress extends IEventDispatcher
	{
		function get current():Number;
		function set current(value:Number):void;
		
		function get percent():Number;
		function set percent(value:Number):void;
		
		function get length():Number;
		function set length(value:Number):void;
	}
}
