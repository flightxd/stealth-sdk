/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.display.DisplayObject;

	import flight.layouts.Bounds;
	import flight.layouts.IBounds;

	public class HorizontalLayout extends BoxLayout
	{
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			var measured:IBounds = target.measured;
			
			// vertical size
			var space:Number = childMargin.top + childMargin.bottom;
			if (verticalAlign == Align.JUSTIFY || !isNaN(childPercentHeight)) {
				measured.minHeight = Bounds.constrainHeight(measured, childBounds.minHeight + space);
				measured.maxHeight = Bounds.constrainHeight(measured, childBounds.maxHeight + space);
			} else {
				space += childBounds.height;
				if (measured.height < space) {
					measured.height = space;
					measured.minHeight = Bounds.constrainHeight(measured, measured.height);
				}
			}
			
			// horizontal size
			if (last) {
				space = childMargin.left + childMargin.right;
			} else {
				space = childMargin.left + padding.horizontal;
				contentMargin.left = childMargin.right;
			}
			
			if (!isNaN(childPercentWidth)) {
				totalPercentWidth += childPercentWidth;
				measured.width += space;
			} else {
				measured.width += childBounds.width + space;
			}
			measured.minWidth += childBounds.width + space;
		}
		
		override protected function updateChildBounds(child:DisplayObject, last:Boolean = false):void
		{
			var size:Number;
			if (!isNaN(childPercentWidth)) {
				size = target.contentWidth - target.measured.minWidth;
				childBounds.width = size * childPercentWidth * (totalPercentWidth < 1 ? 1 : 1/totalPercentWidth);
			}
			if (!isNaN(childPercentHeight)) {
				size = contentRect.height - childMargin.top - childMargin.bottom;
				childBounds.height = size * childPercentHeight * (totalPercentHeight < 1 ? 1 : 1/totalPercentHeight);
			}
			
			// vertical layout
			switch (verticalAlign) {
				case Align.TOP:
					childBounds.y = contentRect.y + childMargin.top;
					break;
				case Align.MIDDLE:
					childBounds.y = contentRect.y + (childMargin.top + contentRect.height - childBounds.height - childMargin.bottom) / 2;
					break;
				case Align.BOTTOM:
					childBounds.y = contentRect.y + (contentRect.height - childBounds.height - childMargin.bottom);
					break;
				case Align.JUSTIFY:
					childBounds.y = contentRect.y + childMargin.top;
					childBounds.height = contentRect.height - childMargin.top - childMargin.bottom;
					break;
			}
			
			// horizontal layout
			childBounds.x = contentRect.x + childMargin.left;
			if (last) {
			} else {
				contentRect.left = childBounds.x + childBounds.width + padding.horizontal;
				contentMargin.left = childMargin.right;
			}
			
			switch (horizontalAlign) {
				case Align.CENTER:
					childBounds.x += totalWidth / 2;
					break;
				case Align.RIGHT:
					childBounds.x += totalWidth;
					break;
			}
		}
		
	}
}
