/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.LifecycleEvent;
	import flight.events.ListEvent;
	import flight.events.SkinEvent;
	import flight.utils.Factory;
	
	import stealth.behaviors.IBehavior;
	import stealth.graphics.GraphicElement;
	import stealth.skins.ISkin;
	import stealth.skins.ISkinnable;
	import stealth.skins.Theme;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public class Component extends GraphicElement implements ISkinnable
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Component()
		{
			_behaviors = new ArrayList();
			_behaviors.addEventListener(ListEvent.LIST_CHANGE, onBehaviorsChange);
			addEventListener(LifecycleEvent.CREATE, onCreate, false, 20);
		}
		
		[Bindable(event="disabledChange", style="noEvent")]
		public function get disabled():Boolean { return _disabled; }
		public function set disabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = !value;
			DataChange.change(this, "disabled", _disabled, _disabled = value);
		}
		private var _disabled:Boolean = true;
		
		[ArrayElementType("stealth.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange", style="noEvent")]
		public function get behaviors():IList { return _behaviors; }
		public function set behaviors(value:*):void
		{
			ArrayList.getInstance(value, _behaviors);
		}
		private var _behaviors:ArrayList;
		
		// ====== IDataRenderer implementation ====== //
		
		[Bindable(event="dataChange", style="noEvent")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			DataChange.change(this, "data", _data, _data = value);
		}
		private var _data:Object;
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		private var _currentState:String;
		
		[Bindable(event="skinChange", style="noEvent")]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void
		{
			if (_skin != value) {
				if (_skin) {
					detachSkin();
				}
				invalidate(LayoutEvent.MEASURE);
				DataChange.queue(this, "skin", _skin, _skin = value);
				if (_skin && created) {
					attachSkin();
				}
				DataChange.change();
			}
		}
		private var _skin:ISkin;
		
		protected function get skinParts():Object { return _skinParts; }
		protected function set skinParts(value:Object):void
		{
			for (var i:String in value) {
				_skinParts[i] = value[i];
			}
		}
		private var _skinParts:Object = {};
		
		protected function getSkinPart(partName:String):InteractiveObject
		{
			if (_skin) {
				return _skin.getSkinPart(partName);
			} else if (partName in this) {
				return this[partName];
			}
			return null;
		}
		
		protected function attachSkin():void
		{
			_skin.target = this;
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = getSkinPart(partName);
				if (skinPart && partName in this) {
					this[partName] = skinPart;
					partAdded(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, null, skinPart));
				}
			}
			_skin.addEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
		}
		
		protected function detachSkin():void
		{
			_skin.removeEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = this[partName];
				if (skinPart) {
					this[partName] = null;
					partRemoved(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, skinPart, null));
				}
			}
			_skin.target = null;
		}
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		override protected function measure():void
		{
			if (!_skin) {
				super.measure();
			}
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			if (_skin) {
				if (Theme.getSkinName(_skin)) {
					Theme.register(this);
				}
				attachSkin();
			} else {
				Theme.register(this);
				skin = Factory.getInstance(getTheme());
			}
		}
		
		protected function getTheme():Object
		{
			return null;
		}
		
		private function onSkinPartChange(event:SkinEvent):void
		{
			var partName:String = event.partName;
			if (partName in this) {
				if (event.oldValue) {
					partRemoved(partName, event.oldValue);
				}
				this[partName] = event.newValue;
				if (event.newValue) {
					partAdded(partName, event.newValue);
				}
				dispatchEvent(event);
			}
		}
		
		private function onBehaviorsChange(event:ListEvent):void
		{
			var behavior:IBehavior;
			for each (behavior in event.removed) {
				delete behaviorsIndex[behavior.type];
				behavior.target = null;
			}
			
			_behaviors.queueChanges = true;
			for each (behavior in event.items) {
				if (behaviorsIndex[behavior.type]) {
					_behaviors.remove(behaviorsIndex[behavior.type]);
				}
				behaviorsIndex[behavior.type] = behavior;
				behavior.target = this;
			}
			_behaviors.queueChanges = false;
		}
		private var behaviorsIndex:Object;
	}
}
