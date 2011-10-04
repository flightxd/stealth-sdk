/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class BitmapSource
	{
		public function BitmapSource()
		{
		}
		
		public static function getScale9Grid(source:BitmapData, graphics:Graphics, left:Number, top:Number,
											 right:Number, bottom:Number, scale9Grid:Rectangle = null):Rectangle
		{
			if (!scale9Grid) {
				scale9Grid = new Rectangle();
			}
			
			gridX[0] = scale9Grid.left = left;
			gridX[1] = scale9Grid.right = right;
			gridX[2] = source.width;
			
			gridY[0] = scale9Grid.top = top;
			gridY[1] = scale9Grid.bottom = bottom;
			gridY[2] = source.height;
			
			graphics.clear();
			
			left = 0;
			for (var i:int = 0; i < 3; i++) {
				top = 0;
				for (var j:int = 0; j < 3; j++) {
					graphics.beginBitmapFill(source);
					graphics.drawRect(left, top, gridX[i] - left, gridY[j] - top);
					graphics.endFill();
					top = gridY[j];
				}
				left = gridX[i];
			}
			
			return scale9Grid;
		}
		private static const gridX:Vector.<Number> = new Vector.<Number>(3, true);
		private static const gridY:Vector.<Number> = new Vector.<Number>(3, true);
		
		
		public static function getInstance(value:*):BitmapData
		{
			if (value is Class) {
				if (bitmapDataCache[value]) {
					return bitmapDataCache[value];
				} else {
					return bitmapDataCache[value] = getInstance(new value());
				}
			}
			
			if (value is BitmapData) {
				return BitmapData(value);
			} else if (value is flash.display.Bitmap) {
				return flash.display.Bitmap(value).bitmapData;
			} else if (value is DisplayObject) {
				var display:DisplayObject = DisplayObject(value);
				if (display is IInvalidating) {
					IInvalidating(display).validateNow();
				} else {
					Invalidation.validateNow(display);
				}
				var rect:Rectangle = display.getRect(display);
				if (rect.width && rect.height) {
					var bmp:BitmapData = new BitmapData(rect.width, rect.height, true, 0x00000000);
					position.tx = rect.x;
					position.ty = rect.y;
					bmp.draw(display, position);
					return bmp;
				}
			}
			return null;
		}
		private static var position:Matrix = new Matrix();
		private static var bitmapDataCache:Dictionary = new Dictionary(true);
	}
}
