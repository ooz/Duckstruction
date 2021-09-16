package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
    private var _logo:FlxSprite;
    private var _duck:FlxSprite;
    private var _btnPlay:FlxButton;
    private var _btnCredits:FlxButton;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        FlxG.mouse.visible = true;
#if android
        FlxG.mouse.visible = false;
#end
        bgColor = 0xFFFFFFFF;

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
        _btnPlay.loadGraphic("assets/images/maskeplay.png");
        _btnPlay.screenCenter();
        add(_btnPlay);
        _btnPlay.y += 100;

        _btnCredits = new FlxButton(1024 - 224, 576 - 32, "", clickCredits);
        _btnCredits.loadGraphic("assets/images/creditsbutton_small.png");
        add(_btnCredits);

		super.create();
	}

    private function clickPlay():Void
    {
        FlxG.switchState(new StoryState());
    }

    private function clickCredits():Void
    {
        FlxG.switchState(new AboutState());
    }
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}
