package mikolka.vslice.ui.title;

import mikolka.compatibility.VsliceOptions;
import flixel.group.FlxGroup;

class IntroSubstate extends MusicBeatSubstate
{
    var credGroup:FlxGroup = new FlxGroup();
    var textGroup:FlxGroup = new FlxGroup();
	var blackScreen:FlxSprite;
	var credTextShit:Alphabet;
	var ngSpr:FlxSprite;

    var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

    public function new() {
        super();
        curWacky = FlxG.random.getObject(getIntroTextShit());
    }

    override function create() {
        super.create();
		blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		blackScreen.scale.set(FlxG.width, FlxG.height);
		blackScreen.updateHitbox();
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52);

		if (FlxG.random.bool(1))
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo_classic'));
		}
		else if (FlxG.random.bool(30))
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo_animated'), true, 600);
			ngSpr.animation.add('idle', [0, 1], 4);
			ngSpr.animation.play('idle');
			ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.55));
			ngSpr.y += 25;
		}
		else
		{
			ngSpr.loadGraphic(Paths.image('newgrounds_logo'));
			ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		}
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = VsliceOptions.FLASHBANG;
		ngSpr.visible = false;

        add(credGroup);
        add(textGroup); 
		add(ngSpr);
    }

	private var sickBeats:Int = 0;
	
	override function beatHit()
	{
		super.beatHit();
		sickBeats++;
		
		// Multiplicamos los tiempos por 4 para que cada texto dure mucho más en pantalla
		switch (sickBeats)
		{
			case 4:
				createCoolText(['Funkin Crew Inc', 'Shadow Mario', 'mikolka9144']);
			case 12:
				addMoreText('present');
			case 16:
				deleteCoolText();
			case 20:
				createCoolText(['Not associated', 'with'], -40);
			case 28:
				addMoreText('newgrounds', -40);
				ngSpr.visible = true;
			case 32:
				deleteCoolText();
				ngSpr.visible = false;
			case 36:
				createCoolText([curWacky[0]]);
			case 44:
				addMoreText(curWacky[1]);
			case 48:
				deleteCoolText();
			case 52:
				addMoreText('Friday');
			case 56:
				addMoreText('Night');
			case 60:
				addMoreText('Funkin');
		}
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			#if !LEGACY_PSYCH
			HapticUtil.vibrate(0, Constants.DEFAULT_VIBRATION_DURATION);
			#end

			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y = (i * 60) + offset;
			textGroup.add(money);
		}
		recenterTextGroup();
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if (textGroup != null)
		{
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y = (textGroup.length * 60) + offset;
			textGroup.add(coolText);
		}
		recenterTextGroup();
	}

	function recenterTextGroup()
	{
		if (textGroup != null && textGroup.length > 0)
		{
			var minY:Float = 99999;
			var maxY:Float = -99999;

			for (member in textGroup.members)
			{
				var spr:FlxSprite = cast member;
				if (spr != null)
				{
					if (spr.y < minY) minY = spr.y;
					if ((spr.y + spr.height) > maxY) maxY = spr.y + spr.height;
				}
			}

			var totalHeight:Float = maxY - minY;
			var targetY:Float = (FlxG.height - totalHeight) / 2;

			var diffY:Float = targetY - minY;
			for (member in textGroup.members)
			{
				var spr:FlxSprite = cast member;
				if (spr != null)
				{
					spr.y += diffY;
				}
			}
		}
	}

	function deleteCoolText()
	{
		if (textGroup != null)
		{
			textGroup.clear(); 
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		#if (MODS_ALLOWED && !LEGACY_PSYCH)
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt');
		#else
		var fullText:String = NativeFileSystem.getContent(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
		var swagGoodArray:Array<Array<String>> = [];
		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}
}