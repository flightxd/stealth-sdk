package mx.core
{
	import flash.utils.ByteArray;

	import stealth.graphics.GraphicElement;

	public class MovieClipLoaderAsset extends GraphicElement implements IFlexAsset
	{
		public function MovieClipLoaderAsset()
		{
			super();
			layoutElement.nativeSizing = true;
		}
		
		public function get movieClipData():ByteArray
		{
			return null;
		}
	}
}
