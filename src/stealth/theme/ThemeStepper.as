/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import flight.data.DataBind;

	import stealth.behaviors.StepBehavior;
	import stealth.skins.topcoat.StepperSkin;

	public class ThemeStepper
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new StepperSkin();
			}
			if (!component.style.step) {
				component.style.step = new StepBehavior();
				DataBind.bind(component.style.step, "position", component, "position");
			}
		}
	}
}
