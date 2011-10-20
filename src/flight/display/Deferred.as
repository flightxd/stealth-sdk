/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import flight.events.InvalidationEvent;
	import flight.events.PropertyEvent;

	public class Deferred extends Dictionary
	{
		private var target:Object;
		private var watched:Object;
		
		public function Deferred(target:Object)
		{
			this.target = target;
			target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, 10, true);
			target.addEventListener(InvalidationEvent.COMMIT, onCommit, false, 10, true);
		}
		
		public function defer(method:Function, withPropertyChange:String = null):void
		{
			if (withPropertyChange) {
				watched ||= {};
				watched[withPropertyChange] = method;
			}
			
			if (!this[method]) {
				this[method] = true;
				invalidate();
			}
		}
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			var method:Function = watched[event.property];
			if (method != null && !this[method]) {
				this[method] = true;
				invalidate();
			}
		}
		
		private function onCommit(event:InvalidationEvent):void
		{
			for (var method:* in this) {
				delete this[method];
				if (method.length) {
					method(event);
				} else {
					method();
				}
			}
		}
		
		private function invalidate():void
		{
			if (target is IInvalidating) {
				IInvalidating(target).invalidate(InvalidationEvent.COMMIT);
			} else if (target is DisplayObject) {
				Invalidation.invalidate(DisplayObject(target), InvalidationEvent.COMMIT);
			}
		}
	}
}
