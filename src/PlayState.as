package
{
	import org.flixel.*;

	public class PlayState extends FlxState
	{
		private var mission        : Mission;
		private var hudPlayer      : FlxText;
		private var hudLives  	   : FlxText;
		private var hudScore       : FlxText;
		private var hudLifeSymbol  : FlxSprite;
		private var hudPowerReload : FlxText;
		
		private var cachedStage   : int;
		private var cachedLives   : int;
		private var cachedScore   : int;
		private var cachedPowerReload : int;
		
		private var player1ShipConfig  : ShipConfig;

		[Embed(source="../data/hud_life_symbol.png")]
        private var SpriteSymbol : Class;		
				
		public function PlayState(player1ShipConfig : ShipConfig)
		{
			this.player1ShipConfig = player1ShipConfig;
		}
		
		override public function create():void
		{			
			// background (star clouds and star field)
			add(new EndlessSpace());

			mission = new Mission(player1ShipConfig);
			add(mission);			
			
			// the HUD parts
			hudPlayer = new FlxText(2, 2, 100, "1P");
			add(hudPlayer);
			
			hudLifeSymbol = new FlxSprite(2, 16, SpriteSymbol);
			add(hudLifeSymbol);
			
			hudLives = new FlxText(20, 16, 100, "00");
			add(hudLives);
			
			hudScore = new FlxText(50, 2, 100, "000000");
			add(hudScore);	
			
			hudPowerReload = new FlxText(120, 2, 100, "0%");
			add(hudPowerReload);
			
			cachedStage = -1;
			cachedLives = -1;
			cachedScore = -1;
			cachedPowerReload = -1;
		}
		
		override public function update():void
		{
			super.update();
			
			/*
			if (mission.stage != cachedStage)
			{
				cachedStage = mission.stage;
				
				hudStage.text = "STAGE: " + (cachedStage + 1);
			}
			*/
			
			if (mission.player1.lives != cachedLives)
			{
				cachedLives = mission.player1.lives;
				
				hudLives.text = "x" + cachedLives;
			}
			
			if (mission.player1.score != cachedScore)
			{
				cachedScore = mission.player1.score;
				
				hudScore.text = "" + formatScore(cachedScore);
			}
			
			var powerReload : int = mission.player1.getPowerReload();
			
			if (cachedPowerReload != powerReload)
			{
				hudPowerReload.text = "" + powerReload + "%";
				
				cachedPowerReload = powerReload;
			}
		}
		
		private function formatScore(score : int) : String
		{
			var asString : String = "" + score;
			
			if (asString.length < 6)
			{
				var leftDigits : int = 6 - asString.length;
				
				for (var i : int = 0; i < leftDigits; i++)
				{
					asString = "0" + asString;
				}
			}
			
			return asString;
		}
	}
}
