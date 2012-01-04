package flight.core
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import flight.events.Signal;

	import org.osflash.signals.ISignal;

	use namespace stealth;

	public class Node
	{
		public var id:String;

		public function Node()
		{
			_invalid = CREATE | SIZE | UPDATE | RENDER;
		}


		public function get visible():Boolean { return _visible; }
		public function set visible(value:Boolean):void
		{
			if (_visible != value) {
				_visible = value;
				if (~_invalid & RENDER) _invalid |= RENDER;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _visible:Boolean = true;


		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			if (value < 0) value = 0;
			else if (value > 1) value = 1;
			if (_alpha != value) {
				_alpha = value;
				if (~_invalid & RENDER) _invalid |= RENDER;
			}
		}
		stealth var _alpha:Number = 1;

		// TODO: add color transform???


		// ====== Size ====== //


		public function get width():Number
		{
			return _contentWidth * (_scaleX < 0 ? -_scaleX : _scaleX);				// width * absValue of scaleX
		}
		public function set width(value:Number):void
		{
			scaleX = _contentWidth ? value / _contentWidth : 1;
		}
		stealth var _contentWidth:Number = 0;

		public function get height():Number
		{
			return _contentHeight * (_scaleY < 0 ? -_scaleY : _scaleY);				// height * absValue of scale
		}
		public function set height(value:Number):void
		{
			scaleY = _contentHeight ? value / _contentHeight : 1;
		}
		stealth var _contentHeight:Number = 0;
		

		// ====== Lifecycle ====== //

		
		stealth static const INVALID:uint =		1 << 0;
		stealth static const CREATE:uint =		1 << 1;
		stealth static const DESTROY:uint =		1 << 2;
		stealth static const SIZE:uint =		1 << 3;
		stealth static const UPDATE:uint =		1 << 4;
		stealth static const RENDER:uint =		1 << 5;
		stealth static const TRANSFORM:uint =	1 << 6;

		stealth var _invalid:uint = 0;

		// initialization of the node
		protected function create():void
		{
		}

		// releases memory and assignments setup in initialization and throughout lifecycle
		protected function destroy():void
		{
		}

		// updates size and layout
		protected function update():void
		{
		}

		// renders display
		protected function render():void
		{
		}

		stealth function invalidateSize(update:Boolean = false):void
		{
			if (~_invalid & SIZE) {
				_invalid |= SIZE | (UPDATE * int(update));
				if (_root && ~_root._invalid & INVALID) _root.invalidateDisplay();
			} else if (update && ~_invalid & UPDATE) {
				_invalid |= UPDATE;
			}
		}

		// runs the full render pass from this Node through its descendants
		stealth function validateNow():void
		{
			if (_invalid & CREATE) {
				_invalid &= ~CREATE;
				create();
			}

			var n:Node = this;		// current node
			n._i = n;
			while (true) {
				var c:Node = n._i;	// child node
				if (c) {
					if (c._invalid & UPDATE) {
						c._invalid &= ~UPDATE;
						c.update();
					}
					if (c._invalid & RENDER) {
						c._invalid &= ~RENDER;
						c.render();
					}

					n._i = c._next;
					n = c;
					n._i = n._head;
				} else {
					if (n == this) break;
					n = n._parent;
				}
			}
		}

		// kill forces destruction of this and all sub-nodes
		final public function kill():void
		{
			// destroy from bottom up
			var n:Node = this;				// current node
			n._i = _head;
			while (true) {
				var c:Node = n._i;			// child node
				if (c) {
					n._i = c._next;
					n = c;
					n._i = n._head;
				} else {
					var p:Node = n._parent;
					if (~n._invalid & DESTROY) {
						n._invalid |= DESTROY;
						n.destroy();
						n._clear();
						n._added = null;
						n._removed = null;
						n._addedToRoot = null;
						n._removedFromRoot = null;
					}

					if (n == this) break;
					n = p;
				}
			}

			if (_parent) {
				_parent._remove(n);
			}
		}


		// ====== Transform ====== //


		public function get x():Number { return _x; }
		public function set x(value:Number):void
		{
			if (_x != value) {
				_x = value;
				if (_display) _display.x = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _x:Number = 0;

		public function get y():Number { return _y; }
		public function set y(value:Number):void
		{
			if (_y != value) {
				_y = value;
				if (_display) _display.y = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _y:Number = 0;

		public function get z():Number { return _z; }
		public function set z(value:Number):void
		{
			if (_z != value) {
				_z = value;
				if (_display) _display.z = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _z:Number = 0;

		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void
		{
			if (_scaleX != value) {
				_scaleX = value;
				if (_display) _display.scaleX = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _scaleX:Number = 1;

		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void
		{
			if (_scaleY != value) {
				_scaleY = value;
				if (_display) _display.scaleY = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _scaleY:Number = 1;

		public function get scaleZ():Number { return _scaleZ; }
		public function set scaleZ(value:Number):void
		{
			if (_scaleZ != value) {
				_scaleZ = value;
				if (_display) _display.scaleZ = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _scaleZ:Number = 1;

		public function get rotationX():Number { return _rotationX; }
		public function set rotationX(value:Number):void
		{
			if (_rotationX != value) {
				_rotationX = value;
				if (_display) _display.rotationX = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
				}
			}
		}
		stealth var _rotationX:Number = 0;

		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void
		{
			if (_rotationY != value) {
				_rotationY = value;
				if (_display) _display.rotationY = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _rotationY:Number = 0;

		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void
		{
			if (_rotationZ != value) {
				_rotationZ = value;
				if (_display) _display.rotation = value;
				if (~_invalid & TRANSFORM) {
					_invalid |= TRANSFORM;
					if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
						_parent.invalidateSize(true);
					}
				}
			}
		}
		stealth var _rotationZ:Number = 0;

		public function get rotation():Number { return _rotationZ; }
		public function set rotation(value:Number):void
		{
			rotationZ = value;
		}



		// ====== Containment ====== //


		public function get added():ISignal { return _added ||= new Signal(); }
		public function set added(value:*):void{ added.add(value); }
		stealth var _added:ISignal;

		public function get removed():ISignal { return _removed ||= new Signal(); }
		public function set removed(value:*):void{ removed.add(value); }
		stealth var _removed:ISignal;

		public function get addedToRoot():ISignal { return _addedToRoot ||= new Signal(); }
		public function set addedToRoot(value:*):void{ addedToRoot.add(value); }
		stealth var _addedToRoot:ISignal;

		public function get removedFromRoot():ISignal { return _removedFromRoot ||= new Signal(); }
		public function set removedFromRoot(value:*):void{ removedFromRoot.add(value); }
		stealth var _removedFromRoot:ISignal;

		stealth var _i:Node;
		stealth var _root:Node;
		stealth var _parent:Node;
		stealth var _prev:Node;
		stealth var _next:Node;
		stealth var _length:uint;
		stealth var _head:Node;
		stealth var _tail:Node;

		stealth function _add(node:Node, before:Node = null):Node
		{
			if (!node) return null;
			if (node._parent) {

				if (node._parent != this) {
					if (node._removed)	node._removed.dispatch();
					if (node._root)		node.removeFromRoot();
					node._parent._length--;
					if (~node._parent._invalid & (SIZE | UPDATE)) {
						node._parent.invalidateSize(true);
					}
				}

				node._prev ? node._prev._next = node._next : node._parent._head = node._next;
				node._next ? node._next._prev = node._prev : node._parent._tail = node._prev;
				node._prev = node._next = null;

			} else if (node._invalid & CREATE) {
				node._invalid &= ~CREATE;
				node.create();
			}

			if (before && before._parent == this) {
				if (before != _head) {
					node._prev = before._prev;
					node._prev._next = node;
				} else _head = node;

				node._next = before;
				before._prev = node;
			} else {
				if (_tail) {
					node._prev = _tail;
					_tail._next = node;
				} else _head = node;
				_tail = node;
			}

			if (node._parent != this) {
				node._parent = this;
				_length++;

				if (_root) node.addToRoot(_root);
				if (node._added) node._added.dispatch();
			}

			if (~_invalid & (SIZE | UPDATE)) {
				invalidateSize(true);
			}
			return node;
		}

		stealth function _contains(node:Node):Boolean
		{
			return node._parent == this;
		}

		stealth function _swap(node1:Node, node2:Node):void
		{
			if (int(!node1)				   | int(!node2) ||
				int(node1._parent != this) | int(node2._parent != this)) return;

			var prev1:Node = node1._prev;
			var next1:Node = node1._next;
			var prev2:Node = node2._prev;
			var next2:Node = node2._next;

			node2._prev = prev1 == node2 ? node1 : prev1;
			node2._next = next1 == node2 ? node1 : next1;
			node1._prev = prev2 == node1 ? node2 : prev2;
			node1._next = next2 == node1 ? node2 : next2;

			prev1 ? node2._prev._next = node2 : _head = node2;
			next1 ? node2._next._prev = node2 : _tail = node2;
			prev2 ? node1._prev._next = node1 : _head = node1;
			next2 ? node1._next._prev = node1 : _tail = node1;

			if (~_invalid & (SIZE | UPDATE)) {
				invalidateSize(true);
			}
		}

		stealth function _remove(node:Node):Node
		{
			if (!node || node._parent != this) return null;

			if (node._removed)	node._removed.dispatch();
			if (node._root)		node.removeFromRoot();

			node._prev ? node._prev._next = node._next : _head = node._next;
			node._next ? node._next._prev = node._prev : _tail = node._prev;
			node._prev = node._next = null;
			node._parent = null;
			_length--;

			if (~_invalid & (SIZE | UPDATE)) {
				invalidateSize(true);
			}
			return node;
		}

		stealth function _clear():void
		{
			var node:Node = _head;
			while (node) {
				if (node._removed)	node._removed.dispatch();
				if (node._root)		node.removeFromRoot();
				node = node._next;
			}

			node = _head;
			while (node) {
				var next:Node = node._next;
				node._prev = null;
				node._next = null;
				node._parent = null;
				node = next;
			}

			_head = null;
			_tail = null;
			_length = 0;

			if (~_invalid & (SIZE | UPDATE)) {
				invalidateSize(true);
			}
		}

		stealth function addToRoot(r:Node):void
		{
			if (_root == r) return;

			var n:Node = this;		// current node
			n._i = n;
			while (true) {
				var c:Node = n._i;	// child node
				if (c) {
					c._root = r;
					if (c._addedToRoot) {
						c._addedToRoot.dispatch();
					}

					n._i = c._next;
					n = c;
					n._i = n._head;
				} else if (n != this) {
					n = n._parent;
				} else {
					break;
				}
			}
		}

		stealth function removeFromRoot():void
		{
			if (!_root) return;

			// remove from bottom up
			var n:Node = this;		// current node
			n._i = _head;
			while (true) {
				var c:Node = n._i;	// child node
				if (c) {
					n._i = c._next;
					n = c;
					n._i = n._head;
				} else {
					if (n._removedFromRoot) {
						n._removedFromRoot.dispatch();
					}
					n._root = null;

					if (n == this) break;
					n = n._parent;
				}
			}
		}





		// ====== Display ====== //


		stealth static var displayNodes:Dictionary = new Dictionary();
		stealth var graphics:Graphics;

		public function get display():DisplayObject { return _display; }
		public function set display(value:DisplayObject):void
		{
			if (_display == value) return;
			if (_display) {
				_display.removeEventListener(Event.ADDED, onChildAdded, true);
				_display.removeEventListener(Event.REMOVED, onChildRemoved, true);
				_display.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				_clear();
				id = null;
				delete displayNodes[_display];
			}

			_display = value;

			if (_display) {
				displayNodes[_display] = this;
				id = _display.name;
				if ("graphics" in _display) {
					graphics = _display["graphics"];
				}

				if (_display is DisplayObjectContainer) {
					_display.addEventListener(Event.ADDED, onChildAdded, true);
					_display.addEventListener(Event.REMOVED, onChildRemoved, true);

					var container:DisplayObjectContainer = _display as DisplayObjectContainer;
					var numChildren:int = container.numChildren;
					for (var i:int = 0; i < numChildren; i++) {
						var child:DisplayObject = container.getChildAt(i);
						if (displayNodes[child]) {
							_add(displayNodes[child]);
						}
					}
				}

				_display.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				if (_display.stage) {
					onAddedToStage(null);
				}
			}
		}
		stealth var _display:DisplayObject;

		// if no parent, establishes displayNode as a fragment root 
		private function onAddedToStage(event:Event):void
		{
			var stage:Stage = _display.stage;

			// if null parent, establish as fragment root
			if (_parent) return;

			var level:int = 0;
			var d:DisplayObject = _display;
			while (d = d.parent) {
				++level;
			}
			// establish this DisplayNode as the root of this fragment
			_invalid |= INVALID;
			stage.invalidate();
			stage.addEventListener(Event.RENDER, onStageRender, false, level);
			stage.addEventListener(Event.RESIZE, onStageRender, false, level);
			_display.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			addToRoot(this);

			// inlined init()
			if (_invalid & CREATE) {
				_invalid &= ~CREATE;
				create();
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			var targetStage:Stage = _display.stage;
			targetStage.removeEventListener(Event.RENDER, onStageRender);
			targetStage.removeEventListener(Event.RESIZE, onStageRender);
			_display.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			removeFromRoot();
		}

		private function onChildAdded(event:Event):void
		{
			if (event.target.parent != _display) return;

			if (displayNodes[event.target]) {
				_add(displayNodes[event.target]);
			}
		}

		private function onChildRemoved(event:Event):void
		{
			if (event.target.parent != _display) return;
			if (displayNodes[event.target]) {
				_remove(displayNodes[event.target]);
			}
		}

		private function onStageRender(event:Event):void
		{
			if (_invalid & INVALID) {
				validateNow();
				_invalid &= ~INVALID;
			}
		}

		stealth function invalidateDisplay():void
		{
			if (~_invalid & INVALID) {
				_invalid |= INVALID;
				_display.stage.invalidate();
			}
		}
	}
}
