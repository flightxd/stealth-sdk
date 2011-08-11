/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flight.containers.IContainer;

	public interface ILayout
	{
		function get target():IContainer;
		function set target(value:IContainer):void;
		
		// TODO: implement support for virtualization in layout
//		function get shift():Number;
//		function set shift(value:Number):void;
//		
//		function get shiftSize():Number;
//		function set shiftSize(value:Number):void;
		
		function measure():void;
		function update():void;
	}
}
