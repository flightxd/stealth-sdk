/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	import flash.events.TimerEvent;

	public function callLater(method:Function, args:Array = null):void
	{
		calls[method] = args;
		
		if (!enabled) {
			enabled = true;
			Interval.timer.addEventListener(TimerEvent.TIMER, onTimer);
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Dictionary;

import flight.utils.Interval;

internal var enabled:Boolean;
internal var calls:Dictionary = new Dictionary();
internal var callsEmpty:Dictionary = new Dictionary();

internal function onTimer(event:TimerEvent):void
{
	enabled = false;
	Interval.timer.removeEventListener(TimerEvent.TIMER, onTimer);
	
	var callsNow:Dictionary = calls;
	calls = callsEmpty;
	callsEmpty = callsNow;
	
	for (var method:Object in callsNow) {
		method.apply(null, callsNow[method]);
		delete callsNow[method];
	}
}
