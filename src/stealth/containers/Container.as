/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.containers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	import flight.collections.IList;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;

	public class Container// implements IContainer
	{
		public var target:DisplayObjectContainer;
		public var targetProperties:Object;
	
		public function Container()
		{
		}

		
		public function get content():IList
		{
			return targetProperties.content;
		}

		public function get layout():ILayout
		{
			return null;
		}

		public function get contentWidth():Number
		{
			return 0;
		}

		public function get contentHeight():Number
		{
			return 0;
		}

		public function set layout(value:ILayout):void
		{
		}

		public function get measured():IBounds
		{
			return null;
		}

		public function get display():DisplayObject
		{
			return null;
		}

		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
		}

		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
		}

		public function dispatchEvent(event:Event):Boolean
		{
			return false;
		}

		public function hasEventListener(type:String):Boolean
		{
			return false;
		}

		public function willTrigger(type:String):Boolean
		{
			return false;
		}
		
	}
}
