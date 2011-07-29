/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.graphics.Group;
	import stealth.layouts.Box;
	import stealth.layouts.VerticalLayout;

	public class VGroup extends Group
	{
		public function VGroup()
		{
			layout = new VerticalLayout();
		}
	}
}
