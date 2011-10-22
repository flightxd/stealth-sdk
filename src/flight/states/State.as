/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.states
{
	import flight.collections.ArrayList;
	import flight.commands.IUndoableCommand;
	import flight.events.PropertyEvent;

	[DefaultProperty("stateChanges")]
	public class State extends ArrayList implements IUndoableCommand
	{
		public var name:String;
		public var source:Object;
		
		public function State(name:String = "normal", changes:* = null)
		{
			this.name = name;
			this.stateChanges = changes;
		}
		
		[Bindable("propertyChange")]
		[ArrayElementType("flight.states.Change")]
		public function set stateChanges(value:*):void
		{
			ArrayList.getInstance(value, this);
		}
		
		public function execute():void
		{
			source.addEventListener(PropertyEvent.PROPERTY_CHANGE, onTargetChanged, false, 10, true);
			// TODO: execute includeIn changes first ... move this to a utility invoked before execute()? (or in some other way avoid 'source')
			// then other changes
			for each (var change:Change in this) {
				if (change.target is String) {
					if (source && source[change.target]) {
						change.target = source[change.target];
					} else {
						//trace("Invalid change in state \"" + name + "\", '" + change.target + "' an invalid target.");
						continue;
					}
				} else if (!change.target) {
					change.target = source;
				}
				change.execute();
			}
		}
		
		private function onTargetChanged(event:PropertyEvent):void
		{
			for each (var change:Change in this) {
				if (change.target is String && change.target == event.property) {
					if (source && source[change.target]) {
						change.target = source[change.target];
						change.execute();
					}
				}
			}
		}
		
		public function undo():void
		{
			source.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onTargetChanged);
			for each (var change:Change in this) {
				change.undo();
			}
		}
		
		public function redo():void
		{
			for each (var change:Change in this) {
				change.redo();
			}
		}
		
		public function change(target:Object, newValues:Object):Change
		{
			return add(new Change(target, newValues));
		}
		
		public function includeIn(target:Object):Change
		{
//			itemsFactory: _StealthStates_Rect2_factory,
//			destination: "_StealthStates_DockGroup1",
//			propertyName: "content",
//			position: "after",
//			relativeTo: ["_StealthStates_Rect1"]
			return null;
		}
		
		public function toString():String
		{
			return name;
		}
		
		public static function resolveDeferredTargets(source:Object, state:State):void
		{
		}
	}
}
