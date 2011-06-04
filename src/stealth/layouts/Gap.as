package stealth.layouts
{
	import flash.events.EventDispatcher;

	import flight.data.DataChange;

	public class Gap extends EventDispatcher
	{
		public function Gap(vertical:Number = 0, horizontal:Number = 0)
		{
			_vertical = vertical;
			_horizontal = horizontal;
		}
		
		[Bindable(event="verticalChange", style="noEvent")]
		public function get vertical():Number { return _vertical }
		public function set vertical(value:Number):void
		{
			DataChange.change(this, "vertical", _vertical, _vertical = value);
		}
		private var _vertical:Number = 0;
		
		[Bindable(event="horizontalChange", style="noEvent")]
		public function get horizontal():Number { return _horizontal }
		public function set horizontal(value:Number):void
		{
			DataChange.change(this, "horizontal", _horizontal, _horizontal = value);
		}
		private var _horizontal:Number = 0;
		
		public function equals(gap:Gap):Boolean
		{
			return (_vertical == gap._vertical && _horizontal == gap._horizontal);
		}
		
		public function copy(gap:Gap = null):Gap
		{
			if (!gap) {
				gap = new Gap();
			}
			gap.vertical = _vertical;
			gap.horizontal = _horizontal;
			
			return gap;
		}
		
		override public function toString():String
		{
			return '[Gap(vertical="' + _vertical + ', horizontal="' + _horizontal + '")]'; 
		}
		
		public static function fromString(value:String, gap:Gap = null):Gap
		{
			if (!gap) {
				gap = new Gap();
			}
			
			if (value) {
				var values:Array = value.split(" ");
				switch (values.length) {
					case 1 :
						gap.vertical = gap.horizontal = parseFloat( values[0] );
						break;
					case 2 :
						gap.vertical = parseFloat( values[0] );
						gap.horizontal = parseFloat( values[1] );
						break;
				}
			}
			return gap;
		}
	}
}
