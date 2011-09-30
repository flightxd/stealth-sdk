/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import flight.events.ThemeEvent;
	import flight.utils.getClassName;
	import flight.utils.getType;

	/**
	 * For delivering skins throughout an application.
	 */
	public class Theme extends Sprite
	{
		public static var dispatcher:IEventDispatcher = new EventDispatcher();
		
		public static function change():void
		{
			dispatcher.dispatchEvent(new ThemeEvent(ThemeEvent.THEME_CHANGE));
		}
		
		public static function register(target:ISkinnable):void
		{
			dispatcher.addEventListener(ThemeEvent.THEME_CHANGE, target.dispatchEvent, false, -10, true);
			target.addEventListener(ThemeEvent.THEME_CHANGE, onThemeChange, false, 10, true);
		}
		
		public static function registerSkin(skin:Object, name:String = null):void
		{
			var skinClass:Class = getType(skin);
			if (!name) {
				if ("skinName" in skinClass) {
					name = skinClass.name;
				}
				if (!name) {
					name = getClassName(skinClass).replace("Skin", "");
				}
			}
			skins[name] = skinClass;
			skinNames[skinClass] = name;
		}
		private static var skins:Object = new Object();
		private static var skinNames:Dictionary = new Dictionary(true);
		
		public static function getSkinName(skin:Object):String
		{
			var skinClass:Class = getType(skin);
			return skinNames[skinClass];
		}
		
		public static function getSkin(name:String):ISkin
		{
			return skins[name];
		}
		
		private static function onThemeChange(event:Event):void
		{
			var target:ISkinnable = ISkinnable(event.target);
			var oldSkin:Class = getType(target.skin);
			var newSkin:Class = skins[ skinNames[oldSkin] ];
			if (newSkin && newSkin != oldSkin) {
				target.skin = new newSkin();
			}
		}
		
	}
}
