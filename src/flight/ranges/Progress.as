/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.ranges
{
	import flash.events.EventDispatcher;

	import flight.events.PositionEvent;
	import flight.events.PropertyEvent;

	[Event(name="progressChange", type="flash.events.Event")]
	
	public class Progress extends EventDispatcher implements IProgress, IRange
	{
		public function Progress(length:Number = 100)
		{
			this.length = length;
		}
		
		[Bindable("propertyChange")]
		public function get precision():Number { return _precision; }
		public function set precision(value:Number):void
		{
			if (_precision != value) {
				PropertyEvent.queue(this, "precision", _precision, _precision = value);
				this.current = _value;
			}
		}
		private var _precision:Number = NaN;
		
		[Bindable("propertyChange")]
		public function get current():Number { return _value; }
		public function set current(value:Number):void
		{
			value = value <= _begin ? _begin : (value > _end ? _end : value);
			if (!isNaN(_precision)) {
				var p:Number = 1 / _precision;
				value = Math.round(value * p) / p;
			}
			PropertyEvent.queue(this, "current", _value, _value = value);
			
			value = !_length ? 0 : (_value - _begin) / _length;
			PropertyEvent.change(this, "percent", _percent, _percent = value);
			
			if (hasEventListener(PositionEvent.POSITION_CHANGE)) {
				dispatchEvent(new PositionEvent(PositionEvent.POSITION_CHANGE));
			}
		}
		private var _value:Number = 0;
		
		[Bindable("propertyChange")]
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void
		{
			if (_percent != value) {
				current = _begin + value * _length;
			}
		}
		private var _percent:Number = 0;
		
		[Bindable("propertyChange")]
		public function get length():Number { return _length; }
		public function set length(value:Number):void
		{
			if (_length != value) {
				end = _begin + (value <= 0 ? 0 : value);
			}
		}
		private var _length:Number = 100;
		
		[Bindable("propertyChange")]
		public function get begin():Number { return _begin; }
		public function set begin(value:Number):void
		{
			if (_begin != value) {
				PropertyEvent.queue(this, "begin", _begin, _begin = value);
				PropertyEvent.queue(this, "end", _end, _end = _begin + _length);
				this.current = _value;
			}
		}
		private var _begin:Number = 0;
		
		[Bindable("propertyChange")]
		public function get end():Number { return _end;}
		public function set end(value:Number):void
		{
			if (_end != value) {
				PropertyEvent.queue(this, "end", _end, _end = value);
				if (_begin > _end) {
					PropertyEvent.queue(this, "begin", _begin, _begin = _end);
				}
				PropertyEvent.queue(this, "length", _length, _length = _end - _begin);
				this.current = _value;
			}
		}
		private var _end:Number = 100;
	}
}
