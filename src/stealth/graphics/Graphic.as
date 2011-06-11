package stealth.graphics
{
	import stealth.containers.Group;

	public class Graphic extends Group
	{
		public function Graphic()
		{
		}
		
		public function get viewWidth():Number { return width; }
		public function set viewWidth(value:Number):void { width = value; }
		
		public function get viewHeight():Number { return height; }
		public function set viewHeight(value:Number):void { height = value; }
	}
}
