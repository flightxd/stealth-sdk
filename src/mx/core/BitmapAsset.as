/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.core
{
	import flash.display.BitmapData;

	public class BitmapAsset extends BitmapData implements IFlexAsset
	{
		public function BitmapAsset(width:int = 0, height:int = 0, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF)
		{
			super(width, height, transparent, fillColor);
		}
	}
}
