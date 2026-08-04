-- ==========================================================
-- MODIFICA ESTOS TEXTOS A TU GUSTO PARA CUANDO EL BOT ESTÉ ACTIVO:
local textoBotIzquierda = "ELBOT"
local textoBotDerecha   = "JUEGA POR VOS"
-- ==========================================================

function onCreatePost()
    -- --- ESQUINA INFERIOR IZQUIERDA ---
    makeLuaText('tiempoActualTxt', '', 300, 20, 685)
    setTextSize('tiempoActualTxt', 22)
    setTextAlignment('tiempoActualTxt', 'left')
    setObjectCamera('tiempoActualTxt', 'hud')
    setTextBorder('tiempoActualTxt', 2, '000000')
    addLuaText('tiempoActualTxt')

    -- --- ESQUINA INFERIOR DERECHA ---
    makeLuaText('tiempoTotalTxt', '', 300, 960, 685)
    setTextSize('tiempoTotalTxt', 22)
    setTextAlignment('tiempoTotalTxt', 'right')
    setObjectCamera('tiempoTotalTxt', 'hud')
    setTextBorder('tiempoTotalTxt', 2, '000000')
    addLuaText('tiempoTotalTxt')
end

function onUpdatePost(elapsed)
    -- Verificamos si el Botplay está activado en el juego
    if botPlay then
        -- Si el Bot está jugando, muestra los textos modificables
        setTextString('tiempoActualTxt', textoBotIzquierda)
        setTextString('tiempoTotalTxt', textoBotDerecha)
    else
        -- Si juegas tú normalmente, muestra el tiempo de la música
        local tiempoActualMs = getSongPosition()
        local tiempoTotalMs = songLength
        
        if tiempoActualMs < 0 then tiempoActualMs = 0 end

        local actualSegundos = math.floor(tiempoActualMs / 1000)
        local totalSegundos = math.floor(tiempoTotalMs / 1000)

        local minActual = math.floor(actualSegundos / 60)
        local segActual = actualSegundos % 60
        
        local minTotal = math.floor(totalSegundos / 60)
        local segTotal = totalSegundos % 60

        local textoActual = string.format("%d:%02d", minActual, segActual)
        local textoTotal = string.format("%d:%02d", minTotal, segTotal)

        setTextString('tiempoActualTxt', textoActual)
        setTextString('tiempoTotalTxt', textoTotal)
    end
end