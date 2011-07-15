/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package mx.core
{
	import stealth.graphics.GraphicElement;

	public class SpriteAsset extends GraphicElement implements IFlexAsset
	{
		public function SpriteAsset()
		{
			layoutElement.nativeSizing = true;
		}
	}
}
