package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.baseComponent.CImage;
	
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.YAConst;
	
	
	public class LinePage extends Sprite
	{
		private var lineData:LineMd;
		private var map_width:int = 1080;
		private var map_height:int = 400;
		private var alphaMask:Sprite;
		private var drag:CDrag;
		private var contain:Sprite;
		public function LinePage(_lineData:LineMd)
		{
			super();
			
			lineData = _lineData;
			
			contain = new Sprite();
			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			drag.target = contain;
			addChild(drag);
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 700;
			
			init();
			
			
		}
		private function init():void
		{
			var pageImg:CImage;
			var i:int = 0;
			for each(var pmd:LinePageMd in lineData.pageArr)
			{
				pageImg = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
				pageImg.url = pmd.bg;
				pageImg.x = YAConst.SCREEN_WIDTH * i;
				contain.addChild(pageImg);
				var btn:CButton;
				for each(var pimd:LineItemMd in pmd.itemArr)
				{
					btn = new CButton(pimd.skin,false,false);
					btn.x = pimd.coordXY.x;
					btn.y = pimd.coordXY.y;
					pageImg.addChild(btn);
					btn.addEventListener(MouseEvent.CLICK,clickHandler);
				}
				i++;
			}
		}
		private function clickHandler(event:MouseEvent):void
		{
			trace("line page btn click..");
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