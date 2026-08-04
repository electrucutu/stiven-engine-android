/* in order to make this work with notetypes its recommended you put smth like this in your note lua:

customRgb = {
    {getColorFromHex('6D8AFF'), getColorFromHex('FFFFFF'), getColorFromHex('1C0052')}, 
    {getColorFromHex('6D8AFF'), getColorFromHex('FFFFFF'), getColorFromHex('1C0052')}, 
    {getColorFromHex('6D8AFF'), getColorFromHex('FFFFFF'), getColorFromHex('1C0052')}, 
    {getColorFromHex('6D8AFF'), getColorFromHex('FFFFFF'), getColorFromHex('1C0052')}
}
function onCreate()
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'noteType' then
            setPropertyFromGroup('unspawnNotes', i, 'rgbShader.r', customRgb[getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1][1])
            setPropertyFromGroup('unspawnNotes', i, 'rgbShader.g', customRgb[getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1][2])
            setPropertyFromGroup('unspawnNotes', i, 'rgbShader.b', customRgb[getPropertyFromGroup('unspawnNotes', i, 'noteData') + 1][3])
			setPropertyFromGroup('unspawnNotes', i, 'extraData.thirdStrum', true, true)
        end
    end
end
*/

import shaders.RGBPalette;
import psychlua.ModchartSprite;
import flixel.tweens.FlxTween;
import states.editors.ChartingState;
import objects.StrumNote;
import backend.CoolUtil;

//DO TOUCH
/*               LEFT R G B                      DOWN R G B                      UP R G B                        RIGHT R G B                   */
var customRgb = [['9708E8', 'FFFFFF', '4B0374'], ['1D5DEC', 'FFFFFF', '0E2F79'], ['87A3AD', 'FFFFFF', '2F3A3D'], ['AE005E', 'FFFFFF', '6D003B']];
var useCustomRGB = true; //Set to true to use preset colors.
var customTexture = 'noteSkins/NOTE_assets-future';
var useCustomTexture = false; //Set to true to use a custom texture for the 3rd strum.
//X pos when 3rd Strum is Visible
var thirdStrumOutPos = [-24, 82, 188, 294];
var opponentStrumOutPos = [426, 532, 638, 746];
var playerStrumOutPos = [854, 960, 1066, 1172];
//X pos when 3rd Strum is Hidden
var thirdStrumInPos = [-478, -366, -254, -142];
var opponentStrumInPos = [92, 204, 316, 428];
var playerStrumInPos = [732, 844, 956, 1068];

//DONT TOUCH
var thirdStrums = [];
var songStarted = false; //this is just for notes at the very start of the song

function onSongStart() {
    for (i in 0...4) {
        var thirdStrum = new StrumNote(thirdStrumInPos[i] + 24, opponentStrums.members[i].y, i, false);

        if (useCustomTexture) thirdStrum.texture = customTexture;

        if (useCustomRGB) {
            thirdStrum.rgbShader.r = CoolUtil.colorFromString(customRgb[i][0]);
            thirdStrum.rgbShader.g = CoolUtil.colorFromString(customRgb[i][1]);
            thirdStrum.rgbShader.b = CoolUtil.colorFromString(customRgb[i][2]);
            thirdStrum.playAnim('confirm');
            thirdStrum.playAnim('static');
        }

        thirdStrums[i] = thirdStrum;
        strumLineNotes.add(thirdStrum);
    }

    songStarted = true;
}

function opponentNoteHit(note) {
    var noteData = note.noteData;

    if (note.extraData.get('thirdStrum') == true)
	{
        thirdStrums[noteData].playAnim('confirm', true);
        thirdStrums[noteData].resetAnim = Conductor.stepCrochet * 1.25 / 1000 / playbackRate;
        opponentStrums.members[noteData].playAnim('static');
    }

}

function onUpdate(elapsed) {
    for (i in 0...PlayState.instance.notes.members.length) {
        var note = PlayState.instance.notes.members[i];
        if (songStarted) {
            if (note.extraData.get('thirdStrum') == true && note.x != thirdStrums[note.noteData].x + note.offsetX && songStarted /*|| note.noteType == 'GF Sing' god knows ill need this later*/) 
            {
                note.copyX = false;
                note.x = thirdStrums[note.noteData].x + note.offsetX;
            }
        }
    }
}

function onEvent(eventName, value1, value2, strummytime) {
    if (eventName.toLowerCase() == '3rd strum') {
        if (value1.toLowerCase() == 'show') {
            for (i in 0...4) {
                FlxTween.tween(thirdStrums[i], {x: (thirdStrumOutPos[i] + 24)}, value2, {ease: FlxEase.quartOut});
                FlxTween.tween(playerStrums.members[i], {x: playerStrumOutPos[i]}, value2, {ease: FlxEase.quartOut});
                FlxTween.tween(opponentStrums.members[i], {x: opponentStrumOutPos[i]}, value2, {ease: FlxEase.quartOut});
            }
        } else if (value1.toLowerCase() == 'hide') {
            for (i in 0...4) {
                FlxTween.tween(thirdStrums[i], {x: (thirdStrumInPos[i])}, value2, {ease: FlxEase.quartOut});
                FlxTween.tween(playerStrums.members[i], {x: playerStrumInPos[i]}, value2, {ease: FlxEase.quartOut});
                FlxTween.tween(opponentStrums.members[i], {x: opponentStrumInPos[i]}, value2, {ease: FlxEase.quartOut});
            }
        }
    }
}