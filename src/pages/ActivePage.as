package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	import core.baseComponent.HScroller;
	import core.interfaces.PageClear;
	import core.loadEvents.Cevent;
	
	import models.ActiveItemMd;
	import models.ActiveMd;
	import models.YAConst;
	
	import views.ActiveDetailView;
	
	public class ActivePage extends Sprite implements PageClear
	{
		private var md:ActiveMd;
		public function ActivePage(_md:ActiveMd)
		{
			super();
			md = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false,false);
			bg.url = md.bg;
			addChild(bg);
			
//			var timer:Timer = new Timer(100,1);
//			timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			timer.start();
			
			timerHandler(null);
		}
		private function timerHandler(event:TimerEvent):void
		{
			var barr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(barr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
			
			var sbar:Array = ["source/public/slider.png","source/public/bar.png"];
			contain = new Sprite();
			var hscroller:HScroller = new HScroller(YAConst.SCREEN_WIDTH - YAConst.SCROLLBAR_RHGITH_MARGIN,YAConst.SCREEN_HEIGHT  - 200,sbar);
			hscroller.target = contain;
			hscroller.y = 45;
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
				contentImg = new CImage(1334,563,false,false);
				contentImg.url = amd.content;
				contain.addChild(contentImg);
				contentImg.x = beignX + 300;
				contentImg.y =  i * 583;
				
				labelImg = new CImage(273,52,true,false);
				labelImg.url = amd.label;
				labelImg.x = beignX;
				labelImg.y = contentImg.y + 100;
				contain.addChild(labelImg);
				
				iconImg = new CImage(42,42,true,false);
				iconImg.url = "source/public/activeIcon.png";
				iconImg.x = beignX - 40;
				iconImg.y = contentImg.y + 100;
				contain.addChild(iconImg);
				
				i++;
				
			}
			timer = new Timer(100,1);
			timer.addEventListener(TimerEvent.TIMER,dispatchHandler);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
			timer.start();
		}
		private var timer:Timer;
		private function dispatchHandler(event:Event):void
		{
			dispatchEvent(new Event(Cevent.PAGEINIT_COMPLETE,true));
		}
		private function timerComplete(event:TimerEvent):void
		{
			if(timer)
			{
				timer.removeEventListener(TimerEvent.TIMER,dispatchHandler);
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerComplete);
				timer = null;
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
		public function clearAll():void
		{
			
		}
		public function hide():void
		{
			this.visible = false;
		}
		public function show():void
		{
			this.visible = true;
		}
	}
}