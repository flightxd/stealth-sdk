/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.shapes
{
	import flash.display.GraphicsPath;
	import flash.geom.Rectangle;

	import flight.graphics.GraphicShape;

	public class Ellipse extends GraphicShape
	{
		private static var ROUND_RATIO:Number = 2 - 1/Math.SQRT1_2;
		
		public function Ellipse(width:Number = 0, height:Number = 0, fill:* = null, stroke:* = null)
		{
		}
		
		override protected function updatePath(graphicsPath:GraphicsPath, pathBounds:Rectangle):void
		{
			var width:Number = pathBounds.width;
			var height:Number = pathBounds.height;
			var halfX:Number = width / 2;
			var halfY:Number = height / 2;
			var roundX:Number = halfX * ROUND_RATIO;
			var roundY:Number = halfY * ROUND_RATIO;
			
			// top-left curve
			graphicsPath.moveTo(0, halfY);
			graphicsPath.curveTo(0, roundY, roundX/2, roundY/2);
			graphicsPath.curveTo(roundX, 0, halfX, 0);
			
			// top-right curve
			graphicsPath.curveTo(width - roundX, 0, width - roundX/2, roundY/2);
			graphicsPath.curveTo(width, roundY, width, halfY);
			
			// bottom-right curve
			graphicsPath.curveTo(width, height - roundY, width - roundX/2, height - roundY/2);
			graphicsPath.curveTo(width - roundX, height, halfX, height);
			
			// bottom-left curve
			graphicsPath.curveTo(roundX, height, roundX/2, height - roundY/2);
			graphicsPath.curveTo(0, height - roundY, 0, halfY);
		}
		
		override protected function measure():void
		{
			measured.width = width;
			measured.height = height;
		}
	}
}
