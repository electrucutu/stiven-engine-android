function onCreatePost()
    -- --- ESQUINA INFERIOR IZQUIERDA (Tiempo Actual) ---
    makeLuaText('tiempoActualTxt', '', 300, 20, 685)
    setTextSize('tiempoActualTxt', 22)
    setTextAlignment('tiempoActualTxt', 'left')
    setObjectCamera('tiempoActualTxt', 'hud')
    setTextBorder('tiempoActualTxt', 2, '000000')
    addLuaText('tiempoActualTxt')

    -- --- ESQUINA INFERIOR DERECHA (Tiempo Total) ---
    makeLuaText('tiempoTotalTxt', '', 300, 960, 685) -- 960 para que quede bien alineado al borde derecho
    setTextSize('tiempoTotalTxt', 22)
    setTextAlignment('tiempoTotalTxt', 'right')
    setObjectCamera('tiempoTotalTxt', 'hud')
    setTextBorder('tiempoTotalTxt', 2, '000000')
    addLuaText('tiempoTotalTxt')
end

function onUpdatePost(elapsed)
    local tiempoActualMs = getSongPosition()
    local tiempoTotalMs = songLength
    
    if tiempoActualMs < 0 then tiempoActualMs = 0 end

    -- Cálculos de segundos y minutos
    local actualSegundos = math.floor(tiempoActualMs / 1000)
    local totalSegundos = math.floor(tiempoTotalMs / 1000)

    local minActual = math.floor(actualSegundos / 60)
    local segActual = actualSegundos % 60
    
    local minTotal = math.floor(totalSegundos / 60)
    local segTotal = totalSegundos % 60

    -- Formateamos los textos por separado
    local textoActual = string.format("%d:%02d", minActual, segActual)
    local textoTotal = string.format("%d:%02d", minTotal, segTotal)

    -- Actualizamos cada esquina con su respectivo dato
    setTextString('tiempoActualTxt', textoActual)
    setTextString('tiempoTotalTxt', textoTotal)
end