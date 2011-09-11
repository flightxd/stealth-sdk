package flight.states
{
	import flight.collections.ArrayList;
	import flight.commands.IUndoableCommand;

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
			// TODO: execute includeIn changes first ... move this to a utility invoked before execute()? (or in some other way avoid 'source')
			// then other changes
			for each (var change:Change in this) {
				if (change.target is String) {
					if (source && source[change.target]) {
						change.target = source[change.target];
					} else {
						trace("Invalid change in state \"" + name + "\", '" + change.target + "' an invalid target.");
						continue;
					}
				} else if (!change.target) {
					change.target = source;
				}
				change.execute();
			}
		}
		
		public function undo():void
		{
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
