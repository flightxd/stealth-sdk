/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components.buttons
{
	import flight.data.DataChange;
	import flight.events.ButtonEvent;

	import stealth.components.ButtonState;
	import stealth.components.containers.Container;

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
	
	public class ButtonBase extends Container
	{
		protected var mouseState:String = ButtonState.UP;
		
		public function ButtonBase()
		{
			ButtonEvent.initialize(this);
		}
		
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
			DataChange.queue(this, "selected", _selected, _selected = value);
			super.currentState = getButtonState();
		}
		private var _selected:Boolean;
		
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
	}
}
