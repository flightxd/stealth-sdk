package flight.display
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	import flight.events.InvalidationEvent;

	public class DeferredListener
	{
		public var source:IInvalidating;
		public var listener:Function;
		public var priority:int;
		public var invalidated:Boolean;
		
		public function DeferredListener(source:IInvalidating, listener:Function, priority:int = 0)
		{
			this.source = source;
			this.listener = listener;
			this.priority = priority;
		}
		
		public function defer(target:IEventDispatcher, event:String):void
		{
			target.addEventListener(event, onDeferred, false, 0, true);
			source.addEventListener(InvalidationEvent.COMMIT, onCommit, false, priority, true);
		}
		
		private function onDeferred(event:Event):void
		{
			if (!invalidated) {
				source.invalidate(InvalidationEvent.COMMIT);
				invalidated = true;
			}
		}
		
		private function onCommit(event:Event):void
		{
			if (invalidated) {
				invalidated = false;
				listener();
			}
		}
	}
}
