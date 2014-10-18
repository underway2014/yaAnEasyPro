package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	
	import models.PointMd;
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
			for each(var pmd:PointMd in md.pointsArr)
			{
				btn = new CButton(pmd.btnSkinArr,false);
				btn.x = pmd.pointXY.x;
				btn.y = pmd.pointXY.y;
				btn.data = pmd.atlasArr;
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				contain.addChild(btn);
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