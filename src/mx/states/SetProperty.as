package mx.states
{
	import flight.states.Change;

	import mx.core.IMXMLObject;

	public class SetProperty extends Change
	{
		public function SetProperty(target:Object = null, newValues:Object = null)
		{
		}
		
		public function initializeFromObject(properties:Object):Object
		{
			target = properties.target;
			newValues = {};
			newValues[properties.name] = properties.value;
			return this;
		}
	}
}
