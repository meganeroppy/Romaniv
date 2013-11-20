package gameObjects
{
	import flash.display.Sprite;
	
	public class Romaniv extends Sprite
	{
		private var message:String = "Romaniv appeared.";
		public function Romaniv()
		{
				trace(message);
		}
		
		public function hop(x:int):void{
			trace("Romaniv hops" + x.toString() + "times!" );
		}
	}
}