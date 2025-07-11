/**
 * XVM: eXtended Visualization Mod for World of Tanks.
 * https://modxvm.com/
 */
package com.xvm.battle.frontline.teamBasesPanel
{
    import com.xfw.*;
    import com.xvm.battle.shared.teamBasesPanel.UI_teamBasesPanel;
    import com.xvm.infrastructure.*;
    import flash.events.Event;
    import net.wg.data.constants.generated.BATTLE_VIEW_ALIASES;
    import net.wg.frontline.gui.battle.views.FrontlineBattlePage;
    import net.wg.gui.battle.random.views.teamBasesPanel.TeamBasesPanel;
    import net.wg.infrastructure.events.LifeCycleEvent;
    import net.wg.infrastructure.interfaces.IView;

    public class TeamBasesPanelXvmView extends XvmViewBase
    {
        public function TeamBasesPanelXvmView(view:IView)
        {
            super(view);
        }

        public function get battlePage():FrontlineBattlePage
        {
            return super.view as FrontlineBattlePage;
        }

        public override function onAfterPopulate(e:LifeCycleEvent):void
        {
            super.onAfterPopulate(e);
            init();
        }

        // PRIVATE

        private function init():void
        {
            battlePage.unregisterComponent(BATTLE_VIEW_ALIASES.TEAM_BASES_PANEL);
            var idx:int = battlePage.getChildIndex(battlePage.teamBasesPanelUI);
            battlePage.removeChild(battlePage.teamBasesPanelUI);
            var component:UI_teamBasesPanel = new UI_teamBasesPanel();
            component.x = battlePage.teamBasesPanelUI.x;
            component.y = battlePage.teamBasesPanelUI.y;
            component.visible = battlePage.teamBasesPanelUI.visible;
            battlePage.teamBasesPanelUI = component;
            battlePage.addChildAt(battlePage.teamBasesPanelUI, idx);
            XfwAccess.getPrivateField(battlePage, 'registerComponent')(battlePage.teamBasesPanelUI, BATTLE_VIEW_ALIASES.TEAM_BASES_PANEL);
        }
    }
}
