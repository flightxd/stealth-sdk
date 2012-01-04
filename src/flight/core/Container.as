/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.core
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	use namespace stealth;
	
	public class Container extends UINode implements ILayout
	{
		public function Container()
		{
			_contained = _container = this;
			_container = this;
		}

		// ====== Containment ====== //
		
		stealth var _contained:Container;
		stealth var _container:Container;

		public function get root():Node { return _root; }

		public function get parent():Container { return Container(_contained._parent); }

		public function get prev():Node { return _prev; }

		public function get next():Node { return _next; }

		public function get length():uint { return _container._length; }

		public function get head():Node { return _container._head; }

		public function get tail():Node { return _container._tail; }


		public function add(node:Node, before:Node = null):Node
		{
			return _container._add(node, before);
		}
		
		public function contains(node:Node):Boolean
		{
			return _container._contains(node);
		}
		
		public function swap(node1:Node, node2:Node):void
		{
			_container._swap(node1, node2);
		}
		
		public function remove(node:Node):Node
		{
			return _container._remove(node);
		}

		public function clear():void
		{
			_container._clear();
		}

//		stealth function invalidate():void
//		{
//			if (~_invalid & INVALID) {
//				_invalid |= INVALID;
//			}
//		}
		
		// ====== Layout ====== //


		override protected function update():void
		{
			if (_layout) {
				_layout.updateLayout(_head, _contentWidth, _contentHeight);
			}
		}
		
		override protected function measureContent(measured:Rectangle, w:Number = NaN, h:Number = NaN):void
		{
			if (_layout) {
				_layout.measureLayout(measured, _head, w, h);
			}
		}

		public function get layout():ILayout { return _container._layout; }
		public function set layout(value:ILayout):void
		{
			if (_container._layout != value) {
				_container._layout = value;
				if (~_container._invalid & (SIZE | UPDATE))
					_container.invalidateSize(true);
			}
		}
		stealth var _layout:*;

		public function get contentAlign():uint { return _contentAlign; }
		public function set contentAlign(value:uint):void
		{
			if (_contentAlign != value) {
				_contentAlign = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _contentAlign:uint = Align.BEGIN;

		public function get paddingTop():Number { return _paddingTop; }
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop != value) {
				_paddingTop = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _paddingTop:Number = 0;

		public function get paddingRight():Number { return _paddingRight; }
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight != value) {
				_paddingRight = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _paddingRight:Number = 0;

		public function get paddingBottom():Number { return _paddingBottom; }
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom != value) {
				_paddingBottom = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _paddingBottom:Number = 0;

		public function get paddingLeft():Number { return _paddingLeft; }
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft != value) {
				_paddingLeft = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _paddingLeft:Number = 0;

		public function set padding(value:*):void
		{
			if (value is Number) {
				_paddingTop = _paddingRight = _paddingBottom = _paddingLeft = value as Number;
			} else if (value is String) {
				var values:Array = (value as String).replace(/[,\s]+/g, " ").split(" ");
				switch (values.length) {
					case 1 :
						_paddingTop = _paddingRight = _paddingBottom = _paddingLeft = Number(values[0]);
						break;
					case 2 :
						_paddingTop = _paddingBottom = Number(values[0]);
						_paddingRight = _paddingLeft = Number(values[1]);
						break;
					case 3 :
						_paddingTop = Number(values[0]);
						_paddingRight = _paddingLeft = Number(values[1]);
						_paddingBottom = Number(values[2]);
						break;
					case 4 :
						_paddingTop = Number(values[0]);
						_paddingRight = Number(values[1]);
						_paddingBottom = Number(values[2]);
						_paddingLeft = Number(values[3]);
						break;
				}
			}
			if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
				_parent.invalidateSize(true);
			}
		}

		public function get hGap():Number { return _hGap; }
		public function set hGap(value:Number):void
		{
			if (_hGap != value) {
				_hGap = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _hGap:Number = 0;

		public function get vGap():Number { return _vGap; }
		public function set vGap(value:Number):void
		{
			if (_vGap != value) {
				_vGap = value;
				if (~_invalid & (SIZE | UPDATE))
					invalidateSize(true);
			}
		}
		stealth var _vGap:Number = 0;



		// TODO: implement BasicLayout right in the core node class
		public function measureLayout(measured:Rectangle, content:Node, w:Number = NaN, h:Number = NaN):void
		{
			while (content) {
				var ui:UINode = content as UINode;
				content = content._next;
				if (ui || ui._freeform || !ui._visible) {
					continue;
				}

				var horz:Number = 0;			// horizontal white space
				var vert:Number = 0;			// vertical white space
				var mw:Number = NaN;			// width for measurement
				var mh:Number = NaN;			// height for measurement
				var percentWidth:Number = ui.preferredWidth >= 0.01 ? NaN : ui.preferredWidth / .001 % 10;
				var percentHeight:Number = ui.preferredHeight >= 0.01 ? NaN : ui.preferredHeight / .001 % 10;

				// measure along horizontal axis
				if (ui._horizontal != ui._horizontal) {
					var hPercent:Number = NaN;
					var hOffset:Number = NaN;
				} else {
					hPercent = ui._horizontal / .001 % 10 || .5;
					hOffset = int(ui._horizontal / .01) * .01;
				}
				if (ui._left == ui._left) {
					if (ui._right == ui._right) {
						horz = ui._left + ui._right;
						mw = w - horz;
					} else if (hPercent) {
						horz = ui._left - hOffset;
						mw = w * hPercent - horz;
					} else {
						horz = ui._left;
					}
				} else if (ui._right == ui._right) {
					if (hPercent) {
						horz = ui._right + hOffset;
						mw = w * (1-hPercent) - horz;
					} else {
						horz = ui._right;
					}
				} else if (hPercent) {
					horz = hOffset < 0 ? -hOffset : hOffset;
				} else {
				}

				// measure along vertical axis
				if (ui._vertical != ui._vertical) {
					var vPercent:Number = NaN;
					var vOffset:Number = NaN;
				} else {
					vPercent = ui._vertical / .001 % 10 || .5;
					vOffset = int(ui._vertical / .01) * .01;
				}
				if (ui._top == ui._top) {
					if (ui._bottom == ui._bottom) {
						vert = ui._top + ui._bottom;
						mh = h - vert;
					} else if (vPercent) {
						vert = ui._top - vOffset;
						mh = h * vPercent - vert;
					} else {
						vert = ui._top;
					}
				} else if (ui._bottom == ui._bottom) {
					if (vPercent) {
						vert = ui._bottom + vOffset;
						mh = h * (1-vPercent) - vert;
					} else {
						vert = ui._bottom;
					}
				} else if (vPercent) {
					vert = vOffset < 0 ? -vOffset : vOffset;
				} else {
				}

				var size:Point = ui.measure(mw, mh);
				if (!(w > size.x + horz)) w = size.x + horz;
				if (!(h > size.y + vert)) h = size.y + vert;
			}
			measured.x = 0;
			measured.y = 0;
			measured.width = w;
			measured.height = h;
		}

		public function updateLayout(content:Node, w:Number, h:Number):void
		{
			while (content) {
				var ui:UINode = content as UINode;
				content = content._next;
				if (ui || ui._freeform || !ui._visible) {
					continue;
				}

				var mw:Number = NaN;
				var mh:Number = NaN;

				// layout along horizontal axis
				if (ui._horizontal != ui._horizontal) {
					var hPercent:Number = NaN;
					var hOffset:Number = NaN;
				} else {
					hPercent = ui._horizontal / .001 % 10 || .5;
					hOffset = int(ui._horizontal / .01) * .01;
				}
				if (ui._left == ui._left) {
					if (ui._right == ui._right) {
						mw = w - ui._left - ui._right;
					} else if (hPercent) {
						mw = w * hPercent + hOffset - ui._left;
					} else {
					}
				} else if (ui._right == ui._right) {
					if (hPercent) {
						mw = w * (1-hPercent) - hOffset - ui._right;
					} else {
					}
				} else if (hPercent) {
				} else {
				}

				// measure along vertical axis
				if (ui._vertical != ui._vertical) {
					var vPercent:Number = NaN;
					var vOffset:Number = NaN;
				} else {
					vPercent = ui._vertical / .001 % 10 || .5;
					vOffset = int(ui._vertical / .01) * .01;
				}
				if (ui._top == ui._top) {
					if (ui._bottom == ui._bottom) {
						mh = h - ui._top - ui._bottom;
					} else if (vPercent) {
						mh = h * vPercent + vOffset - ui._top;
					} else {
					}
				} else if (ui._bottom == ui._bottom) {
					if (vPercent) {
						mh = h * (1-vPercent) - vOffset - ui._bottom;
					} else {
					}
				} else if (vPercent) {
				} else {
				}

				var size:Point = ui.measure(mw, mh);
				var x:Number = NaN;
				var y:Number = NaN;

				if (ui._left == ui._left) {
					x = ui._left;
				} else if (ui._right == ui._right) {
					x = w - size.x - ui._right;
				} else if (hPercent) {
					x = (w - size.x) * hPercent + hOffset;
				} else {
				}

				if (ui._top == ui._top) {
					y = ui._top;
				} else if (ui._bottom == ui._bottom) {
					y = h - size.y - ui._bottom;
				} else if (vPercent) {
					y = (h - size.y) * vPercent + vOffset;
				} else {
				}

				ui.size(mw, mh, x, y);
			}
		}
		
	}
}

