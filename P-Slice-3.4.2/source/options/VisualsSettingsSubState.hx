package options;

import objects.Note;
import objects.StrumNote;
import objects.NoteSplash;
import objects.Alphabet;
import options.Option;

class VisualsSettingsSubState extends BaseOptionsMenu
{
	public static var pauseMusics:Array<String> = ['Ninguna', 'Tea Time', 'Breakfast', 'Breakfast (Pico)', 'Breakfast (Pixel)'];
	var noteOptionID:Int = -1;
	var notes:FlxTypedGroup<StrumNote>;
	var splashes:FlxTypedGroup<NoteSplash>;
	var noteY:Float = 90;
	public function new()
	{
		title = 'Ajustes Visuales';
		rpcTitle = 'Visuals Settings Menu'; //for Discord Rich Presence

		notes = new FlxTypedGroup<StrumNote>();
		splashes = new FlxTypedGroup<NoteSplash>();
		for (i in 0...Note.colArray.length)
		{
			var note:StrumNote = new StrumNote(370 + (560 / Note.colArray.length) * i, -200, i, 0);
			changeNoteSkin(note);
			notes.add(note);
			
			var splash:NoteSplash = new NoteSplash(0, 0, NoteSplash.defaultNoteSplash + NoteSplash.getSplashSkinPostfix());
			splash.inEditor = true;
			splash.babyArrow = note;
			splash.ID = i;
			splash.kill();
			splashes.add(splash);
		}

		var holdSkins:Array<String> = Mods.mergeAllTextsNamed('images/holdCovers/list.txt');
		if(holdSkins.length > 0)
		{
			if(!holdSkins.contains(ClientPrefs.data.holdSkin))
				ClientPrefs.data.holdSkin = ClientPrefs.defaultData.holdSkin;
			holdSkins.remove(ClientPrefs.defaultData.holdSkin);
			holdSkins.insert(0, ClientPrefs.defaultData.holdSkin);
			var option:Option = new Option('Destellos Largos:',
				"Selecciona la variación para los destellos de notas sostenidas o desactívala.",
				'holdSkin',
				STRING,
				holdSkins);
			addOption(option);
		}

		var option:Option = new Option('Opacidad de Destellos',
			'Define qué tan transparentes serán los efectos al presionar notas.',
			'splashAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		option.onChange = playNoteSplashes;

		var option:Option = new Option('Opacidad de Notas Sostenidas',
			'Define la transparencia de los destellos en notas largas.\n0% los desactiva.',
			'holdSplashAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Ocultar Interfaz',
			'Si se marca, se oculta la mayoría de elementos visuales (HUD) en pantalla.',
			'hideHud',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Barra de Tiempo:',
			"¿Qué debería mostrar la barra de tiempo?",
			'timeBarType',
			STRING,
			['Tiempo Restante', 'Tiempo Transcurrido', 'Nombre de Canción', 'Desactivado']);
		addOption(option);

		var option:Option = new Option('Luces Parpadeantes',
			"¡Desmarca esto si eres sensible a los destellos de luces intensas!",
			'flashing',
			BOOL);
		addOption(option);

		var option:Option = new Option('Zoom de la Cámara',
			"Si se desmarca, la cámara no hará zoom siguiendo el ritmo de la música.",
			'camZooms',
			BOOL);
		addOption(option);

		var option:Option = new Option('Agrandar Texto de Puntuación',
			"Si se desmarca, el texto de puntaje ya no aumentará de tamaño al tocar notas.",
			'scoreZoom',
			BOOL);
		addOption(option);

		var option:Option = new Option('Opacidad de la Barra de Vida',
			'Ajusta la transparencia de la barra de salud y de los iconos.',
			'healthBarAlpha',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('Contador de FPS',
			'Ajusta la opacidad o desactiva por completo el medidor de FPS.',
			'showFPSOpacity',
			PERCENT);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		option.onChange = onChangeFPSCounter;

		var option:Option = new Option('FPS Rediseñado',
			'Si se marca, activa el diseño avanzado y técnico para el contador de FPS.',
			'fpsRework',
			BOOL);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		
		var option:Option = new Option('Música de Pausa:',
			"Elige la canción de fondo para el menú de pausa.",
			'pauseMusic',
			STRING,
			pauseMusics);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Buscar Actualizaciones',
			'Busca actualizaciones oficiales al iniciar el juego.',
			'checkForUpdates',
			BOOL);
		addOption(option);
		#end

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Oculta lo que estás jugando en tu estado de Discord para evitar filtraciones.",
			'discordRPC',
			BOOL);
		addOption(option);
		#end

		var option:Option = new Option('Acumulación de Combo',
			"Si se desmarca, las calificaciones no se amontonarán, mejorando la legibilidad.",
			'comboStacking',
			BOOL);
		addOption(option);

		super();
		add(notes);
		add(splashes);
	}

	var notesShown:Bool = false;
	var lastSelected:Int = -1;
	override function changeSelection(change:Float,usePrecision:Bool = false)
	{
		super.changeSelection(change,usePrecision);
		if(lastSelected == curSelected) return;
		else lastSelected = curSelected;

		switch(curOption.variable)
		{
			case 'noteSkin', 'splashSkin', 'splashAlpha':
				if(!notesShown)
				{
					for (note in notes.members)
					{
						FlxTween.cancelTweensOf(note);
						FlxTween.tween(note, {y: noteY}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
					}
				}
				notesShown = true;
				if(curOption.variable.startsWith('splash') && Math.abs(notes.members[0].y - noteY) < 25) playNoteSplashes();

			default:
				if(notesShown) 
				{
					for (note in notes.members)
					{
						FlxTween.cancelTweensOf(note);
						FlxTween.tween(note, {y: -200}, Math.abs(note.y / (200 + noteY)) / 3, {ease: FlxEase.quadInOut});
					}
				}
				notesShown = false;
		}
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}

	function onChangeNoteSkin()
	{
		notes.forEachAlive(function(note:StrumNote) {
			changeNoteSkin(note);
			note.centerOffsets();
			note.centerOrigin();
		});
	}

	function changeNoteSkin(note:StrumNote)
	{
		var skin:String = Note.defaultNoteSkin;
		var customSkin:String = skin + Note.getNoteSkinPostfix();
		if(Paths.fileExists('images/$customSkin.png', IMAGE)) skin = customSkin;

		note.texture = skin;
		note.reloadNote();
		note.playAnim('static');
	}

	function onChangeSplashSkin()
	{
		var skin:String = NoteSplash.defaultNoteSplash + NoteSplash.getSplashSkinPostfix();
		for (splash in splashes)
			splash.loadSplash(skin);

		playNoteSplashes();
	}
	
	function playNoteSplashes()
	{
		var rand:Int = 0;
		if (splashes.members[0] != null && splashes.members[0].maxAnims > 1)
			rand = FlxG.random.int(0, splashes.members[0].maxAnims - 1);

		for (splash in splashes)
		{
			splash.revive();

			splash.spawnSplashNote(0, 0, splash.ID, null, false);
			if (splash.maxAnims > 1)
				splash.noteData = splash.noteData % Note.colArray.length + (rand * Note.colArray.length);

			var anim:String = splash.playDefaultAnim();
			var conf = splash.config.animations.get(anim);
			var offsets:Array<Float> = [0, 0];

			var minFps:Int = 22;
			var maxFps:Int = 26;
			if (conf != null)
			{
				offsets = conf.offsets;

				minFps = conf.fps[0];
				if (minFps < 0) minFps = 0;

				maxFps = conf.fps[1];
				if (maxFps < 0) maxFps = 0;
			}

			splash.offset.set(10, 10);
			if (offsets != null)
			{
				splash.offset.x += offsets[0];
				splash.offset.y += offsets[1];
			}

			if (splash.animation.curAnim != null)
				splash.animation.curAnim.frameRate = FlxG.random.int(minFps, maxFps);
		}
	}
	
	override function destroy()
	{
		if(changedMusic && !OptionsState.onPlayState) FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
		Note.globalRgbShaders = [];
		super.destroy();
	}

	function onChangeFPSCounter()
	{
		if(Main.debugDisplay != null){
			Main.debugDisplay.isAdvanced = ClientPrefs.data.fpsRework;
			Main.debugDisplay.visible = ClientPrefs.data.showFPSOpacity != 0;
			Main.debugDisplay.backgroundOpacity = ClientPrefs.data.showFPSOpacity;
		}
	}
}