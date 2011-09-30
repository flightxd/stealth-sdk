/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.graphics.Group;
	import flight.layouts.HorizontalLayout;
	import flight.layouts.ILayout;

	public class HGroup extends Group
	{
		public function HGroup()
		{
			layout = getDefaultLayout();
		}
		
		override protected function getDefaultLayout():ILayout
		{
			return new HorizontalLayout();
		}
	}
}
