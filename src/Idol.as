package  
{
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	import org.flixel.FlxSound;
  
	/**
	 * ...
	 * @author Stefan Dicu
	 */
	public class Idol extends Enemy 
	{
		public static const SCORE_POINTS    : int = 100;
		public static const BULLET_DELAY    : int = 1500;
		public static const BULLET_TTL      : int = 3000;
		public static const BULLET_VELOCITY : int = 175;		
		public static const VELOCITY        : int = 100;		
		
		[Embed(source="../data/idol.png")]
        private var SpriteSheet : Class;
		
		private var bulletDelay  : Number;
		private var sndFire      : FlxSound;			
		
		public function Idol(mission : Mission, x : Number, y : Number) 
		{
			super(mission, x, y);
			
			loadGraphic(SpriteSheet, true, false, 48, 52);	
			addAnimation("idle", [0, 1], 300, true);
			
			play("idle");
			
			bulletDelay = BULLET_DELAY;
			
			randomHeading();	
			
			sndFire = FlxG.loadSound(SoundData.SndIdolFire, 1.0, false, false);			
		}
		
		override public function scorePoints() : int
		{
			return SCORE_POINTS;
		}			
		
		override public function update() : void
		{
			super.update();
			
			// check if outside the screen and generate a new random heading
			if (!onScreen())
			{
				randomHeading();
			}
			
			bulletDelay -= FlxG.elapsed * 1000.0;
			
			if (bulletDelay <= 0)
			{
				// fire toward the closest player
				var player : Player = mission.getClosestPlayer(x + origin.x, y + origin.y);
				
				if (player != null)
				{
					// add the bullet 
					var bullet : Bullet = mission.addBullet(
					  this,
					  "enemy", 
					  x + origin.x,
					  y + origin.y,
					  BULLET_TTL);
				  
					bullet.velocity.x = player.x + player.origin.x - x - origin.x;
					bullet.velocity.y = player.y + player.origin.y - y - origin.y;
					
					// bullet.velocity.normalize();
          FlxExtraU.normalize(bullet.velocity);
          
					// bullet.velocity.multScalar(BULLET_VELOCITY);
          FlxExtraU.multScalar(bullet.velocity, BULLET_VELOCITY);
						
					//mission.enemyBullets.add(bullet);
					sndFire.play();
				}										
				
				bulletDelay = BULLET_DELAY;
			}
		}
		
		private function randomHeading() : void
		{
			velocity.x = FlxExtraU.randomInt(FlxG.width) - x;
			velocity.y = FlxExtraU.randomInt(FlxG.height) - y;
      
			// velocity.normalize();
      FlxExtraU.normalize(velocity);
      
			// velocity.multScalar(VELOCITY);
      FlxExtraU.multScalar(velocity, VELOCITY);
		}
		
		override public function hurt(Damage:Number):void
		{
			// add an explosion fx
			mission.addExplosion(x + origin.x, y + origin.y);
			
			FlxG.play(SoundData.SndExplosion2, 1.0, false, true);
			
			kill();
		}
		
		public function init(x : Number, y : Number) : void
		{
			bulletDelay = BULLET_DELAY;
			
			reset(x, y);
			
			randomHeading();
		}
	}

}