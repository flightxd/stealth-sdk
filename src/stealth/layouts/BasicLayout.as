/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.display.DisplayObject;

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
//			if (!(child is IStyleable)) {
//				return;
//			}
			
			var style:Object = {};//IStyleable(child).style;
			var offsetX:Number = !isNaN(style.offsetX) ? style.offsetX : 0;
			var offsetY:Number = !isNaN(style.offsetY) ? style.offsetY : 0;
			var measured:IBounds = target.measured;
			var space:Number;
			
			if ( !isNaN(style.left) ) {
				if ( !isNaN(style.right) ) {
					space = style.left + style.right;
					measured.minWidth = space + childBounds.minWidth;
					measured.maxWidth = space + childBounds.maxWidth;
					space = space + childBounds.minWidth;
				} else if ( !isNaN(style.horizontal) ) {
					space = style.left - offsetX;
					measured.minWidth = (space + childBounds.minWidth)/style.horizontal;
					measured.maxWidth = (space + childBounds.maxWidth)/style.horizontal;
					space = (space + childBounds.minWidth)/style.horizontal;
				} else {
					space = style.left;
					measured.minWidth = space + childBounds.width;
					space = space + childBounds.width;
				}
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					space = style.right + offsetX;
					measured.minWidth = (space + childBounds.minWidth)/style.horizontal;
					measured.maxWidth = (space + childBounds.maxWidth)/style.horizontal;
					space = (space + childBounds.minWidth)/style.horizontal;
				} else {
					space = style.right;
					measured.minWidth = offsetX + childBounds.width;
					space = offsetX + childBounds.width;
				}
			} else if ( !isNaN(style.horizontal) ) {
				measured.minWidth = Math.abs(offsetX) + childBounds.width;
				space = Math.abs(offsetX) + childBounds.width;
			} else {
				measured.minWidth = childBounds.x + childBounds.width;
				space = childBounds.x + childBounds.width;
			}
			if (measured.width < space) {
				measured.width = space;
			}
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					space = style.top + style.bottom;
					measured.minHeight = space + childBounds.minHeight;
					measured.maxHeight = space + childBounds.maxHeight;
					space = space + childBounds.minHeight;
				} else if ( !isNaN(style.vertical) ) {
					space = style.top - offsetY;
					measured.minHeight = (space + childBounds.minHeight)/style.vertical;
					measured.maxHeight = (space + childBounds.maxHeight)/style.vertical;
					space = (space + childBounds.minHeight)/style.vertical;
				} else {
					space = style.top;
					measured.minHeight = space + childBounds.height;
					space = space + childBounds.height;
				}
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					space = style.bottom + offsetY;
					measured.minHeight = (space + childBounds.minHeight)/style.vertical;
					measured.maxHeight = (space + childBounds.maxHeight)/style.vertical;
					space = (space + childBounds.minHeight)/style.vertical;
				} else {
					space = style.bottom;
					measured.minHeight = space + childBounds.height;
					space = space + childBounds.height;
				}
			} else if ( !isNaN(style.vertical) ) {
				measured.minHeight = Math.abs(offsetY) + childBounds.height;
				space = Math.abs(offsetY) + childBounds.height;
			} else {
				measured.minHeight = childBounds.y + childBounds.height;
				space = childBounds.y + childBounds.height;
			}
			if (measured.height < space) {
				measured.height = space;
			}
		}
		
		override protected function updateChild(child:DisplayObject, last:Boolean = false):void
		{
//			if (!(child is IStyleable)) {
//				return;
//			}
			
			var style:Object = {};//IStyleable(child).style;
			var offsetX:Number = !isNaN(style.offsetX) ? style.offsetX : 0;
			var offsetY:Number = !isNaN(style.offsetY) ? style.offsetY : 0;
			if ( !isNaN(style.left) ) {
				if ( !isNaN(style.right) ) {
					childBounds.width = target.contentWidth - style.left - style.right;
				} else if ( !isNaN(style.horizontal) ) {
					childBounds.width = (style.horizontal * target.contentWidth) - style.left + offsetX;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - style.left);
				}
				
				childBounds.x = style.left;
			} else if ( !isNaN(style.right) ) {
				if ( !isNaN(style.horizontal) ) {
					childBounds.width = (style.horizontal * target.contentWidth) - style.right - offsetX;
				} else if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * (target.contentWidth - style.right);
				}
				
				childBounds.x = target.contentWidth - childBounds.width - style.right;
			} else if ( !isNaN(style.horizontal) ) {
				if (!isNaN(childPercentWidth)) {
					childBounds.width = childPercentWidth * target.contentWidth;
				}
				
				childBounds.x = style.horizontal * (target.contentWidth - childBounds.width) + offsetX;
			}
			
			
			if ( !isNaN(style.top) ) {
				if ( !isNaN(style.bottom) ) {
					childBounds.height = target.contentHeight - style.top - style.bottom;
				} else if ( !isNaN(style.vertical) ) {
					childBounds.height = (style.vertical * target.contentHeight) - style.top + offsetY;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - style.top);
				}
				
				childBounds.y = style.top;
			} else if ( !isNaN(style.bottom) ) {
				if ( !isNaN(style.vertical) ) {
					childBounds.height = (style.vertical * target.contentHeight) - style.bottom - offsetY;
				} else if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * (target.contentHeight - style.bottom);
				}
				
				childBounds.y = target.contentHeight - childBounds.height - style.bottom;
			} else if ( !isNaN(style.vertical) ) {
				if (!isNaN(childPercentHeight)) {
					childBounds.height = childPercentHeight * target.contentHeight;
				}
				
				childBounds.y = style.vertical * (target.contentHeight - childBounds.height) + offsetY;
			}
		}
		
	}
}
