/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package topcoat
{
	import flash.text.TextField;

	import flight.display.MovieClipDisplay;
	import stealth.layouts.Align;
	import MovieClipSkin;
	
	import stealth.buttons.ButtonBase;
	import stealth.ranges.RangeBase;
	
	dynamic public class StepperSkin extends MovieClipSkin
	{
		[HostComponent("stealth.ranges.RangeBase")]
		public var hostComponent:RangeBase;

		// skinparts
		public var labelDisplay:TextField;
		public var backwardButton:ButtonBase;
		public var forwardButton:ButtonBase;
		public var background:MovieClipDisplay;
		
		public function StepperSkin()
		{
			dataBind.bindSetter(onPositionChange, this, "target.position.value");
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			defaultRect.right = 0;

			if (backwardButton) {
				backwardButton.style.right = backwardButton.style.top = backwardButton.style.bottom = 0;
				setTimelineMargins(backwardButton);
			}
			
			if (forwardButton) {
				backwardButton.style.right = backwardButton.style.bottom = 0;
				setTimelineMargins(forwardButton);
			}
						
			if (background) {
				background.style.left = background.style.top = background.style.right = background.style.bottom = 0;
				setTimelineMargins(background);
			}
			
			hostComponent.position.stepSize = 10;
			hostComponent.position.pageSize = 80;
		}
		
		protected function update():void
		{
			if (hostComponent && labelDisplay) {
				labelDisplay.text = String(hostComponent.position.value);
			}
		}
		
		private function onPositionChange(value:Number):void
		{
			update();
		}
	}
}
