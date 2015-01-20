package  
{
	import flash.display.InteractiveObject;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	
	/**
	 * Displays a label and value for a ship stat.
	 * 
	 * @author Stefan Dicu
	 */
	public class Stat extends FlxGroup
	{
		private var label   : FlxText;
		private var bubbles : FlxGroup;
		
		[Embed(source="../data/ui_stat_bubble.png")]
        private var SpriteSheet : Class;		
		
		public function Stat(x : Number, y : Number, labelText : String, value : int) 
		{			
			super();
						
			label = new FlxText(x - 210, y, 200, labelText);
			label.size = 8;
			label.alignment = "right";
			add(label);
			
			bubbles = new FlxGroup(5);
			
			for (var i : int = 0; i < 5; i++)
			{
				var bubble : FlxSprite = new FlxSprite(x + i * 13, y, SpriteSheet);
				bubbles.add(bubble);
			}

			add(bubbles);
			
			init(labelText, value);
		}
		
		public function init(labelText : String, value : int) : void
		{
			label.text = labelText;
			initValue(value);			
		}
		
		public function initValue(value : int) : void
		{
			for (var i : int = 0; i < 5; i++)
			{
				bubbles.members[i].visible = (i <= value);
			}			
		}
		
	}

}