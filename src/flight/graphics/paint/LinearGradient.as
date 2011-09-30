/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics.paint
{
	import flash.display.GradientType;

	public class LinearGradient extends GradientFill
	{
		public function LinearGradient(entries:* = null, rotation:Number = 0)
		{
			super(GradientType.LINEAR, entries, rotation);
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
