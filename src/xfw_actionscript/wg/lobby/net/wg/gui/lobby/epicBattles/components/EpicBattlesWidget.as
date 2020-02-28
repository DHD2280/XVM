package net.wg.gui.lobby.epicBattles.components
{
    import net.wg.infrastructure.base.meta.impl.EpicBattlesWidgetMeta;
    import net.wg.infrastructure.base.meta.IEpicBattlesWidgetMeta;
    import net.wg.gui.lobby.hangar.alertMessage.AlertMessageBlock;
    import flash.display.MovieClip;
    import net.wg.gui.lobby.hangar.quests.HeaderQuestsFlags;
    import net.wg.gui.lobby.epicBattles.data.EpicBattlesWidgetVO;
    import flash.events.MouseEvent;
    import net.wg.gui.lobby.hangar.quests.HeaderQuestsEvent;
    import scaleform.clik.constants.InvalidationType;

    public class EpicBattlesWidget extends EpicBattlesWidgetMeta implements IEpicBattlesWidgetMeta
    {

        private static const BG_NORMAL_Y_OFFSET:int = -1;

        private static const ALERT_BG_Y_OFFSET:int = 39;

        public var calendarStatus:AlertMessageBlock = null;

        public var button:EpicBattlesWidgetButton = null;

        public var bg:MovieClip = null;

        public var questsFlags:HeaderQuestsFlags = null;

        private var _data:EpicBattlesWidgetVO = null;

        public function EpicBattlesWidget()
        {
            super();
        }

        override protected function configUI() : void
        {
            super.configUI();
            this.button.addEventListener(MouseEvent.CLICK,this.onClickHandler);
            this.calendarStatus.x = -this.calendarStatus.width >> 1;
            this.mouseEnabled = false;
            this.bg.mouseEnabled = this.bg.mouseChildren = false;
            this.questsFlags.addEventListener(HeaderQuestsEvent.HEADER_QUEST_CLICK,this.onBtnHeaderQuestClickHandler);
        }

        override protected function onDispose() : void
        {
            this.questsFlags.removeEventListener(HeaderQuestsEvent.HEADER_QUEST_CLICK,this.onBtnHeaderQuestClickHandler);
            this.questsFlags.dispose();
            this.questsFlags = null;
            this.button.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
            this.calendarStatus.dispose();
            this.calendarStatus = null;
            this.bg = null;
            this.button.dispose();
            this.button = null;
            if(this._data)
            {
                this._data.dispose();
                this._data = null;
            }
            super.onDispose();
        }

        override protected function setData(param1:EpicBattlesWidgetVO) : void
        {
            this._data = param1;
            this.button.setData(param1);
            invalidateData();
        }

        override protected function draw() : void
        {
            super.draw();
            if(isInvalid(InvalidationType.DATA) && this._data != null)
            {
                this.calendarStatus.visible = this._data.showAlert;
                this.calendarStatus.setLocalData(this._data.calendarStatus);
                this.calendarStatus.btnClickHandler = onChangeServerClickS;
                this.questsFlags.y = this.button.y = this.bg.y = this._data.showAlert?ALERT_BG_Y_OFFSET:BG_NORMAL_Y_OFFSET;
                this.questsFlags.setData(this._data.questsGroups);
            }
            if(isInvalid(InvalidationType.SIZE))
            {
                this.button.updateSize();
            }
        }

        private function onBtnHeaderQuestClickHandler(param1:HeaderQuestsEvent) : void
        {
            onQuestBtnClickS(param1.questType,param1.questID);
        }

        private function onClickHandler(param1:MouseEvent) : void
        {
            onWidgetClickS();
        }
    }
}
