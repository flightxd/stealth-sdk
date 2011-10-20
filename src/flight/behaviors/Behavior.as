/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.IEventDispatcher;

	import flight.data.DataBind;
	import flight.events.PropertyEvent;
	import flight.skins.ISkinnable;
	import flight.utils.Extension;
	import flight.utils.getClassName;

	public class Behavior extends Extension implements IBehavior
	{
		protected var dataBind:DataBind = new DataBind();
		
		public static function getDefaultName(behavior:IBehavior):String
		{
			return getClassName(behavior).replace("Behavior", "");
		}
		
		public function Behavior(target:IEventDispatcher = null)
		{
			addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
			if (target) {
				this.target = target;
			}
		}
		
		[Bindable("propertyChange")]
		public function get name():String { return _name ||= getDefaultName(this); }
		public function set name(value:String):void
		{
			PropertyEvent.change(this, "name", _name, _name = value);
		}
		private var _name:String;
		
		[Bindable("propertyChange")]
		public function get target():IEventDispatcher { return getTarget(); }
		public function set target(value:IEventDispatcher):void { setTarget(target = value); }
		
		override protected function attach():void
		{
			if (target is ISkinnable) {
				target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onSkinChange, false, 0, true);
				partSource = ISkinnable(target).skin;
			} else {
				partSource = target;
			}
		}
		
		override protected function detach():void
		{
			if (target is ISkinnable) {
				target.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onSkinChange);
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
		
		private function onSkinChange(event:PropertyEvent):void
		{
			if (event.property == "skin") {
				partSource = IEventDispatcher(event.newValue);
			}
		}
		
		[Bindable("propertyChange")]
		public function get partSource():IEventDispatcher { return _partSource; }
		public function set partSource(value:IEventDispatcher):void
		{
			if (!value) {
				value = target;
			}
			if (_partSource != value) {
				if (_partSource) {
					_partSource.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onSkinPartChange);
				}
				PropertyEvent.queue(this, "partSource", _partSource, _partSource = value);
				if (_partSource) {
					_partSource.addEventListener(PropertyEvent.PROPERTY_CHANGE, onSkinPartChange, false, 0, true);
					for (var i:String in skinParts) {
						this[i] = i in _partSource ? _partSource[i] : null;
					}
				}
				PropertyEvent.change();
			}
		}
		private var _partSource:IEventDispatcher;
		
		private function onSkinPartChange(event:PropertyEvent):void
		{
			if (event.property in skinParts) {
				this[event.property] = _partSource[event.property];
			}
		}
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			if (event.property in skinParts) {
				partRemoved(String(event.property), InteractiveObject(event.oldValue));
				partAdded(String(event.property), InteractiveObject(event.newValue));
			}
		}
	}
}
