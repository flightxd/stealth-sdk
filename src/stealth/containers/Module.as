/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flight.events.LifecycleEvent;

	import stealth.graphics.Group;
	import stealth.layouts.DockLayout;

	public class Module extends Group
	{
		public function Module()
		{
			addEventListener(LifecycleEvent.CREATE, onCreate, false, -10);
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			if (!layout) {
				layout = new DockLayout();
			}
		}
	}
}
