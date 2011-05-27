/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import stealth.skins.topcoat.ButtonSkin;

	public class ThemeButton
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new ButtonSkin();
			}
		}
	}
}

