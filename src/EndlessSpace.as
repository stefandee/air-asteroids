package  
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Stefan Dicu
	 */
	public class EndlessSpace extends FlxSprite
	{
		public static const MIN_STAR_COUNT : uint = 64;
		public static const MAX_STAR_COUNT : uint = 100;

		public static const MIN_SMALL_STAR_COUNT : uint = 8;
		public static const MAX_SMALL_STAR_COUNT : uint = 24;
		
		public static const MIN_STAR_CLUSTER_COUNT : uint = 4;
		public static const MAX_STAR_CLUSTER_COUNT : uint = 8;
		
		[Embed(source="../data/little_stars.png")]
        private var SpriteLittleStars : Class;		

		[Embed(source="../data/big_stars.png")]
        private var SpriteBigStars : Class;		
		
		public function EndlessSpace() 
		{
			super(0, 0);
			
			reset(0, 0);
		}		
		
		override public function reset(X:Number,Y:Number):void
		{
			super.reset(X, Y);
			
			makeGraphic(FlxG.width, FlxG.height, 0xFF000000, true);
			
			fill(0xFF000000);
			
			pixels.perlinNoise(FlxG.width, FlxG.height, 4, FlxExtraU.randomInt(300000), true, false, 12);
			
			//
			// create a basic starfield
			//
			var pixelStarCount : uint = FlxExtraU.randomRangeInt(MIN_STAR_COUNT, MAX_STAR_COUNT);
			var smallStarCount : uint = FlxExtraU.randomRangeInt(MIN_SMALL_STAR_COUNT, MAX_SMALL_STAR_COUNT);
			renderStarField(0, 0, FlxG.width, FlxG.height, pixelStarCount, smallStarCount, 1);
						
			
			//
			// create star clusters (stamp the stars into the bitmapdata of this sprite)
			//
			var starClusterCount : uint = FlxExtraU.randomRangeInt(MIN_STAR_CLUSTER_COUNT, MAX_STAR_CLUSTER_COUNT);
			
			for (var i : int = 0; i < starClusterCount; i++)
			{
				// some magic numbers there :)
				renderStarField(
				  FlxExtraU.randomInt(FlxG.width), 
				  FlxExtraU.randomInt(FlxG.height), 
				  FlxExtraU.randomRangeInt(48, 96),
				  FlxExtraU.randomRangeInt(48, 96),
				  16,
				  4,
				  1
				  );
			}
		}
		
		private function renderStarField(x : int, y : int, w : int, h : int, pixelStarCount : int, smallStarCount : int, bigStarCount : int) : void
		{
			var tmpRectangle : Rectangle = new Rectangle(0, 0, 1, 1);
			var colors : Array = [0xd24e4f, 0x531313, 0xf08787];
			
			// render the pixel stars
			for (var i : uint = 0; i < pixelStarCount; i++)
			{
				var starSize : int = FlxExtraU.randomRangeInt(1, 3);
				
				tmpRectangle.x = x + FlxExtraU.randomInt(w);
				tmpRectangle.y = y + FlxExtraU.randomInt(h);
				tmpRectangle.width = starSize;
				tmpRectangle.height = starSize;
				
				//var alpha : int = FlxU.randomInt(0xFF) << 24;
				var alpha : int = 0xFF << 24;
				var color : int = colors[FlxExtraU.randomInt(colors.length)];
				
				pixels.fillRect(tmpRectangle, color | alpha);
			}
			
			// render the small stars from the sprite sheet
			var spr : FlxSprite = new FlxSprite(0, 0);
			spr.loadGraphic(SpriteLittleStars, true, false, 5, 5);
			
			for (i = 0; i < smallStarCount; i++)
			{
				spr.randomFrame();
				
				stamp(spr, x + FlxExtraU.randomInt(w), y + FlxExtraU.randomInt(h));
			}			
			
			spr.loadGraphic(SpriteBigStars, true, false, 11, 11);			
			
			for (i = 0; i < bigStarCount; i++)
			{
				spr.randomFrame();
				
				stamp(spr, x + FlxExtraU.randomInt(w), y + FlxExtraU.randomInt(h));
			}						
		}
	}

}