/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flight.collections.IList;
	import flight.utils.IFactory;

	import stealth.graphics.Group;
	import stealth.utils.Replicator;

	public class DataGroup extends Group
	{
		protected var replicator:Replicator;
		
		public function DataGroup()
		{
			replicator = new Replicator(this);
		}
		
		[Bindable("propertyChange")]
		public function get dataProvider():IList { return replicator.dataProvider; }
		public function set dataProvider(value:*):void { replicator.dataProvider = value; }
		
		[Bindable("propertyChange")]
		public function get template():IFactory { return replicator.template }
		public function set template(value:*):void { replicator.template = value; }
	}
}
