/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.theme
{
	import flight.behaviors.SlideBehavior;
	import flight.data.DataBind;
	
	import stealth.skins.topcoat.SliderSkin;
	
	public class ThemeSlider
	{
		public static function initialize(component:Object):void
		{
			if (!component.skin) {
				component.skin = new SliderSkin();
			}
			if (!component.style.slide) {
				component.style.slide = new SlideBehavior();
				SlideBehavior(component.style.slide).snapThumb = true;
				DataBind.bind(component.style.slide,  "position", component, "position");
			}
		}
	}
}
