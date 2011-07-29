/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;
	
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.utils.Extension;
	import flight.utils.getClassName;
	
	import mx.events.PropertyChangeEvent;
	
	import stealth.skins.ISkinnable;
	
	public class Behavior extends Extension implements IBehavior
	{
		protected var dataBind:DataBind = new DataBind();
		
		public static function getDefaultName(behavior:IBehavior):String
		{
			return getClassName(behavior).toLowerCase().replace("behavior", "");
		}
		
		public function Behavior()
		{
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
		}
		
		[Bindable(event="nameChange", style="noEvent")]
		public function get name():String { return _name ||= getDefaultName(this); }
		public function set name(value:String):void
		{
			DataChange.change(this, "name", _name, _name = value);
		}
		private var _name:String;
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():IEventDispatcher { return getTarget(); }
		public function set target(value:IEventDispatcher):void
		{
			var target:IEventDispatcher = getTarget();
			if (target is ISkinnable) {
				target.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinChange);
			}
			setTarget(target = value);
			if (target is ISkinnable) {
				target.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinChange);
				skin = ISkinnable(target).skin || target;
			} else {
				skin = target;
			}
		}
		
		
		protected function get skinParts():Object { return _skinParts; }
		protected function set skinParts(value:Object):void
		{
			for (var i:String in value) {
				_skinParts[i] = value[i];
			}
		}
		private var _skinParts:Object = {};
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		private function onSkinChange(event:PropertyChangeEvent):void
		{
			if (event.property == "skin") {
				skin = IEventDispatcher(event.newValue) || target;
			}
		}
		
		[Bindable(event="skinChange", style="noEvent")]
		protected function get skin():IEventDispatcher { return _skin; }
		protected function set skin(value:IEventDispatcher):void
		{
			if (_skin != value) {
				if (_skin) {
					_skin.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinPropertyChange);
				}
				DataChange.change(this, "skin", _skin, _skin = value);
				if (_skin) {
					_skin.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinPropertyChange);
					for (var i:String in skinParts) {
						this[i] = i in _skin ? _skin[i] : null;
					}
				}
			}
		}
		private var _skin:IEventDispatcher;
		
		private function onSkinPropertyChange(event:PropertyChangeEvent):void
		{
			if (event.property in skinParts) {
				this[event.property] = _skin[event.property];
			}
		}
		
		private function onPropertyChange(event:PropertyChangeEvent):void
		{
			if (event.property in skinParts) {
				partRemoved(String(event.property), InteractiveObject(event.oldValue));
				partAdded(String(event.property), InteractiveObject(event.newValue));
			}
		}
	}
}
