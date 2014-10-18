package Json
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.ActiveMd;
	import models.AtlaMd;
	import models.BusinessItemMd;
	import models.BusinessMd;
	import models.ButtonMd;
	import models.EatFoodMd;
	import models.FoodMd;
	import models.HomeMD;
	import models.KmjMd;
	import models.KmjPointMd;
	import models.LineMd;
	import models.PointMd;
	import models.RouteItemMd;
	import models.RouteMd;
	import models.WldMd;
	

	public class ParseJSON extends EventDispatcher
	{
		
		public static const LOAD_COMPLETE:String = "load_complete";
		
		private const HOME:String = "HOME";
		private const KMJ:String = "KMJ";
		private const WLD:String = "WLD";
		private const ROUTE:String = "ROUTE";
		private const MAP:String = "MAP";
		private var type:int;
		/**
		 * 
		 * @param path
		 * @param _type !0 parseInfo else  
		 * 
		 */		
		public function ParseJSON(path:String,_type:int = 0)
		{
			type = _type;
			loadJson(path);
		}
		public function loadJson(path:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,jsonLoadOkHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
		}
		private function jsonLoadOkHandler(event:Event):void
		{
			var obj:Object = JSON.parse(URLLoader(event.target).data);
			parseSource(obj);
		}
		private var homeDataArr:Vector.<HomeMD> = new Vector.<HomeMD>;
		private var activeArr:Array = new Array();
		private var lineMd:LineMd;
		private var wldMd:WldMd;
		private var kmjMd:KmjMd;
		private var eatfood:EatFoodMd;
		private var allSpotsArr:Vector.<PointMd> = new Vector.<PointMd>;
		private function parseSource(data):void
		{
			//首页
			var homeMd:HomeMD;
			for each(var hObj:Object in data.HOME)
			{
				homeMd = new HomeMD();
				homeMd.name = hObj.name;
				homeMd.type = hObj.type;
				homeMd.picArr = new Array();
				var picmd:AtlaMd;
				for each(var pobj:Object in hObj.pictures)
				{
					picmd = new AtlaMd();
					picmd.url = pobj.url;
					picmd.btnArr = new Array();
					if(pobj.buttons && pobj.buttons != "" && pobj.buttons != "null")
					{
						var btnMd:ButtonMd;
						for each(var bobj:Object in pobj.buttons)
						{
							btnMd = new ButtonMd();
							btnMd.skinArr = bobj.skin;
							btnMd.id = bobj.id;
							picmd.btnArr.push(btnMd);
							btnMd.coordXY = new Point();
							if(bobj.coord.length > 1)
							{
								btnMd.coordXY.x = bobj.coord[0];
								btnMd.coordXY.y = bobj.coord[1];
							}
						}
					}
					homeMd.picArr.push(picmd);
				}
				homeDataArr.push(homeMd);
			}
			//all spots
			var aPointMd:PointMd;
			for each(var amd:Object in data.ALLSPOTS)
			{
				aPointMd = new PointMd();
				aPointMd.name = amd.name;
				aPointMd.pointXY = new Point(amd.coordX,amd.coordY);
				aPointMd.audioUrl = amd.audio;
				aPointMd.background = amd.background;
				aPointMd.atlasArr = new Array();
				var atmd:AtlaMd;
				for each(var aobj:Object in amd.atlas)
				{
					atmd = new AtlaMd();
					atmd.name = aobj.name;
					atmd.url = aobj.url;
					aPointMd.atlasArr.push(atmd);
				}
				allSpotsArr.push(aPointMd);
			}
			
			
			//好线路
			lineMd = new LineMd();
			var lineData:Object = data.LINE;
			lineMd.colorMap = lineData.colorMap;
			lineMd.routesArr = new Array();
			var routeMd:RouteMd;
			for each(var obj:Object in lineData.routes)
			{
				routeMd = new RouteMd();
				routeMd.name = obj.name;
				routeMd.itemArr = new Array();
				var routeItemMd:RouteItemMd;
				for each(var iobj:Object in obj.items)
				{
					routeItemMd = new RouteItemMd();
					routeItemMd.name = iobj.name;
					routeItemMd.lineMap = iobj.lineMap;
					routeItemMd.pintsArr = new Array();
					for each(var n:int in iobj.points)
					{
						routeItemMd.pintsArr.push(allSpotsArr[n]);
					}
					routeMd.itemArr.push(routeItemMd);
				}
				lineMd.routesArr.push(routeMd);
			}
			
			///玩乐地
			wldMd = new WldMd();
			var wldData:Object = data.WLD;
			wldMd.name = wldData.name;
			wldMd.background = wldData.background;
			wldMd.pointsArr = new Array();
			var pointMD:PointMd;
			for each(var po:Object in wldData.points)
			{
				pointMD = new PointMd();
				pointMD.name = po.name;
				pointMD.pointXY = new Point(po.coordX,po.coordY);
				pointMD.btnSkinArr = new Array(po.btnNormal,po.btnDown);
				pointMD.atlasArr = new Array();
				var atMD:AtlaMd;
				for each(var ao:Object in po.atlas)
				{
					atMD = new AtlaMd();
					atMD.name = ao.name;
					atMD.url = ao.url;
					atMD.desc = ao.desc;
					pointMD.atlasArr.push(atMD);
				}
				wldMd.pointsArr.push(pointMD);
			}
			
			//赏景点
			kmjMd = new KmjMd();
			var kmjData:Object = data.SJD;
			kmjMd.name = kmjData.name;
			kmjMd.background = kmjData.background;
			kmjMd.pointArr = new Array();
			var kmjSpotMd:KmjPointMd;
			var currType:int = 0;
			for each(var ko:Object in kmjData.points)
			{
				kmjSpotMd = new KmjPointMd();
				kmjSpotMd.name = ko.name;
				kmjSpotMd.pointXY = new Point(ko.coordX,ko.coordY);
				kmjSpotMd.skinArr = new Array(ko.btnNormal,ko.btnDown);
				kmjSpotMd.spotMd = allSpotsArr[ko.spotId];
				kmjSpotMd.type = ko.type;
				if(kmjSpotMd.type > currType)
				{
					currType = ko.type;
				}
				kmjMd.pointArr.push(kmjSpotMd);
			}
			kmjMd.childCityArr = new Array();
			for(var c:int = 0;c <= currType;c++)
			{
				var arr:Array = new Array();
				for each(var xx:KmjPointMd in kmjMd.pointArr)
				{
					if(xx.type == c)
					{
						arr.push(xx);
					}
				}
				kmjMd.childCityArr.push(arr);
			}
			
			
			///活动
			var activeMd:ActiveMd;
			for each(var aco:Object in data.ACTIVITY)
			{
				activeMd = new ActiveMd();
				activeMd.name = aco.name;
				activeMd.desc = aco.desc;
				activeArr.push(activeMd);
			}
			
			// 吃美食
			
			var eatData:Object = data.EATFOOD;
			eatfood = new EatFoodMd();
			eatfood.bg = eatData.background;
			eatfood.dsc = eatData.desc;
			eatfood.btnArr = new Array();
			
			//美食
			eatfood.food = new FoodMd();
			var foodData:Object = eatData.food;
			eatfood.food.name = foodData.name;
			eatfood.btnArr.push(foodData.skin);	// 多添加一个按钮
			eatfood.btnArr.push(foodData.skin);
			eatfood.food.itemArr = new Array();
			var altmd:AtlaMd;
			for each(var imd:Object in foodData.items)
			{
				altmd = new AtlaMd();
				altmd.name = imd.name;
				altmd.desc = imd.dsc;
				altmd.url = imd.picture;
				eatfood.food.itemArr.push(altmd);
			}
			//商业
			eatfood.business = new BusinessMd();
			var busData:Object = eatData.business;
			eatfood.business.name = busData.name;
			eatfood.btnArr.push(busData.skin);
			eatfood.business.itemArr = new Array();
			var itemd:BusinessItemMd;
			for each(var bo:Object in busData.items)
			{
				itemd = new BusinessItemMd();
				itemd.name = bo.name;
				itemd.icon = bo.icon;
				itemd.dsc = bo.dsc;
				itemd.adress = bo.adress;
				itemd.tel = bo.tel;
				itemd.recomendArr = new Array();
				var atl:AtlaMd;
				for each(var ro:Object in bo.recomend)
				{
					atl = new AtlaMd();
					atl.name = ro.name;
					atl.url = ro.url;
					itemd.recomendArr.push(atl);
				}
				
				eatfood.business.itemArr.push(itemd);
			}
			
			
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		private function errorHandler(event:IOErrorEvent):void
		{
			trace("json load wrong!");
		}
		public function getHomeData():Vector.<HomeMD>
		{
			return homeDataArr;
		}
		public function getLineData():LineMd
		{
			return lineMd;
		}
		public function getWldData():WldMd
		{
			return wldMd;
		}
		public function getKmjData():KmjMd
		{
			return kmjMd;
		}
		public function getFoodData():EatFoodMd
		{
			return eatfood;
		}
	}
}