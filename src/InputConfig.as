package  
{
	/**
	 * A data class to exchange input keys from ship selection to game
	 * 
	 * @author Stefan Dicu
	 */
	public class InputConfig 
	{
		public var up    : String;
		public var down  : String;
		public var left  : String;
		public var right : String;
		public var fire  : String;
		
		// the super power key
		public var superPower : String;
		
		public function InputConfig(up : String, down : String, left : String, right : String, fire : String, superPower : String) 
		{
			this.up         = up;
			this.down       = down;
			this.left       = left;
			this.right      = right;
			this.fire       = fire;
			this.superPower = superPower;
		}
		
	}

}