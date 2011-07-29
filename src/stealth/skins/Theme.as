package stealth.skins
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	import flight.utils.callLater;
	import flight.utils.getClassName;
	import flight.utils.getType;

	import stealth.events.ThemeEvent;

	/**
	 * For delivering skins throughout an application.
	 */
	public class Theme extends Sprite
	{
		public static var dispatcher:IEventDispatcher = new EventDispatcher();
		
		public static function register(target:ISkinnable):void
		{
			registered = true;
			dispatcher.addEventListener(ThemeEvent.THEME_CHANGE, target.dispatchEvent, false, -10, true);
			target.addEventListener(ThemeEvent.THEME_CHANGE, onThemeChange, false, 10, true);
		}
		private static var registered:Boolean;
		
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
			if (registered) {
				callLater(themeChanged);
			}
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
		
		private static function themeChanged():void
		{
			dispatcher.dispatchEvent(new ThemeEvent(ThemeEvent.THEME_CHANGE));
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
