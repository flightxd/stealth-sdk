/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.ranges
{
	import flash.events.Event;

	import flight.display.InitializePhase;

	import stealth.theme.ThemeStepper;

	public class Stepper extends RangeBase
	{
		public function Stepper()
		{
			addEventListener(InitializePhase.INITIALIZE, onInit);
		}
		
		protected function init():void
		{
			ThemeStepper.initialize(this);
		}
		
		private function onInit(event:Event):void
		{
			init();
		}
	}
}
