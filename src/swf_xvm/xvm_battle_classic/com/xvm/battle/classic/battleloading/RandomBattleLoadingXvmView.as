/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.battle.classic.battleloading
{
    import com.xfw.*;
    import com.xvm.infrastructure.XvmViewBase;
    import net.wg.data.constants.generated.BATTLE_VIEW_ALIASES;
    import net.wg.gui.battle.random.views.BattlePage;
    import net.wg.infrastructure.events.LifeCycleEvent;
    import net.wg.infrastructure.interfaces.IView;
    import net.wg.infrastructure.helpers.statisticsDataController.BattleStatisticDataController;
    import net.wg.infrastructure.helpers.statisticsDataController.intarfaces.IBattleComponentDataController;

    public class RandomBattleLoadingXvmView extends XvmViewBase
    {
        public function RandomBattleLoadingXvmView(view:IView)
        {
            super(view);
        }

        public function get page():BattlePage
        {
            return super.view as BattlePage;
        }

        public override function onAfterPopulate(e:LifeCycleEvent):void
        {
            super.onAfterPopulate(e);
            init();
        }

        // PRIVATE

        private function init():void
        {
            page.unregisterComponent(BATTLE_VIEW_ALIASES.BATTLE_LOADING);
            var bsdc:BattleStatisticDataController = XfwAccess.getPrivateField(page, 'battleStatisticDataController');
            var cc:Vector.<IBattleComponentDataController> = XfwAccess.getPrivateField(bsdc, '_componentControllers');

            cc.splice(cc.indexOf(page.battleLoading), 1);
            var idx:int = page.getChildIndex(page.battleLoading);
            page.removeChild(page.battleLoading);
            var component:UI_RandomBattleLoading = new UI_RandomBattleLoading();
            component.x = page.battleLoading.x;
            component.y = page.battleLoading.y;
            component.setCompVisible(page.battleLoading.visible);
            page.battleLoading = component;
            page.addChildAt(page.battleLoading, idx);
            bsdc.registerComponentController(page.battleLoading);
            XfwAccess.getPrivateField(page, 'registerComponent')(page.battleLoading, BATTLE_VIEW_ALIASES.BATTLE_LOADING);
        }
    }
}
