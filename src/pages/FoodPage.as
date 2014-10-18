package pages
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import core.baseComponent.CButton;
	import core.baseComponent.CImage;
	
	import models.EatFoodMd;
	import models.YAConst;
	
	import views.FoodStreetView;
	
	public class FoodPage extends Sprite
	{
		private var eatmd:EatFoodMd;
		public function FoodPage(_md:EatFoodMd)
		{
			super();
			
			eatmd = _md;
			
			var bg:CImage = new CImage(YAConst.SCREEN_WIDTH,YAConst.SCREEN_HEIGHT,false);
			addChild(bg);
			bg.url = eatmd.bg;
			
			var arr:Array = ["source/public/back_up.png","source/public/back_up.png"];
			var backBtn:CButton = new CButton(arr,false);
			backBtn.addEventListener(MouseEvent.CLICK,backHandler);
			addChild(backBtn);
			backBtn.x = 30;
			backBtn.y = 30;
			
			initButton();
		}
		private var contentSprite:Sprite;
		private var beginX:int = 200;
		private function initButton():void
		{
			var btn:CButton;
			var i:int = 0;
			for each(var arr:Array in eatmd.btnArr)
			{
				btn = new CButton(arr,false,false);
				btn.data =i;
				btn.addEventListener(MouseEvent.CLICK,clickHandler);
				btn.x = beginX + i * 200;
				addChild(btn);
				i++;
			}
			
			contentSprite = new Sprite();
			contentSprite.x = 450;
			contentSprite.y = 120;
			addChild(contentSprite);
		}
		private function clickHandler(event:MouseEvent):void
		{
			var cb:CButton = event.currentTarget as CButton;
			switch(cb.data)
			{
				case 0:
					break;
				case 1:
					var foodView:FoodStreetView = new FoodStreetView(eatmd.food);
					contentSprite.addChild(foodView);
					break;
				case 2:
					break;
			}
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