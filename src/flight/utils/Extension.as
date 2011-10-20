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
			init();
			_created = true;
			create();
			addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10);
			bindInvalidation(InvalidationEvent.VALIDATE, -10);
			bindInvalidation(InvalidationEvent.COMMIT, -10);
			this["target"] = target;
		}
		
		protected function getTarget():IEventDispatcher { return _target; }
		protected function setTarget(value:IEventDispatcher):void
		{
			if (_target != value) {
				
				if (_target) {
					_target.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
					for (var phase:String in phases) {
						_target.removeEventListener(phase, dispatchEvent);
					}
					
					detach();
				}
				
				PropertyEvent.queue(this ,"target", _target, _target = value);
				if ("host" in this) {
					this["host"] = _target;
				}
				for (var property:String in bindings) {
					bindings[property] = Boolean(_target && property in _target);
					executeBinding(property);
				}
				
				if (_target) {
					_target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10, true);
					for (phase in phases) {
						_target.addEventListener(phase, dispatchEvent, false, phases[phase], true);
						invalidate(phase);
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
				bindings[property] = Boolean(_target && property in _target);
				executeBinding(property);
			} else {
				throw new Error("Cannot find property " + property + " to bind on " + getClassName(this));
			}
		}
		private var bindings:Object = {};
		
		private function executeBinding(property:Object, source:Object = null):Object
		{
			if (bindings[property]) {
				bindings[property] = null;
				
				source ||= bindings["><" + property] ? this : _target;
				var target:Object = source != this ? this : _target;
				
				var oldValue:Object = source[property];
				var newValue:Object = target[property] = oldValue;
				// reassign if newValue was altered by target
				if (newValue != oldValue) {
					source[property] = newValue;
				}
				
				bindings[property] = true;
			}
			return newValue;
		}
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			if (bindings[event.property] != null && event.source == this) {
				bindings["><" + event.property] = true;								// mark property as explicitly set: "><" (x) for explicit
				bindings.setPropertyIsEnumerable("><" + event.property, false);
			}
			event.newValue = executeBinding(event.property, event.source);
		}
		
		protected function bindInvalidation(phase:String, priority:int = 0):void
		{
			if (phases[phase] == null) {
				phases[phase] = priority;
				if (_target) {
					_target.addEventListener(phase, dispatchEvent, false, priority);
					invalidate(phase);
				}
			}
		}
		private var phases:Object = {};
		
		
		// ====== IInvalidating implementation ====== //
		
		public function invalidate(phase:String = null):void
		{
			phase ||= InvalidationEvent.VALIDATE;
			if (phases[phase] == null) {
				return bindInvalidation(phase);
			}
			
			if (_target is IInvalidating) {
				IInvalidating(_target).invalidate(phase);
			} else if (_target is DisplayObject) {
				Invalidation.invalidate(DisplayObject(_target), phase);
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
		
		protected function get created():Boolean { return _created; }
		private var _created:Boolean;
		
		final public function kill():void
		{
			if (_created) {
				if (_target) {
					this["target"] = null;
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
