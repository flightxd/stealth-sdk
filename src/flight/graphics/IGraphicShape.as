/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.graphics
{
	import flash.geom.Matrix;

	import flight.display.IDrawable;
	import flight.graphics.paint.IFill;
	import flight.graphics.paint.IStroke;

	public interface IGraphicShape extends IGraphicElement, IDrawable
	{
		function get fill():IFill;
		function get stroke():IStroke;
		
		function update(transform:Matrix = null):void;
	}
}
