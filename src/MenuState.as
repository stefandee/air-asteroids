package
{
	import flash.display.InteractiveObject;
	import org.flixel.*;

	public class MenuState extends FlxState
	{
		private static const KEY_REPEAT : Number = 0.2;
		
		private var stats     : Object;
		private var shipName  : FlxText;
		private var powerInfo : FlxText;
		private var ships     : Array;
		
		private var _shipIndex : int;
				
		private var btnPrev   : FlxButton;
		private var btnNext   : FlxButton;
		
		[Embed(source="../data/ui_arrow_prev.png")]
        private var SpriteBtnPrev : Class;		
		
		[Embed(source="../data/ui_arrow_next.png")]
        private var SpriteBtnNext : Class;	
		
		private var keyRepeat : Number;
		
		override public function create():void
		{
			ships = [
				new ShipConfig(ShipConfig.SHIP_TYPE_1, "Bumble Bee", 4, 2, 3, 1, 3, 2),
				new ShipConfig(ShipConfig.SHIP_TYPE_2, "Ratchet", 3, 0, 2, 2, 2, 1),
				new ShipConfig(ShipConfig.SHIP_TYPE_3, "Iron Hide", 2, 1, 1, 4, 0, 0)
			];
			
			var t:FlxText;
			t = new FlxText(0,10,FlxG.width,"Select your ship");
			t.size = 24;
			t.alignment = "center";
			add(t);
			t = new FlxText(FlxG.width/2-100,FlxG.height-20,200,"Press SPACE to play!");
			t.alignment = "center";
			add(t);
			
			FlxG.mouse.show();
			
			// the ship name
			shipName = new FlxText(FlxG.width / 2 - 100,FlxG.height / 2 - 32,200,"Ship Name");
			shipName.alignment = "center";
			shipName.size = 16;
			add(shipName);
			
			// the ship stats
			stats = new Object();
			
			var statKeys : Array = ["Speed", "Accel", "Turning", "Reloading", "Power Reload"];
			
			var statY : int = FlxG.height / 2;
			
			for each(var key : String in statKeys)
			{			
				var stat : Stat = new Stat(FlxG.width / 2, statY, key, 0);
				
				stats[key] = stat;
				add(stat);
				
				statY += 16;
			}			
			
			// superpower info
			powerInfo = new FlxText(FlxG.width / 2 - 100, statY + 4, 200, "Power Info");
			powerInfo.alignment = "center";
			powerInfo.size = 8;
			add(powerInfo);			
			
			btnPrev = new FlxButton(FlxG.width / 2 - 100 - 10, FlxG.height / 2 - 32 + 3, null, onPrevClick);
			btnPrev.loadGraphic(SpriteBtnPrev, true, false, 16, 16);
			add(btnPrev);
			
			btnNext = new FlxButton(FlxG.width / 2 + 100 + 10 - 16, FlxG.height / 2 - 32 + 3, null, onNextClick);
			btnNext.loadGraphic(SpriteBtnNext, true, false, 16, 16);
			add(btnNext);
			
			shipIndex = 0;			
			
			keyRepeat = KEY_REPEAT;
		}

		private function set shipIndex(v : int) : void
		{
			if (v < 0) 
			{
				v = 0;
			}
			
			if (v >= ships.length)
			{
				v = ships.length - 1;
			}
			
			shipName.text = ships[v].name;
			
			stats["Speed"].initValue(ships[v].maxSpeed);
			stats["Accel"].initValue(ships[v].accel);
			stats["Turning"].initValue(ships[v].turning);
			//stats["Fire Power"].initValue(ships[v].firePower);
			stats["Reloading"].initValue(ships[v].fireReload);
			stats["Power Reload"].initValue(ships[v].powerReload);

			powerInfo.text = ships[v].powerInfo;
			
			_shipIndex = v;
		}
		
		private function get shipIndex() : int
		{
			return _shipIndex;
		}
		
		override public function update():void
		{
			super.update();

			if(FlxG.keys.SPACE)
			{
				FlxG.mouse.hide();
				FlxG.switchState(new PlayState(ships[shipIndex]));
			}
						
			// TODO: shouldn't flixel have something like this?
			if (keyRepeat >= 0)
			{
				keyRepeat -= FlxG.elapsed;				
			}
			
			if (FlxG.keys.LEFT && keyRepeat <= 0)
			{
				onPrevClick();
				keyRepeat = KEY_REPEAT;				
			}
			
			if (FlxG.keys.RIGHT && keyRepeat <= 0)
			{
				onNextClick();				
				keyRepeat = KEY_REPEAT;				
			}			
		}
		
		private function onPrevClick() : void
		{
			var newValue : int = shipIndex - 1;
			
			if (newValue < 0)
			{
				newValue = ships.length - 1;
			}
			
			shipIndex = newValue;
		}
		
		private function onNextClick() : void
		{
			shipIndex = (shipIndex + 1) % ships.length;
		}		
	}
}
