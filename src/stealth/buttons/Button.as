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
	
	import stealth.theme.ThemeButton;
	
	public class Button extends ButtonBase
	{
		public function Button()
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
		
		override public function set selected(value:Boolean):void
		{
			if (_toggle) {
				super.selected = value;
			}
		}
		
		[Bindable(event="toggleChange", style="noEvent")]
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void
		{
			DataChange.queue(this, "toggle", _toggle, _toggle = value);
			if (!_toggle && selected) {
				super.selected = false;
			}
			DataChange.change();
		}
		private var _toggle:Boolean = false;
		
		[Bindable(event="emphasizedChange", style="noEvent")]
		public function get emphasized():Boolean { return _emphasized; }
		public function set emphasized(value:Boolean):void
		{
			DataChange.change(this, "emphasized", _emphasized, _emphasized = value);
		}
		private var _emphasized:Boolean;
		
		protected function init():void
		{
			ThemeButton.initialize(this);
		}
		
		private function onInit(event:Event):void
		{
			init();
		}
	}
}
