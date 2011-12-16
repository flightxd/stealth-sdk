package flight.events
{
	import flight.core.stealth;

	import org.osflash.signals.ISlot;
	
	use namespace stealth;
	
	public class Slot implements ISlot
	{
		stealth var execute:Function;
		stealth var listener:Function;
		stealth var params:Array;
		
		stealth var once:Boolean;
		stealth var next:Slot;
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean { return stealth::enabled; }
		public function set enabled(value:Boolean):void { stealth::enabled = value; }
		stealth var enabled:Boolean = true;
		
		/**
		 * @inheritDoc
		 * @throws ArgumentError <code>ArgumentError</code>: Incorrect number of parameters.
		 */
		public function callWith(...params):ISlot
		{
			if (params.length == listener.length) {
				execute = executeParams0;
			} else if (params.length == listener.length+1) {
				params.unshift(null);
				execute = executeParams;
			} else {
				throw new ArgumentError('Incorrect number of parameters for target listener. '+
					'Expected '+listener.length+' or '+(listener.length+1)+
					' but received '+params.length+'.');
			}
			this.params = params;
			return this;
		}
		
		stealth function execute0(valueObject:Object):void
		{
			listener();
		}
		
		private function executeParams0(valueObject:Object):void
		{
			listener.apply(null, params);
		}
		
		private function executeParams(valueObject:Object):void
		{
			params[0] = valueObject;
			listener.apply(null, params);
		}
	}

}
