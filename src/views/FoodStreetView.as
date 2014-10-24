package views
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import core.baseComponent.CCScrollBar;
	import core.baseComponent.CImage;
	import core.fontFormat.CFontFormat;
	
	import models.AtlaMd;
	import models.FoodMd;
	
	
	public class FoodStreetView extends Sprite
	{
		private var modeArray:Array;
		private var SELF_WIDHT:int = 1000 + 14;
		private var SELF_HEIGHT:int = 800;
		private var detailSprite:Sprite;
		private var cscroll:CCScrollBar;
		public function FoodStreetView(_md:FoodMd)
		{
			super();
			
			var bg:Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRoundRect(0,0,SELF_WIDHT,SELF_HEIGHT,20,20);
			bg.graphics.endFill();
			this.addChild(bg);
			
			modeArray = _md.itemArr;
			
			var nameText:TextField = new TextField();
			nameText.text = _md.name;
			nameText.x = 22;
			nameText.y = 25;
			nameText.setTextFormat(CFontFormat.getTravelDetailTitleFormat());
			nameText.width = 500;
			addChild(nameText);
			
//			var sourceTxt:TextField = new TextField();
//			sourceTxt.text = _md.noteTime + " 来源: " + _md.noteSource;
//			var sourceFor:TextFormat = new TextFormat(null,16,0x757575);
//			sourceTxt.setTextFormat(sourceFor);
//			addChild(sourceTxt);
//			sourceTxt.width = 500;
//			sourceTxt.x = 22;
//			sourceTxt.y = 55;
			
			var closeImage:CImage = new CImage(66,58,true,false);
			closeImage.url = "source/public/close.png";
			addChild(closeImage);
			closeImage.x = SELF_WIDHT - closeImage.width;
			closeImage.y = 5;
			closeImage.addEventListener(MouseEvent.CLICK,closeHandler);
			
			var line:Shape = new Shape();
			line.graphics.lineStyle(3,0xf2f2f2);
			line.graphics.moveTo(22,85);
			line.graphics.lineTo(SELF_WIDHT - 22,85);
			this.addChild(line);
			
			detailSprite = new Sprite();
			scrollSrpte = new Sprite();
			scrollSrpte.y = 67 + 20;
			scrollSrpte.x = 22;
			addChild(scrollSrpte);
			var barArray:Array = ["source/public/scroll_slider.png","source/public/scroll_bg.png"];
			cscroll = new CCScrollBar(SELF_WIDHT - 35,SELF_HEIGHT - scrollSrpte.y - 10,barArray);
			cscroll.target = detailSprite;
			scrollSrpte.addChild(cscroll);
			initContent();
		}
		private function closeHandler(event:MouseEvent):void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		private var scrollSrpte:Sprite;
		private function initContent():void
		{
			var detailCell:FoodStreetCell;
			var currentY:int = 0;
			for each(var md:AtlaMd in modeArray)
			{
				detailCell = new FoodStreetCell(md);
				detailCell.y = currentY;
				detailSprite.addChild(detailCell);
				currentY += detailCell.cellHeight;
			}
			if(currentY > SELF_HEIGHT)
			{
				cscroll.changeScrollBarState(true);
			}else{
				cscroll.changeScrollBarState(false);
			}
		}
	}
}