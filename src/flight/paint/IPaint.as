/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.paint
{
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public interface IPaint
	{
		function update(graphicsPath:GraphicsPath, pathBounds:Rectangle, transform:Matrix = null):void;
		
		function paint(graphicsData:Vector.<IGraphicsData>):void;
	}
}
