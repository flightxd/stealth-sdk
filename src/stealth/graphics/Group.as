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
	import flight.display.Bitmap;
	import flight.display.IInvalidating;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.ILayout;
	import flight.ranges.IPosition;
	import flight.ranges.Position;
	
	import mx.events.PropertyChangeEvent;
	
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
			if (background != null) {
				this.background = background;
			}
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
		[Bindable("propertyChange")]
		public function get padding():Box { return _layout is BoxLayout ? BoxLayout(_layout).padding : null; }
		public function set padding(value:*):void
		{
			if (_layout is BoxLayout) {
				BoxLayout(_layout).padding = value;
			}
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#gap
		 */
		public function get gap():Box { return _layout is BoxLayout ? BoxLayout(_layout).gap : null; }
		public function set gap(value:*):void
		{
			if (_layout is BoxLayout) {
				BoxLayout(_layout).gap = value;
			}
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#hAlign
		 */
		[Bindable("propertyChange")]
		[Inspectable(enumeration="left,center,right,fill", defaultValue="left", name="hAlign")]
		public function get hAlign():String { return _layout is BoxLayout ? BoxLayout(_layout).hAlign : null; }
		public function set hAlign(value:String):void
		{
			if (_layout is BoxLayout) {
				BoxLayout(_layout).hAlign = value;
			}
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#vAlign
		 */
		[Bindable("propertyChange")]
		[Inspectable(enumeration="top,middle,bottom,fill", defaultValue="top", name="vAlign")]
		public function get vAlign():String { return _layout is BoxLayout ? BoxLayout(_layout).vAlign : null; }
		public function set vAlign(value:String):void
		{
			if (_layout is BoxLayout) {
				BoxLayout(_layout).vAlign = value;
			}
		}
		
		
		// ====== background implementation ====== //
		
		[Bindable("propertyChange")]
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
					_background.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onShapeChange);
				}
				DataChange.change(this, "background", _background, _background = value as IGraphicShape);
				if (_background) {
					_background.width = width;
					_background.height = height;
					_background.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onShapeChange, false, 10);
					invalidate();
				}
			}
		}
		private var _background:IGraphicShape;
		
		[Bindable("propertyChange")]
		public function get flattened():Boolean { return _flattened; }
		public function set flattened(value:Boolean):void
		{
			if (_flattened != value) {
				DataChange.queue(this, "flattened", _flattened, _flattened = value);
				contentChanging = true;
				if (_flattened) {
					invalidate();
					_content.addEventListener(ListEvent.ITEM_CHANGE, onShapeChange, false, 10);
				} else {
					_content.removeEventListener(ListEvent.ITEM_CHANGE, onShapeChange);
					graphics.clear();
					for each (var child:DisplayObject in _content) {
						addChild(child);
					}
					contentChanging = false;
				}
				DataChange.change();
			}
		}
		private var _flattened:Boolean;
		
		private function onShapeChange(event:Event):void
		{
			invalidate();
		}
		
		[Bindable("propertyChange")]
		public function get rasterized():Boolean { return _rasterized; }
		public function set rasterized(value:Boolean):void
		{
			if (_rasterized != value) {
				DataChange.change(this, "rasterized", _rasterized, _rasterized = value);
				if (_rasterized) {
					invalidate();
				} else {
					contentChanging = true;
					removeChild(image);
					image.bitmapData.dispose();
					image = null;
					if (!_flattened) {
						for each (var child:DisplayObject in _content) {
							addChild(child);
						}
					}
					contentChanging = false;
				}
			}
		}
		private var _rasterized:Boolean;
		private var image:Bitmap;
		
		override protected function render():void
		{
			if (!_background && !_flattened && (!_rasterized || image)) {
				return;
			}
			
			graphics.clear();
			if (_background) {
				_background.validateNow();
				_background.update();
				_background.draw(graphics);
			}
			
			var child:DisplayObject;
			if (_flattened) {
				if (numChildren) {
					for each (child in _content) {
						removeChild(child);
					}
				}
				for each (child in _content) {
					if (child is IGraphicShape) {
						IGraphicShape(child).update(child.transform.matrix);
						IGraphicShape(child).draw(graphics);
					}
				}
			}
			
			if (_rasterized && !image) {
				contentChanging = true;
				image = new Bitmap(this);
				var rect:Rectangle = getRect(this);
				image.x = rect.x;
				image.y = rect.y;
				graphics.clear();
				for each (child in _content) {
					removeChild(child);
				}
				addChild(image);
				contentChanging = false;
			}
		}
		
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
		[Bindable("propertyChange")]
		public function get content():IList { return _content; }
		override public function set content(value:*):void
		{
			ArrayList.getInstance(value, _content);
		}
		private var _content:ArrayList;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
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
		
		[Bindable("propertyChange")]
		public function get contentWidth():Number { return layoutElement.contentWidth; }
		public function set contentWidth(value:Number):void { layoutElement.contentWidth = value; }
		
		[Bindable("propertyChange")]
		public function get contentHeight():Number { return layoutElement.contentHeight; }
		public function set contentHeight(value:Number):void { layoutElement.contentHeight = value; }
		
		[Bindable("propertyChange")]
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
		
		[Bindable("propertyChange")]
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
		
		[Bindable("propertyChange")]
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
				if (_flattened || _rasterized) {
					removeChild(child);
					contentChanging = false;
				}
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
				var child:DisplayObject;
				if (!_flattened && !_rasterized) {
					contentChanging = true;
					for each (child in event.removed) {
						removeChild(child);
					}
					for each (child in event.items) {
						addChildAt(child, _content.getIndex(child));
					}
					contentChanging = false;
				} else if (_flattened) {
					for each (child in event.items) {
						if (child is IGraphicShape) {
							IGraphicShape(child).validateNow();
						}
					}
					invalidate();
				}
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		private var contentChanging:Boolean;
	}
}
