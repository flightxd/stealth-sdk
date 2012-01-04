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
	
	public class UINode extends Node
	{
		public function UINode()
		{
			_invalid |= INVALID;
		}
		
		override protected function destroy():void
		{
			if (_display) display = null;
			super.destroy();
		}

		override public function set rotationZ(value:Number):void
		{
			if (_rotationZ != value) {
				super.rotationZ = value;
				direction = Math.round(_rotationZ / 90) % 4;
			}
		}
		private var direction:int = 0;


		// ====== Size ====== //


		override public function get width():Number
		{
			if (_invalid & SIZE) size();
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (preferredWidth != value) {
				preferredWidth = value;
				if (~_invalid & SIZE)
					invalidateSize();
			}
		}
		private var _width:Number = 0;
		stealth var preferredWidth:Number;

		
		override public function get height():Number
		{
			if (_invalid & SIZE) size();
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (preferredHeight != value) {
				preferredHeight = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}
		private var _height:Number = 0;
		stealth var preferredHeight:Number;


		public function get percentWidth():Number
		{
			return preferredWidth / 0.001;
		}
		public function set percentWidth(value:Number):void
		{
			// values of 3 or larger are reduced to a range of 0-1 range rather than 0-100
			value *= value < 3 ? 0.001 : 0.00001;
			if (preferredWidth != value) {
				preferredWidth = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}

		public function get percentHeight():Number
		{
			return preferredHeight / 0.001;
		}
		public function set percentHeight(value:Number):void
		{
			// values of 3 or larger are reduced to a range of 0-1 range rather than 0-100
			value *= value < 3 ? 0.001 : 0.00001;
			if (preferredHeight != value) {
				preferredHeight = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}
		
		
		public function get contentWidth():Number
		{
			if (_invalid & SIZE) size();
			return _contentWidth;
		}

		public function get contentHeight():Number
		{
			if (_invalid & SIZE) size();
			return _contentHeight;
		}

		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			if (_minWidth != value) {
				_minWidth = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}
		stealth var _minWidth:Number = 0;

		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			if (_minHeight != value) {
				_minHeight = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}
		stealth var _minHeight:Number = 0;


		public function get sizeMode():uint { return _sizeMode; }
		public function set sizeMode(value:uint):void
		{
			if (_sizeMode != value) {
				if ((_sizeMode & SizeMode.HMASK) == (SizeMode.SCALE & SizeMode.HMASK)) scaleX = 1;
				if ((_sizeMode & SizeMode.VMASK) == (SizeMode.SCALE & SizeMode.VMASK)) scaleY = 1;

				_sizeMode = value;
				if (~_invalid & SIZE) {
					invalidateSize();
				}
			}
		}
		stealth var _sizeMode:uint = SizeMode.SCALE;


		override stealth function invalidateSize(update:Boolean = false):void
		{
			if (update && ~_invalid & UPDATE) {
				_invalid |= UPDATE;
			}

			if (~_invalid & SIZE) {

				var node:UINode = this;
				do {

					node.$_matched = false;
					node.$w_matchedWidth = NaN;
					node.$h_matchedHeight = NaN;
					node.$wh_matchedWidth = NaN;

					node._invalid |= SIZE;
					node = node._parent as UINode;
				} while (node && ~node._invalid & SIZE);

				if (_root && ~_root._invalid & INVALID) _root.invalidateDisplay();
			}
		}
		
		// ====== Layout Data ====== //

		
		public function get freeform():Boolean { return _freeform; }
		public function set freeform(value:Boolean):void
		{
			if (_freeform != value) {
				_freeform = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _freeform:Boolean = false;

		public function get marginTop():Number { return _marginTop; }
		public function set marginTop(value:Number):void
		{
			if (_marginTop != value) {
				_marginTop = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _marginTop:Number = 0;

		public function get marginRight():Number { return _marginRight; }
		public function set marginRight(value:Number):void
		{
			if (_marginRight != value) {
				_marginRight = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _marginRight:Number = 0;

		public function get marginBottom():Number { return _marginBottom; }
		public function set marginBottom(value:Number):void
		{
			if (_marginBottom != value) {
				_marginBottom = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _marginBottom:Number = 0;

		public function get marginLeft():Number { return _marginLeft; }
		public function set marginLeft(value:Number):void
		{
			if (_marginLeft != value) {
				_marginLeft = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _marginLeft:Number = 0;

		public function set margin(value:*):void
		{
			if (value is Number) {
				_marginTop = _marginRight = _marginBottom = _marginLeft = value as Number;
			} else if (value is String) {
				var values:Array = (value as String).replace(/[,\s]+/g, " ").split(" ");
				switch (values.length) {
					case 1 :
						_marginTop = _marginRight = _marginBottom = _marginLeft = Number(values[0]);
						break;
					case 2 :
						_marginTop = _marginBottom = Number(values[0]);
						_marginRight = _marginLeft = Number(values[1]);
						break;
					case 3 :
						_marginTop = Number(values[0]);
						_marginRight = _marginLeft = Number(values[1]);
						_marginBottom = Number(values[2]);
						break;
					case 4 :
						_marginTop = Number(values[0]);
						_marginRight = Number(values[1]);
						_marginBottom = Number(values[2]);
						_marginLeft = Number(values[3]);
						break;
				}
			}
			if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
				_parent.invalidateSize(true);
			}
		}


		public function get top():Number { return _top; }
		public function set top(value:Number):void
		{
			if (_top != value) {
				_top = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _top:Number;

		public function get right():Number { return _right; }
		public function set right(value:Number):void
		{
			if (_right != value) {
				_right = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _right:Number;

		public function get bottom():Number { return _bottom; }
		public function set bottom(value:Number):void
		{
			if (_bottom != value) {
				_bottom = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _bottom:Number;

		public function get left():Number { return _left; }
		public function set left(value:Number):void
		{
			if (_left != value) {
				_left = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _left:Number;

		public function get horizontal():Number { return _horizontal; }
		public function set horizontal(value:Number):void
		{
			if (_horizontal != value) {
				_horizontal = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _horizontal:Number;

		public function get vertical():Number { return _vertical; }
		public function set vertical(value:Number):void
		{
			if (_vertical != value) {
				_vertical = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _vertical:Number;

		public function get align():uint { return _align; }
		public function set align(value:uint):void
		{
			if (_align != value) {
				_align = value;
				if (_parent && ~_parent._invalid & (SIZE | UPDATE)) {
					_parent.invalidateSize(true);
				}
			}
		}
		stealth var _align:uint = Align.BEGIN;


		// ====== Size ====== //

		// measurement cache
		// cached size where neither width or height are defined (the unconstrained size)
		private var $_matched:Boolean;
		private var $_cachedRect:Measurement;

		// cached size where only width is defined
		private var $w_matchedWidth:Number;
		private var $w_cachedRect:Measurement;

		// cached size where only height is defined
		private var $h_matchedHeight:Number;
		private var $h_cachedRect:Measurement;

		// cached size where both width and height are defined
		private var $wh_matchedWidth:Number;
		private var $wh_matchedHeight:Number;
		private var $wh_cachedRect:Measurement;

		public function size(w:Number = NaN, h:Number = NaN, x:Number = NaN, y:Number = NaN):void
		{
			_invalid &= ~SIZE;
			var hScaling:Boolean = (_sizeMode & SizeMode.HMASK) == (SizeMode.SCALE & SizeMode.HMASK);
			var vScaling:Boolean = (_sizeMode & SizeMode.VMASK) == (SizeMode.SCALE & SizeMode.VMASK);
	
			if (direction % 2) {
				var swap:Number = w;
				w = h;
				h = swap;
			}
	
			if (w == w) {
				w = (!hScaling ? w / scaleX : w) - _marginLeft - _marginRight;
				w = w <= _minWidth ? _minWidth : w;
			} else if (preferredWidth == preferredWidth) {
				w = preferredWidth;
				w = w <= _minWidth ? _minWidth : w;
			}
	
			if (h == h) {
				h = (!vScaling ? h / scaleY : h) - _marginTop - _marginBottom;
				h = h <= _minHeight ? _minHeight : h;
			} else if (preferredHeight == preferredHeight) {
				h = preferredHeight;
				h = h <= _minHeight ? _minHeight : h;
			}
	
			// a measurement is required whether setting or getting size
			var m:Measurement;
			measurement: {
				// lookup measurement in cache
				if (w == w) {				// !isNaN(w)
					if (h == h) {			// !isNaN(h)
						m = $wh_cachedRect ||= new Measurement();
						if (w == $wh_matchedWidth &&
							h == $wh_matchedHeight) break measurement;
						$wh_matchedWidth = w;
						$wh_matchedHeight = h;
					} else {
						m = $w_cachedRect ||= new Measurement();
						if (w == $w_matchedWidth) break measurement;
						$w_matchedWidth = w;
					}
				} else if (h == h) {		// !isNaN(h)
					m = $h_cachedRect ||= new Measurement();
					if (h == $h_matchedHeight) break measurement;
					$h_matchedHeight = h;
				} else {
					m = $_cachedRect ||= new Measurement();
					if ($_matched) break measurement;
					$_matched = true;
				}
	
				// if not found in cache, process measurement, storing new measurement in cache
				measureContent(m, w, h);
	
				if (m.width < _minWidth) m.width = _minWidth;
				if (m.height < _minHeight) m.height = _minHeight;
				m.w = w == w ? w : m.width;
				m.h = h == h ? h : m.height;
	
				if (!hScaling) {
					if (m.width < m.w) {
						m.width = m.w;
					} else if ((_sizeMode & SizeMode.HMASK) == (SizeMode.CONSTRAIN & SizeMode.HMASK)) {
						m.w = m.width;
					}
				}
				if (!vScaling) {
					if (m.height < m.h) {
						m.height = m.h;
					} else if ((_sizeMode & SizeMode.VMASK) == (SizeMode.CONSTRAIN & SizeMode.VMASK)) {
						m.h = m.height;
					}
				}
			}
	
			_width = m.w;
			_height = m.h;
			if (_contentWidth != m.width || _contentHeight != m.height) {
				_contentWidth = m.width;
				_contentHeight = m.height;
				
				_invalid |= UPDATE | RENDER;
				if (_root && ~_root._invalid & INVALID) _root.invalidateDisplay();
			}
	
			if (hScaling) {
				scaleX = _contentWidth ? _width / _contentWidth : 1;						// TODO: how to avoid setting scaleX from invalidating parent?
			}
			if (vScaling) {
				scaleY = _contentHeight ? _height / _contentHeight : 1;
			}
	
			// TODO: translate to be on the left/top edge
			if (x == x) this.x = x;
			if (y == y) this.y = y;
		}
	
		public function measure(w:Number = NaN, h:Number = NaN):Point
		{
			// TODO: optimize for non 'constrained' size modes (ie return w/h directly, with mins accounted for)
			var hScaling:Boolean = (_sizeMode & SizeMode.HMASK) == (SizeMode.SCALE & SizeMode.HMASK);
			var vScaling:Boolean = (_sizeMode & SizeMode.VMASK) == (SizeMode.SCALE & SizeMode.VMASK);
	
			if (direction % 2) {
				var swap:Number = w;
				w = h;
				h = swap;
			}
	
			if (w == w) {
				w = (!hScaling ? w / scaleX : w) - _marginLeft - _marginRight;
				w = w <= _minWidth ? _minWidth : w;
			} else if (preferredWidth == preferredWidth) {
				w = preferredWidth;
				w = w <= _minWidth ? _minWidth : w;
			}
	
			if (h == h) {
				h = (!vScaling ? h / scaleY : h) - _marginTop - _marginBottom;
				h = h <= _minHeight ? _minHeight : h;
			} else if (preferredHeight == preferredHeight) {
				h = preferredHeight;
				h = h <= _minHeight ? _minHeight : h;
			}
	
			// a measurement is required whether setting or getting size
			var m:Measurement;
			measurement: {
				// lookup measurement in cache
				if (w == w) {				// !isNaN(w)
					if (h == h) {			// !isNaN(h)
						m = $wh_cachedRect ||= new Measurement();
						if (w == $wh_matchedWidth &&
							h == $wh_matchedHeight) break measurement;
						$wh_matchedWidth = w;
						$wh_matchedHeight = h;
					} else {
						m = $w_cachedRect ||= new Measurement();
						if (w == $w_matchedWidth) break measurement;
						$w_matchedWidth = w;
					}
				} else if (h == h) {		// !isNaN(h)
					m = $h_cachedRect ||= new Measurement();
					if (h == $h_matchedHeight) break measurement;
					$h_matchedHeight = h;
				} else {
					m = $_cachedRect ||= new Measurement();
					if ($_matched) break measurement;
					$_matched = true;
				}
	
				// if not found in cache, process measurement, storing new measurement in cache
				m.width = m.height = m.x = m.y = 0;
				measureContent(m, w, h);
	
				if (m.width < _minWidth) m.width = _minWidth;
				if (m.height < _minHeight) m.height = _minHeight;
				m.w = w == w ? w : m.width;
				m.h = h == h ? h : m.height;
	
				if (!hScaling) {
					if (m.width < m.w) {
						m.width = m.w;
					} else if ((_sizeMode & SizeMode.HMASK) == (SizeMode.CONSTRAIN & SizeMode.HMASK)) {
						m.w = m.width;
					}
				}
				if (!vScaling) {
					if (m.height < m.h) {
						m.height = m.h;
					} else if ((_sizeMode & SizeMode.VMASK) == (SizeMode.CONSTRAIN & SizeMode.VMASK)) {
						m.h = m.height;
					}
				}
			}
	
			w = m.w + _marginLeft + _marginRight;
			h = m.h + _marginTop + _marginBottom;
			if (!hScaling) w *= scaleX;
			if (!vScaling) h *= scaleY;
	
			if (direction % 2) {
				point.x = h;
				point.y = w;
			} else {
				point.x = w;
				point.y = h;
			}
			return point;
		}
		stealth var point:Point = new Point();
	
		protected function measureContent(measured:Rectangle, w:Number = NaN, h:Number = NaN):void
		{
			if (_display && sizeMode == SizeMode.SCALE) {
				measured.copyFrom(_display.getRect(_display));
			} else {
				
				var c:Node = _head;		// current node
				while (c) {
					if (c is UINode) {
						var s:Point = UINode(c).measure();
						s.x += c.x;
						s.y += c.y;
						if (measured.width < s.x) measured.width = s.x;
						if (measured.height < s.y) measured.height = s.y;
					}
					c = c._next;
				}
				
			}
		}
	}
}

import flash.geom.Rectangle;

internal class Measurement extends Rectangle
{
	public var w:Number;
	public var h:Number;
}
