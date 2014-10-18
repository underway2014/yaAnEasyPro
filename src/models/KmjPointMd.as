package models
{
	import flash.geom.Point;

	public class KmjPointMd
	{
		public function KmjPointMd()
		{
		
		}
		public var name:String;
		public var pointXY:Point;
		public var skinArr:Array;
		public var spotMd:PointMd; // spotId 对应 ALLspots 中的一个景点
		public var type:int; // 区分 全市 / ..区 / ..区
	}
}