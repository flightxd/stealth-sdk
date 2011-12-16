package flight.collections
{
	import flight.core.stealth;
	import flight.events.ListEvent;
	import flight.events.Slot;
	import flight.utils.getClassName;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.ISlot;

	use namespace stealth;
	
	public class ArraySignal extends Array implements ISignal
	{
		protected var head:Slot;
		protected var changeEvent:ListEvent = new ListEvent(ListEvent.LIST_CHANGE);
		
		public function ArraySignal(source:Object = null)
		{
			if (source) {
				if (source is Array) {
					super.push.apply(this, source);
				} else {
					super.push(source);
				}
			}
		}
		
		
		// ====== ISignal Implementation ====== //
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Invalid valueClasses argument: this Signal does not support more than a single value class.
		 */
		[ArrayElementType("Class")]
		public function get valueClasses():Array { return [ListEvent]; }
		public function set valueClasses(value:Array):void
		{
			throw new ArgumentError('Invalid valueClasses assignment: this Signal does not support custom value classes.');
		}
		
		public function get numListeners():uint
		{
			var num:int = 0;
			var slot:Slot = head;
			while (slot) {
				slot = slot.next;
				++num;
			}
			return num;
		}
		
		public function add(listener:Function):ISlot
		{
			var slot:Slot = head;
			while (slot) {
				if (slot.listener == listener) {
					slot.once = false;
					return slot;
				}
				slot = slot.next;
			}
			
			slot = new Slot();
			slot.execute = listener.length == 0 ? slot.execute0 : listener;
			slot.listener = listener;
			slot.next = head;
			head = slot;
			return slot;
		}
		
		public function addOnce(listener:Function):ISlot
		{
			var slot:Slot = Slot( add(listener) );
			slot.once = true;
			return slot;
		}
		
		public function dispatch(...valueObjects):void
		{
			throw new ArgumentError('Invalid dispatch on '+getClassName(this)+': this Signal does not support public dispatch.');
		}
		
		protected function dispatchChange():void
		{
			var prev:Slot;
			var slot:Slot = head;
			while (slot) {
				if (slot.stealth::enabled) {
					if (slot.once) {
						prev ? prev.next = slot.next : head = slot.next;
					} else {
						prev = slot;
					}
					slot.execute(changeEvent);
				} else {
					prev = slot;
				}
				slot = slot.next
			}
		}
		
		public function remove(listener:Function):ISlot
		{
			var prev:Slot;
			var slot:Slot = head;
			while (slot) {
				if (slot.listener == listener) {
					prev ? prev.next = slot.next : head = slot.next;
					break;
				}
				prev = slot;
				slot = slot.next;
			}
			return slot;
		}
		
		public function removeAll():void
		{
			head = null;
		}
		
		
		// ====== Array Implementation ====== //
		
		override public function set length(value:uint):*
		{
			var oldValue:int = super.length;
			if (oldValue > value) {
				var deleteValues:Array = AS3::slice();
				super.length = value;
				change(oldValue, value, null, deleteValues);
			}
		}
		
		[Bindable("propertyChange")]
		public function get suspended():Boolean { return _suspended; }
		public function set suspended(value:Boolean):void
		{
			if (value) {
				_suspended = changeEvent;
			} else if (_suspended) {
				_suspended = null;
				dispatchChange();
			}
		}
		private var _suspended:ListEvent;
		
		public function set(index:int, item:Object):Object
		{
			if (index < 0) {
				index = super.length - index <= 0 ? 0 : super.length - index;
			}
			var value:* = this[index];
			this[index] = item;
			change(index, index, item, value);
			return item;
		}
		
		override AS3 function push(...args):uint
		{
			var loc:int = super.length;
			var len:int = super.AS3::push.apply(this, args);
			change(loc, len-1, args, null);
			return len;
		}
		
		override AS3 function pop():*
		{
			var len:int = super.length-1;
			var value:* = super.AS3::pop();
			change(len, len, null, value);
			return value;
		}

		override AS3 function shift():*
		{
			var value:* = super.AS3::shift();
			change(0, 0, null, value);
			return value;
		}

		override AS3 function unshift(...args):uint
		{
			var len:int = super.AS3::unshift.apply(this, args);
			change(0, args.length-1, args, null);
			return len;
		}
		
		override AS3 function reverse():Array
		{
			super.AS3::reverse();
			change(0, super.length-1);
			return this;
		}

		override AS3 function splice(...args):*
		{
			var len:int = super.length;
			var startIndex:int = args[0];
			if (startIndex < 0) {
				startIndex = args[0] = len - startIndex <= 0 ? 0 : len - startIndex;
			} else if (startIndex > len) {
				startIndex = len;
			}
			var deleteValues:Array = super.AS3::splice.apply(this, args);
			args.shift();
			var deleteCount:Number = args.shift();
			var max:int = isNaN(deleteCount) ? len-1-startIndex : deleteCount;
			if (args && args.length-1 > max) {
				max = args.length-1;
			}
			change(startIndex, startIndex+max, args, deleteValues);
			return deleteValues;
		}

		override AS3 function sort(...args):*
		{
			var value:* = super.AS3::sort.apply(this, args);
			change(0, super.length);
			return value;
		}
		
		override AS3 function sortOn(names:*, options:* = 0, ...args):*
		{
			args.unshift(names, options);
			var value:* = super.AS3::sortOn.apply(this, args);
			change(0, super.length);
			return value;
		}
		
		override AS3 function concat(...args):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, this);
			for each (var o:Object in args) {
				if (o is Array) {
					value.push.apply(value, o);
				} else {
					value.push(o);
				}
			}
			return value;
		}
		
		override AS3 function slice(startIndex:* = 0, endIndex:* = 16777215):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::slice(startIndex, endIndex));
			return value;
		}

		override AS3 function filter(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::filter(callback, thisObject));
			return value;
		}

		override AS3 function map(callback:Function, thisObject:* = null):Array
		{
			var value:ArrayList = new this['constructor']();
			value.push.apply(value, super.AS3::map(callback, thisObject));
			return value;
		}
		
		protected function change(from:int, to:int, items:Object = null, removed:Object = null):void
		{
			if (_suspended) {
				_suspended.append(from, to, items, removed);
			} else {
				changeEvent.set(from, to, items, removed);
				dispatchChange();
			}
		}
	}
}
