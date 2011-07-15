/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components.ranges
{
	import theme.ranges.ThemeScrollBar;

	public class ScrollBar extends RangeBase
	{
		public function ScrollBar()
		{
		}
		
		override protected function getTheme():Object
		{
			return ThemeScrollBar;
		}
	}
}
