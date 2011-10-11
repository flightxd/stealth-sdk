package flight.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import flight.events.InvalidationEvent;

	public class DisplayDebugger
	{
		private var root:DisplayObject;
		private var drawing:Shape; 
		
		public function DisplayDebugger(root:DisplayObject)
		{
			this.root = root;
			root.addEventListener(InvalidationEvent.VALIDATE, onValidate, false, -10, true);
			root.addEventListener(InvalidationEvent.VALIDATE, onValidate, true, 0, true);
			drawing = new Shape();
		}
		
		private function onValidate(event:InvalidationEvent):void
		{
			if (event.target != root) {
				Invalidation.invalidate(root, InvalidationEvent.VALIDATE);
			} else {
				redraw();
			}
		}
		
		private var indices:Dictionary = new Dictionary(true);
		private function redraw():void
		{
			drawing.graphics.clear();
			if (!root.stage) {
				return;
			} else {
				root.stage.addChild(drawing);
			}
			
			var current:DisplayObjectContainer = root as DisplayObjectContainer;
			var next:DisplayObject;
			
			indices[current] = 0;
			
			while (current) {
				
				next = indices[current] < current.numChildren ? current.getChildAt(indices[current]++) : null;
				if (next) {
					if (!next.visible) {
						continue;
					} else if (next is DisplayObjectContainer) {
						current = DisplayObjectContainer(next);
						indices[current] = 0;
					} else {
						drawBounds(next);
					}
				} else {
					drawBounds(current);
					delete indices[current];
					current = current != root ? current.parent : null;
				}
			}
			drawBounds(root);
		}
		
		private var colors:Dictionary = new Dictionary(true);
		private var pad:Rectangle = new Rectangle();
		private var mar:Rectangle = new Rectangle();
		private var rect:Rectangle = new Rectangle();
		private var p:Point = new Point();
		
		private function drawBounds(displayObject:DisplayObject):void
		{
			var graphics:Graphics = drawing.graphics;
			
			var color:Number = colors[displayObject] || (colors[displayObject] = Math.random() * 0xFFFFFF);
			pad.setEmpty();
			if ("padding" in displayObject && displayObject["padding"]) {
				pad.left = displayObject["padding"].left;
				pad.right = displayObject["padding"].right;
				pad.top = displayObject["padding"].top;
				pad.bottom = displayObject["padding"].bottom;
			}
			mar.setEmpty();
			if ("margin" in displayObject && displayObject["margin"]) {
				mar.left = displayObject["margin"].left;
				mar.right = displayObject["margin"].right;
				mar.top = displayObject["margin"].top;
				mar.bottom = displayObject["margin"].bottom;
			}
			
			var bounds:Rectangle = displayObject.getRect(displayObject);
			if ("contentWidth" in displayObject) {
				bounds.x = 0;
				bounds.width = displayObject["contentWidth"];
			}
			if ("contentHeight" in displayObject) {
				bounds.y = 0;
				bounds.height = displayObject["contentHeight"];
			}
			
			var m:Matrix = displayObject.transform.concatenatedMatrix;
			graphics.lineStyle();
			graphics.beginFill(color, .02);
			drawRect(graphics, bounds, m);
			graphics.endFill();
			
			graphics.beginFill(color, .25);
			drawRect(graphics, padRect(bounds, mar, false), m);
			drawRect(graphics, padRect(bounds, pad, true), m);
			graphics.endFill();
			
			graphics.lineStyle(0, color, .75);
			drawRect(graphics, bounds, m);
			graphics.endFill();
		}
		
		private function padRect(orig:Rectangle, pad:Rectangle, inset:Boolean = true):Rectangle
		{
			if (inset) {
				rect.left = orig.left + pad.left;
				rect.top = orig.top + pad.top;
				rect.right = orig.right - pad.right;
				rect.bottom = orig.bottom - pad.bottom;
			} else {
				rect.left = orig.left - pad.left;
				rect.top = orig.top - pad.top;
				rect.right = orig.right + pad.right;
				rect.bottom = orig.bottom + pad.bottom;
			}
			return rect;
		}
		
		private function drawRect(graphics:Graphics, rect:Rectangle, matrix:Matrix):void
		{
			transformPoint(rect.left, rect.top, matrix);
			graphics.moveTo(p.x, p.y);
			
			transformPoint(rect.right, rect.top, matrix);
			graphics.lineTo(p.x, p.y);
			
			transformPoint(rect.right, rect.bottom, matrix);
			graphics.lineTo(p.x, p.y);
			
			transformPoint(rect.left, rect.bottom, matrix);
			graphics.lineTo(p.x, p.y);
			
			transformPoint(rect.left, rect.top, matrix);
			graphics.lineTo(p.x, p.y);
		}
		
		private function transformPoint(x:Number, y:Number, matrix:Matrix):Point
		{
			p.x = matrix.a * x + matrix.c * y + matrix.tx;
			p.y = matrix.d * y + matrix.b * x + matrix.ty;
			return p;
		}
	}
}
