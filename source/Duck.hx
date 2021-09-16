package ;

import Std.int;
import Math.floor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxAngle;

class Duck extends FlxSprite
{
    public static var MOUSE_DEAD_ZONE:Float = 15.0;
    public var speed:Float = 300;

    private var _kicking = false;

    public function new()
    {
        super();
        //makeGraphic(32, 32, 0xFFFF0000);
        loadGraphic("assets/images/duck_all.png", true, 64, 68);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("walk", [0, 1], 8, false);
        animation.add("walkback", [2, 3], 8, false);
        animation.add("kick", [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 60, false);
        drag.x = drag.y = 1600;
        width = 32;
        height = 52;
        offset.x = 16;
        offset.y = 8;
    }

    public function kick():Void
    {
        velocity.x = velocity.y = 0;
        _kicking = true;
        animation.play("kick", true);
    }

    override public function update():Void
    {
        movement();
        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    // Stolen from FlixelTut
    // https://raw.githubusercontent.com/HaxeFlixel/flixel-tutorial/Part-VII/source/Player.hx
	override public function draw():Void 
	{
        if (_kicking) {
            if (animation.finished) {
                _kicking = false;
            }
        }

		if ((velocity.x != 0 || velocity.y != 0) && !_kicking)
		{
			switch(facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("walk");
					
				case FlxObject.UP:
					animation.play("walkback");
					
				case FlxObject.DOWN:
					animation.play("walk");
			}
		}
			
		super.draw();
	}

    private function movement():Void
    {
        var _up:Bool = false;
        var _down:Bool = false;
        var _left:Bool = false;
        var _right:Bool = false;


        if (FlxG.mouse.pressed) {
            // 8-way mouse control

            var mx = FlxG.mouse.x;
            var my = FlxG.mouse.y;
            var tx = this.x;
            var ty = this.y;

            if (Math.abs(mx - tx) < Duck.MOUSE_DEAD_ZONE && my < ty) {
                _up = true;
            } else if (Math.abs(mx - tx) < Duck.MOUSE_DEAD_ZONE && my > ty) {
                _down = true;
            } else if (mx < tx && Math.abs(my - ty) < Duck.MOUSE_DEAD_ZONE) {
                _left = true;
            } else if (mx > tx && Math.abs(my - ty) < Duck.MOUSE_DEAD_ZONE) {
                _right = true;
            } else if (mx < tx && my < ty) {
                _left = true;
                _up = true;
            } else if (mx < tx && my > ty) {
                _left = true;
                _down = true;
            } else if (mx > tx && my < ty) {
                _right = true;
                _up = true;
            } else if (mx > tx && my > ty) {
                _right = true;
                _down = true;
            }

        } else {
            _up = FlxG.keys.anyPressed(["UP", "W"]);
            _down = FlxG.keys.anyPressed(["DOWN", "S"]);
            _left = FlxG.keys.anyPressed(["LEFT", "A"]);
            _right = FlxG.keys.anyPressed(["RIGHT", "D"]);
        }

        if (_up && _down)
            _up = _down = false;
        if (_left && _right)
            _left = _right = false;

        if (_up || _down || _left || _right)
        {
            var mA:Float = 0;
            if (_up)
            {
                mA = -90;
                if (_left)
                    mA -= 45;
                else if (_right)
                    mA += 45;
                facing = FlxObject.UP;
            }
            else if (_down)
            {
                mA = 90;
                if (_left)
                    mA += 45;
                else if (_right)
                    mA -= 45;
                facing = FlxObject.DOWN;
            }
            else if (_left)
            {
                mA = 180;
                facing = FlxObject.LEFT;
            }
            else if (_right)
            {
                mA = 0;
                facing = FlxObject.RIGHT;
            }       

            FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
        }
    }


}
