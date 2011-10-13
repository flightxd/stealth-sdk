/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import flight.events.PropertyEvent;

	/**
	 * The Bounds class holds values related to a object's dimensions.
	 */
	public class Bounds extends EventDispatcher implements IBounds
	{
		/**
		 * Constructor.
		 * 
		 * @param		width		The initial width of this bounds instance.
		 * @param		height		The initial height of this bounds instance.
		 */
		public function Bounds(width:Number = NaN, height:Number = NaN)
		{
			_width = width;
			_height = height;
		}
		
		/**
		 * The horizontal position of the bounds.
		 * 
		 * @default		0
		 */
		[Bindable("propertyChange")]
		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			PropertyEvent.change(this, "x", _x, _x = value);
		}
		private var _x:Number = 0;
		
		/**
		 * The vertical position of the bounds.
		 * 
		 * @default		0
		 */
		[Bindable("propertyChange")]
		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			PropertyEvent.change(this, "y", _y, _y = value);
		}
		private var _y:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			value = constrainWidth(this, value);
			PropertyEvent.change(this, "width", _width, _width = value);
		}
		private var _width:Number;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			value = constrainHeight(this, value);
			PropertyEvent.change(this, "height", _height, _height = value);
		}
		private var _height:Number;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			if (_maxWidth < value) {
				PropertyEvent.queue(this, "maxWidth", _maxWidth, _maxWidth = value);
			}
			PropertyEvent.queue(this, "minWidth", _minWidth, _minWidth = value);
			width = _width;
		}
		private var _minWidth:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			if (_maxHeight < value) {
				PropertyEvent.queue(this, "maxHeight", _maxHeight, _maxHeight = value);
			}
			PropertyEvent.queue(this, "minHeight", _minHeight, _minHeight = value);
			height = _height;
		}
		private var _minHeight:Number = 0;
			
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void
		{
			if (_minWidth > value) {
				PropertyEvent.queue(this, "minWidth", _minWidth, _minWidth = value);
			}
			PropertyEvent.queue(this, "maxWidth", _maxWidth, _maxWidth = value);
			width = _width;
		}
		private var _maxWidth:Number = int.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void
		{
			if (_minHeight > value) {
				PropertyEvent.queue(this, "minHeight", _minHeight, _minHeight = value);
			}
			PropertyEvent.queue(this, "maxHeight", _maxHeight, _maxHeight = value);
			height = _height;
		}
		private var _maxHeight:Number = int.MAX_VALUE;
		
		public function getRect(rect:Rectangle = null):Rectangle
		{
			if (!rect) {
				rect = new Rectangle();
			}
			rect.x = _x;
			rect.y = _y;
			rect.width = _width;
			rect.height = _height;
			return rect;
		}
		
		public function setRect(rect:Rectangle):void
		{
			x = rect.x;
			y = rect.y;
			width = rect.width;
			height = rect.height;
		}
		
		public function equalsRect(rect:Rectangle):Boolean
		{
			return (_x == rect.x &&
					_y == rect.y &&
					_width == rect.width &&
					_height == rect.height);
		}
		
		override public function toString():String
		{
			return '[object Bounds(x="' + _x + '", y="' + _y +
					'", width="' + _width + '", height="' + _height +
					'", minWidth="' + _minWidth + '", minHeight="' + _minHeight +
					'", maxWidth="' + _maxWidth + '", maxHeight="' + _maxHeight + '")]';
		}
		
		
		/**
		 * Constrains a width value between target bounds minWidth and
		 * maxWidth, returning the new value.
		 * 
		 * @param		bounds		The target bounds to use as the constraint.
		 * @param		width		The source width value to be constrained.
		 * @return					The newly constrained width.
		 */
		public static function constrainWidth(bounds:IBounds, width:Number):Number
		{
			return (width >= bounds.maxWidth) ? bounds.maxWidth :
				   (width <= bounds.minWidth) ? bounds.minWidth : width;
		}
		
		/**
		 * Constrains a height value between target bounds minHeight and
		 * maxHeight, returning the new value.
		 * 
		 * @param		bounds		The target bounds to use as the constraint.
		 * @param		height		The source height value to be constrained.
		 * @return					The newly constrained height.
		 */
		public static function constrainHeight(bounds:IBounds, height:Number):Number
		{
			return (height >= bounds.maxHeight) ? bounds.maxHeight :
				   (height <= bounds.minHeight) ? bounds.minHeight : height;
		}
		
		public static function reset(bounds:IBounds):void
		{
			bounds.maxWidth = bounds.maxHeight = int.MAX_VALUE;
			bounds.minWidth = bounds.minHeight = 0;
			bounds.width = bounds.height = 0;
		}
		
		public static function lockAspectRatio(bounds:IBounds, aspectRatio:Number = NaN):void
		{
			if (isNaN(aspectRatio)) {
				aspectRatio = bounds.width == bounds.height ? 1 : bounds.width / bounds.height;
			}
			aspectRatios[bounds] = aspectRatio;
			IEventDispatcher(bounds).addEventListener(PropertyEvent.PROPERTY_CHANGE, onBoundsChange, false, 20, true);
		}
		
		public static function unlockAspectRatio(bounds:IBounds):void
		{
			IEventDispatcher(bounds).removeEventListener(PropertyEvent.PROPERTY_CHANGE, onBoundsChange);
		}
		
		private static function onBoundsChange(event:PropertyEvent):void
		{
			if (!boundsChanging) {
				boundsChanging = true;
				var bounds:IBounds = IBounds(event.source);
				var aspectRatio:Number = aspectRatios[bounds];
				switch (event.property) {
					case "width": bounds.height = bounds.width / aspectRatio; break;
					case "height": bounds.width = bounds.height * aspectRatio; break;
					case "minWidth": bounds.minHeight = bounds.minWidth / aspectRatio; break;
					case "minHeight": bounds.minWidth = bounds.minHeight * aspectRatio; break;
					case "maxWidth": bounds.maxHeight = bounds.maxWidth / aspectRatio; break;
					case "maxHeight": bounds.maxWidth = bounds.maxHeight * aspectRatio; break;
				}
				boundsChanging = false;
			} else {
				event.stopImmediatePropagation();
			}
		}
		private static var boundsChanging:Boolean;
		private static var aspectRatios:Dictionary = new Dictionary(true);
	}
}
