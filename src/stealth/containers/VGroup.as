/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flight.containers.Group;
	import flight.layouts.Box;
	import flight.layouts.VerticalLayout;
	
	public class VGroup extends Group
	{
		protected var verticalLayout:VerticalLayout;
		
		public function VGroup()
		{
			layout = verticalLayout = new VerticalLayout();
		}
		
		/**
		 * @copy flight.layout.Layout#padding
		 */
		[Inspectable(type="String")]
		public function get padding():Box { return verticalLayout.padding; }
		public function set padding(value:*):void
		{
			verticalLayout.padding = value;
		}

		/**
		 * @copy flight.layout.Layout#horizontalAlign
		 */
		[Inspectable(enumeration="left,center,right,justify", defaultValue="left", name="horizontalAlign")]
		public function get horizontalAlign():String { return verticalLayout.horizontalAlign }
		public function set horizontalAlign(value:String):void
		{
			verticalLayout.horizontalAlign = value;
		}

		/**
		 * @copy flight.layout.Layout#verticalAlign
		 */
		[Inspectable(enumeration="top,center,bottom", defaultValue="top", name="verticalAlign")]
		public function get verticalAlign():String { return verticalLayout.verticalAlign }
		public function set verticalAlign(value:String):void
		{
			verticalLayout.verticalAlign = value;
		}
		
	}
}
