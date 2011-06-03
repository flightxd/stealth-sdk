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
				return super.measureChild(child, last);
			}
			var element:ILayoutElement = child as ILayoutElement;
			
			var hOffset:Number = !isNaN(element.hOffset) ? element.hOffset : 0;
			var vOffset:Number = !isNaN(element.vOffset) ? element.vOffset : 0;
			var measured:IBounds = target.measured;
			var space:Number;
			
			if ( !isNaN(element.left) ) {
				if ( !isNaN(element.right) ) {
					space = element.left + element.right;
					measured.minWidth = Bounds.constrainWidth(measured, space + childBounds.minWidth);
					measured.maxWidth = Bounds.constrainWidth(measured, space + childBounds.maxWidth);
					space = space + childBounds.minWidth;
				} else if ( !isNaN(element.hPercent) ) {
					space = element.left - hOffset;
					measured.minWidth = Bounds.constrainWidth(measured, (space + childBounds.minWidth)/element.hPercent);
					measured.maxWidth = Bounds.constrainWidth(measured, (space + childBounds.maxWidth)/element.hPercent);
					space = (space + childBounds.minWidth)/element.hPercent;
				} else {
					space = element.left;
					measured.minWidth = Bounds.constrainWidth(measured, space + childBounds.width);
					space = space + childBounds.width;
				}
			} else if ( !isNaN(element.right) ) {
				if ( !isNaN(element.hPercent) ) {
					space = element.right + hOffset;
					measured.minWidth = Bounds.constrainWidth(measured, (space + childBounds.minWidth)/element.hPercent);
					measured.maxWidth = Bounds.constrainWidth(measured, (space + childBounds.maxWidth)/element.hPercent);
					space = (space + childBounds.minWidth)/element.hPercent;
				} else {
					space = element.right;
					measured.minWidth = Bounds.constrainWidth(measured, hOffset + childBounds.width);
					space = hOffset + childBounds.width;
				}
			} else if ( !isNaN(element.hPercent) ) {
				measured.minWidth = Bounds.constrainWidth(measured, Math.abs(hOffset) + childBounds.width);
				space = Math.abs(hOffset) + childBounds.width;
			} else {
				measured.minWidth = Bounds.constrainWidth(measured, childBounds.x + childBounds.width);
				space = childBounds.x + childBounds.width;
			}
			if (measured.width < space) {
				measured.width = space;
			}
			
			if ( !isNaN(element.top) ) {
				if ( !isNaN(element.bottom) ) {
					space = element.top + element.bottom;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.minHeight);
					measured.maxHeight = Bounds.constrainHeight(measured, space + childBounds.maxHeight);
					space = space + childBounds.minHeight;
				} else if ( !isNaN(element.vPercent) ) {
					space = element.top - vOffset;
					measured.minHeight = Bounds.constrainHeight(measured, (space + childBounds.minHeight)/element.vPercent);
					measured.maxHeight = Bounds.constrainHeight(measured, (space + childBounds.maxHeight)/element.vPercent);
					space = (space + childBounds.minHeight)/element.vPercent;
				} else {
					space = element.top;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.height);
					space = space + childBounds.height;
				}
			} else if ( !isNaN(element.bottom) ) {
				if ( !isNaN(element.vPercent) ) {
					space = element.bottom + vOffset;
					measured.minHeight = Bounds.constrainHeight(measured, (space + childBounds.minHeight)/element.vPercent);
					measured.maxHeight = Bounds.constrainHeight(measured, (space + childBounds.maxHeight)/element.vPercent);
					space = (space + childBounds.minHeight)/element.vPercent;
				} else {
					space = element.bottom;
					measured.minHeight = Bounds.constrainHeight(measured, space + childBounds.height);
					space = space + childBounds.height;
				}
			} else if ( !isNaN(element.vPercent) ) {
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
		
		override protected function layoutChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is ILayoutElement)) {
				return super.measureChild(child, last);
			}
			var element:ILayoutElement = child as ILayoutElement;
			
			var hOffset:Number = !isNaN(element.hOffset) ? element.hOffset : 0;
			var vOffset:Number = !isNaN(element.vOffset) ? element.vOffset : 0;
			if ( !isNaN(element.left) ) {
				if ( !isNaN(element.right) ) {
					childBounds.width = target.contentWidth - element.left - element.right;
				} else if ( !isNaN(element.hPercent) ) {
					childBounds.width = (element.hPercent * target.contentWidth) - element.left + hOffset;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - element.left);
				}
				
				childBounds.x = element.left;
			} else if ( !isNaN(element.right) ) {
				if ( !isNaN(element.hPercent) ) {
					childBounds.width = (element.hPercent * target.contentWidth) - element.right - hOffset;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - element.right);
				}
				
				childBounds.x = target.contentWidth - childBounds.width - element.right;
			} else if ( !isNaN(element.hPercent) ) {
				if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * target.contentWidth;
				}
				
				childBounds.x = element.hPercent * (target.contentWidth - childBounds.width) + hOffset;
			}
			
			
			if ( !isNaN(element.top) ) {
				if ( !isNaN(element.bottom) ) {
					childBounds.height = target.contentHeight - element.top - element.bottom;
				} else if ( !isNaN(element.vPercent) ) {
					childBounds.height = (element.vPercent * target.contentHeight) - element.top + vOffset;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - element.top);
				}
				
				childBounds.y = element.top;
			} else if ( !isNaN(element.bottom) ) {
				if ( !isNaN(element.vPercent) ) {
					childBounds.height = (element.vPercent * target.contentHeight) - element.bottom - vOffset;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - element.bottom);
				}
				
				childBounds.y = target.contentHeight - childBounds.height - element.bottom;
			} else if ( !isNaN(element.vPercent) ) {
				if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * target.contentHeight;
				}
				
				childBounds.y = element.vPercent * (target.contentHeight - childBounds.height) + vOffset;
			}
		}
		
	}
}
