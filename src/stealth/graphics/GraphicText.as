/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;

	import flight.collections.ArrayList;
	import flight.data.DataChange;
	import flight.events.InitializeEvent;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.IBounds;
	import flight.utils.Invalidation;

	import mx.core.IMXMLObject;

	import stealth.layouts.Box;
	import stealth.layouts.LayoutElement;

	[Event(name="ready", type="flight.events.InitializeEvent")]
	[Event(name="create", type="flight.events.InitializeEvent")]
	[Event(name="destroy", type="flight.events.InitializeEvent")]
	
	/**
	 * A generic shape element providing position, size and transformation.
	 * GraphicShape inherits basic drawing Shape.
	 */
	public class GraphicText extends TextField implements IGraphicElement, IMXMLObject
	{
		public function GraphicText()
		{
			_filters.addEventListener(ListEvent.LIST_CHANGE, refreshFilters);
			_filters.addEventListener(ListEvent.ITEM_CHANGE, refreshFilters);
			
			layoutElement = new LayoutElement(this);
			addEventListener(LayoutEvent.RESIZE, onResize);
			addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10);
			addEventListener(Event.CHANGE, onTextChange);
			measure();
			
			addEventListener(Event.ADDED, onFirstAdded, false, 10);
			addEventListener(InitializeEvent.CREATE, onCreate, false, 10);
			addEventListener(InitializeEvent.DESTROY, onDestroy, false, 10);
			invalidate(InitializeEvent.CREATE);
			invalidate(InitializeEvent.READY);
			init();
		}
		
		
		// ====== IGraphicElement implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="idChange", style="noEvent")]
		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			DataChange.change(this, "id", _id, super.name = _id = value);
		}
		private var _id:String;
		
		/**
		 * @inheritDoc
		 */
		override public function set name(value:String):void
		{
			id = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="visibleChange", style="noEvent")]
		override public function set visible(value:Boolean):void
		{
			DataChange.change(this, "visible", super.visible, super.visible = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="alphaChange", style="noEvent")]
		override public function set alpha(value:Number):void
		{
			DataChange.change(this, "alpha", super.alpha, super.alpha = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maskChange", style="noEvent")]
		override public function set mask(value:DisplayObject):void
		{
			DataChange.change(this, "mask", super.mask, super.mask = value);
		}
		
		[Bindable(event="maskTypeChange", style="noEvent")]
		public function get maskType():String { return _maskType; }
		public function set maskType(value:String):void
		{
			DataChange.change(this, "maskType", _maskType, _maskType = value);
		}
		private var _maskType:String = "default";
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="blendModeChange", style="noEvent")]
		override public function set blendMode(value:String):void
		{
			DataChange.change(this, "blendMode", super.blendMode, super.blendMode = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.filters.BitmapFilter")]
		[Bindable(event="filtersChange", style="noEvent")]
		override public function get filters():Array { return _filters as Array; }
		override public function set filters(value:Array):void
		{
			_filters.queueChanges = true;
			_filters.removeAt();
			if (value) {
				_filters.add(value);
			}
			_filters.queueChanges = false;
		}
		private var _filters:ArrayList = new ArrayList();
		
		private function refreshFilters(event:ListEvent):void
		{
			super.filters = _filters;
		}
		
		
		// ====== ITransform implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="xChange", style="noEvent")]
		override public function set x(value:Number):void
		{
			DataChange.change(this, "x", super.x, super.x = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="yChange", style="noEvent")]
		override public function set y(value:Number):void
		{
			DataChange.change(this, "y", super.y, super.y = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="transformXChange", style="noEvent")]
		public function get transformX():Number { return _transformX; }
		public function set transformX(value:Number):void
		{
			DataChange.change(this, "transformX", _transformX, _transformX = value);
		}
		private var _transformX:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="transformYChange", style="noEvent")]
		public function get transformY():Number { return _transformY; }
		public function set transformY(value:Number):void
		{
			DataChange.change(this, "transformY", _transformY, _transformY = value);
		}
		private var _transformY:Number = 0;
		
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="scaleXChange", style="noEvent")]
		override public function set scaleX(value:Number):void
		{
			if (super.scaleX != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					DataChange.queue(this, "scaleX", super.scaleX, super.scaleX = value);
					updateTransform(oldMatrix);
				} else {
					 DataChange.change(this, "scaleX", super.scaleX, super.scaleX = value);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="scaleYChange", style="noEvent")]
		override public function set scaleY(value:Number):void
		{
			if (super.scaleY != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					DataChange.queue(this, "scaleY", super.scaleY, super.scaleY = value);
					updateTransform(oldMatrix);
				} else {
					DataChange.change(this, "scaleY", super.scaleY, super.scaleY = value);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		
		[Bindable(event="rotationChange", style="noEvent")]
		public function get skewX():Number
		{
			var matrix:Matrix = transform.matrix;
			return Math.atan2(-matrix.c, matrix.d) * (180/Math.PI);
		}
		public function set skewX(value:Number):void
		{
			var oldValue:Number = super.rotation;
			value *= Math.PI/180;
			var matrix:Matrix = transform.matrix;
			matrix.c = scaleY * -Math.sin(value);
			matrix.d = scaleY * Math.cos(value);
			transform.matrix = matrix;
			if (_transformX || _transformY) {
				var oldMatrix:Matrix = transform.matrix;
				DataChange.queue(this, "rotation", oldValue, super.rotation);
				updateTransform(oldMatrix);
			} else {
				DataChange.change(this, "rotation", oldValue, super.rotation);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="rotationChange", style="noEvent")]
		public function get skewY():Number
		{
			var matrix:Matrix = transform.matrix;
			return Math.atan2(matrix.b, matrix.a) * (180/Math.PI);
		}
		public function set skewY(value:Number):void
		{
			var oldValue:Number = super.rotation;
			value *= Math.PI/180;
			var matrix:Matrix = transform.matrix;
			matrix.a = scaleX * Math.cos(value);
			matrix.b = scaleX * Math.sin(value);
			transform.matrix = matrix;
			if (_transformX || _transformY) {
				var oldMatrix:Matrix = transform.matrix;
				DataChange.queue(this, "rotation", oldValue, super.rotation);
				updateTransform(oldMatrix);
			} else {
				DataChange.change(this, "rotation", oldValue, super.rotation);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="rotationChange", style="noEvent")]
		override public function set rotation(value:Number):void
		{
			if (super.rotation != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					DataChange.queue(this, "rotation", super.rotation, super.rotation = value);
					updateTransform(oldMatrix);
				} else {
					DataChange.change(this, "rotation", super.rotation, super.rotation = value);
				}
			}
		}
		
		private function updateTransform(oldMatrix:Matrix):void
		{
			// TODO: research simpler algorithm (concat matrices)
			var anchorX:Number = oldMatrix.a * _transformX + oldMatrix.c * _transformY + oldMatrix.tx;
			var anchorY:Number = oldMatrix.d * _transformY + oldMatrix.b * _transformX + oldMatrix.ty;
			
			var newMatrix:Matrix = transform.matrix;
			anchorX -= newMatrix.a * _transformX + newMatrix.c * _transformY + newMatrix.tx;
			anchorY -= newMatrix.d * _transformY + newMatrix.b * _transformX + newMatrix.ty;
			
			DataChange.queue(this, "x", super.x, super.x += anchorX);
			DataChange.change(this, "y", super.y, super.y += anchorY);
		}
		
		
		// ====== ILayoutBounds implementation ====== //
		
		protected var layoutElement:LayoutElement;
		
		[Bindable(event="snapToPixelChange", style="noEvent")]
		public function get snapToPixel():Boolean { return layoutElement.snapToPixel; }
		public function set snapToPixel(value:Boolean):void { layoutElement.snapToPixel = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="freeformChange", style="noEvent")]
		public function get freeform():Boolean { return layoutElement.freeform; }
		public function set freeform(value:Boolean):void { layoutElement.freeform = value; }
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange", style="noEvent")]
		override public function get width():Number { return layoutElement.width; }
		override public function set width(value:Number):void { layoutElement.width = value; }
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", style="noEvent")]
		override public function get height():Number { return layoutElement.height; }
		override public function set height(value:Number):void { layoutElement.height = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minWidthChange", style="noEvent")]
		public function get minWidth():Number { return layoutElement.minWidth; }
		public function set minWidth(value:Number):void { layoutElement.minWidth = value; } 
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minHeightChange", style="noEvent")]
		public function get minHeight():Number { return layoutElement.minHeight; }
		public function set minHeight(value:Number):void { layoutElement.minHeight = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxWidthChange", style="noEvent")]
		public function get maxWidth():Number { return layoutElement.maxWidth; }
		public function set maxWidth(value:Number):void { layoutElement.maxWidth = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxHeightChange", style="noEvent")]
		public function get maxHeight():Number { return layoutElement.maxHeight; }
		public function set maxHeight(value:Number):void { layoutElement.maxHeight = value; }
		
		/**
		 * The space surrounding the layout, relative to the local coordinates
		 * of the parent. The space is defined as a box with left, top, right
		 * and bottom coordinates.
		 */
		[Bindable(event="marginChange", style="noEvent")]
		public function get margin():Box { return layoutElement.margin; }
		public function set margin(value:*):void { layoutElement.margin = value; }
		
		/**
		 * The width of the bounds as a percentage of the parent's total size,
		 * relative to the local coordinates of the parent. The percentWidth
		 * is a value from 0 to 1, where 1 equals 100% of the parent's
		 * total size.
		 * 
		 * @default		NaN
		 */
		[Bindable(event="percentWidthChange", style="noEvent")]
		public function get percentWidth():Number { return layoutElement.percentWidth; }
		public function set percentWidth(value:Number):void { layoutElement.percentWidth = value; }
		
		/**
		 * The height of the bounds as a percentage of the parent's total size,
		 * relative to the local coordinates of the parent. The percentHeight
		 * is a value from 0 to 1, where 1 equals 100% of the parent's
		 * total size.
		 * 
		 * @default		NaN
		 */
		[Bindable(event="percentHeightChange", style="noEvent")]
		public function get percentHeight():Number { return layoutElement.percentHeight; }
		public function set percentHeight(value:Number):void { layoutElement.percentHeight = value; }
		
		[Bindable(event="leftChange", style="noEvent")]
		public function get left():Number { return layoutElement.left; }
		public function set left(value:Number):void { layoutElement.left = value; }
		
		[Bindable(event="topChange", style="noEvent")]
		public function get top():Number { return layoutElement.top; }
		public function set top(value:Number):void { layoutElement.top = value; }
		
		[Bindable(event="rightChange", style="noEvent")]
		public function get right():Number { return layoutElement.right; }
		public function set right(value:Number):void { layoutElement.right = value; }
		
		[Bindable(event="bottomChange", style="noEvent")]
		public function get bottom():Number { return layoutElement.bottom; }
		public function set bottom(value:Number):void { layoutElement.bottom = value; }
		
		[Bindable(event="hPercentChange", style="noEvent")]
		public function get hPercent():Number { return layoutElement.hPercent; }
		public function set hPercent(value:Number):void { layoutElement.hPercent = value; }
		
		[Bindable(event="vPercentChange", style="noEvent")]
		public function get vPercent():Number { return layoutElement.vPercent; }
		public function set vPercent(value:Number):void { layoutElement.vPercent = value; }
		
		[Bindable(event="hOffsetChange", style="noEvent")]
		public function get hOffset():Number { return layoutElement.hOffset; }
		public function set hOffset(value:Number):void { layoutElement.hOffset = value; }
		
		[Bindable(event="vOffsetChange", style="noEvent")]
		public function get vOffset():Number { return layoutElement.vOffset; }
		public function set vOffset(value:Number):void { layoutElement.vOffset = value; }
		
		[Bindable(event="dockChange", style="noEvent")]
		public function get dock():String { return layoutElement.dock; }
		public function set dock(value:String):void { layoutElement.dock = value; }
		
		[Bindable(event="alignChange", style="noEvent")]
		public function get align():String { return layoutElement.align; }
		public function set align(value:String):void { layoutElement.align = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get explicit():IBounds { return layoutElement.explicit; }
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return layoutElement.measured; }
		
		/**
		 * @inheritDoc
		 */
		public function constrainWidth(width:Number):Number
		{
			return layoutElement.constrainWidth(width);
		}
		
		/**
		 * @inheritDoc
		 */
		public function constrainHeight(height:Number):Number
		{
			return layoutElement.constrainHeight(height);
		}
		/**
		 * @inheritDoc
		 */
		public function setLayoutRect(rect:Rectangle):void
		{
			layoutElement.setLayoutRect(rect);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		{
			return layoutElement.getLayoutRect(width, height);
		}
		
		protected function measure():void
		{
			var metrics:TextLineMetrics = getLineMetrics(0);
			measured.width = metrics.width;
			measured.height = metrics.height;
		}
		
		private function onMeasure(event:LayoutEvent):void
		{
			measure();
		}
		
		private function onTextChange(event:Event):void
		{
			invalidate(LayoutEvent.MEASURE);
		}
		
		private function onResize(event:LayoutEvent):void
		{
			super.width = width;
			super.height = height;
		}
		
		// ====== IMXML implementation ====== //
		
		/**
		 * Specialized method for MXML, called after the display has been
		 * created and all of its properties specified in MXML have been
		 * initialized.
		 * 
		 * @param		document	The MXML document defining this display.
		 * @param		id			The identifier used by <code>document</code>
		 * 							to refer to this display, or its instance
		 * 							name.
		 */
		public function initialized(document:Object, id:String):void
		{
			this.id = super.name = id;
		}
		
		
		// ====== IInvalidating implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function invalidate(phase:String = null):void
		{
			Invalidation.invalidate(this, phase || InvalidationEvent.VALIDATE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(phase:String = null):void
		{
			Invalidation.validate(this, phase);
		}
		
		
		// ====== Lifecycle methods ====== //
		
		public function kill():void
		{
			if (created) {
				created = false;
				destroy();
			}
		}
		protected var created:Boolean;
		
		protected function init():void
		{
		}
		
		protected function create():void
		{
		}
		
		protected function destroy():void
		{
		}
		
		private function onFirstAdded(event:Event):void
		{
			removeEventListener(Event.ADDED, onFirstAdded);
			validateNow(InitializeEvent.CREATE);
		}
		
		private function onCreate(event:InitializeEvent):void
		{
			create();
			created = true;
		}
		
		private function onDestroy(event:InitializeEvent):void
		{
			kill();
		}
	}
}
