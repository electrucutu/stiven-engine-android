function onCreate()
    -- CAMBIA 'tu-cancion' POR EL NOMBRE DE TU CANCIÓN EN MINÚSCULAS
    if songName:lower() == 'prueba-1-(pico-mix)' then
        
        -- Revisa si el personaje jugable NO es Pico
        if boyfriendName ~= 'pico-player' and boyfriendName ~= 'pico' and boyfriendName ~= 'pico-playable' then
            
            -- Te saca inmediatamente de la canción y te devuelve al Freeplay
            exitSong() 
        end
    end
end