/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components.ranges
{
	import theme.ranges.ThemeSlider;

	public class Slider extends RangeBase
	{
		public function Slider()
		{
		}
		
		override protected function getTheme():Object
		{
			return ThemeSlider;
		}
	}
}
