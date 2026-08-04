-- Script para quitar vida hasta dejar al jugador a 0.1 de vida (al borde de la muerte)
-- Compatible con Psych Engine 1.0.4+

local dañoPorNota = 0.05 -- Cuánta vida pierdes por nota

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    local vidaActual = getProperty('health')
    
    -- Solo te quita vida si estás por encima del 0.1
    if vidaActual > 0.1 then
        local nuevaVida = vidaActual - dañoPorNota
        
        -- Si el golpe te iba a bajar de 0.1, te frena exactamente en el límite
        if nuevaVida < 0.1 then
            nuevaVida = 0.1
        end
        
        setProperty('health', nuevaVida)
    end
end