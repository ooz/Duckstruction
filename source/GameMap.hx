package ;

import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxRandom;

class GameMap extends FlxTilemap
{
    public var _width:Int = 20;
    public var _height:Int = 20;
    public var _tileSize:Int = 128;

    public static inline var TILE_TRANSPARENT = 0;
    public static inline var TILE_BLOCK = 1;
    public static inline var TILE_STREET_VERT = 2;
    public static inline var TILE_STREET_HORI = 3;
    public static inline var TILE_STREET_CROSS = 4;

    public function new()
    {
        super();
        var mapArray = [];
        for (i in 0..._width) {
            for (j in 0..._height) {
                mapArray.push(GameMap.TILE_BLOCK);
            }
        }
        widthInTiles = _width;
        heightInTiles = _height;
        loadMap(mapArray, "assets/images/bodentextur.png", _tileSize, _tileSize);

        // von Silvio
        var strassen_x:Int = Std.int(_width / 10);
        for (sx in 0...strassen_x) {
            var sp = FlxRandom.intRanged(0, _width - 1);
            if (sp > 1 && sp < _height - 2 
                && getTile(sp-1, 0) != GameMap.TILE_STREET_VERT
                && getTile(sp-2, 0) != GameMap.TILE_STREET_VERT 
                && getTile(sp+1, 0) != GameMap.TILE_STREET_VERT 
                && getTile(sp+2, 0) != GameMap.TILE_STREET_VERT) {
                for (c in 0..._width) {
                    setTile(sp, c, GameMap.TILE_STREET_VERT);
                }
            }
        }

        var strassen_y:Int = Std.int(_height / 10);
        for (sy in 0...strassen_y) {
            var sp = FlxRandom.intRanged(0, _height - 1);
            if (sp > 1 && sp < _width-2 
                && getTile(0,sp-1) !=  GameMap.TILE_STREET_HORI 
                && getTile(0,sp-2) !=  GameMap.TILE_STREET_HORI 
                && getTile(0, sp+1) != GameMap.TILE_STREET_HORI 
                && getTile(0, sp+2) != GameMap.TILE_STREET_HORI) {
                for (c in 0..._height) {
                    if (getTile(c, sp) == GameMap.TILE_STREET_VERT
                        || getTile(c, sp) == GameMap.TILE_STREET_CROSS)
                    {
                        setTile(c, sp, GameMap.TILE_STREET_CROSS);
                    }
                    else
                    {
                        setTile(c, sp, GameMap.TILE_STREET_HORI);
                    }
                }
            }
        }
    }

//    override public function update():Void
//    {
//        super.update();
//    }

    public function getTileCoordsForWorldCoords(x:Float, y:Float):Array<Int>
    {
        return [Std.int(x / _tileSize), Std.int(y / _tileSize)];
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}
