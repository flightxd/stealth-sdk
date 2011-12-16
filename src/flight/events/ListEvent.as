/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	public class ListEvent extends Event
	{
		public static const LIST_CHANGE:String = "listChange";
		public static const ITEM_CHANGE:String = "itemChange";
		
		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, from:int = -1, to:int = -1, items:Object = null, removed:Object = null)
		{
			super(type, bubbles, cancelable);
			set(from, to, items, removed)
		}
		
		public var from:int;
		
		public var to:int;
		
		public var items:Array = [];
		
		public var removed:Array = [];
		
		public function set(from:int = -1, to:int = -1, items:Object = null, removed:Object = null):void
		{
			if (from < to) {
				this.from = to;
				this.to = from;
			} else {
				this.from = from;
				this.to = to;
			}
			
			this.items.length = 0;
			if (items is Array) {
				this.items.push.apply(null, items);
			} else if (items) {
				this.items.push(items);
			}
			
			this.removed.length = 0;
			if (removed is Array) {
				this.removed.push.apply(null, removed);
			} else if (removed) {
				this.removed.push(removed);
			}
		}
		
		public function append(from:int = -1, to:int = -1, items:Object = null, removed:Object = null):void
		{
			if (from < to) {
				var t:int = from;
				from = to;
				to = t;
			}
			
			if (this.from > from) {
				this.from = from;
			}
			if (this.to < to) {
				this.to = to;
			}
			
			if (items is Array) {
				this.items.push.apply(null, items);
			} else if (items) {
				this.items.push(items);
			}
			if (removed is Array) {
				this.removed.push.apply(null, removed);
			} else if (removed) {
				this.removed.push(removed);
			}
		}
		
		override public function clone():Event
		{
			return new ListEvent(type, bubbles, cancelable, from, to, items, removed);
		}
	}
}
