/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	import flight.events.PropertyEvent;

	public class Position extends Progress implements IPosition
	{
		public function Position(begin:Number = 0, end:Number = 100)
		{
			this.begin = begin;
			super(end - begin);
		}
		
		[Bindable("propertyChange")]
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(value:Number):void
		{
			PropertyEvent.change(this, "stepSize", _stepSize, _stepSize = value);
		}
		private var _stepSize:Number = 1;
		
		[Bindable("propertyChange")]
		public function get skipSize():Number { return _pageSize; }
		public function set skipSize(value:Number):void
		{
			PropertyEvent.change(this, "skipSize", _pageSize, _pageSize = value);
		}
		private var _pageSize:Number = 20;
		
		public function stepForward():Number
		{
			return current += _stepSize;
		}
		
		public function stepBackward():Number
		{
			return current -= _stepSize;
		}
		
		public function skipForward():Number
		{
			return current += _pageSize;
		}
		
		public function skipBackward():Number
		{
			return current -= _pageSize;
		}
	}
}
