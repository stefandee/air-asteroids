package
{
	import org.flixel.*;
	import flash.display.StageScaleMode;
	
	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Asteroids extends FlxGame
	{
		public function Asteroids()
		{
			super(640, 480, MenuState, StageScaleMode.SHOW_ALL, 1);
		}
	}
}
