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

	public class VerticalLayout extends BoxLayout
	{
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			var measured:IBounds = target.measured;
			
			// horizontal size
			var space:Number = childMargin.left + childMargin.right;
			if (horizontalAlign == Align.JUSTIFY || !isNaN(childPercentWidth)) {
				measured.minWidth = Bounds.constrainWidth(measured, childBounds.minWidth + space);
				measured.maxWidth = Bounds.constrainWidth(measured, childBounds.maxWidth + space);
			} else {
				space += childBounds.width;
				if (measured.width < space) {
					measured.width = space;
					measured.minWidth = Bounds.constrainWidth(measured, measured.width);
				}
			}
			
			// vertical size
			if (last) {
				space = childMargin.top + childMargin.bottom;
			} else {
				space = childMargin.top + gap.vertical;
				contentMargin.top = childMargin.bottom;
			}
			if (!isNaN(childPercentHeight)) {
				totalPercentHeight += childPercentHeight;
				measured.height += space;
			} else {
				measured.height += childBounds.height + space;
			}
			measured.minHeight += childBounds.height + space;
		}
		
		override protected function updateChildBounds(child:DisplayObject, last:Boolean = false):void
		{
			var size:Number;
			if (!isNaN(childPercentWidth)) {
				size = contentRect.width - childMargin.left - childMargin.right;
				childBounds.width = size * childPercentWidth * (totalPercentWidth < 1 ? 1 : 1/totalPercentWidth);
			}
			if (!isNaN(childPercentHeight)) {
				size = target.contentHeight - target.measured.minHeight;
				childBounds.height = size * childPercentHeight * (totalPercentHeight < 1 ? 1 : 1/totalPercentHeight);
			}
			
			// horizontal layout
			switch (horizontalAlign) {
				case Align.LEFT:
					childBounds.x = contentRect.x + childMargin.left;
					break;
				case Align.CENTER:
					childBounds.x = contentRect.x + (childMargin.left + contentRect.width - childBounds.width - childMargin.right) / 2;
					break;
				case Align.RIGHT:
					childBounds.x = contentRect.x + (contentRect.width - childBounds.width - childMargin.right);
					break;
				case Align.JUSTIFY:
					childBounds.x = contentRect.x + childMargin.left;
					childBounds.width = contentRect.width - childMargin.left - childMargin.right;
					break;
			}
			
			// vertical layout
			childBounds.y = contentRect.y + childMargin.top;
			if (last) {
			} else {
				contentRect.top = childBounds.y + childBounds.height + gap.vertical;
				contentMargin.top = childMargin.bottom;
			}
			
			switch (verticalAlign) {
				case Align.MIDDLE:
					childBounds.y += totalHeight / 2;
					break;
				case Align.RIGHT:
					childBounds.y += totalHeight;
					break;
			}
		}
		
	}
}
