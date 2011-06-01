/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flight.data.DataChange;
	import flight.display.Invalidation;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;

	import mx.events.PropertyChangeEvent;

	public class LayoutElement implements ILayoutElement
	{
		private var target:DisplayObject;
		
		public function LayoutElement(target:DisplayObject)
		{
			this.target = target;
			_measured.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMeasuredChange);
		}
		
		
		// ====== ILayoutBounds implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="freeformChange", style="noEvent")]
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			if (value) {
				_layoutWidth = _layoutHeight = NaN;
				updateWidth();
				updateHeight();
			}
			DataChange.change(target, "freeform", _freeform, _freeform = value);
			invalidateLayout();
		}
		private var _freeform:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange", style="noEvent")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			_explicit.width = value;
			updateWidth();
		}
		private var _width:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", style="noEvent")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			_explicit.height = value;
			updateHeight();
		}
		private var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minWidthChange", style="noEvent")]
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			_explicit.minWidth = value;
			if (_contained) {
				value = _measured.constrainWidth(value);
			}
			if (_minWidth != value) {
				DataChange.queue(target, "minWidth", _minWidth, _minWidth = value);
				updateWidth();
				invalidateLayout(true);
			}
		}
		private var _minWidth:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minHeightChange", style="noEvent")]
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			_explicit.minHeight = value;
			if (_contained) {
				value = _measured.constrainHeight(value);
			}
			if (_minHeight != value) {
				DataChange.queue(target, "minHeight", _minHeight, _minHeight = value);
				updateHeight();
				invalidateLayout(true);
			}
		}
		private var _minHeight:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxWidthChange", style="noEvent")]
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void
		{
			_explicit.maxWidth = value;
			if (_contained) {
				value = _measured.constrainWidth(value);
			}
			if (_maxWidth != value) {
				DataChange.queue(target, "maxWidth", _maxWidth, _maxWidth = value);
				updateWidth();
				invalidateLayout(true);
			}
		}
		private var _maxWidth:Number = Number.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxHeightChange", style="noEvent")]
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void
		{
			_explicit.maxHeight = value;
			if (_contained) {
				value = _measured.constrainHeight(value);
			}
			if (_maxHeight != value) {
				DataChange.queue(target, "maxHeight", _maxHeight, _maxHeight = value);
				updateHeight();
				invalidateLayout(true);
			}
		}
		private var _maxHeight:Number = Number.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="marginChange", style="noEvent")]
		public function get margin():Box { return _margin || (margin = new Box()); }
		public function set margin(value:*):void
		{
			if (value is String) {
				value = Box.fromString(value);
			} else if (value is Number) {
				value = new Box(value, value, value, value);
			} else {
				value = value as Box;
			}
			
			if (_margin) {
				_margin.removeEventListener(Event.CHANGE, onMarginChange);
			}
			DataChange.change(target, "margin", _margin, _margin = value);
			invalidateLayout();
			if (_margin) {
				_margin.addEventListener(Event.CHANGE, onMarginChange);
			}
		}
		private var _margin:Box;
		
		private function onMarginChange(event:Event):void
		{
			invalidateLayout();
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", style="noEvent")]
		public function get percentWidth():Number { return _percentWidth; }
		public function set percentWidth(value:Number):void
		{
			if (value > 1) {
				value /= 100;
			}
			DataChange.change(target, "percentWidth", _percentWidth, _percentWidth = value);
			invalidateLayout();
		}
		private var _percentWidth:Number;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", style="noEvent")]
		public function get percentHeight():Number { return _percentHeight; }
		public function set percentHeight(value:Number):void
		{
			if (value > 1) {
				value /= 100;
			}
			DataChange.change(target, "percentHeight", _percentHeight, _percentHeight = value);
			invalidateLayout();
		}
		private var _percentHeight:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			return !isNaN(explicit.width) ? explicit.width : measured.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			return !isNaN(explicit.height) ? explicit.height : measured.height;
		}
		
		[Bindable(event="containedChange", style="noEvent")]
		public function get contained():Boolean { return _contained; }
		public function set contained(value:Boolean):void
		{
			if (_contained != value) {
				DataChange.queue(target, "contained", _contained, _contained = value);
				minWidth = _explicit.minWidth;
				minHeight = _explicit.minHeight;
				maxWidth = _explicit.maxWidth;
				maxHeight = _explicit.maxHeight;
				DataChange.change();
			}
		}
		private var _contained:Boolean = true;
		
		[Bindable(event="nativeSizingChange", style="noEvent")]
		public function get nativeSizing():Boolean { return _nativeSizing; }
		public function set nativeSizing(value:Boolean):void
		{
			DataChange.queue(target, "nativeSizing", _nativeSizing, _nativeSizing = value);
			if (value) {
				unscaledRect = target.getRect(target);
				updateWidth();
				updateHeight();
			}
			DataChange.change();
		}
		private var _nativeSizing:Boolean;
		private var unscaledRect:Rectangle;
		
		[Bindable(event="snapToPixelChange", style="noEvent")]
		public function get snapToPixel():Boolean { return _snapToPixel; }
		public function set snapToPixel(value:Boolean):void
		{
			DataChange.change(target, "snapToPixel", _snapToPixel, _snapToPixel = value);
			if (_snapToPixel) {
				target.x = Math.round(target.x);
				target.y = Math.round(target.y);
				updateWidth();
				updateHeight();
			}
		}
		private var _snapToPixel:Boolean;
		
		[Bindable(event="leftChange", style="noEvent")]
		public function get left():Number { return _left; }
		public function set left(value:Number):void
		{
			DataChange.change(target, "left", _left, _left = value);
		}
		private var _left:Number;
		
		[Bindable(event="topChange", style="noEvent")]
		public function get top():Number { return _top; }
		public function set top(value:Number):void
		{
			DataChange.change(target, "top", _top, _top = value);
		}
		private var _top:Number;
		
		[Bindable(event="rightChange", style="noEvent")]
		public function get right():Number { return _right; }
		public function set right(value:Number):void
		{
			DataChange.change(target, "right", _right, _right = value);
		}
		private var _right:Number;
		
		[Bindable(event="bottomChange", style="noEvent")]
		public function get bottom():Number { return _bottom; }
		public function set bottom(value:Number):void
		{
			DataChange.change(target, "bottom", _bottom, _bottom = value);
		}
		private var _bottom:Number;
		
		[Bindable(event="hPercentChange", style="noEvent")]
		public function get hPercent():Number { return _hPercent; }
		public function set hPercent(value:Number):void
		{
			DataChange.change(target, "hPercent", _hPercent, _hPercent = value);
		}
		private var _hPercent:Number;
		
		[Bindable(event="vPercentChange", style="noEvent")]
		public function get vPercent():Number { return _vPercent; }
		public function set vPercent(value:Number):void
		{
			DataChange.change(target, "vPercent", _vPercent, _vPercent = value);
		}
		private var _vPercent:Number;
		
		[Bindable(event="hOffsetChange", style="noEvent")]
		public function get hOffset():Number { return _hOffset; }
		public function set hOffset(value:Number):void
		{
			DataChange.change(target, "hOffset", _hOffset, _hOffset = value);
		}
		private var _hOffset:Number;
		
		[Bindable(event="vOffsetChange", style="noEvent")]
		public function get vOffset():Number { return _vOffset; }
		public function set vOffset(value:Number):void
		{
			DataChange.change(target, "vOffset", _vOffset, _vOffset = value);
		}
		private var _vOffset:Number;
		
		[Bindable(event="dockChange", style="noEvent")]
		public function get dock():String { return _dock; }
		public function set dock(value:String):void
		{
			DataChange.change(target, "dock", _dock, _dock = value);
		}
		private var _dock:String;
		
		[Bindable(event="tileChange", style="noEvent")]
		public function get tile():String { return _tile; }
		public function set tile(value:String):void
		{
			DataChange.change(target, "tile", _tile, _tile = value);
		}
		private var _tile:String;
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:Bounds = new Bounds(0, 0);
		
		/**
		 * The explicitly set bounds of this bounds instance. Actual values
		 * may differ from those explicitly set based on layout adjustments.
		 */
		public function get explicit():IBounds { return _explicit; }
		private var _explicit:Bounds = new Bounds();
		
		/**
		 * Constrains a width value between minWidth and maxWidth,
		 * returning the new value.
		 * 
		 * @param		width		The source width value to be constrained.
		 * @return					The newly constrained width.
		 */
		public function constrainWidth(width:Number):Number
		{
			return (width >= _maxWidth) ? _maxWidth :
				   (width <= _minWidth) ? _minWidth : width;
		}
		
		/**
		 * Constrains a height value between minHeight and maxHeight,
		 * returning the new value.
		 * 
		 * @param		height		The source height value to be constrained.
		 * @return					The newly constrained height.
		 */
		public function constrainHeight(height:Number):Number
		{
			return (height >= _maxHeight) ? _maxHeight :
				   (height <= _minHeight) ? _minHeight : height;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		{
			if (isNaN(width)) {
				width = preferredWidth;
			}
			if (isNaN(height)) {
				height = preferredHeight;
			}
			
			var m:Matrix = target.transform.matrix;
			if (complexMatrix(m, _nativeSizing)) {
				var x:Number, y:Number;
				var minX:Number, minY:Number, maxX:Number, maxY:Number;
				
				minX = maxX = m.tx;
				minY = maxY = m.ty;
				
				x = m.a * width + m.tx;
				y = m.b * width + m.ty;
				if (x < minX) minX = x;
				else if (x > maxX) maxX = x;
				if (y < minY) minY = y;
				else if (y > maxY) maxY = y;
				
				x = m.a * width + m.c * height + m.tx;
				y = m.d * height + m.b * width + m.ty;
				if (x < minX) minX = x;
				else if (x > maxX) maxX = x;
				if (y < minY) minY = y;
				else if (y > maxY) maxY = y;
				
				x = m.c * height + m.tx;
				y = m.d * height + m.ty;
				if (x < minX) minX = x;
				else if (x > maxX) maxX = x;
				if (y < minY) minY = y;
				else if (y > maxY) maxY = y;
				
				rect.x = minX;
				rect.y = minY;
				rect.width = maxX - minX;
				rect.height = maxY - minY;
			} else {
				rect.x = m.tx;
				rect.y = m.ty;
				rect.width = width * m.a;
				rect.height = height * m.d;
			}
			return rect;
		}
		private var rect:Rectangle = new Rectangle();
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutRect(rect:Rectangle):void
		{
			var m:Matrix = target.transform.matrix;
			if (complexMatrix(m, _nativeSizing)) {
				
				var d:Number;
				d = m.a * _width + m.c * _height;
				if (d < 0) rect.x -= d;
				d = m.d * _height + m.b * _width;
				if (d < 0) rect.y -= d;
				
				if (rect.width < 0) {
					rect.width = 0;
				}
				if (rect.height < 0) {
					rect.height = 0;
				}
				m.invert();
				_layoutWidth = Math.abs(m.a * rect.width + m.c * rect.height);
				_layoutHeight = Math.abs(m.d * rect.height + m.b * rect.width);
			} else if (_nativeSizing) {
				_layoutWidth = rect.width;
				_layoutHeight = rect.height;
			} else {
				_layoutWidth = rect.width / m.a;
				_layoutHeight = rect.height / m.d;
			}
			
			if (_snapToPixel) {
				rect.x = Math.round(rect.x);
				rect.y = Math.round(rect.y);
				_layoutWidth = Math.round(_layoutWidth);
				_layoutHeight = Math.round(_layoutHeight);
			}
			
			if (_layoutWidth == preferredWidth) {
				_layoutWidth = NaN;
			}
			if (_layoutHeight == preferredHeight) {
				_layoutHeight = NaN;
			}
			
			DataChange.queue(target, "x", target.x, target.x = rect.x);
			DataChange.queue(target, "y", target.y, target.y = rect.y);
			updateWidth(true);
			updateHeight(true);
			DataChange.change();
		}
		private var _layoutWidth:Number;
		private var _layoutHeight:Number;
		
		private function complexMatrix(m:Matrix, resetScale:Boolean = false):Boolean
		{
			var complex:Boolean = m.b != 0 || m.c != 0 || m.a < 0 || m.d < 0;
			if (complex && resetScale) {
				var skewY:Number = Math.atan2(m.b, m.a);
				m.a = Math.cos(skewY);
				m.b = Math.sin(skewY);
				var skewX:Number = Math.atan2(-m.c, m.d);
				m.c = -Math.sin(skewX);
				m.d = Math.cos(skewX);
			}
			return complex;
		}
		
		private function onMeasuredChange(event:PropertyChangeEvent):void
		{
			switch (event.property) {
				case "width":
					updateWidth();
					break;
				case "height":
					updateHeight();
					break;
				case "minWidth":
					minWidth = _explicit.minWidth;
					break;
				case "minHeight":
					minHeight = _explicit.minHeight;
					break;
				case "maxWidth":
					maxWidth = _explicit.maxWidth;
					break;
				case "maxHeight":
					maxHeight = _explicit.maxHeight;
					break;
			}
		}
		
		private function updateWidth(layout:Boolean = false):void
		{
			var value:Number = constrainWidth( !isNaN(_layoutWidth) ? _layoutWidth : preferredWidth );
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_width != value) {
				if (_nativeSizing) {
					DataChange.queue(target, "scaleX", target.scaleX, target.scaleX = value / unscaledRect.width);
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "width", _width, _width = value);
				if (!layout) {
					invalidateLayout();
				}
			}
		}
		
		private function updateHeight(layout:Boolean = false):void
		{
			var value:Number = constrainHeight( !isNaN(_layoutHeight) ? _layoutHeight : preferredHeight );
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_height != value) {
				if (_nativeSizing) {
					DataChange.change(target, "scaleY", target.scaleY, target.scaleY = _height / unscaledRect.height);
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "height", _height, _height = value);
				if (!layout) {
					invalidateLayout();
				}
			}
		}
		
		
		// ====== IInvalidating implementation ====== //
		
		public function invalidateLayout(measureOnly:Boolean = false):void
		{
			if (!_freeform && target.parent) {
				Invalidation.invalidate(target.parent, LayoutEvent.MEASURE);
				if (!measureOnly) {
					Invalidation.invalidate(target.parent, LayoutEvent.LAYOUT);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidate(phase:String = null):void
		{
			Invalidation.invalidate(target, phase || InvalidationEvent.VALIDATE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(phase:String = null):void
		{
			Invalidation.validate(target, phase);
		}
		
		
		// ====== IEventDispatcher implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			target.addEventListener(type, listener,  useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			target.removeEventListener(type, listener,  useCapture);
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return target.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return target.hasEventListener(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			return target.willTrigger(type);
		}
	}
}
