-- Configuración del temblor estilo Wednesday's Infidelity
local fuerzaTemblorX = 8  -- Qué tan fuerte se mueve hacia los lados (en píxeles)
local fuerzaTemblorY = 6  -- Qué tan fuerte se mueve hacia arriba y abajo
local rotacionFuerte = 1.5 -- Qué tanto gira la pantalla al temblar (en grados)

function onUpdate(elapsed)
    -- Generamos un movimiento totalmente aleatorio en cada frame
    -- math.random(-100, 100) / 100 da un número entre -1 y 1
    local desvioX = (math.random(-100, 100) / 100) * fuerzaTemblorX
    local desvioY = (math.random(-100, 100) / 100) * fuerzaTemblorY
    local desvioRot = (math.random(-100, 100) / 100) * rotacionFuerte

    -- Aplicamos el temblor a toda la interfaz (Flechas, barra, etc.)
    setProperty('camHUD.x', desvioX)
    setProperty('camHUD.y', desvioY)
    setProperty('camHUD.angle', desvioRot)
end

function onDestroy()
    -- Al salir de la canción, nos aseguramos de que el HUD regrese a su posición normal
    setProperty('camHUD.x', 0)
    setProperty('camHUD.y', 0)
    setProperty('camHUD.angle', 0)
end