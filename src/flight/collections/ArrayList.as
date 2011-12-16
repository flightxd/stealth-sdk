/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.collections
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import flight.events.ListEvent;
	import flight.events.PropertyEvent;
	import flight.utils.callLater;

	[Event(name="listChange", type="flight.events.ListEvent")]
	[Event(name="itemChange", type="flight.events.ListEvent")]
	
	dynamic public class ArrayList extends Array implements IEventDispatcher, IList
	{
		protected var dispatcher:EventDispatcher;
		protected var listChangeEvent:ListEvent;
		protected var itemChangeEvent:ListEvent;
		private var itemsWatched:Boolean;
		
		public function ArrayList(source:Object = null, idField:String = "id")
		{
			if (source) {
				if (source is Array) {
					super.push.apply(this, source);
				} else {
					super.push(source);
				}
			}
			_idField = idField;
		}
		
		[Bindable("propertyChange")]
		public function get idField():String { return _idField; }
		public function set idField(value:String):void
		{
			PropertyEvent.change(this, "idField", _idField, _idField = value);
		}
		private var _idField:String;
		
		public function clear():void
		{
			length = 0;
		}
		
		public function add(items:*, index:int = int.MAX_VALUE):*
		{
			if (items is Array) {
				if (index >= length) {
					push.apply(this, items);
				} else {
					items.unshift(index, 0);
					splice.apply(this, items);
				}
			} else {
				if (index >= length) {
					push(items);
				} else {
					splice(index, 0, items);
				}
			}
			return items;
		}
		
		public function contains(item:Object):Boolean
		{
			return getIndex(item) != -1;
		}
		
		public function getAt(index:int, length:uint = 0):*
		{
			if (length > 0) {
				return slice(index, index + length);
			}
			
			if (index < 0) {
				index = length - index <= 0 ? 0 : length - index;
			}
			return this[index];
		}
		
		public function getById(id:Object, field:String = null):Object
		{
			field = field || _idField;
			for each (var item:Object in this) {
				if (field in item && item[field] == id) {
					return item;
				}
			}
			return null;
		}
		
		public function getIndex(item:Object, fromIndex:int = 0):int
		{
			return indexOf(item, fromIndex);
		}
		
		public function getLastIndex(item:Object, fromIndex:int = 2147483647):int
		{
			return lastIndexOf(item, fromIndex);
		}
		
		public function remove(item:Object):Object
		{
			var index:int = getIndex(item);
			return (index != -1) ? removeAt(index, 0) : null;
		}
		
		public function removeAt(index:int, length:uint = 0):*
		{
			if (length > 0) {
				return splice(index, length);
			}
			return splice(index, 1)[0];
		}
		
		public function setIndex(item:Object, index:int):Object
		{
			var oldIndex:int = getIndex(item);
			if (oldIndex == -1) {
				return add(item, index);
			} else if (index < 0) {
				index = (length + index) > 0 ? length + index : 0;
			}
			
			queueChanges = true;
			splice(oldIndex, 1);
			splice(index, 0, item);
			queueChanges = false;
			return item;
		}
		
		public function swap(item1:Object, item2:Object):void
		{
			var index1:int = getIndex(item1);
			var index2:int = getIndex(item2);
			swapAt(index1, index2);
		}
		
		public function swapAt(index1:int, index2:int):void
		{
			var item1:Object = this[index1];
			this[index1] = this[index2];
			this[index2] = item1;
			if (dispatcher) {
				listChange(index1, index2);
			}
		}
		
		public static function getInstance(value:*, list:ArrayList = null):ArrayList
		{
			if (!list) {
				list = new ArrayList();
			}
			
			list.queueChanges = true;
			list.clear();
			if (value is Array) {
				list.add(value);
			} else if (value is IList) {
				list.add( IList(value).getAt(0, uint.MAX_VALUE) );
			} else if (value != null) {
				list.add(value);
			}
			list.queueChanges = false;
			
			return list;
		}
		
		[Bindable("listChange")]
		override public function get length():uint { return super.length; }
		override public function set length(value:uint):*
		{
			var oldValue:int = super.length;
			if (oldValue > value) {
				var deleteValues:Array = AS3::slice();
				super.length = value;
				listChange(oldValue, value, null, deleteValues);
			}
		}
		
		[Bindable("propertyChange")]
		public function get queueChanges():Boolean { return _queueChanges; }
		public function set queueChanges(value:Boolean):void
		{
			PropertyEvent.change(this, "queueChanges", _queueChanges, _queueChanges = value);
			if (!_queueChanges && dispatcher) {
				if (listChangeEvent) {
					dispatcher.dispatchEvent(listChangeEvent);
					listChangeEvent = null;
				}
				if (itemChangeEvent) {
					dispatcher.dispatchEvent(itemChangeEvent);
					itemChangeEvent = null;
				}
			}
		}
		private var _queueChanges:Boolean;
		
		public function set(index:int, item:Object):Object
		{
			if (index < 0) {
				index = super.length - index <= 0 ? 0 : super.length - index;
			}
			var value:* = this[index];
			this[index] = item;
			if (dispatcher) {
				listChange(index, index, item, value);
			}
			return item;
		}
		
		override AS3 function push(...args):uint
		{
			var loc:int = super.length;
			var len:int = super.AS3::push.apply(this, args);
			if (dispatcher) {
				listChange(loc, len-1, args, null);
			}
			return len;
		}
		
		override AS3 function pop():*
		{
			var len:int = super.length-1;
			var value:* = super.AS3::pop();
			if (dispatcher) {
				listChange(len, len, null, value);
			}
			return value;
		}

		override AS3 function shift():*
		{
			var value:* = super.AS3::shift();
			if (dispatcher) {
				listChange(0, 0, null, value);
			}
			return value;
		}

		override AS3 function unshift(...args):uint
		{
			var len:int = super.AS3::unshift.apply(this, args);
			if (dispatcher) {
				listChange(0, args.length-1, args, null);
			}
			return len;
		}
		
		override AS3 function reverse():Array
		{
			super.AS3::reverse();
			if (dispatcher) {
				listChange(0, super.length-1);
			}
			return this;
		}

		override AS3 function splice(...args):*
		{
			var len:int = super.length;
			var startIndex:int = args[0];
			if (startIndex < 0) {
				startIndex = args[0] = len - startIndex <= 0 ? 0 : len - startIndex;
			} else if (startIndex > len) {
				startIndex = len;
			}
			var deleteValues:Array = super.AS3::splice.apply(this, args);
			if (dispatcher) {
				args.shift();
				var deleteCount:Number = args.shift();
				var max:int = isNaN(deleteCount) ? len-1-startIndex : deleteCount;
				if (args && args.length-1 > max) {
					max = args.length-1;
				}
				listChange(startIndex, startIndex+max, args, deleteValues);
			}
			return deleteValues;
		}

		override AS3 function sort(...args):*
		{
			var value:* = super.AS3::sort.apply(this, args);
			if (dispatcher) {
				listChange(0, super.length);
			}
			return value;
		}
		
		override AS3 function sortOn(names:*, options:* = 0, ...args):*
		{
			args.unshift(names, options);
			var value:* = super.AS3::sortOn.apply(this, args);
			if (dispatcher) {
				listChange(0, super.length);
			}
			return value;
		}
		
		override AS3 function concat(...args):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, this);
			for each (var o:Object in args) {
				if (o is Array) {
					value.push.apply(value, o);
				} else {
					value.push(o);
				}
			}
			return value;
		}
		
		override AS3 function slice(startIndex:* = 0, endIndex:* = 16777215):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::slice(startIndex, endIndex));
			return value;
		}

		override AS3 function filter(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::filter(callback, thisObject));
			return value;
		}

		override AS3 function map(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::map(callback, thisObject));
			return value;
		}
		
		protected function listChange(from:int, to:int, items:Object = null, removed:Object = null):void
		{
			if (dispatcher) {
				if (listChangeEvent) {
					listChangeEvent.append(from, to, items, removed);
				} else {
					listChangeEvent = new ListEvent(ListEvent.LIST_CHANGE, false, false, from, to, items, removed);
				}
				
				if (!_queueChanges) {
					dispatcher.dispatchEvent(listChangeEvent);
					listChangeEvent = null;
				}
			}
		}
		
		protected function itemChange(index:int, item:Object):void
		{
			if (dispatcher) {
				if (itemChangeEvent) {
					itemChangeEvent.append(index, index, [item]);
				} else {
					itemChangeEvent = new ListEvent(ListEvent.ITEM_CHANGE, false, false, index, index, [item]);
				}
				
				if (!_queueChanges) {
					dispatcher.dispatchEvent(itemChangeEvent);
					itemChangeEvent = null;
				}
			}
		}
		
		private function watchItems():void
		{
			if (!itemsWatched) {
				itemsWatched = true;
				dispatcher.addEventListener(ListEvent.LIST_CHANGE, onListChange, false, 10);
				for each (var item:Object in this) {
					if (item is IEventDispatcher) {
						item.addEventListener(PropertyEvent.PROPERTY_CHANGE, onItemChange, false, 10, true);
					}
				}
			}
		}
		
		private function unwatchItems():void
		{
			if (itemsWatched && !dispatcher.hasEventListener(ListEvent.ITEM_CHANGE)) {
				itemsWatched = false;
				dispatcher.removeEventListener(ListEvent.LIST_CHANGE, onListChange);
				for each (var item:Object in this) {
					if (item is IEventDispatcher) {
						item.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onItemChange);
					}
				}
			}
		}
		
		private function onListChange(event:ListEvent):void
		{
			var item:Object;
			for each (item in event.removed) {
				if (item is IEventDispatcher) {
					item.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onItemChange);
				}
			}
			for each (item in event.items) {
				if (item is IEventDispatcher) {
					item.addEventListener(PropertyEvent.PROPERTY_CHANGE, onItemChange, false, 10, true);
				}
			}
		}
		
		private function onItemChange(event:PropertyEvent):void
		{
			var index:int = indexOf(event.target);
			itemChange(index, event);
		}
		
		// ========== EventDispatcher Implementation ========== //
		
		/**
		 * @inherit
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void
		{
			if (!dispatcher) {
				dispatcher = new EventDispatcher(this);
			}
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			if (type == ListEvent.ITEM_CHANGE) {
				watchItems();
			}
		}
		
		/**
		 * @inherit
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (dispatcher) {
				dispatcher.removeEventListener(type, listener, useCapture);
				
				if (type == ListEvent.ITEM_CHANGE && !dispatcher.hasEventListener(ListEvent.ITEM_CHANGE)) {
					callLater(unwatchItems);
				}
			}
		}
		
		/**
		 * @inherit
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return dispatcher ? dispatcher.dispatchEvent(event) : false;
		}
		
		/**
		 * @inherit
		 */
		public function hasEventListener(type:String):Boolean
		{
			return dispatcher ? dispatcher.hasEventListener(type) : false;
		}
		
		/**
		 * @inherit
		 */
		public function willTrigger(type:String):Boolean
		{
			return dispatcher ? dispatcher.willTrigger(type) : false;
		}
	}
}
