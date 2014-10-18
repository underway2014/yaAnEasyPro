package views
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import baidu.map.basetype.LngLat;
	import baidu.map.basetype.Size;
	import baidu.map.control.base.Navigator;
	import baidu.map.control.base.Overview;
	import baidu.map.control.base.Ruler;
	import baidu.map.control.base.Scaler;
	import baidu.map.core.Map;
	import baidu.map.layer.Layer;
	import baidu.map.layer.RasterLayer;
	
	import core.baseComponent.CButton;
	
	public class CMapView extends Sprite
	{
		public function CMapView(_LngLatPoint:Point,sizePoint:Point,_zoomRank = 12)
		{
			super();
			
			var map:Map = new Map(new Size(sizePoint.x,sizePoint.y));
			addChild(map);
			map.centerAndZoom(new LngLat(_LngLatPoint.x,_LngLatPoint.y),_zoomRank);
			
			var layer:Layer = new RasterLayer("Baidumap",map);
			map.addLayer(layer);
			
//			 添加Navigator
			var nav:Navigator = new Navigator(map);
//			map.addControl(nav);
//			nav.anchor = Anchor.BC;
			nav.offset = new Size(200,100);
			trace(nav.offset.width,nav.offset.height);
			// 添加Overview			
			var overview:Overview = new Overview(map);
//			map.addControl(overview);
			// 添加Scaler			
			var scaler:Scaler = new Scaler(map);
			map.addControl(scaler);
			// 添加Ruler			
			var ruler:Ruler = new Ruler(map);
//			map.addControl(ruler);
			
			var arr:Array = ["source/back_up.png","source/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
		}
		private function backHandler(event:MouseEvent):void
		{
			this.visible = false;
		}
	}
}