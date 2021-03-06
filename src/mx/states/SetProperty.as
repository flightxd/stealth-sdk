/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.states
{
	import flight.states.Change;

	public class SetProperty extends Change
	{
		public var name:String;
		
		public function SetProperty(target:Object = null, newValues:Object = null)
		{
			super(target, newValues);
		}
		
		public function get value():Object { return newValues[name]; }
		public function set value(value:Object):void
		{
			newValues[name] = value;
			if (changed) {
				target[name] = value;
			}
		}
		
		public function initializeFromObject(properties:Object):Object
		{
			newValues = {};
			target = properties.target;
			name = properties.name;
			value = properties.value;
			return this;
		}
	}
}
