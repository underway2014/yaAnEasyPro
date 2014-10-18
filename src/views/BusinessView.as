package views
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.HScroller;
	import core.layout.Layout;
	
	import models.BusinessItemMd;
	import models.BusinessMd;
	
	public class BusinessView extends Sprite
	{
		private var SELF_WIDHT:int = 1000 + 14;
		private var SELF_HEIGHT:int = 800;
		private var md:BusinessMd;
		
		private var contain:Sprite;
		public function BusinessView(_md:BusinessMd)
		{
			super();
			
			md = _md;
			
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRoundRect(0,0,SELF_WIDHT,SELF_HEIGHT,20,20);
			this.graphics.endFill();
			
			contain = new Sprite();
			var scroll:HScroller = new HScroller(SELF_WIDHT,SELF_HEIGHT);
			scroll.target = contain;
			addChild(scroll);
			
			initList();
		}
		private function initList():void
		{
			var itemCell:BusinessCell;
			var n:int = 0;
			for each(var itemMd:BusinessItemMd in md.itemArr)
			{
				itemCell = new BusinessCell(itemMd);
				itemCell.addEventListener(MouseEvent.CLICK,clickHandler);
				itemCell.data = itemMd;
				
				itemCell.x = n %2 * 470;
				itemCell.y = Math.floor(n / 2) * 120;
				n++;
			}
		}
		private function clickHandler(evet:MouseEvent):void
		{
			
		}
	}
}