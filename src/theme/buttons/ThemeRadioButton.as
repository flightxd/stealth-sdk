/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package theme.buttons
{
	import stealth.skins.ISkin;
	import stealth.skins.buttons.RadioButtonSkin;

	public class ThemeRadioButton
	{
		public static function getInstance():ISkin
		{
			return new RadioButtonSkin();
		}
	}
}
