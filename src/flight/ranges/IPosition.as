/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	public interface IPosition extends IProgress, IRange
	{
		function get stepSize():Number;
		function set stepSize(value:Number):void;
		
		function get skipSize():Number;
		function set skipSize(value:Number):void;
		
		function stepBackward():Number;
		
		function stepForward():Number;
		
		function skipBackward():Number;
		
		function skipForward():Number;
	}
}
