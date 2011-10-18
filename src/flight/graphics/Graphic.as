/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics
{
	import flight.containers.Group;

	public class Graphic extends Group
	{
		public var version:Number = 1;
		
		public function get viewWidth():Number { return width; }
		public function set viewWidth(value:Number):void { width = value; }
		
		public function get viewHeight():Number { return height; }
		public function set viewHeight(value:Number):void { height = value; }
	}
}
