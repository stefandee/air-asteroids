package 
{
  import org.flixel.FlxPoint;
  
	/**
   * A random utils library.
   * 
   * @author Piron Games
   */
  public class FlxExtraU 
  {
		static public function randomInt(v : int) : int
		{
			return int(v * Math.random());
		}
		
		static public function randomRangeInt(a : int, b : int) : int
		{
			return a + int((b - a) * Math.random());
		}
    
		/**
		 * Normalize the vector
		 * 
		 * @param
		 * 
		 * @return	Length of the vector
		 */
		static public function length(p: FlxPoint) : Number
		{
			return Math.sqrt(p.x * p.x + p.y * p.y);
		}
		
		/**
		 * Normalizes the vector
		 * 
		 * @param
		 * 
		 * @return	
		 */
		static public function normalize(p: FlxPoint) : void
		{
			var length : Number = FlxExtraU.length(p);
			
			if (length != 0)
			{
				p.x = p.x / length;
				p.y = p.y / length;
			}
		}
		
		/**
		 * Scale the vector by a value
		 * 
		 * @param Scalar to scale
		 * 
		 * @return	
		 */
		static public function multScalar(p: FlxPoint, scale : Number) : void
		{
			p.x *= scale;
			p.y *= scale;
		}
		
		static public function rotateAroundOrigin(p: FlxPoint, angle : Number) : void
		{
			var newX : Number = Math.cos(angle) * p.x - Math.sin(angle) * p.y;
			var newY : Number = Math.sin(angle) * p.x + Math.cos(angle) * p.y;
			p.x = newX;
			p.y = newY;
		}    
  }

}