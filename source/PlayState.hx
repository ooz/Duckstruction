package;

import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxRandom;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
    private var _map:GameMap;
    private var _duck:Duck;
    private var _buildings:FlxTypedGroup<Building>;
    private var _ruins:FlxTypedGroup<Building>;
    private var _cars:FlxTypedGroup<Car>;
    private var _persons:FlxTypedGroup<Person>;
    private var _buildingGibs:FlxEmitter;
    private var _hamsterGibs:FlxEmitter;
    private var _endtimer(default, null):FlxTimer;
    private var _explosion:Explosion;
    private var _ui:UI;

    private var BUILDING_PADDING = 2;
    private var MAX_BUILDINGS = 100;
    private var CHANCE_TO_SPAWN_BUILDING = 0.2;
    private var CHANCE_TO_SPAWN_CAR = 0.1;
    private var CHANCE_TO_SPAWN_PERSON = 0.2;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
        #if android
		FlxG.mouse.visible = false;
        #end
        bgColor = 0xFF000000;

        _map = new GameMap();
        add(_map);

        _buildings = new FlxTypedGroup<Building>();
        _cars = new FlxTypedGroup<Car>();
        _persons = new FlxTypedGroup<Person>();
        _ruins = new FlxTypedGroup<Building>();
        placeBuildings();

        _buildingGibs = new FlxEmitter();
		_buildingGibs.setXSpeed( -1600, 1600);
		_buildingGibs.setYSpeed( -1600, 0);
		_buildingGibs.setRotation( -720, -720);
		_buildingGibs.gravity = 800;
		_buildingGibs.bounce = 0.35;
		_buildingGibs.makeParticles("assets/images/particlestuff1.png", 80, 20, true, 0.0);
        add(_buildingGibs);

        _hamsterGibs = new FlxEmitter();
		_hamsterGibs.setXSpeed( -1200, 1200);
		_hamsterGibs.setYSpeed( -1200, 0);
		_hamsterGibs.setRotation( -720, -720);
		_hamsterGibs.gravity = 800;
		_hamsterGibs.bounce = 0.35;
        _hamsterGibs.makeParticles("assets/images/hamster_rauskatapultiert.png", 1, 16, false, 0.0);
        add(_hamsterGibs);

        _explosion = new Explosion();

        FlxG.worldBounds.width = _map._width * _map._tileSize + 10;
        FlxG.worldBounds.height = _map._height * _map._tileSize + 10;

        _duck = new Duck();
        _duck.x = FlxG.worldBounds.width / 2.0;
        _duck.y = FlxG.worldBounds.height / 2.0;
        add(_duck);
        FlxG.camera.follow(_duck, FlxCamera.STYLE_TOPDOWN, null, 1);

        _ui = new UI();
        add(_ui);

        // if flash
        #if linux
            FlxG.sound.playMusic("assets/music/ente_evil.ogg");
        #else
            FlxG.sound.playMusic("assets/music/ente_evil.mp3");
        #end

		super.create();
	}

    private function placeBuildings():Void
    {
        var buildingCount = 0;
        for (tileY in BUILDING_PADDING..._map._height - BUILDING_PADDING) {
            for (tileX in BUILDING_PADDING..._map._width - BUILDING_PADDING) {
                var spawnX = tileX * _map._tileSize;
                var spawnY = tileY * _map._tileSize;
                switch (_map.getTile(tileX, tileY)) {
                    case GameMap.TILE_BLOCK:
                        if (FlxRandom.float() < CHANCE_TO_SPAWN_BUILDING && buildingCount < MAX_BUILDINGS) {
                            _buildings.add(new Building(spawnX, spawnY));
                            buildingCount++;
                        } else if (FlxRandom.float() < CHANCE_TO_SPAWN_PERSON) {
                            _persons.add(new Person(spawnX, spawnY, _map));
                        }
                    case GameMap.TILE_STREET_VERT, GameMap.TILE_STREET_HORI:
                        if (FlxRandom.float() < CHANCE_TO_SPAWN_CAR) {
                            _cars.add(new Car(spawnX + 19, spawnY + 10, _map));
                        }
                }
            }
        }
        add(_cars);
        add(_ruins);
        add(_persons);
        add(_buildings);
    }

	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
        _map = null;
        _duck = null;
        _buildings = null;
        _ruins = null;
        _cars = null;
        _persons = null;
        _buildingGibs = null;
        _endtimer = null;
        _explosion = null;
        _ui = null;
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

        FlxG.overlap(_duck, _buildings, duckOverlapBuilding);
        FlxG.overlap(_duck, _cars, duckOverlapCar);

        // Make duck stay on map
        if (_duck.x < 0)
            _duck.x = 0;
        if (_duck.y < 0)
            _duck.y = 0;
        if (_duck.x > _map._width * _map._tileSize - _duck.width)
            _duck.x = _map._width * _map._tileSize - _duck.width;
        if (_duck.y > _map._height * _map._tileSize - _duck.height)
            _duck.y = _map._height * _map._tileSize - _duck.height;

        // End condition
        //trace("buildings: " + _buildings.length);
        //trace("ruins: " + _ruins.length);
        var alive:Float = _cars.length - _cars.countLiving() + _ruins.length;
        var total:Float = _cars.length + _buildings.length;
        var destructionRate:Float = alive / total;
        //var endCondition:Bool = _cars.countLiving() == 0 && _buildings.length - _ruins.length <= 2 // so you dont need to destroy everything / search last buildings
        var endCondition:Bool = destructionRate >= 0.95;
        if (endCondition
            && _endtimer == null) {
            _endtimer = new FlxTimer();
            _endtimer.start(2.0, gotoEndState);
        }

        _ui.updateUI(destructionRate);
	}	

    private function duckOverlapBuilding(duck:Duck, building:Building):Void
    {
        if (duck.alive && duck.exists && building.alive && building.exists) {
            duck.kick();
            FlxG.sound.play("assets/sounds/explosion1.wav", 0.5, false);
            _buildingGibs.at(building);
            _buildingGibs.start(true, 5);
            var midpoint = building.getMidpoint();
            _explosion.x = midpoint.x - _explosion.width / 2.0;
            _explosion.y = midpoint.y;
            remove(_explosion);
            add(_explosion);
            _explosion.animation.play("explode");
            building.kill();
            FlxG.camera.shake(FlxRandom.floatRanged(0.007, 0.01), 0.5);
            _ruins.add(building);
            _buildings.remove(building);
        }
    }

    private function duckOverlapCar(duck:Duck, car:Car):Void
    {
        if (duck.alive && duck.exists && car.alive && car.exists) {
            duck.kick();
            _hamsterGibs.at(car);
            _hamsterGibs.start(true, 5);
            car.kill();
        }
    }

    private function gotoEndState(t:FlxTimer):Void
    {
        FlxG.switchState(new EndState());
    }
}
