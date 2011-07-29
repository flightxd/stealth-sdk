/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.ILayout;
	import flight.ranges.IPosition;
	import flight.ranges.Position;
	
	import stealth.graphics.paint.Paint;
	import stealth.graphics.shapes.Rect;
	import stealth.layouts.Align;
	import stealth.layouts.Box;
	import stealth.layouts.BoxLayout;

	[Event(name="validate", type="flight.events.InvalidationEvent")]

	[DefaultProperty("content")]
	public class Group extends GraphicElement implements IContainer
	{
		public function Group(content:* = null, background:* = null)
		{
			this.background = background;
			layoutElement.snapToPixel = true;
			
			addEventListener(Event.ADDED, onChildAdded, true, 10);
			addEventListener(Event.REMOVED, onChildRemoved, true, 10);
			
			_content = new ArrayList();
			for (var i:int = 0; i < numChildren; i++) {
				_content.add(getChildAt(i));
			}
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange, false, 10);
			if (content) {
				this.content = content;
			}
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#padding
		 */
		[Bindable(event="paddingChange", style="noEvent")]
		public function get padding():Box { return _padding ||= new Box(); }
		public function set padding(value:*):void
		{
			if (!(value is Box)) {
				value = Box.getInstance(value, _padding);
			}
			DataChange.change(this, "padding", _padding, _padding = value);
		}
		private var _padding:Box;
		
		/**
		 * @copy stealth.layout.BoxLayout#gap
		 */
		public function get gap():Box { return _padding ||= new Box(); }
		public function set gap(value:*):void
		{
			if (!(value is Box)) {
				value = Box.getDirectional(value, _padding);
			}
			DataChange.change(this, "padding", _padding, _padding = value);
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#hAlign
		 */
		[Bindable(event="hAlignChange", style="noEvent")]
		[Inspectable(enumeration="left,center,right,fill", defaultValue="left", name="hAlign")]
		public function get hAlign():String { return _hAlign; }
		public function set hAlign(value:String):void
		{
			DataChange.change(this, "hAlign", _hAlign, _hAlign = value);
		}
		private var _hAlign:String = Align.LEFT;
		
		/**
		 * @copy stealth.layout.BoxLayout#vAlign
		 */
		[Bindable(event="vAlignChange", style="noEvent")]
		[Inspectable(enumeration="top,middle,bottom,fill", defaultValue="top", name="vAlign")]
		public function get vAlign():String { return _vAlign; }
		public function set vAlign(value:String):void
		{
			DataChange.change(this, "vAlign", _vAlign, _vAlign = value);
		}
		private var _vAlign:String = Align.TOP;
		
		// ====== background implementation ====== //
		
		[Bindable(event="backgroundChange", style="noEvent")]
		public function get background():IGraphicShape { return _background; }
		public function set background(value:*):void
		{
			if (!(value is IGraphicShape)) {
				value = Paint.getInstance(value);
				if (value) {
					value = new Rect(0, 0, value);
				}
			}
			
			if (_background != value) {
				if (_background) {
					_background.canvas = null;
				}
				DataChange.change(this, "background", _background, _background = value as IGraphicShape);
				if (_background) {
					_background.canvas = this;
					_background.depth = -1;
					_background.width = width;
					_background.height = height;
				}
				invalidate();
			}
		}
		private var _background:IGraphicShape;
		
		override protected function resize():void
		{
			if (_background) {
				_background.width = width;
				_background.height = height;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		override public function set content(value:*):void
		{
			ArrayList.getInstance(value, _content);
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
					addEventListener(LayoutEvent.RESIZE, onClippedResize);
					invalidate(LayoutEvent.RESIZE);
					layoutElement.contained = false;
				} else {
					removeEventListener(LayoutEvent.RESIZE, onClippedResize);
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
					rect.x = _hPosition.current;
				}
				if (_vPosition) {
					rect.y = _vPosition.current;
				}
				scrollRect = rect;
			}
		}
		
		protected function scrollRectSize():void
		{
			if (_hPosition) {
				_hPosition.begin = 0;
				_hPosition.end = contentWidth - width;
				_hPosition.skipSize = width;
			}
			if (_vPosition) {
				_vPosition.begin = 0;
				_vPosition.end = contentHeight - height;
				_vPosition.skipSize = height;
			}
			
			if (width < contentWidth || height < contentHeight) {
				var rect:Rectangle = scrollRect || new Rectangle();
				rect.width = width;
				rect.height = height;
				if (_hPosition) {
					rect.x = hPosition.current;
				}
				if (_vPosition) {
					rect.y = vPosition.current;
				}
				scrollRect = rect;
			} else if (scrollRect) {
				scrollRect = null;
			}
		}
		
		private function onClippedResize(event:Event):void
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
