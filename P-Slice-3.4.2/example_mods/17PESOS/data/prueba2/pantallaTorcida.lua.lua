-- Configuración
local anguloMaximo = 10 -- Grados de torsión de pantalla
local velocidadGiro = 1.5 

function onUpdate(elapsed)
    -- 1. Torcer la pantalla (Cámaras)
    local balanceo = math.cos(getSongPosition() / 1000 * velocidadGiro) * anguloMaximo
    setProperty('camGame.angle', balanceo)
    setProperty('camHUD.angle', balanceo)

end

function onDestroy()
    -- Reseteamos todo al salir para no romper el resto del juego
    setProperty('camGame.angle', 0)
    setProperty('camHUD.angle', 0)
    setProperty('playbackRate', 1)
end
-- Configuración
local anguloMaximoFlechas = 45 -- Qué tan torcidas van a estar las flechas (45 grados)
local velocidadGiro = 2         -- Qué tan rápido rotan de lado a lado

function onUpdate(elapsed)
    -- 1. Calculamos el ángulo de torsión usando el tiempo de la canción
    local balanceo = math.cos(getSongPosition() / 1000 * velocidadGiro) * anguloMaximoFlechas

    -- 2. Torcer las flechas del Oponente (Str績ums del 0 al 3)
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'angle', balanceo)
    end

    -- 3. Torcer tus flechas (Player Str績ums del 0 al 3)
    for i = 0, 3 do
        setPropertyFromGroup('playerStrums', i, 'angle', balanceo)
    end
    
    -- 4. Torcer también la pantalla completa (por si quieres mantener el efecto de fondo)
    setProperty('camGame.angle', balanceo * 0.3) -- Un giro más suave para el fondo para no marear tanto
end

function onDestroy()
    -- Reseteamos el ángulo de las flechas al salir
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'angle', 0)
        setPropertyFromGroup('playerStrums', i, 'angle', 0)
    end
    setProperty('camGame.angle', 0)
end
