/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.buttons
{
	import flash.events.Event;

	import flight.data.DataChange;
	import flight.display.InitializePhase;

	import stealth.theme.ThemeCheckBox;

	public class CheckBox extends ButtonBase
	{
		public function CheckBox()
		{
			addEventListener(InitializePhase.INITIALIZE, onInit);
		}
		
		[Bindable(event="labelChange")]
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			DataChange.change(this, "label", _label, _label = value);
		}
		private var _label:String;

		[Bindable(event="emphasizedChange", style="noEvent")]
		public function get emphasized():Boolean { return _emphasized; }
		public function set emphasized(value:Boolean):void
		{
			DataChange.change(this, "emphasized", _emphasized, _emphasized = value);
		}
		private var _emphasized:Boolean;
				
		protected function init():void
		{
			ThemeCheckBox.initialize(this);
		}
		
		private function onInit(event:Event):void
		{
			init();
		}
	}
}
