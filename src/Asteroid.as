package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxCamera;	
	import org.flixel.FlxU;	
	import org.flixel.FlxG;	
	
	/**
	 * It's an asteroid. Upon collision with bullets, will "recursively" split
	 * into smaller chunks.
	 * 
	 * Upon collision with the player ship, substract a live.
	 * 
	 * @author Stefan Dicu
	 */
	public class Asteroid extends Enemy 
	{		
		// 0 - big, 1 - medium, 2 - small
		private var level : int;
		
		[Embed(source="../data/asteroid1_lvl1.png")]
        private var SpriteSheet1 : Class;

		[Embed(source="../data/asteroid1_lvl2.png")]
        private var SpriteSheet2 : Class;

		[Embed(source="../data/asteroid1_lvl3.png")]
        private var SpriteSheet3 : Class;		
		
		public function Asteroid(mission : Mission, level : int, x : Number, y : Number) 
		{
			super(mission, x, y);
			
			init(level, x, y);			
		}
		
		override public function update() : void
		{
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
			if (!exists || !active)
			{
				return;
			}
			
			// add an explosion fx
			mission.addExplosion(x, y);
			
			FlxG.play(SoundData.SndExplosion, 1.0, false, true);
			
			// split the larger asteroids in two
			if (level < 2)
			{
				var velocitySpread : Number = FlxU.randomRangeInt(10, 20) * Math.PI / 180;
				var asteroidCount  : int = 2;
				var velAngle       : Number = -velocitySpread / asteroidCount;
				var velAngleDelta  : Number = velocitySpread / (asteroidCount - 1)
				
				for (var i : int = 0; i < asteroidCount; i++)
				{				
					// TODO: this shouldn't happen, but there is an insidious bug
					// when asteroids get blasted by a mine; must further 
					// investigate
					if (level + 1 > 2)
					{
						continue;
					}
					
					var asteroid : Asteroid = mission.addAsteroid(
					  level + 1,
					  x + origin.y + FlxU.randomRangeInt(-20, 20),
					  y + origin.y + FlxU.randomRangeInt(-20, 20)
					 );
					 
					 asteroid.velocity.x = velocity.x;
					 asteroid.velocity.y = velocity.y;
					 
					 //mission.enemies.add(asteroid);
					 					 
					 					 
					 // distribute the velocities
					 asteroid.velocity.rotateAroundOrigin(velAngle);
					 
					 // scale the velocity with a small factor
					 asteroid.velocity.multScalar(1.0 + 0.2 * Math.random());
					 
					 velAngle += velAngleDelta;
				}
			}
			
			kill();
		}
		
		override public function scorePoints() : int
		{
			return 10 + level * 5;
		}
		
		public function init(level : int, x : Number, y : Number) : void
		{
			reset(x, y);
			
			this.level = level;
			
			switch(level)
			{
				case 0:
				{
					loadGraphic(SpriteSheet1, true, false, 54, 38);
					addAnimation("idle", [0], 0, true);
					break;
				}
				
				case 1:
				{
					loadGraphic(SpriteSheet2, true, false, 32, 32);
					
					addAnimation("idle", [FlxU.randomInt(2)], 0, true);
					
					break;
				}
				
				case 2:
				{
					loadGraphic(SpriteSheet3, true, false, 16, 16);	
					addAnimation("idle", [FlxU.randomInt(4)], 0, true);
					break;
				}
			}
			
			trace("trace asteroid level: " + level);
			
			play("idle");			
		}
	}

}