package options;

import mikolka.funkin.custom.mobile.MobileScaleMode;
import mikolka.vslice.components.crash.UserErrorSubstate;
import backend.StageData;
import flixel.FlxObject;

class OptionsState extends MusicBeatState
{
	// Lista de opciones visibles directamente en español
	var options:Array<String> = [
		'Controles',
		'Ajustar Retraso y Combo',
		'Gráficos',
		'Visuales',
		'Modo de Juego',
		'S-v2',
		'Opciones V-Slice',
		#if (TOUCH_CONTROLS_ALLOWED || mobile)'Opciones de Celular' #end
	];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private static var curSelectedPartial:Float = 0;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	var exiting:Bool = false;

	private var mainCam:FlxCamera;
	public static var funnyCam:FlxCamera;
	private var camFollow:FlxObject;
	private var camFollowPos:FlxObject;

	function openSelectedSubstate(label:String) {
		if (label != "Ajustar Retraso y Combo")
			funnyCam.visible = persistentUpdate = false;

		// Vinculamos cada texto en español con su respectivo menú interno
		switch(label)
		{
			case 'Controles':
				if (controls.mobileC)
				{
					funnyCam.visible = persistentUpdate = true;
					UserErrorSubstate.makeMessage("Controles no soportados", 
					"¡No necesitas entrar aquí en celular!\n\nSi deseas ingresar de todas formas\nEstablece 'Opacidad de Controles Táctiles' en 0%");
				}
				else
					openSubState(new options.ControlsSubState());
			case 'Gráficos':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuales':
				openSubState(new options.VisualsSettingsSubState());
			case 'Modo de Juego':
				openSubState(new options.GameplaySettingsSubState());
			case 'Ajustar Retraso y Combo':
				MusicBeatState.switchState(new options.NoteOffsetState());
			case 'S-v2':
				openSubState(new PSliceSubState());
			case 'Opciones V-Slice':
				openSubState(new VSliceSubState());
			#if (TOUCH_CONTROLS_ALLOWED || mobile)
			case 'Opciones de Celular':
				openSubState(new mobile.options.MobileOptionsSubState());
			#end
		}
	}

	override function create()
	{
		mainCam = initPsychCamera();
		funnyCam = new FlxCamera();
		funnyCam.bgColor.alpha = 0;
		FlxG.cameras.add(funnyCam, false);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		FlxG.cameras.list[FlxG.cameras.list.indexOf(funnyCam)].follow(camFollowPos);

		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Menu de Opciones", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.color = 0xFFea71fd;
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();

		bg.screenCenter();
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (num => option in options)
		{
			// Eliminamos temporalmente la carga de traducciones para forzar nuestro texto manual
			var optionText:Alphabet = new Alphabet(0, 0, option, true);
			optionText.screenCenter();
			optionText.x -= MobileScaleMode.gameCutoutSize.x / 2;
			optionText.y += (92 * (num - (options.length / 2))) + 45;
			optionText.cameras = [funnyCam];
			grpOptions.add(optionText);
		}

		changeSelection(0,true);
		ClientPrefs.saveSettings();

		#if TOUCH_CONTROLS_ALLOWED
		addTouchPad('UP_DOWN', 'A_B');

		var button = new TouchZone(90,270,FlxG.width,100,FlxColor.PURPLE);
		
		var scroll = new ScrollableObject(-0.01,100,0,FlxG.width-200,FlxG.height,button);
		scroll.onPartialScroll.add(delta -> changeSelection(delta,false));
        scroll.onFullScrollSnap.add(() ->changeSelection(0,true));
		scroll.onTap.add(() ->{
			openSelectedSubstate(options[curSelected]);
		});
		add(scroll);
		add(button);
		#end
		
		super.create();
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Menu de Opciones", null);
		#end
		controls.isInSubstate = false;
		persistentUpdate = funnyCam.visible = true;
		
		#if TOUCH_CONTROLS_ALLOWED
		removeTouchPad();
		addTouchPad('UP_DOWN', 'A_B');
		#end
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		if(exiting) return;

		if (controls.UI_UP_P){
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(-1,true);
		}
		if (controls.UI_DOWN_P){
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(1,true);
		}

		var lerpVal:Float = Math.max(0, Math.min(1, elapsed * 7.5));
		camFollowPos.setPosition(635, FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));


		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			exiting = false;
			if(onPlayState)
			{
				StageData.loadDirectory(PlayState.SONG);
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
			else MusicBeatState.switchState(new MainMenuState());
		}
		else if (controls.ACCEPT) openSelectedSubstate(options[curSelected]);
	}
	
	function changeSelection(delta:Float,usePrecision:Bool = false) {
		if(usePrecision) {
			if(delta != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			curSelected =  FlxMath.wrap(curSelected + Std.int(delta), 0, options.length - 1);
			curSelectedPartial = curSelected;
		}
		else {
			curSelectedPartial = FlxMath.bound(curSelectedPartial + delta, 0, options.length - 1);
			if(curSelected != Math.round(curSelectedPartial)) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			curSelected = Math.round(curSelectedPartial);
		}
		for (num => item in grpOptions.members)
		{
			item.targetY = num - curSelectedPartial;
			item.alpha = 0.6;
			if (num == curSelected)
			{
				item.alpha = 1;
				var thing:Float = grpOptions.members.length > 6 ? grpOptions.members.length * 2 : 0;
				var partialDiff = (curSelectedPartial-curSelected);
				if(partialDiff > 0 && grpOptions.length > curSelected+1){
					var nextItem = grpOptions.members[curSelected+1];
					var camY = FlxMath.lerp(item.y,nextItem.y,partialDiff);
					camFollow.setPosition(635, camY + 100 - thing);
				}
				else if(partialDiff < 0 && 0 <= curSelected-1) {
					 var prevItem = grpOptions.members[curSelected-1];
					 var camY = FlxMath.lerp(prevItem.y,item.y,1+partialDiff);
					 camFollow.setPosition(635, camY + 100 - thing);
				}
				else camFollow.setPosition(635, item.y + 100 - thing);
			}
		}

	}

	override function destroy()
	{
		ClientPrefs.loadPrefs();
		super.destroy();
	}
}