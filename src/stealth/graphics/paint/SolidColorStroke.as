/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;

	public class SolidColorStroke extends SolidStroke implements IStroke
	{
		public function SolidColorStroke(weight:Number = 1, color:uint = 0x000000, alpha:Number = 1,
										 pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = CapsStyle.ROUND,
										 joints:String = JointStyle.ROUND, miterLimit:Number = 3)
		{
			super(weight, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
	}
}
