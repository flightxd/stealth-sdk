/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.events
{
	import flash.events.Event;

	import flight.events.PropertyEvent;

	public class PropertyChangeEvent extends PropertyEvent
	{
		public static const PROPERTY_CHANGE:String = "propertyChange";
		
		public static function createUpdateEvent(source:Object, property:Object, oldValue:Object, newValue:Object):PropertyChangeEvent
		{
			return new PropertyChangeEvent(PROPERTY_CHANGE, false, false, null, property, oldValue, newValue, source);
		}
		
		public function PropertyChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, kind:String = null,
											property:Object = null, oldValue:Object = null, newValue:Object = null, source:Object = null)
		{
			super(type, bubbles, cancelable, source, property, oldValue, newValue);
		}
		
		override public function clone():Event
		{
			return new PropertyChangeEvent(type, bubbles, cancelable, null,
										   property, oldValue, newValue, source);
		}
	}
	
}
