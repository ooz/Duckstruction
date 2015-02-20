package;

import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
using flixel.util.FlxSpriteUtil;

class UI extends FlxTypedGroup<FlxSprite>
{
    private var _completion:FlxText;

    public function new()
    {
        super();

        _completion = new FlxText(2, 2, 0, "0%", 16);
        _completion.setBorderStyle(FlxText.BORDER_OUTLINE, 0xFF000000, 1.0);
        _completion.alignment = "right";
        
        add(_completion);
        
        forEach(function(spr:FlxSprite) {
            spr.scrollFactor.set();
        });
    }

    public function updateUI(completion:Float = 0.0):Void
    {
        _completion.text = Std.string(Std.int(completion * 100.0)) + "%";
    }
}
