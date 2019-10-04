package net.wg.gui.login
{
    import net.wg.infrastructure.interfaces.entity.IDisposable;
    import flash.geom.Rectangle;
    import flash.display.Sprite;

    public interface ISparksManager extends IDisposable
    {

        function resetZone(param1:Rectangle) : void;

        function createSparks() : void;

        function get zone() : Rectangle;

        function set zone(param1:Rectangle) : void;

        function get scope() : Sprite;

        function set scope(param1:Sprite) : void;

        function get sparkQuantity() : Number;

        function set sparkQuantity(param1:Number) : void;
    }
}
