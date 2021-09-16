package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;

class EndState extends FlxState
{
    private var _whatDoWeDoNow:FlxText;
    private var _logo:FlxSprite;
    private var _duck:FlxSprite;
    private var _btnPlay:FlxButton;
    private var _btnCredits:FlxButton;

	override public function create():Void
	{
        FlxG.mouse.visible = true;
#if android
        FlxG.mouse.visible = false;
#end
        bgColor = 0xFFFFFFFF;

        //FlxG.sound.destroy();

        _whatDoWeDoNow = new FlxText(0, 0, 0, "You destroyed the city!", 24);
        _whatDoWeDoNow.setBorderStyle(FlxText.BORDER_OUTLINE, 0xFF000000, 2.0);
        _whatDoWeDoNow.screenCenter();
        add(_whatDoWeDoNow);
        _whatDoWeDoNow.y -= 250;
        _whatDoWeDoNow = new FlxText(1, 0, 0, "What do we do now?", 48);
        _whatDoWeDoNow.setBorderStyle(FlxText.BORDER_OUTLINE, 0xFF000000, 2.0);
        _whatDoWeDoNow.screenCenter();
        add(_whatDoWeDoNow);
        _whatDoWeDoNow.y -= 190;

        _logo = new FlxSprite(0, 0, "assets/images/maskelogo.png");
        _logo.screenCenter();
        add(_logo);
        _logo.y -= 100;

        _duck = new FlxSprite(0, 0);
        _duck.loadGraphic("assets/images/duck.png", true, 64, 64);
        _duck.animation.add("idle", [0, 1], 6, true);
        _duck.animation.play("idle");
        _duck.screenCenter();
        add(_duck);

        _btnPlay = new FlxButton(0, 0, "", clickPlay);
        _btnPlay.loadGraphic("assets/images/maskeplayagain.png");
        _btnPlay.screenCenter();
        add(_btnPlay);
        _btnPlay.y += 150;

        _btnCredits = new FlxButton(1024 - 224, 576 - 32, "", clickCredits);
        _btnCredits.loadGraphic("assets/images/creditsbutton_small.png");
        add(_btnCredits);

		super.create();
	}

    private function clickPlay():Void
    {
        FlxG.switchState(new PlayState());
    }
	
    private function clickCredits():Void
    {
        FlxG.switchState(new AboutState());
    }

	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
	}	
}
