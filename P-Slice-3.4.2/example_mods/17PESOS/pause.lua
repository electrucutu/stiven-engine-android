-- Custom Pause Menu - Psych Engine 1.0.4 Pure Lua Rewrite (Zero Haxe Errors)
local tinocoPaused = false
local resume = false
local restart = false
local exit = false
local animProgress = 0
local musicTimer = 0

function onPause()
	-- Si el jugador no está muerto, abre el substate nativo de pausa congelando todo
	if not tinocoPaused and not getProperty('isDead') then
		openCustomSubstate('tinoco_pause', true)
		return Function_Stop
	end
end

function onCreate()
	precacheSound('LullabyPause')

	-- Fondo oscuro
	makeGraphic('bg', screenWidth, screenHeight, '000000')
	setObjectCamera('bg', 'other')
	setProperty('bg.visible', false)
	addLuaSprite('bg')

	-- Imágenes decorativas
	makeLuaSprite('left', 'pause/left', -1000, 0)
	setObjectCamera('left', 'other')
	setProperty('left.visible', false)
	addLuaSprite('left')

	makeLuaSprite('right', 'pause/right', 1200, 0)
	setObjectCamera('right', 'other')
	setProperty('right.visible', false)
	addLuaSprite('right')

	-- Caja del menú
	makeLuaSprite('box', 'pause/box', 470, 245)
	setObjectCamera('box', 'other')
	scaleObject('box', 0.5, 0.5)
	setProperty('box.visible', false)
	addLuaSprite('box')

	-- Textos de las opciones
	makeLuaText('h2', 'RESUME', 600, 365, 315)
	setObjectCamera('h2', 'other')
	setTextSize('h2', 30)
	setTextFont('h2', 'poketext.ttf')
	setProperty('h2.visible', false)
	addLuaText('h2')

	makeLuaText('h3', 'RESTART', 600, 379, 350)
	setObjectCamera('h3', 'other')
	setTextSize('h3', 30)
	setTextFont('h3', 'poketext.ttf')
	setProperty('h3.visible', false)
	addLuaText('h3')

	makeLuaText('h4', 'EXIT', 600, 330, 385)
	setObjectCamera('h4', 'other')
	setTextSize('h4', 30)
	setTextFont('h4', 'poketext.ttf')
	setProperty('h4.visible', false)
	addLuaText('h4')

	-- Flecha selectora
	makeLuaSprite('pointydoingy', 'pause/arrow', 525, 320)
	setObjectCamera('pointydoingy', 'other')
	scaleObject('pointydoingy', 0.05, 0.05)
	setProperty('pointydoingy.visible', false)
	addLuaSprite('pointydoingy')
end

-- Este bloque se ejecuta en el instante en que el juego se congela nativamente
function onCustomSubstateCreate(name)
	if name == 'tinoco_pause' then
		tinocoPaused = true
		resume = true
		restart = false
		exit = false
		animProgress = 0
		musicTimer = 0

		-- Mostramos el menú arriba de la pantalla congelada
		setProperty('bg.visible', true)
		setProperty('left.visible', true)
		setProperty('right.visible', true)
		setProperty('box.visible', true)
		setProperty('h2.visible', true)
		setProperty('h3.visible', true)
		setProperty('h4.visible', true)
		setProperty('pointydoingy.visible', true)

		-- Valores iniciales para la animación de entrada
		setProperty('left.x', -1000)
		setProperty('right.x', 1200)
		setProperty('bg.alpha', 0)
		setProperty('h2.alpha', 0)
		setProperty('h3.alpha', 0)
		setProperty('h4.alpha', 0)
		setProperty('box.alpha', 0)
		setProperty('pointydoingy.alpha', 0)

		playSound('LullabyPause', 0.7, 'pausesong')
	end
end

-- Este bloque maneja los controles y animaciones mientras el juego sigue pausado
function onCustomSubstateUpdate(name, elapsed)
	if name == 'tinoco_pause' then
		
		-- Loop manual de la música (independiente del reloj congelado del juego)
		musicTimer = musicTimer + elapsed
		if musicTimer >= 85.523 then
			musicTimer = 0
			playSound('LullabyPause', 0.7, 'pausesong')
		end

		-- Animación de entrada matemática y ultra fluida (no usa tweens del motor)
		if animProgress < 1 then
			animProgress = animProgress + (elapsed * 4)
			if animProgress > 1 then animProgress = 1 end

			setProperty('left.x', -1000 + (1000 * animProgress))
			setProperty('right.x', 1200 - (604 * animProgress))
			setProperty('bg.alpha', 0.4 * animProgress)
			setProperty('h2.alpha', animProgress)
			setProperty('h3.alpha', animProgress)
			setProperty('h4.alpha', animProgress)
			setProperty('box.alpha', animProgress)
			setProperty('pointydoingy.alpha', animProgress)
		end

		-- Posición de la flecha selectora
		if resume then
			setProperty('pointydoingy.y', 320)
		elseif restart then
			setProperty('pointydoingy.y', 355)
		elseif exit then
			setProperty('pointydoingy.y', 390)
		end

		-- Navegación para arriba
		if keyJustPressed('up') then
			if resume then
				resume = false; restart = false; exit = true
			elseif exit then
				resume = false; restart = true; exit = false
			elseif restart then
				resume = true; restart = false; exit = false
			end
		end

		-- Navegación para abajo
		if keyJustPressed('down') then
			if resume then
				resume = false; restart = true; exit = false
			elseif restart then
				resume = false; restart = false; exit = true
			elseif exit then
				resume = true; restart = false; exit = false
			end
		end

		-- Si vuelven a tocar la tecla de Pausa (Escape), despausa directo
		if keyJustPressed('pause') then
			hidePauseMenu()
			stopSound('pausesong')
			tinocoPaused = false
			closeCustomSubstate()
		end

		-- SELECCIONAR CON ENTER O ESPACIO (keyJustPressed 'accept' lee ambos por defecto)
		if keyJustPressed('accept') then
			if resume == true then
				hidePauseMenu()
				stopSound('pausesong')
				tinocoPaused = false
				closeCustomSubstate() -- Cierra el estado y el juego sigue normal
			elseif restart == true then
				stopSound('pausesong')
				restartSong(false)    -- Reinicia el mapa al toque
			elseif exit == true then
				stopSound('pausesong')
				exitSong(false)       -- Sale al menú principal sin trabas
			end
		end
	end
end

function hidePauseMenu()
	setProperty('bg.visible', false)
	setProperty('left.visible', false)
	setProperty('right.visible', false)
	setProperty('box.visible', false)
	setProperty('h2.visible', false)
	setProperty('h3.visible', false)
	setProperty('h4.visible', false)
	setProperty('pointydoingy.visible', false)
end