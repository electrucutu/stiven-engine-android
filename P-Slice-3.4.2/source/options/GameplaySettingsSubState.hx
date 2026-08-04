package options;

import options.Option;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Modo de Juego';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Notas Abajo', //Name
			'Si se marca, las notas caerán hacia abajo en lugar de subir.', //Description
			'downScroll', //Save data variable name
			BOOL); //Variable type
		addOption(option);

		var option:Option = new Option('Notas al Centro',
			'Si se marca, tus notas se centrarán en la pantalla.',
			'middleScroll',
			BOOL);
		addOption(option);

		var option:Option = new Option('Notas del Rival',
			'Si se desmarca, las notas del oponente se ocultarán.',
			'opponentStrums',
			BOOL);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"Si se marca, no fallarás al presionar teclas\ncuando no haya notas cerca para tocar.",
			'ghostTapping',
			BOOL);
		addOption(option);
		
		var option:Option = new Option('Pausa Automática',
			"Si se marca, el juego se pausa automáticamente si la ventana pierde el foco.",
			'autoPause',
			BOOL);
		addOption(option);
		option.onChange = onChangeAutoPause;

		var option:Option = new Option('Mostrar Puntuación',
			"Si se desmarca, no saldrán los textos de \"Sick!\", \"Good\" ni el combo.\n(Útil para dispositivos de gama baja).",
			'popUpRating',
			BOOL);
		addOption(option);

		var option:Option = new Option('Desactivar Botón de Reinicio',
			"Si se marca, presionar la tecla de reinicio (R) no hará nada.",
			'noReset',
			BOOL);
		addOption(option);

		var option:Option = new Option('Vibraciones',
			"Si se marca, tu dispositivo vibrará en ciertas situaciones.",
			'vibrating',
			BOOL);
		addOption(option);
		option.onChange = onChangeVibration;

		var option:Option = new Option('Sostener como una Nota',
			"Si se marca, las notas largas no se pueden presionar si fallas,\ny cuentan como un único acierto/fallo.\nDesmarca esto si prefieres el sistema antiguo.",
			'guitarHeroSustains',
			BOOL);
		addOption(option);

		var option:Option = new Option('Volumen de Hitsounds',
			'Las notas harán un sonido de \"¡Tick!\" al ser presionadas.',
			'hitsoundVolume',
			PERCENT);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Margen de Calificación',
			'Cambia qué tan tarde o temprano debes presionar para un "Sick!"\nValores más altos significan que debes presionar más tarde.',
			'ratingOffset',
			INT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Ventana de Sick!',
			'Cambia el tiempo en milisegundos que tienes\npara conseguir la calificación "Sick!".',
			'sickWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15.0;
		option.maxValue = 45.0;
		option.changeValue = 0.5;
		addOption(option);

		var option:Option = new Option('Ventana de Good',
			'Cambia el tiempo en milisegundos que tienes\npara conseguir la calificación "Good".',
			'goodWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15.0;
		option.maxValue = 90.0;
		option.changeValue = 0.5;
		addOption(option);

		var option:Option = new Option('Ventana de Bad',
			'Cambia el tiempo en milisegundos que tienes\npara conseguir la calificación "Bad".',
			'badWindow',
			FLOAT);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15.0;
		option.maxValue = 135.0;
		option.changeValue = 0.5;
		addOption(option);

		var option:Option = new Option('Fotogramas Seguros',
			'Cambia cuántos fotogramas (frames) tienes para\ntocar una nota antes o después de tiempo.',
			'safeFrames',
			FLOAT);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.data.hitsoundVolume);

	function onChangeAutoPause()
		FlxG.autoPause = ClientPrefs.data.autoPause;

	function onChangeVibration()
	{
		HapticUtil.vibrate(0, Constants.DEFAULT_VIBRATION_DURATION);
	}
}