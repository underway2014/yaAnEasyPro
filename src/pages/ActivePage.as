package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	
	import models.ActiveItemMd;
	import models.ActiveMd;
	import models.YAConst;
	
	import views.ActiveDetailView;
	
	public class ActivePage extends Sprite
	{
		private var md:ActiveMd;
		public function ActivePage(_md:ActiveMd)
		{
			super();
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bg.url = md.bg;
			addChild(bg);
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
			
			
			contain = new Sprite();
			var hscroller:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT  - 100);
			hscroller.target = contain;
			addChild(hscroller);
			
			detailContain = new Sprite();
			addChild(detailContain);
			init();
		}
		private var contain:Sprite;
		private var beignX:int = 100;
		private function init():void
		{
			var contentImg:CImage;
			var labelImg:CImage;
			var iconImg:CImage;
			var i:int = 0;
			for each(var amd:ActiveItemMd in md.itemArr)
			{
				contentImg = new CImage(1334,433,true,false);
				contentImg.url = amd.content;
				contain.addChild(contentImg);
				contentImg.x = beignX + 300;
				contentImg.y =  i * 453;
				
				labelImg = new CImage(273,52,true,false);
				labelImg.url = amd.label;
				labelImg.x = beignX;
				labelImg.y = amd.coordXY.y;
				contain.addChild(labelImg);
				
				iconImg = new CImage(42,42,true,false);
				iconImg.url = "source/public/activeIcon.png";
				iconImg.x = beignX - 40;
				iconImg.y = amd.coordXY.y;
				contain.addChild(iconImg);
				
			}
		}
		private var detailContain:Sprite;
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			var view:ActiveDetailView = new ActiveDetailView(cb.data);
			view.x = (YAConst.SCREEN_WIDTH - view.SELF_WIDTH) / 2;
			view.y = (YAConst.SCREEN_HEIGHT - view.SELF_HEIGHT) / 2;
			detailContain.addChild(view);
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.visible = false;
			}
		}
	}
}