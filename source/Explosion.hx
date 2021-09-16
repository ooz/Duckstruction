package;

import flixel.FlxSprite;
import flixel.FlxG;

class Explosion extends FlxSprite
{
    public function new()
    {
        super();
        loadGraphic("assets/images/explosion4.png", true, 125, 128);
        animation.add("explode", [0, 1, 2, 3, 4, 5, 6], 12, false);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}
