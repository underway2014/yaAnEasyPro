package pages
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
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
			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT - 200);
			hscroll.target = contain;
			addChild(hscroll);
			
			
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
		private var beginY:int = 200;
		private var radius:int = 10;
		private function initContent():void
		{
			var btn:CButton;
			var i:int = 0;
			
			for each(var wmd:WldItemMd in md.itemArr)
			{
				btn = new CButton(wmd.skinsArr,false,false);
				btn.addEventListener(MouseEvent.CLICK,enterDetailHandler);
				btn.data = wmd;
				contain.addChild(btn);
				if(i % 2 == 0)
				{
					btn.x = 500;
				}else{
					btn.x = 895;
				}
				btn.y = i * 135 + beginY;
				i++;
			}
			
			var lineShape:Shape = new Shape();
			lineShape.graphics.lineStyle(2,0xaacc00);
			lineShape.graphics.moveTo(892,beginY + 72);
			lineShape.graphics.lineTo(892,(i - 1) * 135 + 72 + beginY);
			contain.addChild(lineShape);
			
			var cirShape:Shape;
			for(var n:int = 0;n < i;n++)
			{
				cirShape = new Shape();
				cirShape.graphics.beginFill(0xaacc00);
				cirShape.graphics.drawCircle(0,0,radius);
				cirShape.graphics.endFill();
				contain.addChild(cirShape);
				cirShape.x = 892;
				cirShape.y = beginY + 72 + n * 135;
			}
			
//			initPageButton();
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