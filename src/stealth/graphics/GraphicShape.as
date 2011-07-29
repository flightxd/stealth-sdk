/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.graphics
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.GraphicsEndFill;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataChange;
	import flight.display.Invalidation;
	import flight.display.Shape;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.events.LifecycleEvent;
	import flight.events.ListEvent;
	import flight.layouts.IBounds;
	import flight.states.IStateful;
	import flight.states.State;

	import mx.events.PropertyChangeEvent;

	import stealth.graphics.paint.IFill;
	import stealth.graphics.paint.IStroke;
	import stealth.graphics.paint.Paint;
	import stealth.layouts.Box;
	import stealth.layouts.LayoutElement;

	[Event(name="resize", type="flight.events.LayoutEvent")]
	[Event(name="validate", type="flight.events.InvalidationEvent")]
	
	/**
	 * A generic shape element providing position, size and transformation.
	 * GraphicShape inherits basic drawing from Shape.
	 */
	public class GraphicShape extends Shape implements IGraphicShape, IStateful
	{
		public function GraphicShape()
		{
			layoutElement = new LayoutElement(this);
			addEventListener(InvalidationEvent.VALIDATE, onClear, false, 20);
			addEventListener(InvalidationEvent.VALIDATE, onRender, false, 10);
			addEventListener(LayoutEvent.RESIZE, onResize, false, 10);
			addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10);
			invalidate(LayoutEvent.RESIZE);
			measure();
		}
		
		
		[Bindable(event="maskTypeChange", style="noEvent")]
		public function get maskType():String { return _maskType; }
		public function set maskType(value:String):void
		{
			DataChange.change(this, "maskType", _maskType, _maskType = value);
		}
		private var _maskType:String = "default";

		
		// ====== IStateful implementation ====== //
		
		protected var state:State;
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			if (_currentState != value) {
				var newState:State = State(_states.getById(value));
				if (!newState) {
					newState = _states[0];
				}
				
				if (state != newState) {
					state.undo();
					state = newState;
					state.execute();
					DataChange.change(this, "currentState", _currentState, _currentState = state.name);
				}
			}
		}
		private var _currentState:String;
		
		[ArrayElementType("flight.states.State")]
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states || (states = []); }
		public function set states(value:*):void
		{
			if (!_states) {
				_states = new ArrayList(null, "name");
				_states.addEventListener(ListEvent.LIST_CHANGE, onStatesChanged);
			}
			ArrayList.getInstance(value, _states);
		}
		private var _states:ArrayList;
		
		private function onStatesChanged(event:ListEvent):void
		{
			currentState = _states[0];
		}
				
		
		// ====== IGraphicShape implementation ====== //
		
		private var graphicsPath:GraphicsPath;
		private var graphicsData:Vector.<IGraphicsData>;
		private static var pathBounds:Rectangle = new Rectangle();
		private static var endFill:GraphicsEndFill = new GraphicsEndFill();
		
		[Bindable(event="fillChange", style="noEvent")]
		public function get fill():IFill { return _fill; }
		public function set fill(value:*):void
		{
			value = Paint.getInstance(value);
			
			if (_fill != value) {
				if (_fill && _fill is IEventDispatcher) {
					IEventDispatcher(_fill).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaintChange);
				}
				DataChange.change(this, "fill", _fill, _fill = value);
				invalidate();
				if (_fill && IEventDispatcher) {
					IEventDispatcher(_fill).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaintChange);
				}
			}
		}
		private var _fill:IFill;
		
		[Bindable(event="strokeChange", style="noEvent")]
		public function get stroke():IStroke { return _stroke; }
		public function set stroke(value:*):void
		{
			value = Paint.getInstance(value, true);
			
			if (_stroke != value) {
				if (_stroke && _stroke is IEventDispatcher) {
					IEventDispatcher(_stroke).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaintChange);
				}
				DataChange.change(this, "stroke", _stroke, _stroke = value);
				invalidate();
				if (_stroke && _stroke is IEventDispatcher) {
					IEventDispatcher(_stroke).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPaintChange);
				}
			}
		}
		private var _stroke:IStroke;
		
		[Bindable(event="canvasChange", style="noEvent")]
		public function get canvas():Sprite { return _canvas; }
		public function set canvas(value:Sprite):void
		{
			if (_canvas != value) {
				var canvas:DisplayObject = _canvas || this;
				canvas.removeEventListener(InvalidationEvent.VALIDATE, onClear);
				canvas.removeEventListener(InvalidationEvent.VALIDATE, onRender);
				canvas.removeEventListener(LayoutEvent.RESIZE, onResize);
				DataChange.change(this, "canvas", _canvas, _canvas = value);
				validateNow(LifecycleEvent.CREATE);
				canvas = _canvas || this;
				canvas.addEventListener(InvalidationEvent.VALIDATE, onClear, false, 0xFFF);
				canvas.addEventListener(InvalidationEvent.VALIDATE, onRender, false, 0xFF - _depth);
				canvas.addEventListener(LayoutEvent.RESIZE, onResize, false, 10);
				invalidate();
			}
		}
		private var _canvas:Sprite;
		
		[Bindable(event="depthChange", style="noEvent")]
		public function get depth():int { return _depth; }
		public function set depth(value:int):void
		{
			if (_canvas) {
				_canvas.addEventListener(InvalidationEvent.VALIDATE, onRender, false, 0xFF - _depth);
			}
			DataChange.change(this, "depth", _depth, _depth = value);
		}
		private var _depth:int = 0;
		
		private function onPaintChange(event:PropertyChangeEvent):void
		{
			invalidate();
		}
		
		public function draw(graphics:Graphics):void
		{
			graphics.drawGraphicsData(graphicsData);
		}
		
		public function update(transform:Matrix = null):void
		{
			// clear and reuse graphicsData & graphicsPath instances
			graphicsData.length = 0;
			graphicsPath.data.length = 0;
			graphicsPath.commands.length = 0;
			pathBounds.x = pathBounds.y = 0;
			pathBounds.width = width;
			pathBounds.height = height;
			updatePath(graphicsPath, pathBounds);
			
			if (_canvas) {
				transform = matrix;
			}
			if (transform) {
				var data:Vector.<Number> = graphicsPath.data;
				for (var i:int = 0; i < data.length; i += 2) {
					var x:Number = data[i];
					var y:Number = data[i+1];
					data[i] = transform.a * x + transform.c * y + transform.tx;
					data[i+1] = transform.d * y + transform.b * x + transform.ty;
				}
			}
			
			var fillLength:int, strokeLength:int;
			if (_fill) {
				_fill.update(graphicsPath, pathBounds, transform);
				_fill.paint(graphicsData);
				fillLength = graphicsData.length;
			}
			if (_stroke) {
				_stroke.update(graphicsPath, pathBounds, transform);
				_stroke.paint(graphicsData);
				strokeLength = graphicsData.length - fillLength;
			}
			
			// add graphicsPath for simple strokes and fills
			if (fillLength == 1) {
				if (strokeLength <= 1) {
					graphicsData.push(graphicsPath, endFill);
				} else {
					graphicsData.splice(fillLength, 0, graphicsPath, endFill);
				}
			} else if (strokeLength == 1) {
				graphicsData.push(graphicsPath, endFill);
			}
		}
		
		protected function updatePath(graphicsPath:GraphicsPath, pathBounds:Rectangle):void
		{
		}
		
		override protected function create():void
		{
			graphicsData = new Vector.<IGraphicsData>;
			graphicsPath = new GraphicsPath();
			graphicsPath.data = new Vector.<Number>();
			graphicsPath.commands = new Vector.<int>();
		}
		
		override protected function destroy():void
		{
			graphicsPath.commands = null;
			graphicsPath.data = null;
			graphicsPath = null;
			graphicsData = null;
		}
		
		override public function invalidate(phase:String = null):void
		{
			var canvas:DisplayObject = _canvas || this;
			Invalidation.invalidate(canvas, phase || InvalidationEvent.VALIDATE);
		}
		
		// ====== ITransform implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		override public function set x(value:Number):void
		{
			super.x = layoutElement.x = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set y(value:Number):void
		{
			super.y = layoutElement.y = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="transformXChange", style="noEvent")]
		public function get transformX():Number { return _transformX; }
		public function set transformX(value:Number):void
		{
			DataChange.change(this, "transformX", _transformX, _transformX = value);
		}
		private var _transformX:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="transformYChange", style="noEvent")]
		public function get transformY():Number { return _transformY; }
		public function set transformY(value:Number):void
		{
			DataChange.change(this, "transformY", _transformY, _transformY = value);
		}
		private var _transformY:Number = 0;
		
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleX(value:Number):void
		{
			if (super.scaleX != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.scaleX = value;
					updateTransform(oldMatrix);
				} else {
					 super.scaleX = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set scaleY(value:Number):void
		{
			if (super.scaleY != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.scaleY = value;
					updateTransform(oldMatrix);
				} else {
					super.scaleY = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		
		[Bindable(event="rotationChange", style="noEvent")]
		public function get skewX():Number
		{
			var matrix:Matrix = transform.matrix;
			return Math.atan2(-matrix.c, matrix.d) * (180/Math.PI);
		}
		public function set skewX(value:Number):void
		{
			var oldValue:Number = super.rotation;
			value *= Math.PI/180;
			var matrix:Matrix = transform.matrix;
			matrix.c = scaleY * -Math.sin(value);
			matrix.d = scaleY * Math.cos(value);
			transform.matrix = matrix;
			if (_transformX || _transformY) {
				var oldMatrix:Matrix = transform.matrix;
				DataChange.queue(this, "rotation", oldValue, super.rotation);
				updateTransform(oldMatrix);
			} else {
				DataChange.change(this, "rotation", oldValue, super.rotation);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="rotationChange", style="noEvent")]
		public function get skewY():Number
		{
			var matrix:Matrix = transform.matrix;
			return Math.atan2(matrix.b, matrix.a) * (180/Math.PI);
		}
		public function set skewY(value:Number):void
		{
			var oldValue:Number = super.rotation;
			value *= Math.PI/180;
			var matrix:Matrix = transform.matrix;
			matrix.a = scaleX * Math.cos(value);
			matrix.b = scaleX * Math.sin(value);
			transform.matrix = matrix;
			if (_transformX || _transformY) {
				var oldMatrix:Matrix = transform.matrix;
				DataChange.queue(this, "rotation", oldValue, super.rotation);
				updateTransform(oldMatrix);
			} else {
				DataChange.change(this, "rotation", oldValue, super.rotation);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set rotation(value:Number):void
		{
			if (super.rotation != value) {
				if (_transformX || _transformY) {
					var oldMatrix:Matrix = transform.matrix;
					super.rotation = value;
					updateTransform(oldMatrix);
				} else {
					super.rotation = value;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get matrix():Matrix { return transform.matrix; }
		public function set matrix(value:Matrix):void
		{
			transform.matrix = value;
		}
		
		private function updateTransform(oldMatrix:Matrix):void
		{
			var anchorX:Number = oldMatrix.a * _transformX + oldMatrix.c * _transformY + oldMatrix.tx;
			var anchorY:Number = oldMatrix.d * _transformY + oldMatrix.b * _transformX + oldMatrix.ty;
			
			var newMatrix:Matrix = transform.matrix;
			anchorX -= newMatrix.a * _transformX + newMatrix.c * _transformY + newMatrix.tx;
			anchorY -= newMatrix.d * _transformY + newMatrix.b * _transformX + newMatrix.ty;
			
			DataChange.queue(this, "x", super.x, super.x += anchorX);
			DataChange.change(this, "y", super.y, super.y += anchorY);
		}
		
		
		// ====== ILayoutBounds implementation ====== //
		
		public function get layoutData():Object { return layoutElement; }
		protected var layoutElement:LayoutElement;
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="freeformChange", style="noEvent")]
		public function get freeform():Boolean { return layoutElement.freeform; }
		public function set freeform(value:Boolean):void { layoutElement.freeform = value; }
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentWidth")]
		[Bindable(event="widthChange", style="noEvent")]
		override public function get width():Number { return layoutElement.width; }
		override public function set width(value:Number):void { layoutElement.width = value; }
		
		/**
		 * @inheritDoc
		 */
		[PercentProxy("percentHeight")]
		[Bindable(event="heightChange", style="noEvent")]
		override public function get height():Number { return layoutElement.height; }
		override public function set height(value:Number):void { layoutElement.height = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minWidthChange", style="noEvent")]
		public function get minWidth():Number { return layoutElement.minWidth; }
		public function set minWidth(value:Number):void { layoutElement.minWidth = value; } 
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="minHeightChange", style="noEvent")]
		public function get minHeight():Number { return layoutElement.minHeight; }
		public function set minHeight(value:Number):void { layoutElement.minHeight = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxWidthChange", style="noEvent")]
		public function get maxWidth():Number { return layoutElement.maxWidth; }
		public function set maxWidth(value:Number):void { layoutElement.maxWidth = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="maxHeightChange", style="noEvent")]
		public function get maxHeight():Number { return layoutElement.maxHeight; }
		public function set maxHeight(value:Number):void { layoutElement.maxHeight = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="marginChange", style="noEvent")]
		public function get margin():Box { return layoutElement.margin; }
		public function set margin(value:*):void { layoutElement.margin = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentWidthChange", style="noEvent")]
		public function get percentWidth():Number { return layoutElement.percentWidth; }
		public function set percentWidth(value:Number):void { layoutElement.percentWidth = value; }
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="percentHeightChange", style="noEvent")]
		public function get percentHeight():Number { return layoutElement.percentHeight; }
		public function set percentHeight(value:Number):void { layoutElement.percentHeight = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get preferredWidth():Number { return layoutElement.preferredWidth; }
		
		/**
		 * @inheritDoc
		 */
		public function get preferredHeight():Number { return layoutElement.preferredHeight; }
		
		[Bindable(event="snapToPixelChange", style="noEvent")]
		public function get snapToPixel():Boolean { return layoutElement.snapToPixel; }
		public function set snapToPixel(value:Boolean):void { layoutElement.snapToPixel = value; }
		
		[Bindable(event="leftChange", style="noEvent")]
		public function get left():Number { return layoutElement.left; }
		public function set left(value:Number):void { layoutElement.left = value; }
		
		[Bindable(event="topChange", style="noEvent")]
		public function get top():Number { return layoutElement.top; }
		public function set top(value:Number):void { layoutElement.top = value; }
		
		[Bindable(event="rightChange", style="noEvent")]
		public function get right():Number { return layoutElement.right; }
		public function set right(value:Number):void { layoutElement.right = value; }
		
		[Bindable(event="bottomChange", style="noEvent")]
		public function get bottom():Number { return layoutElement.bottom; }
		public function set bottom(value:Number):void { layoutElement.bottom = value; }
		
		[Bindable(event="hPercentChange", style="noEvent")]
		public function get hPercent():Number { return layoutElement.hPercent; }
		public function set hPercent(value:Number):void { layoutElement.hPercent = value; }
		
		[Bindable(event="vPercentChange", style="noEvent")]
		public function get vPercent():Number { return layoutElement.vPercent; }
		public function set vPercent(value:Number):void { layoutElement.vPercent = value; }
		
		[Bindable(event="hOffsetChange", style="noEvent")]
		public function get hOffset():Number { return layoutElement.hOffset; }
		public function set hOffset(value:Number):void { layoutElement.hOffset = value; }
		
		[Bindable(event="vOffsetChange", style="noEvent")]
		public function get vOffset():Number { return layoutElement.vOffset; }
		public function set vOffset(value:Number):void { layoutElement.vOffset = value; }
		
		[Bindable(event="dockChange", style="noEvent")]
		[Inspectable(enumeration="left,top,right,bottom,fill")]
		public function get dock():String { return layoutElement.dock; }
		public function set dock(value:String):void { layoutElement.dock = value; }
		
		[Bindable(event="tileChange", style="noEvent")]
		[Inspectable(enumeration="left,top,right,bottom")]
		public function get tile():String { return layoutElement.tile; }
		public function set tile(value:String):void { layoutElement.tile = value; }
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return layoutElement.measured; }
		
		/**
		 * @inheritDoc
		 */
		public function getLayoutRect(width:Number = NaN, height:Number = NaN):Rectangle
		{
			return layoutElement.getLayoutRect(width, height);
		}
		
		/**
		 * @inheritDoc
		 */
		public function setLayoutRect(rect:Rectangle):void
		{
			layoutElement.setLayoutRect(rect);
		}
		
		protected function render():void
		{
			var graphics:Graphics = _canvas ? _canvas.graphics : this.graphics;
			update();
			draw(graphics);
		}
		
		protected function measure():void
		{
		}
		
		private function onMeasure(event:LayoutEvent):void
		{
			measure();
		}
		
		private function onResize(event:LayoutEvent):void
		{
			invalidate();
		}
		
		private function onRender(event:InvalidationEvent):void
		{
			render();
		}
		
		private static function onClear(event:Event):void
		{
			event.target.graphics.clear();
		}
	}
}
