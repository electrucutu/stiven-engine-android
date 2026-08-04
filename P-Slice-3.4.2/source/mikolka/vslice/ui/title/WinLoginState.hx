package mikolka.vslice.ui.title;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxTimer;
import states.MainMenuState; // Ajustado según tu inicializador de estados

class WinLoginState extends MusicBeatState
{
	var fondoBoyfriend:FlxSprite;
	var UIPerfil:FlxSprite;
	var campoContrasena:FlxInputText;
	var transitioning:Bool = false;

	override public function create():Void
	{
		super.create();

		// 1. Fondo de pantalla de Boyfriend (inicio/iniciar)
		fondoBoyfriend = new FlxSprite(0, 0).loadGraphic(Paths.image('inicio/iniciar'));
		fondoBoyfriend.setGraphicSize(FlxG.width, FlxG.height);
		fondoBoyfriend.updateHitbox();
		add(fondoBoyfriend);

		// 2. El "coso" del perfil completo con el cuadro y nombre de usuario
		UIPerfil = new FlxSprite(0, 0).loadGraphic(Paths.image('inicio/perfil con el nombre y contrasena'));
		UIPerfil.screenCenter();
		add(UIPerfil);

		// 3. El campo donde vas a escribir la contraseña "gf"
		// Ajustamos las coordenadas X e Y para que quede alineado sobre tu barra/coso de contraseña
		campoContrasena = new FlxInputText(0, 0, 280, "", 22, FlxColor.BLACK, FlxColor.WHITE);
		campoContrasena.screenCenter();
		campoContrasena.y += 110; // Lo baja un poco para encajar en el diseño de Windows
		campoContrasena.passwordMode = true; // Convierte las letras en puntitos ocultos
		campoContrasena.focus(); // Activa el teclado de inmediato
		add(campoContrasena);

		// Sonido de fondo clásico si deseas conservar la música
		if (FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// Al presionar Enter verifica lo escrito
		if (FlxG.keys.justPressed.ENTER && !transitioning)
		{
			verificarContrasena();
		}
	}

	function verificarContrasena()
	{
		// Pasamos a minúsculas por seguridad. Verifica si es "gf"
		if (campoContrasena.text.toLowerCase() == "gf")
		{
			transitioning = true;
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
			FlxG.camera.flash(FlxColor.WHITE, 1);

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				// Te manda directo al menú principal del juego
				MusicBeatState.switchState(new MainMenuState());
			});
		}
		else
		{
			// Si falla, se limpia la contraseña y la cámara tiembla como error de Windows
			campoContrasena.text = "";
			FlxG.camera.shake(0.005, 0.15);
		}
	}
}