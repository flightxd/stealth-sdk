/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.Event;

	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.events.SkinEvent;
	import stealth.skins.ISkinnable;
	import flight.utils.Extension;
	import flight.utils.getClassName;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	public class Behavior extends Extension implements IBehavior
	{
		protected var dataBind:DataBind = new DataBind();
		
		[Bindable(event="typeChange", style="noEvent")]
		public function get type():String
		{
			if (!_type) {
				_type = getClassName(this).toLowerCase();
				_type = _type.replace("behavior", "");
			}
			return _type;
		}
		public function set type(value:String):void
		{
			DataChange.change(this, "type", _type, _type = value);
		}
		private var _type:String;
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():InteractiveObject { return InteractiveObject(getTarget()); }
		public function set target(value:InteractiveObject):void { setTarget(value); }
		
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
			var target:InteractiveObject = this.target;
			if (target) {
				if (target is ISkinnable && ISkinnable(target).skin) {
					return ISkinnable(target).skin.getSkinPart(partName);
				} else if (partName in target) {
					return target[partName];
				}
			}
			return null;
		}
		
		override protected function attach():void
		{
			var target:InteractiveObject = this.target;
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = getSkinPart(partName);
				if (skinPart && partName in this) {
					this[partName] = skinPart;
					partAdded(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, null, skinPart));
				}
			}
			target.addEventListener("skinChange", onSkinChange);
			target.addEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
		}
		
		override protected function detach():void
		{
			var target:InteractiveObject = this.target;
			target.removeEventListener(SkinEvent.SKIN_PART_CHANGE, onSkinPartChange);
			target.removeEventListener("skinChange", onSkinChange);
			var skinParts:Object = this.skinParts;
			for (var partName:String in skinParts) {
				var skinPart:InteractiveObject = this[partName];
				if (skinPart) {
					this[partName] = null;
					partRemoved(partName, skinPart);
					dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, partName, skinPart, null));
				}
			}
		}
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
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
		
		private function onSkinChange(event:Event):void
		{
			detach();
			attach();
		}
	}
}
