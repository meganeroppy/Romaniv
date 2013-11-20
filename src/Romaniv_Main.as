package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import GameScenes.Run;
	import GameScenes.Menu;
	
	//	import gameObjects.Romaniv;
	
	public class Romaniv_Main extends Sprite
	{
		//system////
		private const SCENE:Object = {MENU:0, RUN:1, OPTION:2};
		private static var current_scene:int;
		private var h:int;	//screenheight 
		private var w:int;	//screenWidth 
		private var margin:int;	//Value between a button and edges
		
		//scenes
		private var run:Run;
		private var menu:Menu;		
		
		//logo

		public function Romaniv_Main()
		{
			super();
			current_scene = SCENE.MENU;
			
			// autoOrients をサポート
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init()
		}
		
		private function init():void{
			
			//about system
			h = stage.fullScreenHeight;
			w = stage.fullScreenWidth;
			margin = h * 0.01;
			
			run = new Run(w, h, stage);
			menu = new Menu(w, h, stage);

			menu.load();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void{
			switch(current_scene){
				case SCENE.MENU:
					if(!menu.update()){
						switchScene(SCENE.RUN);
						run.load();
						stage.addChild(run);
						stage.removeChild(menu);
					}					
					break;
				case SCENE.RUN:
					if(!run.update()){
						switchScene(SCENE.MENU);
						menu.load();
						stage.addChild(menu);
						stage.removeChild(run);
					}	
					break;
				case SCENE.RESULT:
					break;
				default:
					break;
			}
		}
		private function switchScene(next_scene):void{
			current_scene = next_scene;
		}
	}
}