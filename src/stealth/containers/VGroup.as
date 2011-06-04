/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import stealth.layouts.Box;
	import stealth.layouts.VerticalLayout;

	public class VGroup extends Group
	{
		protected var verticalLayout:VerticalLayout;
		
		public function VGroup()
		{
			layout = verticalLayout = new VerticalLayout();
		}
		
		/**
		 * @copy stealth.layout.BoxLayout#padding
		 */
		[Inspectable(type="String")]
		public function get padding():Box { return verticalLayout.padding; }
		public function set padding(value:*):void { verticalLayout.padding = value; }
		
		/**
		 * @copy stealth.layout.BoxLayout#gap
		 */
		[Inspectable(type="String")]
		public function get gap():Box { return verticalLayout.gap; }
		public function set gap(value:*):void { verticalLayout.gap = value; }

		/**
		 * @copy stealth.layout.BoxLayout#hAlign
		 */
		[Inspectable(enumeration="left,center,right,justify", defaultValue="left")]
		public function get hAlign():String { return verticalLayout.hAlign }
		public function set hAlign(value:String):void { verticalLayout.hAlign = value; }
		
		/**
		 * @copy stealth.layout.BoxLayout#vAlign
		 */
		[Inspectable(enumeration="top,middle,bottom", defaultValue="top")]
		public function get vAlign():String { return verticalLayout.vAlign }
		public function set vAlign(value:String):void { verticalLayout.vAlign = value; }
		
	}
}
