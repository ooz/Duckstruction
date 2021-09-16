package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxRandom;

class Building extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);
        switch (FlxRandom.intRanged(1, 2)) {
            case 1:
                loadGraphic("assets/images/haus1_new.png", true, 105, 272);
                y -= 272;
            case 2:
                loadGraphic("assets/images/haus2_new.png", true, 105, 244);
                y -= 244;
        }
        animation.add("destroyed", [1], 1, true);
    }

    override public function update():Void
    {
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    override public function kill():Void
    {
        alive = false;
        animation.play("destroyed");
    }
}
