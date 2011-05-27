/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import stealth.graphics.paint.IFill;
	import stealth.graphics.paint.IStroke;

	public interface IGraphicShape extends IDrawable
	{
		function get stroke():IStroke;
		function get fill():IFill;
	}
}
