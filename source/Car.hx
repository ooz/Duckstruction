package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class Car extends FlxSprite
{
    private var _map:GameMap;

    private var _speed:Float;

    public function new(x:Float, y:Float, map:GameMap)
    {
        super(x, y);
        _map = map;
        switch (FlxRandom.intRanged(0, 1)) {
            case 0:
                _speed = -350.0;
            case 1:
                _speed = 350.0;
        }
        //makeGraphic(64, 64, 0xFFFF0000);
        loadGraphic("assets/images/hamster_all.png", true, 90, 90);
        setFacingFlip(FlxObject.LEFT, true, false);
        animation.add("roll", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], 20, true);
        animation.add("rollfront", [16, 17, 18, 19, 20, 21, 22, 23], 12, true);
        animation.add("rollback", [25, 26, 27, 28, 29, 30, 31, 32], 12, true);
        animation.add("stop", [24], 1, true);
    }

//	override public function draw():Void 
//	{
//		if (velocity.x != 0 || velocity.y != 0)
//		{
//			switch(facing)
//			{
//				case FlxObject.LEFT, FlxObject.RIGHT:
//					animation.play("roll");
//					
//				case FlxObject.UP:
//
//				case FlxObject.DOWN:
//                    animation.play("rollfront");
//			}
//		}
//			
//		super.draw();
//	}

    override public function update():Void
    {
        if (alive) {
            var tilePos = _map.getTileCoordsForWorldCoords(x, y);
            var tileKind = _map.getTile(tilePos[0], tilePos[1]);
            switch (tileKind) {
                case GameMap.TILE_STREET_VERT:
                    velocity.y = _speed;
                case GameMap.TILE_STREET_HORI:
                    velocity.x = _speed;
                case GameMap.TILE_STREET_CROSS:
            }

            if (velocity.x < 0) {
                facing = FlxObject.LEFT;
                animation.play("roll");
            } else if (velocity.x > 0) {
                facing = FlxObject.RIGHT;
                animation.play("roll");
            } else if (velocity.y < 0) {
                facing = FlxObject.UP;
                animation.play("rollback");
            } else if (velocity.y > 0) {
                facing = FlxObject.DOWN;
                animation.play("rollfront");
            }

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
        _map = null;
        super.destroy();
    }

    override public function kill():Void
    {
        velocity.x = velocity.y = 0;
        alive = false;
        animation.play("stop");
        FlxG.sound.play("assets/sounds/bruchGlas.wav");
        //y = y + 32;
        //makeGraphic(64, 32, 0xFFFF0000);
    }
}
