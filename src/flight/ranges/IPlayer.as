package flight.ranges
{
	public interface IPlayer extends IProgress
	{
		function get playing():Boolean;
		
		function play():void
		function pause():void;
		function stop():void;
		
		function seek(position:Number = NaN):void;
	}
}

