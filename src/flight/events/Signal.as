package flight.events
{
	import flash.events.IEventDispatcher;

	import flight.core.stealth;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.ISlot;
	
	use namespace stealth;
	
	public class Signal implements ISignal
	{
		protected var head:Slot;
		
		public function Signal(valueClass:Class = null, eventTarget:IEventDispatcher = null,
							   eventType:String = null, eventPriority:int = 0)
		{
			_valueClass = valueClass || Object;
			if (eventTarget) {
				eventTarget.addEventListener(eventType, dispatchObject, false, eventPriority, true);
			}
		}
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Invalid valueClasses argument: this Signal does not support more than a single value class.
		 */
		[ArrayElementType("Class")]
		public function get valueClasses():Array { return [_valueClass]; }
		public function set valueClasses(value:Array):void
		{
			if (value && value.length > 1) {
				throw new ArgumentError('Invalid valueClasses argument: this Signal does not support more than a single value class.');
			} else {
				_valueClass = value && value[0] ? value[0] : Object;
			}
		}
		private var _valueClass:Class;
		
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
		
		/**
		 * 
		 * @throws ArgumentError <code>ArgumentError</code>: Incorrect number of arguments.
		 * @throws ArgumentError <code>ArgumentError</code>: Value object is not an instance of the appropriate valueClasses Class.
		 */
		public function dispatch(...valueObjects):void
		{
			if (valueObjects.length > 1) {
				throw new ArgumentError('Incorrect number of arguments. '+
					'Expected no more than 1 but received '+valueObjects.length+'.');
			}
			
			
			dispatchObject(valueObjects[0]);
		}
		
		/**
		 * @throws ArgumentError <code>ArgumentError</code>: Value object is not an instance of the appropriate valueClasses Class.
		 */
		public function dispatchObject(valueObject:Object = null):void
		{
			// Optimized for the optimistic case that values are correct.
			if (valueObject && !(valueObject is _valueClass)) {
				throw new ArgumentError('Value object <'+valueObject
					+'> is not an instance of <'+_valueClass+'>.');
			}
			
			var prev:Slot;
			var slot:Slot = head;
			while (slot) {
				if (slot.stealth::enabled) {
					if (slot.once) {
						prev ? prev.next = slot.next : head = slot.next;
					} else {
						prev = slot;
					}
					slot.execute(valueObject);
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
	}
}

