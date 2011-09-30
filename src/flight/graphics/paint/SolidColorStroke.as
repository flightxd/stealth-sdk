/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	public class SolidColorStroke extends SolidStroke
	{
		public function SolidColorStroke(weight:Number = 1, color:uint = 0x000000, alpha:Number = 1, pixelHinting:Boolean = false)
		{
			super(weight, color, alpha, pixelHinting);
		}
	}
}
