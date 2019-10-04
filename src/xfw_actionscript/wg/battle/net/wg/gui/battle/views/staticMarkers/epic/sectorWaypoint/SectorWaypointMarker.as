package net.wg.gui.battle.views.staticMarkers.epic.sectorWaypoint
{
    import flash.display.Sprite;
    import net.wg.infrastructure.interfaces.entity.IDisposable;
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class SectorWaypointMarker extends Sprite implements IDisposable
    {

        public const markerType:String = "waypoint";

        public var marker:SectorWaypointIcon = null;

        public var arrow:MovieClip = null;

        public var txtLabel:TextField = null;

        public function SectorWaypointMarker()
        {
            super();
            this.marker.visible = true;
            this.arrow.visible = false;
            this.txtLabel.visible = false;
        }

        public function clearCountdown() : void
        {
        }

        public final function dispose() : void
        {
            this.marker.dispose();
            this.marker = null;
            this.arrow = null;
            this.txtLabel = null;
        }

        public function isAttacker(param1:Boolean) : void
        {
            this.marker.isAttacker(param1);
        }

        public function setCountdown(param1:String) : void
        {
        }
    }
}
