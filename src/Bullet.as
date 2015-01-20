package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	
	/**
	 * The Almighty Bullet
	 * 
	 * @author Stefan Dicu
	 */
	public class Bullet extends FlxSprite 
	{
		public static const TYPE_ENEMY  : String = "enemy";
		public static const TYPE_PLAYER : String = "player";
		
		// time to live in miliseconds
		public static const DEFAULT_TTL : Number = 3000;

		[Embed(source="../data/bullets.png")]
        private var SpriteSheet : Class;
		
		private var mission   : Mission;
		private var source    : FlxSprite;
		private var timeStamp : Number;
		private var ttl       : Number;
		public var type       : String;
		
		public function Bullet(mission : Mission, source : FlxSprite, type : String, x : Number, y : Number, ttl : Number = DEFAULT_TTL) 
		{
			this.mission = mission;
			this.source  = source;
			
			timeStamp = 0;
			this.ttl = ttl;
			
			super(x, y);
			
			loadGraphic(SpriteSheet, true, false, 8, 8);
			
			addAnimation("enemy", [0], 0, true);
			addAnimation("player", [1], 0, true);
			
			play(type);
		}
		
		override public function update() : void
		{
			super.update();
			
			timeStamp += FlxG.elapsed;
			
			if (timeStamp * 1000 > ttl)
			{
				kill();
			}
			
			var camera : FlxCamera = FlxG.camera;
			
			getScreenXY(_point, camera);
			
			if (_point.x + width < 0)
			{
				x = camera.width;
			}
			
			if (_point.x > camera.width)
			{
				x = 0;
			}
			
			if (_point.y + height < 0)
			{
				y = camera.height;
			}
			
			if (_point.y > camera.height)
			{
				y = 0;
			}			
		}
		
		override public function hurt(Damage:Number):void
		{
			kill();
		}
		
		public function init(source : FlxSprite, type : String, x : Number, y : Number, ttl : Number = DEFAULT_TTL) : void
		{
			reset(x, y);
			
			this.type = type;
			play(type);
			
			this.source = source;
			
			this.ttl = ttl;
			timeStamp = 0;
		}
	}

}