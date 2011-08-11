/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.EventDispatcher;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.events.ListEvent;

	public class ListSelection extends EventDispatcher implements IListSelection
	{
		private var updating:Boolean;
		
		public function ListSelection(list:IList = null)
		{
			this.list = list;
		}
		
		[Bindable("propertyChange")]
		public function get list():IList { return _list; }
		public function set list(value:IList):void
		{
			if (_list) {
				_list.removeEventListener(ListEvent.LIST_CHANGE, onListChange);
			}
			index = -1;
			DataChange.change(this, "list", _list, _list = value);
			if (_list) {
				_list.addEventListener(ListEvent.LIST_CHANGE, onListChange, false, 10);
			}
		}
		private var _list:IList;
		
		[Bindable("propertyChange")]
		public function get item():Object { return _item; }
		public function set item(value:Object):void
		{
			index = list.getIndex(value);
		}
		private var _item:Object = null;
		
		
		[Bindable("propertyChange")]
		public function get index():int { return _index; }
		public function set index(value:int):void
		{
			// restrict value within -1 (deselect) and highest possible index
			value = value < -1 ? -1 : (value > list.length - 1 ? list.length - 1 : value);
			if (_index != value) {
				DataChange.queue(this, "index", _index, _index = value);
				DataChange.queue(this, "item", _item, _item = _index != -1 ? list.get(_index, 0) : null);
				
				if (_items) {
					_items.queueChanges = updating = true;
					_items.clear();
					_items.add(_item);
					_items.queueChanges = updating = false;
				}
				
				if (_indices) {
					_indices.queueChanges = updating = true;
					_indices.clear();
					_indices.add(_index);
					_indices.queueChanges = updating = false;
				}
				
				DataChange.change();
			}
		}
		private var _index:int = -1;
		
		
		[Bindable("propertyChange")]
		public function get items():IList
		{
			if (!_items) {
				_items = new ArrayList();
				if (_item) {
					_items.push(_item);
				}
				indices;
				_items.addEventListener(ListEvent.LIST_CHANGE, onItemsChange, false, 10);
			}
			return _items;
		}
		private var _items:ArrayList;
		
		[Bindable("propertyChange")]
		public function get indices():IList
		{
			if (!_indices) {
				_indices = new ArrayList();
				if (_index != -1) {
					_indices.push(_index);
				}
				items;
				_indices.addEventListener(ListEvent.LIST_CHANGE, onIndicesChange, false, 10);
			}
			return _indices;
		}
		private var _indices:ArrayList;
		
		
		public function select(items:*):*
		{
			if (items is Array) {
				this.items;
				_items.queueChanges = true;
				_items.clear();
				_items.add(items);
				_items.queueChanges = false;
			} else {
				item = items;
			}
		}
		
		public function selectAt(indices:*):*
		{
			if (indices is Array) {
				this.indices;
				_indices.queueChanges = true;
				_indices.clear();
				_indices.add(indices);
				_indices.queueChanges = false;
			} else {
				index = indices;
			}
		}
		
		private function onListChange(event:ListEvent):void
		{
			if (!event.removed) {
				return;
			}
			
			if (_items) {
				_items.queueChanges = true;
				for each (var item:Object in event.removed) {
					_items.remove(item);
				}
				_items.queueChanges = false;
			} else if (event.removed.indexOf(_item) != -1) {
				index = -1;
			}
		}
		
		private function onItemsChange(event:ListEvent):void
		{
			if (updating) {
				return;
			}
			
			var item:Object;
			_indices.queueChanges = updating = true;
			_indices.clear();
			for each (item in _items) {
				_indices.add(_list.getIndex(item));
			}
			DataChange.queue(this, "item", _item, _item = _items.length ? _items.get(-1, 0) : null);
			DataChange.change(this, "index", _index, _index = _indices.length ? _indices.get(-1, 0) : -1);
			_indices.queueChanges = updating = false;
		}

		private function onIndicesChange(event:ListEvent):void
		{
			if (updating) {
				return;
			}
			
			var index:int;
			_items.queueChanges = updating = true;
			_items.clear();
			for each (index in _items) {
				_items.add(_list.get(index, 0));
			}
			DataChange.queue(this, "item", _item, _item = _items.length ? _items.get(-1, 0) : null);
			DataChange.change(this, "index", _index, _index = _indices.length ? _indices.get(-1, 0) : -1);
			_items.queueChanges = updating = false;
		}
	}
}
