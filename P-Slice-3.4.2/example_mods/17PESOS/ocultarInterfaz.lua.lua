function onCreatePost()
    -- Ocultar las flechas (stritrum) del jugador y del oponente
    for i = 0, getProperty('strumLineNotes.length') - 1 do
        setPropertyFromGroup('strumLineNotes', i, 'visible', false)
    end

    -- Ocultar la barra de vida y el icono
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    
    -- Opcional: Ocultar el texto de puntuación y el rango
    setProperty('scoreTxt.visible', false)
end 
function onCreatePost()
    -- Ocultar las flechas (strumLineNotes)
    for i = 0, getProperty('strumLineNotes.length') - 1 do
        setPropertyFromGroup('strumLineNotes', i, 'visible', false)
    end

    -- Ocultar barra de vida e iconos
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    
    -- Ocultar puntuación
    setProperty('scoreTxt.visible', false)

    -- Ocultar el contador de tiempo
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
end
function onCreatePost()
    -- 1. Ocultar los receptores de notas (las flechas fijas)
    for i = 0, getProperty('strumLineNotes.length') - 1 do
        setPropertyFromGroup('strumLineNotes', i, 'visible', false)
    end

    -- 2. Ocultar las notas que van cayendo (el chart)
    -- Esto oculta todas las notas activas en pantalla
    setProperty('notes.visible', false)

    -- 3. Ocultar barra de vida e iconos
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('iconP1.visible', false)
    setProperty('iconP2.visible', false)
    
    -- 4. Ocultar textos (puntuación y tiempo)
    setProperty('scoreTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
end

-- Esto asegura que si aparecen nuevas notas, se mantengan ocultas
function onUpdate(elapsed)
    setProperty('notes.visible', false)
end