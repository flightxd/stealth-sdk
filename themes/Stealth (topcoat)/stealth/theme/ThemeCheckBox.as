/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import stealth.behaviors.ClickBehavior;
	import stealth.behaviors.SelectBehavior;
	
	import topcoat.CheckBoxSkin;
	
	public class ThemeCheckBox
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new CheckBoxSkin();
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
