package mx.core
{
	import stealth.graphics.GraphicElement;

	public class MovieClipAsset extends GraphicElement implements IFlexAsset
	{
		public function MovieClipAsset()
		{
			super();
			layoutElement.nativeSizing = true;
		}
	}
}
