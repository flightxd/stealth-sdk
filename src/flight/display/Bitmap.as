/*
 * From the Stealth SDK, a UI framework for the Flash Developer.
 *   Copyright (c) 2011 Tyler Wright - Flight XD.
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package flight.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filters.BitmapFilter;

	import flight.collections.ArrayList;
	import flight.events.InvalidationEvent;
	import flight.events.ListEvent;
	import flight.events.PropertyEvent;
	import flight.filters.IBitmapFilter;

	import mx.core.IMXMLObject;

	[Event(name="commit", type="flight.events.InvalidationEvent")]
	[Event(name="validate", type="flight.events.InvalidationEvent")]
	[Event(name="ready", type="flight.events.InvalidationEvent")]
	
	[DefaultProperty("source")]
	public class Bitmap extends flash.display.Bitmap implements IInvalidating, IMXMLObject
	{
		public function Bitmap(source:* = null, pixelSnapping:String = PixelSnapping.AUTO, smoothing:Boolean = false)
		{
			super(null, pixelSnapping, smoothing);
			this.source = source;
			
			_id = name;
			_filters = new ArrayList(bitmapFilters = super.filters);
			_filters.addEventListener(ListEvent.LIST_CHANGE, refreshFilters);
			_filters.addEventListener(ListEvent.ITEM_CHANGE, refreshFilters);
			
			addEventListener(Event.ADDED, onCreate, false, 10);
			addEventListener(InvalidationEvent.COMMIT, onCreate, false, 10);
			invalidate(InvalidationEvent.COMMIT);
			invalidate(InvalidationEvent.READY);
			
			init();
		}
		
		/**
		 * A convenience property for storing data associated with this element.
		 */
		[Bindable("propertyChange")]
		public function get tag():Object { return _tag; }
		public function set tag(value:Object):void
		{
			PropertyEvent.change(this, "tag", _tag, _tag = value);
		}
		private var _tag:Object;
		
		
		[Bindable("propertyChange")]
		public function get id():String { return _id; }
		public function set id(value:String):void
		{
			PropertyEvent.change(this, "id", _id, super.name = _id = value);
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
		override public function set bitmapData(value:BitmapData):void
		{
			PropertyEvent.change(this, "bitmapData", super.bitmapData, super.bitmapData = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set visible(value:Boolean):void
		{
			PropertyEvent.change(this, "visible", super.visible, super.visible = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set alpha(value:Number):void
		{
			PropertyEvent.change(this, "alpha", super.alpha, super.alpha = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set mask(value:DisplayObject):void
		{
			PropertyEvent.change(this, "mask", super.mask, super.mask = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set blendMode(value:String):void
		{
			PropertyEvent.change(this, "blendMode", super.blendMode, super.blendMode = value);
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
		private var _filters:ArrayList;
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
			PropertyEvent.change(this, "x", super.x, super.x = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set y(value:Number):void
		{
			PropertyEvent.change(this, "y", super.y, super.y = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set z(value:Number):void
		{
			PropertyEvent.change(this, "z", super.z, super.z = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleX(value:Number):void
		{
			PropertyEvent.change(this, "scaleX", super.scaleX, super.scaleX = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleY(value:Number):void
		{
			PropertyEvent.change(this, "scaleY", super.scaleY, super.scaleY = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set scaleZ(value:Number):void
		{
			PropertyEvent.change(this, "scaleZ", super.scaleZ, super.scaleZ = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotation(value:Number):void
		{
			PropertyEvent.change(this, "rotation", super.rotation, super.rotation = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationX(value:Number):void
		{
			PropertyEvent.change(this, "rotationX", super.rotationX, super.rotationX = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationY(value:Number):void
		{
			PropertyEvent.change(this, "rotationY", super.rotationY, super.rotationY = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set rotationZ(value:Number):void
		{
			PropertyEvent.change(this, "rotationZ", super.rotationZ, super.rotationZ = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set width(value:Number):void
		{
			PropertyEvent.change(this, "width", super.width, super.width = value);
		}
		
		/**
		 * @inheritDoc
		 */
		[Bindable("propertyChange")]
		override public function set height(value:Number):void
		{
			PropertyEvent.change(this, "height", super.height, super.height = value);
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
		
		public function set source(value:*):void
		{
			bitmapData = BitmapSource.getInstance(value);
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
		
		public function defer(method:Function, withPropertyChange:String = null):void
		{
			deferred ||= new Deferred(this);
			deferred.defer(method, withPropertyChange);
		}
		private var deferred:Deferred;
		
		protected function get created():Boolean { return _created; }
		private var _created:Boolean;
		
		final public function kill():void
		{
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
		
		private function onCreate(event:Event):void
		{
			if (event.target == this) {
				removeEventListener(Event.ADDED, onCreate);
				removeEventListener(InvalidationEvent.COMMIT, onCreate);
				
				if (!_created) {
					_created = true;
					create();
				}
			}
		}
		
		override public function toString():String
		{
			return super.toString().replace("]", "(\"" + _id + "\")]");
		}
	}
}
