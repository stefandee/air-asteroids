package  
{
	import flash.display.InteractiveObject;
	/**
	 * ...
	 * @author Stefan Dicu
	 */
	public class ShipConfig 
	{
		static public const SHIP_TYPE_1 : uint = 0;
		static public const SHIP_TYPE_2 : uint = 1;
		static public const SHIP_TYPE_3 : uint = 2;
		
		static public const MAX_STAT_VALUE : uint = 5;
		
		public var type      : int;
		public var name      : String;
		
		// these are indices, not actual values
		// it is necessary in order to display each ship stats
		// in the selection menu
		public var maxSpeed    : int;
		public var accel       : int;
		public var turning     : int;
		public var firePower   : int;
		public var fireReload  : int;
		public var powerReload : int;
		
		public var powerInfo   : String;
		
		public function ShipConfig(type : int, 
			name : String, 
			maxSpeed : int, 
			accel : int, 
			turning : int, 
			firePower : int, 
			fireReload  : int, 
			powerReload  : int) 
		{
			this.type        = type;
			this.name        = name;
			this.maxSpeed    = maxSpeed;
			this.accel       = accel;
			this.turning     = turning;
			this.firePower   = firePower;
			this.fireReload  = fireReload;
			this.powerReload = powerReload;
			
			switch(type)
			{
				case 0:
				{
					powerInfo = "Able to teleport randomly.";
					break;
				}
				
				case 1:
				{
					powerInfo = "Able to lay mines.";
					break;
				}
				
				case 2:
				{
					powerInfo = "Able to deploy the bullet storm.";
					break;
				}
			}
		}		
	}

}