/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Returns the exact class name, without package or path.
	 * 
	 * @param	value			The object for which the class name is desired.
	 * 							Any ActionScript value may be passed including
	 * 							all ActionScript types, object instances,
	 * 							primitive types such as uint, and class objects. 
	 */
	public function getClassName(value:Object):String
	{
		return getQualifiedClassName(value).split("::").pop();
	}
}
