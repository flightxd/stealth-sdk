/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import flight.behaviors.Behavior;
	import flight.data.DataChange;
	import flight.data.ITrack;
	import flight.data.Track;
	import flight.events.ButtonEvent;

	public class SlideBehavior extends Behavior
	{
		private var dragPercent:Number;
		private var dragPoint:Number;
		private var dragging:Boolean;
		private var forwardPress:Boolean;
		
		public function SlideBehavior()
		{
			skinParts = {thumb:InteractiveObject, track:InteractiveObject};
		}
		
		[Bindable(event="positionChange", style="noEvent")]
		public function get position():ITrack { return _position || (position = new Track()); }
		public function set position(value:ITrack):void
		{
			if (_position != value) {
				if (_position) {
					_position.removeEventListener(Event.CHANGE, onPositionChange);
				}
				DataChange.change(this, "position", _position, _position = value);
				if (_position) {
					_position.addEventListener(Event.CHANGE, onPositionChange);
					onPositionChange(null);
				}
			}
		}
		private var _position:ITrack;
		
		[Bindable(event="horizontalChange", style="noEvent")]
		public function get horizontal():Boolean { return _horizontal; }
		public function set horizontal(value:Boolean):void
		{
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		private var _horizontal:Boolean;
		
		[Bindable(event="snapThumbChange", style="noEvent")]
		public function get snapThumb():Boolean { return _snapThumb; }
		public function set snapThumb(value:Boolean):void
		{
			DataChange.change(this, "snapThumb", _snapThumb, _snapThumb = value);
		}
		private var _snapThumb:Boolean;
		
		[SkinPart]
		[Bindable(event="thumbChange", style="noEvent")]
		public function get thumb():InteractiveObject { return _thumb; }
		public function set thumb(value:InteractiveObject):void
		{
			DataChange.change(this, "thumb", _thumb, _thumb = value);
		}
		private var _thumb:InteractiveObject;
		
		[SkinPart]
		[Bindable(event="trackChange", style="noEvent")]
		public function get track():InteractiveObject { return _track; }
		public function set track(value:InteractiveObject):void
		{
			DataChange.change(this, "track", _track, _track = value);
		}
		private var _track:InteractiveObject;
		
		[Bindable(event="percentChange", style="noEvent")]
		protected function get percent():Number { return _percent; }
		private var _percent:Number = 0;
		
		
		public function updatePosition():void
		{
			if (_track && _thumb) {
				var p:Point = new Point();
				
				if (horizontal) {
					p.x = (_track.width - _thumb.width) * _percent + _track.x;
					p = _thumb.parent.globalToLocal(_track.parent.localToGlobal(p));
					_thumb.x = Math.round(p.x);
				} else {
					p.y = (_track.height - _thumb.height) * _percent + _track.y;
					p = _thumb.parent.globalToLocal(_track.parent.localToGlobal(p));
					_thumb.y = Math.round(p.y);
				}
			}
		}
		
		override protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
			switch (partName) {
				case "thumb":
					ButtonEvent.initialize(skinPart);
					skinPart.addEventListener(ButtonEvent.PRESS, onThumbPress, false, 0, true);
					skinPart.addEventListener(ButtonEvent.DRAG, onThumbDrag, false, 0, true);
					skinPart.addEventListener(ButtonEvent.RELEASE, onThumbRelease, false, 0, true);
					skinPart.addEventListener(ButtonEvent.RELEASE_OUTSIDE, onThumbRelease, false, 0, true);
					break;
				case "track":
					ButtonEvent.initialize(skinPart);
					skinPart.addEventListener(ButtonEvent.PRESS, onTrackPress, false, 0, true);
					skinPart.addEventListener(ButtonEvent.HOLD, onTrackHold, false, 0, true);
					horizontal = _track.width > _track.height;
					break;
			}
			// TODO: put off to the cycle
			updatePosition();
		}
		
		override protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
			switch (partName) {
				case "thumb":
					ButtonEvent.initialize(skinPart);
					skinPart.removeEventListener(ButtonEvent.PRESS, onThumbPress);
					skinPart.removeEventListener(ButtonEvent.DRAG, onThumbDrag);
					skinPart.removeEventListener(ButtonEvent.RELEASE, onThumbRelease);
					skinPart.removeEventListener(ButtonEvent.RELEASE_OUTSIDE, onThumbRelease);
					break;
				case "track":
					ButtonEvent.initialize(skinPart);
					skinPart.removeEventListener(ButtonEvent.PRESS, onTrackPress);
					skinPart.removeEventListener(ButtonEvent.HOLD, onTrackHold);
					break;
			}
		}
		
		private function onPositionChange(event:Event):void
		{
			if (_thumb && _track && !dragging) {
				DataChange.change(this, "percent", _percent, _percent = _position.percent);
				// TODO: put off to the cycle
				updatePosition();
			}
		}
		
		private function onTrackPress(event:ButtonEvent):void
		{
			var size:Number = horizontal ? _track.width - _thumb.width : _track.height - _thumb.height;
			var mousePoint:Number = horizontal ? _track.parent.mouseX - _track.x : _track.parent.mouseY - _track.y;
			
			if (snapThumb) {
				_thumb.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, _thumb.mouseX, _thumb.mouseY));
				
				_percent = (mousePoint - _thumb.width / 2) / size;
				_percent = _percent <= 0 ? 0 : _percent >= 1 ? 1 : _percent;
				position.percent = _percent;
				updatePosition();
				
				dragPoint = horizontal ? _thumb.x + _thumb.width / 2 : _thumb.y + _thumb.height / 2;
				dragPercent = _percent;
				
				dispatchEvent(new Event("percentChange"));
			} else {
				forwardPress = mousePoint > ((horizontal ? _thumb.width / 2 : _thumb.height / 2) + size * position.percent);
				if (forwardPress) {
					position.pageForward();
				} else {
					position.pageBackward();
				}
			}
			event.updateAfterEvent();
		}
		
		private function onTrackHold(event:ButtonEvent):void
		{
			var size:Number = horizontal ? _track.width - _thumb.width : _track.height - _thumb.height;
			var mousePoint:Number = horizontal ? _track.parent.mouseX - _track.x : _track.parent.mouseY - _track.y;
			var forwardHold:Boolean = mousePoint > ((horizontal ? _thumb.width / 2 : _thumb.height / 2) + size * position.percent);
			
			if (forwardPress != forwardHold) {
				return;
			}
			
			var control:ITrack = position as ITrack;
			
			if (control) {
				if (forwardPress) {
					control.pageForward();
				} else {
					control.pageBackward();
				}
			}
			event.updateAfterEvent();
		}
		
		private function onThumbPress(event:ButtonEvent):void
		{
			dragging = true;
			dragPoint = horizontal ? _thumb.parent.mouseX : _thumb.parent.mouseY;
			dragPercent = _percent;
		}
		
		private function onThumbDrag(event:ButtonEvent):void
		{
			var mousePoint:Number = horizontal ? _thumb.parent.mouseX : _thumb.parent.mouseY;
			var size:Number = horizontal ? _track.width - _thumb.width : _track.height - _thumb.height;
			var delta:Number = (mousePoint - dragPoint) / size;
			_percent = dragPercent + delta;
			_percent = _percent <= 0 ? 0 : (_percent >= 1 ? 1 : _percent);
			position.percent = _percent;
			updatePosition();
			dispatchEvent(new Event("percentChange"));
			
			event.updateAfterEvent();
		}
		
		private function onThumbRelease(event:ButtonEvent):void
		{
			dragging = false;
		}
		
		// TODO: listen to target's RESIZE phase
		private function onResize(event:Event):void
		{
			updatePosition();
		}
	}
}
