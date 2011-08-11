package mx.core
{
	import flash.display.BitmapData;

	public class BitmapAsset extends BitmapData implements IFlexAsset
	{
		public function BitmapAsset(width:int = 0, height:int = 0, transparent:Boolean = true, fillColor:uint = 0xFFFFFFFF)
		{
			super(width, height, transparent, fillColor);
		}
	}
}
