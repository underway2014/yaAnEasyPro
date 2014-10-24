package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	
	import models.WldItemDetailMd;
	import models.WldItemMd;
	import models.WldMd;
	import models.YAConst;
	
	public class WldPage extends Sprite
	{
		private var md:WldMd;
		private var contain:Sprite;
		public function WldPage(_md:WldMd)
		{
			super();
			md = _md;
			
			contain = new Sprite();
			addChild(contain);
			
			var img:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			img.url = md.background;
			contain.addChild(img);
			
//			contentSprite = new Sprite();
//			addChild(contentSprite);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 20;
			
			
			initContent();
			
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
		private function initContent():void
		{
			var btn:CButton;
			var imageArr:Array = new Array();
			var itemImg:CImage;
			for each(var wmd:WldItemMd in md.itemArr)
			{
				itemImg = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
				itemImg.url = wmd.url;
				imageArr.push(itemImg);
				var i:int = 0;
				for each(var wdmd:WldItemDetailMd in wmd.detailArr)
				{
					btn = new CButton(wdmd.skin,false,false);
					btn.addEventListener(MouseEvent.CLICK,enterDetailHandler);
					btn.data = wmd;
					btn.x = wdmd.coordXY.x;
					btn.y = wdmd.coordXY.y;
					itemImg.addChild(btn);
					i++;
				}
			}
			loopAlt = new LoopAtlas(imageArr,false);
			contain.addChild(loopAlt);
			
			initPageButton();
		}
		private var loopAlt:LoopAtlas;
		private function enterDetailHandler(event:MouseEvent):void
		{
			
		}
		private function initPageButton():void
		{
			var nextBtn:CButton = new CButton(["source/public/arrowRight_up.png","source/public/arrowRight_down.png"],false,false);
			nextBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			nextBtn.data = 1;
			var prevBtn:CButton = new CButton(["source/public/arrowLeft_up.png","source/public/arrowLeft_down.png"],false,false);
			prevBtn.addEventListener(MouseEvent.CLICK,pageHandler);
			
			contain.addChild(nextBtn);
			contain.addChild(prevBtn);
			nextBtn.y = prevBtn.y = (YAConst.SCREEN_HEIGHT - 118) / 2 - 118 /2;
			nextBtn.x = YAConst.SCREEN_WIDTH - 116;
			
			
		}
		private function pageHandler(event:MouseEvent):void
		{
			var btn:CButton = event.currentTarget as CButton;
			if(btn.data == 1)
			{
				loopAlt.next();
			}else{
				loopAlt.prev();
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			var tb:CButton = event.currentTarget as CButton;
			var view:PictureFlowPage = new PictureFlowPage(tb.data);
			addChild(view);
		}
	}
}