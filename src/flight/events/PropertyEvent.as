/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.events
{
	import flash.events.Event;

	public class PropertyEvent extends Event
	{
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		public static function change(source:Object = null, property:String = null, oldValue:Object = null, newValue:Object = null, force:Boolean = false):void
		{
			queue(source, property, oldValue, newValue, force);
			
			while (changes) {
				var change:PropertyEvent = changes;
				changes = changes.next;
				
				change.next = null;
				source = change.source;
				source.dispatchEvent(change);
			}
		}
		
		public static function queue(source:Object, property:String, oldValue:Object, newValue:Object, force:Boolean = false):void
		{
			if (source && (oldValue != newValue || force)) {
				if (source.hasEventListener(PROPERTY_CHANGE)) {
					var change:PropertyEvent = new PropertyEvent(PROPERTY_CHANGE, false, false,
																	  source, property, oldValue, newValue);
					change.next = changes;
					changes = change;
				}
			}
		}
		private static var changes:PropertyEvent;
		
		
		public var source:Object;
		public var property:Object;
		public var oldValue:Object;
		public var newValue:Object;
		
		private var next:PropertyEvent;
		
		public function PropertyEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
									  source:Object = null, property:Object = null, oldValue:Object = null, newValue:Object = null)
		{
			super(type, bubbles, cancelable);
			this.source = source;
			this.property = property;
			this.oldValue = oldValue;
			this.newValue = newValue;
		}

		override public function clone():Event
		{
			return new PropertyEvent(type, bubbles, cancelable, source, property, oldValue, newValue);
		}
		
		override public function toString():String
		{
			return "[object PropertyEvent(" + property + "=" + newValue + ")]";
		}
	}
}
