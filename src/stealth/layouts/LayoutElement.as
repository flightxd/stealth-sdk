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
	import flash.utils.getQualifiedClassName;

	import flight.data.DataChange;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.utils.Invalidation;

	import mx.events.PropertyChangeEvent;

	// TODO? refactor to extend an Extension (or Trait, MixIn, Behavior, etc) class
	public class LayoutElement implements ILayoutBounds
	{
		public var target:DisplayObject
		
		public function LayoutElement(target:DisplayObject)
		{
			this.target = target;
			_measured.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMeasuredChange);
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
		
		// TODO: implement multi-density behavior...
		[Bindable(event="snapToPixelChange", style="noEvent")]
		public function get snapToPixel():Boolean { return _snapToPixel; }
		public function set snapToPixel(value:Boolean):void
		{
			DataChange.change(target, "snapToPixel", _snapToPixel, _snapToPixel = value);
			if (_snapToPixel) {
				x = Math.round(super.x);
				y = Math.round(super.y);
				updateWidth();
				updateHeight();
			}
		}
		private var _snapToPixel:Boolean;
		
		
		// ====== ILayoutElement implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="freeformChange", style="noEvent")]
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			if (value) {
				if (!isNaN(_layoutWidth)) {
					_layoutWidth = NaN;
					updateWidth();
				}
				if (!isNaN(_layoutWidth)) {
					_layoutHeight = NaN;
					updateHeight();
				}
			}
			DataChange.change(target, "freeform", _freeform, _freeform = value);
		}
		private var _freeform:Boolean = false;
		
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

		/**
		 * @inheritDoc
		 */
		[Bindable(event="xChange", style="noEvent")]
		public function get x():Number { return target.x; }
		public function set x(value:Number):void
		{
			DataChange.change(target, "x", target.x, target.x = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="yChange", style="noEvent")]
		public function get y():Number { return target.y; }
		public function set y(value:Number):void
		{
			DataChange.change(target, "y", target.y, target.y = value);
		}
		
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
			}
		}
		private var _maxWidth:Number = 0;
		
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
			}
		}
		private var _maxHeight:Number = 0;
		
		/**
		 * The space surrounding the layout, relative to the local coordinates
		 * of the parent. The space is defined as a box with left, top, right
		 * and bottom coordinates.
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
		
		private function onMarginChange(event:PropertyChangeEvent):void
		{
			DataChange.change(target, "margin", _margin, _margin, true);
		}
		
		/**
		 * The width of the bounds as a percentage of the parent's total size,
		 * relative to the local coordinates of the parent. The percentWidth
		 * is a value from 0 to 1, where 1 equals 100% of the parent's
		 * total size.
		 * 
		 * @default		NaN
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
		 * The height of the bounds as a percentage of the parent's total size,
		 * relative to the local coordinates of the parent. The percentHeight
		 * is a value from 0 to 1, where 1 equals 100% of the parent's
		 * total size.
		 * 
		 * @default		NaN
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
		
		[Bindable(event="alignChange", style="noEvent")]
		public function get align():String { return _align; }
		public function set align(value:String):void
		{
			DataChange.change(target, "align", _align, _align = value);
		}
		private var _align:String;
		
		/**
		 * @inheritDoc
		 */
		public function get explicit():IBounds { return _explicit; }
		private var _explicit:Bounds = new Bounds();
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:Bounds = new Bounds(0, 0);
		
		/**
		 * @inheritDoc
		 */
		public function constrainWidth(width:Number):Number
		{
			return (width >= _maxWidth) ? _maxWidth :
				   (width <= _minWidth) ? _minWidth : width;
		}
		
		/**
		 * @inheritDoc
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
				width = !isNaN(explicit.width) ? explicit.width : measured.width;
			}
			if (isNaN(height)) {
				height = !isNaN(explicit.height) ? explicit.height : measured.height;
			}
			
			var m:Matrix = target.transform.matrix;
			var complexMatrix:Boolean = m.b != 0 || m.c != 0 || m.a < 0 || m.d < 0;
			if (complexMatrix) {
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
			var complexMatrix:Boolean = m.b != 0 || m.c != 0 || m.a < 0 || m.d < 0;
			if (_nativeSizing) {
				// reset matrix scale back to 1 but keep rotation
				if (complexMatrix) {
					var skewX:Number = Math.atan2(-m.c, m.d);
					var skewY:Number = Math.atan2(m.b, m.a);
					m.b = Math.sin(skewY);
					m.c = -Math.sin(skewX);
				}
				m.a = 1;
				m.d = 1;
			}
			
			if (complexMatrix) {
				var d:Number;
				d = m.a * _width + m.c * _height;
				if (d < 0) rect.x -= d;
				d = m.d * _height + m.b * _width;
				if (d < 0) rect.y -= d;
			}
			
			if (_snapToPixel) {
				rect.x = Math.round(rect.x);
				rect.y = Math.round(rect.y);
			}
			DataChange.queue(target, "x", target.x, target.x = rect.x);
			DataChange.change(target, "y", target.y, target.y = rect.y);
			
			// setLayoutSize....
			if (complexMatrix) {
				m.invert();
				
				if (rect.width < 0) {
					rect.width = 0;
				}
				if (rect.height < 0) {
					rect.height = 0;
				}
				_layoutWidth = Math.abs(m.a * rect.width + m.c * rect.height);
				_layoutHeight = Math.abs(m.d * rect.height + m.b * rect.width);
			} else if (_nativeSizing) {
				_layoutWidth = rect.width;
				_layoutHeight = rect.height;
			} else {
				_layoutWidth = rect.width / target.scaleX;
				_layoutHeight = rect.height / target.scaleY;
			}
			
//			if (_layoutWidth == preferredWidth) {
//				_layoutWidth = NaN;
//			}
//			if (_layoutHeight == preferredHeight) {
//				_layoutHeight = NaN;
//			}
			updateWidth();
			updateHeight();
		}
		private var _layoutWidth:Number;
		private var _layoutHeight:Number;
		
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
		
		private function updateWidth():void
		{
			var value:Number = _measured.width;
			if (!isNaN(_layoutWidth)) {
				value = constrainWidth(_layoutWidth);
			} else if (!isNaN(_explicit.width)) {
				value = constrainWidth(_explicit.width);
			}
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_width != value) {
				if (_nativeSizing) {
					DataChange.queue(target, "scaleX", super.scaleX, super.scaleX = value / unscaledRect.width);
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "width", _width, _width = value);
			}
		}
		
		private function updateHeight():void
		{
			var value:Number = _measured.height;
			if (!isNaN(_layoutHeight)) {
				value = constrainHeight(_layoutHeight);
			} else if (!isNaN(_explicit.height)) {
				value = constrainHeight(_explicit.height);
			}
			
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_height != value) {
				if (_nativeSizing) {
					DataChange.change(target, "scaleY", super.scaleY, super.scaleY = _height / unscaledRect.height);
				}
				invalidate(LayoutEvent.RESIZE);
				DataChange.change(target, "height", _height, _height = value);
			}
		}
		
		
		// ====== IEventDispatcher implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			var className:String = getQualifiedClassName(this).split("::").pop();
			throw new Error("Adding an event listener through " + className + " is now allowed.");
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			var className:String = getQualifiedClassName(this).split("::").pop();
			throw new Error("Removing an event listener through " + className + " is now allowed.");
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
