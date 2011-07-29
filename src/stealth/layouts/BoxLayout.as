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
			
			bindTarget("padding");
			bindTarget("hAlign");
			bindTarget("vAlign");
			
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
		
		[Bindable(event="paddingChange", style="noEvent")]
		public function get padding():Box { return _padding || (padding = new Box()); }
		public function set padding(value:*):void
		{
			if (!(value is Box)) {
				value = Box.getInstance(value, _padding);
			}
			
			if (_padding != value) {
				if (_padding) {
					_padding.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
				}
				DataChange.change(this, "padding", _padding, _padding = value);
				invalidate(LayoutEvent.LAYOUT);
				if (_padding) {
					_padding.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaddingChange);
				}
			}
		}
		private var _padding:Box;
		
		public function get gap():Box { return _padding || (padding = new Box()); }
		public function set gap(value:*):void
		{
			if (!(value is Box)) {
				value = Box.getDirectional(value, _padding);
			}
			padding = value;
		}
		
		private function onPaddingChange(event:PropertyChangeEvent):void
		{
			invalidate(LayoutEvent.LAYOUT);
		}
		
		[Bindable(event="hAlignChange", style="noEvent")]
		[Inspectable(enumeration="left,center,right,fill", defaultValue="left", name="hAlign")]
		public function get hAlign():String { return _hAlign; }
		public function set hAlign(value:String):void
		{
			DataChange.change(this, "hAlign", _hAlign, _hAlign = value);
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _hAlign:String = Align.LEFT;
		
		[Bindable(event="vAlignChange", style="noEvent")]
		[Inspectable(enumeration="top,middle,bottom,fill", defaultValue="top", name="vAlign")]
		public function get vAlign():String { return _vAlign; }
		public function set vAlign(value:String):void
		{
			DataChange.change(this, "vAlign", _vAlign, _vAlign = value);
			invalidate(LayoutEvent.LAYOUT);
		}
		private var _vAlign:String = Align.TOP;
		
		
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
		{
			updateChildBounds(child, last);
			if (!childBounds.equalsRect(childRect)) {
				childBounds.getRect(childRect);
				var layoutChild:ILayoutElement = getLayoutElement(child);
				if (layoutChild) {
					layoutChild.setLayoutRect(childRect);
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
			
			var layoutChild:ILayoutElement = getLayoutElement(child);
			if (layoutChild) {
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
				childBounds.maxWidth = childBounds.maxHeight = int.MAX_VALUE;
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
		
		protected function getLayoutElement(element:DisplayObject):ILayoutElement
		{
			if (element is ILayoutElement) {
				return ILayoutElement(element);
			} else if ("layoutData" in element && element["layoutData"] is ILayoutElement) {
				return ILayoutElement(element["layoutData"]);
			} else {
				return null;
			}
		}
	}
}
