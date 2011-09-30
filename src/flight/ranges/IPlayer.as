/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	public interface IPlayer extends IProgress
	{
		function get playing():Boolean;
		
		function play():void
		function pause():void;
		function stop():void;
		
		function seek(position:Number = NaN):void;
	}
}

