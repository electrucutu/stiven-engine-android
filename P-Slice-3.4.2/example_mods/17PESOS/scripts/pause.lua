-- Custom Pause Menu - Psych Engine 1.0.4 Expanded Lua (Center Alignment Fix)
local tinocoPaused = false
local curSelected = 1 -- 1: RESUME, 2: RESTART, 3: OPTIONS, 4: CREDITS, 5: EXIT
local curOptSelected = 1 -- 1: BOTPLAY, 2: PRACTICE MODE
local menuState = 'main' -- 'main', 'options', 'credits'
local animProgress = 0
local musicTimer = 0

-- Coordenadas verticales perfectas para la flecha selectora
local arrowY = {275, 310, 345, 380, 415}
local optArrowY = {330, 365}

-- DETECTOR SEGURO EN LUA PURA: Detecta ENTER sin usar Haxe para evitar errores en pantalla
function isAcceptPressed()
	if keyJustPressed('accept') then
		return true
	end
	
	local normalEnter = getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER')
	local numpadEnter = getPropertyFromClass('flixel.FlxG', 'keys.justPressed.NUMPADENTER')
	
	return (normalEnter == true or numpadEnter == true)
end

function onPause()
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

	-- --- TEXTOS DEL MENÚ PRINCIPAL (Eje X unificado a 345 y centrados en el medio) ---
	makeLuaText('h2', 'RESUME', 600, 345, 275)
	setObjectCamera('h2', 'other')
	setTextSize('h2', 30)
	setTextFont('h2', 'poketext.ttf')
	setTextAlignment('h2', 'center')
	setProperty('h2.visible', false)
	addLuaText('h2')

	makeLuaText('h3', 'RESTART', 600, 345, 310)
	setObjectCamera('h3', 'other')
	setTextSize('h3', 30)
	setTextFont('h3', 'poketext.ttf')
	setTextAlignment('h3', 'center')
	setProperty('h3.visible', false)
	addLuaText('h3')

	makeLuaText('h5', 'OPTIONS', 600, 345, 345)
	setObjectCamera('h5', 'other')
	setTextSize('h5', 30)
	setTextFont('h5', 'poketext.ttf')
	setTextAlignment('h5', 'center')
	setProperty('h5.visible', false)
	addLuaText('h5')

	makeLuaText('h6', 'CREDITS', 600, 345, 380)
	setObjectCamera('h6', 'other')
	setTextSize('h6', 30)
	setTextFont('h6', 'poketext.ttf')
	setTextAlignment('h6', 'center')
	setProperty('h6.visible', false)
	addLuaText('h6')

	makeLuaText('h4', 'EXIT', 600, 345, 415)
	setObjectCamera('h4', 'other')
	setTextSize('h4', 30)
	setTextFont('h4', 'poketext.ttf')
	setTextAlignment('h4', 'center')
	setProperty('h4.visible', false)
	addLuaText('h4')

	-- Flecha selectora
	makeLuaSprite('pointydoingy', 'pause/arrow', 525, 275)
	setObjectCamera('pointydoingy', 'other')
	scaleObject('pointydoingy', 0.05, 0.05)
	setProperty('pointydoingy.visible', false)
	addLuaSprite('pointydoingy')

	-- --- TEXTOS SUB-MENÚ CRÉDITOS (Centrado perfecto) ---
	makeLuaText('creditsTitle', 'CREDITS', 600, 345, 255)
	setObjectCamera('creditsTitle', 'other')
	setTextSize('creditsTitle', 35)
	setTextFont('creditsTitle', 'poketext.ttf')
	setTextAlignment('creditsTitle', 'center')
	setProperty('creditsTitle.visible', false)
	addLuaText('creditsTitle')

	makeLuaText('creditsBody', 'DIRECTOR: STIVEN\nPROGRAMACION FIX: STIVEN\nDYLAN 2: ARTISTA DE SPRITES\nMELI 3: ARTISTA DE LOS FONDOS\nALAN 4: BETA TESTER\nE 5: SISISIII', 600, 345, 295)
	setObjectCamera('creditsBody', 'other')
	setTextSize('creditsBody', 18) 
	setTextFont('creditsBody', 'poketext.ttf')
	setTextAlignment('creditsBody', 'center')
	setProperty('creditsBody.visible', false)
	addLuaText('creditsBody')

	makeLuaText('creditsBack', 'PRESS ENTER TO GO BACK', 600, 345, 425)
	setObjectCamera('creditsBack', 'other')
	setTextSize('creditsBack', 16)
	setTextFont('creditsBack', 'poketext.ttf')
	setTextAlignment('creditsBack', 'center')
	setProperty('creditsBack.visible', false)
	addLuaText('creditsBack')

	-- --- TEXTOS SUB-MENÚ OPCIONES (Centrado perfecto) ---
	makeLuaText('optTitle', 'OPTIONS', 600, 345, 270)
	setObjectCamera('optTitle', 'other')
	setTextSize('optTitle', 35)
	setTextFont('optTitle', 'poketext.ttf')
	setTextAlignment('optTitle', 'center')
	setProperty('optTitle.visible', false)
	addLuaText('optTitle')

	makeLuaText('opt1Text', 'BOTPLAY: OFF', 600, 345, 330)
	setObjectCamera('opt1Text', 'other')
	setTextSize('opt1Text', 24)
	setTextFont('opt1Text', 'poketext.ttf')
	setTextAlignment('opt1Text', 'center')
	setProperty('opt1Text.visible', false)
	addLuaText('opt1Text')

	makeLuaText('opt2Text', 'PRACTICE: OFF', 600, 345, 365)
	setObjectCamera('opt2Text', 'other')
	setTextSize('opt2Text', 24)
	setTextFont('opt2Text', 'poketext.ttf')
	setTextAlignment('opt2Text', 'center')
	setProperty('opt2Text.visible', false)
	addLuaText('opt2Text')

	makeLuaText('optBack', 'PRESS ESC TO GO BACK', 600, 345, 415)
	setObjectCamera('optBack', 'other')
	setTextSize('optBack', 16)
	setTextFont('optBack', 'poketext.ttf')
	setTextAlignment('optBack', 'center')
	setProperty('optBack.visible', false)
	addLuaText('optBack')
end

function onCustomSubstateCreate(name)
	if name == 'tinoco_pause' then
		tinocoPaused = true
		curSelected = 1
		curOptSelected = 1
		menuState = 'main'
		animProgress = 0
		musicTimer = 0

		showMainMenu()
		setProperty('bg.visible', true)
		setProperty('left.visible', true)
		setProperty('right.visible', true)
		setProperty('box.visible', true)

		setProperty('left.x', -1000)
		setProperty('right.x', 1200)
		setProperty('bg.alpha', 0)
		setProperty('box.alpha', 0)
		setMenuAlpha(0)

		playSound('LullabyPause', 0.7, 'pausesong')
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'tinoco_pause' then
		
		-- Loop de la música
		if menuState ~= 'credits' then
			musicTimer = musicTimer + elapsed
			if musicTimer >= 85.523 then
				musicTimer = 0
				playSound('LullabyPause', 0.7, 'pausesong')
			end
		end

		-- Animación fluida de entrada
		if animProgress < 1 then
			animProgress = animProgress + (elapsed * 4)
			if animProgress > 1 then animProgress = 1 end

			setProperty('left.x', -1000 + (1000 * animProgress))
			setProperty('right.x', 1200 - (604 * animProgress))
			setProperty('bg.alpha', 0.4 * animProgress)
			setProperty('box.alpha', animProgress)
			setMenuAlpha(animProgress)
		end

		local acceptPressed = isAcceptPressed()

		-- --- LÓGICA DE CONTROL SEGÚN LA PANTALLA ACTIVA ---
		if menuState == 'main' then
			setProperty('pointydoingy.y', arrowY[curSelected])

			if keyJustPressed('up') then
				curSelected = curSelected - 1
				if curSelected < 1 then curSelected = 5 end
				playSound('scrollMenu')
			end

			if keyJustPressed('down') then
				curSelected = curSelected + 1
				if curSelected > 5 then curSelected = 1 end
				playSound('scrollMenu')
			end

			if keyJustPressed('pause') and not acceptPressed then
				resumeGame()
			end

			if acceptPressed then
				if curSelected == 1 then     -- RESUME
					resumeGame()
				elseif curSelected == 2 then -- RESTART
					stopSound('pausesong')
					restartSong(false)
				elseif curSelected == 3 then -- OPTIONS
					menuState = 'options'
					curOptSelected = 1
					showOptionsMenu()
					playSound('scrollMenu')
				elseif curSelected == 4 then -- CREDITS
					menuState = 'credits'
					stopSound('pausesong') 
					showCreditsMenu()
					playSound('scrollMenu')
				elseif curSelected == 5 then -- EXIT
					stopSound('pausesong')
					exitSong(false)
				end
			end

		elseif menuState == 'options' then
			setProperty('pointydoingy.y', optArrowY[curOptSelected])

			if getProperty('cpuControlled') then
				setTextString('opt1Text', 'BOTPLAY: ON')
				setTextColor('opt1Text', '00FF00')
			else
				setTextString('opt1Text', 'BOTPLAY: OFF')
				setTextColor('opt1Text', 'FF0000')
			end

			if getProperty('practiceMode') then
				setTextString('opt2Text', 'PRACTICE: ON')
				setTextColor('opt2Text', '00FF00')
			else
				setTextString('opt2Text', 'PRACTICE: OFF')
				setTextColor('opt2Text', 'FF0000')
			end

			if keyJustPressed('up') or keyJustPressed('down') then
				if curOptSelected == 1 then curOptSelected = 2 else curOptSelected = 1 end
				playSound('scrollMenu')
			end

			if keyJustPressed('left') or keyJustPressed('right') or acceptPressed then
				if curOptSelected == 1 then
					setProperty('cpuControlled', not getProperty('cpuControlled'))
				else
					setProperty('practiceMode', not getProperty('practiceMode'))
				end
				playSound('scrollMenu')
			end

			if keyJustPressed('pause') and not acceptPressed then
				menuState = 'main'
				showMainMenu()
				playSound('scrollMenu')
			end

		elseif menuState == 'credits' then
			if acceptPressed or keyJustPressed('pause') then
				menuState = 'main'
				musicTimer = 0
				playSound('LullabyPause', 0.7, 'pausesong') 
				showMainMenu()
				playSound('scrollMenu')
			end
		end
	end
end

function showMainMenu()
	setProperty('h2.visible', true)
	setProperty('h3.visible', true)
	setProperty('h5.visible', true)
	setProperty('h6.visible', true)
	setProperty('h4.visible', true)
	setProperty('pointydoingy.visible', true)
	
	setProperty('creditsTitle.visible', false)
	setProperty('creditsBody.visible', false)
	setProperty('creditsBack.visible', false)
	setProperty('optTitle.visible', false)
	setProperty('opt1Text.visible', false)
	setProperty('opt2Text.visible', false)
	setProperty('optBack.visible', false)
end

function showCreditsMenu()
	setProperty('h2.visible', false)
	setProperty('h3.visible', false)
	setProperty('h5.visible', false)
	setProperty('h6.visible', false)
	setProperty('h4.visible', false)
	setProperty('pointydoingy.visible', false) 
	
	setProperty('creditsTitle.visible', true)
	setProperty('creditsBody.visible', true)
	setProperty('creditsBack.visible', true)
end

function showOptionsMenu()
	setProperty('h2.visible', false)
	setProperty('h3.visible', false)
	setProperty('h5.visible', false)
	setProperty('h6.visible', false)
	setProperty('h4.visible', false)
	setProperty('pointydoingy.visible', true) 
	
	setProperty('optTitle.visible', true)
	setProperty('opt1Text.visible', true)
	setProperty('opt2Text.visible', true)
	setProperty('optBack.visible', true)
end

function setMenuAlpha(alphaValue)
	setProperty('h2.alpha', alphaValue)
	setProperty('h3.alpha', alphaValue)
	setProperty('h5.alpha', alphaValue)
	setProperty('h6.alpha', alphaValue)
	setProperty('h4.alpha', alphaValue)
	setProperty('pointydoingy.alpha', alphaValue)
end

function resumeGame()
	hidePauseMenu()
	stopSound('pausesong')
	tinocoPaused = false
	closeCustomSubstate()
end

function hidePauseMenu()
	setProperty('bg.visible', false)
	setProperty('left.visible', false)
	setProperty('right.visible', false)
	setProperty('box.visible', false)
	setProperty('h2.visible', false)
	setProperty('h3.visible', false)
	setProperty('h5.visible', false)
	setProperty('h6.visible', false)
	setProperty('h4.visible', false)
	setProperty('pointydoingy.visible', false)
	setProperty('creditsTitle.visible', false)
	setProperty('creditsBody.visible', false)
	setProperty('creditsBack.visible', false)
	setProperty('optTitle.visible', false)
	setProperty('opt1Text.visible', false)
	setProperty('opt2Text.visible', false)
	setProperty('optBack.visible', false)
end