package flight.core
{
	public class SizeMode
	{
		public static const HMASK:uint =				3 <<0;						// horizontal range 0,1,2,3
		public static const VMASK:uint =						3 <<2;				// vertical range 0,4,8,12
		
		public static const SCALE:uint =				1 <<0 | 1 <<2;				// 1 | 4 = 5
		public static const CONSTRAIN:uint =			2 <<0 | 2 <<2;				// 2 | 8 = 10
		public static const OVERFLOW:uint =				3 <<0 | 3 <<2;				// 3 | 12 = 15
	}
}
