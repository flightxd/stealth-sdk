/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.core
{
	public class Align
	{
		public static const HMASK:uint =				7 <<0;						// horizontal range 0-7
		public static const VMASK:uint =						7 <<3;				// vertical range 0,8,16,24,32,40,48,56

		public static const BEGIN:uint =				0 <<0 | 0 <<3;				// 0 | 0 = 0
		public static const MIDDLE:uint =				1 <<0 | 1 <<3;				// 1 | 8 = 9
		public static const END:uint =					2 <<0 | 2 <<3;				// 2 | 16 = 18

		public static const FILL:uint =					3 <<0 | 3 <<3;				// 3 | 24 = 27
		public static const JUSTIFY:uint =				4 <<0 | 4 <<3;				// 4 | 32 = 36
	}
}
