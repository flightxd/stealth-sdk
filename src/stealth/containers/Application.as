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
	import flash.system.Capabilities;
	
	import flight.display.Invalidation;
	import flight.events.LifecycleEvent;

	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends Module
	{
		public function Application()
		{
			// if this is the root application class
			if (this == root) {
				addEventListener(LifecycleEvent.CREATE, onCreate, false, -10);
			}
		}
		
		
		public function get applicationDPI():Number { return _applicationDPI; }
		public function set applicationDPI(value:Number):void
		{
			_applicationDPI = classifyDPI(value);
			scaleX = scaleY = runtimeDPI / _applicationDPI;
		}
		private var _applicationDPI:Number = runtimeDPI;
		
		
		public function get runtimeDPI():Number
		{
			return _runtimeDPI ||= classifyDPI(Capabilities.screenDPI);
		}
		private var _runtimeDPI:Number;
		
		
		protected function classifyDPI(dpi:Number):Number
		{
			return Math.round(dpi / 40) * 40;
		}
		
		protected function initRoot():void
		{
			//contextMenu = new ContextMenu();
			//contextMenu.hideBuiltInItems();
			stage.addEventListener(Event.RESIZE, onStageResize, false, 20, true);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			onStageResize(null);
			Invalidation.validateNow();
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			initRoot();
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth / scaleX;
			height = stage.stageHeight / scaleY;
		}
	}
}
