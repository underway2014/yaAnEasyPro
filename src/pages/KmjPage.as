package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.baseComponent.CImage;
	import core.baseComponent.CSprite;
	import core.tween.TweenLite;
	
	import models.KmjMd;
	import models.KmjPointMd;
	import models.YAConst;
	
	public class KmjPage extends Sprite
	{
		private var kmjMd:KmjMd;
		private var drag:CDrag;
		private var navagation:Sprite;
		public function KmjPage(_md:KmjMd)
		{
			super();
			
			kmjMd = _md;
			
			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			addChild(drag);
			var contain:Sprite = new Sprite();
			drag.target = contain;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT + 100,false,false);
			bgImg.url = kmjMd.background;
			contain.addChild(bgImg);
			
			btnContain = new Sprite();
			contain.addChild(btnContain);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
			
			navagation = new Sprite();
			addChild(navagation);
			navagation.x = 100;
			navagation.y = 50;
			
			initBar();
			
			initAlphaButton();
		}
		private var items:Array = ["1.png","2.png","3.png","4.png"]
		private function initBar():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var str:String in items)
			{
				btn = new CButton(["source/lookSpot/" + str,"source/lookSpot/" + str],false,false);
				btn.addEventListener(MouseEvent.CLICK,changeCity);
				btn.x += 175 * i;
				navagation.addChild(btn);
				i++;
			}
		}
		private function changeCity(event:MouseEvent):void
		{
			trace();
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		private var btnContain:Sprite;
		private function initAlphaButton():void
		{
			var btn:CSprite;
			btnArr = new Array();
			for each(var kmd:KmjPointMd in kmjMd.pointArr)
			{
				btn = new CSprite();
				btn.graphics.beginFill(0xaa0000,0.2);
				btn.graphics.drawRect(0,0,150,65);
				btn.graphics.endFill();
				btnContain.addChild(btn);
				btn.x = kmd.pointXY.x;
				btn.y = kmd.pointXY.y;
				btn.data = kmd.spotMd;
				btnArr.push(btn);
				btn.addEventListener(MouseEvent.CLICK,clickAlphaButton);
			}
			autoFall();
		}
		private var btnArr:Array;
		public function autoFall():void
		{
			for each(var btn:Sprite in btnArr)
			{
				TweenLite.from(btn,1,{y:-100,onComplete:tweenOve});
			}
		}

		private function initSpotButton():void
		{
			var btn:CButton;
			for each(var kmd:KmjPointMd in kmjMd.pointArr)
			{
				btn = new CButton(kmd.skinArr,false);
				btn.x = kmd.pointXY.x;
				btn.y = -100;
				btn.data = kmd.spotMd;
				btnContain.addChild(btn);
				TweenLite.to(btn,1,{y:kmd.pointXY.y,delay:1,onComplete:tweenOve});
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		private var tn:int = 0;
		private function tweenOve():void
		{
			tn++;
			if(tn >= kmjMd.pointArr.length)
			{
				
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			var atlasPage:AtlasPage = new AtlasPage(cb.data);
			addChild(atlasPage);
		}
		private function clickAlphaButton(event:MouseEvent):void
		{
			var cb:CSprite = event.currentTarget as CSprite;
			var atlasPage:AtlasPage = new AtlasPage(cb.data);
			addChild(atlasPage);
		}
	}
}