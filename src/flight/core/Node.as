package flight.core
{
	import flash.geom.Rectangle;

	import flight.events.Signal;

	use namespace stealth;
	
	public class Node implements ILayout
	{
		stealth static var inv:uint = 0;
		
		public static const RENDER:uint =			1 << inv++;
		public static const UPDATE:uint =			1 << inv++;
		public static const SIZE:uint =				1 << inv++;
		public static const COMMIT:uint =			1 << inv++;
		public static const CREATE:uint =			1 << inv++;
		
		stealth var invalid:uint = 0;
		
		stealth var root:DisplayNode;
		stealth var parent:Node;
		stealth var head:Node;
		stealth var tail:Node;
		stealth var next:Node;
		stealth var prev:Node;
		
		stealth var i:Node;
		
		
		public function get signal():Signal { return _signal ||= new Signal(); }
		public function set signal(value:*):void { if (value is Function) signal.add(value); }
		private var _signal:Signal;
		
		
		public var id:String;
		
		
		public function Node()
		{
			invalid = CREATE | SIZE | UPDATE | RENDER;
		}
		
		// init forces creation of the node, where otherwise creation is deferred until added to a parent node
		final public function init():void
		{
			if (invalid & CREATE) {
				invalid &= ~CREATE;
				create();
			}
		}
		
		// kill forces destruction of this and all sub-nodes
		final public function kill():void
		{
			// destroy from bottom up
			var n:Node = this;				// current node
			n.i = head;
			while (true) {
				var c:Node = n.i;			// child node
				if (c) {
					n.i = c.next;
					n = c;
					n.i = n.head;
				} else {
					var p:Node = n.parent;
					if (!(n.invalid & CREATE)) {
						n.invalid |= CREATE;
						n.destroy();
					}

					if (n == this) {
						if (p) p.remove(n);
						break;
					}
					p.remove(n);
					n = p;
				}
			}
		}
		
		// initialization of the node
		protected function create():void
		{
		}
		
		// releases memory and assignments setup in initialization and throughout lifecycle
		protected function destroy():void
		{
		}
		
		// resolves deferred property changes
		protected function commit():void
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
		
		
		// ... primary cache buster for all layout when width or height change
		public function invalidateSize():void
		{
			if (invalid & SIZE) {
				if (root && !root.invalid) {
					root.invalidate();
				}
				invalid |= SIZE | UPDATE | RENDER;
				
				var p:Node = this;
				while (p) {
//					p.invalid |= SIZE | UPDATE | RENDER;
					// TODO: clear measure cache
					p = p.parent;
				}
			}
		}
		
		// TODO: remove in favor of inlining invalidation
		public function invalidate(phases:uint = 1):void
		{
			if (root && !(root.invalid & DisplayNode.DISPLAY)) {
				root.stage.invalidate();
				root.invalid |= DisplayNode.DISPLAY;
			}
			invalid |= phases;
		}
		
		// runs the full render cycle from this point and below, incl layout etc
		public function validateNow():void
		{
			var n:Node = this;	// current node
			var c:Node;			// child node

			n.i = n = this;
			while (true) {
				c = n.i;
				if (c) {
					if (c.invalid & COMMIT) {
						c.invalid &= ~COMMIT;
						c.commit();
					}

					n.i = c.next;
					n = c;
					n.i = n.head;
				} else {
					if (n == this) break;
					n = n.parent;
				}
			}

			n.i = n = this;
			while (true) {
				c = n.i;
				if (c) {
					if (c.invalid & SIZE) {
						c.invalid &= ~SIZE;
						c.size();
					}
					if (c.invalid & UPDATE) {
						c.invalid &= ~UPDATE;
						c.update();
					}

					n.i = c.next;
					n = c;
					n.i = n.head;
				} else {
					if (n == this) break;
					n = n.parent;
				}
			}
			
			// render from bottom up
			n = this;
			n.i = head;
			while (true) {
				c = n.i;
				if (c) {
					n.i = c.next;
					n = c;
					n.i = n.head;
				} else {
					if (n.invalid & RENDER) {
						n.invalid &= ~RENDER;
						n.render();
					}
					
					if (n == this) break;
					n = n.parent;
				}
			}
		}


		public function getLength():uint { return _getLength; }
		private var _getLength:uint;
		
		public function getParent():Node
		{
			return parent;
		}
		
		public function getHead():Node
		{
			return head;
		}
		
		public function getTail():Node
		{
			return tail;
		}
		
		public function getNext(after:Node = null):Node
		{
			return after ? after.next : next;
		}
		
		public function getPrev(before:Node = null):Node
		{
			return before ? before.prev : prev;
		}
		
		public function add(node:Node, before:Node = null):Node
		{
			if (!node) return null;
			if (node.parent) {
				node.prev ? node.prev.next = node.next : node.parent.head = node.next;
				node.next ? node.next.prev = node.prev : node.parent.tail = node.prev;
				node.prev = node.next = null;
				if (node.parent != this) {
					//node.removed();
					node.parent._getLength--;
				}
			}
			
			if (before && before.parent == this) {
				if (head == before) {
					head = node;
				} else {
					node.prev = before.prev;
					node.prev.next = node;
				}
				node.next = before;
				before.prev = node;
			} else {
				if (tail) {
					node.prev = tail;
					tail.next = node;
				} else {
					head = node;
				}
				tail = node;
			}
			
			if (node.parent != this) {
				node.parent = this;
				var root:DisplayNode = this.root;
				if (root != node.root) {
					var n:Node = node;		// current node
					n.i = n;
					while (true) {
						var c:Node = n.i;	// child node
						if (c) {
							c.root = root;
							//c.addedToStage();
							
							n.i = c.next;
							n = c;
							n.i = n.head;
						} else if (n != node) {
							n = n.parent;
						} else {
							break;
						}
					}
				}
				
				_getLength++;
				if (node.invalid & CREATE) {
					node.invalid &= ~CREATE;
					node.create();
				}
				//node.added();
			}
			
			return node;
		}
		
		public function contains(node:Node):Boolean
		{
			return node.parent == this;
		}
		
		public function swap(node1:Node, node2:Node):void
		{
			if (int(!node1) | int(!node2) ||
				int(!node1.parent) | int(!node1.parent)) return;

			var prev1:Node = node1.prev;
			var next1:Node = node1.next;
			var prev2:Node = node2.prev;
			var next2:Node = node2.next;

			node2.prev = prev1 == node2 ? node1 : prev1;
			prev1 ? node2.prev.next = node2 : head = node2;
			node2.next = next1 == node2 ? node1 : next1;
			next1 ? node2.next.prev = node2 : tail = node2;

			node1.prev = prev2 == node1 ? node2 : prev2;
			prev2 ? node1.prev.next = node1 : head = node1;
			node1.next = next2 == node1 ? node2 : next2;
			next2 ? node1.next.prev = node1 : tail = node1;
		}
		
		public function remove(node:Node):Node
		{
			if (!node || node.parent != this) return null;
			_getLength--;
			node.prev ? node.prev.next = node.next : head = node.next;
			node.next ? node.next.prev = node.prev : tail = node.prev;
			node.prev = node.next = null;
			//node.removed();
			node.parent = null;
			
			if (root != null) {
				// remove from bottom up
				var n:Node = node;		// current node
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
			
			return node;
		}
		
		public function clear():void
		{
			var root:DisplayNode = this.root;
			var node:Node = head;
			head = tail = null;
			_getLength = 0;
			while (node) {
				var next:Node = node.next;
				node.prev = node.next = null;
				//node.removed();
				node.parent = null;
				
				if (root != null) {
					// remove from bottom up
					var n:Node = node;		// current node
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
				
				node = next;
			}
		}
		
		// ====== Transform ====== //
		public function get x():Number { return _x; }
		public function set x(value:Number):void { _x = value; }
		private var _x:Number = 0;
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void { _y = value; }
		private var _y:Number = 0;
		
		public function get z():Number { return _z; }
		public function set z(value:Number):void { _z = value; }
		private var _z:Number = 0;
		
		public function get scaleX():Number { return _scaleX; }
		public function set scaleX(value:Number):void { _scaleX = value; }
		private var _scaleX:Number = 1;
		
		public function get scaleY():Number { return _scaleY; }
		public function set scaleY(value:Number):void { _scaleY = value; }
		private var _scaleY:Number = 1;
		
		public function get scaleZ():Number { return _scaleZ; }
		public function set scaleZ(value:Number):void { _scaleZ = value; }
		private var _scaleZ:Number = 1;
		
		public function get rotationX():Number { return _rotationX; }
		public function set rotationX(value:Number):void { _rotationX = value; }
		private var _rotationX:Number = 0;
		
		public function get rotationY():Number { return _rotationY; }
		public function set rotationY(value:Number):void { _rotationY = value; }
		private var _rotationY:Number = 0;
		
		public function get rotationZ():Number { return _rotationZ; }
		public function set rotationZ(value:Number):void { _rotationZ = value; }
		private var _rotationZ:Number = 0;
		
		public function get rotation():Number { return _rotationZ; }
		public function set rotation(value:Number):void { _rotationZ = value; }
		
		
		
		// ====== Layout ====== //
		stealth var visible:Boolean;
		stealth var freeform:Boolean;
		// make getters/setters with shortcuts
		stealth var marginTop:Number = 0;
		stealth var marginRight:Number = 0;
		stealth var marginBottom:Number = 0;
		stealth var marginLeft:Number = 0;
		
		stealth var top:Number;
		stealth var right:Number;
		stealth var bottom:Number;
		stealth var left:Number;
		stealth var horizontal:Number;
		stealth var vertical:Number;
		
		
		
		stealth var layout:ILayout;
		stealth var paddingTop:Number = 0;
		stealth var paddingRight:Number = 0;
		stealth var paddingBottom:Number = 0;
		stealth var paddingLeft:Number = 0;
		stealth var hGap:Number = 0;
		stealth var vGap:Number = 0;
		
		
		// TODO: determine these settings on layout vs on child
		// TODO: make these smaller data-types? uint: 0, 1, 2 ... begin, middle, end ... fill & justify
		stealth var hAlign:String;//creation 815 ms, 27876 kb - 484, 0
		stealth var vAlign:String;//creation 644 ms, 27644 kb - 484, 0
		
		
		
		// ====== Size ====== //
//		public function get width():Number { return stealth::width; }
//		public function set width(value:Number):void
//		{
//			stealth::preferredWidth = value;
//			invalidate(Node.UPDATE);
//		}
		public function get width():Number {
//			if (!layout && invalid & UPDATE)
//				validateNow();
			return _width;
		}
		public function set width(value:Number):void
		{
			if (_width != value) {
				_width = preferredWidth = value;
				if (root && !root.invalid) root.invalidate();
				invalid |= UPDATE;
			}
		}
		private var _width:Number = 0;
		
		public function get height():Number {
//			if (!layout && invalid & UPDATE)
//				validateNow();
			return _height;}
		
		public function set height(value:Number):void
		{
			if (_height != value) {
				_height = preferredHeight = value;
				if (root && !root.invalid) root.invalidate();
				invalid |= UPDATE;
				trace("setttt", invalid);
			}
		}
		private var _height:Number = 0;
		
		public function get contentWidth():Number
		{
//			if (!layout && invalid & UPDATE)
//				validateNow();
			return _contentWidth;
		}
		private var _contentWidth:Number = 0;
		
		public function get contentHeight():Number
		{
//			if (!layout && invalid & UPDATE)
//				validateNow();
			return _contentHeight;
		}
		private var _contentHeight:Number = 0;
		
		protected var preferredWidth:Number;		// explicit
		protected var preferredHeight:Number;		// explicit
		
		// TODO: implement
		public var percentWidth:Number;				// explicit
		public var percentHeight:Number;			// explicit
		
		// TODO: implement
		private var _minWidth:Number = 0;
		private var _minHeight:Number = 0;
		
		//
		stealth var sizeMode:uint = SizeMode.SCALE;
		
		
		public function setSize(w:Number = NaN, h:Number = NaN):void
		{
			
		}
		
		// measurement cache
		private var nSize:Rectangle;
		
		private var wWidth:Number;
		private var wSize:Rectangle;
		
		private var hHeight:Number;
		private var hSize:Rectangle;
		
		private var whWidth:Number;
		private var whHeight:Number;
		private var whSize:Rectangle;
		
		/*
		1) invalidate size with change in preferredSize, measuredSize
		2) validate size with call to setSize/updateSize
		3) update invalid size before calculating layout
		
		updateSize() + 'virtual' == setSize() + measure()
		 */
		public function size(w:Number = NaN, h:Number = NaN, commit:Boolean = true):Rectangle
		{
			// lookup measurement in cache
			if (w == w) {				// !isNaN(w)
				if (h == h) {			// !isNaN(h)
					if (w == whWidth && h == whHeight) return whSize;
				} else {
					if (w == wWidth) return wSize;
				}
			} else if (h == h) {		// !isNaN(h)
				if (h == hHeight) return hSize;
			} else if (nSize) {
				return nSize;
			}
			
			// BEGIN DUPLICATE CODE
			// TODO: update coordinates based on rotation/scale (parent coord space) ... for 'measure' & 'setSize' 
			// 90 or 270, swap
			// 0 or 180, don't swap
			// anything else does both 90 & 0, then combines the result proportionally
			
			// TODO: lookup measurement in cache here?? includes min/max and preferred
			if (w == w) {
				w -= marginLeft + marginRight;
				w = w <= _minWidth ? _minWidth : w;
			} else if (preferredWidth == preferredWidth) {
				w = preferredWidth;
				w = w <= _minWidth ? _minWidth : w;
			}
			
			if (h == h) {
				h -= marginTop + marginBottom;
				h = h <= _minHeight ? _minHeight : h;
			} else if (preferredHeight == preferredHeight) {
				h = preferredHeight;
				h = h <= _minHeight ? _minHeight : h;
			}
			
			// TODO: lookup measurement in cache here??
			var measured:Rectangle = layout ? layout.measureContent(head, w, h) : measure(w, h);
			measured.width = measured.width <= _minWidth ? _minWidth : measured.width;
			measured.height = measured.height <= _minHeight ? _minHeight : measured.height;
			
			// END DUPLICATE CODE
			
			if (commit) {
				// TODO: add snapToPixel
				if (w != w) {
					_contentWidth = w = measured.width;
				} else {
					_contentWidth = w < measured.width ? measured.width : w;
				}
				
				var hSizeMode:uint = (sizeMode & SizeMode.HMASK);
				if (hSizeMode == (SizeMode.SCALE & SizeMode.HMASK)) {
					_contentWidth = measured.width;
					_width = w;
					scaleX = _contentWidth ? _width / _contentWidth : 1;
				} else if (hSizeMode == (SizeMode.CONSTRAIN & SizeMode.HMASK)) {
					_width = _contentWidth;
				} else {
					_width = w;
				}
				
				if (h != h) {
					_contentHeight = h = measured.height;
				} else {
					_contentHeight = h < measured.width ? measured.width : h;
				}
				
				var vSizeMode:uint = (sizeMode & SizeMode.VMASK);
				if (vSizeMode == (SizeMode.SCALE & SizeMode.VMASK)) {
					_contentHeight = measured.height;
					_height = h;
					scaleY = _contentHeight ? _height / _contentHeight : 1;
				} else if (vSizeMode == (SizeMode.CONSTRAIN & SizeMode.VMASK)) {
					_height = _contentHeight;
				} else {
					_height = h;
				}
				
				invalid |= UPDATE;		// TODO: is this all?
			}
			trace("!!! Size:", commit, measured.width, measured.height, _width, _height, _contentWidth, _contentHeight);
			measured.width += marginLeft + marginRight;
			measured.height += marginTop + marginBottom;
			// TODO: update coordinates based on rotation/scale (parent coord space) ... for 'measure' & 'setSize' 
			// 90 or 270, swap
			// 0 or 180, don't swap
			// anything else does both 90 & 0, then combines the result proportionally
			return measured;
		}
		
		protected function measure(w:Number = NaN, h:Number = NaN):Rectangle
		{
			return measured;
		}
		private static var measured:Rectangle = new Rectangle();
		
		
		// TODO: implement BasicLayout right in the core node class
		public function measureContent(content:Node, w:Number = NaN, h:Number = NaN):Rectangle
		{ return null; }
		
		public function sizeContent(content:Node, w:Number, h:Number):void
		{}
	}
}
