package stealth.skins
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.SkinEvent;
	import flight.utils.Type;
	import flight.utils.getClassName;
	
	import mx.events.PropertyChangeEvent;
	
	import stealth.graphics.Group;
	import stealth.layouts.Align;
	import stealth.layouts.Box;
	import stealth.layouts.DockLayout;
	import stealth.layouts.ILayoutElement;

	[Event(name="skinPartChange", type="flight.events.SkinEvent")]

	public class TimelineSkin extends Group implements ISkin, IContainer//, IStateful	// TODO: determine extend of state implementation
	{
		protected var skinParts:Object;
		protected var statefulParts:Object;
		
		private var tweens:Dictionary;
		
		public function TimelineSkin()
		{
			bindTarget("currentState");
			bindTarget("width");
			bindTarget("height");
			
			width = defaultRect.width;
			height = defaultRect.height;
		}
		
		// ====== ISkin implementation ====== //
		
		[Bindable(event="targetChange", style="noEvent")]
		public function get target():Sprite { return _target; }
		public function set target(value:Sprite):void
		{
			if (_target != value) {
				
				if (_target) {
					_target.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
					removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange);
					detach();
				}
				DataChange.queue(this ,"target", _target, _target = value);
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
					_target.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange, false, -10, true);
					addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, onPropertyChange, false, -10);
					attach();
				}
				DataChange.change();
			}
		}
		private var _target:Sprite;
		
		public function getSkinPart(partName:String):InteractiveObject
		{
			return partName in this ? this[partName] : null;
		}
		
		protected function attach():void
		{
			_target.addChild(this);
			skinParts = {};
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
						
						this[id] = child;
						dispatchEvent(new SkinEvent(SkinEvent.SKIN_PART_CHANGE, false, false, id, null, InteractiveObject(child)));
					}
					// inspect child if not its own component/skin
					if (child is Sprite && !(child is ISkinnable)) {
						inspectSkin(child as Sprite);
					}
				}
			}	
		}
		
		protected function setMargins(skinPart:InteractiveObject):void
		{
			if (!(skinPart is ILayoutElement)) {
				return;
			}
			
			var layoutPart:Object = ILayoutElement(skinPart);
			var childRect:Rectangle = layoutPart.getLayoutRect();
			trace(childRect);
			// support for simple docking
			if (layoutPart.dock != null) {
				var margin:Box = layoutPart.margin;
				if (layoutPart.dock != Align.LEFT) {
					margin.right = defaultRect.right - childRect.right;
				}
				if (layoutPart.dock != Align.TOP) {
					margin.bottom = defaultRect.bottom - childRect.bottom;
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
					layoutPart.right = defaultRect.right - childRect.right;
				}
				if (!isNaN(layoutPart.bottom)) {
					layoutPart.bottom = defaultRect.bottom - childRect.bottom;
				}
				if (!isNaN(layoutPart.horizontal)) {
					layoutPart.offsetX = childRect.x - layoutPart.horizontal * (defaultRect.width - childRect.width);
				}
				if (!isNaN(layoutPart.vertical)) {
					layoutPart.offsetY = childRect.y - layoutPart.vertical * (defaultRect.height - childRect.height);
				}
			}
		}
		
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
		
		protected override function create():void
		{
			if (parent is ISkinnable) {
				ISkinnable(parent).skin = this;
			}
			if (!layout) {
				layout = new DockLayout();
			}
		}
		
		// ====== IStateful implementation ====== //
		
		[Bindable(event="currentStateChange", style="noEvent")]
		public function get currentState():String { return _currentState; }
		public function set currentState(value:String):void
		{
			if (_currentState != value) {
				DataChange.change(this, "currentState", _currentState, _currentState = value);
				gotoState(value);
			}
		}
		private var _currentState:String;
		
		[Bindable(event="statesChange", style="noEvent")]
		public function get states():Array { return _states; }
		public function set states(value:Array):void
		{
			DataChange.change(this, "states", _states, _states = value);
		}
		private var _states:Array;
		
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
		
		
		private function onPropertyChange(event:PropertyChangeEvent):void
		{
			var property:String = String(event.property);
			if (bindings[property]) {
				bindings[property] = false;
				var bindTarget:Object = event.target != this ? this : _target;
				var newValue:Object = bindTarget[property] = event.newValue;
				trace("property changed", this, property, newValue);
				if (newValue != event.newValue) {
					event.target[property] = newValue;
					event.newValue = newValue;
				}
				bindings[property] = true;
			}
		}
	}
}
