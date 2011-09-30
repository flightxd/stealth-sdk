/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flight.graphics.Group;
	import flight.layouts.ILayout;
	import flight.layouts.VerticalLayout;

	public class VGroup extends Group
	{
		public function VGroup()
		{
			layout = getDefaultLayout();
		}
		
		override protected function getDefaultLayout():ILayout
		{
			return new VerticalLayout();
		}
	}
}
