/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flight.data.DataChange;
	import flight.display.IInvalidating;
	import flight.display.Invalidation;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;

	import mx.events.PropertyChangeEvent;

	dynamic public class LayoutElement implements ILayoutElement
	{
		private var target:DisplayObject;
		
		public function LayoutElement(target:DisplayObject)
		{
			this.target = target;
			target.addEventListener(LayoutEvent.MEASURE, onMeasure, false, 20);
			_measured.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onMeasuredChange);
		}
		
		[Bindable("propertyChange")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			if (!positioning) {
				_explicit.x = value;
				updateX();
			}
		}
		private var _x:Number = 0;
		
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		private var _maxWidth:Number = int.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
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
		private var _maxHeight:Number = int.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get margin():Box { return _margin || (margin = new Box()); }
		public function set margin(value:*):void
		{
			if (!(value is Box)) {
				value = Box.getInstance(value);
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
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
			if (!isNaN(_explicit.width)) {
				return _contained ? Bounds.constrainWidth(_measured, _explicit.width) : _explicit.width;
			} else {
				return _measured.width;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number
		{
			if (!isNaN(_explicit.height)) {
				return _contained ? Bounds.constrainHeight(_measured, _explicit.height) : _explicit.width;
			} else {
				return _measured.height;
			}
		}
		
		[Bindable("propertyChange")]
		public function get contentWidth():Number
		{
			if (!_contained) {
				var preferredWidth:Number = !isNaN(_contentWidth) ? Bounds.constrainWidth(_measured, _contentWidth) : _measured.width;
				if (preferredWidth > _width) {
					return preferredWidth;
				}
			}
			return _width;
		}
		public function set contentWidth(value:Number):void
		{
			if (!_contained) {
				DataChange.change(target, "contentWidth", _contentWidth, _contentWidth = value);
			} else {
				width = value;
			}
		}
		private var _contentWidth:Number = 0;
		
		[Bindable("propertyChange")]
		public function get contentHeight():Number
		{
			if (!_contained) {
				var preferredHeight:Number = !isNaN(_contentHeight) ? Bounds.constrainHeight(_measured, _contentHeight) : _measured.height;
				if (preferredHeight > _height) {
					return preferredHeight;
				}
			}
			return _height;
		}
		public function set contentHeight(value:Number):void
		{
			if (!_contained) {
				DataChange.change(target, "contentHeight", _contentHeight, _contentHeight = value);
			} else {
				height = value;
			}
		}
		private var _contentHeight:Number = 0;
		
		[Bindable("propertyChange")]
		public function get nativeRect():Rectangle { return _nativeRect; }
		private var _nativeRect:Rectangle = emptyRect;
		
		private function updateNativeRect():void
		{
			var bounds:DisplayObject;
			if (target is DisplayObjectContainer) {
				bounds = DisplayObjectContainer(target).getChildByName("bounds");
			}
			
			if (bounds) {
				bounds.visible = false;
			} else {
				bounds = target;
			}
			DataChange.change(this, "nativeRect", _nativeRect, _nativeRect = bounds.getRect(target) || emptyRect);
		}
		private static var emptyRect:Rectangle = new Rectangle();
		
		[Bindable("propertyChange")]
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
		
		[Bindable("propertyChange")]
		public function get nativeSizing():Boolean { return _nativeSizing; }
		public function set nativeSizing(value:Boolean):void
		{
			DataChange.queue(target, "nativeSizing", _nativeSizing, _nativeSizing = value);
			if (value) {
				updateNativeRect();
				if (target.scaleX != 1) {
					_measured.minWidth *= target.scaleX;
					_explicit.minWidth *= target.scaleX;
				}
				if (target.scaleY != 1) {
					_measured.minHeight *= target.scaleY;
					_explicit.minHeight *= target.scaleY;
				}
				updateWidth();
				updateHeight();
			}
			DataChange.change();
		}
		private var _nativeSizing:Boolean;
		
		[Bindable("propertyChange")]
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
		
		[Bindable("propertyChange")]
		public function get left():Number { return _left; }
		public function set left(value:Number):void
		{
			DataChange.change(target, "left", _left, _left = value);
		}
		private var _left:Number;
		
		[Bindable("propertyChange")]
		public function get top():Number { return _top; }
		public function set top(value:Number):void
		{
			DataChange.change(target, "top", _top, _top = value);
		}
		private var _top:Number;
		
		[Bindable("propertyChange")]
		public function get right():Number { return _right; }
		public function set right(value:Number):void
		{
			DataChange.change(target, "right", _right, _right = value);
		}
		private var _right:Number;
		
		[Bindable("propertyChange")]
		public function get bottom():Number { return _bottom; }
		public function set bottom(value:Number):void
		{
			DataChange.change(target, "bottom", _bottom, _bottom = value);
		}
		private var _bottom:Number;
		
		[Bindable("propertyChange")]
		public function get hPercent():Number { return _hPercent; }
		public function set hPercent(value:Number):void
		{
			DataChange.change(target, "hPercent", _hPercent, _hPercent = value);
		}
		private var _hPercent:Number;
		
		[Bindable("propertyChange")]
		public function get vPercent():Number { return _vPercent; }
		public function set vPercent(value:Number):void
		{
			DataChange.change(target, "vPercent", _vPercent, _vPercent = value);
		}
		private var _vPercent:Number;
		
		[Bindable("propertyChange")]
		public function get hOffset():Number { return _hOffset; }
		public function set hOffset(value:Number):void
		{
			DataChange.change(target, "hOffset", _hOffset, _hOffset = value);
		}
		private var _hOffset:Number;
		
		[Bindable("propertyChange")]
		public function get vOffset():Number { return _vOffset; }
		public function set vOffset(value:Number):void
		{
			DataChange.change(target, "vOffset", _vOffset, _vOffset = value);
		}
		private var _vOffset:Number;
		
		[Bindable("propertyChange")]
		public function get dock():String { return _dock; }
		public function set dock(value:String):void
		{
			DataChange.change(target, "dock", _dock, _dock = value);
		}
		private var _dock:String;
		
		[Bindable("propertyChange")]
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
			if (resetScale) {
				if (complex) {
					var skewY:Number = Math.atan2(m.b, m.a);
					m.a = Math.cos(skewY);
					m.b = Math.sin(skewY);
					var skewX:Number = Math.atan2(-m.c, m.d);
					m.c = -Math.sin(skewX);
					m.d = Math.cos(skewX);
				} else {
					m.a = m.d = 1;
				}
			}
			return complex;
		}
		
		private function onMeasuredChange(event:PropertyChangeEvent):void
		{
			switch (event.property) {
				case "width": updateWidth(); break;
				case "height": updateHeight(); break;
				default: this[event.property] = _explicit[event.property];
			}
		}
		
		private function onMeasure(event:LayoutEvent):void
		{
			updateNativeRect();
		}
		
		private function updateX():void
		{
			var value:Number = !isNaN(layoutRect.x) ? layoutRect.x : _explicit.x;
			if (_snapToPixel) {
				value = Math.round(value);
			}
			if (_x != value) {
				positioning = true;
				target.x = _x = value;
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
					target.scaleX = _nativeRect.width ? value / _nativeRect.width : 1;
				}
				invalidate(LayoutEvent.RESIZE);
				if (_contained) {
					DataChange.queue(target, "contentWidth", _width, value);
				}
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
					target.scaleY = _nativeRect.height ? value / _nativeRect.height : 1;
				}
				invalidate(LayoutEvent.RESIZE);
				if (_contained) {
					DataChange.queue(target, "contentHeight", _height, value);
				}
				DataChange.change(target, "height", _height, _height = value);
			}
		}
		
		
		// ====== IInvalidating implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function invalidate(phase:String = null):void
		{
			if (target is IInvalidating) {
				IInvalidating(target).invalidate(phase);
			} else {
				Invalidation.invalidate(target, phase || InvalidationEvent.VALIDATE);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(phase:String = null):void
		{
			Invalidation.validateNow(target, phase);
		}
		
		
		// ====== IEventDispatcher implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			target.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			target.removeEventListener(type, listener, useCapture);
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
