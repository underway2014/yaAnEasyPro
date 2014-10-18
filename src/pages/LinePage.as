package pages
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CDrag;
	import core.baseComponent.CTextButton;
	import core.layout.Group;
	import core.loadEvents.CLoader;
	import core.loadEvents.Cevent;
	import core.loadEvents.DataEvent;
	
	import models.LineMd;
	import models.PointMd;
	import models.RouteItemMd;
	import models.RouteMd;
	import models.YAConst;
	
	import views.RouteListView;
	
	public class LinePage extends Sprite
	{
		private var lineData:LineMd;
		private var map_width:int = 1080;
		private var map_height:int = 400;
		private var alphaMask:Sprite;
		private var drag:CDrag;
		public function LinePage(_lineData:LineMd)
		{
			super();
			
			lineData = _lineData;
			
			mapContain = new Sprite();
			drag = new CDrag(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT);
			drag.target = mapContain;
			addChild(drag);
//			addChild(mapContain);
			
			bgContain = new Sprite();
			mapContain.addChild(bgContain);
			lineContain = new Sprite();
			mapContain.addChild(lineContain);
			numContain = new Sprite();
			mapContain.addChild(numContain);
			
			controlContain = new Sprite();
			addChild(controlContain);
			
			alphaMask = new Sprite();
			alphaMask.graphics.beginFill(0xaacc00,0);
			alphaMask.graphics.drawRect(0,0,1080,608);
			alphaMask.graphics.endFill();
			addChild(alphaMask);
			alphaMask.visible = false;
			
//			mapContain.addEventListener(MouseEvent.MOUSE_DOWN,startDragHandler);
//			mapContain.addEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
			
			initColorMap();
			initControl();
			initBackButton();
		}
		private function initBackButton():void
		{
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 700;
		}
		private function backHandler(event:MouseEvent):void
		{
			this.visible = false;
		}
		private var mapContain:Sprite;
		private var bgContain:Sprite;
		private var lineContain:Sprite;
		private var numContain:Sprite;
		
		private var controlContain:Sprite;
		private var bgLoader:CLoader;
		private function initColorMap():void
		{
			bgLoader = new CLoader();
			bgLoader.load(lineData.colorMap);
			bgLoader.addEventListener(CLoader.LOADE_COMPLETE,bgOkHandler);
		}
		private function bgOkHandler(event:Event):void
		{
			bgContain.addChild(bgLoader._loader);
		}
		private function initLine(_md:RouteItemMd):void
		{
			changeLine(_md.lineMap);
			changeStateNum(_md.pintsArr);
		}
		private function changeStateNum(_arr:Array):void
		{
			while(numContain.numChildren)
			{
				numContain.removeChildAt(0);
			}
			var nbtn:CButton;
			var i:int =1;
			for each(var pmd:PointMd in _arr)
			{
				nbtn = new CButton(["source/stateNum/" + i + ".png","source/stateNum/" + i + ".png"],false);
				nbtn.x = pmd.pointXY.x;
				nbtn.y = pmd.pointXY.y;
				nbtn.data = pmd;
				i++;
				nbtn.addEventListener(MouseEvent.CLICK,clicNumHandler);
				numContain.addChild(nbtn);
			}
		}
		private function clicNumHandler(event:MouseEvent):void
		{
			var cnbtn:CButton = event.currentTarget as CButton;
			var atlasPage:AtlasPage = new AtlasPage(cnbtn.data);
			addChild(atlasPage);
			
		}
		private function changeLine(lineMap:String):void//添加纯线 路
		{
			
		}
		private var typeGroup:Group = new Group();
		private function initControl():void
		{
			var btn:CTextButton;
			var i:int = 0;
			for each(var roteMd:RouteMd in lineData.routesArr)
			{
				btn = new CTextButton(["source/line/lineButton/1.png","source/line/lineButton/2.png"],false);
				btn.text = roteMd.name;
				btn.data = roteMd.itemArr;
				btn.addEventListener(MouseEvent.CLICK,typeClickHandler);
				typeGroup.add(btn);
				controlContain.addChild(btn);
				btn.x = i * 100;
				i++;
			}
			typeGroup.addEventListener(Cevent.SELECT_CHANGE,typeChangeHandler);
			typeGroup.selectById(0);
		}
		private function typeClickHandler(event:MouseEvent):void
		{
			var tbtn:CTextButton = event.currentTarget as CTextButton;
			typeGroup.selectByItem(tbtn);
		}
		private var routeListView:RouteListView;
		private function typeChangeHandler(event:Event):void
		{
			var sb:CTextButton = typeGroup.getCurrentObj() as CTextButton;
			routeListView = new RouteListView(sb.data);
			routeListView.addEventListener(DataEvent.CLICK,listChangeHandler);
			routeListView.y = 80;
			controlContain.addChild(routeListView);
			routeListView.reset();
		}
		private function listChangeHandler(event:DataEvent):void
		{
			var cdata:RouteItemMd = event.data as RouteItemMd;
			initLine(cdata);
		}
		private var mouse_beginX:Number;
		private var mouse_beginY:Number;
		private var standar_dis:int = 10;
		private var hasAddMove:Boolean;//是否已经注册MOVE事件
		private function startDragHandler(event:MouseEvent):void
		{
			mouse_beginX = this.mouseX;
			mouse_beginY = this.mouseY;
			mapContain.startDrag(false,new Rectangle(map_width - mapContain.width,map_height - mapContain.height,mapContain.width - 1080,mapContain.height - 608));
			
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,autoRotationHandler);
			}
			//			mapContain.addEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
		}
		private function autoRotationHandler(event:Event):void
		{
			if(!hasAddMove && Math.sqrt((this.mouseX - mouse_beginX)*(this.mouseX - mouse_beginX) + (this.mouseY - mouse_beginY)*(this.mouseY - mouse_beginY)) >= standar_dis)
			{
				mapContain.addEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
				hasAddMove = true;
				trace("add move event");
			}
		}
		private function mapContainMovehandler(event:MouseEvent):void
		{
			alphaMask.addEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
			alphaMask.addEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			alphaMask.visible = true;
//			blackMaskShape.mouseEnabled = statesContain.mouseChildren = statesContain.mouseEnabled = false;
			
			
		}
		private function stopDragHandler(event:MouseEvent):void
		{
			alphaMask.visible = false;
			mapContain.stopDrag();
			if(hasAddMove)
			{
				alphaMask.removeEventListener(MouseEvent.MOUSE_UP,stopDragHandler);
				alphaMask.removeEventListener(MouseEvent.MOUSE_OUT,stopDragHandler);
			}
			mapContain.removeEventListener(MouseEvent.MOUSE_MOVE,mapContainMovehandler);
			this.removeEventListener(Event.ENTER_FRAME,autoRotationHandler);
//			blackMaskShape.mouseEnabled = statesContain.mouseChildren = statesContain.mouseEnabled = true;
			hasAddMove = false;
		}
	}
}