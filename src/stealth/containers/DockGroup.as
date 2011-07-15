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
		
		/**
		 * @copy stealth.layout.BoxLayout#padding
		 */
		public function get padding():Box { return dockLayout.padding; }
		public function set padding(value:*):void { dockLayout.padding = value; }
		
		/**
		 * @copy stealth.layout.BoxLayout#gap
		 */
		[Inspectable(type="String")]
		public function get gap():Box { return dockLayout.gap; }
		public function set gap(value:*):void { dockLayout.gap = value; }
		
	}
}
