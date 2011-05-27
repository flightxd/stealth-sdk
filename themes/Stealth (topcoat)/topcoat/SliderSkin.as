/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package topcoat
{
	import flight.display.MovieClipDisplay;
	import MovieClipSkin;
	
	import stealth.buttons.ButtonBase;
	import stealth.ranges.RangeBase;
	
	dynamic public class SliderSkin extends MovieClipSkin
	{
		[HostComponent("stealth.ranges.RangeBase")]
		public var hostComponent:RangeBase;
		
		// skinparts
		public var thumb:ButtonBase;
		public var track:MovieClipDisplay;
		public var background:MovieClipDisplay;
		
		public function SliderSkin()
		{
			dataBind.bindSetter(onPositionChange, this, "target.position.size");
			dataBind.bindSetter(onPositionChange, this, "track.width");
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
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
			}
						
			hostComponent.position.stepSize = 10;
			hostComponent.position.pageSize = 80;
		}
		
		protected function update():void
		{
			if (hostComponent && thumb && track) {
				thumb.x = (track.width - thumb.width) * hostComponent.position.percent + track.x;
			}
		}
		
		private function onPositionChange(size:Number):void
		{
			update();
		}
	}
}
