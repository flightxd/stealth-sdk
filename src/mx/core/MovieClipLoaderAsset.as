/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.core
{
	import flash.utils.ByteArray;

	import flight.graphics.GraphicElement;

	public class MovieClipLoaderAsset extends GraphicElement implements IFlexAsset
	{
		public function MovieClipLoaderAsset()
		{
			layoutElement.nativeSizing = true;
		}
		
		public function get movieClipData():ByteArray
		{
			return null;
		}
	}
}
