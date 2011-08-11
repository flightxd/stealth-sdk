/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.states
{
	public interface IStateful
	{
		function get currentState():String;
		function set currentState(value:String):void;
		
		function get states():Array;
	}
}
