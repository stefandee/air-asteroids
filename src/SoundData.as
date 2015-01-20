package  
{
	/**
	 * Data class for sound embeds.
	 * 
	 * @author Stefan Dicu
	 */
	public class SoundData 
	{
		[Embed(source="../data/sfx/explosion.mp3")]
		public static var SndExplosion : Class;
			
		[Embed(source="../data/sfx/explosion2.mp3")]
		public static var SndExplosion2 : Class;
			
		[Embed(source="../data/sfx/player_fire.mp3")]
		public static var SndPlayerFire : Class;
			
		[Embed(source="../data/sfx/player_hurt.mp3")]
		public static var SndPlayerHurt : Class;

		[Embed(source="../data/sfx/player_power.mp3")]
		public static var SndPlayerPower : Class;
			
		[Embed(source="../data/sfx/idol_fire.mp3")]
		public static var SndIdolFire : Class;

		[Embed(source="../data/sfx/newstage.mp3")]
		public static var SndNewStage : Class;
		
		public function SoundData() 
		{
		}
		
	}

}