function onCreatePost()
    -- En las versiones más nuevas, los datos de configuración están dentro de 'data'
    setPropertyFromClass('backend.ClientPrefs', 'data.ghostTapping', false)
end

function onDestroy()
    -- Opcional: Si quieres restaurar la configuración original del jugador al salir
    -- Psych Engine normalmente lo guarda solo, pero es buena práctica no dejarlo forzado
    -- si el usuario tiene activada la opción en su menú.
end