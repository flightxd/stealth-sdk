/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.GradientType;

	public class RadialGradient extends GradientFill
	{
		public function RadialGradient(entries:* = null, rotation:Number = 0)
		{
			super(GradientType.RADIAL, entries, rotation);
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
