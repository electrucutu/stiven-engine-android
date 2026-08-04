-- Archivo: mods/states/FreeplayState.lua
-- Este script centra las canciones, iconos y la interfaz en el menú Freeplay para Psych Engine 1.0.4

local screenWidth = 1280

function onUpdatePost(elapsed)
    -- El juego original interpola la posición en onUpdate().
    -- Usamos onUpdatePost() para sobreescribir la posición X JUSTO ANTES de que se dibuje en pantalla,
    -- lo que evita cualquier "tartamudeo" o vibración visual.

    -- Obtenemos la cantidad de canciones en la lista
    local songCount = getProperty('grpSongs.length')
    
    if songCount ~= nil and songCount > 0 then
        for i = 0, songCount - 1 do
            -- Obtener el ancho de la fuente de la canción (Alphabet)
            local textWidth = getPropertyFromGroup('grpSongs', i, 'width')
            local iconWidth = 150 -- Tamaño estándar de los iconos de salud (HealthIcons)
            local padding = 15 -- Espacio de separación entre el texto y el icono
            
            -- Calculamos el ancho total de ambos elementos para centrarlos como un bloque perfecto
            local totalWidth = textWidth + padding + iconWidth
            local startX = (screenWidth / 2) - (totalWidth / 2)
            
            -- 1. Aplicamos la nueva posición X al texto para que quede en el centro
            setPropertyFromGroup('grpSongs', i, 'x', startX)
            
            -- 2. Colocamos el icono justo a la derecha del texto
            setProperty('iconArray['..i..'].x', startX + textWidth + padding)
        end
    end
    
    -- ===================================================================
    -- OPCIONAL: Centrar también la caja de puntaje (Score) 
    -- y el texto de dificultad en la parte superior derecha por defecto.
    -- ===================================================================
    
    if getProperty('scoreText.x') ~= nil then
        local scoreTextWidth = getProperty('scoreText.width')
        setProperty('scoreText.x', (screenWidth / 2) - (scoreTextWidth / 2))
        
        -- Ajustar el fondo negro translúcido al nuevo centro
        setProperty('scoreBG.x', getProperty('scoreText.x') - 6)
    end
    
    if getProperty('diffText.x') ~= nil then
        local diffTextWidth = getProperty('diffText.width')
        setProperty('diffText.x', (screenWidth / 2) - (diffTextWidth / 2))
    end
end