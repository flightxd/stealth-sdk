/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.skins
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import flight.containers.IContainer;
	import flight.events.PropertyEvent;
	import flight.containers.Group;
	import flight.layouts.Align;
	import flight.layouts.Box;
	import flight.layouts.DockLayout;
	import flight.layouts.IBounds;
	import flight.layouts.ILayoutElement;
	import flight.layouts.IMeasureable;
	import flight.utils.Type;
	import flight.utils.getClassName;

	public class TimelineSkin extends Group implements ISkin, IContainer
	{
		protected var statefulParts:Object;
		
		private var tweens:Dictionary;
		
		public function TimelineSkin()
		{
			bindTarget("width");
			bindTarget("height");
			IEventDispatcher(measured).addEventListener(PropertyEvent.PROPERTY_CHANGE, onMeasuredChange, false, 10);
		}
		
		// ====== ISkin implementation ====== //
		
		[Bindable("propertyChange")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target != value) {
				
				if (_target) {
					_target.removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
					removeEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange);
					detach();
				}
				PropertyEvent.queue(this ,"target", _target, _target = value);
				if ("host" in this) {
					this["host"] = _target;
				}
				if (_target) {
					for (var property:String in bindings) {
						bindings[property] = property in _target;
						if (bindings[property]) {
							this[property] = _target[property];
						}
					}
					_target.addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10, true);
					addEventListener(PropertyEvent.PROPERTY_CHANGE, onPropertyChange, false, -10);
					attach();
				}
				PropertyEvent.change();
			}
		}
		private var _target:Sprite;
		
		protected function attach():void
		{
			_target.addChild(this);
			statefulParts = [];
			inspectSkin(target);
		}
		
		protected function detach():void
		{
			_target.removeChild(this);
		}
		
		protected function inspectSkin(skinPart:Sprite):void
		{
			if (skinPart is MovieClip) {
				
				// get frame labels
				var movieclip:MovieClip = skinPart as MovieClip;
				if (movieclip.currentLabels.length) {
					var states:Object = {skinPart:movieclip};
					for each (var label:FrameLabel in movieclip.currentLabels) {
						states[label.name] = label.frame;
					}
					statefulParts.push(states);
				}
			}
			for (var i:int = 0; i < skinPart.numChildren; i++) {
				var child:DisplayObject = skinPart.getChildAt(i);
				if (child is InteractiveObject) {
					var id:String = child.name.replace("$", "");
					skinParts[id] = child;
					if (id in this) {
						
						if (child is ISkin) {
							var type:Class = Type.getPropertyType(this, id);
							if (!(child is type)) {
								var component:InteractiveObject = new type();
								skinPart.addChildAt(component, i);
								component.transform.matrix = child.transform.matrix;
								ISkinnable(component).skin = ISkin(child);
								skinParts[id] = child = component;
							}
						}
						
						// TODO: dispatch propety change event even for burried children to trigger skinPart changes
						this[id] = child;
					}
					// inspect child if not its own component/skin
					if (child is Sprite && !(child is ISkinnable)) {
						inspectSkin(child as Sprite);
					}
				}
			}	
		}
		
		// TODO: refactor to a utility to work anywhere in the Timeline (not just on TimelineSkin)
		protected function setMargins(skinPart:InteractiveObject):void
		{
			if (!(skinPart is ILayoutElement)) {
				return;
			}
			
			var layoutPart:Object = ILayoutElement(skinPart);
			var childRect:Rectangle = layoutPart.getLayoutRect();
			
			// support for simple docking
			if (layoutPart.dock != null) {
				var margin:Box = layoutPart.margin;
				if (layoutPart.dock != Align.LEFT) {
					margin.right = layoutElement.nativeRect.right - childRect.right;
				}
				if (layoutPart.dock != Align.TOP) {
					margin.bottom = layoutElement.nativeRect.bottom - childRect.bottom;
				}
				if (layoutPart.dock != Align.RIGHT) {
					margin.left = childRect.left;
				}
				if (layoutPart.dock != Align.BOTTOM) {
					margin.top = childRect.top;
				}
			} else {
				if (!isNaN(layoutPart.left)) {
					layoutPart.left = childRect.left;
				}
				if (!isNaN(layoutPart.top)) {
					layoutPart.top = childRect.top;
				}
				if (!isNaN(layoutPart.right)) {
					layoutPart.right = layoutElement.nativeRect.right - childRect.right;
				}
				if (!isNaN(layoutPart.bottom)) {
					layoutPart.bottom = layoutElement.nativeRect.bottom - childRect.bottom;
				}
				if (!isNaN(layoutPart.horizontal)) {
					layoutPart.offsetX = childRect.x - layoutPart.horizontal * (layoutElement.nativeRect.width - childRect.width);
				}
				if (!isNaN(layoutPart.vertical)) {
					layoutPart.offsetY = childRect.y - layoutPart.vertical * (layoutElement.nativeRect.height - childRect.height);
				}
			}
		}
		
		// TODO: refactor to a utility to work anywhere in the Timeline (not just on TimelineSkin)
		private function onTweenFrame(event:Event):void
		{
			var tweening:Boolean = false;
			for (var skinPart:* in tweens) {
				var targetFrame:int = tweens[skinPart];
				if (targetFrame == skinPart.currentFrame) {
					delete tweens[skinPart];
				} else {
					tweening = true;
					if (targetFrame < skinPart.currentFrame) {
						skinPart.gotoAndStop(skinPart.currentFrame - 1);
					} else {
						skinPart.gotoAndStop(skinPart.currentFrame + 1);
					}
				}
			}
			if (!tweening) {
				target.removeEventListener(Event.ENTER_FRAME, onTweenFrame);
			}
		}
		
		private function onMeasuredChange(event:PropertyEvent):void
		{
			if (target is IMeasureable) {
				var targetMeasured:IBounds = IMeasureable(target).measured;
				targetMeasured.minWidth = measured.minWidth;
				targetMeasured.minHeight = measured.minHeight;
				targetMeasured.maxWidth = measured.maxWidth;
				targetMeasured.maxHeight = measured.maxHeight;
				targetMeasured.width = measured.width;
				targetMeasured.height = measured.height;
			}
		}
		
		// TODO: refactor to a utility to work anywhere in the Timeline (not just on TimelineSkin)
		protected function gotoState(state:String):void
		{
			removeEventListener(Event.ENTER_FRAME, onTweenFrame);
			for each (var states:Object in statefulParts) {
				var skinPart:MovieClip = states.skinPart;
				if (!states[state]) {
					continue;
				}
				if (states[state + "Start"]) {
					target.addEventListener(Event.ENTER_FRAME, onTweenFrame);
					if (!tweens) tweens = new Dictionary(true);
					tweens[skinPart] = states[state];
					skinPart.gotoAndStop(states[state + "Start"]);
				} else {
					skinPart.gotoAndStop(states[state]);
				}
			}
		}
		
		protected override function create():void
		{
			if (parent is ISkinnable) {
				ISkinnable(parent).skin = this;
			}
			if (!layout) {
				layout = new DockLayout();
			}
		}
		
		// ====== Extension implementation ====== //
		
		protected function bindTarget(property:String):void
		{
			if (property in this) {
				bindings[property] = _target && property in _target;
				if (bindings[property]) {
					this[property] = _target[property];
				}
			} else {
				throw new Error("Cannot register property " + property + " in " + getClassName(this));
			}
		}
		private var bindings:Object = {};
		
		
		private function onPropertyChange(event:PropertyEvent):void
		{
			var property:String = String(event.property);
			if (bindings[property]) {
				bindings[property] = false;
				var bindTarget:Object = event.target != this ? this : _target;
				var newValue:Object = bindTarget[property] = event.newValue;
				if (newValue != event.newValue) {
					event.target[property] = newValue;
					event.newValue = newValue;
				}
				bindings[property] = true;
			}
		}
	}
}
