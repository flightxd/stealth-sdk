/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.layouts.Box;
	import stealth.layouts.HorizontalLayout;

	public class HGroup extends Group
	{
		protected var horizontalLayout:HorizontalLayout;
		
		public function HGroup()
		{
			layout = horizontalLayout = new HorizontalLayout();
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#padding
		 */
		[Inspectable(type="String")]
		public function get padding():Box { return horizontalLayout.padding; }
		public function set padding(value:*):void { horizontalLayout.padding = value; }
		
		/**
		 * @copy stealth.layout.BoxLayout#gap
		 */
		[Inspectable(type="String")]
		public function get gap():Box { return horizontalLayout.gap; }
		public function set gap(value:*):void { horizontalLayout.gap = value; }

		/**
		 * @copy stealth.layout.BoxLayout#hAlign
		 */
		[Inspectable(enumeration="left,center,right", defaultValue="left")]
		public function get hAlign():String { return horizontalLayout.hAlign }
		public function set hAlign(value:String):void { horizontalLayout.hAlign = value; }

		/**
		 * @copy stealth.layout.BoxLayout#vAlign
		 */
		[Inspectable(enumeration="top,middle,bottom,justify", defaultValue="top")]
		public function get vAlign():String { return horizontalLayout.vAlign }
		public function set vAlign(value:String):void { horizontalLayout.vAlign = value; }
		
	}
}
