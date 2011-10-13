/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import flight.containers.IContainer;
	import flight.display.IInvalidating;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.events.PropertyEvent;
	import flight.utils.Extension;

	public class Layout extends Extension implements ILayout, IInvalidating
	{
		private var updating:Boolean;
		
		public function Layout(target:IContainer = null)
		{
			super(target);
			watchContent("visible");
		}
		
		
		// ====== ILayout implementation ====== //
		
		[Bindable("propertyChange")]
		public function get target():IContainer { return IContainer(getTarget()); }
		public function set target(value:IContainer):void { setTarget(value); }
		
		public function measure():void
		{
			var len:int = target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(target.content.getAt(i));
				if (childReady(child)) {
					measureChild(child, i == len - 1);
				}
			}
		}
		
		public function update():void
		{
			updating = true;
			var len:int = target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(target.content.getAt(i));
				if (childReady(child)) {
					updateChild(child, i == len - 1);
				}
			}
			updating = false;
		}
		
		protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		protected function childReady(child:DisplayObject):Boolean
		{
			return child.visible;
		}
		
		override protected function attach():void
		{
			target.addEventListener(LayoutEvent.MEASURE, onMeasure, false, 20, true);
			target.addEventListener(LayoutEvent.UPDATE, onLayout, false, 20, true);
			target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, 0, true);
			target.content.addEventListener(ListEvent.LIST_CHANGE, onContentChange, false, 0, true);
			target.content.addEventListener(ListEvent.ITEM_CHANGE, onItemChange, false, 0, true);
			target.invalidate(LayoutEvent.MEASURE);
			target.invalidate(LayoutEvent.UPDATE);
		}
		
		override protected function detach():void
		{
			target.removeEventListener(LayoutEvent.MEASURE, onMeasure);
			target.removeEventListener(LayoutEvent.UPDATE, onLayout);
			target.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
			target.content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
			target.content.removeEventListener(ListEvent.ITEM_CHANGE, onItemChange);
			target.invalidate(LayoutEvent.MEASURE);
			target.invalidate(LayoutEvent.UPDATE);
		}
		
		protected function watchTarget(property:String):void
		{
			targetWatch[property] = true;
		}
		private var targetWatch:Object = {};
		
		protected function watchContent(property:String, measureOnly:Boolean = false):void
		{
			contentWatch[property] = measureOnly;
		}
		private var contentWatch:Object = {};
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			switch (targetWatch[event.property]) {
				case null: break;
				case true: target.invalidate(LayoutEvent.UPDATE);						// only invalidate layout
			}
		}
		
		private function onContentChange(event:ListEvent):void
		{
			target.invalidate(LayoutEvent.MEASURE);
			target.invalidate(LayoutEvent.UPDATE);
		}
		
		private function onItemChange(event:ListEvent):void
		{
			if (!updating) {
				for each (var propertyChange:PropertyEvent in event.items) {
					switch (contentWatch[propertyChange.property]) {
						case null: break;
						case false: target.invalidate(LayoutEvent.UPDATE);				// break purposely excluded
						case true: target.invalidate(LayoutEvent.MEASURE);				// always invalidate measure
					}
				}
			}
		}
		
		private function onMeasure(event:Event):void
		{
			measure();
		}
		
		private function onLayout(event:Event):void
		{
			update();
		}
	}
}
