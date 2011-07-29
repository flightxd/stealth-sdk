/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;

	import flight.data.DataChange;
	import flight.display.BitmapSource;

	public class BitmapImage extends GraphicBitmap//GraphicShape
	{
		/*
		progress (load)
		
		preliminaryWidth/Height - size before loaded, but not explicit (should be initial measured size?)
		
		smooth & smoothingQuality (quality - downSample
		fillMode - BitmapFillMode.clip/repeat/scale
		scaleMode - stretch/letterbox
		hAlign/vAlign - (letterbox only)
		*/
		
		
		static public const BEST_FIT:String = "bestFit";
		static public const BEST_FILL:String = "bestFill";
		static public const HORIZONTAL_FIT:String = "horizontalFit";
		static public const VERTICAL_FIT:String = "verticalFit";
		static public const SKEW:String = "skew";
		
		private var loader:Loader;
		private var original:BitmapData;
		
		private var _scaling:String = BEST_FILL;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _backgroundAlpha:Number = 0;
		
		[Bindable("propertyChange")]
		public function get source():BitmapData { return _source; }
		override public function set source(value:*):void
		{
			DataChange.change(this, "source", _source, _source = BitmapSource.getInstance(value));
		}
		private var _source:BitmapData;
		
		[Bindable("propertyChange")]
		public function get scaling():String { return _scaling; }
		public function set scaling(value:String):void
		{
			DataChange.change(this, "scaling", _scaling, _scaling = value);
		}
		
		[Bindable("propertyChange")]
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(value:uint):void
		{
			DataChange.change(this, "backgroundColor", _backgroundColor, _backgroundColor = value);
		}
		
		[Bindable("propertyChange")]
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(value:Number):void
		{
			DataChange.change(this, "backgroundAlpha", _backgroundAlpha, _backgroundAlpha = value);
		}
		
		public function BitmapImage()
		{
		}
		
		/**
		 * @private
		 */
		[CommitProperties(target="source")]
		public function onSourceChanged(event:Event):void
		{
			if (source is String) {
				var request:URLRequest = new URLRequest(source as String);
				loader = new Loader();
				loader.load(request);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			} else if (source is Class) {
				var display:Bitmap = new (source as Class)();
//				measured.width = display.width;
//				measured.height = display.height;
				original = display.bitmapData;
				draw();
			}
		}
		
		private function onComplete(event:Event):void
		{
//			measured.width = loader.content.width;
//			measured.height = loader.content.height;
			original = (loader.content as Bitmap).bitmapData;
			draw();
		}
		
		/**
		 * @private
		 */
		[CommitProperties(target="width, height, scaling, backgroundColor, backgroundAlpha")]
		public function onSizeChange(event:Event):void
		{
			var color:uint = (_backgroundAlpha * 255) << 24 | _backgroundColor
			this.bitmapData = new BitmapData(width, height, true, color);
			this.smoothing = true;
			draw();
		}
		
		private function draw():void
		{
			if (original) {
				var mode:String = _scaling;
				var matrix:Matrix;
				
				var originalRatio:Number = original.width / original.height;
				var bitmapRatio:Number = width / height;
				
				if (_scaling == BEST_FIT) {
					if (originalRatio > bitmapRatio) {
						mode = HORIZONTAL_FIT;
					} else {
						mode = VERTICAL_FIT;
					}
				} else if (_scaling == BEST_FILL) {
					if (originalRatio > bitmapRatio) {
						mode = VERTICAL_FIT;
					} else {
						mode = HORIZONTAL_FIT;
					}
				}
				
				if (mode == HORIZONTAL_FIT) {
					var hs:Number = width / original.width;
					matrix = new Matrix(hs, 0, 0, hs, 0, (original.height * hs - height) / 2 * -1);
				} else if (mode == VERTICAL_FIT) {
					var vs:Number = height / original.height;
					matrix = new Matrix(vs, 0, 0, vs, (original.width * vs - width) / 2 * -1, 0);
				} else if (mode == SKEW) {
					matrix = new Matrix(width / original.width, 0, 0, height / original.height, 0, 0);
				}
				this.bitmapData.draw(original, matrix, null, null, null, true);
			}
		}
		
		private function resolve(m:String):*
		{
			var t:* = this[m];
			return t;
		}
		
	}
}
