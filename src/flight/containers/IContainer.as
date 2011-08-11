/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.collections.IList;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;
	
	[Event(name="measure", type="flight.events.LayoutEvent")]
	[Event(name="layout", type="flight.events.LayoutEvent")]
	
	public interface IContainer extends IMeasureable
	{
		function get content():IList;
		
		function get layout():ILayout;
		function set layout(value:ILayout):void;
		
		/**
		 * The width of the container's viewable area.
		 * 
		 * @default		0
		 */
		function get width():Number;
		function set width(value:Number):void;
		
		/**
		 * The height of the container's viewable area.
		 * 
		 * @default		0
		 */
		function get height():Number;
		function set height(value:Number):void;
		
		/**
		 * The width of the layout's content in pixels relative to the local
		 * coordinates of this layout instance. The width represents a
		 * virtual size, allowing content of the layout to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get contentWidth():Number;
		
		/**
		 * The height of the layout's content in pixels relative to the local
		 * coordinates of this layout instance. The height represents a
		 * virtual size, allowing content of the layout to fill it
		 * accordingly, and is non-scaling.
		 * 
		 * @default		0
		 */
		function get contentHeight():Number;
	}
}
