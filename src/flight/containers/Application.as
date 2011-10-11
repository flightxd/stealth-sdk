/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	import flight.display.Invalidation;

	[SWF(widthPercent="100%", heightPercent="100%", frameRate="30")]
	public class Application extends Module
	{
		public function Application()
		{
			addEventListener(Event.ADDED, onAppCreate, false, -10);
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
		
		protected function initStage():void
		{
			// switch to leverage multitouch where 
			if (Multitouch.supportsTouchEvents && Multitouch["mapTouchToMouse"] &&
				Multitouch.inputMode == MultitouchInputMode.NONE) {
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			}
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onStageResize, false, 20, true);
			onStageResize(null);
			Invalidation.validateNow();
		}
		
		private function onAppCreate(event:Event):void
		{
			// if this is a root application class
			if (stage == parent) {
				initStage();
			}
		}
		
		private function onStageResize(event:Event):void
		{
			width = stage.stageWidth / scaleX;
			height = stage.stageHeight / scaleY;
		}
	}
}
