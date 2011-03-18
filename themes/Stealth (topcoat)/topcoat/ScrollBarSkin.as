/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package topcoat
{
	import flight.display.MovieClipDisplay;
	import flight.layouts.Align;
	import flight.skins.MovieClipSkin;
	
	import stealth.buttons.ButtonBase;
	import stealth.ranges.RangeBase;
	
	dynamic public class ScrollBarSkin extends MovieClipSkin
	{
		[HostComponent("stealth.ranges.RangeBase")]
		public var hostComponent:RangeBase;
		
		// skinparts
		public var backwardButton:ButtonBase;
		public var forwardButton:ButtonBase;
		public var thumb:ButtonBase;
		public var track:MovieClipDisplay;
		public var background:MovieClipDisplay;
		
		public function ScrollBarSkin()
		{
			dataBind.bindSetter(onPositionChange, this, "target.position.size");
			dataBind.bindSetter(onPositionChange, this, "target.position.pageSize");
			dataBind.bindSetter(onPositionChange, this, "track.width");
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if (backwardButton) {
				backwardButton.style.dock = Align.LEFT;
				setTimelineMargins(backwardButton);
			}
			
			if (forwardButton) {
				forwardButton.style.dock = Align.RIGHT;
				setTimelineMargins(forwardButton);
			}
			
			if (thumb) {
				thumb.holdPress = true;
				thumb.style.top = thumb.style.bottom = 0;
				setTimelineMargins(thumb);
			}
			
			if (track) {
				track.style.left = track.style.top = track.style.right = track.style.bottom = 0;
				setTimelineMargins(track);
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
			if (hostComponent && thumb && track) {
				var w:Number = hostComponent.position.pageSize / (hostComponent.position.pageSize + hostComponent.position.size);
				if (w >= 1) {
					thumb.visible = false;
				} else {
					thumb.visible = true;
					w *= track.width;
					thumb.width = w <= 10 ? 10 : w;
				}
				thumb.x = (track.width - thumb.width) * hostComponent.position.percent + track.x;
			}
		}
		
		private function onPositionChange(size:Number):void
		{
			update();
		}
	}
}
