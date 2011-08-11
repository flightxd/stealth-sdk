package flight.events
{
	import flash.events.Event;

	public class PositionEvent extends Event
	{
		public static const POSITION_CHANGE:String = "positionChange";
		
		public function PositionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new PositionEvent(type, bubbles, cancelable);
		}
	}
}
