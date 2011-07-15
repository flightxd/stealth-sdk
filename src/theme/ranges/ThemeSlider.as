/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package theme.ranges
{
	import stealth.skins.ISkin;
	import stealth.skins.ranges.SliderSkin;

	public class ThemeSlider
	{
		public static function getInstance():ISkin
		{
			return new SliderSkin();
		}
	}
}
