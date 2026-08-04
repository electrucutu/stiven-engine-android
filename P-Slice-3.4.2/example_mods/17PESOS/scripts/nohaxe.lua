-- Script Independiente: nohaxe.lua
-- Esconde el contador original y crea uno 100% limpio en Lua

function onCreatePost()
	-- 1. Apaga por completo el contador de fábrica con el logo de Haxe
	setPropertyFromClass('Main', 'fpsVar.visible', false)

	-- 2. Crea un texto de Lua nuevo y estético para tus FPS
	makeLuaText('cleanFPS', 'FPS: 0', 200, 10, 10)
	setTextSize('cleanFPS', 16)
	setTextAlignment('cleanFPS', 'left')
	setObjectCamera('cleanFPS', 'other') -- Lo mantiene siempre visible arriba de todo
	
	-- Le ponemos un borde negro para que se lea bien en cualquier fondo
	setTextBorder('cleanFPS', 1.2, '000000') 
	
	addLuaText('cleanFPS')
end

function onUpdatePost(elapsed)
	-- 3. Lee los FPS reales del motor en tiempo real y actualiza el texto
	local currentFPS = getPropertyFromClass('Main', 'fpsVar.currentFPS')
	setTextString('cleanFPS', 'FPS: ' .. currentFPS)
	
	-- Opcional: Cambia de color si los FPS bajan de 60 (Verde = Bien, Rojo = Lag)
	if currentFPS >= 60 then
		setTextColor('cleanFPS', '00FF00')
	elseif currentFPS >= 30 then
		setTextColor('cleanFPS', 'FFFF00')
	else
		setTextColor('cleanFPS', 'FF0000')
	end
end

function onDestroy()
	-- Por seguridad, si salís al menú principal, le devuelve el control al motor
	setPropertyFromClass('Main', 'fpsVar.visible', true)
end