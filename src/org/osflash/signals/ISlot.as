package org.osflash.signals
{
	/**
	 * The ISlot interface defines the basic properties of a
	 * listener associated with a Signal.
	 *
	 * @author Joa Ebert
	 * @author Robert Penner
	 * @author Tyler Wright
	 */
	public interface ISlot
	{
		/**
		 * Allows the ISlot to inject parameters when dispatching. The params will be at 
		 * the tail of the arguments and the ISignal arguments will be at the head.
		 * 
		 * var signal:ISignal = new Signal(String);
		 * signal.add(handler).callWith(42);
		 * signal.dispatch('The Answer');
		 * function handler(name:String, num:int):void{}
		 */
		function callWith(...params):ISlot;
		
		/**
		 * Whether the listener is called on execution. Defaults to true.
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
}
