/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.DisplayObject;

	import flight.display.ITransform;

	import stealth.layouts.ILayoutElement;

	public interface IGraphicElement extends ITransform, ILayoutElement
	{
		function get id():String;
		function set id(value:String):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		
		function get maskType():String;
		function set maskType(value:String):void;
		
		function get blendMode():String;
		function set blendMode(value:String):void;
		
		function get filters():Array;
		function set filters(value:Array):void;
	}
}
