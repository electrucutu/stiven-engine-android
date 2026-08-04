-- Configuración
local intensidad = 0.24 -- Qué tan fuerte es el latido (0.03 es sutil pero se nota)
local velocidad = 1     -- Velocidad del pulso

function onUpdate(elapsed)
    -- Calculamos el pulso base
    local pulso = 1 + (math.sin(getSongPosition() / 100 * velocidad) * intensidad)

    -- 1. Latido del Escenario y Personajes (Cámara del juego)
    -- Modificamos el zoom por defecto para que todo el fondo se mueva
    setProperty('defaultCamZoom', 0.59 * pulso) -- Ajusta el 0.85 al zoom original de tu mapa

    -- 2. Latido de la Interfaz (Flechas, Barra de vida, Texto, Iconos)
    -- Escalamos la cámara del HUD completa para que todo lata al unísono
    setProperty('camHUD.scale.x', pulso)
    setProperty('camHUD.scale.y', pulso)
end