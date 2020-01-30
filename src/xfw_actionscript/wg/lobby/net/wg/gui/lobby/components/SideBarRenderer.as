package net.wg.gui.lobby.components
{
    import net.wg.gui.components.controls.SoundListItemRenderer;
    import flash.display.MovieClip;
    import net.wg.infrastructure.managers.ITooltipMgr;
    import flash.events.MouseEvent;
    import scaleform.clik.constants.InvalidationType;
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;
    import net.wg.data.constants.SoundTypes;

    public class SideBarRenderer extends SoundListItemRenderer
    {

        public var tooltip:String;

        public var iconUp:MovieClip;

        public var iconHover:MovieClip;

        private var _isTooltipShown:Boolean;

        private var _toolTipMgr:ITooltipMgr;

        public function SideBarRenderer()
        {
            super();
            preventAutosizing = true;
            allowDeselect = false;
            mouseEnabledOnDisabled = true;
            soundType = SoundTypes.MAIN_MENU;
            this._toolTipMgr = App.toolTipMgr;
        }

        override protected function changeFocus() : void
        {
            if(selected)
            {
                return;
            }
            super.changeFocus();
        }

        override protected function onDispose() : void
        {
            removeEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
            removeEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
            this.iconUp = null;
            this.iconHover = null;
            this._toolTipMgr = null;
            super.onDispose();
        }

        override protected function configUI() : void
        {
            super.configUI();
            addEventListener(MouseEvent.ROLL_OVER,this.onMouseRollOverHandler);
            addEventListener(MouseEvent.ROLL_OUT,this.onMouseRollOutHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
        }

        override protected function draw() : void
        {
            super.draw();
            if(data && isInvalid(InvalidationType.DATA))
            {
                this.iconUp.gotoAndStop(data.id);
                this.iconHover.gotoAndStop(data.id);
            }
        }

        protected function showTooltip() : void
        {
            if(this.tooltip)
            {
                this._isTooltipShown = true;
                this._toolTipMgr.showComplex(this.tooltip);
            }
        }

        private function hideTooltip() : void
        {
            if(this._isTooltipShown)
            {
                this._isTooltipShown = false;
                this._toolTipMgr.hide();
            }
        }

        override public function set selected(param1:Boolean) : void
        {
            enabled = buttonMode = !param1;
            super.selected = param1;
        }

        override public function set data(param1:Object) : void
        {
            super.data = param1;
            invalidateData();
        }

        public function get counterTarget() : DisplayObject
        {
            return this.iconUp;
        }

        private function onMouseDownHandler(param1:MouseEvent) : void
        {
            this.hideTooltip();
        }

        private function onMouseRollOverHandler(param1:MouseEvent) : void
        {
            this.showTooltip();
        }

        private function onMouseRollOutHandler(param1:MouseEvent) : void
        {
            this.hideTooltip();
        }

        override public function getBounds(param1:DisplayObject) : Rectangle
        {
            if(hitArea != null)
            {
                return hitArea.getBounds(param1);
            }
            return super.getBounds(param1);
        }
    }
}
