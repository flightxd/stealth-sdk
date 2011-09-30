/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flight.collections.IList;

	public interface IListSelection extends ISelection
	{
		function get index():int;
		function set index(value:int):void;
		
		function get indices():IList;
		
		function selectAt(indices:*):*;
	}
}
