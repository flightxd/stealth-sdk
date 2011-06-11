/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.ranges
{
	import flight.data.DataChange;
	import flight.data.IPosition;
	import flight.data.Position;

	import stealth.components.Component;

	public class RangeBase extends Component
	{
		[Bindable(event="positionChange")]
		public function get position():IPosition { return _position ||= new Position(); }
		public function set position(value:IPosition):void
		{
			DataChange.change(this, "position", _position, _position = value);
		}
		private var _position:IPosition;
		
		public function RangeBase()
		{
		}
	}
}
