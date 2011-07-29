/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.events.IEventDispatcher;

	public interface IBehavior
	{
		function get name():String;
		function set name(value:String):void;
		
		function get target():IEventDispatcher;
		function set target(value:IEventDispatcher):void;
	}
}
