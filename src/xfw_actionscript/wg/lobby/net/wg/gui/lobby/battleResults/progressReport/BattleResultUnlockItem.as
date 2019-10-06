package net.wg.gui.lobby.battleResults.progressReport
{
    import net.wg.infrastructure.base.UIComponentEx;
    import net.wg.gui.lobby.interfaces.ISubtaskComponent;
    import scaleform.clik.core.UIComponent;
    import net.wg.gui.components.controls.UILoaderAlt;
    import net.wg.gui.components.controls.SoundButtonEx;
    import flash.text.TextField;
    import net.wg.gui.components.controls.price.CompoundPrice;
    import scaleform.clik.events.ButtonEvent;
    import net.wg.gui.components.controls.VO.ItemPriceVO;

    public class BattleResultUnlockItem extends UIComponentEx implements ISubtaskComponent
    {

        private static const LINK_BTN_OFFSET:int = 5;

        public var fittingIcon:UIComponent;

        public var vehicleIcon:UILoaderAlt;

        public var tankmenIcon:UILoaderAlt;

        public var lvlIcon:UILoaderAlt;

        public var linkBtn:SoundButtonEx;

        public var title:TextField;

        public var description:TextField;

        public var price:CompoundPrice;

        public var prediction:TextField;

        private var _itemData:BattleResultUnlockItemVO;

        public function BattleResultUnlockItem()
        {
            super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            this.price.actionState = CompoundPrice.ACTION_STATE_SHOW_VALUE;
            this.price.itemsDirection = CompoundPrice.DIRECTION_LEFT;
            this.linkBtn.addEventListener(ButtonEvent.CLICK,this.onLinkBtnClickHandler);
        }

        override protected function onDispose() : void
        {
            this.linkBtn.removeEventListener(ButtonEvent.CLICK,this.onLinkBtnClickHandler);
            this._itemData.dispose();
            this._itemData = null;
            this.fittingIcon.dispose();
            this.fittingIcon = null;
            this.vehicleIcon.dispose();
            this.vehicleIcon = null;
            this.tankmenIcon.dispose();
            this.tankmenIcon = null;
            this.lvlIcon.dispose();
            this.lvlIcon = null;
            this.linkBtn.dispose();
            this.linkBtn = null;
            this.title = null;
            this.description = null;
            this.price.dispose();
            this.price = null;
            this.prediction = null;
            super.onDispose();
        }

        public function disableLinkBtns(param1:Vector.<String>) : void
        {
        }

        public function setData(param1:Object) : void
        {
            this._itemData = new BattleResultUnlockItemVO(param1);
            this.fittingIcon.visible = this._itemData.fittingType.length > 0;
            if(this.fittingIcon.visible)
            {
                this.fittingIcon.gotoAndStop(this._itemData.fittingType);
            }
            this.initIcon(this.vehicleIcon,this._itemData.vehicleIcon);
            this.initIcon(this.tankmenIcon,this._itemData.tankmenIcon);
            this.initIcon(this.lvlIcon,this._itemData.lvlIcon);
            this.linkBtn.visible = this._itemData.linkEvent.length > 0;
            this.title.text = this._itemData.title;
            App.utils.commons.moveDsiplObjToEndOfText(this.linkBtn,this.title,LINK_BTN_OFFSET);
            this.description.htmlText = this._itemData.description;
            if(this._itemData.price)
            {
                this.price.setData(new ItemPriceVO(this._itemData.price[0]));
            }
            this.prediction.text = this._itemData.prediction;
        }

        private function initIcon(param1:UILoaderAlt, param2:String) : void
        {
            if(param2.length > 0)
            {
                param1.visible = true;
                param1.source = param2;
            }
            else
            {
                param1.visible = false;
            }
        }

        private function onLinkBtnClickHandler(param1:ButtonEvent) : void
        {
            dispatchEvent(new UnlockLinkEvent(this._itemData.linkEvent,this._itemData.linkId));
        }
    }
}
