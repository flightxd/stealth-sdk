/*
 * Copyright (c) 2010 the original author or authors.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package stealth.components
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;

	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.LayoutEvent;
	import flight.events.LifecycleEvent;
	import flight.events.ListEvent;
	import flight.layouts.ILayout;
	import flight.utils.Factory;

	import mx.events.PropertyChangeEvent;

	import stealth.behaviors.IBehavior;
	import stealth.graphics.GraphicElement;
	import stealth.skins.ISkin;
	import stealth.skins.ISkinnable;
	import stealth.skins.Theme;

	public class Component extends GraphicElement implements ISkinnable, IContainer
	{
		public function Component()
		{
			_behaviors = new ArrayList();
			_behaviors.addEventListener(ListEvent.LIST_CHANGE, onBehaviorsChange);
			addEventListener(LifecycleEvent.CREATE, onCreate, false, 5);
			minWidth = minHeight = 2;
			snapToPixel = true;
			
			
			skinParts = { contents:IContainer };
		}
		
		[Bindable("propertyChange")]
		public function get disabled():Boolean { return _disabled; }
		public function set disabled(value:Boolean):void
		{
			mouseEnabled = mouseChildren = !value;
			DataChange.change(this, "disabled", _disabled, _disabled = value);
		}
		private var _disabled:Boolean = true;


		override public function get currentState():String
		{
			return _skin ? _skin.currentState : super.currentState;
		}
		override public function set currentState(value:String):void
		{
			_skin ? _skin.currentState = value : super.currentState = value;
		}
		
		override public function get states():Array
		{
			return _skin ? _skin.states : super.states;
		}
		
		[ArrayElementType("stealth.behaviors.IBehavior")]
		[Bindable("propertyChange")]
		public function get behaviors():IList { return _behaviors; }
		public function set behaviors(value:*):void
		{
			ArrayList.getInstance(value, _behaviors);
		}
		private var _behaviors:ArrayList;
		
		
		// ====== IDataRenderer implementation ====== //
		
		[Bindable("propertyChange")]
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			DataChange.change(this, "data", _data, _data = value);
		}
		private var _data:Object;
		
		[Bindable("propertyChange")]
		public function get skin():ISkin { return _skin; }
		public function set skin(value:ISkin):void
		{
			if (!created) {
				_skin = value;
			} else if (_skin != value) {
				if (_skin) {
					_skin.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinPartChange);
					_skin.target = null;
				}
				DataChange.queue(this, "skin", _skin, _skin = value);
				invalidate(LayoutEvent.MEASURE);
				if (_skin) {
					_skin.target = this;
					_skin.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onSkinPartChange);
					for (var i:String in skinParts) {
						this[i] = i in _skin ? _skin[i] : null;
					}
				}
				DataChange.change();
			}
		}
		private var _skin:ISkin;
		
		protected function partAdded(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		protected function partRemoved(partName:String, skinPart:InteractiveObject):void
		{
		}
		
		private function onSkinPartChange(event:PropertyChangeEvent):void
		{
			if (event.property in skinParts) {
				this[event.property] = _skin[event.property];
			}
		}
		
		private function onPropertyChange(event:PropertyChangeEvent):void
		{
			if (event.property in skinParts) {
				partRemoved(String(event.property), InteractiveObject(event.oldValue));
				partAdded(String(event.property), InteractiveObject(event.newValue));
			}
		}
		
		override protected function measure():void
		{
			if (!_skin) {
				super.measure();
			}
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			if (_skin) {
				if (Theme.getSkinName(_skin)) {
					Theme.register(this);
				}
				
				var reset:ISkin = _skin;
				_skin = null;
				skin = reset;
			} else {
				Theme.register(this);
				skin = Factory.getInstance(getTheme());
			}
		}
		
		protected function getTheme():Object
		{
			return null;
		}
		
		private var behaviorsChanging:Boolean;
		private function onBehaviorsChange(event:ListEvent):void
		{
			if (behaviorsChanging) {
				return;
			}
			behaviorsChanging = true;
			
			var behavior:IBehavior;
			for each (behavior in event.removed) {
				delete behaviorsIndex[behavior.name];
				behavior.target = null;
			}
			
			_behaviors.queueChanges = true;
			for each (behavior in event.items) {
				if (behaviorsIndex[behavior.name]) {
					behaviorsIndex[behavior.name].target = null;
					_behaviors.remove(behaviorsIndex[behavior.name]);
				}
				behaviorsIndex[behavior.name] = behavior;
				behavior.target = this;
			}
			_behaviors.queueChanges = false;
			behaviorsChanging = false;
		}
		private var behaviorsIndex:Object = {};
		
		
		// ====== IContainer implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		[ArrayElementType("flash.display.DisplayObject")]
		[Bindable("propertyChange")]
		public function get content():IList { return _content; }
		override public function set content(value:*):void
		{
			explicitContent = true;
			ArrayList.getInstance(value, _content);
		}
		private var _content:ArrayList = new ArrayList();
		private var explicitContent:Boolean;
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		public function get layout():ILayout { return _layout; }
		public function set layout(value:ILayout):void
		{
			explicitLayout = true;
			if (_layout != value) {
				DataChange.queue(this, "layout", _layout, _layout = value);
				if (_contents) {
					_contents.layout = _layout;
				}
				DataChange.change();
			}
		}
		private var _layout:ILayout;
		private var explicitLayout:Boolean;
		
		[Bindable("propertyChange")]
		public function get contentWidth():Number { return _contents ? _contents.contentWidth : 0; }
		
		[Bindable("propertyChange")]
		public function get contentHeight():Number { return _contents ? _contents.contentHeight : 0; }
		
		[SkinPart]
		[Bindable("propertyChange")]
		public function get contents():IContainer { return _contents; }
		public function set contents(value:IContainer):void
		{
			if (_contents != value) {
				if (_contents) {
					_content.removeEventListener(ListEvent.LIST_CHANGE, onContentChange);
					if (explicitLayout) {
						_contents.layout = null;
					}
					if (explicitContent) {
						_contents.content.clear();
					}
				}
				DataChange.queue(this, "contents", _contents, _contents = value);
				if (_contents) {
					if (explicitContent) {
						_contents.content.clear();
						_contents.content.add(_content.get());
					} else if (_contents.content.length) {
						_content.add(_contents.content.get());
					}
					if (explicitLayout) {
						_contents.layout = _layout;
					} else if (_contents.layout) {
						_layout = _contents.layout;
					}
					_content.addEventListener(ListEvent.LIST_CHANGE, onContentChange);
				}
				DataChange.change();
			}
		}
		private var _contents:IContainer;
		
		private function onContentChange(event:ListEvent):void
		{
			explicitContent = true;
			var child:DisplayObject;
			for each (child in event.removed) {
				_contents.content.remove(child);
			}
			for each (child in event.items) {
				_contents.content.add(child, _content.getIndex(child));
			}
		}
	}
}
