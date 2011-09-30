/*
 * Copyright (c) 2010 the original author or authors.
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
