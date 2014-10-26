package Json
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import models.ActiveItemMd;
	import models.ActiveMd;
	import models.AtlaMd;
	import models.ButtonMd;
	import models.EatFoodMd;
	import models.HomeMD;
	import models.KmjMd;
	import models.KmjPointMd;
	import models.LineItemMd;
	import models.LineMd;
	import models.LinePageMd;
	import models.PointMd;
	import models.RouteItemMd;
	import models.RouteMd;
	import models.TelMd;
	import models.WldItemDetailMd;
	import models.WldItemMd;
	import models.WldMd;
	
	import pages.LinePage;
	

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
		private var activeMd:ActiveMd;
		private var eatfood:EatFoodMd;
		private var telMd:TelMd;
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
			lineMd.bg = lineData.background;
			lineMd.desc = lineData.desc;
			lineMd.pageArr = new Array();
			var pageMd:LinePageMd;
			for each(var obj:Object in lineData.page)
			{
				pageMd = new LinePageMd();
				pageMd.name = obj.name;
				pageMd.bg = obj.background;
				pageMd.itemArr = new Array();
				var lineItemMd:LineItemMd;
				for each(var iobj:Object in obj.items)
				{
					lineItemMd = new LineItemMd();
					lineItemMd.name = iobj.name;
					lineItemMd.skin = iobj.skin;
					lineItemMd.coordXY = new Point();
					lineItemMd.coordXY.x = iobj.coordXY[0];
					lineItemMd.coordXY.y = iobj.coordXY[1];
					pageMd.itemArr.push(lineItemMd);
				}
				lineMd.pageArr.push(pageMd);
			}
			
			///玩乐地
			wldMd = new WldMd();
			var wldData:Object = data.WLD;
			wldMd.name = wldData.name;
			wldMd.background = wldData.background;
			wldMd.itemArr = new Array();
			var wlditemMd:WldItemMd;
			for each(var po:Object in wldData.items)
			{
				wlditemMd = new WldItemMd();
				wlditemMd.name = po.name;
				wlditemMd.url = po.url;
				wlditemMd.skinsArr = po.skin;
				
				wlditemMd.detailArr = new Array();
				var dMd:WldItemDetailMd;
				for each(var dobj:Object in po.detail)
				{
					dMd = new WldItemDetailMd();
					dMd.name = dobj.name;
					dMd.url = dobj.url;
					dMd.coordXY = new Point();
					dMd.coordXY.x = dobj.coordXY[0];
					dMd.coordXY.y = dobj.coordXY[1];
					dMd.skin = dobj.skin;
//					wlditemMd.skinsArr.push(dobj.skin);
					wlditemMd.detailArr.push(dMd);
				}
				
				wldMd.itemArr.push(wlditemMd);
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
			var actData:Object = data.ACTIVITY;
			activeMd = new ActiveMd();
			activeMd.name = actData.name;
			activeMd.bg = actData.background;
			activeMd.itemArr = new Array();
			
			var acitem:ActiveItemMd;
			for each(var aco:Object in actData.items)
			{
				acitem = new ActiveItemMd();
				acitem.name = aco.name;
				acitem.desc = aco.desc;
				acitem.label = aco.label;
				acitem.content = aco.detail;
				acitem.coordXY = new Point();
				acitem.coordXY.x = aco.coordXY[0];
				acitem.coordXY.y = aco.coordXY[1];
				activeMd.itemArr.push(acitem);
			}
			
			// 吃美食
			
			var eatData:Object = data.EATFOOD;
			eatfood = new EatFoodMd();
			eatfood.bg = eatData.background;
			eatfood.dsc = eatData.desc;
			eatfood.btnArr = new Array();
			eatfood.altArr = new Array();
			eatfood.beginIndexArr = new Array();
			
			//美食街
			var foodstreetData:Object = eatData.footstreet;
			eatfood.btnArr.push(foodstreetData.skin);
			var altmd:AtlaMd;
			var num:int = 0;
			eatfood.beginIndexArr.push(num);
			for each(var imd:Object in foodstreetData.items)
			{
				altmd = new AtlaMd();
				altmd.name = imd.name;
				altmd.desc = imd.dsc;
				altmd.url = imd.picture;
				eatfood.altArr.push(altmd);
				
				num++;
			}
			trace("num = ",num);
			eatfood.beginIndexArr.push(num);
			
			//美食
			var foodData:Object = eatData.food;
			eatfood.btnArr.push(foodData.skin);
			for each(var fmd:Object in foodData.items)
			{
				altmd = new AtlaMd();
				altmd.name = fmd.name;
				altmd.desc = fmd.dsc;
				altmd.url = fmd.picture;
				eatfood.altArr.push(altmd);
				num++;
			}
			trace("num2 = ",num);
			eatfood.beginIndexArr.push(num);
			
			
			//商业
			var busData:Object = eatData.business;
			eatfood.btnArr.push(busData.skin);
			for each(var bo:Object in busData.items)
			{
				altmd = new AtlaMd();
				altmd.name = bo.name;
				altmd.desc = bo.dsc;
				altmd.url = bo.picture;
				eatfood.altArr.push(altmd);
			}
			
			// 电话簿
			
			telMd = new TelMd();
			var telData:Object = data.TEL;
			telMd.name = telData.name;
			telMd.contentArr = telData.content;
			telMd.dsc = telData.desc;
			
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
		public function getActiveData():ActiveMd
		{
			return activeMd;
		}
		public function getTelData():TelMd
		{
			return telMd;
		}
	}
}