package stealth.utils
{
	import flight.collections.ArrayList;
	import flight.collections.IList;
	import flight.containers.IContainer;
	import flight.data.DataChange;
	import flight.events.InvalidationEvent;
	import flight.events.ListEvent;
	import flight.utils.IFactory;

	public class Replicator
	{
		private var target:IContainer;
		
		public function Replicator(target:IContainer)
		{
			this.target = target;
			target.addEventListener(InvalidationEvent.COMMIT, onCommit, false, 20);
		}
		
		
		[Bindable("propertyChange")]
		public function get dataProvider():IList { return _dataProvider; }
		public function set dataProvider(value:*):void
		{
			if (!(value is IList) && value != null) {
				value = ArrayList.getInstance(value, _dataProvider as ArrayList);
			}
			
			if (_dataProvider != value) {
				if (_dataProvider) {
					_dataProvider.removeEventListener(ListEvent.LIST_CHANGE, onProviderChange);
				}
				DataChange.change(this, "dataProvider", _dataProvider, _dataProvider = value);
				target.invalidate(InvalidationEvent.COMMIT);
				if (_dataProvider) {
					_dataProvider.addEventListener(ListEvent.LIST_CHANGE, onProviderChange);
				}
			}
		}
		private var _dataProvider:IList;
		
		
		[Bindable("propertyChange")]
		public function get template():IFactory { return _template }
		public function set template(value:*):void
		{
			DataChange.change(this, "template", _template, _template = value);
			target.invalidate(InvalidationEvent.COMMIT);
		}
		private var _template:IFactory;
		
		protected function commit():void
		{
		}
		
		private function onCommit(event:InvalidationEvent):void
		{
			commit();
		}
		
		private function onProviderChange(event:ListEvent):void
		{
			target.invalidate(InvalidationEvent.COMMIT);
		}
	}
}
