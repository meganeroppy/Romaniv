package GameScenes
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import Romaniv_Main;
	
	//	import gameObjects.Romaniv;
	
	public class Menu extends Sprite
	{
		//system////
		private var Obj:DisplayObject;
		private var h:int;	//screenheight 
		private var w:int;	//screenWidth 
		private var margin:int;	//Value between a button and edges
		private var urlReq:URLRequest;
		

		//images////	
		
		//logo
		private var title_logo:Loader = new Loader();

		
		//buttons
		private var button_run:Loader = new Loader();
		private var button_record:Loader = new Loader();
		private var button_tweet:Loader = new Loader();
		private var button_postFB:Loader = new Loader();
		private var button_option:Loader = new Loader();
		private var button_sounds:Loader = new Loader();
		private const LOGO_POS_Y:int = 50;
		private const RUN_BUTTON_POS_Y:int = 150;
		private const BUTTONS_POS_Y:int = 300;

		private const BUTTON_SCALE_RATE:Number = 0.17;
		
		//sounds
		
		public function Menu(w:int, h:int, Obj:DisplayObject)
		{
//			super();
			// autoOrients をサポート
			this.Obj = Obj;
			this.w = w;
			this.h = h;

			init();
		}
		
		public function load():void{
			
		}
		
		private function init():void{
			trace("Menu.init()");

			//about system
//			h = stage.fullScreenHeight;
//			w = stage.fullScreenWidth;
//			margin = stage.fullScreenHeight * 0.01;
			

			//about visuals////
			
			//title_logo
			urlReq = new URLRequest("images/title_logo.png");
			title_logo.load(urlReq);
			title_logo.x = 100;
			title_logo.y = LOGO_POS_Y;;			
					
			
			//run button
			urlReq = new URLRequest("images/button_run.png");
			button_run.load(urlReq);
			button_run.x = 120;
			button_run.y = RUN_BUTTON_POS_Y;	
			
			//record button
			urlReq = new URLRequest("images/button_record.png");
			button_record.load(urlReq);
			button_record.x = 120;
			button_record.y = BUTTONS_POS_Y;
//			button_record.scaleX = 1.2;
			
			//tweet button
			urlReq = new URLRequest("images/button_tweet.png");
			button_tweet.load(urlReq);
			button_tweet.x = 220;
			button_tweet.y = BUTTONS_POS_Y;	
			
			//postFB button
			urlReq = new URLRequest("images/button_postFB.png");
			button_postFB.load(urlReq);
			button_postFB.x = 320;
			button_postFB.y = BUTTONS_POS_Y;	
			
			//option button
			urlReq = new URLRequest("images/button_option.png");
			button_option.load(urlReq);
			button_option.x = 420;
			button_option.y = BUTTONS_POS_Y;	
			
			//sounds button
			urlReq = new URLRequest("images/button_sounds.png");
			button_sounds.load(urlReq);
			button_sounds.x = 520;
			button_sounds.y = BUTTONS_POS_Y;	
			
		}
		
		public function update():void{			//add children and eventlisteners
			Obj.stage.addChild(title_logo);
			Obj.stage.addChild(button_run);
			Obj.stage.addChild(button_record);
			Obj.stage.addChild(button_tweet);
			Obj.stage.addChild(button_postFB);
			Obj.stage.addChild(button_option);
			Obj.stage.addChild(button_sounds);
			
			button_run.addEventListener(MouseEvent.CLICK, gameStart);
			button_record.addEventListener(MouseEvent.CLICK, showRecord);
			button_tweet.addEventListener(MouseEvent.CLICK, tweet);
			button_postFB.addEventListener(MouseEvent.CLICK, postFB);
			button_option.addEventListener(MouseEvent.CLICK, optionMenu);
			button_sounds.addEventListener(MouseEvent.CLICK, soundsMenu);
		}
		
		private function gameStart(e:Event):Boolean{
			trace("gameStart()");
			return true;
		}

		private function showRecord(e:Event):void{
			trace("showRecord()");

		}
		
		private function tweet(e:Event):void{
			trace("tweet()");

		}
		
		private function postFB(e:Event):void{
			trace("postFB()");

		}
		
		private function optionMenu(e:Event):void{
			trace("optionMenu()");

		}
		
		private function soundsMenu(e:Event):void{
			trace("soundMenu()");

		}
	}
}