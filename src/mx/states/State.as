/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

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
