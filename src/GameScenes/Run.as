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
		private var margin_side:int;	
		private var margin_btm:int;	

		private var tmpTime:Number;
		private var urlReq:URLRequest;
		static private var itemIsAdded:Boolean = false;
		static private var EndOfRun:Boolean = false;
		static private var onPop:Boolean = false;
		
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
		private var cur_pic:Loader = new Loader();
		private const STATUS:Object = {RUN:0, JUMP:1, SLAP:2, DEAD:3, FATHER:4, IDLE:5, END:6};
		private var cur_status:int;
		private var onGround:Boolean = true;
		private const GRAVITY:int = 1;
		private const JUMP_SPEED_BASE:int = -10;
		private var jump_speed:int;
		private var defaultPosY:int;
		private const SLAP_DURATION:Number = 0.3;
		private const EXPLODE_DURATION:Number = 1.8;
		private var attack_area:Sprite = new Sprite();
		private var scale_rate_romaniv:Number = 0.2;
		
		//hairs
		private var hair:Loader = new Loader();
		private var hairs:Array = new Array(3);
		
		private const HAIR_SPEED_BASE:Number = 9.0;
		private const HAIR_SPEED_INCREASE_RATE:Number = 1.1;
		private var hair_speed_rate:Number = 1.0;
		private var numOfHair:int = 0;
		
		
		//btns
		private var btn_slap:Loader = new Loader();
		private var btn_jump:Loader = new Loader();
//
		private var btn_restart:Loader = new Loader();
		private var btn_to_menu:Loader = new Loader();
		private var scale_rate:Number = 0.4;
		
		private var popBG:Loader = new Loader();
		
		
		
		//sounds
		
		
		public function Run(w:int, h:int, Obj:DisplayObject)
		{
//			super();
			// autoOrients をサポート
			this.Obj = Obj;
			this.w = w;
			this.h = h;
			
			margin_side = w *  0.01;
			margin_btm = h * 0.1;
			
			tmpTime = getTimer();
			
			
			//about GUI (include btns)////
			
			//slap btn
			urlReq = new URLRequest("images/btn_slap.png");
			btn_slap.load(urlReq);
			btn_slap.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void{
				btn_slap.width *= scale_rate;
//				trace(btn_slap.width);
				btn_slap.height *= scale_rate;
//				trace(btn_slap.height);
				btn_slap.x =  margin_side;
				btn_slap.y =  h - btn_slap.height - margin_btm;

			});	
			
			//jump btn
			urlReq = new URLRequest("images/btn_jump.png");
			btn_jump.load(urlReq);
			btn_jump.contentLoaderInfo.addEventListener(Event.COMPLETE, function (e:Event):void{
				btn_jump.width *= scale_rate;
				btn_jump.height *= scale_rate;
				btn_jump.x = w - btn_jump.width - margin_side;
				btn_jump.y = h - btn_jump.height - margin_btm;
			});
			
			
			//resatrt btn
			urlReq = new URLRequest("images/s_btn_yes.png");
			btn_restart.load(urlReq);
			btn_restart.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_restart.width = w * 0.25;
				btn_restart.height = h * 0.2;

			});
			btn_restart.x = w * 0.15;
			btn_restart.y = h * 0.35;
			
			//backToMenu btn
			urlReq = new URLRequest("images/s_btn_no.png");
			btn_to_menu.load(urlReq);
			btn_to_menu.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				btn_to_menu.width = w * 0.25;
				btn_to_menu.height = h * 0.2;

			});
			btn_to_menu.x = w * 0.55;
			btn_to_menu.y = h * 0.35;
			
			//popBG
			urlReq = new URLRequest("images/s_background.png");
			popBG.load(urlReq);
			popBG.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				popBG.width = w * 0.98;
				popBG.height = h * 0.9;
			});
			popBG.x = w * 0.01;
			popBG.y = h * 0.01;
			
			//Collected hairs
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			collected_hair_text_field.x = w * 0.3;
			
			//Advanced meter
			advance_text_field.text = advance.toString() + "CM";
			advance_text_field.x = w * 0.6;

			//ground
			ground.graphics.beginFill(0x000000, 1.0);
			ground.graphics.drawRect(0, 0, w, 5);
			ground.graphics.endFill();

			ground.y = h * 0.65;

			//about Romaniv////
			romaniv.graphics.beginFill(0x111111, 0.0);
			romaniv.graphics.drawRect(0, 0, 100, 128);
			romaniv.graphics.endFill();
//			urlReq = new URLRequest("images/Romaniv_run.png");
			urlReq = new URLRequest("images/run1.png");
			run_pic.load(urlReq);
			run_pic.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				run_pic.width  *= scale_rate_romaniv;
				run_pic.height *= scale_rate_romaniv;
			});
//			urlReq = new URLRequest("images/Romaniv_jump.png");
			urlReq = new URLRequest("images/jump6.png");
			jump_pic.load(urlReq);
			jump_pic.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				jump_pic.width  *= scale_rate_romaniv;
				jump_pic.height *= scale_rate_romaniv;
			});
//			urlReq = new URLRequest("images/Romaniv_slap.png");
			urlReq = new URLRequest("images/hataki6.png");
			slap_pic.load(urlReq);
			slap_pic.contentLoaderInfo.addEventListener(Event.COMPLETE, function():void{
				slap_pic.width  *= scale_rate_romaniv;
				slap_pic.height *= scale_rate_romaniv;
			});
			urlReq = new URLRequest("images/explosion.png");
			exp_pic.load(urlReq);
			urlReq = new URLRequest("images/father.png");
			father_pic.load(urlReq);
			
			cur_status = STATUS.RUN;
			jump_speed = JUMP_SPEED_BASE;
			cur_pic = run_pic;
			romaniv.addChild(cur_pic);
			
			trace("romaniv" + cur_pic.width.toString());
			defaultPosY = ground.y -170;
			romaniv.x = w * 0.08;
			romaniv.y = defaultPosY;

			
			//hairs	
			urlReq = new URLRequest("images/hair.png");
			hair.load(urlReq);
		}
			
		public function update():Boolean{
			
			if(EndOfRun){
				EndOfRun = false;
				itemIsAdded = false;
				return false;
			}
			
			
			if(!itemIsAdded){
				Obj.stage.addChild(btn_slap);
				Obj.stage.addChild(btn_jump);
				Obj.stage.addChild(collected_hair_text_field);
				Obj.stage.addChild(advance_text_field);
				Obj.stage.addChild(ground);
				Obj.stage.addChild(romaniv);
				
				btn_slap.addEventListener(MouseEvent.CLICK, slap);
				btn_jump.addEventListener(MouseEvent.CLICK, jump);
				itemIsAdded = true;
			}			
			
			
			
			
			//hairs
			if(!isGameOver){
				if((Math.floor(getTimer() / 100) / 10) % 1 == 0 && !numOfHair){
					makeHair();
				}else if(numOfHair){
					hair.x -= HAIR_SPEED_BASE * hair_speed_rate;
					if(hair.x < romaniv.x + ( romaniv.width * 0.7) && hair.x > romaniv.x  && cur_status != STATUS.JUMP){
						trace(romaniv.x);
						trace(romaniv.width);
						tmpTime = getTimer();
						cur_status = STATUS.DEAD;
						romaniv.addChild(exp_pic);
						romaniv.removeChild(cur_pic);
						cur_pic = exp_pic;
						
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
			switch(cur_status){
				case STATUS.RUN:
					break;
				
				case STATUS.JUMP:
					romaniv.y += jump_speed;
					jump_speed += GRAVITY;
					if(romaniv.y >= defaultPosY){
						romaniv.y = defaultPosY;
						jump_speed = JUMP_SPEED_BASE;
						onGround = true;
						cur_status = STATUS.RUN;
						romaniv.addChild(run_pic);
						romaniv.removeChild(cur_pic);
						cur_pic = run_pic;
					}
					break;
				
				case STATUS.SLAP:
					if((Math.floor(getTimer() / 100) / 10) - tmpTime >= SLAP_DURATION ){
						cur_status = STATUS.RUN;
						romaniv.addChild(run_pic);
						romaniv.removeChild(cur_pic);
						cur_pic = run_pic;
						
						Obj.stage.removeChild(attack_area);
					}
					break;
				case STATUS.DEAD:
					if(!isGameOver){
						gameOver();
					}
					
					if((Math.floor(getTimer() / 100) / 10) - tmpTime >= EXPLODE_DURATION ){
						cur_status = STATUS.FATHER;
						romaniv.addChild(father_pic);
						romaniv.removeChild(cur_pic);
						cur_pic = father_pic;
					}					
					break;
				case STATUS.FATHER:
					if(!onPop){
						onPop = true;
						Obj.stage.addEventListener(MouseEvent.CLICK, makePop);
					}
					break;
				default:
					break;
			}
			return true;
		}
		
		private function jump(e:MouseEvent):void{
			if(onGround){
				cur_status = STATUS.JUMP;
				romaniv.addChild(jump_pic);
				romaniv.removeChild(cur_pic);
				cur_pic = jump_pic;
				onGround = false;
			}
		}
		
		
		private function slap(e:MouseEvent):void{
			if(cur_status == STATUS.RUN){
				attack_area.graphics.beginFill(0xFF0000, 0.0);
				attack_area.graphics.drawRect(0, 0, 47, 128);
				attack_area.graphics.endFill();
				Obj.stage.addChild(attack_area);
				attack_area.x = romaniv.x + 100;
				attack_area.y = romaniv.y + 50
				cur_status = STATUS.SLAP;
				
				romaniv.addChild(slap_pic);
				romaniv.removeChild(cur_pic);
				cur_pic = slap_pic;
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
			btn_jump.removeEventListener(MouseEvent.CLICK, jump);
			btn_slap.removeEventListener(MouseEvent.CLICK, slap);
			tmpTime = (Math.floor(getTimer() / 100) / 10);
		}
		
		private function makePop(e:MouseEvent):void{
			Obj.stage.removeEventListener(MouseEvent.CLICK, makePop);
			btn_jump.addEventListener(MouseEvent.CLICK, jump);
			btn_slap.addEventListener(MouseEvent.CLICK, slap);
			
			Obj.stage.addChild(popBG);
			Obj.stage.addChild(btn_restart);
			Obj.stage.addChild(btn_to_menu);
			
			btn_restart.addEventListener(MouseEvent.CLICK, restart);
			btn_to_menu.addEventListener(MouseEvent.CLICK, backToMenu);
		
		}
		
		private function restart(e:MouseEvent):void{
			onPop = false;
			cur_status = STATUS.RUN;
			Obj.stage.removeChild(popBG);
			Obj.stage.removeChild(btn_restart);
			Obj.stage.removeChild(btn_to_menu);
			
			trace("restart()");

			isGameOver = false;
			collected_hair = 0;
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			advance = 0.0;
			hair_speed_rate = 1.0;
			cur_status = STATUS.RUN;
			romaniv.addChild(run_pic);
			romaniv.removeChild(cur_pic);
			cur_pic = run_pic;
		}
		
		private function backToMenu(e:MouseEvent):void
		{
			onPop = false;
			isGameOver = false;
			collected_hair = 0;
			collected_hair_text_field.text = "毛：" + collected_hair.toString() + "本";
			advance = 0.0;
			hair_speed_rate = 1.0;
			cur_status = STATUS.RUN;
			romaniv.addChild(run_pic);
			romaniv.removeChild(cur_pic);
			cur_pic = run_pic;
			removeAll();
			Obj.stage.removeChild(popBG);
			Obj.stage.removeChild(btn_restart);
			Obj.stage.removeChild(btn_to_menu);
			EndOfRun = true; 
		}
		
		private function removeAll():void{
			Obj.stage.removeChild(btn_slap);
			Obj.stage.removeChild(btn_jump);
			Obj.stage.removeChild(collected_hair_text_field);
			Obj.stage.removeChild(advance_text_field);
			Obj.stage.removeChild(ground);
			Obj.stage.removeChild(romaniv);		
		};
		
		private function makeHair():void{
			Obj.stage.addChild(hair);
			numOfHair += 1;
			hair.y = ground.y - 60 ;
			hair.x = w + 5;
		}
	}
}// ActionScript file