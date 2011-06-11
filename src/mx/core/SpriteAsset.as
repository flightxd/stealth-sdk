package mx.core
{
	import stealth.graphics.GraphicElement;

	public class SpriteAsset extends GraphicElement implements IFlexAsset
	{
		public function SpriteAsset()
		{
			super();
			layoutElement.nativeSizing = true;
		}
	}
}
