package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
using flixel.util.FlxSpriteUtil;

class AboutState extends FlxState
{
    public static inline var FONT_SIZE = 10;
    public static inline var BACK_BUTTON_WIDTH = 128;
    public static inline var BACK_BUTTON_HEIGHT = 32;

    private var _versionNumber:FlxText;
    private var _creditsImg:FlxSprite;
    private var _btnCredits:FlxButton;

    override public function create():Void
    {
        FlxG.mouse.visible = true;
#if android
        FlxG.mouse.visible = false;
#end
        bgColor = 0xFFFFFFFF;

        _creditsImg = new FlxSprite(0, 0, "assets/images/credits.png");
        _creditsImg.screenCenter();
        add(_creditsImg);

        var appVersion = getVersionCode();
        _versionNumber = new FlxText(0, 0, 0, "Duckstruction " + Std.string(appVersion), AboutState.FONT_SIZE);
        _versionNumber.setBorderStyle(FlxText.BORDER_OUTLINE, 0xFF000000, 1.0);
        add(_versionNumber);

        _btnCredits = new FlxButton(1024 - AboutState.BACK_BUTTON_WIDTH, 
                                    576 - AboutState.BACK_BUTTON_HEIGHT, "", clickBack);
        _btnCredits.loadGraphic("assets/images/backbutton_small.png");
        add(_btnCredits);

        super.create();
    }

    private function getVersionCode():String
    {
        // TODO: find a way to get the version code from the Project.xml
        return "v0.1.0";
    }

    private function clickBack():Void
    {
        FlxG.switchState(new MenuState());
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
