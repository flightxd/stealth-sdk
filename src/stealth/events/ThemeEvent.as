package stealth.events
{
	import flash.events.Event;

	public class ThemeEvent extends Event
	{
		public static const THEME_CHANGE:String = "themeChange";
		
		public function ThemeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new ThemeEvent(type, bubbles, cancelable);
		}
	}
}
