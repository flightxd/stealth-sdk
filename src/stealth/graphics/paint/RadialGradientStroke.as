/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GradientType;

	public class RadialGradientStroke extends GradientStroke
	{
		public function RadialGradientStroke(weight:Number = 1, entries:* = null, rotation:Number = 0, pixelHinting:Boolean = false)
		{
			super(weight, GradientType.RADIAL, entries, rotation, pixelHinting);
		}
		
		/**
		 * @private
		 */
		override public function set type(value:String):void
		{
			super.type = value;
		}
	}
}
