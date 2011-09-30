/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.data.DataChange;
	import flight.display.MovieClip;
	import flight.events.LayoutEvent;
	import flight.events.ListEvent;
	import flight.layouts.Bounds;
	import flight.layouts.IBounds;
	import flight.layouts.ILayout;
	import flight.states.IStateful;
	import flight.states.State;

	public class Container extends MovieClip implements IContainer, IStateful
	{
		public function Container(content:* = null)
		{
			addEventListener(Event.ADDED, onChildAdded, true, 10);
			addEventListener(Event.REMOVED, onChildRemoved, true, 10);
			
			_content = new ArrayList();
			for (var i:int = 0; i < numChildren; i++) {
				_content.add(getChildAt(i));
			}
			_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange, false, 10);
			if (content) {
				this.content = content;
			}
		}
		
		
		// ====== IStateful implementation ====== //
		
		protected var state:State;
		
		[Bindable("propertyChange")]
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
		[Bindable("propertyChange")]
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
		
		
		// ====== IContainer implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable("propertyChange")]
		public function get content():IList { return _content; }
		override public function set content(value:*):void
		{
			ArrayList.getInstance(value, _content);
		}
		private var _content:ArrayList;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				if (_layout) {
					_layout.target = null;
				}
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_layout) {
					_layout.target = this;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		[Bindable("propertyChange")]
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void
		{
			_measured.width = value;
			DataChange.change(this, "width", _width, _width = value);
		}
		private var _width:Number = 0;
		
		[Bindable("propertyChange")]
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void
		{
			_measured.height = value;
			DataChange.change(this, "height", _height, _height = value);
		}
		private var _height:Number = 0;
		
		public function get contentWidth():Number { return super.width; }
		public function set contentWidth(value:Number):void { super.width = value; }
		
		public function get contentHeight():Number { return super.width; }
		public function set contentHeight(value:Number):void { super.height = value;}
		
		public function get measured():IBounds { return _measured; }
		private var _measured:Bounds = new Bounds(0, 0);
		
		private function onChildAdded(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (child.parent == this && !contentChanging) {
				contentChanging = true;
				content.add(child, getChildIndex(child));
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		
		private function onChildRemoved(event:Event):void
		{
			var child:DisplayObject = DisplayObject(event.target);
			if (child.parent == this && !contentChanging) {
				contentChanging = true;
				content.remove(child);
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		
		private function onContentChange(event:ListEvent):void
		{
			if (!contentChanging) {
				contentChanging = true;
				var child:DisplayObject;
				for each (child in event.removed) {
					removeChild(child);
				}
				for each (child in event.items) {
					addChildAt(child, _content.getIndex(child));
				}
				contentChanging = false;
				
				invalidate(LayoutEvent.MEASURE);
				invalidate(LayoutEvent.LAYOUT);
			}
		}
		private var contentChanging:Boolean;
				
	}
}
