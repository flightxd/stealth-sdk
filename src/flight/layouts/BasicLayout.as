/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.layouts
{
	import flash.display.DisplayObject;

	public class BasicLayout extends BoxLayout
	{
		public function BasicLayout()
		{
			watchContent("left");
			watchContent("top");
			watchContent("right");
			watchContent("bottom");
			watchContent("hPercent");
			watchContent("vPercent");
			watchContent("hOffset");
			watchContent("vOffset");
		}
		
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is ILayoutElement)) {
				return;
			}
			var layoutChild:ILayoutElement = ILayoutElement(child);
			
			var hOffset:Number = !isNaN(layoutChild.hOffset) ? layoutChild.hOffset : 0;
			var vOffset:Number = !isNaN(layoutChild.vOffset) ? layoutChild.vOffset : 0;
			var measured:IBounds = target.measured;
			var space:Number;
			
			if ( !isNaN(layoutChild.left) ) {
				if ( !isNaN(layoutChild.right) ) {
					space = layoutChild.left + layoutChild.right;
					measured.minWidth = Bounds.constrainWidth(measured, space + childBounds.minWidth);
					measured.maxWidth = Bounds.constrainWidth(measured, space + childBounds.maxWidth);
					space = space + childBounds.minWidth;
				} else if ( !isNaN(layoutChild.hPercent) ) {
					space = layoutChild.left - hOffset;
					measured.minWidth = Bounds.constrainWidth(measured, (space + childBounds.minWidth)/layoutChild.hPercent);
					measured.maxWidth = Bounds.constrainWidth(measured, (space + childBounds.maxWidth)/layoutChild.hPercent);
					space = (space + childBounds.minWidth)/layoutChild.hPercent;
				} else {
					space = layoutChild.left;
					measured.minWidth = Bounds.constrainWidth(measured, space + childBounds.width);
					space = space + childBounds.width;
				}
			} else if ( !isNaN(layoutChild.right) ) {
				if ( !isNaN(layoutChild.hPercent) ) {
					space = layoutChild.right + hOffset;
					measured.minWidth = Bounds.constrainWidth(measured, (space + childBounds.minWidth)/layoutChild.hPercent);
					measured.maxWidth = Bounds.constrainWidth(measured, (space + childBounds.maxWidth)/layoutChild.hPercent);
					space = (space + childBounds.minWidth)/layoutChild.hPercent;
				} else {
					space = layoutChild.right;
					measured.minWidth = Bounds.constrainWidth(measured, hOffset + childBounds.width);
					space = hOffset + childBounds.width;
				}
			} else if ( !isNaN(layoutChild.hPercent) ) {
				measured.minWidth = Bounds.constrainWidth(measured, Math.abs(hOffset) + childBounds.width);
				space = Math.abs(hOffset) + childBounds.width;
			} else {
				measured.minWidth = Bounds.constrainWidth(measured, childBounds.x + childBounds.width);
				space = childBounds.x + childBounds.width;
			}
			if (measured.width < space) {
				measured.width = space;
			}
			
			if ( !isNaN(layoutChild.top) ) {
				if ( !isNaN(layoutChild.bottom) ) {
					space = layoutChild.top + layoutChild.bottom;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.minHeight);
					measured.maxHeight = Bounds.constrainHeight(measured, space + childBounds.maxHeight);
					space = space + childBounds.minHeight;
				} else if ( !isNaN(layoutChild.vPercent) ) {
					space = layoutChild.top - vOffset;
					measured.minHeight = Bounds.constrainHeight(measured, (space + childBounds.minHeight)/layoutChild.vPercent);
					measured.maxHeight = Bounds.constrainHeight(measured, (space + childBounds.maxHeight)/layoutChild.vPercent);
					space = (space + childBounds.minHeight)/layoutChild.vPercent;
				} else {
					space = layoutChild.top;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.height);
					space = space + childBounds.height;
				}
			} else if ( !isNaN(layoutChild.bottom) ) {
				if ( !isNaN(layoutChild.vPercent) ) {
					space = layoutChild.bottom + vOffset;
					measured.minHeight = Bounds.constrainHeight(measured, (space + childBounds.minHeight)/layoutChild.vPercent);
					measured.maxHeight = Bounds.constrainHeight(measured, (space + childBounds.maxHeight)/layoutChild.vPercent);
					space = (space + childBounds.minHeight)/layoutChild.vPercent;
				} else {
					space = layoutChild.bottom;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.height);
					space = space + childBounds.height;
				}
			} else if ( !isNaN(layoutChild.vPercent) ) {
				measured.minHeight = Bounds.constrainHeight(measured, Math.abs(vOffset) + childBounds.height);
				space = Math.abs(vOffset) + childBounds.height;
			} else {
				measured.minHeight = Bounds.constrainHeight(measured, childBounds.y + childBounds.height);
				space = childBounds.y + childBounds.height;
			}
			if (measured.height < space) {
				measured.height = space;
			}
		}
		
		override protected function updateChildBounds(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is ILayoutElement)) {
				return;
			}
			var layoutChild:ILayoutElement = ILayoutElement(child);
			
			var hOffset:Number = !isNaN(layoutChild.hOffset) ? layoutChild.hOffset : 0;
			var vOffset:Number = !isNaN(layoutChild.vOffset) ? layoutChild.vOffset : 0;
			if ( !isNaN(layoutChild.left) ) {
				if ( !isNaN(layoutChild.right) ) {
					childBounds.width = target.contentWidth - layoutChild.left - layoutChild.right;
				} else if ( !isNaN(layoutChild.hPercent) ) {
					childBounds.width = (layoutChild.hPercent * target.contentWidth) - layoutChild.left + hOffset;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - layoutChild.left);
				}
				
				childBounds.x = layoutChild.left;
			} else if ( !isNaN(layoutChild.right) ) {
				if ( !isNaN(layoutChild.hPercent) ) {
					childBounds.width = (layoutChild.hPercent * target.contentWidth) - layoutChild.right - hOffset;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - layoutChild.right);
				}
				
				childBounds.x = target.contentWidth - childBounds.width - layoutChild.right;
			} else if ( !isNaN(layoutChild.hPercent) ) {
				if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * target.contentWidth;
				}
				
				childBounds.x = layoutChild.hPercent * (target.contentWidth - childBounds.width) + hOffset;
			} else if (!isNaN(childPercentWidth)) {
				childBounds.width = childPercentWidth * target.contentWidth;
			}
			
			
			if ( !isNaN(layoutChild.top) ) {
				if ( !isNaN(layoutChild.bottom) ) {
					childBounds.height = target.contentHeight - layoutChild.top - layoutChild.bottom;
				} else if ( !isNaN(layoutChild.vPercent) ) {
					childBounds.height = (layoutChild.vPercent * target.contentHeight) - layoutChild.top + vOffset;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - layoutChild.top);
				}
				
				childBounds.y = layoutChild.top;
			} else if ( !isNaN(layoutChild.bottom) ) {
				if ( !isNaN(layoutChild.vPercent) ) {
					childBounds.height = (layoutChild.vPercent * target.contentHeight) - layoutChild.bottom - vOffset;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - layoutChild.bottom);
				}
				
				childBounds.y = target.contentHeight - childBounds.height - layoutChild.bottom;
			} else if ( !isNaN(layoutChild.vPercent) ) {
				if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * target.contentHeight;
				}
				
				childBounds.y = layoutChild.vPercent * (target.contentHeight - childBounds.height) + vOffset;
			} else if (!isNaN(childPercentHeight)) {
				childBounds.height = childPercentHeight * target.contentHeight;
			}
		}
	}
}
