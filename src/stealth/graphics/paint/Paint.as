package stealth.graphics.paint
{
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class Paint extends EventDispatcher implements IPaint
	{
		protected var paintData:IGraphicsData;
		
		public function update(graphicsPath:GraphicsPath, pathBounds:Rectangle):void
		{
		}
		
		public function paint(graphicsData:Vector.<IGraphicsData>):void
		{
			graphicsData.push(paintData);
		}
	}
}
