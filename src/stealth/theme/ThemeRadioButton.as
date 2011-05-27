/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import stealth.behaviors.ClickBehavior;
	import stealth.behaviors.SelectBehavior;
	import stealth.skins.topcoat.RadioButtonSkin;

	public class ThemeRadioButton
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new RadioButtonSkin();
			}
			if (!component.style.click) {
				component.style.click = new ClickBehavior();
			}
			if (!component.style.select) {
				component.style.select = new SelectBehavior();
			}
		}
	}
}
