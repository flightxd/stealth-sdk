package flight.text
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.filters.BitmapFilter;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import flight.collections.ArrayDispatcher;
	import flight.data.DataChange;
	import flight.display.DeferredListener;
	import flight.display.ILifecycle;
	import flight.display.Invalidation;
	import flight.events.InvalidationEvent;
	import flight.events.LifecycleEvent;
	import flight.events.ListEvent;
	import flight.filters.IBitmapFilter;
	
	import mx.core.IMXMLObject;

	[Event(name="commit", type="flight.events.InvalidationEvent")]
	[Event(name="invalidate", type="flight.events.InvalidationEvent")]
	
	[Event(name="ready", type="flight.events.LifecycleEvent")]
	[Event(name="create", type="flight.events.LifecycleEvent")]
	[Event(name="destroy", type="flight.events.LifecycleEvent")]
	
	public class TextField extends flash.text.TextField implements ILifecycle, IMXMLObject
	{
		public function TextField()
		{
			_id = name;
			_filters = new ArrayDispatcher(bitmapFilters = super.filters);
			_filters.addEventListener(ListEvent.LIST_CHANGE, refreshFilters);
			_filters.addEventListener(ListEvent.ITEM_CHANGE, refreshFilters);
			
			addEventListener(Event.ADDED, onFirstAdded, false, 10);
			addEventListener(LifecycleEvent.CREATE, onCreate, false, 10);
			addEventListener(LifecycleEvent.DESTROY, onDestroy, false, 10);
			invalidate(LifecycleEvent.CREATE);
			invalidate(LifecycleEvent.READY);
			
			init();
		}
		
		/**
		 * A convenience property for storing data associated with this element.
		 */
		[Bindable("propertyChange")]
		public function get tag():Object { return _tag; }
		public function set tag(value:Object):void
		{
			DataChange.change(this, "tag", _tag, _tag = value);
		}
		private var _tag:Object;
		
		
		[Bindable("propertyChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			DataChange.change(this, "id", _id, super.name = _id = value);
		}
		private var _id:String;
		
		override public function set name(value:String):void
		{
			id = value;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set text(value:String):void
		{
			var oldHtmlText:String = super.htmlText;
			DataChange.change(this, "text", super.text, super.text = value || "");
			DataChange.change(this, "htmlText", oldHtmlText, super.htmlText);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set htmlText(value:String):void
		{
			var oldText:String = super.text;
			DataChange.queue(this, "htmlText", super.htmlText, super.htmlText = value || "");
			DataChange.change(this, "text", oldText, super.text);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set visible(value:Boolean):void
		{
			DataChange.change(this, "visible", super.visible, super.visible = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set alpha(value:Number):void
		{
			DataChange.change(this, "alpha", super.alpha, super.alpha = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set mask(value:DisplayObject):void
		{
			DataChange.change(this, "mask", super.mask, super.mask = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set blendMode(value:String):void
		{
			DataChange.change(this, "blendMode", super.blendMode, super.blendMode = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		[ArrayElementType("flash.filters.BitmapFilter")]
		[ArrayElementType("flight.filters.IBitmapFilter")]
		override public function get filters():Array { return _filters as Array; }
		override public function set filters(value:Array):void
		{
			_filters.queueChanges = true;
			_filters.length = 0;
			_filters.push.apply(_filters, value);
			_filters.queueChanges = false;
		}
		private var _filters:ArrayDispatcher;
		private var bitmapFilters:Array;
		
		private function refreshFilters(event:ListEvent):void
		{
			if (event.type == ListEvent.LIST_CHANGE || event.items[0].property == "enabled") {
				bitmapFilters.length = 0;
				for each (var filter:Object in _filters) {
					if (filter is IBitmapFilter && IBitmapFilter(filter).enabled) {
						bitmapFilters.push(IBitmapFilter(filter).bitmapFilter);
					} else if (filter is BitmapFilter) {
						bitmapFilters.push(filter);
					}
				}
			}
			super.filters = bitmapFilters;
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set x(value:Number):void
		{
			DataChange.change(this, "x", super.x, super.x = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set y(value:Number):void
		{
			DataChange.change(this, "y", super.y, super.y = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set z(value:Number):void
		{
			DataChange.change(this, "z", super.z, super.z = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleX(value:Number):void
		{
			DataChange.change(this, "scaleX", super.scaleX, super.scaleX = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleY(value:Number):void
		{
			DataChange.change(this, "scaleY", super.scaleY, super.scaleY = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleZ(value:Number):void
		{
			DataChange.change(this, "scaleZ", super.scaleZ, super.scaleZ = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotation(value:Number):void
		{
			DataChange.change(this, "rotation", super.rotation, super.rotation = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationX(value:Number):void
		{
			DataChange.change(this, "rotationX", super.rotationX, super.rotationX = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationY(value:Number):void
		{
			DataChange.change(this, "rotationY", super.rotationY, super.rotationY = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationZ(value:Number):void
		{
			DataChange.change(this, "rotationZ", super.rotationZ, super.rotationZ = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set width(value:Number):void
		{
			DataChange.change(this, "width", super.width, super.width = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set height(value:Number):void
		{
			DataChange.change(this, "height", super.height, super.height = value);
		}
		
		
		// ====== IMXML implementation ====== //
		
		/**
		 * Specialized method for MXML, called after the display has been
		 * created and all of its properties specified in MXML have been
		 * initialized.
		 * 
		 * @param		document	The MXML document defining this display.
		 * @param		id			The identifier used by <code>document</code>
		 * 							to refer to this display, or its instance
		 * 							name.
		 */
		public function initialized(document:Object, id:String):void
		{
			if (id) {
				this.id = id;
			}
		}
		
		
		// ====== IInvalidating implementation ====== //
		
		/**
		 * @inheritDoc
		 */
		public function invalidate(phase:String = null):void
		{
			Invalidation.invalidate(this, phase || InvalidationEvent.VALIDATE);
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow(phase:String = null):void
		{
			Invalidation.validateNow(this, phase);
		}
		
		public function defer(target:IEventDispatcher, event:String, listener:Function, priority:int = 0):DeferredListener
		{
			if (!deferredListeners) {
				deferredListeners = new Dictionary();
			}
			if (!deferredListeners[listener]) {
				deferredListeners[listener] = new DeferredListener(this, listener);
			}
			var deferred:DeferredListener = deferredListeners[listener];
			deferred.priority = priority;
			deferred.defer(target, event);
			return deferred;
		}
		private var deferredListeners:Dictionary;
		
		
		// ====== ILifecycle implementation ====== //
		
		protected function get created():Boolean { return _created; }
		private var _created:Boolean;
		
		public final function kill():void
		{
			removeEventListener(Event.ADDED, onFirstAdded);
			removeEventListener(LifecycleEvent.CREATE, onCreate);
			removeEventListener(LifecycleEvent.DESTROY, onDestroy);
			if (_created) {
				destroy();
				if (parent) {
					parent.removeChild(this);
				}
				_created = false;
			}
		}
		
		protected function init():void
		{
		}
		
		protected function create():void
		{
		}
		
		protected function destroy():void
		{
		}
		
		private function onFirstAdded(event:Event):void
		{
			if (event.target == this) {
				removeEventListener(Event.ADDED, onFirstAdded);
				validateNow(LifecycleEvent.CREATE);
			}
		}
		
		private function onCreate(event:LifecycleEvent):void
		{
			if (!_created) {
				_created = true;
				create();
			}
		}
		
		private function onDestroy(event:LifecycleEvent):void
		{
			kill();
		}
		
		override public function toString():String
		{
			return super.toString().replace("]", "(\"" + _id + "\")]");
		}
	}
}
