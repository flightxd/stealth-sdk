/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import flight.behaviors.SlideBehavior;
	import flight.behaviors.StepBehavior;

	import flight.data.DataBind;

	import topcoat.ScrollBarSkin;
	
	public class ThemeScrollBar
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new ScrollBarSkin();
			}
			if (!component.style.step) {
				component.style.step = new StepBehavior();
				DataBind.bind(component.style.step,  "position", component, "position");
			}
			if (!component.style.slide) {
				component.style.slide = new SlideBehavior();
				DataBind.bind(component.style.slide,  "position", component, "position");
			}
		}
	}
}
