/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.CapsStyle;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	public class RadialGradientStroke extends GradientStroke
	{
		public function RadialGradientStroke(weight:Number = 1, colors:Array = null, alphas:Array = null, ratios:Array = null, matrix:Matrix = null,
											 spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0,
											 pixelHinting:Boolean = false, scaleMode:String = LineScaleMode.NORMAL, caps:String = CapsStyle.ROUND,
											 joints:String = JointStyle.ROUND, miterLimit:Number = 3)
		{
			super(weight, GradientType.RADIAL, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio,
				pixelHinting, scaleMode, caps, joints, miterLimit);
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
