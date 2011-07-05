/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import flight.behaviors.Behavior;
	import flight.data.DataChange;
	import flight.events.ButtonEvent;

	import stealth.components.ButtonState;

	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	
	public class ClickBehavior extends Behavior// implements IStateful
	{
		public function ClickBehavior()
		{
			dataBind.bind(this, "holdPress", this, "target.holdPress", true);
		}
		
		[Bindable(event="holdPressChange", style="noEvent")]
		public function get holdPress():Boolean { return _holdPress; }
		public function set holdPress(value:Boolean):void
		{
			if (value) {
				if (target) {
					target.removeEventListener(ButtonEvent.DRAG_OVER, onStateDown);
					target.removeEventListener(ButtonEvent.DRAG_OUT, onStateOver);
				}
				dataBind.releaseEventListener(ButtonEvent.DRAG_OVER, onStateDown, this, "target");
				dataBind.releaseEventListener(ButtonEvent.DRAG_OUT, onStateOver, this, "target");
			} else {
				dataBind.bindEventListener(ButtonEvent.DRAG_OVER, onStateDown, this, "target");
				dataBind.bindEventListener(ButtonEvent.DRAG_OUT, onStateOver, this, "target");
			}
			DataChange.change(this, "holdPress", _holdPress, _holdPress = value);
		}
		private var _holdPress:Boolean = false;
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.queue(this, "currentState", _currentState, _currentState = value);
//			if (target is IStateful) {
//				IStateful(target).currentState = value;
//			}
		}
		private var _currentState:String = ButtonState.UP;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
		
		override protected function attach():void
		{
			super.attach();
			ButtonEvent.initialize(target);
			if (target is Sprite) {
				//Sprite(target).mouseChildren = false;
			}
			target.addEventListener(MouseEvent.ROLL_OUT, onStateUp, false, 0, true);
			target.addEventListener(ButtonEvent.RELEASE_OUTSIDE, onStateUp, false, 0, true);
			target.addEventListener(MouseEvent.ROLL_OVER, onStateOver, false, 0, true);
			target.addEventListener(ButtonEvent.DRAG_OUT, onStateOver, false, 0, true);
			target.addEventListener(ButtonEvent.RELEASE, onStateOver, false, 0, true);
			target.addEventListener(ButtonEvent.PRESS, onStateDown, false, 0, true);
			target.addEventListener(ButtonEvent.DRAG_OVER, onStateDown, false, 0, true);
		}
		
		override protected function detach():void
		{
			super.detach();
			target.removeEventListener(MouseEvent.ROLL_OUT, onStateUp);
			target.removeEventListener(ButtonEvent.RELEASE_OUTSIDE, onStateUp);
			target.removeEventListener(MouseEvent.ROLL_OVER, onStateOver);
			target.removeEventListener(ButtonEvent.DRAG_OUT, onStateOver);
			target.removeEventListener(ButtonEvent.RELEASE, onStateOver);
			target.removeEventListener(ButtonEvent.PRESS, onStateDown);
			target.removeEventListener(ButtonEvent.DRAG_OVER, onStateDown);
		}
		
		// ====== Event Listeners ====== //
		
		private function onStateUp(event:MouseEvent):void
		{
			if (event.type == MouseEvent.ROLL_OUT && event.buttonDown) {
				return;
			}
			currentState = ButtonState.UP;
			event.updateAfterEvent();
		}
		
		private function onStateOver(event:MouseEvent):void
		{
			if (event.type == MouseEvent.ROLL_OVER && event.buttonDown) {
				return;
			}
			currentState = ButtonState.OVER;
			event.updateAfterEvent();
		}
		
		private function onStateDown(event:MouseEvent):void
		{
			currentState = ButtonState.DOWN;
			event.updateAfterEvent();
		}
		
	}
}
