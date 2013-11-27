package GameScenes
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
//	import Romaniv_Main;
	
	//	import gameObjects.Romaniv;
	
	public class Menu extends Sprite
	{
		//system////
		private var Obj:DisplayObject;
		private var h:int;	//screenheight 
		private var w:int;	//screenWidth 
		private var margin:int;	//Value between a btn and edges
		private var urlReq:URLRequest;
		private var readyToRun:Boolean = false;
		private var itemIsAdded:Boolean = false;
		

		//images////	
		
		//logo
		private var title_logo:Loader = new Loader();

		
		//btns
		private var btn_run:Loader = new Loader();
		private var btn_record:Loader = new Loader();
		private var btn_tweet:Loader = new Loader();
		private var btn_postFB:Loader = new Loader();
		private var btn_option:Loader = new Loader();
		private var btn_sounds:Loader = new Loader();
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
			//about system

			//about visuals////
			
			//title_logo
			urlReq = new URLRequest("images/title_logo.png");
			title_logo.load(urlReq);
			title_logo.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				title_logo.width = w * 0.7;
			});
			title_logo.x = w * 0.15;
			title_logo.y = LOGO_POS_Y;		
					
			
			//run btn
			urlReq = new URLRequest("images/btn_run.png");
			btn_run.load(urlReq);
			btn_run.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_run.width = w * 0.7;
				btn_run.height = h * 0.25;

			});
			btn_run.x = w * 0.15;
			btn_run.y = RUN_BUTTON_POS_Y;	
			
			//record btn
			urlReq = new URLRequest("images/btn_rnk.png");
			btn_record.load(urlReq);
			btn_record.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_record.width = w * 0.12;
				btn_record.height = h * 0.2;

			});
			btn_record.x = w * 0.15;
			btn_record.y = BUTTONS_POS_Y;
//			btn_record.scaleX = 1.2;
			
			//tweet btn
			urlReq = new URLRequest("images/btn_tw.png");
			btn_tweet.load(urlReq);
			btn_tweet.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_tweet.width = w * 0.12;
				btn_tweet.height = h * 0.2;
			});
			btn_tweet.x = w * 0.30;
			btn_tweet.y = BUTTONS_POS_Y;	
			
			//postFB btn
			urlReq = new URLRequest("images/btn_fb.png");
			btn_postFB.load(urlReq);
			btn_postFB.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_postFB.width = w * 0.12;
				btn_postFB.height = h * 0.2;

			});
			btn_postFB.x = w * 0.45;
			btn_postFB.y = BUTTONS_POS_Y;	
			
			//option btn
			urlReq = new URLRequest("images/btn_opt.png");
			btn_option.load(urlReq);
			btn_option.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_option.width = w * 0.12;
				btn_option.height = h * 0.2;

			});
			btn_option.x = w * 0.6;

			btn_option.y = BUTTONS_POS_Y;	
			
			//sounds btn
			urlReq = new URLRequest("images/btn_snd.png");
			btn_sounds.load(urlReq);
			btn_sounds.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_sounds.width = w * 0.12;
				btn_sounds.height = h * 0.2;

			});
			btn_sounds.x = w * 0.75;
			btn_sounds.y = BUTTONS_POS_Y;	
			
		}
		
		
		public function update():Boolean{			//add children and eventlisteners
			
			if(!itemIsAdded){
				Obj.stage.addChild(title_logo);
				Obj.stage.addChild(btn_run);
				Obj.stage.addChild(btn_record);
				Obj.stage.addChild(btn_tweet);
				Obj.stage.addChild(btn_postFB);
				Obj.stage.addChild(btn_option);
				Obj.stage.addChild(btn_sounds);
				
				btn_run.addEventListener(MouseEvent.CLICK, gameStart);
				btn_record.addEventListener(MouseEvent.CLICK, showRecord);
				btn_tweet.addEventListener(MouseEvent.CLICK, tweet);
				btn_postFB.addEventListener(MouseEvent.CLICK, postFB);
				btn_option.addEventListener(MouseEvent.CLICK, optionMenu);
				btn_sounds.addEventListener(MouseEvent.CLICK, soundsMenu);
				
				itemIsAdded = true;
			}
			
			if(readyToRun){
				Obj.stage.removeChild(title_logo);
				Obj.stage.removeChild(btn_run);
				Obj.stage.removeChild(btn_record);
				Obj.stage.removeChild(btn_tweet);
				Obj.stage.removeChild(btn_postFB);
				Obj.stage.removeChild(btn_option);
				Obj.stage.removeChild(btn_sounds);
				readyToRun = false;
				itemIsAdded = false;
				return false;
			}
				return true;
		}
	
		private function gameStart(e:Event):void{
			trace("gameStart()");
			readyToRun = true;
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