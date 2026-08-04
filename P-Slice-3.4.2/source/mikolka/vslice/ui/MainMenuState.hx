package mikolka.vslice.ui;

import mikolka.vslice.ui.mainmenu.DesktopMenuState;
import mikolka.compatibility.ui.MainMenuHooks;
import mikolka.compatibility.VsliceOptions;
import mikolka.vslice.ui.title.TitleState;
import mikolka.compatibility.ModsHelper;
import options.OptionsState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import mikolka.vslice.freeplay.FreeplayState;
import states.GaleriaState; 

class MainMenuState extends MusicBeatState
{
	#if !LEGACY_PSYCH
	public static var psychEngineVersion:String = '1.0.4';
	#else
	public static var psychEngineVersion:String = '0.6.3';
	#end
	public static var pSliceVersion:String = '3.4.2';
	public static var funkinVersion:String = '0.7.6';

	var bg:FlxSprite;
	var magenta:FlxSprite;
	var logo:FlxSprite;
	var bgBaseX:Float = 0;
	var bgBaseY:Float = 0;
	var logoBaseX:Float = 0;
	var logoBaseY:Float = 80;

	var stickerSubState:Bool;
	var optionShit:Array<String> = ['play', 'galeria', 'credits', 'options'];
	
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Int = 0;

	var textModo:FlxText;

	var alertaBtn:FlxSprite;
	var cartelBox:FlxSprite;
	var cartelTxt:FlxText;
	var viendoCartel:Bool = false;

	public function new(?stickers:Bool = false)
	{
		super();
		stickerSubState = stickers;
	}

	override function create()
	{
		#if false
		var _dummy = new GaleriaState();
		#end

		if(stickerSubState) ModsHelper.clearStoredWithoutStickers();
		else #if !LEGACY_PSYCH backend.CacheSystem.clearStoredMemory(); #end
		#if !LEGACY_PSYCH backend.CacheSystem.clearUnusedMemory(); #end
		
		#if (debug && !LEGACY_PSYCH)
		FlxG.console.registerFunction("dumpCache", backend.CacheSystem.cacheStatus); 
		FlxG.console.registerFunction("dumpSystem", backend.Native.buildSystemInfo);
		#end
		
		ModsHelper.resetActiveMods();
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		persistentDraw = true;

		FlxG.mouse.visible = true;
		if (FlxG.sound.music != null && !FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
		}

		bg = new FlxSprite().loadGraphic(Paths.image('mainmenu/bg'));
		bg.antialiasing = VsliceOptions.ANTIALIASING;
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		bg.updateHitbox();
		bg.scrollFactor.set(0, 0);
		add(bg);

		magenta = new FlxSprite().loadGraphic(Paths.image('mainmenu/bg'));
		magenta.antialiasing = VsliceOptions.ANTIALIASING;
		magenta.setGraphicSize(Std.int(magenta.width * 1.5));
		magenta.updateHitbox();
		magenta.scrollFactor.set(0, 0);
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		bgBaseX = (FlxG.width - bg.width) / 2;
		bgBaseY = (FlxG.height - bg.height) / 2;
		bg.x = bgBaseX;
		bg.y = bgBaseY;
		magenta.x = bgBaseX;
		magenta.y = bgBaseY;

		logo = new FlxSprite().loadGraphic(Paths.image('mainmenu/logo'));
		logo.antialiasing = VsliceOptions.ANTIALIASING;
		logo.setGraphicSize(Std.int(logo.width * 0.45));
		logo.updateHitbox();
		
		logoBaseX = (FlxG.width - logo.width) / 2;
		logo.x = logoBaseX;
		logo.y = logoBaseY;
		logo.scrollFactor.set(0, 0);
		add(logo);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite();
			menuItem.loadGraphic(Paths.image('mainmenu/' + optionShit[i]));
			menuItem.antialiasing = VsliceOptions.ANTIALIASING;
			menuItem.ID = i;
			menuItem.scrollFactor.set(0, 0);
			switch(optionShit[i])
			{
				case 'play':
					menuItem.setGraphicSize(Std.int(menuItem.width * 0.95));
					menuItem.updateHitbox();
					menuItem.x = (FlxG.width / 2) + 40;
					menuItem.y = 450;

				case 'galeria':
					menuItem.setGraphicSize(Std.int(menuItem.width * 0.95));
					menuItem.updateHitbox();
					menuItem.x = (FlxG.width / 2) - menuItem.width - 40;
					menuItem.y = 450;

				case 'credits':
					menuItem.setGraphicSize(Std.int(menuItem.width * 0.75));
					menuItem.updateHitbox();
					menuItem.x = (FlxG.width / 2) - menuItem.width - 60; 
					menuItem.y = 600;

				case 'options':
					menuItem.setGraphicSize(Std.int(menuItem.width * 0.75));
					menuItem.updateHitbox();
					menuItem.x = (FlxG.width / 2) + 60; 
					menuItem.y = 600;
			}
			
			menuItems.add(menuItem);
		}

		var fnfVer:FlxText = new FlxText(10, FlxG.height - 24, FlxG.width, "STIVEN ENGINE V2", 12);
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fnfVer.scrollFactor.set();
		add(fnfVer);

		#if ACHIEVEMENTS_ALLOWED
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			MainMenuHooks.unlockFriday();

		#if MODS_ALLOWED
		MainMenuHooks.reloadAchievements();
		#end
		#end

		super.create();

		var uiFront:FlxSprite = new FlxSprite(0, 0);
		uiFront.loadGraphic(Paths.image('UI_Front'));
		uiFront.antialiasing = VsliceOptions.ANTIALIASING;
		uiFront.scrollFactor.set(0, 0);
		uiFront.screenCenter();
		add(uiFront);

		alertaBtn = new FlxSprite();
		alertaBtn.loadGraphic(Paths.image('mainmenu/alerta'));
		alertaBtn.antialiasing = VsliceOptions.ANTIALIASING;
		alertaBtn.scrollFactor.set(0, 0);
		alertaBtn.setGraphicSize(Std.int(alertaBtn.width * 0.4));
		alertaBtn.updateHitbox();
		alertaBtn.x = 40; 
		alertaBtn.y = 40; 
		add(alertaBtn);

		cartelBox = new FlxSprite().makeGraphic(850, 250, FlxColor.BLACK);
		cartelBox.alpha = 0.9;
		cartelBox.scrollFactor.set(0, 0);
		cartelBox.screenCenter();
		cartelBox.visible = false;
		add(cartelBox);

		cartelTxt = new FlxText(cartelBox.x + 30, cartelBox.y + 40, cartelBox.width - 60, "", 20);
		cartelTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		cartelTxt.text = "LAS NOVEDADES DEL STIVEN ENGINE SON\n\nESTE MEGA ULTRA NUEVO MENU\n\nARREGLO DE BUG\n\nQUITO EL STORY MODE";
		cartelTxt.scrollFactor.set(0, 0);
		cartelTxt.visible = false;
		add(cartelTxt);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		var factorX:Float = (FlxG.mouse.x - (FlxG.width / 2)) / (FlxG.width / 2);
		var factorY:Float = (FlxG.mouse.y - (FlxG.height / 2)) / (FlxG.height / 2);

		var maxBgMove:Float = 50; 
		var maxLogoMove:Float = 25;
		bg.x = FlxMath.lerp(bg.x, bgBaseX - (factorX * maxBgMove), FlxMath.bound(elapsed * 6, 0, 1));
		bg.y = FlxMath.lerp(bg.y, bgBaseY - (factorY * maxBgMove), FlxMath.bound(elapsed * 6, 0, 1));
		magenta.x = bg.x;
		magenta.y = bg.y;
		logo.x = FlxMath.lerp(logo.x, logoBaseX + (factorX * maxLogoMove), FlxMath.bound(elapsed * 6, 0, 1));
		logo.y = FlxMath.lerp(logo.y, logoBaseY + (factorY * maxLogoMove), FlxMath.bound(elapsed * 6, 0, 1));

		if (!selectedSomethin)
		{
			if (!viendoCartel)
			{
				if (FlxG.keys.justPressed.SEVEN)
				{
					selectedSomethin = true;
					FlxG.mouse.visible = false;
					FlxG.sound.play(Paths.sound('scrollMenu'));
					MusicBeatState.switchState(Type.createInstance(Type.resolveClass('states.editors.MasterEditorMenu'), []));
				}

				for (item in menuItems.members)
				{
					if (FlxG.mouse.overlaps(item))
					{
						if (curSelected != item.ID)
						{
							curSelected = item.ID;
							FlxG.sound.play(Paths.sound('scrollMenu'));
						}

						item.scale.set(FlxMath.lerp(item.scale.x, 1.05, elapsed * 12), FlxMath.lerp(item.scale.y, 1.05, elapsed * 12));
						item.alpha = 1.0;

						if (FlxG.mouse.justPressed)
						{
							selectItem();
						}
					}
					else
					{
						item.scale.set(FlxMath.lerp(item.scale.x, 1.0, elapsed * 12), FlxMath.lerp(item.scale.y, 1.0, elapsed * 12));
						item.alpha = 0.8;
					}
				}

				if (FlxG.mouse.overlaps(alertaBtn))
				{
					alertaBtn.scale.set(FlxMath.lerp(alertaBtn.scale.x, 1.05, elapsed * 12), FlxMath.lerp(alertaBtn.scale.y, 1.05, elapsed * 12));
					alertaBtn.alpha = 1.0;

					if (FlxG.mouse.justPressed)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						viendoCartel = true;
						cartelBox.visible = true;
						cartelTxt.visible = true;
					}
				}
				else
				{
					alertaBtn.scale.set(FlxMath.lerp(alertaBtn.scale.x, 1.0, elapsed * 12), FlxMath.lerp(alertaBtn.scale.y, 1.0, elapsed * 12));
					alertaBtn.alpha = 0.8;
				}

				if (controls.BACK)
				{
					selectedSomethin = true;
					FlxG.mouse.visible = false;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					MusicBeatState.switchState(new TitleState());
				}
			}
			else
			{
				if (controls.BACK || FlxG.mouse.justPressed)
				{
					FlxG.sound.play(Paths.sound('cancelMenu'));
					viendoCartel = false;
					cartelBox.visible = false;
					cartelTxt.visible = false;
				}
			}
		}

		super.update(elapsed);
	}

	function selectItem()
	{
		selectedSomethin = true;
		var choice:String = optionShit[curSelected];

		switch (choice)
		{
			case 'play':
				// --- EL ARREGLO ESTÁ AQUÍ ---
				// Reseteamos por completo las entradas de clicks del mouse en el motor flixel
				// Esto hace que el click actual muera aquí y no se transfiera al submenú (PlaySelectionSubState)
				FlxG.mouse.reset();
				
				openSubState(new PlaySelectionSubState());
				selectedSomethin = false; 
				FlxG.mouse.visible = true; 
			case 'galeria':
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new GaleriaState());
			case 'credits':
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(Type.createInstance(Type.resolveClass('states.CreditsState'), []));
			case 'options':
				FlxG.mouse.visible = false;
				goToOptions();
		}
	}

	function goToOptions()
	{
		MusicBeatState.switchState(new OptionsState());
		#if !LEGACY_PSYCH OptionsState.onPlayState = false; #end
		if (PlayState.SONG != null)
		{
			PlayState.SONG.arrowSkin = null;
			PlayState.SONG.splashSkin = null;
			#if !LEGACY_PSYCH PlayState.stageUI = 'normal'; #end
		}
	}
}