/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.layouts.Box;
	import stealth.layouts.Gap;
	import stealth.layouts.HorizontalLayout;

	public class HGroup extends Group
	{
		protected var horizontalLayout:HorizontalLayout;
		
		public function HGroup()
		{
			layout = horizontalLayout = new HorizontalLayout();
		}
		
		/**
		 * @copy flight.layout.Layout#padding
		 */
		[Inspectable(type="String")]
		public function get padding():Box { return horizontalLayout.padding; }
		public function set padding(value:*):void
		{
			horizontalLayout.padding = value;
		}
		
		/**
		 * @copy flight.layout.Layout#gap
		 */
		[Inspectable(type="String")]
		public function get gap():Gap { return horizontalLayout.gap; }
		public function set gap(value:*):void
		{
			horizontalLayout.gap = value;
		}

		/**
		 * @copy flight.layout.Layout#horizontalAlign
		 */
		[Inspectable(enumeration="left,center,right", defaultValue="left", name="horizontalAlign")]
		public function get horizontalAlign():String { return horizontalLayout.horizontalAlign }
		public function set horizontalAlign(value:String):void
		{
			horizontalLayout.horizontalAlign = value;
		}

		/**
		 * @copy flight.layout.Layout#verticalAlign
		 */
		[Inspectable(enumeration="top,center,bottom,justify", defaultValue="left", name="horizontalAlign")]
		public function get verticalAlign():String { return horizontalLayout.verticalAlign }
		public function set verticalAlign(value:String):void
		{
			horizontalLayout.verticalAlign = value;
		}
		
	}
}
