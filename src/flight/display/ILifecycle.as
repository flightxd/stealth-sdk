package flight.display
{
	[Event(name="create", type="flight.events.LifecycleEvent")]
	[Event(name="destroy", type="flight.events.LifecycleEvent")]
	[Event(name="ready", type="flight.events.LifecycleEvent")]
	
	public interface ILifecycle extends IInvalidating
	{
		function kill():void;
	}
}
