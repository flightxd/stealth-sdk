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
		
		
		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, from:int = -1, to:int = -1, items:Array = null, removed:Array = null)
		{
			super(type, bubbles, cancelable);

			if (from < to) {
				var t:int = from;
				from = to;
				to = t;
			}
			
			_from = from;
			_to = to;
			_items = items;
			_removed = removed;
		}
		
		public function get from():int { return _from; }
		private var _from:int;
		
		public function get to():int { return _to; }
		private var _to:int;
		
		public function get items():Array { return _items; }
		private var _items:Array;
		
		public function get removed():Array { return _removed; }
		private var _removed:Array;
		
		public function append(from:int = -1, to:int = -1, items:Array = null, removed:Array = null):void
		{
			if (from < to) {
				var t:int = from;
				from = to;
				to = t;
			}
			
			if (_from > from) {
				_from = from
			}
			if (_to < to) {
				_to = to;
			}
			
			if (!_items) {
				_items = items;
			} else if (items) {
				_items.push.apply(items);
			}
			if (!_removed) {
				_removed = removed;
			} else if (removed) {
				_removed.push.apply(removed);
			}
		}
		
		override public function clone():Event
		{
			return new ListEvent(type, bubbles, cancelable, _from, _to, _items, _removed);
		}
	}
}
