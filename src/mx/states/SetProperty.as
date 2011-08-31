package mx.states
{
	import flight.states.Change;
	
	import mx.core.IMXMLObject;

	public class SetProperty extends Change
	{
		public var name:String;
		
		public function SetProperty(target:Object = null, newValues:Object = null)
		{
			super(target, newValues);
		}
		
		public function get value():Object { return newValues[name]; }
		public function set value(value:Object):void { newValues[name] = value; }
		
		public function initializeFromObject(properties:Object):Object
		{
			newValues = {};
			target = properties.target;
			name = properties.name;
			value = properties.value;
			return this;
		}
	}
}
