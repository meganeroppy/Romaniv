package GameScenes
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import Romaniv_Main;
	
	//	import gameObjects.Romaniv;
	
	public class Run extends Sprite
	{
		//system////
		private var Obj:DisplayObject;
		private var h:int;	//screenheight 
		private var w:int;	//screenWidth 
		private var margin:int;	//Value between a button and edges
		private var tmpTime:Number;
		private var urlReq:URLRequest;
		static private var itemIsAdded:Boolean = false;
		
		//controls////
		private var isGameOver:Boolean = false;
		private var collected_hair:int = 0;
		private var advance:Number = 0.0;
		
		//images////
		
		//GUI
		private var collected_hair_text_field:TextField = new TextField();
		private var collected_hair_text:String;
		
		private var advance_text_field:TextField = new TextField();
		private var advance_text:String;
		
		//ground
		private var ground:Sprite = new Sprite();
		
		//Romaniv
		private var romaniv:Sprite = new Sprite();
		private var run_pic:Loader = new Loader();
		private var slap_pic:Loader = new Loader();
		private var jump_pic:Loader = new Loader();
		private var exp_pic:Loader = new Loader();
		private var father_pic:Loader = new Loader();
		private var current_pic:Loader = new Loader();
		private const STATUS:Object = {RUN:0, JUMP:1, SLAP:2, DEAD:3, FATHER:4, IDLE:5};
		private var current_status:int;
		private var onGround:Boolean = true;
		private const GRAVITY:int = 1;
		private const JUMP_SPEED_BASE:int = -10;
		private var jump_speed:int;
		private var defaultPosY:int;
		private const SLAP_DURATION:Number = 0.3;
		private const EXPLODE_DURATION:Number = 1.8;
		private var attack_area:Sprite = new Sprite();
		
		//hairs
		private var hair:Loader = new Loader();
		private var hairs:Array = new Array(3);
		
		private const HAIR_SPEED_BASE:Number = 9.0;
		private const HAIR_SPEED_INCREASE_RATE:Number = 1.1;
		private var hair_speed_rate:Number = 1.0;
		private var numOfHair:int = 0;
		
		
		//buttons
		private var button_slap:Loader = new Loader();
		private var button_jump:Loader = new Loader();
		
		private const BUTTON_SCALE_RATE:Number = 0.17;
		
		
		//sounds
		
		public function load():void{
			
		}
		
		public function Run(w:int, h:int, Obj:DisplayObject)
		{
//			super();
			
			// autoOrients をサポート
			this.Obj = Obj;
			this.w = w;
			this.h = h;
			
			init()
			trace("MainGame.init()");
		}
		
		private function init():void{
			
			//about system
//			h = stage.fullScreenHeight;
//			w = stage.fullScreenWidth;
//			this.h = h;
//			this.w = w;
//			margin = h * 0.01;
			tmpTime = getTimer();
			
			//about GUI (include buttons)////
			
			//slap button
			urlReq = new URLRequest("images/button_slap.png");
			button_slap.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteJump);
			button_slap.load(urlReq);
			button_slap.x = margin;
			button_slap.y = margin;			
			
			//jump button
			urlReq = new URLRequest("images/button_jump.png");
			button_jump.load(urlReq);
			
			button_jump.x = (w -(w * BUTTON_SCALE_RATE) ) - margin;
			button_jump.y = margin;
			
			//Collected hairs
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			collected_hair_text_field.x = w * 0.3;
			
			//Advanced meter
			advance_text_field.text = advance.toString() + "CM";
			advance_text_field.x = w * 0.6;
			
			//about Romaniv////
			urlReq = new URLRequest("images/Romaniv_run.png");
			run_pic.load(urlReq);
			urlReq = new URLRequest("images/Romaniv_jump.png");
			jump_pic.load(urlReq);
			urlReq = new URLRequest("images/Romaniv_slap.png");
			slap_pic.load(urlReq);
			urlReq = new URLRequest("images/explosion.png");
			exp_pic.load(urlReq);
			urlReq = new URLRequest("images/father.png");
			father_pic.load(urlReq);
			romaniv.x = w * 0.08;
			defaultPosY = h * 0.5;
			romaniv.y = defaultPosY;
			current_status = STATUS.RUN;
			jump_speed = JUMP_SPEED_BASE;
			current_pic = run_pic;
			romaniv.addChild(current_pic);
			
			
			//ground
			ground.graphics.beginFill(0x000000, 1.0);
			ground.graphics.drawRect(0, 0, w, 5);
			ground.graphics.endFill();
			ground.y = romaniv.y + 128;
			
			//hairs	
			urlReq = new URLRequest("images/hair.png");
			hair.load(urlReq);
			

		}
		
		public function update():void{						//add children and eventlisteners
			if(itemIsAdded){
				Obj.stage.addChild(button_slap);
				Obj.stage.addChild(button_jump);
				Obj.stage.addChild(collected_hair_text_field);
				Obj.stage.addChild(advance_text_field);
				Obj.stage.addChild(ground);
				Obj.stage.addChild(romaniv);
				
				Obj.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				button_slap.addEventListener(MouseEvent.CLICK, slap);
				button_jump.addEventListener(MouseEvent.CLICK, jump);
				itemIsAdded = true;
			}
		}
		
		private function onEnterFrame(e:Event):void{
						
			//			trace("OnEnterFrame is woking now.  current_status :" + current_status.toString() );
			
			//			trace( (Math.floor(getTimer() / 100) / 10));
			//hairs
			if(!isGameOver){
				if((Math.floor(getTimer() / 100) / 10) % 1 == 0 && !numOfHair){
					makeHair();
				}else if(numOfHair){
					hair.x -= HAIR_SPEED_BASE * hair_speed_rate;
					if(hair.x < romaniv.x + ( romaniv.width * 0.7) && hair.x > romaniv.x  && current_status != STATUS.JUMP){
						trace(romaniv.x);
						trace(romaniv.width);
						tmpTime = getTimer();
						current_status = STATUS.DEAD;
						romaniv.addChild(exp_pic);
						romaniv.removeChild(current_pic);
						current_pic = exp_pic;
						
						if(numOfHair){
							Obj.stage.removeChild(hair);
							numOfHair -= 1;
						}
					}					
					if(hair.x <= 0 && numOfHair){
						Obj.stage.removeChild(hair);
						numOfHair -= 1;
					}
				}
			}
			
			//Romaniv////
			if(!isGameOver){
				advance += 0.05;
				advance_text_field.text = Math.floor(advance).toString() + "CM";
			}
			switch(current_status){
				case STATUS.RUN:
					break;
				
				case STATUS.JUMP:
					romaniv.y += jump_speed;
					jump_speed += GRAVITY;
					if(romaniv.y >= defaultPosY){
						romaniv.y = defaultPosY;
						jump_speed = JUMP_SPEED_BASE;
						onGround = true;
						current_status = STATUS.RUN;
						romaniv.addChild(run_pic);
						romaniv.removeChild(current_pic);
						current_pic = run_pic;
					}
					break;
				
				case STATUS.SLAP:
					if((Math.floor(getTimer() / 100) / 10) - tmpTime >= SLAP_DURATION ){
						current_status = STATUS.RUN;
						romaniv.addChild(run_pic);
						romaniv.removeChild(current_pic);
						current_pic = run_pic;
						
						Obj.stage.removeChild(attack_area);
					}
					break;
				case STATUS.DEAD:
					if(!isGameOver){
						gameOver();
					}
					
					if((Math.floor(getTimer() / 100) / 10) - tmpTime >= EXPLODE_DURATION ){
						current_status = STATUS.FATHER;
						romaniv.addChild(father_pic);
						romaniv.removeChild(current_pic);
						current_pic = father_pic;
					}					
					break;
				case STATUS.FATHER:
					Obj.stage.addEventListener(MouseEvent.CLICK, reset);
					break;
				
				default:
					break;
			}
		}
		
		private function jump(e:MouseEvent):void{
			if(onGround){
				current_status = STATUS.JUMP;
				romaniv.addChild(jump_pic);
				romaniv.removeChild(current_pic);
				current_pic = jump_pic;
				onGround = false;
			}
		}
		
		
		private function slap(e:MouseEvent):void{
			if(current_status == STATUS.RUN){
				attack_area.graphics.beginFill(0xFF0000, 0.0);
				attack_area.graphics.drawRect(0, 0, 45, 128);
				attack_area.graphics.endFill();
				Obj.stage.addChild(attack_area);
				attack_area.x = romaniv.x + 90;
				attack_area.y = romaniv.y
				current_status = STATUS.SLAP;
				
				romaniv.addChild(slap_pic);
				romaniv.removeChild(current_pic);
				current_pic = slap_pic;
				tmpTime = (Math.floor(getTimer() / 100) / 10);
				
				if(attack_area.hitTestObject(hair)){
					hair_speed_rate *= HAIR_SPEED_INCREASE_RATE;
					kill(hair);
				}
			}
		}
		
		private function kill(obj:Loader):void{
			Obj.stage.removeChild(obj);
			collected_hair++;
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			numOfHair -= 1;
		}
		
		private function gameOver():void{
			trace("GAMEOVER");
			isGameOver = true;
			button_jump.removeEventListener(MouseEvent.CLICK, jump);
			button_slap.removeEventListener(MouseEvent.CLICK, slap);
			tmpTime = (Math.floor(getTimer() / 100) / 10);
		}
		
		private function reset(e:MouseEvent):void{
			trace("reset()");
			Obj.stage.removeEventListener(MouseEvent.CLICK, reset);
			button_jump.addEventListener(MouseEvent.CLICK, jump);
			button_slap.addEventListener(MouseEvent.CLICK, slap);
			isGameOver = false;
			collected_hair = 0;
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			advance = 0.0;
			hair_speed_rate = 1.0;
			current_status = STATUS.RUN;
			romaniv.addChild(run_pic);
			romaniv.removeChild(current_pic);
			current_pic = run_pic;
		}
		private function onCompleteJump(e:Event):void{
			button_jump.x = w - button_jump.width - margin;
		}
		
		private function makeHair():void{
			Obj.stage.addChild(hair);
			numOfHair += 1;
			hair.y = ground.y - 60 ;
			hair.x = w + 5;
		}
	}
}// ActionScript file