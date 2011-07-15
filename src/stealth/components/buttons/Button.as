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
	import stealth.components.containers.Container;
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
	
	public class Button extends Container
	{
		protected var mouseState:String = ButtonState.UP;
		
		public function Button()
		{
			ButtonEvent.initialize(this);
			skinParts = { labelDisplay:DisplayObject, iconDisplay:DisplayObject };
		}
		
		[SkinPart]
		[Bindable(event="labelDisplayChange", style="noEvent")]
		public function get labelDisplay():DisplayObject { return _labelDisplay; }
		public function set labelDisplay(value:DisplayObject):void
		{
			if (value) {
				if (_label != null) {
					if ("label" in value) {
						value["label"] = _label;
					} else if ("text" in value) {
						value["text"] = _label;
					}
				} else {
					if ("label" in value) {
						_label = value["label"];
					} else if ("text" in value) {
						_label = value["text"];
					}
				}
			}
			DataChange.change(this, "labelDisplay", _labelDisplay, _labelDisplay = value);
		}
		private var _labelDisplay:DisplayObject;
		
		[SkinPart]
		[Bindable(event="iconDisplayChange", style="noEvent")]
		public function get iconDisplay():DisplayObject { return _iconDisplay; }
		public function set iconDisplay(value:DisplayObject):void
		{
			if (value) {
				if (_icon) {
					if ("source" in value) {
						value["source"] = _icon;
					} else if ("bitmapData" in value) {
						value["bitmapData"] = _icon;
					}
				} else {
					if ("source" in value) {
						_icon = value["source"];
					} else if ("bitmapData" in value) {
						_icon = value["bitmapData"];
					}
				}
			}
			DataChange.change(this, "iconDisplay", _iconDisplay, _iconDisplay = value);
		}
		private var _iconDisplay:DisplayObject;
		
		
		
		[Bindable(event="labelChange")]
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			DataChange.change(this, "label", _label, _label = value);
		}
		private var _label:String;
		
		[Bindable(event="iconChange", style="noEvent")]
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
		
		[Bindable(event="selectedChange", style="noEvent")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			if (_toggle) {
				DataChange.queue(this, "selected", _selected, _selected = value);
				super.currentState = getButtonState();
			}
		}
		private var _selected:Boolean;
		
		[Bindable(event="toggleChange", style="noEvent")]
		public function get toggle():Boolean { return _toggle; }
		public function set toggle(value:Boolean):void
		{
			if (!value && _selected) {
				DataChange.queue(this, "selected", _selected, _selected = value);
			}
			DataChange.change(this, "toggle", _toggle, _toggle = value);
		}
		private var _toggle:Boolean = false;
		
		[Bindable(event="emphasizedChange", style="noEvent")]
		public function get emphasized():Boolean { return _emphasized; }
		public function set emphasized(value:Boolean):void
		{
			DataChange.change(this, "emphasized", _emphasized, _emphasized = value);
		}
		private var _emphasized:Boolean;
		
		[Bindable(event="holdPressChange", style="noEvent")]
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
