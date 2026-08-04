package states;

import objects.AttachedSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.utils.Assets as OpenFlAssets;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 0;
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	
	var franjaLineas:FlxSprite;
	var flechaIzquierda:FlxSprite;
	var flechaDerecha:FlxSprite;
	var botonBack:FlxSprite;

	var nameText:FlxText;
	var roleText:FlxText;
	var descText:FlxText;

	private var iconGroup:FlxTypedGroup<FlxSprite>;

	override function create()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Viewing Credits", null);
		#end

		FlxG.mouse.visible = true;
		persistentUpdate = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [
			["Stiven",			"stiven",			"Programador Principal de Stiven Engine",	"https://x.com",                     "FF0000"],
			["ninjamuffin99",		"ninjamuffin99",	"Programmer of Friday Night Funkin'",		"https://x.com/ninja_muffin99",		"CF2D2D"],
			["PhantomArcade",		"phantomarcade",	"Animator of Friday Night Funkin'",			"https://x.com/PhantomArcade3K",	"FADC45"],
			["evilsk8r",			"evilsk8r",			"Artist of Friday Night Funkin'",			"https://x.com/evilsk8r",			"5ABD4B"],
			["kawaisprite",			"kawaisprite",		"Composer of Friday Night Funkin'",			"https://x.com/kawaisprite",		"378FC7"]
		];

		for(i in defaultList) {
			if(i.length > 1) creditsStuff.push(i);
		}

		franjaLineas = new FlxSprite(0, 0).loadGraphic(Paths.image('creditos/linea'));
		franjaLineas.antialiasing = ClientPrefs.data.antialiasing;
		add(franjaLineas);
		franjaLineas.screenCenter();

		iconGroup = new FlxTypedGroup<FlxSprite>();
		add(iconGroup);

		for (i => credit in creditsStuff)
		{
			if(credit[5] != null) Mods.currentModDirectory = credit[5];
			var str:String = 'credits/missing_icon';
			if(credit[1] != null && credit[1].length > 0)
			{
				var fileName = 'credits/' + credit[1];
				if (Paths.fileExists('images/$fileName.png', IMAGE) || OpenFlAssets.exists(Paths.getPath('images/$fileName.png', IMAGE))) 
					str = fileName;
				#if MODS_ALLOWED
				else if (FileSystem.exists('mods/' + Mods.currentModDirectory + '/images/$fileName.png') || FileSystem.exists('assets/images/$fileName.png'))
					str = fileName;
				#end
			}

			var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image(str));
			icon.antialiasing = ClientPrefs.data.antialiasing;
			
			// Aumentamos el tamaño base de renderizado inicial a 300x300 píxeles
			icon.setGraphicSize(300, 300);
			icon.updateHitbox();
			
			icon.screenCenter(Y); 
			icon.ID = i;

			iconGroup.add(icon);
		}
		Mods.currentModDirectory = '';

		flechaIzquierda = new FlxSprite(0, 0).loadGraphic(Paths.image('creditos/triangle'));
		flechaIzquierda.antialiasing = ClientPrefs.data.antialiasing;
		flechaIzquierda.screenCenter(Y);
		add(flechaIzquierda);

		flechaDerecha = new FlxSprite(0, 0).loadGraphic(Paths.image('creditos/triangle'));
		flechaDerecha.antialiasing = ClientPrefs.data.antialiasing;
		flechaDerecha.flipX = true;
		flechaDerecha.screenCenter(Y);
		add(flechaDerecha);

		botonBack = new FlxSprite(40, 30).loadGraphic(Paths.image('creditos/back'));
		botonBack.antialiasing = ClientPrefs.data.antialiasing;
		botonBack.origin.set(botonBack.width / 2, botonBack.height / 2);
		add(botonBack);

		nameText = new FlxText(0, 50, FlxG.width, "", 42);
		nameText.setFormat(Paths.font("vcr.ttf"), 42, FlxColor.WHITE, CENTER);
		add(nameText);

		roleText = new FlxText(0, 585, FlxG.width, "", 28);
		roleText.setFormat(Paths.font("vcr.ttf"), 28, FlxColor.WHITE, CENTER);
		roleText.bold = true;
		add(roleText);

		descText = new FlxText(0, 638, FlxG.width, "", 22);
		descText.setFormat(Paths.font("vcr.ttf"), 22, 0x88FFFFFF, CENTER);
		add(descText);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	override function update(elapsed:Float)
	{
		if(!quitting)
		{
			var leftP = controls.UI_LEFT_P;
			var rightP = controls.UI_RIGHT_P;

			if (leftP)  changeSelection(-1);
			if (rightP) changeSelection(1);

			var lerpVal:Float = Math.exp(-elapsed * 12);
			if (FlxG.mouse.overlaps(botonBack))
			{
				botonBack.scale.x = FlxMath.lerp(1.25, botonBack.scale.x, lerpVal);
				botonBack.scale.y = FlxMath.lerp(1.25, botonBack.scale.y, lerpVal);
				botonBack.angle = FlxMath.lerp(-15, botonBack.angle, lerpVal);

				if (FlxG.mouse.justPressed) salirMenu();
			}
			else
			{
				botonBack.scale.x = FlxMath.lerp(1.0, botonBack.scale.x, lerpVal);
				botonBack.scale.y = FlxMath.lerp(1.0, botonBack.scale.y, lerpVal);
				botonBack.angle = FlxMath.lerp(0, botonBack.angle, lerpVal);
			}

			if (FlxG.mouse.justPressed)
			{
				if (FlxG.mouse.overlaps(flechaIzquierda)) changeSelection(-1);
				else if (FlxG.mouse.overlaps(flechaDerecha)) changeSelection(1);
				else
				{
					for (icon in iconGroup.members)
					{
						if (icon.ID == curSelected && FlxG.mouse.overlaps(icon))
						{
							if (creditsStuff[curSelected][3] != null && creditsStuff[curSelected][3].length > 4) {
								CoolUtil.browserLoad(creditsStuff[curSelected][3]);
							}
						}
					}
				}
			}

			if(controls.ACCEPT && creditsStuff[curSelected][3] != null && creditsStuff[curSelected][3].length > 4) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			
			if (controls.BACK) salirMenu();
		}

		for (icon in iconGroup.members)
		{
			var lerpVal:Float = Math.exp(-elapsed * 12);
			
			// Ajustamos el movimiento horizontal al nuevo tamaño de ancho
			var targetX:Float = (FlxG.width / 2) - (icon.width / 2) + ((icon.ID - curSelected) * 420);
			icon.x = FlxMath.lerp(targetX, icon.x, lerpVal);

			// Nueva escala base de 300 píxeles para que se vea grande como la imagen original
			var baseScale:Float = 300 / icon.frameWidth; 

			if (icon.ID == curSelected) {
				icon.scale.x = FlxMath.lerp(baseScale, icon.scale.x, lerpVal);
				icon.scale.y = FlxMath.lerp(baseScale, icon.scale.y, lerpVal);
				icon.alpha = 1.0;

				// Las flechas se acomodan dinámicamente según el tamaño del icono actual
				// Dejamos 35 píxeles de espacio para que queden perfectas
				flechaIzquierda.x = icon.x - flechaIzquierda.width - 35;
				flechaDerecha.x = icon.x + icon.width + 35;
			} else {
				icon.scale.x = FlxMath.lerp(baseScale * 0.7, icon.scale.x, lerpVal);
				icon.scale.y = FlxMath.lerp(baseScale * 0.7, icon.scale.y, lerpVal);
				icon.alpha = 0.0;
			}
		}
		
		super.update(elapsed);
	}

	function salirMenu()
	{
		FlxG.mouse.visible = false;
		FlxG.sound.play(Paths.sound('cancelMenu'));
		MusicBeatState.switchState(new MainMenuState());
		quitting = true;
	}

	function changeSelection(change:Int = 0)
	{
		var prevSelected:Int = curSelected;
		curSelected = FlxMath.wrap(curSelected + change, 0, creditsStuff.length - 1);
		if (prevSelected != curSelected)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		FlxTween.cancelTweensOf(bg);
		FlxTween.color(bg, 0.5, bg.color, newColor);

		nameText.text = creditsStuff[curSelected][0];
		
		if (creditsStuff[curSelected][0] == "Stiven") {
			roleText.text = "CREADOR DEL STIVEN ENGINE";
		} else {
			roleText.text = "EQUIPO FNF ORIGINAL";
		}
		
		descText.text = '"' + creditsStuff[curSelected][2] + '"';
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) {
					arr.push(folder);
					creditsStuff.push(arr);
				}
			}
		}
	}
	#end
}