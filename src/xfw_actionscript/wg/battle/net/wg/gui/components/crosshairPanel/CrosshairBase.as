package net.wg.gui.components.crosshairPanel
{
    import flash.display.MovieClip;
    import flash.text.TextField;
    import net.wg.gui.components.crosshairPanel.components.CrosshairClipQuantityBarContainer;
    import flash.display.Sprite;
    import net.wg.gui.components.crosshairPanel.components.autoloader.AutoloaderIndicator;
    import net.wg.gui.components.crosshairPanel.constants.CrosshairConsts;
    import net.wg.data.constants.generated.CROSSHAIR_CONSTANTS;
    import net.wg.data.constants.Values;
    import flash.external.ExternalInterface;

    public class CrosshairBase extends MovieClip implements ICrosshair
    {

        private static const FRACTIONAL_FORMAT_CMD:String = "WG.getFractionalFormat";

        protected static const TYPE_PREFIX:String = "type";

        public var timerProgressTextField:TextField = null;

        public var timerCompleteTextField:TextField = null;

        public var reloadingBar:MovieClip = null;

        public var reloadingAnimationMC:MovieClip = null;

        public var healthBarMC:MovieClip = null;

        public var ammoLowTextField:TextField = null;

        public var ammoNormalTextField:TextField = null;

        public var cassetteMC:CrosshairClipQuantityBarContainer = null;

        public var centerMC:MovieClip = null;

        public var netMC:Sprite = null;

        public var netSeparator:Sprite = null;

        public var distance:CrosshairDistanceContainer = null;

        public var autoloaderComponent:AutoloaderIndicator = null;

        protected var health:Number = 0;

        protected var reloadingTime:Number = 0;

        protected var netType:Number = 0;

        protected var centerType:Number = 0;

        protected var reloadingState:String = "";

        protected var centerAlpha:Number = 1.0;

        protected var netAlpha:Number = 1.0;

        protected var reloadingBarAlpha:Number = 1.0;

        protected var healthBarAlpha:Number = 1.0;

        protected var cassetteAlpha:Number = 1.0;

        protected var reloadingTimeFieldAlpha:Number = 1.0;

        private var _isAutoloader:Boolean = false;

        private var _currentTimerTextField:TextField = null;

        private var _currentReloadingTime:Number = -1;

        private var _isReloadInProgress:Boolean = false;

        private var _currentAmmoTextField:TextField = null;

        private var _count:Number = -1;

        private var _isLow:Boolean = false;

        private var _isUseFrameAnimation:Boolean = true;

        public function CrosshairBase()
        {
            super();
            this.cassetteMC.isUseFrameAnimation = this._isUseFrameAnimation;
            this.timerProgressTextField.visible = false;
            this.timerCompleteTextField.visible = true;
            this.ammoLowTextField.visible = false;
            this.ammoNormalTextField.visible = true;
        }

        public function autoloaderShowShot() : void
        {
            if(this._isAutoloader)
            {
                this.autoloaderComponent.autoloaderShowShot();
            }
        }

        public function autoloaderUpdate(param1:Number, param2:Number, param3:Boolean) : void
        {
            this.autoloaderComponent.autoloaderUpdate(param1,param2,param3);
        }

        public function clearDistance(param1:Boolean) : void
        {
            this.distance.clearDistance(param1);
        }

        public function dispose() : void
        {
            this.timerProgressTextField = null;
            this.timerCompleteTextField = null;
            this._currentTimerTextField = null;
            this.ammoLowTextField = null;
            this.ammoNormalTextField = null;
            this._currentAmmoTextField = null;
            this.reloadingBar = null;
            this.reloadingAnimationMC = null;
            this.healthBarMC = null;
            this.cassetteMC = null;
            this.centerMC = null;
            this.netMC = null;
            this.netSeparator = null;
            if(this.autoloaderComponent)
            {
                this.autoloaderComponent.dispose();
                this.autoloaderComponent = null;
            }
            if(this.distance)
            {
                this.distance.dispose();
                this.distance = null;
            }
        }

        public function setAmmoStock(param1:Number, param2:Number, param3:Boolean, param4:String, param5:Boolean = false) : void
        {
            this.setAmmoCount(param1,param3);
            if(this._isAutoloader)
            {
                this.autoloaderComponent.updateCurrentAmmo(param2);
            }
            else
            {
                this.cassetteMC.updateInfo(param2,param4,param5);
            }
        }

        public function setAutoloaderReloadingAsPercent(param1:Number, param2:Boolean) : void
        {
            this.autoloaderComponent.setGunReloadingPercent(param1,param2);
        }

        public function setCenterType(param1:Number) : void
        {
            if(this.centerType != param1)
            {
                this.centerType = param1;
                this.updateCenterMC();
            }
        }

        public function setClipsParam(param1:Number, param2:Number, param3:Boolean = false) : void
        {
            this._isAutoloader = param3;
            this.setNetSeparatorVisible();
            if(this._isAutoloader)
            {
                this.autoloaderComponent.updateTotalAmmo(param1);
                this.ammoNormalTextField.visible = false;
                this.ammoLowTextField.visible = false;
            }
            else
            {
                this.cassetteMC.setClipsParam(param1,param2);
            }
            if(this.autoloaderComponent)
            {
                this.autoloaderComponent.visible = this._isAutoloader;
            }
            this.cassetteMC.visible = !this._isAutoloader;
        }

        public function setComponentsAlpha(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
        {
            this.netAlpha = param1;
            this.centerAlpha = param2;
            this.reloadingBarAlpha = param3;
            this.healthBarAlpha = param4;
            this.cassetteAlpha = param5;
            this.setReloadingAlpha(param6);
            this.updateComponentsAlpha();
        }

        public function setDistance(param1:String) : void
        {
            this.distance.setDistance(param1);
        }

        public function setDistanceVisibility(param1:Boolean) : void
        {
        }

        public function setHealth(param1:Number) : void
        {
            if(this.health == param1)
            {
                return;
            }
            this.health = param1;
            this.updateHealthBarMC();
        }

        public function setInfo(param1:Number, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:String, param7:String, param8:Number, param9:Number, param10:String, param11:Number, param12:Number, param13:Boolean, param14:String, param15:Boolean = false, param16:Boolean = false, param17:Boolean = false) : void
        {
            this.setClipsParam(param8,param9,param16);
            this.setHealth(param1);
            this.setZoom(param2);
            this.setReloadingState(param3);
            this.showReloadingTimeField(param4);
            this.setDistanceVisibility(param5);
            this.setDistance(param6);
            this.updatePlayerInfo(param7);
            this.setAmmoStock(param11,param12,param13,param14,param15);
            this.updateAmmoState(param10);
            this.updateAutoloaderState(param8,param12,param17);
        }

        public function setNetType(param1:Number) : void
        {
            if(this.netType != param1)
            {
                this.netType = param1;
                this.updateNetType();
                this.updateCenterMC();
                this.updateComponentsAlpha();
                this.updateHealthBarMC();
                this.setReloadingBarFrame();
                this.updateAmmoCount();
                this.setNetSeparatorVisible();
            }
        }

        public function setReloadingAsPercent(param1:Number) : void
        {
            if(this.reloadingTime == param1)
            {
                return;
            }
            this.reloadingTime = param1;
            this.setReloadingBarFrame();
        }

        public function setReloadingState(param1:String) : void
        {
            if(this.reloadingState != param1)
            {
                this.reloadingState = param1;
                this.updateReloadingState();
            }
        }

        public function setReloadingTime(param1:Number) : void
        {
            if(this._currentReloadingTime != param1)
            {
                this._currentReloadingTime = param1 < 0?0:param1;
                this.applyReloadingData();
            }
        }

        public function setTimerReloadingState() : void
        {
            var _loc1_:* = !(this.reloadingState == CrosshairConsts.RELOADING_ENDED || this.reloadingState == CrosshairConsts.RELOADING_END);
            var _loc2_:* = this._currentTimerTextField == this.timerProgressTextField;
            var _loc3_:* = this._currentTimerTextField == this.timerCompleteTextField;
            if(this._isReloadInProgress == _loc1_ && this._currentTimerTextField && (_loc2_ || _loc3_))
            {
                return;
            }
            this._isReloadInProgress = _loc1_;
            if(this._currentTimerTextField)
            {
                this.timerProgressTextField.visible = false;
                this.timerCompleteTextField.visible = false;
            }
            this._currentTimerTextField = this._isReloadInProgress?this.timerProgressTextField:this.timerCompleteTextField;
            this._currentTimerTextField.visible = true;
            this.applyReloadingData();
            this.applyReloadingAlpha();
        }

        public function setVisibleNet(param1:int) : void
        {
            this.netMC.visible = (param1 & CROSSHAIR_CONSTANTS.VISIBLE_NET) != 0;
            this.showAmmoCountField((param1 & CROSSHAIR_CONSTANTS.VISIBLE_AMMO_COUNT) != 0);
        }

        public function setZoom(param1:String) : void
        {
        }

        public function showAmmoCountField(param1:Boolean) : void
        {
            if(param1 && !this._isAutoloader)
            {
                if(this._currentAmmoTextField)
                {
                    this.ammoNormalTextField.visible = this.ammoNormalTextField == this._currentAmmoTextField;
                    this.ammoLowTextField.visible = this.ammoLowTextField == this._currentAmmoTextField;
                }
                else
                {
                    this.ammoNormalTextField.visible = true;
                    this.ammoLowTextField.visible = false;
                }
            }
            else
            {
                this.ammoNormalTextField.visible = false;
                this.ammoLowTextField.visible = false;
            }
        }

        public function showReloadingTimeField(param1:Boolean) : void
        {
            if(param1)
            {
                if(this._currentTimerTextField)
                {
                    this.timerCompleteTextField.visible = this.timerCompleteTextField == this._currentTimerTextField;
                    this.timerProgressTextField.visible = this.timerProgressTextField == this._currentTimerTextField;
                }
                else
                {
                    this.timerCompleteTextField.visible = true;
                    this.timerProgressTextField.visible = false;
                }
            }
            else
            {
                this.timerCompleteTextField.visible = false;
                this.timerProgressTextField.visible = false;
            }
        }

        public function updateAmmoState(param1:String) : void
        {
        }

        public function updateAutoloaderState(param1:Number, param2:Number, param3:Boolean) : void
        {
            if(this._isAutoloader)
            {
                this.autoloaderComponent.updateQuantityInClip(param2,param1);
                this.autoloaderComponent.updateCritical(param3);
            }
        }

        public function updateCritical(param1:Boolean) : void
        {
            if(this._isAutoloader)
            {
                this.autoloaderComponent.updateCritical(param1);
            }
        }

        public function updatePlayerInfo(param1:String) : void
        {
        }

        protected function updateNetType() : void
        {
            gotoAndStop(TYPE_PREFIX + this.netType);
        }

        protected function updateReloadingState() : void
        {
            this.setTimerReloadingState();
            if(this.reloadingState == CrosshairConsts.RELOADING_END)
            {
                this.reloadingAnimationMC.visible = true;
                this.reloadingAnimationMC.play();
            }
            else if(this.reloadingState == CrosshairConsts.RELOADING_ENDED)
            {
                this.reloadingAnimationMC.visible = true;
                this.reloadingAnimationMC.gotoAndStop(1);
            }
            else
            {
                this.reloadingAnimationMC.visible = false;
            }
        }

        private function setNetSeparatorVisible() : void
        {
            if(this.netSeparator)
            {
                this.netSeparator.visible = !this._isAutoloader;
            }
        }

        private function setAmmoCount(param1:Number, param2:Boolean) : void
        {
            if(!(this._isLow == param2 && this._currentAmmoTextField && (this._currentAmmoTextField == this.ammoLowTextField || this._currentAmmoTextField == this.ammoNormalTextField)))
            {
                this._isLow = param2;
                if(this._currentAmmoTextField)
                {
                    this.ammoLowTextField.visible = false;
                    this.ammoNormalTextField.visible = false;
                }
                this._currentAmmoTextField = this._isLow?this.ammoLowTextField:this.ammoNormalTextField;
                this._currentAmmoTextField.visible = !this._isAutoloader;
            }
            if(this._count != param1)
            {
                this._count = param1;
                this._currentAmmoTextField.text = this._count.toString();
            }
        }

        private function updateAmmoCount() : void
        {
            this.ammoLowTextField.visible = false;
            this.ammoNormalTextField.visible = false;
            this._currentAmmoTextField = this._isLow?this.ammoLowTextField:this.ammoNormalTextField;
            this._currentAmmoTextField.visible = !this._isAutoloader;
            this._currentAmmoTextField.text = this._count.toString();
        }

        private function setReloadingAlpha(param1:Number) : void
        {
            if(this.reloadingTimeFieldAlpha != param1)
            {
                this.reloadingTimeFieldAlpha = param1;
                this.applyReloadingAlpha();
            }
        }

        private function applyReloadingAlpha() : void
        {
            if(this._currentTimerTextField)
            {
                this._currentTimerTextField.alpha = this.reloadingTimeFieldAlpha;
            }
        }

        private function applyReloadingData() : void
        {
            var _loc1_:String = null;
            if(this._currentTimerTextField && this._currentReloadingTime != Values.DEFAULT_INT)
            {
                _loc1_ = ExternalInterface.call.apply(this,[FRACTIONAL_FORMAT_CMD,Number(this._currentReloadingTime)]);
                this._currentTimerTextField.text = _loc1_.slice(0,_loc1_.length - 1);
            }
        }

        private function updateCenterMC() : void
        {
            this.centerMC.gotoAndStop(TYPE_PREFIX + this.centerType);
        }

        private function updateHealthBarMC() : void
        {
            var _loc1_:* = 0;
            if(this.healthBarMC)
            {
                _loc1_ = CrosshairConsts.PROGRESS_TOTAL_FRAMES_COUNT * this.health;
                this.healthBarMC.gotoAndStop(_loc1_);
            }
        }

        private function setReloadingBarFrame() : void
        {
            var _loc1_:* = 0;
            if(this.reloadingBar)
            {
                this.updateReloadingState();
                _loc1_ = CrosshairConsts.PROGRESS_TOTAL_FRAMES_COUNT * this.reloadingTime;
                this.reloadingBar.gotoAndStop(_loc1_);
            }
        }

        private function updateComponentsAlpha() : void
        {
            this.centerMC.alpha = this.centerAlpha;
            if(this.netSeparator)
            {
                this.netSeparator.alpha = this.netAlpha;
            }
            this.netMC.alpha = this.netAlpha;
            this.healthBarMC.alpha = this.healthBarAlpha;
            this.reloadingBar.alpha = this.reloadingBarAlpha;
            this.reloadingAnimationMC.alpha = this.reloadingBarAlpha;
            this.cassetteMC.alpha = this.cassetteAlpha;
            this.autoloaderComponent.alpha = this.cassetteAlpha;
            this.ammoLowTextField.alpha = this.netAlpha;
            this.ammoNormalTextField.alpha = this.netAlpha;
        }

        public function set isUseFrameAnimation(param1:Boolean) : void
        {
            this._isUseFrameAnimation = param1;
        }
    }
}
