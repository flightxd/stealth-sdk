/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.skins
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;
	import flight.states.State;
	import flight.utils.Extension;
	
	import stealth.graphics.MaskType;

	/**
	 * Skin is a convenient base class for many skins, swappable graphic
	 * definitions. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	[DefaultProperty("content")]
	public class Skin extends Extension implements ISkin, IContainer
	{
		public function Skin()
		{
			addEventListener(LayoutEvent.RESIZE, onResize, false, 10);
			addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10);
			addEventListener(InvalidationEvent.VALIDATE, onRender, false, 10);
			
			bindTarget("currentState");
			bindTarget("width");
			bindTarget("height");
			bindTarget("minWidth");
			bindTarget("minHeight");
			bindTarget("maxWidth");
			bindTarget("maxHeight");
			
			bindTarget("alpha");
			bindTarget("mask");
			bindTarget("maskType");
			bindTarget("blendMode");
			bindTarget("filters");
		}
		
		[Bindable(event="alphaChange", style="noEvent")]
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			DataChange.change(this, "alpha", _alpha, _alpha = value);
		}
		private var _alpha:Number = 1;
		
		[Bindable(event="maskChange", style="noEvent")]
		public function get mask():DisplayObject { return _mask; }
		public function set mask(value:DisplayObject):void
		{
			DataChange.change(this, "mask", _mask, _mask = value);
		}
		private var _mask:DisplayObject = null;
		
		[Bindable(event="maskTypeChange", style="noEvent")]
		public function get maskType():String { return _maskType; }
		public function set maskType(value:String):void
		{
			DataChange.change(this, "maskType", _maskType, _maskType = value);
		}
		private var _maskType:String = MaskType.CLIP;
		
		[Bindable(event="blendModeChange", style="noEvent")]
		public function get blendMode():String { return _blendMode; }
		public function set blendMode(value:String):void
		{
			DataChange.change(this, "blendMode", _blendMode, _blendMode = value);
		}
		private var _blendMode:String = BlendMode.NORMAL;
		
		[Bindable(event="filtersChange", style="noEvent")]
		public function get filters():Array { return _filters; }
		public function set filters(value:Array):void
		{
			DataChange.change(this, "filters", _filters, _filters = value);
		}
		private var _filters:Array;
		
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
		
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return Sprite(getTarget()); }
		public function set target(value:Sprite):void
		{
			setTarget(value);
			if (_layout) {
				_layout.target = value ? this : null;
			}
		}
		
		public function getSkinPart(partName:String):InteractiveObject
		{
			return partName in this ? this[partName] : null;
		}
		
		override protected function attach():void
		{
			for (var i:int; i < _content.length; i++) {
				target.addChildAt(DisplayObject(_content.get(i, 0)), i);
			}
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
			target.addEventListener(LayoutEvent.MEASURE, dispatchEvent, false, -10);
			invalidate(LayoutEvent.MEASURE);
		}
		
		override protected function detach():void
		{
			target.removeEventListener(LayoutEvent.MEASURE, onMeasure);
			_content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
			for (var i:int; i < _content.length; i++) {
				target.removeChild(DisplayObject(_content.get(i, 0)));
			}
		}
		
		
		// ====== IContainer implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			ArrayList.getInstance(value, _content);
		}
		private var _content:ArrayList = new ArrayList();
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange", style="noEvent")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				if (_layout) {
					_layout.target = null;
				}
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_layout) {
					_layout.target = target ? this : null;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		[Bindable(event="widthChange", style="noEvent")]
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			DataChange.queue(this, "contentWidth", _width, value);
			DataChange.change(this, "width", _width, _width = value);
			invalidate(LayoutEvent.RESIZE);
		}
		private var _width:Number = 0;
		
		[Bindable(event="heightChange", style="noEvent")]
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			DataChange.queue(this, "contentHeight", _height, value);
			DataChange.change(this, "height", _height, _height = value);
			invalidate(LayoutEvent.RESIZE);
		}
		private var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="widthChange", style="noEvent")]
		public function get contentWidth():Number
		{
			return target ? target.width : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		[Inspectable(category="General")]
		[Bindable(event="heightChange", style="noEvent")]
		public function get contentHeight():Number
		{
			return target ? target.height : 0;
		}
		
		[Bindable(event="minWidthChange", style="noEvent")]
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(value:Number):void
		{
			DataChange.change(this, "minWidth", _minWidth, _minWidth = value);
		}
		private var _minWidth:Number = 0;
		
		[Bindable(event="minHeightChange", style="noEvent")]
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void
		{
			DataChange.change(this, "minHeight", _minHeight, _minHeight = value);
		}
		private var _minHeight:Number = 0;
		
		[Bindable(event="maxWidthChange", style="noEvent")]
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(value:Number):void
		{
			DataChange.change(this, "maxWidth", _maxWidth, _maxWidth = value);
		}
		private var _maxWidth:Number = int.MAX_VALUE;
		
		[Bindable(event="maxHeightChange", style="noEvent")]
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(value:Number):void
		{
			DataChange.change(this, "maxHeight", _maxHeight, _maxHeight = value);
		}
		private var _maxHeight:Number = int.MAX_VALUE;
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:IBounds = new Bounds();
		
		protected function render():void
		{
		}
		
		protected function resize():void
		{
		}
		
		protected function measure():void
		{
			if (!layout) {
				var rect:Rectangle = target.getRect(target);
				_measured.minWidth = rect.right;
				_measured.minHeight = rect.bottom;
			}
		}
		protected var defaultRect:Rectangle;
		
		private function onMeasure(event:LayoutEvent):void
		{
			measure();
			if (target is IMeasureable) {
				var targetMeasured:IBounds = IMeasureable(target).measured;
				targetMeasured.minWidth = _measured.minWidth;
				targetMeasured.minHeight = _measured.minHeight;
				targetMeasured.maxWidth = _measured.maxWidth;
				targetMeasured.maxHeight = _measured.maxHeight;
				targetMeasured.width = _measured.width;
				targetMeasured.height = _measured.height;
			}
		}
		
		private function onResize(event:LayoutEvent):void
		{
			resize();
			invalidate();
		}
		
		private function onRender(event:InvalidationEvent):void
		{
			render();
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (contentChanging) {
				return;
			}
			var target:Sprite = this.target;
			
			contentChanging = true;
			var child:DisplayObject;
			for each (child in event.removed) {
				target.removeChild(child);
			}
			for each (child in event.items) {
				target.addChildAt(child, _content.getIndex(child));
			}
			contentChanging = false;
			
			invalidate(LayoutEvent.MEASURE);
			invalidate(LayoutEvent.LAYOUT);
		}
		private var contentChanging:Boolean;
	}
}
