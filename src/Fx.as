package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	
	/**
	 * Fx that is able to:
		 * finish when its animation finished
		 * finish when it faded out completely
		 * able to sync between fade and lifeSpan
	 * 
	 * @author Stefan Dicu
	 */
	public class Fx extends FlxSprite 
	{
		// positive value, in ms; passing -1 will make this Fx last forever
		private var lifeSpan               : Number;
		private var fadeSpeed              : Number;
		private var syncFade               : Boolean;
		private var maxLifeSpan            : Number;
		
		public function Fx(x : Number, y : Number, lifeSpan : Number, fadeSpeed : Number = 0.0, syncFade : Boolean = false)
		{
			super(x, y);
			
			this.lifeSpan    = lifeSpan;
			this.maxLifeSpan = lifeSpan;
			this.fadeSpeed   = fadeSpeed;
			this.syncFade    = syncFade;
		}		
		
		override public function update() : void
		{
			super.update();
			
			if (finished)
			{
				kill();
			}
			
			if (syncFade)
			{
				if (maxLifeSpan > 0)
				{
					this.alpha = lifeSpan / maxLifeSpan;
				}
			}
			else
			{
				alpha += fadeSpeed;
			}
						
			if (lifeSpan >= 0)
			{			
				lifeSpan -= FlxG.elapsed;
				
				if (lifeSpan <= 0)
				{
					kill();
				}
			}
		}
		
		public function init(x : Number, y : Number, lifeSpan : Number, fadeSpeed : Number = 0.0, syncFade : Boolean = false) : void
		{			
			this.lifeSpan    = lifeSpan;
			this.maxLifeSpan = lifeSpan;
			this.fadeSpeed   = fadeSpeed;
			this.syncFade    = syncFade;
			
			reset(x, y);
		}
	}

}