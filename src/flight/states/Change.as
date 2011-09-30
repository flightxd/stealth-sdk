/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.states
{
	import flight.commands.IUndoableCommand;

	public class Change implements IUndoableCommand
	{
		public var target:Object;
		public var newValues:Object;
		public var oldValues:Object;
		
		protected var changed:Boolean;
		
		public function Change(target:Object = null, newValues:Object = null)
		{
			this.target = target;
			this.newValues = newValues;
		}
		
		public function execute():void
		{
			var i:String;
			if (!changed) {
				if (!oldValues) {
					oldValues = {};
				}
				for (i in newValues) {
					oldValues[i] = target[i];
					target[i] = newValues[i];
				}
				changed = true;
			} else {
				for (i in newValues) {
					target[i] = newValues[i];
				}
			}
		}
		
		public function undo():void
		{
			if (changed) {
				for (var i:String in oldValues) {
					target[i] = oldValues[i];
				}
				changed = false;
			}
		}
		
		public function redo():void
		{
			execute();
		}
	}
}
