/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package topcoat.stepper
{
	import flash.text.TextField;

	import flash.text.TextFieldAutoSize;

	import flight.containers.Group;
	import flight.display.MovieClipDisplay;
	import flight.layouts.Align;
	import flight.layouts.HorizontalLayout;
	import flight.skins.MovieClipSkin;

	dynamic public class BackwardButtonSkin extends MovieClipSkin
	{
		public var contentGroup:Group;
		public var labelDisplay:TextField;
		public var icon:MovieClipDisplay;
		
		public var contour:MovieClipDisplay;
		public var depth:MovieClipDisplay;
		public var color:MovieClipDisplay;
		public var emphasis:MovieClipDisplay;
		
		public function BackwardButtonSkin()
		{
			dataBind.bindSetter(onLabelChange, this, "target.label");
			dataBind.bindSetter(onEmphasizedChange, this, "target.emphasized");
		}
		
		override protected function attachSkin():void
		{
			super.attachSkin();
			
			if (contentGroup) {
				if (!contentGroup.layout) {
					var contentLayout:HorizontalLayout = new HorizontalLayout();
					contentLayout.horizontalAlign = contentLayout.verticalAlign = Align.CENTER;
					contentGroup.layout = contentLayout;
				}
				contentGroup.style.left = contentGroup.style.top = contentGroup.style.right = contentGroup.style.bottom = 0;
				setTimelineMargins(contentGroup);
			}
			if (labelDisplay) {
				labelDisplay.autoSize = TextFieldAutoSize.CENTER;
				if (target && "label" in target) {
					labelDisplay.text = target["label"] || "";
				}
			}
			if (icon) {
				icon.style.horizontal = .5;
				icon.style.vertical = .5;
				setTimelineMargins(icon);
			}
			
			if (contour) {
				contour.style.left = contour.style.top = contour.style.right = contour.style.bottom = 0;
				setTimelineMargins(contour);
			}
			if (depth) {
				depth.style.left = depth.style.top = depth.style.right = depth.style.bottom = 0;
				setTimelineMargins(depth);
			}
			if (color) {
				color.style.left = color.style.top = color.style.right = color.style.bottom = 0;
				setTimelineMargins(color);
			}
			
			if (emphasis) {
				emphasis.style.left = emphasis.style.top = emphasis.style.right = emphasis.style.bottom = 0;
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
