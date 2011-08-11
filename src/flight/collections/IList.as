/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.collections
{
	import flash.events.IEventDispatcher;

	[Event(name="listChange", type="flight.events.ListEvent")]
	[Event(name="itemChange", type="flight.events.ListEvent")]
	
	public interface IList extends IEventDispatcher
	{
		function get length():uint;
		
		function clear():void;
		function add(items:*, index:int = int.MAX_VALUE):*;					// combined addItem, addItemAt, addItems
		function contains(item:Object):Boolean;								// was containsItem
		function get(index:int = 0, length:uint = int.MAX_VALUE):*;			// combined getItemAt, getItems
		function getById(id:Object, field:String = null):Object;			// was getItemById
		function getIndex(item:Object, fromIndex:int = 0):int;				// was getItemIndex
		function getLastIndex(item:Object, fromIndex:int = int.MAX_VALUE):int;
		function remove(item:Object):Object;								// was removeItem
		function removeAt(index:int = 0, length:uint = 0):*;				// combined removeItemAt, removeItems
		function set(index:int, item:Object):Object;						// was setItemAt
		function setIndex(item:Object, index:int):Object;					// was setItemIndex
		function swap(item1:Object, item2:Object):void						// was swapItems
		function swapAt(index1:int, index2:int):void						// was swapItemsAt
	}
}
