/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.InteractiveObject;

	import flight.behaviors.Behavior;
	import flight.data.DataChange;
	import flight.data.IPosition;
	import flight.data.Position;
	import flight.events.ButtonEvent;

	public class StepBehavior extends Behavior
	{
		public function StepBehavior()
		{
			skinParts = {forwardButton:InteractiveObject, backwardButton:InteractiveObject};
		}
		
		[Bindable(event="positionChange", style="noEvent")]
		public function get position():IPosition { return _position ||= new Position(); }
		public function set position(value:IPosition):void
		{
			DataChange.change(this, "position", _position, _position = value);
		}
		private var _position:IPosition;
		
		[SkinPart]
		[Bindable(event="forwardButtonChange", style="noEvent")]
		public function get forwardButton():InteractiveObject { return _forwardButton; }
		public function set forwardButton(value:InteractiveObject):void
		{
			DataChange.change(this, "forwardButton", _forwardButton, _forwardButton = value);
		}
		private var _forwardButton:InteractiveObject;
		
		[SkinPart]
		[Bindable(event="backwardButtonChange", style="noEvent")]
		public function get backwardButton():InteractiveObject { return _backwardButton; }
		public function set backwardButton(value:InteractiveObject):void
		{
			DataChange.change(this, "backwardButton", _backwardButton, _backwardButton = value);
		}
		private var _backwardButton:InteractiveObject;
		
		override protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
			switch (partName) {
				case "forwardButton":
					ButtonEvent.initialize(skinPart);
					skinPart.addEventListener(ButtonEvent.PRESS, onForwardPress, false, 0, true);
					skinPart.addEventListener(ButtonEvent.HOLD, onForwardPress, false, 0, true);
					break;
				case "backwardButton":
					ButtonEvent.initialize(skinPart);
					skinPart.addEventListener(ButtonEvent.PRESS, onBackwardPress, false, 0, true);
					skinPart.addEventListener(ButtonEvent.HOLD, onBackwardPress, false, 0, true);
					break;
			}
		}
		
		override protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
			switch (partName) {
				case "forwardButton":
					skinPart.removeEventListener(ButtonEvent.PRESS, onForwardPress);
					skinPart.removeEventListener(ButtonEvent.HOLD, onForwardPress);
					break;
				case "backwardButton":
					skinPart.removeEventListener(ButtonEvent.PRESS, onBackwardPress);
					skinPart.removeEventListener(ButtonEvent.HOLD, onBackwardPress);
					break;
			}
		}
		
		private function onForwardPress(event:ButtonEvent):void
		{
			position.stepForward();
			event.updateAfterEvent();
		}
		
		private function onBackwardPress(event:ButtonEvent):void
		{
			position.stepBackward();
			event.updateAfterEvent();
		}
	}
}
