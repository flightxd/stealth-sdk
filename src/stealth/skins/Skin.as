/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.skins
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataBind;
	import flight.data.DataChange;
	import flight.display.Invalidation;
	import flight.events.InvalidationEvent;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.layouts.IMeasureable;
	import flight.utils.Extension;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]
	
	/**
	 * Skin is a convenient base class for many skins, swappable graphic
	 * definitions. Skins decorate a target Sprite by drawing on its surface,
	 * adding children to the Sprite, or both.
	 */
	[DefaultProperty("content")]
	public class Skin extends Extension implements ISkin, IContainer//, IStateful
	{
		public function Skin()
		{
			bindTarget("currentState");
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
			var target:Sprite = this.target;
			for (var i:int = 0; i < target.numChildren; i ++) {
				_content.add(target.getChildAt(i), i);
			}
			for (i; i < _content.length; i++) {
				target.addChildAt(DisplayObject(_content.get(i, 0)), i);
			}
			target.addEventListener(LayoutEvent.MEASURE, onMeasure, false, 10, true);
			target.addEventListener(Event.ADDED, onChildAdded, true);
			target.addEventListener(Event.REMOVED, onChildRemoved, true);
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
		}
		
		override protected function detach():void
		{
			var target:Sprite = this.target;
			target.removeEventListener(Event.ADDED, onChildAdded, true);
			target.removeEventListener(Event.REMOVED, onChildRemoved, true);
			_content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
			
			while (target.numChildren) {
				target.removeChildAt(0);
			}
		}
		
		public function invalidate(phase:String = null):void
		{
			Invalidation.invalidate(target, phase || InvalidationEvent.VALIDATE);
		}
		
		
		public function validateNow(phase:String = null):void
		{
			Invalidation.validateNow(target, phase);
		}
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			DataChange.change(this, "currentState", _currentState, _currentState = value);
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
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
		
		/**
		 * @inheritDoc
		 */
		public function get measured():IBounds { return _measured; }
		private var _measured:IBounds = new Bounds();
		
		protected function measure():void
		{
			var rect:Rectangle = target.getRect(target);
			_measured.width = rect.width;
			_measured.height = rect.height;
		}
		
		private function onMeasure(event:Event):void
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
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != target) {
				return;
			}
			
			contentChanging = true;
			content.add(child, target.getChildIndex(child));
			contentChanging = false;
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (contentChanging || child.parent != target) {
				return;
			}
			
			contentChanging = true;
			content.remove(child);
			contentChanging = false;
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
