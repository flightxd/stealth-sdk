/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.data.IPosition;
	import flight.data.Position;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.ILayout;
	
	import stealth.graphics.GraphicElement;

	[Style(name="background")]	// TODO: implement limited drawing feature
	
	[DefaultProperty("content")]
	public class Group extends GraphicElement implements IContainer
	{
		public function Group(content:* = null)
		{
			_content = new ArrayList();
			for (var i:int = 0; i < numChildren; i++) {
				_content.add(getChildAt(i));
			}
			addEventListener(Event.ADDED, onChildAdded, true, 10);
			addEventListener(Event.REMOVED, onChildRemoved, true, 10);
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange, false, 10);
			if (content) {
				this.content = content;
			}
			
			super();
			layoutElement.snapToPixel = true;
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		override public function set content(value:*):void
		{
			_content.queueChanges = true;
			_content.removeAt();
			if (value is DisplayObject) {
				_content.add(value);
			} else if (value is Array) {
				_content.add(value);
			} else if (value is IList) {
				_content.add( IList(value).get() );
			}
			_content.queueChanges = false;
		}
		private var _content:ArrayList;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange", style="noEvent")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				if (_layout) {
					_layout.target = null;
				}
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_layout) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		[Bindable(event="contentWidthChange", style="noEvent")]
		public function get contentWidth():Number { return layoutElement.contentWidth; }
		public function set contentWidth(value:Number):void { layoutElement.contentWidth = value; }
		
		[Bindable(event="contentHeightChange", style="noEvent")]
		public function get contentHeight():Number { return layoutElement.contentHeight; }
		public function set contentHeight(value:Number):void { layoutElement.contentHeight = value; }
		
		[Bindable(event="hPositionChange", style="noEvent")]
		public function get hPosition():IPosition { return _hPosition || (hPosition = new Position()); }
		public function set hPosition(value:IPosition):void
		{
			if (_hPosition) {
				_hPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "hPosition", _hPosition, _hPosition = value);
			if (_hPosition) {
				_hPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _hPosition:IPosition;
		
		[Bindable(event="vPositionChange", style="noEvent")]
		public function get vPosition():IPosition { return _vPosition || (vPosition = new Position()); }
		public function set vPosition(value:IPosition):void
		{
			if (_vPosition) {
				_vPosition.removeEventListener(Event.CHANGE, onPositionChange);
			}
			DataChange.change(this, "vPosition", _vPosition, _vPosition = value);
			if (_vPosition) {
				_vPosition.addEventListener(Event.CHANGE, onPositionChange);
			}
		}
		private var _vPosition:IPosition;
		
		[Bindable(event="clippedChange", style="noEvent")]
		public function get clipped():Boolean { return _clipped; }
		public function set clipped(value:Boolean):void
		{
			if (_clipped != value) {
				if (value) {
					addEventListener(LayoutEvent.RESIZE, onResize);
					invalidate(LayoutEvent.RESIZE);
					layoutElement.contained = false;
				} else {
					removeEventListener(LayoutEvent.RESIZE, onResize);
					layoutElement.contained = true;
				}
				DataChange.change(this, "clipped", _clipped, _clipped = value);
			}
		}
		private var _clipped:Boolean = false;
		
		override protected function measure():void
		{
			if (!layout) {
				super.measure();
			}
			if (!layoutElement.contained) {
				scrollRectSize();
			}
		}
		
		protected function scrollRectPosition():void
		{
			if (width < contentWidth || height < contentHeight) {
				var rect:Rectangle = scrollRect || new Rectangle();
				if (_hPosition) {
					rect.x = hPosition.value;
				}
				if (_vPosition) {
					rect.y = vPosition.value;
				}
				scrollRect = rect;
			}
		}
		
		protected function scrollRectSize():void
		{
			if (_hPosition) {
				_hPosition.minimum = 0;
				_hPosition.maximum = contentWidth - width;
				_hPosition.pageSize = width;
			}
			if (_vPosition) {
				_vPosition.minimum = 0;
				_vPosition.maximum = contentHeight - height;
				_vPosition.pageSize = height;
			}
			
			if (width < contentWidth || height < contentHeight) {
				var rect:Rectangle = scrollRect || new Rectangle();
				rect.width = width;
				rect.height = height;
				if (_hPosition) {
					rect.x = hPosition.value;
				}
				if (_vPosition) {
					rect.y = vPosition.value;
				}
				scrollRect = rect;
			} else if (scrollRect) {
				scrollRect = null;
			}
		}
		
		private function onResize(event:Event):void
		{
			scrollRectSize();
		}
		
		private function onPositionChange(event:Event):void
		{
			scrollRectPosition();
		}
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (child.parent == this && !contentChanging) {
				contentChanging = true;
				content.add(child, getChildIndex(child));
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (child.parent == this && !contentChanging) {
				contentChanging = true;
				content.remove(child);
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (!contentChanging) {
				contentChanging = true;
				var child:DisplayObject;
				for each (child in event.removed) {
					removeChild(child);
				}
				for each (child in event.items) {
					addChildAt(child, _content.getIndex(child));
				}
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		private var contentChanging:Boolean;
	}
}
