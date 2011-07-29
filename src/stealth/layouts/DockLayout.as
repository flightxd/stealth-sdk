/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.layouts
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	import flight.layouts.Bounds;
	import flight.layouts.IBounds;

	public class DockLayout extends BasicLayout
	{
		protected var dockMeasured:Bounds = new Bounds();
		protected var dockMargin:Box = new Box();
		protected var tileRect:Rectangle = new Rectangle();
		protected var lastDock:String = null;
		protected var tiling:Boolean;
		
		protected var tileWidth:Number;
		protected var tileHeight:Number;
		protected var measuredWidth:Number;
		protected var measuredHeight:Number;
		
		private var validDockValues:Array = [Align.LEFT, Align.TOP, Align.RIGHT, Align.BOTTOM, Align.FILL];
		
		public function DockLayout()
		{
			watchContent("dock");
			watchContent("tile");
		}
		
		override public function measure():void
		{
			dockMeasured.width = dockMeasured.minWidth = padding.left + padding.right;
			dockMeasured.height = dockMeasured.minHeight = padding.top + padding.bottom;
			dockMeasured.maxWidth = dockMeasured.maxHeight = int.MAX_VALUE;
			measuredWidth = measuredHeight = 0;
			
			super.measure();
			
			var measured:IBounds = target.measured;
			measured.minWidth = Bounds.constrainWidth(dockMeasured, measured.minWidth);
			measured.minHeight = Bounds.constrainHeight(dockMeasured, measured.minHeight);
			measured.maxWidth = Bounds.constrainWidth(dockMeasured, measured.maxWidth);
			measured.maxHeight = Bounds.constrainHeight(dockMeasured, measured.maxHeight);
			dockMeasured.width = measuredWidth;
			dockMeasured.height = measuredHeight;
			if (measured.width < dockMeasured.width) {
				measured.width = dockMeasured.width;
			}
			if (measured.height < dockMeasured.height) {
				measured.height = dockMeasured.height;
			}
		}
		
		override protected function measureChild(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is ILayoutElement)) {
				return super.measureChild(child, last);
			}
			var layoutChild:ILayoutElement = child as ILayoutElement;
			
			var dock:String = layoutChild.dock;
			var tile:String = layoutChild.tile;
			if (tile) {
				if (tile == Align.LEFT || tile == Align.RIGHT) {
					if (dock != Align.BOTTOM) {
						dock = Align.TOP;
					}
				} else if (tile == Align.TOP || tile == Align.BOTTOM) {
					if (dock != Align.RIGHT) {
						dock = Align.LEFT;
					}
				} else {
					tile = null;
				}
			}
			if (!dock || validDockValues.indexOf(dock) == -1) {
				super.measureChild(child, last);
				return;
			}
			
			var space:Number;
			var m:String;
			if (!tile) {
				if (tiling) {
					if (lastDock == Align.LEFT || lastDock == Align.RIGHT) {
						measuredWidth += tileWidth;
						dockMeasured.minHeight -= gap.vertical;
					} else {
						measuredHeight += tileHeight;
						dockMeasured.minWidth -= gap.horizontal;
					}
					childMargin.merge(dockMargin.copy(contentMargin));
					tiling = false;
				}
			} else if (!tiling || dock != lastDock) {
				contentMargin.copy(dockMargin);
				tileWidth = tileHeight = 0;
				tiling = true;
			}
			
			if (dock == Align.LEFT || dock == Align.RIGHT) {
				m = dock == Align.LEFT ? Align.RIGHT : Align.LEFT;
				if (tile) {
					if (tile == Align.TOP) {
						contentMargin.top = childMargin.bottom;
						space = childMargin.top;
					} else {
						contentMargin.bottom = childMargin.top;
						space = childMargin.bottom;
					}
					tileHeight += space + childBounds.height + gap.vertical;
					space = childBounds.width + childMargin[dock] + gap.horizontal;
					if (tileWidth + dockMargin[dock] < space + childMargin[m]) {
						tileWidth = space;
						dockMargin[dock] = childMargin[m];
					}
					dockMeasured.minWidth = Bounds.constrainWidth(dockMeasured, measuredWidth + tileWidth);
					dockMeasured.minHeight = Bounds.constrainHeight(dockMeasured, measuredHeight + tileHeight);
				} else {
					if (dock == Align.LEFT) {
						contentMargin.left = childMargin.right;
						space = childMargin.left;
					} else {
						contentMargin.right = childMargin.left;
						space = childMargin.right;
					}
					measuredWidth += childBounds.width + space + gap.horizontal;
					space = measuredHeight + childMargin.top + childMargin.bottom;
					dockMeasured.minWidth = Bounds.constrainWidth(dockMeasured, measuredWidth);
					dockMeasured.minHeight = Bounds.constrainHeight(dockMeasured, space + childBounds.minHeight);
					dockMeasured.maxHeight = Bounds.constrainHeight(dockMeasured, space + childBounds.maxHeight);
				}
			} else if (dock == Align.TOP || dock == Align.BOTTOM) {
				m = dock == Align.TOP ? Align.BOTTOM : Align.TOP;
				if (tile) {
					if (tile == Align.LEFT) {
						contentMargin.left = childMargin.right;
						space = childMargin.left;
					} else {
						contentMargin.right = childMargin.left;
						space = childMargin.right;
					}
					tileWidth += childBounds.width + space + gap.horizontal;
					space = childBounds.height + childMargin[dock] + gap.vertical;
					if (tileHeight + dockMargin[dock] < space + childMargin[m]) {
						tileHeight = space;
						dockMargin[dock] = childMargin[m];
					}
					dockMeasured.minWidth = Bounds.constrainWidth(dockMeasured, measuredWidth + tileWidth);
					dockMeasured.minHeight = Bounds.constrainHeight(dockMeasured, measuredHeight + tileHeight);
				} else {
					if (dock == Align.TOP) {
						contentMargin.top = childMargin.bottom;
						space = childMargin.top;
					} else {
						contentMargin.bottom = childMargin.top;
						space = childMargin.bottom;
					}
					measuredHeight += childBounds.height + space + gap.vertical;
					space = measuredWidth + childMargin.left + childMargin.right;
					dockMeasured.minHeight = Bounds.constrainHeight(dockMeasured, measuredHeight);
					dockMeasured.minWidth = Bounds.constrainWidth(dockMeasured, space + childBounds.minWidth);
					dockMeasured.maxWidth = Bounds.constrainWidth(dockMeasured, space + childBounds.maxWidth);
				}
			} else {	// if (dock == FILL) {
				space = measuredWidth + childMargin.left + childMargin.right + gap.horizontal;
				dockMeasured.minWidth = Bounds.constrainWidth(dockMeasured, space + childBounds.minWidth);
				dockMeasured.maxWidth = Bounds.constrainWidth(dockMeasured, space + childBounds.maxWidth);
				
				space = measuredHeight + childMargin.top + childMargin.bottom + gap.vertical;
				dockMeasured.minHeight = Bounds.constrainHeight(dockMeasured, space + childBounds.minHeight);
				dockMeasured.maxHeight = Bounds.constrainHeight(dockMeasured, space + childBounds.maxHeight);
			}
			
			if (last) {
				// remove the last pad and add the last margin
				switch (lastDock) {
					case Align.LEFT: dockMeasured.minWidth += childMargin.right - gap.horizontal; break;
					case Align.TOP: dockMeasured.minHeight += childMargin.bottom - gap.vertical; break;
					case Align.RIGHT: dockMeasured.minWidth += childMargin.left - gap.horizontal; break;
					case Align.BOTTOM: dockMeasured.minHeight += childMargin.top - gap.vertical; break;
				}
				lastDock = null;
				tiling = false;
			} else {
				lastDock = dock;
			}
		}
		
		override protected function updateChildBounds(child:DisplayObject, last:Boolean = false):void
		{
			if (!(child is ILayoutElement)) {
				return super.measureChild(child, last);
			}
			var layoutChild:ILayoutElement = child as ILayoutElement;
			
			var dock:String = layoutChild.dock;
			var tile:String = layoutChild.tile;
			if (tile) {
				if (tile == Align.LEFT || tile == Align.RIGHT) {
					if (dock != Align.BOTTOM) {
						dock = Align.TOP;
					}
				} else if (tile == Align.TOP || tile == Align.BOTTOM) {
					if (dock != Align.RIGHT) {
						dock = Align.LEFT;
					}
				} else {
					tile = null;
				}
			}
			if (!dock || validDockValues.indexOf(dock) == -1) {
				super.updateChildBounds(child, last);
				return;
			}
			
			if (!tile) {
				if (tiling) {
					childMargin.merge(dockMargin.copy(contentMargin));
					tiling = false;
				}
				dockChild(dock, contentRect, childMargin);
				updateArea(dock, contentRect, contentMargin);
			} else {
				if (!tiling || dock != lastDock) {
					tiling = true;
					contentMargin.copy(dockMargin);
					tileRect.x = contentRect.x;
					tileRect.y = contentRect.y;
					tileRect.width = contentRect.width;
					tileRect.height = contentRect.height;
				}
				
				tileChild(tile, dock, tileRect, childMargin);
				updateArea(tile, tileRect, contentMargin);
				updateArea(dock, contentRect, dockMargin);
			}
			
			if (last) {
				lastDock = null;
				tiling = false;
			} else {
				lastDock = dock;
			}
		}
		
		protected function dockChild(dock:String, area:Rectangle, margin:Box):void
		{
			switch (dock) {
				case Align.LEFT:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					childBounds.height = area.height - margin.top - margin.bottom;
					break;
				case Align.TOP:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					childBounds.width = area.width - margin.left - margin.right;
					break;
				case Align.RIGHT:
					childBounds.x = area.x + area.width - childBounds.width - margin.right;
					childBounds.y = area.y + margin.top;
					childBounds.height = area.height - margin.top - margin.bottom;
					break;
				case Align.BOTTOM:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + area.height - childBounds.height - margin.bottom;
					childBounds.width = area.width - margin.left - margin.right;
					break;
				case Align.FILL:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					childBounds.height = area.height - margin.top - margin.bottom;
					childBounds.width = area.width - margin.left - margin.right;
					break;
			}
		}
		
		protected function tileChild(tile:String, dock:String, area:Rectangle, margin:Box):void
		{
			switch (tile) {
				case Align.LEFT:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					if (dock == Align.BOTTOM) {
						childBounds.y = area.y + area.height - childBounds.height - margin.bottom;
					}
					break;
				case Align.TOP:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					if (dock == Align.RIGHT) {
						childBounds.x = area.x + area.width - childBounds.width - margin.right;
					}
					break;
				case Align.RIGHT:
					childBounds.x = area.x + area.width - childBounds.width - margin.right;
					childBounds.y = area.y + margin.top;
					if (dock == Align.BOTTOM) {
						childBounds.y = area.y + area.height - childBounds.height - margin.bottom;
					}
					break;
				case Align.BOTTOM:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + area.height - childBounds.height - margin.bottom;
					if (dock == Align.RIGHT) {
						childBounds.x = area.x + area.width - childBounds.width - margin.right;
					}
					break;
				case Align.FILL:
					childBounds.x = area.x + margin.left;
					childBounds.y = area.y + margin.top;
					break;
			}
		}
		
		protected function updateArea(align:String, area:Rectangle, margin:Box):void
		{
			var pos:Number;
			switch (align) {
				case Align.LEFT:
					pos = childBounds.x + childBounds.width + gap.horizontal;
					if (area.left + margin.left < pos + childMargin.right) {
						area.left = pos;
						margin.left = childMargin.right;
					}
					break;
				case Align.TOP:
					pos = childBounds.y + childBounds.height + gap.vertical;
					if (area.top + margin.top < pos + childMargin.bottom) {
						area.top = pos;
						margin.top = childMargin.bottom;
					}
					break;
				case Align.RIGHT:
					pos = childBounds.x - gap.horizontal;
					if (area.right - margin.right > pos - childMargin.left) {
						area.right = pos;
						margin.right = childMargin.left;
					}
					break;
				case Align.BOTTOM:
					pos = childBounds.y - gap.vertical;
					if (area.bottom - margin.bottom > pos - childMargin.top) {
						area.bottom = pos;
						margin.bottom = childMargin.top;
					}
					break;
			}
		}
		
		override protected function layoutChildReady(layoutChild:ILayoutElement):Boolean
		{
			if (layoutChild.dock ||
				layoutChild.tile) {
				return true;
			}
			return super.layoutChildReady(layoutChild);
		}
	}
}
