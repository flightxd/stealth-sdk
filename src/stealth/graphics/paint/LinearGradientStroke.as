/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GradientType;

	public class LinearGradientStroke extends GradientStroke
	{
		public function LinearGradientStroke(weight:Number = 1, entries:* = null, rotation:Number = 0, pixelHinting:Boolean = false)
		{
			super(weight, GradientType.LINEAR, entries, rotation, pixelHinting);
		}
		
		/**
		 * @private
		 */
		override public function set type(value:String):void
		{
			super.type = value;
		}
		
		/**
		 * @private
		 */
		override public function set focalPointRatio(value:Number):void
		{
			super.focalPointRatio = value;
		}
		
		/**
		 * @private
		 */
		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
		}
	}
}
