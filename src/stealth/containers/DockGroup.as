/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.graphics.Group;
	import stealth.layouts.Box;
	import stealth.layouts.DockLayout;

	public class DockGroup extends Group
	{
		protected var dockLayout:DockLayout;
		
		public function DockGroup()
		{
			layout = dockLayout = new DockLayout();
		}
		
	}
}
