/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.GraphicsPathCommand;
	import flash.events.Event;

	import flight.data.DataChange;
	import flight.events.LayoutEvent;

	public class Rect extends GraphicShape
	{
		public function Rect()
		{
		}
		
		[Bindable(event="radiusXChange", style="noEvent")]
		public function get radiusX():Number { return _radiusX }
		public function set radiusX(value:Number):void
		{
			DataChange.change(this, "radiusX", _radiusX, _radiusX = value);
		}
		private var _radiusX:Number = 0;
		
		[Bindable(event="radiusYChange", style="noEvent")]
		public function get radiusY():Number { return _radiusY }
		public function set radiusY(value:Number):void
		{
			DataChange.change(this, "radiusY", _radiusY, _radiusY = value);
		}
		private var _radiusY:Number = 0;
		
		[Bindable(event="topLeftRadiusXChange", style="noEvent")]
		public function get topLeftRadiusX():Number { return _topLeftRadiusX }
		public function set topLeftRadiusX(value:Number):void
		{
			DataChange.change(this, "topLeftRadiusX", _topLeftRadiusX, _topLeftRadiusX = value);
		}
		private var _topLeftRadiusX:Number = NaN;
		
		[Bindable(event="topLeftRadiusYChange", style="noEvent")]
		public function get topLeftRadiusY():Number { return _topLeftRadiusY }
		public function set topLeftRadiusY(value:Number):void
		{
			DataChange.change(this, "topLeftRadiusY", _topLeftRadiusY, _topLeftRadiusY = value);
		}
		private var _topLeftRadiusY:Number = NaN;
		
		[Bindable(event="topRightRadiusXChange", style="noEvent")]
		public function get topRightRadiusX():Number { return _topRightRadiusX }
		public function set topRightRadiusX(value:Number):void
		{
			DataChange.change(this, "topRightRadiusX", _topRightRadiusX, _topRightRadiusX = value);
		}
		private var _topRightRadiusX:Number = NaN;
		
		[Bindable(event="topRightRadiusYChange", style="noEvent")]
		public function get topRightRadiusY():Number { return _topRightRadiusY }
		public function set topRightRadiusY(value:Number):void
		{
			DataChange.change(this, "topRightRadiusY", _topRightRadiusY, _topRightRadiusY = value);
		}
		private var _topRightRadiusY:Number = NaN;
		
		[Bindable(event="bottomLeftRadiusXChange", style="noEvent")]
		public function get bottomLeftRadiusX():Number { return _bottomLeftRadiusX }
		public function set bottomLeftRadiusX(value:Number):void
		{
			DataChange.change(this, "bottomLeftRadiusX", _bottomLeftRadiusX, _bottomLeftRadiusX = value);
		}
		private var _bottomLeftRadiusX:Number = NaN;
		
		[Bindable(event="bottomLeftRadiusYChange", style="noEvent")]
		public function get bottomLeftRadiusY():Number { return _bottomLeftRadiusY }
		public function set bottomLeftRadiusY(value:Number):void
		{
			DataChange.change(this, "bottomLeftRadiusY", _bottomLeftRadiusY, _bottomLeftRadiusY = value);
		}
		private var _bottomLeftRadiusY:Number = NaN;
		
		[Bindable(event="bottomRightRadiusXChange", style="noEvent")]
		public function get bottomRightRadiusX():Number { return _bottomRightRadiusX }
		public function set bottomRightRadiusX(value:Number):void
		{
			DataChange.change(this, "bottomRightRadiusX", _bottomRightRadiusX, _bottomRightRadiusX = value);
		}
		private var _bottomRightRadiusX:Number = NaN;
		
		[Bindable(event="bottomRightRadiusYChange", style="noEvent")]
		public function get bottomRightRadiusY():Number { return _bottomRightRadiusY }
		public function set bottomRightRadiusY(value:Number):void
		{
			DataChange.change(this, "bottomRightRadiusY", _bottomRightRadiusY, _bottomRightRadiusY = value);
		}
		private var _bottomRightRadiusY:Number = NaN;
		
		override protected function update():void
		{
			super.update();
			var cmds:Vector.<int> = graphicsPath.commands;
			var data:Vector.<Number> = graphicsPath.data;
			cmds.splice(0, cmds.length);
			data.splice(0, data.length);
			
			cmds.push(GraphicsPathCommand.MOVE_TO);
			data.push(0, 0);
			cmds.push(GraphicsPathCommand.LINE_TO);
			data.push(width, 0);
			cmds.push(GraphicsPathCommand.LINE_TO);
			data.push(width, height);
			cmds.push(GraphicsPathCommand.LINE_TO);
			data.push(0, height);
			cmds.push(GraphicsPathCommand.LINE_TO);
			data.push(0, 0);
		}
	}
}
