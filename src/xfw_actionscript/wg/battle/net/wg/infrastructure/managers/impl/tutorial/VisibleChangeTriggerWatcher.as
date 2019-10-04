package net.wg.infrastructure.managers.impl.tutorial
{
    import flash.display.DisplayObject;
    import scaleform.clik.events.ComponentEvent;
    import flash.events.Event;

    public class VisibleChangeTriggerWatcher extends AbstractTriggerWatcher
    {

        private var _visible:Boolean = false;

        public function VisibleChangeTriggerWatcher(param1:String, param2:String)
        {
            super(param1,param2);
        }

        override public function start(param1:DisplayObject) : void
        {
            super.start(param1);
            param1.addEventListener(ComponentEvent.SHOW,this.onTargetVisibleChangeHandler);
            param1.addEventListener(ComponentEvent.HIDE,this.onTargetVisibleChangeHandler);
            this._visible = param1.visible;
            dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER_ACTIVATED,false,false,this._visible));
        }

        override public function stop() : void
        {
            target.removeEventListener(ComponentEvent.SHOW,this.onTargetVisibleChangeHandler);
            target.removeEventListener(ComponentEvent.HIDE,this.onTargetVisibleChangeHandler);
            super.stop();
        }

        private function onTargetVisibleChangeHandler(param1:Event) : void
        {
            if(target.visible != this._visible)
            {
                this._visible = target.visible;
                dispatchEvent(new TriggerEvent(TriggerEvent.TRIGGER_ACTIVATED,false,false,this._visible));
            }
        }
    }
}
