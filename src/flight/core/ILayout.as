package flight.core
{
	import flash.geom.Rectangle;

	public interface ILayout
	{
		// TODO: implement support for virtualization in layout
//		function get shift():Number;
//		function set shift(value:Number):void;
//		
//		function get shiftSize():Number;
//		function set shiftSize(value:Number):void;
		
		function measureLayout(measured:Rectangle, content:Node, w:Number = NaN, h:Number = NaN):void;
		function updateLayout(content:Node, w:Number, h:Number):void;
	}
}
