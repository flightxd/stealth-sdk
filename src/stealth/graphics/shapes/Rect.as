/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.shapes
{
	import flash.display.GraphicsPath;
	import flash.geom.Rectangle;

	import flight.data.DataChange;

	import stealth.graphics.GraphicShape;

	public class Rect extends GraphicShape
	{
		public function Rect(width:Number = 0, height:Number = 0, fill:* = null, stroke:* = null)
		{
			this.width = width;
			this.height = height;
			this.fill = fill;
			this.stroke = stroke;
		}
		
		[Bindable("propertyChange")]
		public function get radiusX():Number { return _radiusX }
		public function set radiusX(value:Number):void
		{
			DataChange.queue(this, "radiusX", _radiusX, _radiusX = value);
			DataChange.queue(this, "topLeftRadiusX", _topLeftRadiusX, _topLeftRadiusX = value);
			DataChange.queue(this, "topRightRadiusX", _topRightRadiusX, _topRightRadiusX = value);
			DataChange.queue(this, "bottomLeftRadiusX", _bottomLeftRadiusX, _bottomLeftRadiusX = value);
			DataChange.change(this, "bottomRightRadiusX", _bottomRightRadiusX, _bottomRightRadiusX = value);
			invalidate();
		}
		private var _radiusX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get radiusY():Number { return _radiusY }
		public function set radiusY(value:Number):void
		{
			DataChange.queue(this, "radiusY", _radiusY, _radiusY = value);
			DataChange.queue(this, "topLeftRadiusY", _topLeftRadiusY, _topLeftRadiusY = value);
			DataChange.queue(this, "topRightRadiusY", _topRightRadiusY, _topRightRadiusY = value);
			DataChange.queue(this, "bottomLeftRadiusY", _bottomLeftRadiusY, _bottomLeftRadiusY = value);
			DataChange.change(this, "bottomRightRadiusY", _bottomRightRadiusY, _bottomRightRadiusY = value);
			invalidate();
		}
		private var _radiusY:Number = 0;
		
		[Bindable("propertyChange")]
		public function get topLeftRadiusX():Number { return _topLeftRadiusX }
		public function set topLeftRadiusX(value:Number):void
		{
			DataChange.queue(this, "radiusX", _radiusX, _radiusX = NaN);
			DataChange.change(this, "topLeftRadiusX", _topLeftRadiusX, _topLeftRadiusX = value);
			invalidate();
		}
		private var _topLeftRadiusX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get topLeftRadiusY():Number { return _topLeftRadiusY }
		public function set topLeftRadiusY(value:Number):void
		{
			DataChange.queue(this, "radiusY", _radiusY, _radiusY = NaN);
			DataChange.change(this, "topLeftRadiusY", _topLeftRadiusY, _topLeftRadiusY = value);
			invalidate();
		}
		private var _topLeftRadiusY:Number = 0;
		
		[Bindable("propertyChange")]
		public function get topRightRadiusX():Number { return _topRightRadiusX }
		public function set topRightRadiusX(value:Number):void
		{
			DataChange.queue(this, "radiusX", _radiusX, _radiusX = NaN);
			DataChange.change(this, "topRightRadiusX", _topRightRadiusX, _topRightRadiusX = value);
			invalidate();
		}
		private var _topRightRadiusX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get topRightRadiusY():Number { return _topRightRadiusY }
		public function set topRightRadiusY(value:Number):void
		{
			DataChange.queue(this, "radiusY", _radiusY, _radiusY = NaN);
			DataChange.change(this, "topRightRadiusY", _topRightRadiusY, _topRightRadiusY = value);
			invalidate();
		}
		private var _topRightRadiusY:Number = 0;
		
		[Bindable("propertyChange")]
		public function get bottomLeftRadiusX():Number { return _bottomLeftRadiusX }
		public function set bottomLeftRadiusX(value:Number):void
		{
			DataChange.queue(this, "radiusX", _radiusX, _radiusX = NaN);
			DataChange.change(this, "bottomLeftRadiusX", _bottomLeftRadiusX, _bottomLeftRadiusX = value);
			invalidate();
		}
		private var _bottomLeftRadiusX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get bottomLeftRadiusY():Number { return _bottomLeftRadiusY }
		public function set bottomLeftRadiusY(value:Number):void
		{
			DataChange.queue(this, "radiusY", _radiusY, _radiusY = NaN);
			DataChange.change(this, "bottomLeftRadiusY", _bottomLeftRadiusY, _bottomLeftRadiusY = value);
			invalidate();
		}
		private var _bottomLeftRadiusY:Number = 0;
		
		[Bindable("propertyChange")]
		public function get bottomRightRadiusX():Number { return _bottomRightRadiusX }
		public function set bottomRightRadiusX(value:Number):void
		{
			DataChange.queue(this, "radiusX", _radiusX, _radiusX = NaN);
			DataChange.change(this, "bottomRightRadiusX", _bottomRightRadiusX, _bottomRightRadiusX = value);
			invalidate();
		}
		private var _bottomRightRadiusX:Number = 0;
		
		[Bindable("propertyChange")]
		public function get bottomRightRadiusY():Number { return _bottomRightRadiusY }
		public function set bottomRightRadiusY(value:Number):void
		{
			DataChange.queue(this, "radiusY", _radiusY, _radiusY = NaN);
			DataChange.change(this, "bottomRightRadiusY", _bottomRightRadiusY, _bottomRightRadiusY = value);
			invalidate();
		}
		private var _bottomRightRadiusY:Number = 0;
		
		override protected function updatePath(graphicsPath:GraphicsPath, pathBounds:Rectangle):void
		{
			var tlRadiusX:Number = _topLeftRadiusX;
			var tlRadiusY:Number = _topLeftRadiusY;
			var trRadiusX:Number = _topRightRadiusX;
			var trRadiusY:Number = _topRightRadiusY;
			var blRadiusX:Number = _bottomLeftRadiusX;
			var blRadiusY:Number = _bottomLeftRadiusY;
			var brRadiusX:Number = _bottomRightRadiusX;
			var brRadiusY:Number = _bottomRightRadiusY;
			
			var width:Number = pathBounds.width;
			var height:Number = pathBounds.height;
			
			if (_radiusX != 0 && _radiusY != 0) {
				var topRatio:Number = _topLeftRadiusX + _topRightRadiusX;
				topRatio = topRatio > width ? width / topRatio : 1;
				
				var leftRatio:Number = _topLeftRadiusY + _bottomLeftRadiusY;
				leftRatio = leftRatio > height ? height / leftRatio : 1;
				
				var bottomRatio:Number = _bottomLeftRadiusX + _bottomRightRadiusX;
				bottomRatio = bottomRatio > width ? width / bottomRatio : 1;
				
				var rightRatio:Number = _topRightRadiusY + _bottomRightRadiusY;
				rightRatio = rightRatio > height ? height / rightRatio : 1;
				
				var cornerRatio:Number;
				cornerRatio = topRatio <= leftRatio ? topRatio : leftRatio;
				tlRadiusX *= cornerRatio;
				tlRadiusY *= cornerRatio;
				
				cornerRatio = topRatio <= rightRatio ? topRatio : rightRatio;
				trRadiusX *= cornerRatio;
				trRadiusY *= cornerRatio;
				
				cornerRatio = topRatio <= leftRatio ? topRatio : leftRatio;
				blRadiusX *= cornerRatio;
				blRadiusY *= cornerRatio;
				
				cornerRatio = topRatio <= rightRatio ? topRatio : rightRatio;
				brRadiusX *= cornerRatio;
				brRadiusY *= cornerRatio;
			}
			
			if (tlRadiusX && tlRadiusY) {
				graphicsPath.moveTo(0, tlRadiusY);
				graphicsPath.curveTo(0, 0, tlRadiusX, 0);
			} else {
				graphicsPath.moveTo(0, 0);
			}
			
			if (trRadiusX && trRadiusY) {
				graphicsPath.lineTo(width - trRadiusX, 0);
				graphicsPath.curveTo(width, 0, width, trRadiusY);
			} else {
				graphicsPath.lineTo(width, 0);
			}
			
			if (brRadiusX && brRadiusY) {
				graphicsPath.lineTo(width, height - brRadiusY);
				graphicsPath.curveTo(width, height, width - brRadiusX, height);
			} else {
				graphicsPath.lineTo(width, height);
			}
			
			if (blRadiusX && blRadiusY) {
				graphicsPath.lineTo(blRadiusX, height);
				graphicsPath.curveTo(0, height, 0, height - blRadiusY);
			} else {
				graphicsPath.lineTo(0, height);
			}
			
			graphicsPath.lineTo(graphicsPath.data[0], graphicsPath.data[1]);
		}
		
		override protected function measure():void
		{
			measured.width = width;
			measured.height = height;
		}
	}
}
