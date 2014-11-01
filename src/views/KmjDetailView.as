package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.LoopAtlas;
	import core.loadEvents.CLoader;
	
	import models.KmjPointDetailMd;
	import models.YAConst;
	
	public class KmjDetailView extends Sprite
	{
		private var md:KmjPointDetailMd;
		private var selfWidth:int = 1670 + 30;
		public function KmjDetailView(_md:KmjPointDetailMd)
		{
			super();
			
			md = _md;
			
			var bgImg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bgImg.url = md.bg;
			addChild(bgImg);
			
			contain = new Sprite();
			addChild(contain);
			
			contain.x = (YAConst.SCREEN_WIDTH - selfWidth) / 2;
			contain.y = 50;
			
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 700;
			
			initContent();
			
		}
		private var contain:Sprite;
		private function initContent():void
		{
			
			var imgArr:Array = [];
			var img:CImage;
			for each(var str:String in md.headArr)
			{
				img = new CImage(1670,589,false,false);
				img.url = str;
				imgArr.push(img);
			}
			
			loop = new LoopAtlas(imgArr,true);
			loop.addEventListener(Event.REMOVED_FROM_STAGE,clearLoop);
			loop.size = new Point(1670,589);
			loop.showTipCircle = true;
			contain.addChild(loop);
			loop.x = 15;
			loop.y = 15;
			
			loader = new CLoader();
			loader.load(md.txt);
			loader.addEventListener(CLoader.LOADE_COMPLETE,completeHandler);
			
		}
		private var loop:LoopAtlas;
		private var loader:CLoader;
		private function completeHandler(event:Event):void
		{
			contain.addChild(loader._loader);
			loader._loader.x = 15;
			loader._loader.y = 15 + 589 + 20;
			loader._loader.addEventListener(Event.REMOVED_FROM_STAGE,clearTxtImg);
		}
		private function backHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private function clearLoop(event:Event):void
		{
			if(loop)
			{
				loop.clear();
				loop = null;
			}
		}
		private function clearTxtImg(event:Event):void
		{
			if(loader)
			{
				loader._loader = null;
				loader = null;
			}
		}
	}
}