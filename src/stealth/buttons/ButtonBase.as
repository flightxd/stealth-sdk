/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.buttons
{
	import flash.display.DisplayObject;
	
	import flight.components.ButtonState;
	import flight.components.Component;
	import flight.containers.Group;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.ButtonEvent;
	import flight.events.ListEvent;
	import flight.events.ListEventKind;
	import flight.layouts.ILayout;
	import flight.list.ArrayList;
	import flight.list.IList;
	
	[SkinState("up")]
	[SkinState("over")]
	[SkinState("down")]
	[SkinState("disabled")]
	[SkinState("upSelected")]
	[SkinState("overSelected")]
	[SkinState("downSelected")]
	[SkinState("disabledSelected")]
	
	[Event(name="press", type="flight.events.ButtonEvent")]
	[Event(name="hold", type="flight.events.ButtonEvent")]
	[Event(name="drag", type="flight.events.ButtonEvent")]
	[Event(name="dragOver", type="flight.events.ButtonEvent")]
	[Event(name="dragOut", type="flight.events.ButtonEvent")]
	[Event(name="release", type="flight.events.ButtonEvent")]
	[Event(name="releaseOutside", type="flight.events.ButtonEvent")]
	
	public class ButtonBase extends Component implements IContainer
	{
		protected var mouseState:String = ButtonState.UP;
		
		public function ButtonBase()
		{
			ButtonEvent.initialize(this);
			skinParts = {contentGroup:Group};
		}
		
		override public function set disabled(value:Boolean):void
		{
			mouseState = value ? ButtonState.DISABLED : ButtonState.UP;
			super.disabled = value;
			super.currentState = getButtonState();
		}
		
		override public function set currentState(value:String):void
		{
			mouseState = value.replace("Selected", "");
			super.disabled = mouseState == ButtonState.DISABLED;
			super.currentState = getButtonState();
		}
		
		[Bindable(event="selectedChange", style="noEvent")]
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void
		{
			DataChange.queue(this, "selected", _selected, _selected = value);
			super.currentState = getButtonState();
		}
		private var _selected:Boolean;
		
		[Bindable(event="holdPressChange", style="noEvent")]
		public function get holdPress():Boolean { return _holdPress; }
		public function set holdPress(value:Boolean):void
		{
			DataChange.change(this, "holdPress", _holdPress, _holdPress = value);
		}
		private var _holdPress:Boolean;
		
		[SkinPart]
		[Bindable(event="contentGroupChange", style="noEvent")]
		public function get contentGroup():Group { return _contentGroup; }
		public function set contentGroup(value:Group):void
		{
			if (_contentGroup != value) {
				if (_contentGroup) {
					_contentGroup.content.removeItems();
					_content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
					if (_layout) {
						_contentGroup.layout = null;
					}
				}
				DataChange.queue(this, "contentGroup", _contentGroup, _contentGroup = value);
				if (_contentGroup) {
					if (_content.length) {
						_contentGroup.content.removeItems();
						_contentGroup.content.addItems(_content.getItems());
					} else if (contentGroup.content.length) {
						_content.addItems(contentGroup.content.getItems());
					}
					_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
					if (_layout) {
						_contentGroup.layout = _layout;
					}
				}
				DataChange.change();
			}
		}
		private var _contentGroup:Group;
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable(event="contentChange", style="noEvent")]
		public function get content():IList { return _content; }
		public function set content(value:*):void
		{
			_content.removeItems();
			if (value is DisplayObject) {
				_content.addItem(value);
			} else if (value is Array) {
				_content.addItems(value);
			} else if (value is IList) {
				_content.addItems( IList(value).getItems() );
			}
			DataChange.change(this, "content", _content, _content, true);
		}
		private var _content:IList = new ArrayList();
		
		/**
		 * @inheritDoc
		 */
		[Bindable(event="layoutChange", style="noEvent")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			if (_layout != value) {
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_contentGroup) {
					_contentGroup.layout = _layout;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		
		[Bindable(event="contentWidthChange", style="noEvent")]
		public function get contentWidth():Number { return _contentGroup ? _contentGroup.contentWidth : 0; }
		
		[Bindable(event="contentHeightChange", style="noEvent")]
		public function get contentHeight():Number { return _contentGroup ? _contentGroup.contentHeight : 0; }
		
		protected function getButtonState():String
		{
			return _selected ? mouseState + "Selected" : mouseState;
		}
		
		private function onContentChange(event:ListEvent):void
		{
			var child:DisplayObject;
			var location:int = event.location1;
			switch (event.kind) {
				case ListEventKind.ADD:
					_contentGroup.content.addItems(event.items, location);
					break;
				case ListEventKind.REMOVE:
					_contentGroup.content.removeItems(location, event.items.length);
					break;
				case ListEventKind.MOVE:
					if (event.items.length == 1) {
						_contentGroup.content.setItemIndex(event.items[0], location);
					} else {
						_contentGroup.content.swapItems(location, event.location2);
					}
					break;
				case ListEventKind.REPLACE:
					removeChild(event.items[1]);
					addChildAt(event.items[0], location);
					break;
				default:	// ListEventKind.RESET
					for each (child in event.items) {
						removeChild(child);
					}
					for each (child in _content) {
						addChildAt(child, location++);
					}
			}
		}
	}
}
