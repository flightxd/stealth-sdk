/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsStroke;
	import flash.display.IGraphicsData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flight.display.BitmapSource;

	public class Paint extends EventDispatcher implements IPaint
	{
		protected var paintData:IGraphicsData;
		
		public function update(graphicsPath:GraphicsPath, pathBounds:Rectangle, transform:Matrix = null):void
		{
		}
		
		public function paint(graphicsData:Vector.<IGraphicsData>):void
		{
			graphicsData.push(paintData);
		}
		
		public static var endFill:GraphicsEndFill = new GraphicsEndFill();
		public static var endStroke:GraphicsStroke = new GraphicsStroke();
		
		public static function getInstance(value:*, stroke:Boolean = false):IPaint
		{
			if (value is IPaint || value == null) {
				return value;
			} else if (value is Number) {
				
				if (isNaN(value)) {
					return null;
				} else if (stroke) {
					return new SolidColorStroke(1, value);
				} else {
					return new SolidColor(value);
				}
				
			} if (value is String) {
				
				value = value.replace(/#/g, "0x");
				value = value.replace(/[,\s]+/g, " ");
				var values:Array = value.split(" ");
				switch (values.length) {
					case 0: values[0] = 0x000000;
					case 1:
						if (stroke) {
							return new SolidColorStroke(1, Number(values[0]), 1, true);
						} else {
							return new SolidColor(Number(values[0]));
						}
						break;
					default:
						var entries:Array = [];
						for each (value in values) {
							if (value && !isNaN(value)) {
								entries.push(new GradientEntry( Number(value) ));
							}
						}
						
						if (stroke) {
							return new LinearGradientStroke(1, entries, 90, true);
						} else {
							return new LinearGradient(entries, 90);
						}
						break;
				}
			} else {
				value = BitmapSource.getInstance(value);
				if (value) {
					if (stroke) {
						return new BitmapStroke(value);
					} else {
						return new BitmapFill(value);
					}
				}
			}
			
			return null;
		}
	}
}
