/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.data
{
	import flash.events.IEventDispatcher;

	import mx.events.PropertyChangeEvent;

	/**
	 * DataChange enables objects to broadcast when their properties change
	 * value, allowing property watchers and data binding.
	 */
	public class DataChange
	{
		public static var staticCallbacks:Vector.<Function> = new Vector.<Function>();
		
		private static var headChange:DataChange;
		private static var currentChange:DataChange;
		private static var objectPool:DataChange;
		
		/**
		 * The more concise approach to notifying a change in data when only a
		 * single value is updated.
		 */
		public static function change(source:Object = null, property:String = null, oldValue:* = null, newValue:* = null, force:Boolean = false):void
		{
			if (source && (oldValue != newValue || force)) {
				queue(source, property, oldValue, newValue, force);
			}
			
			var dataChange:DataChange = headChange;
			var nextChange:DataChange;
			headChange = currentChange = null;
			while (dataChange) {
				if (dataChange.oldValue != dataChange.newValue || dataChange.force) {
					// broadcast change to registered callbacks
					for each (var callback:Function in staticCallbacks) {
						callback(dataChange);
					}
					if (dataChange.source is IEventDispatcher) {
						var dispatcher:IEventDispatcher = IEventDispatcher(dataChange.source);
						if (dispatcher.hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)) {
							dispatcher.dispatchEvent(PropertyChangeEvent.createUpdateEvent(dataChange.source, dataChange.property, dataChange.oldValue, dataChange.newValue));
						}
						var eventType:String = dataChange.property + "Change";
						if (dispatcher.hasEventListener(eventType)) {
							dispatcher.dispatchEvent(new PropertyChangeEvent(eventType, false, false, null, dataChange.property, dataChange.oldValue, dataChange.newValue, dataChange.source));
						}
					}
				}
				
				// clear and store previous DataChange in the object pool for reuse
				dataChange.source = dataChange.oldValue = dataChange.newValue = null;
				
				// progress to the next DataChange
				nextChange = dataChange.next;
				dataChange.next = objectPool;
				objectPool = dataChange;
				dataChange = nextChange;
			}
		}
		
		public static function queue(source:Object, property:String, oldValue:*, newValue:*, force:Boolean = false):DataChange
		{
			var dataChange:DataChange;
			
			// pull DataChange object from the object pool if available
			if (objectPool) {
				dataChange = objectPool;
				objectPool = dataChange.next;
				dataChange.next = null;
			} else {
				dataChange = new DataChange();
			}
			
			// assign change values
			dataChange.source = source;
			dataChange.property = property;
			dataChange.oldValue = oldValue;
			dataChange.newValue = newValue;
			dataChange.force = force;
			
			if (!headChange) {
				// capture the head change
				headChange = dataChange;
			} else {
				// add DataChange object to the list of changes
				currentChange.next = dataChange;
			}
			currentChange = dataChange;
			
			return dataChange;
		}
		
		public var source:Object;
		public var property:String;
		public var oldValue:*;
		public var newValue:*;
		
		private var force:Boolean;
		private var next:DataChange;
		
		public function complete():void
		{
			change();
		}
	}
}
