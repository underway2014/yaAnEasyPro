package views
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.loadEvents.CLoader;
	
	import models.ActiveItemMd;
	
	public class ActiveDetailView extends Sprite
	{
		public var SELF_WIDTH:int = 1000;
		public var SELF_HEIGHT:int = 900;
		private var md:ActiveItemMd;
		public function ActiveDetailView(_md:ActiveItemMd)
		{
			super();
			md = _md;
			
			var nameTxt:TextField = new TextField();
			nameTxt.text = md.name;
			addChild(nameTxt);
			
			var hscroll:HScroller = new HScroller(SELF_WIDTH,SELF_HEIGHT);
			addChild(hscroll);
//			hscroll.x = (YAConst.SCREEN_WIDTH - SELF_WIDTH) / 2;
			hscroll.y = 50;
			content = new Sprite();
			hscroll.target = content;
			
			var closeImage:CImage = new CImage(66,58,true,false);
			closeImage.url = "source/public/close.png";
			addChild(closeImage);
			closeImage.x = SELF_WIDTH - closeImage.width;
			closeImage.y = 5;
			closeImage.addEventListener(MouseEvent.CLICK,closeHandler);
			
			var loader:CLoader = new CLoader();
			loader.load(md.content);
			loader.addEventListener(CLoader.LOADE_COMPLETE,okHandler);
		}
		private function closeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private var content:Sprite;
		private function okHandler(event:Event):void
		{
			var l:CLoader = event.currentTarget as CLoader;
			content.addChild(l._loader);
		}
	}
}