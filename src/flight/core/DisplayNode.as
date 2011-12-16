package flight.core
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	use namespace stealth;
	
	public class DisplayNode extends Node
	{
		stealth static var displayNodes:Dictionary = new Dictionary();

		public static const DISPLAY:uint =			1 << inv++;
		stealth var stage:Stage;
		
		// ====== Graphics ====== //
		private var graphicsPath:GraphicsPath;
		private var graphicsData:Vector.<IGraphicsData>;
		private var bitmapData:BitmapData;
		
		public function DisplayNode(target:DisplayObject = null)
		{
			this.target = target;
		}
		
		public function get target():DisplayObject { return _target; }
		public function set target(value:DisplayObject):void
		{
			if (_target == value) return;
			if (_target) {
				_target.removeEventListener(Event.ADDED, onChildAdded, true);
				_target.removeEventListener(Event.REMOVED, onChildRemoved, true);
				_target.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				clear();
				id = null;
				delete displayNodes[_target];
			}
			
			_target = value;
			
			if (_target) {
				displayNodes[_target] = this;
				id = _target.name;
				
				if (_target is DisplayObjectContainer) {
					_target.addEventListener(Event.ADDED, onChildAdded, true);
					_target.addEventListener(Event.REMOVED, onChildRemoved, true);
	
					var container:DisplayObjectContainer = _target as DisplayObjectContainer;
					var numChildren:int = container.numChildren;
					for (var i:int = 0; i < numChildren; i++) {
						var child:DisplayObject = container.getChildAt(i);
						if (displayNodes[child]) {
							add(displayNodes[child]);
						}
					}
				}
				
				_target.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				if (_target.stage) {
					onAddedToStage(null);
				}
			}
		}
		private var _target:DisplayObject;
		
		public function invalidateDisplay():void
		{
			if (invalid & DISPLAY) return;
			
			stage.invalidate();
			invalid |= DISPLAY;
		}
		
		// if no parent, establishes displayNode as a fragment root 
		private function onAddedToStage(event:Event):void
		{
			stage = _target.stage;
			if (parent) return;
			
			var level:int = 0;
			var d:DisplayObject = _target;
			while (d = d.parent) {
				++level;
			}
			// establish this DisplayNode as the root of this fragment
			stage.invalidate();
			stage.addEventListener(Event.RENDER, onStageRender, false, level);
			stage.addEventListener(Event.RESIZE, onStageRender, false, level);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			var n:Node = this;		// current node
			n.i = n;
			while (true) {
				var c:Node = n.i;	// child node
				if (c) {
					c.root = this;
					//c.addedToStage();
					
					n.i = c.next;
					n = c;
					n.i = n.head;
				} else if (n != this) {
					n = n.parent;
				} else {
					break;
				}
			}
			
			// inlined init()
			if (invalid & CREATE) {
				invalid &= ~CREATE;
				create();
			}
		}
		
		private function onRemovedFromStage(event:Event):void
		{
			var targetStage:Stage = _target.stage;
			targetStage.removeEventListener(Event.RENDER, onStageRender);
			targetStage.removeEventListener(Event.RESIZE, onStageRender);
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			// remove from bottom up
			var n:Node = this;		// current node
			n.i = head;
			while (true) {
				var c:Node = n.i;	// child node
				if (c) {
					n.i = c.next;
					n = c;
					n.i = n.head;
				} else {
					//n.removedFromStage();
					n.root = null;
					
					if (n == this) break;
					n = n.parent;
				}
			}
		}
		
		private function onStageRender(event:Event):void
		{
			validateNow();
		}
		
		private function onChildAdded(event:Event):void
		{
			if (event.target.parent != this) return;
			
			if (displayNodes[event.target]) {
				add(displayNodes[event.target]);
			}
		}
		
		private function onChildRemoved(event:Event):void
		{
			if (event.target.parent != this) return;
			if (displayNodes[event.target]) {
				remove(displayNodes[event.target]);
			}
		}
		
		stealth var create:Function;
		override protected function create():void
		{
			super.create();
			if (stealth::create) {
				stealth::create();
			}
			trace("::create");
		}
		
		stealth var destroy:Function;
		override protected function destroy():void
		{
			trace("::destroy");
			super.destroy();
			if (stealth::destroy) {
				stealth::destroy();
			}
		}

		stealth var commit:Function;
		override protected function commit():void
		{
			trace("::commit");
			super.commit();
			if (stealth::commit) {
				stealth::commit();
			}
		}

		stealth var update:Function;
		override protected function update():void
		{
			trace("::update");
			super.update();
			if (stealth::update) {
				stealth::update();
			}
		}

		stealth var render:Function;
		override protected function render():void
		{
			trace("::render");
			super.render();
			if (stealth::render) {
				stealth::render();
			}
			trace("setting", width, height);
		}
		
		override public function size(w:Number = NaN, h:Number = NaN, commit:Boolean = true):Rectangle
		{
			return super.size(w, h, commit);
		}

		stealth var measure:Function;
		override protected function measure(w:Number = NaN, h:Number = NaN):Rectangle
		{
			trace("::measure");
			if (stealth::measure) {
				return stealth::measure(w, h);
			} else {
				return _target.getRect(_target);
			}
		}


		override public function get x():Number { return _target.x; }
		override public function set x(value:Number):void { _target.x = value; }

		override public function get y():Number { return _target.y; }
		override public function set y(value:Number):void { _target.y = value; }

		override public function get z():Number { return _target.z; }
		override public function set z(value:Number):void { _target.z = value; }

		override public function get scaleX():Number { return _target.scaleX; }
		override public function set scaleX(value:Number):void { _target.scaleX = value; }

		override public function get scaleY():Number { return _target.scaleY; }
		override public function set scaleY(value:Number):void { _target.scaleY = value; }

		override public function get scaleZ():Number { return _target.scaleZ; }
		override public function set scaleZ(value:Number):void { _target.scaleZ = value; }

		override public function get rotationX():Number { return _target.rotationX; }
		override public function set rotationX(value:Number):void { _target.rotationX = value; }

		override public function get rotationY():Number { return _target.rotationY; }
		override public function set rotationY(value:Number):void { _target.rotationY = value; }

		override public function get rotationZ():Number { return _target.rotationZ; }
		override public function set rotationZ(value:Number):void { _target.rotationZ = value; }

		override public function get rotation():Number { return _target.rotationZ; }
		override public function set rotation(value:Number):void { _target.rotationZ = value; }
	}
}
