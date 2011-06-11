/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import mx.containers.Box;
	
	import stealth.layouts.DockLayout;

	//[Frame(factoryClass="flight.containers.FrameLoader")]
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends DockGroup
	{
		override protected function create():void
		{
			// if this is the root application class
			if (this == root) {
				initStage();
			}
		}
		
		protected function initStage():void
		{
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.addEventListener(Event.RESIZE, onStageResize, false, 20, true);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			onStageResize(null);
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
	}
}
