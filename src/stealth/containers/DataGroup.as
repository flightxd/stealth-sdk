/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flash.display.DisplayObject;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataChange;
	import flight.events.InvalidationEvent;
	import flight.events.ListEvent;
	import flight.utils.Factory;
	import flight.utils.IFactory;

	import stealth.graphics.Group;

	import stealth.utils.TemplateFactory;

	public class DataGroup extends Group
	{
		public function DataGroup()
		{
			addEventListener(InvalidationEvent.COMMIT, onCommit);
		}
		
		[ArrayElementType("Object")]
		[Bindable(event="dataProviderChange", style="noEvent")]
		public function get dataProvider():IList { return _dataProvider; }
		public function set dataProvider(value:*):void
		{
			if (!(value is IList) && value !== null) {
				if (_dataProvider) {
					_dataProvider.add(value);
					return;
				} else {
					value = new ArrayList(value);
				}
			}
			
			if (_dataProvider) {
				_dataProvider.removeEventListener(ListEvent.LIST_CHANGE, onProviderChange);
			}
			DataChange.change(this, "dataProvider", _dataProvider, _dataProvider = value);
			invalidate(InvalidationEvent.COMMIT);
			if (_dataProvider) {
				_dataProvider.addEventListener(ListEvent.LIST_CHANGE, onProviderChange);
			}
		}
		private var _dataProvider:IList;
		
		[Bindable(event="templateChange", style="noEvent")]
		public function get template():IFactory { return _template }
		public function set template(value:*):void
		{
			if (!(value is IFactory) && value !== null) {
				value = new TemplateFactory(value);
			}
			DataChange.change(this, "template", _template, _template = value);
			invalidate(InvalidationEvent.COMMIT);
		}
		private var _template:IFactory;
		
		protected function commit():void
		{
			if (_dataProvider && _template) {
				
				for (var i:int = 0; i < _dataProvider.length; i++) {
					
					var data:Object = _dataProvider.get(i, 0);
					var child:DisplayObject = i < numChildren ? getChildAt(i) : null;
					if (!child) {
						child = _template.getInstance(data);
						addChildAt(child, i);
					}
					if ("data" in child) {
						child["data"] = data;
					}
				}
				
				while (i < numChildren) {
					removeChildAt(i);
				}
			}
		}
		
		private function onCommit(event:InvalidationEvent):void
		{
			commit();
		}
		
		private function onProviderChange(event:ListEvent):void
		{
			invalidate(InvalidationEvent.COMMIT);
		}
	}
}
