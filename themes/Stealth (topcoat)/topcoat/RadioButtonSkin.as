/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package topcoat
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import stealth.containers.Group;
	import flight.display.MovieClipDisplay;
	import stealth.layouts.Align;
	import stealth.layouts.HorizontalLayout;
	import MovieClipSkin;
	
	dynamic public class RadioButtonSkin extends MovieClipSkin
	{
		public var contentGroup:Group;
		public var labelDisplay:TextField;
		
		public var contour:MovieClipDisplay;
		public var depth:MovieClipDisplay;
		public var color:MovieClipDisplay;
		public var background:MovieClipDisplay;
		public var emphasis:MovieClipDisplay;
		
		public function RadioButtonSkin()
		{
			dataBind.bindSetter(onLabelChange, this, "target.label");
			dataBind.bindSetter(onEmphasizedChange, this, "target.emphasized");
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			defaultRect.right = 0;
			
			if (contentGroup) {
				if (!contentGroup.layout) {
					var contentLayout:HorizontalLayout = new HorizontalLayout();
					contentLayout.horizontalAlign = Align.CENTER;
					contentLayout.verticalAlign = Align.MIDDLE;
					contentGroup.layout = contentLayout;
				}
				contentGroup.style.left = contentGroup.style.top = contentGroup.style.bottom = 0;
				setTimelineMargins(contentGroup);
			}
			if (labelDisplay) {
				labelDisplay.autoSize = TextFieldAutoSize.LEFT;
				if (target && "label" in target) {
					labelDisplay.text = target["label"] || "";
				}
			}
			
			if (contour) {
				contour.style.left = 0;
				contour.style.vertical = .5;
				setTimelineMargins(contour);
			}
			if (depth) {
				depth.style.left = 0;
				depth.style.vertical = .5;
				setTimelineMargins(depth);
			}
			if (color) {
				color.style.left = 0;
				color.style.vertical = .5;
				setTimelineMargins(color);
			}
			if (background) {
				background.style.left = background.style.top = background.style.right = background.style.bottom = 0;
				setTimelineMargins(background);
			}
			
			if (emphasis) {
				emphasis.style.left = 0;
				emphasis.style.vertical = .5;
				setTimelineMargins(emphasis);
				if (target && "emphasized" in target) {
					emphasis.alpha = int(target["emphasized"]);
				}
			}
		}
		
		private function onLabelChange(label:String):void
		{
			if (labelDisplay) {
				labelDisplay.text = label || "";
			}
		}
		
		private function onEmphasizedChange(emphasized:Boolean):void
		{
			if (emphasis) {
				emphasis.alpha = int(emphasized);
			}
		}
	}
}
