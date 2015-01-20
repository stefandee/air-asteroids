package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	import org.flixel.FlxG;
	
	/**
	 * Detonates at impact. Damages everything in a set radius.
	 * 
	 * TODO: maybe bend the enemy bullets trajectories too?
	 * 
	 * @author Stefan Dicu
	 */
	public class Mine extends FlxSprite 
	{
		public static const BLAST_RADIUS : int = 100;
		
		[Embed(source="../data/mine.png")]
        private var SpriteSheet : Class;
		
		private var mission : Mission;
		
		public function Mine(mission : Mission, x : Number, y : Number) 
		{
			this.mission = mission;
			
			super(x, y);
			
			loadGraphic(SpriteSheet, true, false, 22, 22);
			addAnimation("idle", [0, 1, 2, 3, 4, 5], 60, true);
			
			play("idle");
		}
		
		public function init(x : Number, y : Number) : void
		{
			reset(x, y);
		}		
		
		override public function hurt(Damage:Number):void
		{
			if (!exists || !active)
			{
				return;
			}
			
			// damage everything inside a radius
			var basePos : FlxPoint = new FlxPoint(x, y);
			
			// destroying asteroids this way will create other asteroids in the
			// enemies group
			// I don't want to hurt them too 
			var toHurt : Array = new Array;
			
			for (var i : int = 0; i < mission.enemies.length; i++)
			{
				var enemyPos : FlxPoint = new FlxPoint(
				  mission.enemies.members[i].x,
				  mission.enemies.members[i].y);
				
				if (FlxU.getDistance(basePos, enemyPos) <= BLAST_RADIUS &&
					mission.enemies.members[i].exists &&
					mission.enemies.members[i].active)
				{
					//mission.enemies.members[i].hurt(1);
					toHurt.push(mission.enemies.members[i]);
				}
			}
			
			trace("will hurt: " + toHurt.length);
			
			for each(var enemy : Enemy in toHurt)
			{
				enemy.hurt(1);
			}
			
			// add an explosion fx
			mission.addExplosion(x, y);
			
			FlxG.play(SoundData.SndExplosion, 1.0, false, true);
			
			kill();
		}		
	}

}