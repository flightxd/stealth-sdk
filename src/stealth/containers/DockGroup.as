/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
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
		 * @copy flight.layout.Layout#padding
		 */
		public function get padding():Box { return dockLayout.padding; }
		public function set padding(value:*):void
		{
			dockLayout = value;
		}
		
		/**
		 * @copy flight.layout.Layout#horizontalAlign
		 */
		public function get horizontalAlign():String { return dockLayout.horizontalAlign }
		public function set horizontalAlign(value:String):void
		{
			dockLayout.horizontalAlign = value;
		}
		
		/**
		 * @copy flight.layout.Layout#verticalAlign
		 */
		public function get verticalAlign():String { return dockLayout.verticalAlign }
		public function set verticalAlign(value:String):void
		{
			dockLayout.verticalAlign = value;
		}
		
	}
}
