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
		protected var totalWidth:Number;
		protected var totalHeight:Number;
		
		private var childRect:Rectangle = new Rectangle();
		
		public function BoxLayout(target:IContainer = null)
		{
			super(target);
			
			bindTarget("horizontalAlign");
			bindTarget("verticalAlign");
			bindTarget("padding");
			
			watchTarget("width");
			watchTarget("height");
			watchTarget("contentWidth");
			watchTarget("contentHeight");
			
			watchContent("x");
			watchContent("y");
			watchContent("scaleX");
			watchContent("scaleY");
			watchContent("rotation");
			watchContent("freeform");
			watchContent("width");
			watchContent("height");
			watchContent("minWidth", true);
			watchContent("minHeight", true);
			watchContent("maxWidth", true);
			watchContent("maxHeight", true);
			watchContent("percentWidth");
			watchContent("percentHeight");
		}
		
		[Bindable(event="horizontalAlignChange", style="noEvent")]
		public function get horizontalAlign():String { return _horizontalAlign; }
		public function set horizontalAlign(value:String):void
		{
			DataChange.change(this, "horizontalAlign", _horizontalAlign, _horizontalAlign = value);
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _horizontalAlign:String = Align.LEFT;
		
		[Bindable(event="verticalAlignChange", style="noEvent")]
		public function get verticalAlign():String { return _verticalAlign; }
		public function set verticalAlign(value:String):void
		{
			DataChange.change(this, "verticalAlign", _verticalAlign, _verticalAlign = value);
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _verticalAlign:String = Align.TOP;
		
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
		
		[Bindable(event="gapChange", style="noEvent")]
		public function get gap():Gap { return _gap || (gap = new Gap()); }
		public function set gap(value:*):void
		{
			if (value is String) {
				value = Gap.fromString(value);
			} else if (value is Number) {
				value = new Gap(value, value);
			}
			
			if (_gap) {
				_gap.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
			}
			DataChange.change(this, "gap", _gap, _gap = value);
			if (_gap) {
				_gap.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
			}
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _gap:Gap;
		
		private function onPaddingChange(event:PropertyChangeEvent):void
		{
			invalidate(LayoutEvent.LAYOUT);
		}
		
		
		override public function measure():void
		{
			var measured:IBounds = target.measured;
			Bounds.reset(measured);
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			totalPercentWidth = totalPercentHeight = 0;
			
			super.measure();
			
			var space:Number = padding.left + padding.right;
			measured.width += space;
			measured.minWidth += space;
			measured.maxWidth += space;
			space = padding.top + padding.bottom;
			measured.height += space;
			measured.minHeight += space;
			measured.maxHeight += space;
		}
		
		override public function update():void
		{
			var measured:IBounds = target.measured;
			contentMargin.left = contentMargin.top = contentMargin.right = contentMargin.bottom = 0;
			contentRect.x = padding.left;
			contentRect.y = padding.top;
			contentRect.width = target.contentWidth;
			contentRect.height = target.contentHeight
			var measuredWidth:Number = measured.minWidth + totalPercentWidth * contentRect.width;
			var measuredHeight:Number = measured.minHeight + totalPercentHeight * contentRect.height;
			totalWidth = measuredWidth < contentRect.width ? contentRect.width - measuredWidth : 0;
			totalHeight = measuredHeight < contentRect.height ? contentRect.height - measuredHeight : 0;
			contentRect.width -= padding.left + padding.right;
			contentRect.height -= padding.top + padding.bottom;
			
			super.update();
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{// TODO: asfda sdf sdfas dfasdf stop listening to updates...
			updateChildBounds(child,  last);
			if (!childBounds.equalsRect(childRect)) {
				childBounds.getRect(childRect);
				if (child is ILayoutElement) {
					ILayoutElement(child).setLayoutRect(childRect);
				} else {
					child.x = childRect.x;
					child.y = childRect.y;
					child.width = childRect.width;
					child.height = childRect.height;
				}
			}
		}
		
		protected function updateChildBounds(child:DisplayObject, last:Boolean = false):void
		{
		}
		
		override protected function childReady(child:DisplayObject):Boolean
		{
			if (!child.visible) {
				return false;
			}
			
			if (child is ILayoutElement) {
				var layoutChild:ILayoutElement = ILayoutElement(child);
				if (layoutChild.freeform) {
					return false;
				}
				
				// update contentMargin to be the greater of this child's margin and the previous child's margin
				contentMargin.copy(childMargin);
				childMargin.merge(layoutChild.margin);
				
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
				contentMargin.copy(childMargin);
				childBounds.maxWidth = childBounds.maxHeight = 0xFFFFFF;
				childBounds.minWidth = childBounds.minHeight = 0;
				childRect = child.getRect(child.parent);
				childPercentWidth = childPercentHeight = NaN;
			}
			childBounds.setRect(childRect);
			
			return true;
		}
		
		override protected function detach():void
		{
			super.detach();
			Bounds.reset(target.measured);
			for each (var child:DisplayObject in target.content) {
				if (child is ILayoutElement) {
					var layoutChild:ILayoutElement = ILayoutElement(child);
					layoutChild.setLayoutRect( layoutChild.getLayoutRect() );
				}
			}
		}
	}
}
