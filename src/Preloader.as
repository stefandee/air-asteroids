package
{
	import org.flixel.system.FlxPreloader;
	import flash.display.StageScaleMode;

	public class Preloader extends FlxPreloader
	{
		public function Preloader()
		{
			className = "Asteroids";
			super(StageScaleMode.NO_SCALE);
		}
	}
}
