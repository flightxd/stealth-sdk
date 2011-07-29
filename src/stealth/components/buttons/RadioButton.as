/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components.buttons
{
	import theme.buttons.ThemeRadioButton;

	public class RadioButton extends Button
	{
		public function RadioButton()
		{
			toggle = true;
		}
		
		override protected function getTheme():Object
		{
			return ThemeRadioButton;
		}
	}
}
