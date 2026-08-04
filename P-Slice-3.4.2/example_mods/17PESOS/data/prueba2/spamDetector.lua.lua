-- Configuración
local spamLimit = 5 -- Cantidad de veces que puede fallar antes de castigo
local timerLimit = 0.5 -- Tiempo en segundos para considerar "spam"
local spamCount = 0
local spamTimer = 0

function onUpdate(elapsed)
    -- Reducir el contador de spam con el tiempo
    if spamTimer > 0 then
        spamTimer = spamTimer - elapsed
    else
        spamCount = 0
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
    -- Si el jugador falla una nota, aumentamos el spam
    spamCount = spamCount + 1
    spamTimer = timerLimit
    
    if spamCount >= spamLimit then
        triggerSpamPenalty()
    end
end

function triggerSpamPenalty()
    -- Efecto visual: sobrecalentamiento
    cameraShake('camGame', 0.05, 0.2)
    setProperty('health', getProperty('health') - 0.1) -- Penalización de vida
    
    -- Cambiar color de la pantalla a rojo momentáneamente
    makeLuaSprite('redFlash', '', 0, 0)
    makeGraphic('redFlash', screenWidth, screenHeight, 'FF0000')
    setObjectCamera('redFlash', 'other')
    setProperty('redFlash.alpha', 0.4)
    addLuaSprite('redFlash', true)
    
    doTweenAlpha('redFlashGone', 'redFlash', 0, 0.5, 'linear')
    
    -- Reiniciar contador
    spamCount = 0
    debugPrint("¡Cuidado con el spam!")
end