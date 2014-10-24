package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.loadEvents.CLoader;
	
	import models.TelMd;
	import models.YAConst;
	
	public class TelPage extends Sprite
	{
		private var md:TelMd;
		private var imgContain:Sprite;
		public function TelPage(_md:TelMd)
		{
			super();
			md = _md;
			var hscroll:HScroller = new HScroller(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			addChild(hscroll);
			imgContain = new Sprite();
			hscroll.target = imgContain;
			
//			var loader:CLoader = new CLoader();
//			loader.load(md.url);
//			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
			
			var img:CImage;
			var i:int = 0;
			for each(var url:String in md.contentArr)
			{
				img = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,true,false);
				img.url = url;
				imgContain.addChild(img);
				img.y = i * YAConst.SCREEN_HEIGHT;
				i++;
			}
			
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
		
		}
		private function okHandler(event:Event):void
		{
			var el:CLoader = event.currentTarget as CLoader;
			imgContain.addChild(el._loader);
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