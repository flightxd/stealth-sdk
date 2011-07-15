/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.behaviors
{
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import stealth.behaviors.Behavior;
	import flight.events.ButtonEvent;

	public class DragBehavior extends Behavior
	{
		private var startMouse:Point;
		private var startPosition:Point;
		
		public function DragBehavior()
		{
		}
		
		override public function set target(value:InteractiveObject):void
		{
			if (value != null) {
				ButtonEvent.initialize(value);
			}
			super.target = value;
		}
		
		
		// ====== Event Listeners ====== //
		
		//[EventListener(type="mouseDown", target="target")]
		public function onMouseDown(event:MouseEvent):void
		{
			var item:InteractiveObject = event.currentTarget as InteractiveObject;
			startMouse = new Point(event.stageX, event.stageY);
			startPosition = new Point(item.x, item.y);
			startPosition = item.parent.localToGlobal(startPosition);
		}
		
		//[EventListener(type="drag", target="target")]
		public function onDrag(event:MouseEvent):void
		{
			var item:InteractiveObject = event.currentTarget as InteractiveObject;
			var mouse:Point = new Point(event.stageX, event.stageY);
			var delta:Point = mouse.subtract(startMouse);
			var position:Point = startPosition.add(delta);
			position = item.parent.globalToLocal(position);
			item.x = position.x;
			item.y = position.y;
			event.updateAfterEvent();
		}
	}
}
