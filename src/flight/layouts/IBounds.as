/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	/**
	 * A set of related coordinates that represent minimum, maximum and actual
	 * size.
	 */
	public interface IBounds
	{
		/**
		 * The actual width of the bounds, constrained between the minWidth
		 * and maxWidth respectively.
		 * 
		 * @default		0
		 */
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * The actual height of the bounds, constrained between the minHeight
		 * and maxHeight respectively.
		 * 
		 * @default		0
		 */
		function get height():Number;
		function set height(value:Number):void;
		
		/**
		 * The minimum width of the bounds, constraining the bounds actual
		 * width and any width value passed into the
		 * <code>constrainWidth()</code> method.
		 * 
		 * @default		0
		 */
		function get minWidth():Number;
		function set minWidth(value:Number):void;
		
		/**
		 * The minimum height of the bounds, constraining the bounds actual
		 * height and any height value passed into the
		 * <code>constrainHeight()</code> method.
		 * 
		 * @default		0
		 */
		function get minHeight():Number;
		function set minHeight(value:Number):void;
		
		/**
		 * The maximum width of the bounds, constraining the bounds actual
		 * width and any width value passed into the
		 * <code>constrainWidth()</code> method.
		 * 
		 * @default		16777215
		 */
		function get maxWidth():Number;
		function set maxWidth(value:Number):void;
		
		/**
		 * The maximum height of the bounds, constraining the bounds actual
		 * height and any height value passed into the
		 * <code>constrainHeight()</code> method.
		 * 
		 * @default		16777215
		 */
		function get maxHeight():Number;
		function set maxHeight(value:Number):void;
		
	}
}
