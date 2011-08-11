/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.IEventDispatcher;

	public interface IDataRenderer extends IEventDispatcher
	{
		function get data():Object;
		function set data(value:Object):void;
	}
}
