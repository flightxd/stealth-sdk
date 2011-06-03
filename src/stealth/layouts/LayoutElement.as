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
		
		[Bindable(event="xChange", style="noEvent")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			if (!positioning) {
				_explicit.x = value;
				updateX();
			}
		}
		private var _x:Number = 0;
		
		[Bindable(event="yChange", style="noEvent")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			if (!positioning) {
				_explicit.y = value;
				updateY();
			}
		}
		private var _y:Number = 0;
		
		
		// ====== ILayoutBounds implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="freeformChange", style="noEvent")]
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			if (value) {
				layoutRect.width = layoutRect.height = NaN;
				updateWidth();
				updateHeight();
			}
			DataChange.change(target, "freeform", _freeform, _freeform = value);
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
				value = Bounds.constrainWidth(_measured, value);
			}
			if (_minWidth != value) {
				DataChange.queue(target, "minWidth", _minWidth, _minWidth = value);
				updateWidth();
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
				value = Bounds.constrainHeight(_measured, value);
			}
			if (_minHeight != value) {
				DataChange.queue(target, "minHeight", _minHeight, _minHeight = value);
				updateHeight();
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
				value = Bounds.constrainWidth(_measured, value);
			}
			if (_maxWidth != value) {
				DataChange.queue(target, "maxWidth", _maxWidth, _maxWidth = value);
				updateWidth();
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
				value = Bounds.constrainHeight(_measured, value);
			}
			if (_maxHeight != value) {
				DataChange.queue(target, "maxHeight", _maxHeight, _maxHeight = value);
				updateHeight();
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
				_margin.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMarginChange);
			}
			DataChange.change(target, "margin", _margin, _margin = value);
			if (_margin) {
				_margin.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMarginChange);
			}
		}
		private var _margin:Box;
		
		private function onMarginChange(event:Event):void
		{
			DataChange.change(target, "margin", _margin, _margin, true);
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
		}
		private var _percentHeight:Number;
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number
		{
			return !isNaN(explicit.width) ? Bounds.constrainWidth(_measured, explicit.width) : measured.width;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			return !isNaN(explicit.height) ? Bounds.constrainHeight(_measured, explicit.height) : measured.height;
		}
		
		[Bindable(event="contentWidthChange", style="noEvent")]
		public function get contentWidth():Number
		{
			if (!contained) {
				var preferredWidth:Number = !isNaN(_contentWidth) ? Bounds.constrainWidth(_measured, _contentWidth) : measured.width;
				if (preferredWidth > _width) {
					return preferredWidth;
				}
			}
			return _width;
		}
		public function set contentWidth(value:Number):void
		{
			if (!contained) {
				DataChange.change(target, "contentWidth", _contentWidth, _contentWidth = value);
			} else {
				width = value;
			}
		}
		private var _contentWidth:Number = 0;
		
		[Bindable(event="contentHeightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			if (!contained) {
				var preferredHeight:Number = !isNaN(_contentHeight) ? Bounds.constrainHeight(_measured, _contentHeight) : measured.height;
				if (preferredHeight > _height) {
					return preferredHeight;
				}
			}
			return _height;
		}
		public function set contentHeight(value:Number):void
		{
			if (!contained) {
				DataChange.change(target, "contentHeight", _contentHeight, _contentHeight = value);
			} else {
				height = value;
			}
		}
		private var _contentHeight:Number = 0;
		
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
		public function getLayoutRect(w:Number = NaN, h:Number = NaN):Rectangle
		{
			if (isNaN(w)) {
				w = preferredWidth;
			}
			if (isNaN(h)) {
				h = preferredHeight;
			}
			
			var m:Matrix = target.transform.matrix;
			m.tx = _explicit.x;
			m.ty = _explicit.y;
			if (complexMatrix(m, _nativeSizing)) {
				var x:Number, y:Number;
				var minX:Number, minY:Number, maxX:Number, maxY:Number;
				
				minX = maxX = m.tx;
				minY = maxY = m.ty;
				
				x = m.a * w + m.tx;
				y = m.b * w + m.ty;
				if (x < minX) minX = x;
				else if (x > maxX) maxX = x;
				if (y < minY) minY = y;
				else if (y > maxY) maxY = y;
				
				x = m.a * w + m.c * h + m.tx;
				y = m.d * h + m.b * w + m.ty;
				if (x < minX) minX = x;
				else if (x > maxX) maxX = x;
				if (y < minY) minY = y;
				else if (y > maxY) maxY = y;
				
				x = m.c * h + m.tx;
				y = m.d * h + m.ty;
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
				rect.width = w * m.a;
				rect.height = h * m.d;
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
			var complex:Boolean = complexMatrix(m, _nativeSizing);
			
			// first fully set layout size
			if (complex) {
				var i:Matrix = new Matrix(m.a, m.b, m.c, m.d, m.tx, m.ty);
				i.invert();
				var w:Number = rect.width < 0 ? 0 : rect.width;
				var h:Number = rect.height < 0 ? 0 : rect.height;
				rect.width = Math.abs(i.a * w + i.c * h);
				rect.height = Math.abs(i.d * h + i.b * w);
			} else {
				rect.width = rect.width / m.a;
				rect.height = rect.height / m.d;
			}
			layoutRect.width = rect.width == preferredWidth ? NaN : rect.width;
			layoutRect.height = rect.height == preferredHeight ? NaN : rect.height;
			updateWidth();
			updateHeight();
			
			// now set layout position
			if (complex) {
				var d:Number;
				d = m.a * _width + m.c * _height;
				if (d < 0) rect.x = rect.x - d;
				d = m.d * _height + m.b * _width;
				if (d < 0) rect.y = rect.y - d;
			}
			layoutRect.x = rect.x == _explicit.x ? NaN : rect.x;
			layoutRect.y = rect.y == _explicit.y ? NaN : rect.y;
			updateX();
			updateY();
		}
		private var layoutRect:Rectangle = new Rectangle(NaN, NaN, NaN, NaN);
		private var positioning:Boolean;
		
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
		
		private function updateX():void
		{
			var value:Number = !isNaN(layoutRect.x) ? layoutRect.x : _explicit.x;
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_x != value) {
				positioning = true;
				DataChange.change(target, "x", _x, target.x = _x = value);
				positioning = false;
			}
		}
		
		private function updateY():void
		{
			var value:Number = !isNaN(layoutRect.y) ? layoutRect.y : _explicit.y;
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_y != value) {
				positioning = true;
				DataChange.change(target, "y", _y, target.y = _y = value);
				positioning = false;
			}
		}
		
		private function updateWidth():void
		{
			var value:Number = constrainWidth( !isNaN(layoutRect.width) ? layoutRect.width : preferredWidth );
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_width != value) {
				if (_nativeSizing) {
					target.scaleX = value / unscaledRect.width;
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "width", _width, _width = value);
			}
		}
		
		private function updateHeight():void
		{
			var value:Number = constrainHeight( !isNaN(layoutRect.height) ? layoutRect.height : preferredHeight );
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_height != value) {
				if (_nativeSizing) {
					target.scaleY = _height / unscaledRect.height;
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "height", _height, _height = value);
			}
		}
		
		
		// ====== IInvalidating implementation ====== //
		
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
