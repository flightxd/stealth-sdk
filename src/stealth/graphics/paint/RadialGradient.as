/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics.paint
{
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	public class RadialGradient extends GradientFill implements IFill
	{
		public function RadialGradient(colors:Array = null, alphas:Array = null, ratios:Array = null, matrix:Matrix = null,
									   spreadMethod:String = SpreadMethod.PAD, interpolationMethod:String = InterpolationMethod.RGB, focalPointRatio:Number = 0)
		{
			super(GradientType.RADIAL, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
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
