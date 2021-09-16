package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxRandom;

class Person extends FlxSprite
{
    private var _map:GameMap;

    private var MAX_SPEED:Float = 200.0;

    public function new(X:Float, Y:Float, map:GameMap)
    {
        super(X, Y);
        loadGraphic("assets/images/keks0" + Std.string(FlxRandom.intRanged(1,4)) + ".png", true, 54, 54);
        animation.add("walk", [0, 1], 8, true);
        animation.play("walk");
        _map = map;

        velocity.x = FlxRandom.floatRanged(-1.0, 1.0) * MAX_SPEED;
        velocity.y = FlxRandom.floatRanged(-1.0, 1.0) * MAX_SPEED;
    }

    override public function update():Void
    {
        if (alive) {
            if (x < 0) {
                x = _map._width * _map._tileSize;
            }
            if (y < 0) {
                y = _map._height * _map._tileSize;
            }
            if (x > _map._width * _map._tileSize) {
                x = 0;
            }
            if (y > _map._height * _map._tileSize) {
                y = 0;
            }
        }
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}
