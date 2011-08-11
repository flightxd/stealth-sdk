package mx.states
{
	import flight.states.State;

	public class State extends flight.states.State
	{
	    public function State(properties:Object=null)
	    {
			super(properties.name, properties.overrides);
	    }
	}
}
