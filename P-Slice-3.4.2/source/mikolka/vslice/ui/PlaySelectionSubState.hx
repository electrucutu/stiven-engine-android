package mikolka.vslice.ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.effects.FlxFlicker;
import mikolka.compatibility.VsliceOptions;
import mikolka.vslice.freeplay.FreeplayState;

class PlaySelectionSubState extends FlxSubState
{
	var images:FlxTypedGroup<FlxSprite>;
	var optionNames:Array<String> = ['story', 'extra', 'covers'];
	var curSelected:Int = 0;
	var acceptInput:Bool = true;

	// Variable estática para que FreeplayState sepa qué filtro aplicar
	public static var modoCargado:String = 'all';

	public function new()
	{
		super();

		var bgOverlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF000000);
		bgOverlay.alpha = 0.7;
		bgOverlay.scrollFactor.set();
		add(bgOverlay);

		images = new FlxTypedGroup<FlxSprite>();
		add(images);

		for (i in 0...3)
		{
			var img:FlxSprite = new FlxSprite();
			img.loadGraphic(Paths.image('gallery/' + (i + 1))); 
			img.antialiasing = VsliceOptions.ANTIALIASING;
			img.ID = i;
			img.scrollFactor.set();

			img.setGraphicSize(Std.int(img.width * 0.45));
			img.updateHitbox();

			img.x = (FlxG.width / 4) * (i + 1) - (img.width / 2);
			img.y = (FlxG.height / 2) - (img.height / 2);

			images.add(img);
		}

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!acceptInput) return;

		if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			close(); 
		}

		for (img in images.members)
		{
			if (FlxG.mouse.overlaps(img))
			{
				if (curSelected != img.ID)
				{
					curSelected = img.ID;
					FlxG.sound.play(Paths.sound('scrollMenu'));
				}

				img.scale.set(FlxMath.lerp(img.scale.x, 0.48, elapsed * 12), FlxMath.lerp(img.scale.y, 0.48, elapsed * 12));
				img.alpha = 1.0;

				if (FlxG.mouse.justPressed)
				{
					selectOption(img);
				}
			}
			else
			{
				img.scale.set(FlxMath.lerp(img.scale.x, 0.45, elapsed * 12), FlxMath.lerp(img.scale.y, 0.45, elapsed * 12));
				img.alpha = 0.6;
			}
		}
	}

	function selectOption(targetImg:FlxSprite)
	{
		acceptInput = false; 
		FlxG.sound.play(Paths.sound('confirmMenu'));

		// Seteamos el filtro según el ID de la imagen seleccionada
		switch (targetImg.ID)
		{
			case 0: 
				modoCargado = 'story';  // Carga: prueba 1 (pico mix), prueba 2, prueba 3
			case 1: 
				modoCargado = 'extra';  // Carga: prueba 5
			case 2: 
				modoCargado = 'covers'; // Carga: prueba 1
		}

		FlxFlicker.flicker(targetImg, 1.0, 0.06, false, false, function(flick:FlxFlicker)
		{
			FlxG.mouse.visible = false;
			FlxG.switchState(new FreeplayState());
		});
	}
}