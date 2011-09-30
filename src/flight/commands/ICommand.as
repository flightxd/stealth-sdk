/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.commands
{
	/**
	 * Base interface for all commands.
	 */
	public interface ICommand
	{
		/**
		 * Execute is the one necessary ingredient for a command class. This method represents
		 * the primary action the command fulfills and returns its success or failure.
		 */
		function execute():void;
	}
}
