/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.ranges
{
	import flight.data.DataChange;
	import flight.data.ITrack;
	import flight.data.Track;

	import stealth.components.Component;

	public class RangeBase extends Component
	{
		[Bindable(event="positionChange")]
		public function get position():ITrack { return _position ||= new Track(); }
		public function set position(value:ITrack):void
		{
			DataChange.change(this, "position", _position, _position = value);
		}
		private var _position:ITrack;
		
		public function RangeBase()
		{
		}
	}
}
