/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import flight.display.BitmapSource;

	public class Paint extends EventDispatcher implements IPaint
	{
		protected var paintData:IGraphicsData;
		
		public function update(graphicsPath:GraphicsPath, pathBounds:Rectangle):void
		{
		}
		
		public function paint(graphicsData:Vector.<IGraphicsData>):void
		{
			graphicsData.push(paintData);
		}
		
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
					case 1:
						if (stroke) {
							new SolidColorStroke(1, Number(values[0]));
						} else {
							new SolidColor(Number(values[0]));
						}
						break;
					case 2:
						if (stroke) {
							var gradientStroke:LinearGradientStroke = new LinearGradientStroke(1, [Number(values[0]), Number(values[1])]);
							gradientStroke.rotation = 90;
							return gradientStroke;
						} else {
							var gradient:LinearGradient = new LinearGradient([Number(values[0]), Number(values[1])]);
							gradient.rotation = 90;
							return gradient;
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
