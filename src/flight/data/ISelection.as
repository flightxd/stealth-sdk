/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flight.collections.IList;

	public interface ISelection
	{
		function get item():Object;
		function set item(value:Object):void;
		
		function get items():IList;
		
		function select(items:*):*;
		
	}
}
