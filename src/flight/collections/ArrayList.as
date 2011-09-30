/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.collections
{
	import flight.data.DataChange;
	import flight.data.IListSelection;
	import flight.data.ListSelection;

	dynamic public class ArrayList extends ArrayDispatcher implements IList
	{
		public function ArrayList(source:Array = null, idField:String = "id")
		{
			super(source);
			_idField = idField;
		}
		
		[Bindable("propertyChange")]
		public function get selected():IListSelection { return _selected ||= new ListSelection(this); }
		private var _selected:ListSelection;
		
		[Bindable("propertyChange")]
		public function get idField():String { return _idField; }
		public function set idField(value:String):void
		{
			DataChange.change(this, "idField", _idField, _idField = value);
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
		
		public function get(index:int = 0, length:uint = int.MAX_VALUE):*
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
		
		public function removeAt(index:int = 0, length:uint = int.MAX_VALUE):*
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
			var item2:Object = this[index2];
			this[index1] = item2;
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
				list.add( IList(value).get() );
			} else if (value != null) {
				list.add(value);
			}
			list.queueChanges = false;
			
			return list;
		}
	}
}
