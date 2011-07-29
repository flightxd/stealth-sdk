/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.components.containers.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import flight.events.LifecycleEvent;
	
	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends Module
	{
		public function Application()
		{
			// if this is the root application class
			if (this == root) {
				addEventListener(LifecycleEvent.CREATE, onCreate, false, 20);
			}
		}
		
		protected function initRoot():void
		{
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.addEventListener(Event.RESIZE, onStageResize, false, 20, true);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			onStageResize(null);
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			initRoot();
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth;
			height = stage.stageHeight;
		}
	}
}
