/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.skins.ranges
{
	import stealth.components.buttons.Button;
	import stealth.skins.Skin;
	import stealth.skins.Theme;

	public class ScrollBarSkin extends Skin
	{
		Theme.registerSkin(ScrollBarSkin);
		
		public var backwardButton:Button;
		public var forwardButton:Button;
		
		public var thumb:Button;
		public var track:Button;
		
		public function ScrollBarSkin()
		{
		}
		
		
		override protected function create():void
		{
			
		}
	}
}
