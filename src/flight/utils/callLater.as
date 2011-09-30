/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.utils
{
	public function callLater(method:Function, args:Array = null):void
	{
		calls[method] = args;
		if (!timer.running) {
			timer.start();
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Dictionary;
import flash.utils.Timer;

internal var calls:Dictionary = new Dictionary();
internal var callsEmpty:Dictionary = new Dictionary();
internal var timer:Timer = new Timer(1, 1);
timer.addEventListener(TimerEvent.TIMER, onTimer);

internal function onTimer(event:TimerEvent):void
{
	timer.reset();
	var callsNow:Dictionary = calls;
	calls = callsEmpty;
	callsEmpty = callsNow;
	
	for (var method:Object in callsNow) {
		method.apply(null, callsNow[method]);
		delete callsNow[method];
	}
}
