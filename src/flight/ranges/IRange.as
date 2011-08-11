/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	public interface IRange
	{
		function get begin():Number;
		function set begin(value:Number):void;
		
		function get end():Number;
		function set end(value:Number):void;
	}
}
