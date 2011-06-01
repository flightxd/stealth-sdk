/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.Layout;

	import mx.events.PropertyChangeEvent;

	public class BoxLayout extends Layout
	{
		protected var contentRect:Rectangle = new Rectangle();
		protected var contentMargin:Box = new Box();
		
		protected var childBounds:Bounds = new Bounds();
		protected var childMargin:Box = new Box();
		protected var childPercentWidth:Number;
		protected var childPercentHeight:Number;
		
		protected var totalPercentWidth:Number;
		protected var totalPercentHeight:Number;
		protected var horizontalSpace:Number;
		protected var verticalSpace:Number;
		
		private var childRect:Rectangle = new Rectangle();
		
		public function BoxLayout(target:IContainer = null)
		{
			super(target);
		}
		
		[Bindable(event="paddingChange", style="noEvent")]
		public function get padding():Box { return _padding || (padding = new Box()); }
		public function set padding(value:*):void
		{
			if (value is String) {
				value = Box.fromString(value);
			} else if (value is Number) {
				value = new Box(value, value, value, value);
			}
			
			if (_padding) {
				_padding.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
			}
			DataChange.change(this, "padding", _padding, _padding = value);
			if (_padding) {
				_padding.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
			}
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _padding:Box;
		
		private function onPaddingChange(event:PropertyChangeEvent):void
		{
			invalidate(LayoutEvent.LAYOUT);
		}
		
		[Bindable(event="horizontalAlignChange", style="noEvent")]
		public function get horizontalAlign():String { return _horizontalAlign; }
		public function set horizontalAlign(value:String):void
		{
			invalidate(LayoutEvent.LAYOUT);
			DataChange.change(this, "horizontalAlign", _horizontalAlign, _horizontalAlign = value);
		}
		private var _horizontalAlign:String = Align.LEFT;
		
		[Bindable(event="verticalAlignChange", style="noEvent")]
		public function get verticalAlign():String { return _verticalAlign; }
		public function set verticalAlign(value:String):void
		{
			invalidate(LayoutEvent.LAYOUT);
			DataChange.change(this, "verticalAlign", _verticalAlign, _verticalAlign = value);
		}
		private var _verticalAlign:String = Align.TOP;
		
		
		override public function measure():void
		{
			if (!target) return;
			
			var measured:IBounds = target.measured;
			measured.minWidth = measured.minHeight = 0;
			measured.maxWidth = measured.maxHeight = 0xFFFFFF;
			measured.width = measured.height = 0;
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			totalPercentWidth = totalPercentHeight = 0;
			
			var len:int = target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(target.content.get(i, 0));
				if (setChildBounds(child)) {
					measureChild(child, i == len - 1);
				}
			}
			
			var space:Number = _padding.left + _padding.right;
			measured.width += space;
			measured.minWidth += space;
			measured.maxWidth += space;
			space = _padding.top + _padding.bottom;
			measured.height += space;
			measured.minHeight += space;
			measured.maxHeight += space;
		}
		
		override public function update():void
		{
			if (!target) return;
			
			var measured:IBounds = target.measured;
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			contentRect.x = _padding.left;
			contentRect.y = _padding.top;
			contentRect.width = target.contentWidth;
			contentRect.height = target.contentHeight
			var measuredWidth:Number = measured.width + totalPercentWidth * contentRect.width;
			var measuredHeight:Number = measured.height + totalPercentHeight * contentRect.height;
			horizontalSpace = measuredWidth < contentRect.width ? contentRect.width - measuredWidth : 0;
			verticalSpace = measuredHeight < contentRect.height ? contentRect.height - measuredHeight : 0;
			contentRect.width -= _padding.left + _padding.right;
			contentRect.height -= _padding.top + _padding.bottom;
			
			var len:int = target.content.length;
			for (var i:int = 0; i < len; i++) {
				var child:DisplayObject = DisplayObject(target.content.get(i, 0));
				if (setChildBounds(child)) {
					var originalRect:Rectangle = childRect.clone();
					updateChild(child, i == len - 1);
					if (originalRect.equals(childRect)) {
						continue;
					}
					
					if (child is ILayoutElement) {
//						ILayoutElement(child).setLayoutSize(childRect.width, childRect.height);
//						ILayoutElement(child).setLayoutPosition(childRect.x, childRect.y);
					} else {
						child.x = childRect.x;
						child.y = childRect.y;
						child.width = childRect.width;
						child.height = childRect.height;
					}
				}
			}
		}
		
		private function setChildBounds(child:DisplayObject):Boolean
		{
			if (!child.visible) {
				return false;
			}
			
			childMargin = contentMargin.clone(childMargin);
			childBounds.maxWidth = childBounds.maxHeight = 0xFFFFFF;
			childBounds.width = childBounds.height =childBounds.minWidth = childBounds.minHeight = 0;
			
			if (child is ILayoutElement) {
				var layoutChild:ILayoutElement = ILayoutElement(child);
				if (layoutChild.freeform) {
					return false;
				}
				
				// update contentMargin to be the greater of this child's margin and the previous child's margin
				childMargin = childMargin.merge(layoutChild.margin);
				
				childRect = layoutChild.getLayoutRect(layoutChild.minWidth, layoutChild.minHeight);
				childBounds.minWidth = childRect.width;
				childBounds.minHeight = childRect.height;
				childRect = layoutChild.getLayoutRect(layoutChild.maxWidth, layoutChild.maxHeight);
				childBounds.maxWidth = childRect.width;
				childBounds.maxHeight = childRect.height;
				childRect = layoutChild.getLayoutRect();
				
				if (!isNaN(childPercentWidth = layoutChild.percentWidth)) {
					childRect.width = childBounds.minWidth;
				}
				if (!isNaN(childPercentHeight = layoutChild.percentHeight)) {
					childRect.height = childBounds.minHeight;
				}
			} else {
				childRect = child.getRect(child.parent);
				childPercentWidth = childPercentHeight = NaN;
			}
			childBounds.x = childRect.x;
			childBounds.y = childRect.y;
			childBounds.width = childRect.width;
			childBounds.height = childRect.height;
			
			return true;
		}
	}
}
