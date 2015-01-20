package  
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Stefan Dicu
	 */
	public class Enemy extends FlxSprite 
	{
		protected var mission : Mission;
				
		public function Enemy(mission : Mission, x : Number, y : Number) 
		{
			this.mission = mission;
			
			super(x, y);
		}
		
		public function scorePoints() : int
		{
			return 0;
		}		
	}

}