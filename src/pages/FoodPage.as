package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	
	import models.AtlaMd;
	import models.EatFoodMd;
	import models.YAConst;
	
	import views.FoodStreetView;
	
	public class FoodPage extends Sprite
	{
		private var eatmd:EatFoodMd;
		public function FoodPage(_md:EatFoodMd)
		{
			super();
			
			eatmd = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false);
			addChild(bg);
			bg.url = eatmd.bg;
			
		
			
			initButton();
		}
		private var contentSprite:Sprite;
		private var beginX:int = 200;
		private function initButton():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var arr:Array in eatmd.btnArr)
			{
				btn = new CButton(arr,false,false);
				btn.data =eatmd.beginIndexArr[i];
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.x = beginX + i * 200;
				addChild(btn);
				i++;
			}
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
			
			contentSprite = new Sprite();
			contentSprite.visible = false;
			addChild(contentSprite);
			initPageButton();
			
			var tjbackBtn:CButton = new CButton(barr,false);
			tjbackBtn.addEventListener(MouseEvent.CLICK,loopAtlbackHandler);
			contentSprite.addChild(tjbackBtn);
			tjbackBtn.x = 30;
			tjbackBtn.y = 30;
			
			var timer:Timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
		}
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			contentSprite.addChild(nextBtn);
			contentSprite.addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 118) / 2 - 118 /2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 116;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAtl.next();
			}else{
				loopAtl.prev();
			}
		}
		private function timerHandler(event:TimerEvent):void
		{
			var imgArr:Array = new Array();
			var img:CImage;
			for each(var amd:AtlaMd in eatmd.altArr)
			{
				img = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
				img.url = amd.url;
				imgArr.push(img);
			}
			loopAtl = new LoopAtlas(imgArr,false);
			contentSprite.addChildAt(loopAtl,0);
		}
		private var loopAtl:LoopAtlas;
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			loopAtl.gotoPage(cb.data);
			contentSprite.visible = true;
			
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		private function loopAtlbackHandler(event:MouseEvent):void
		{
			if(contentSprite)
			{
				contentSprite.visible = false;
			}
		}
	}
}