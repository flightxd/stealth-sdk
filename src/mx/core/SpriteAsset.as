/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.core
{
	import flight.graphics.GraphicElement;

	public class SpriteAsset extends GraphicElement implements IFlexAsset
	{
		public function SpriteAsset()
		{
			layoutElement.nativeSizing = true;
		}
	}
}
