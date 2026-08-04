package options;

import flixel.system.scaleModes.RatioScaleMode;
import mikolka.funkin.custom.mobile.MobileScaleMode;
import objects.Character;
import options.Option;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;
	public function new()
	{
		title = 'Ajustes Gráficos';
		rpcTitle = 'Graphics Settings Menu'; //for Discord Rich Presence

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (name:String) boyfriend.dance();
		boyfriend.visible = false;

		var option:Option = new Option('Baja Calidad', //Name
			'Si se marca, desactiva detalles del fondo,\nreduce tiempos de carga y mejora el rendimiento.', //Description
			'lowQuality', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Suavizado de Bordes',
			'Si se desmarca, quita el anti-aliasing, mejorando el rendimiento\na costa de que los sprites se vean más pixelados.',
			'antialiasing',
			BOOL);
		option.onChange = onChangeAntiAliasing; 
		addOption(option);
		antialiasingOption = optionsArray.length-1;

		var option:Option = new Option('Shaders', //Name
			"Si se desmarca, desactiva los shaders.\nSe usan para efectos visuales especiales, pero consumen CPU en equipos lentos.", //Description
			'shaders',
			BOOL);
		addOption(option);

		var option:Option = new Option('Caché en GPU', //Name
			"Si se marca, usa la tarjeta gráfica para cargar texturas, reduciendo el consumo de RAM.\nNo lo actives si tienes una gráfica muy vieja.", //Description
			'cacheOnGPU',
			BOOL);
		addOption(option);

		option = new Option('Pantalla Ancha',
			'Si se marca, el juego se estirará para llenar tu pantalla. (AVISO: Puede romper los elementos visuales de algunos mods).',
			'wideScreen', BOOL);
		option.onChange = () -> MobileScaleMode.enabled = ClientPrefs.data.wideScreen;
		addOption(option);

		#if !html5 
		var option:Option = new Option('Límite de FPS',
			"Ajusta la tasa de fotogramas por segundo máxima para el juego.",
			'framerate',
			INT);
		addOption(option);

		final refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
		option.minValue = 30;
		option.maxValue = 240;
		option.defaultValue = Std.int(FlxMath.bound(refreshRate, option.minValue, option.maxValue));
		option.displayFormat = '%v FPS';
		option.onChange = onChangeFramerate;
		#end

		super();
		insert(1, boyfriend);
	}

	function onChangeAntiAliasing()
	{
		for (sprite in members)
		{
			var sprite:FlxSprite = cast sprite;
			if(sprite != null && (sprite is FlxSprite) && !(sprite is FlxText)) {
				sprite.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		if(ClientPrefs.data.framerate > FlxG.drawFramerate)
		{
			FlxG.updateFramerate = ClientPrefs.data.framerate;
			FlxG.drawFramerate = ClientPrefs.data.framerate;
		}
		else
		{
			FlxG.drawFramerate = ClientPrefs.data.framerate;
			FlxG.updateFramerate = ClientPrefs.data.framerate;
		}
	}

	override function changeSelection(change:Float,usePrecision:Bool = false) 
	{
		super.changeSelection(change,usePrecision);
		boyfriend.visible = (antialiasingOption == curSelected);
	}
}