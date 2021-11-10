package  
{
	import flash.display.InteractiveObject;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;	
	
	/**
	 * Handles the game logic
	 * 
	 * @author Stefan Dicu
	 */
	public class Mission extends FlxGroup
	{
		public static const STAGES : int = 12;
		
		public var player1       : Player;
		public var player2       : Player;		
		public var stage         : int;
		
		public var players       : FlxGroup;		
		public var playerBullets : FlxGroup;
		public var enemyBullets  : FlxGroup;
		public var enemies       : FlxGroup;
		public var fxs           : FlxGroup;
		
		private var inputPlayer1 : InputConfig;
		private var inputPlayer2 : InputConfig;
		
		private var idolCount    : int;
		private var idolDelay    : Number;
		
		public function Mission(player1ShipConfig : ShipConfig) 
		{
			//var shipConfig1 : ShipConfig = new ShipConfig(ShipConfig.SHIP_TYPE_1, "Bumble Bee", 4, 2, 3, 1, 3, 2);
			//var shipConfig2 : ShipConfig = new ShipConfig(ShipConfig.SHIP_TYPE_2, "Ratchet", 3, 0, 2, 2, 2, 1);
			//var shipConfig3 : ShipConfig = new ShipConfig(ShipConfig.SHIP_TYPE_3, "Iron Hide", 2, 1, 0, 4, 0, 0);
			
			inputPlayer1 = new InputConfig("UP", "DOWN", "LEFT", "RIGHT", "Z", "X");
			//inputPlayer1 = new InputConfig("UP", "DOWN", "LEFT", "RIGHT", "COMMA", "PERIOD");
			inputPlayer2 = new InputConfig("W", "S", "A", "D", "V", "SPACE");
			
			players       = new FlxGroup(2);									
			add(players);
			
			playerBullets = new FlxGroup(128);
			add(playerBullets);
			
			enemyBullets  = new FlxGroup(16);
			add(enemyBullets);
			
			enemies       = new FlxGroup(128);
			add(enemies);

			fxs           = new FlxGroup(32);
			add(fxs);
			
			player1 = new Player(this, player1ShipConfig, inputPlayer1);
			
			players.add(player1);
						
			stage = 0;
			
			genEnv(stage);
		}
		
		override public function update() : void
		{
			super.update();
			
			// collision detection (asteroid - player bullets)
			FlxG.overlap(enemies, playerBullets, enemyPlayerBulletCb);
			
			// collision detection (asteroid - players)
			FlxG.overlap(enemies, players, enemyPlayerCb);

			// collision detection (players - enemy bullets)
			FlxG.overlap(enemyBullets, players, enemyBulletsPlayerCb);
			
			// check if the players are dead, and if so, return to main menu
			var gameOver : Boolean = true;
			
			for (var i : int = 0; i < players.length; i++)
			{
				if (players.members[i].alive ||
					players.members[i].exists)
				{
					gameOver = false;
					break;					
				}				     
			}
			
			if (gameOver || FlxG.keys.BACKSPACE)
			{
				FlxG.mouse.show();
				FlxG.switchState(new MenuState());				
			}
			
			// check if the stage is clear (no asteroids are present) and advance the stage
			if (enemies.countLiving() == 0)
			{
				stage++;
				
				genEnv(stage);
				
				FlxG.play(SoundData.SndNewStage, 1.0, false, true);				
			}
			
			// idol generation management
			if (idolCount > 0)
			{
				idolDelay -= FlxG.elapsed;
				
				if (idolDelay <= 0)
				{
					// generate an idol
					var coord : FlxPoint = randomPolarCoord();
					
					var idol : Idol = addIdol(coord.x, coord.y);
					
					idolDelay = FlxExtraU.randomRangeInt(3000, 5000) / 1000;
					idolCount--;
				}
			}
		}
		
		/**
		 * Generates the playing environment (asteroids, idols) depending on
		 * the current stage.
		 */
		private function genEnv(stage : int) : void
		{
			// cap the stage, otherwise there will be too much clutter 
			// and the game will become unplayable (too many asteroids, idols, etc)
			if (stage >= STAGES)
			{
				stage = STAGES;
			}
			
			var asteroidCount : int = 3 + int(Math.floor(stage / 2.0));
			
			for (var i : int = 0; i < asteroidCount; i++)
			{
				// pick the asteroid starting coordinates in polar coordinates
				var coord : FlxPoint = randomPolarCoord();
				
				var asteroid : Asteroid = addAsteroid(
				  0,
				  coord.x,
				  coord.y
				  );
				
				var velocityLength : Number = FlxExtraU.randomRangeInt(30, 70) + stage * 10;			
				
				asteroid.velocity.x = FlxExtraU.randomInt(FlxG.width) - asteroid.x;
				asteroid.velocity.y = FlxExtraU.randomInt(FlxG.height) - asteroid.y;
        
				// asteroid.velocity.normalize();
        FlxExtraU.normalize(asteroid.velocity);
        
				// asteroid.velocity.multScalar(velocityLength);
        FlxExtraU.multScalar(asteroid.velocity, velocityLength);
				
				// add a small angular velocity
				asteroid.angularVelocity = 5 * Math.random();
				
				//enemies.add(asteroid);
			}
			
			// pick the count of idols to generate and also the initial delay
			// every 3 stages we generate one additional idol
			// the idol starts with a small delay and there is also a delay
			// when the next idol appears
			idolCount = 1 + Math.floor(stage / 3);
			idolDelay = FlxExtraU.randomRangeInt(3000, 5000) / 1000.0;
		}
		
		/**
		 * Returns a random coordinate around the play area.
		 * Useful to generate the enemies a bit outside the play area and
		 * distribute them evenly around the player ship.
		 * 
		 * @return the coordinate
		 */
		private function randomPolarCoord() : FlxPoint
		{			
			var randomAngle : Number = 2 * Math.PI * Math.random();
							
			var randomRadius : Number = 
			  1.5 * FlxU.max(FlxG.width / 2, FlxG.height / 2) + 
			  30 + FlxExtraU.randomInt(30);
			  
			//trace(randomRadius);
			  
			return new FlxPoint(
				FlxG.width / 2 + randomRadius * Math.cos(randomAngle), 
				FlxG.height / 2 + randomRadius * Math.sin(randomAngle)
			);
		}
		
		/**
		 * Processes the asteroid - player bullet collision 
		 * 
		 * @param	obj1
		 * @param	obj2
		 */		
		private function enemyPlayerBulletCb(obj1 : FlxBasic, obj2 : FlxBasic) : void
		{
			var bullet : FlxObject;
			var enemy  : Enemy;
			
			// manage the score
			if (obj1 is Bullet)
			{
				bullet = (obj1 as FlxObject);
				enemy  = (obj2 as Enemy);				
			}
			else
			{
				bullet = (obj2 as FlxObject);
				enemy  = (obj1 as Enemy);				
			}
			
			player1.score += enemy.scorePoints();
			
			bullet.hurt(1);
			enemy.hurt(1);			
		}
		
		/**
		 * Processes the enemy - player collision
		 * 
		 * @param	obj1
		 * @param	obj2
		 */
		private function enemyPlayerCb(obj1 : FlxBasic, obj2 : FlxBasic) : void
		{			
			var player : Player;
			var enemy  : Enemy;
			
			// manage the score
			if (obj1 is Player)
			{
				player = obj1 as Player;
				enemy  = obj2 as Enemy;
			}
			else
			{
				player = obj2 as Player;
				enemy  = obj1 as Enemy;
			}
			
			if (!player.invincible)
			{
				player.hurt(1);
				enemy.hurt(1);
				
				player.score += enemy.scorePoints();			
			}
		}
		
		/**
		 * Processes the player vs enemy bullets (spawned by the idol)
		 * 
		 * @param	obj1
		 * @param	obj2
		 */
		private function enemyBulletsPlayerCb(obj1 : FlxBasic, obj2 : FlxBasic) : void
		{			
			var bullet : Bullet;
			var player : Player;
			
			// manage the score
			if (obj1 is Bullet)
			{
				bullet = (obj1 as Bullet);
				player = (obj2 as Player);
			}
			else
			{
				bullet = (obj2 as Bullet);
				player = (obj1 as Player);				
			}
			
			if (!player.invincible)
			{
				bullet.hurt(1);
				player.hurt(1);
			}
		}
		
		public function getClosestPlayer(x : Number, y : Number) : Player
		{
			var minDistance : Number = Number.MAX_VALUE;
			var origin      : FlxPoint = new FlxPoint(x, y);
			var player      : Player = null;
			
			for (var i : int = 0; i < players.length; i++)
			{
				var currentDistance : Number = FlxU.getDistance(
				  new FlxPoint(players.members[i].x, players.members[i].y), 
				  origin); 
				  
				if (currentDistance < minDistance)
				{
					minDistance = currentDistance;
					player = players.members[i];
				}
			}
			
			return player;
		}
		
		public function addBullet(source : FlxSprite, type : String, x : Number, y : Number, ttl : Number = Bullet.DEFAULT_TTL) : Bullet
		{
			var group : FlxGroup = (type == "enemy") ? enemyBullets : playerBullets;
			
			var bullet : Bullet = group.getFirstAvailable(Bullet) as Bullet;
			
			if (bullet == null)
			{
				bullet = new Bullet(this, source, type, x, y, ttl);
				group.add(bullet);
			}
			else
			{			
				bullet.init(source, type, x, y, ttl);
			}
			
			return bullet;
		}
		
		[Embed(source="../data/fx_explode001.png")]
        private var SpriteSheetExplode : Class;
		
		public function addExplosion(x : Number, y : Number) : Fx
		{									
			var fx : Fx = fxs.getFirstAvailable(Fx) as Fx;
			
			if (fx == null)
			{
				fx = new Fx(x, y, -1, 0);
				fxs.add(fx);
			}
			else
			{			
				fx.init(x, y,  -1, 0);
			}
						
			//var fx : Fx = new Fx();
			fx.loadGraphic(SpriteSheetExplode, true, false, 26, 26);
			fx.addAnimation("fx", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 30, false);
			fx.play("fx");
						
			return fx;
		}
		
		/**
		 * Returns the first available fx from the fx pool and configure it
		 * using the params sent.
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function addFx(x : Number, y : Number, lifeSpan : Number, fadeSpeed : Number = 0.0, syncFade : Boolean = false) : Fx
		{
			var fx : Fx = fxs.getFirstAvailable(Fx) as Fx;
			
			if (fx == null)
			{
				fx = new Fx(x, y, lifeSpan, fadeSpeed, syncFade);
				fxs.add(fx);
			}
			else
			{			
				fx.init(x, y, lifeSpan, fadeSpeed, syncFade);
			}
			
			return fx;
		}
		
		public function addAsteroid(level : int, x : Number, y : Number) : Asteroid
		{			
			var asteroid : Asteroid = enemies.getFirstAvailable(Asteroid) as Asteroid;
			
			if (asteroid == null)
			{
				asteroid = new Asteroid(this, level, x, y);
				enemies.add(asteroid);
			}
			else
			{			
				asteroid.init(level, x, y);
			}
			
			return asteroid;
		}
		
		public function addIdol(x : Number, y : Number) : Idol
		{			
			var idol : Idol = enemies.getFirstAvailable(Idol) as Idol;
			
			if (idol == null)
			{
				idol = new Idol(this, x, y);
				enemies.add(idol);
			}
			else
			{			
				idol.init(x, y);
			}
			
			return idol;
		}		
		
		public function addMine(x : Number, y : Number) : Mine
		{			
			var mine : Mine = playerBullets.getFirstAvailable(Mine) as Mine;
			
			if (mine == null)
			{
				mine = new Mine(this, x, y);
				playerBullets.add(mine);
			}
			else
			{			
				mine.init(x, y);
			}
			
			return mine;
		}
	}

}