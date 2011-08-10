/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components.buttons
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	import flight.data.DataChange;
	import flight.display.BitmapSource;
	import flight.events.ButtonEvent;

	import stealth.components.ButtonState;
	import stealth.components.Component;

	import theme.buttons.ThemeButton;

	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	[SkinState("upSelected")]
	[SkinState("overSelected")]
	[SkinState("downSelected")]
	[SkinState("disabledSelected")]
	
	[Event(name="press", type="flight.events.ButtonEvent")]
	[Event(name="hold", type="flight.events.ButtonEvent")]
	[Event(name="drag", type="flight.events.ButtonEvent")]
	[Event(name="dragOver", type="flight.events.ButtonEvent")]
	[Event(name="dragOut", type="flight.events.ButtonEvent")]
	[Event(name="release", type="flight.events.ButtonEvent")]
	[Event(name="releaseOutside", type="flight.events.ButtonEvent")]
	
	public class Button extends Component
	{
		protected var mouseState:String = ButtonState.UP;
		
		public function Button()
		{
			ButtonEvent.initialize(this);
		}
		
		[Bindable("propertyChange")]
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			DataChange.change(this, "label", _label, _label = value);
		}
		private var _label:String;
		
		[Bindable("propertyChange")]
		public function get icon():BitmapData { return _icon; }
		public function set icon(value:*):void
		{
			DataChange.change(this, "icon", _icon, _icon = BitmapSource.getInstance(value));
		}
		private var _icon:BitmapData;
		
		override public function set disabled(value:Boolean):void
		{
			mouseState = value ? ButtonState.DISABLED : ButtonState.UP;
			super.disabled = value;
			super.currentState = getButtonState();
		}
		
		override public function set currentState(value:String):void
		{
			mouseState = value.replace("Selected", "");
			super.disabled = mouseState == ButtonState.DISABLED;
			super.currentState = getButtonState();
		}
		
		[Bindable("propertyChange")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			if (_toggle) {
				DataChange.queue(this, "selected", _selected, _selected = value);
				super.currentState = getButtonState();
			}
		}
		private var _selected:Boolean;
		
		[Bindable("propertyChange")]
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void
		{
			if (!value && _selected) {
				DataChange.queue(this, "selected", _selected, _selected = value);
			}
			DataChange.change(this, "toggle", _toggle, _toggle = value);
		}
		private var _toggle:Boolean = false;
		
		[Bindable("propertyChange")]
		public function get emphasized():Boolean { return _emphasized; }
		public function set emphasized(value:Boolean):void
		{
			DataChange.change(this, "emphasized", _emphasized, _emphasized = value);
		}
		private var _emphasized:Boolean;
		
		[Bindable("propertyChange")]
		public function get holdPress():Boolean { return _holdPress; }
		public function set holdPress(value:Boolean):void
		{
			DataChange.change(this, "holdPress", _holdPress, _holdPress = value);
		}
		private var _holdPress:Boolean;
		
		protected function getButtonState():String
		{
			return _selected ? mouseState + "Selected" : mouseState;
		}
		
		override protected function getTheme():Object
		{
			return ThemeButton;
		}
	}
}
