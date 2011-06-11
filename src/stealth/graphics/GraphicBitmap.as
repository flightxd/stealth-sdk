/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import flight.data.DataChange;
	import flight.display.Bitmap;
	import flight.events.LayoutEvent;
	import flight.layouts.IBounds;
	
	import stealth.layouts.Box;
	import stealth.layouts.LayoutElement;

	[Event(name="resize", type="flight.events.LayoutEvent")]
	
	/**
	 * A generic bitmap element providing position, size and transformation.
	 */
	public class GraphicBitmap extends Bitmap implements IGraphicElement
	{
		public function GraphicBitmap(bitmapData:BitmapData = null, pixelSnapping:String = PixelSnapping.AUTO, smoothing:Boolean = false)
		{
			layoutElement = new LayoutElement(this);
			layoutElement.nativeSizing = true;
			addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10);
			measure();
			
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		[Bindable(event="maskTypeChange", style="noEvent")]
		public function get maskType():String { return _maskType; }
		public function set maskType(value:String):void
		{
			DataChange.change(this, "maskType", _maskType, _maskType = value);
		}
		private var _maskType:String = "default";
		
		
		[Bindable(event="bitmapDataChange", style="noEvent")]
		override public function set bitmapData(value:BitmapData):void
		{
			DataChange.change(this, "bitmapData", super.bitmapData, super.bitmapData = value);
			layoutElement.nativeSizing = true;
			measure();
		}
		
		
		// ====== ITransform implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			super.x = layoutElement.x = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			super.y = layoutElement.y = value;
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
		override public function set scaleX(value:Number):void
		{
			if (super.scaleX != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.scaleX = value;
					updateTransform(oldMatrix);
				} else {
					 super.scaleX = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
			if (super.scaleY != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.scaleY = value;
					updateTransform(oldMatrix);
				} else {
					super.scaleY = value;
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
		override public function set rotation(value:Number):void
		{
			if (super.rotation != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.rotation = value;
					updateTransform(oldMatrix);
				} else {
					super.rotation = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get matrix():Matrix { return transform.matrix; }
		public function set matrix(value:Matrix):void
		{
			transform.matrix = value;
		}
		
		private function updateTransform(oldMatrix:Matrix):void
		{
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
		 * @inheritDoc
		 */
		[Bindable(event="marginChange", style="noEvent")]
		public function get margin():Box { return layoutElement.margin; }
		public function set margin(value:*):void { layoutElement.margin = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", style="noEvent")]
		public function get percentWidth():Number { return layoutElement.percentWidth; }
		public function set percentWidth(value:Number):void { layoutElement.percentWidth = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", style="noEvent")]
		public function get percentHeight():Number { return layoutElement.percentHeight; }
		public function set percentHeight(value:Number):void { layoutElement.percentHeight = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number { return layoutElement.preferredWidth; }
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number { return layoutElement.preferredHeight; }
		
		[Bindable(event="snapToPixelChange", style="noEvent")]
		public function get snapToPixel():Boolean { return layoutElement.snapToPixel; }
		public function set snapToPixel(value:Boolean):void { layoutElement.snapToPixel = value; }
		
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
		[Inspectable(enumeration="left,top,right,bottom,justify")]
		public function get dock():String { return layoutElement.dock; }
		public function set dock(value:String):void { layoutElement.dock = value; }
		
		[Bindable(event="tileChange", style="noEvent")]
		[Inspectable(enumeration="left,top,right,bottom")]
		public function get tile():String { return layoutElement.tile; }
		public function set tile(value:String):void { layoutElement.tile = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return layoutElement.measured; }
		
		/**
		 * @inheritDoc
		 */
		public function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		{
			return layoutElement.getLayoutRect(width, height);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutRect(rect:Rectangle):void
		{
			layoutElement.setLayoutRect(rect);
		}
		
		protected function measure():void
		{
			measured.width = bitmapData ? bitmapData.width : 0;
			measured.height = bitmapData ? bitmapData.height : 0;
		}
		
		private function onMeasure(event:LayoutEvent):void
		{
			measure();
		}
	}
}
