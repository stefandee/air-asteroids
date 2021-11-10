package
{
	import flash.media.Camera;
	import org.flixel.*;

	public class Player extends FlxSprite
	{		
		//static public const ROTATION_VEL : Number = 1.0;
		//static public const DRAG_FACTOR  : Number = -10.0;
		static public const BULLET_TTL       : Number = 2000;
		static public const LIVES            : int    = 5;
		static public const INVINCIBLE_DELAY : int    = 2000;
		
		public var lives         	: int;
		public var score         	: int;
		public var invincible      	: Boolean;
				
		[Embed(source="../data/player_ship1.png")]
        private var SpriteSheet1 : Class;

		[Embed(source="../data/player_ship2.png")]
        private var SpriteSheet2 : Class;

		[Embed(source="../data/player_ship3.png")]
        private var SpriteSheet3 : Class;

		[Embed(source="../data/fx_teleport.png")]
        private var SpriteSheetTeleport : Class;
		
		private var config      	: ShipConfig;
		
		// max speed, accel, inertia, turning, firepower (actual values)
		// the ShipConfig contains indices in these arrays
		private var maxSpeed    	: Array;
		private var accels      	: Array;
		private var turning     	: Array;
		private var firePower   	: Array;	
		private var fireReload  	: Array;	
		private var powerReload     : Array;	
		
		private var inputConfig     : InputConfig;
		
		private var mission         : Mission;
		
		// reload time stamps for of the main weapon and for the super power
		private var reloadDelay     : Number;		
		private var powerDelay      : Number;

		private var invincibleDelay : Number;
		
		private var sndFire         : FlxSound;
		private var sndHurt         : FlxSound;
		private var sndPower        : FlxSound;
		
		public function Player(mission : Mission, shipConfig : ShipConfig, inputConfig : InputConfig) : void
		{
			this.mission = mission;
			
			super(FlxG.width / 2, FlxG.height / 2);
			
			// on a data driven app, these values belong in a xml
			// but this is not a data driven app :)
			maxSpeed    = [100, 125, 150, 200];
			accels      = [2, 3, 4, 5];
			turning     = [1, 1.5, 2, 2.5];
			firePower   = [10, 20, 30, 40];
			
			// values in miliseconds
			fireReload  = [450, 400, 350, 300];
			
			// values in miliseconds
			powerReload = [10000, 8000, 6000, 5000];
						
			configureShip(shipConfig);
			
			this.inputConfig = inputConfig;
			
			reloadDelay = fireReload[config.fireReload];
			powerDelay  = powerReload[config.powerReload];
			
			lives = LIVES;
			score = 0;
			
			invincible = false;
			
			sndFire  = FlxG.loadSound(SoundData.SndPlayerFire, 1.0, false, false);
			sndHurt  = FlxG.loadSound(SoundData.SndPlayerHurt, 1.0, false, false);
			sndPower = FlxG.loadSound(SoundData.SndPlayerPower, 1.0, false, false);
		}
		
		override public function update() : void
		{
			if (invincible)
			{
				invincibleDelay -= (FlxG.elapsed * 1000);
				
				if (invincibleDelay <= 0)
				{
					invincible = false;
				}
			}
			
			handleInput();
			
			// if (acceleration.length() > 0)
			if (FlxExtraU.length(acceleration) > 0)
			{
				//drag.copyFrom(acceleration);
				//drag.normalize();
				//drag.multScalar(-1.0);
				//drag.multScalar(-DRAG_FACTOR);
				//velocity.x *= 0.9;
				//velocity.y *= 0.9;
			}
			
			velocity.x *= 0.999;
			velocity.y *= 0.999;
			
			// I believe the original asteroids mirrored the movement when out of screen
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
			
			super.update();
		}		
		
		private function applyAccel(newValue : Number) : void
		{
			velocity.x = newValue * Math.cos((angle - 90) * Math.PI / 180.0);
			velocity.y = newValue * Math.sin((angle - 90) * Math.PI / 180.0);			
		}	
		
		private function factorAccel(factor : Number) : void
		{
			// var velLength : Number = velocity.length();
			// var velLength : Number = FlxExtraU.length(velocity);
			
			velocity.x += (factor) * Math.cos((angle - 90) * Math.PI / 180.0);
			velocity.y += (factor) * Math.sin((angle - 90) * Math.PI / 180.0);			
		}			
				
		public function configureShip(config : ShipConfig) : void
		{						
			this.config = config;
			
			switch(config.type)
			{
				case ShipConfig.SHIP_TYPE_1:
				{
					loadGraphic(SpriteSheet1, true, false, 32, 36);	
					break;
				}
					
				case ShipConfig.SHIP_TYPE_2:
				{
					loadGraphic(SpriteSheet2, true, false, 32, 32);												
					break;
				}
					
				case ShipConfig.SHIP_TYPE_3:
				{
					loadGraphic(SpriteSheet3, true, false, 32, 40);
					break;
				}
			}
			
			// all ship sheets have the same layout
			addAnimation("idle", [1], 0, true);
			addAnimation("run", [0], 0, true);
			
			play("idle");
						
			maxVelocity = new FlxPoint(maxSpeed[config.maxSpeed], maxSpeed[config.maxSpeed]);
			
			x = FlxG.width / 2;
			y = FlxG.height / 2;
			
			trace(fireReload[config.fireReload]);
		}
		
		private function handleInput() : void
		{
			if(FlxG.keys.pressed(inputConfig.left))
			{
				angle -= turning[config.turning];				
			}
			else if(FlxG.keys.pressed(inputConfig.right))
			{
				angle += turning[config.turning];
			}

			if(FlxG.keys.pressed(inputConfig.up))
			{
				factorAccel(accels[config.accel]);
				
				play("run");
			}
			else if(FlxG.keys.pressed(inputConfig.down))
			{
				factorAccel(-accels[config.accel]);
					
				play("run");
			}
			else
			{
				play("idle");
			}

			reloadDelay -= FlxG.elapsed * 1000;
				
			// fire the main weapon?
			if (FlxG.keys.pressed(inputConfig.fire) &&
				reloadDelay <= 0)
			{
				// spawn the bullet in the middle of the ship anim frame
				// it's not very correct, but since I only have basic sprite 
				// support...it has to do it
				var bullet : Bullet = mission.addBullet(
				  this,
				  "player", 
				  x + origin.x,//x + this.frameWidth / 2, 
				  y + origin.y,//y + this.frameHeight / 2, 
				  BULLET_TTL);
										
				bullet.velocity.x = 200 * Math.cos((angle - 90) * Math.PI / 180.0);
				bullet.velocity.y = 200 * Math.sin((angle - 90) * Math.PI / 180.0);			
					
				mission.playerBullets.add(bullet);
					
				reloadDelay = fireReload[config.fireReload];
				
				sndFire.play();
			}
				
			powerDelay -= FlxG.elapsed * 1000;
				
			if (FlxG.keys.pressed(inputConfig.superPower) &&
				powerDelay <= 0)
			{
				usePower();
				powerDelay = powerReload[config.powerReload];
				
				sndPower.play();
			}
		}
		
		private function addTeleportFx(x : Number, y : Number) : Fx
		{
			var fx : Fx = mission.addFx(x, y, -1, 0);
			
			fx.loadGraphic(SpriteSheetTeleport, true, false, 50, 50);
			fx.addAnimation("fx", [0, 1, 2, 1, 0, 1, 2, 1, 0, 1, 2, 1, 0], 120, false);
			fx.play("fx");
			
			return fx;
		}
		
		private function usePower() : void
		{
			switch(config.type)
			{
				case ShipConfig.SHIP_TYPE_1:
				{
					// random teleport
					
					// add the fx before
					addTeleportFx(x, y);					
					
					this.x = FlxExtraU.randomInt(FlxG.width);
					this.y = FlxExtraU.randomInt(FlxG.height);
					
					// add the fx after
					addTeleportFx(x, y);	
					
					break;
				}
				
				case ShipConfig.SHIP_TYPE_2:
				{
					// lay a mine
					var mine : Mine = mission.addMine(x, y);
					
					break;
				}
				
				case ShipConfig.SHIP_TYPE_3:
				{
					// fire the bullet storm
					var bulletAngle : Number = 0;
					var bulletAngleDelta : Number = 2 * Math.PI / 8;
					
					for (var i : int = 0; i < 8; i++)
					{
						var bullet : Bullet = mission.addBullet(this, "player", x + origin.x, y + origin.y, BULLET_TTL);
						
						bullet.velocity.x = 150 * Math.cos(bulletAngle);
						bullet.velocity.y = 150 * Math.sin(bulletAngle);			
						
						bulletAngle += bulletAngleDelta;
					}
					
					break;
				}
			}
		}
		
		override public function hurt(Damage:Number):void
		{						
			// cant touch this! :)
			if (invincible)
			{
				return;
			}
			
			sndHurt.play();
			
			lives--;
			
			// make the player flash/invicible for a bit, until he realizes
			// what hit him :)
			invincible = true;
			invincibleDelay = INVINCIBLE_DELAY;
			flicker(INVINCIBLE_DELAY / 1000.0);
			
			if (lives == 0)
			{
				mission.addExplosion(x, y);
				
				kill();
			}
		}
		
		public function getPowerReload() : int
		{
			var tmp : Number = powerDelay;
			
			if (tmp < 0)
			{
				tmp = 0;
			}
			
			return int(100 - 100 * tmp / powerReload[config.powerReload]);
		}
	}	
}