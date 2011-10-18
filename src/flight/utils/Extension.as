/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import flight.display.Deferred;
	import flight.display.IInvalidating;
	import flight.display.Invalidation;
	import flight.events.InvalidationEvent;
	import flight.events.PropertyEvent;

	[Event(name="commit", type="flight.events.InvalidationEvent")]
	[Event(name="validate", type="flight.events.InvalidationEvent")]
	
	public class Extension extends EventDispatcher implements IInvalidating
	{
		public function Extension(target:IEventDispatcher = null)
		{
			setTarget(target);
			init();
		}
		
		protected function getTarget():IEventDispatcher { return _target; }
		protected function setTarget(value:IEventDispatcher):void
		{
			if (_target != value) {
				
				if (_target) {
					removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
					_target.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
					_target.removeEventListener(InvalidationEvent.VALIDATE, dispatchEvent);
					_target.removeEventListener(InvalidationEvent.COMMIT, dispatchEvent);
					detach();
				}
				PropertyEvent.queue(this ,"target", _target, _target = value);
				if ("host" in this) {
					this["host"] = _target;
				}
				if (_target) {
					for (var property:String in bindings) {
						bindings[property] = property in _target;
						if (bindings[property]) {
							this[property] = _target[property];
						}
					}
					addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10);
					_target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10);
					_target.addEventListener(InvalidationEvent.VALIDATE, dispatchEvent, false, -10);
					_target.addEventListener(InvalidationEvent.COMMIT, dispatchEvent, false, -10);
					invalidate(InvalidationEvent.VALIDATE);
					invalidate(InvalidationEvent.COMMIT);
					if (!_created) {
						_created = true;
						create();
					}
					attach();
				}
				PropertyEvent.change();
			}
		}
		private var _target:IEventDispatcher;
		
		protected function attach():void
		{
		}
		
		protected function detach():void
		{
		}
		
		protected function bindTarget(property:String):void
		{
			if (property in this) {
				bindings[property] = _target && property in _target;
				if (bindings[property]) {
					this[property] = _target[property];
				}
			} else {
				throw new Error("Cannot register property " + property + " in " + getClassName(this));
			}
		}
		private var bindings:Object = {};
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			var property:String = String(event.property);
			if (bindings[property]) {
				bindings[property] = false;
				var bindTarget:Object = event.target != this ? this : _target;
				var newValue:Object = bindTarget[property] = event.newValue;
				if (newValue != event.newValue) {
					event.target[property] = newValue;
					event.newValue = newValue;
				}
				bindings[property] = true;
			}
		}
		
		
		// ====== IInvalidating implementation ====== //
		
		public function invalidate(phase:String = null):void
		{
			if (_target is IInvalidating) {
				IInvalidating(_target).invalidate(phase);
			} else if (_target is DisplayObject) {
				Invalidation.invalidate(DisplayObject(_target), phase || InvalidationEvent.VALIDATE);
			}
		}
		
		public function validateNow(phase:String = null):void
		{
			if (_target is IInvalidating) {
				IInvalidating(_target).validateNow(phase);
			} else if (_target is DisplayObject) {
				Invalidation.validateNow(DisplayObject(_target), phase);
			}
		}
		
		public function defer(method:Function, withPropertyChange:String = null):void
		{
			deferred ||= new Deferred(this);
			deferred.defer(method, withPropertyChange);
		}
		private var deferred:Deferred;
		
		
		// ====== ILifecycle implementation ====== //
		
		protected function get created():Boolean { return _created; }
		private var _created:Boolean;
		
		public final function kill():void
		{
			if (_created) {
				if (_target) {
					setTarget(null);
				}
				destroy();
				_created = false;
			}
		}
		
		protected function init():void
		{
		}
		
		protected function create():void
		{
		}
		
		protected function destroy():void
		{
		}
	}
}
