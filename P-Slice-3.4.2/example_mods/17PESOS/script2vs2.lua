-- Script by PerroBot64
function onCreate()
	makeAnimatedLuaSprite('Dad2', 'characters/black', 100, 680); -- Cambiar a personaje idle en XML
	addAnimationByPrefix('Dad2', 'idle', 'black idle remast0', 24, false); -- cambiar a caracteres idle en XML
    addAnimationByPrefix('Dad2', '0', 'black left0', 24, false); -- cambiar a caracter leftnote en XML
    addAnimationByPrefix('Dad2', '1', 'black down0', 24, false); -- cambiear a carscter downnote en XML
    addAnimationByPrefix('Dad2', '2', 'black up0', 24, false); -- cambiar a caracter upnote en XML
    addAnimationByPrefix('Dad2', '3', 'black right0', 24, false); -- cambiar a caracter rightnote en XML
	objectPlayAnimation('Dad2', 'idle'); 
	addLuaSprite('Dad2', true); -- false = agregar personaje detrás, true = agregar personaje encima
	setPropertyLuaSprite('Dad2', 'flipX', false);
end
function onBeatHit()
	-- activado 4 veces por secciónon
	if curBeat % 1 == 0 then
		objectPlayAnimation('Dad2', 'idle');
	end
end

lastNote = {0, ""}

function opponentNoteHit(id,d,t,s)

    lastNote[1] = d
    lastNote[2] = t
    
    if lastNote[2] == "No Animation" then -- Cambie "no animation" para que sea su tipo de nota, por lo general, puede mantenerlo como no animation, suponiendo que no lo esté usando en otro lugar
	objectPlayAnimation('Dad2', lastNote[1]);
    end
end
