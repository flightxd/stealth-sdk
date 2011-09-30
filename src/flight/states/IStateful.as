/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
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
