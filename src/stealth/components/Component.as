/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components
{
	import flash.display.InteractiveObject;

	import flight.behaviors.IBehavior;
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.events.SkinEvent;
	import flight.events.StyleEvent;
	import flight.skins.ISkin;
	import flight.skins.ISkinnable;

	import stealth.graphics.GraphicElement;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public class Component extends GraphicElement implements ISkinnable
	{
		protected var dataBind:DataBind = new DataBind();
		
		public function Component()
		{
			_behaviors = new ArrayList();
			_behaviors.addEventListener(ListEvent.LIST_CHANGE, onBehaviorsChange);
//			style.addEventListener(StyleEvent.STYLE_CHANGE, onStyleChange);
		}
		
		[Bindable(event="disabledChange", style="noEvent")]
		public function get disabled():Boolean { return _disabled; }
		public function set disabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = !value;
			DataChange.change(this, "disabled", _disabled, _disabled = value);
		}
		private var _disabled:Boolean = true;
		
		[ArrayElementType("flight.behaviors.IBehavior")]
		[Bindable(event="behaviorsChange", style="noEvent")]
		public function get behaviors():IList { return _behaviors; }
		public function set behaviors(value:*):void
		{
			if (value is IBehavior) {
//				style[IBehavior(value).type] = value;
			} else if (value is Array || value is IList) {
				for each (var behavior:IBehavior in value) {
//					style[behavior.type] = behavior;
				}
			} else if (value === null) {
				_behaviors.removeAt();
			}
		}
		private var _behaviors:IList;
		
		// ====== IDataRenderer implementation ====== //
		
		[Bindable(event="dataChange", style="noEvent")]
		public function get data():Object { return _data ||= {}; }
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
				if (_skin) {
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
					partAdded(partName,  skinPart);
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
		
		private function onStyleChange(event:StyleEvent):void
		{
			var behavior:IBehavior;			
			if (event.oldValue is IBehavior) {
				behavior = IBehavior(event.oldValue);
				behaviorsChanging = true;
				_behaviors.remove(behavior);
				behaviorsChanging = false;
				behavior.target = null;
			}
			if (event.newValue is IBehavior) {
				behavior = IBehavior(event.newValue);
				if (behavior.type != event.property) {
					behavior.type = event.property;
				}
				behaviorsChanging = true;
				_behaviors.add(behavior);
				behaviorsChanging = false;
				behavior.target = this;
			}
		}
		
		private function onBehaviorsChange(event:ListEvent):void
		{
			if (behaviorsChanging) {
				return;
			}

			var behavior:IBehavior;
			for each (behavior in event.removed) {
//				delete style[behavior.type];
			}
			for each (behavior in event.items) {
//				style[behavior.type] = behavior;
			}
		}
		private var behaviorsChanging:Boolean;
	}
}
