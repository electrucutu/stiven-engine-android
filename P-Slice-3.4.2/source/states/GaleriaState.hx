package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import mikolka.compatibility.VsliceOptions;
import mikolka.vslice.ui.MainMenuState;

class GaleriaState extends MusicBeatState
{
	var bg:FlxSprite;
	var magenta:FlxSprite;
	var imagenMostrada:FlxSprite;
	var textoDescripcion:FlxText;
	var textoAyuda:FlxText;

	// Configuración de las imágenes en assets/shared/images/gallery/
	var listaImagenes:Array<String> = ['pedro', 'bfstiven', 'renata'];
	var listaDescripciones:Array<String> = [
		"este es un personaje de among us inspirado en su serie dibujado por stiven",
		"este es una prueba de bf de las primeras versiones paarra probar algo simple hecho por stiven",
		"renata hizo sus sprites y se durmio pa lo demas XD"
	];
	
	var curSelected:Int = 0;

	// Constructor explícito fundamental para que funcione el cambio de estado en pSlice/Psych
	public function new()
	{
		super();
	}

	override function create()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Viendo la Galeria", null);
		#end

		persistentUpdate = true;
		persistentDraw = true;

		// Fondo idéntico al menú principal para mantener la estética
		bg = new FlxSprite().loadGraphic(Paths.image('mainmenu/bg'));
		bg.antialiasing = VsliceOptions.ANTIALIASING;
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		magenta = new FlxSprite().loadGraphic(Paths.image('mainmenu/bg'));
		magenta.antialiasing = VsliceOptions.ANTIALIASING;
		magenta.setGraphicSize(Std.int(magenta.width * 1.5));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		// Imagen del visor
		imagenMostrada = new FlxSprite();
		imagenMostrada.antialiasing = VsliceOptions.ANTIALIASING;
		add(imagenMostrada);

		// Texto de descripción abajo
		textoDescripcion = new FlxText(100, 590, FlxG.width - 200, "", 24);
		textoDescripcion.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textoDescripcion.scrollFactor.set();
		add(textoDescripcion);

		// Texto de ayuda superior
		textoAyuda = new FlxText(10, 20, FlxG.width - 20, "PRESIONA IZQUIERDA O DERECHA PARA NAVEGAR - ESCAPE PARA VOLVER", 18);
		textoAyuda.setFormat(Paths.font("vcr.ttf"), 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		textoAyuda.scrollFactor.set();
		add(textoAyuda);

		cambiarImagen(0);

		super.create();
	}

	override function update(elapsed:Float)
	{
		// Efecto de movimiento leve con el mouse como en el menú principal
		var factorX:Float = (FlxG.mouse.x - (FlxG.width / 2)) / (FlxG.width / 2);
		var factorY:Float = (FlxG.mouse.y - (FlxG.height / 2)) / (FlxG.height / 2);
		bg.x = FlxMath.lerp(bg.x, ((FlxG.width - bg.width) / 2) - (factorX * 30), FlxMath.bound(elapsed * 6, 0, 1));
		bg.y = FlxMath.lerp(bg.y, ((FlxG.height - bg.height) / 2) - (factorY * 30), FlxMath.bound(elapsed * 6, 0, 1));
		magenta.x = bg.x;
		magenta.y = bg.y;

		if (controls.UI_LEFT_P)
			cambiarImagen(-1);
		if (controls.UI_RIGHT_P)
			cambiarImagen(1);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	function cambiarImagen(cambio:Int)
	{
		if (cambio != 0)
			FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += cambio;

		if (curSelected < 0)
			curSelected = listaImagenes.length - 1;
		if (curSelected >= listaImagenes.length)
			curSelected = 0;

		imagenMostrada.loadGraphic(Paths.image('gallery/' + listaImagenes[curSelected]));
		
		// Ajustar tamaño para que no rompa la pantalla si la imagen es muy grande
		if (imagenMostrada.width > 850 || imagenMostrada.height > 480) {
			imagenMostrada.setGraphicSize(850, 480);
		}
		imagenMostrada.updateHitbox();
		imagenMostrada.screenCenter();
		imagenMostrada.y -= 35; // Dejar espacio para el texto inferior

		textoDescripcion.text = listaDescripciones[curSelected];
	}
}