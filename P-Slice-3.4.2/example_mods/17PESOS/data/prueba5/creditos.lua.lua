local creditBoxName = 'creditBox'
local creditTextName = 'creditText'

function onCreatePost()
    -- 1. Creamos el fondo negro semitransparente (ajustamos el tamaño a 230 de alto)
    makeLuaSprite(creditBoxName, '', -400, 220) -- Empieza fuera de la pantalla (izquierda)
    makeGraphic(creditBoxName, 350, 230, '000000')
    setObjectCamera(creditBoxName, 'camHUD')
    setProperty(creditBoxName .. '.alpha', 0.6)
    addLuaSprite(creditBoxName, true)

    -- 2. El texto actualizado con todo el equipo "Stiven"
    local textoCreditos = "DIRECTOR: stiven\nART: stiven\nCHART: stiven\nMUSIC: stiven\nPROGRAMACIÓN: stiven\nSTIVEN ENGINE: stiven"
    
    makeLuaText(creditTextName, textoCreditos, 330, -400, 230) -- Empieza fuera de la pantalla
    setTextSize(creditTextName, 20)
    setTextAlignment(creditTextName, 'left')
    setObjectCamera(creditTextName, 'camHUD')
    addLuaText(creditTextName)
end

function onSongStart()
    -- Cuando empieza la canción, el cuadro entra con una animación suave
    doTweenX('boxEntra', creditBoxName, 20, 1.0, 'cubeOut')
    doTweenX('textEntra', creditTextName, 30, 1.0, 'cubeOut')
    
    -- Se queda 4.5 segundos para dar tiempo a leer toda la lista
    runTimer('esperaCreditos', 4.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'esperaCreditos' then
        -- Animación para desaparecer hacia la izquierda
        doTweenX('boxSale', creditBoxName, -400, 1.0, 'cubeIn')
        doTweenX('textSale', creditTextName, -400, 1.0, 'cubeIn')
    end
end