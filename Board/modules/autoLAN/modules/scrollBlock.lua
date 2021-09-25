--=======================================================================================
--=
--=  ScrollBlock
--=  av 10Fingers
--=
--=  Filuppdateringar:
--=   * 2013-05-27
--=        <MarcusThunström> - scrollBlock registrerar nu alltid sig själv med activationTap och activationPress automatiskt.
--=   * 2013-05-23
--=        <MarcusThunström> - Buggfix: clearInteractionMemory ger error.
--=   * 2013-05-21
--=        <MarcusThunström> - Buggfix: scrollBlock avfyrar alltid activationTap på sig själv.
--=   * 2013-05-20
--=        <MarcusThunström> - Ny metod: unregisterInteractive.
--=   * 2013-05-14
--=        <MarcusThunström> - scrollTo kan nu scrolla mjukt.
--=   * 2013-05-13
--=        <MarcusThunström> - scroll-eventet skickar nu med xLimit/yLimit även vid transitions.
--=   * 2013-05-10
--=        <MarcusThunström> - Nytt event: scroll.
--=   * 2013-05-06
--=        <MarcusThunström> - Fixat snabb swipe.
--=   * 2013-05-03
--=        <MarcusThunström> - Ny metod: clearInteractionMemory.
--=   * 2013-05-02
--=        <MarcusThunström> - Nya metoder: enable, disable. Buggfix.
--=   * 2013-04-29
--=        <MarcusThunström> - Förbättrat scrollning.
--=   * 2013-04-26
--=        <MarcusThunström> - Lagt till överstigning av gränser vid scrollning. (Objekten slungas tillbaks vid släpp.)
--=   * 2013-04-18
--=        <MarcusThunström> - Nya event: interactionBegan, interactionEnded, scrollBegan, scrollEnded, beforeScrollEnded.
--=        <MarcusThunström> - Constructor: Nytt argument: disableActivationPress.
--=   * 2013-04-10
--=        <MarcusThunström> - Buggfix: activationTap körs innan activationPress.
--=   * 2013-03-28
--=        <MarcusThunström> - Lagt till event: activationPressBegan, activationPressCancelled. Uppdaterat dokumentation.
--=   * 2013-03-22
--=        <MarcusThunström> - Buggfix.
--=   * 2013-03-20
--=        <MarcusThunström> - Fortsättning...
--=   * 2013-03-15
--=        <MarcusThunström> - Fil skapad.
--=
--=  TODO:
--=   * xSnap/ySnap för scrollTargets.
--=
--[[=====================================================================================



	API-beskrivning:

		scrollBlock = require("modules.scrollBlock")( [parent,] width, height [, scrollOptions [, disableActivationPress ] ] )
			- width, height: Dimensioner på rutan. [#]
			- scrollOptions: Tabell med inställningar för scrollning av själva scrollblocket. Inställningar påverkar inte scrollbara underobjekt. [{}|nil] (Default: nil)
				- x, y: Om objektet ska vara scrollbart i x/y-led. [true|false] (Default: false)
				- xSnap, ySnap: I vilka steg innehållet ska snäppa. nil = mjuk scrollning. [#] (Default: nil)
				- pageScrollX, pageScrollY: Om det bara ska gå att scrolla en sida i taget. [true|false] (Default: false)
				- strictX, strictY: Om det inte ska gå att scrolla utanför gränserna. [true|false] (Default: false)
			- disableActivationPress: Om objekt inte ska kunna få activationPress-event. [true|false]

		scrollBlock:append( child ) :: ersätter insert-metoden!
			- child: Vilket objekt som ska sättas in i scrollblocket.

		scrollBlock:clearInteractionMemory(  ) :: gör att påbörjade interaktioner inte kan sluföras

		scrollBlock:enable(  ) :: avaktiverar interaktion med blocket
		scrollBlock:disable(  ) :: aktiverar interaktion med blocket

		scrollBlock:getScrollPosition(  ) :: returnerar innehållets positionen
			> Returnerar: Innehållets x- och y-position.

		scrollBlock:registerInteractive( interactive, options ) :: registrerar ett objekt som ska gå att interagera med (t.ex. scrolla eller trycka på)
			- interactive: Vilket objekt som ska gå att interagera med.
			- options: Tabell med inställningar för interagering. [{}]
				- activationPress: Om det ska gå att aktivera objektet genom att trycka och hålla ner fingret på det. [true|false] (Default: false)
				- activationTap: Om det ska gå att tap:a på objektet. [true|false] (Default: false)
				- scroll: Se scrollOptions i constructor-funktionen. [{}|nil]

		scrollBlock:scrollTo( [scrollTarget,] x, y [, time ] ) :: scrollar innehållet till en viss position
			- scrollTarget: Vilket objekt vars innehåll ska scrolllas. (Default: scrollBlock)
			- x, y: Ny position för innehållet. nil = behåll position. (Default: nil)
			- time: Hur lång tid scrollningen ska ta. (Default: 0)

		scrollBlock:unregisterInteractive( interactive ) :: avregistrerar ett objekt från interaktion
			- interactive: Vilket objekt som ej ska gå att interagera med.



--=======================================================================================



	Event:

		activationPress (bubblar)
			Avfyras när scrollblocket aktiveras (genom att hålla ner fingret på ett objekt).

		activationPressBegan (bubblar)
			Avfyras när användaren börjat hålla ner ett finger på ett objekt.
			event.activationTarget är objektet som är på väg att aktiveras.
			event.target är objektet som eventet avfyras på i bubblingen.
			event.x och event.y är fingrets position på skärmen.

		activationPressCancelled (bubblar)
			Avfyras när användaren släppt skärmen eller börjat scrolla (vilket stoppar activationPress-eventet från att avfyras).
			event.activationTarget är objektet vars aktivering avbrytits.
			event.target är objektet som eventet avfyras på i bubblingen.
			event.x och event.y är fingrets position på skärmen.

		activationTap (bubblar)
			Avfyras när användaren tap:ar på ett objekt.
			event.activationTarget är objektet som användaren tap:at på.
			event.target är objektet som eventet avfyras på i bubblingen.

		beforeScrollEnded
			Avfyras när användaren scrollat och sen släppt objektet. Eventet avfyras innan en ivägslungning.
			event.target är scrollBlocket.
			event.scrollTarget är objektet som scrollas.
			event.x och event.y är destinationen som objektet slungas till. (Kan vara nil om scrollning bara sker i en axel.)

		interactionBegan
			Avfyras när användaren börjat hålla ner ett finger på ett objekt.
			event.target är scrollblocket.

		interactionEnded
			Avfyras när användaren släpper objektet. (Notera att en scrollning kan fortsätta efter detta event.)
			event.target är scrollblocket.

		scroll
			Avfyras när ett objekt scrollats.
			event.target är scrollBlocket.
			event.scrollTarget är objektet som scrollats.
			event.x och event.y är positionen som objektet scrollats till. (Kan vara nil om scrollning bara skett i en axel.)
			event.xLimit och event.yLimit är max-positionen som objektet kan scrollas till. (Notera att objektet kan vara scrollat
				längre medans användaren drar eller om infiniteX/Y är satta. Kan även vara nil om scrollning bara skett i en axel.)

		scrollBegan
			Avfyras när scrollning påbörjats.
			event.target är scrollBlocket.

		scrollEnded
			Avfyras när scrollning avslutats.
			event.target är scrollBlocket.



--=======================================================================================



	Exempel:

		local width, height = display.contentWidth, display.contentHeight
		local scrollBlock = require("modules.scrollBlock")( width, height, { x=true, xSnap=width/2, y=true } )

		local somethingTall = display.newRect( 0, 0, 50, height*1.4 )
		somethingTall:setFillColor( 0,255,0 )
		scrollBlock:append( somethingTall )

		for page = 1, 4 do

			local background = display.newRect( (page-1)*width/2, 0, width/2, height )
			background:setFillColor( math.random(50,200), math.random(50,200), math.random(50,200) )
			scrollBlock:append( background )

			local txt = display.newText("Sida "..page, (page-1)*width/2, height-100, nil, 20)
			txt:setTextColor(255)
			scrollBlock:append( txt )

		end



--=====================================================================================]]

--Istället för globaler
	-- Som DisplayObject:dispatchEvent(), fast avfyras även av alla child-objekt
	-- Exempel:
	--   local function printHello()
	--     print("Hej!")
	--   end
	--   local group = display.newGroup()
	--   group:addEventListener( "myEvent", printHello )
	--   local image1 = display.newImage( group, "foo.png" )
	--   image1:addEventListener( "myEvent", printHello )
	--   local image2 = display.newImage( group, "bar.png" )
	--   image2:addEventListener( "myEvent", printHello )
	--   broadcastEvent{ name="myEvent", target=group } -- printar "Hej!" när eventet når gruppen och när det når bilderna
	local function broadcastEvent(e)
		local t = e.target or display.currentStage
		e.target = t
		t:dispatchEvent(e)
		if t.numChildren then
			for i = 1, t.numChildren do
				e.target = t[i]
				broadcastEvent(e)
			end
		end
	end



	-- Som DisplayObject:dispatchEvent(), fast bubblar även upp i hierarkin.
	-- Bubblingen stoppas om en event handler returnerar ett sant värde eller efter eventet nått Runtime.
	-- event.originalTarget är originalobjektet som eventet avfyrades på.
	-- Exempel:
	--   local group = display.newGroup()
	--   group:addEventListener( "myEvent", function(e) print("Hej!") end )
	--   local image = display.newImage( group, "foo.png" )
	--   dispatchBubblingEvent{ name="myEvent", target=image } -- printar "Hej!" när eventet når gruppen
	local function dispatchBubblingEvent(e)
		e.originalTarget = e.target
		local stopValue = e.target:dispatchEvent(e)
		if not stopValue then
			while e.target.parent do
				e.target = e.target.parent
				stopValue = e.target:dispatchEvent(e)
				if stopValue then break end
			end
			if not stopValue then
				e.target = nil
				stopValue = Runtime:dispatchEvent(e)
			end
		end
		return stopValue
	end

	local FPS                     = display.fps
	local activationPressTime     = 300
	local scrollDeadZoneRadius	  = 6
---




-- Moduler
local tenfLib = require('modules.tenfLib')

local function iterator(t, i)
	i = i+1
	local v = t[i]
	if v then return i, v end
end

local function iteratorReverse(t, i)
	i = i-1
	local v = t[i]
	if v then return i, v end
end

local function ipairs_(t, reverse)
	if reverse then
		return iteratorReverse, t, (t.numChildren or #t)+1
	else
		return iterator, t, 0
	end
end

tenfLib.ipairs = ipairs_

-- Inställningar
local horizontalScrollAngle     = 45
local maxPositionHistoryLength  = 5
local scrollSpeedFast           = 1/15
local scrollSpeedSlow           = 1/40
local throwStrengthFast         = 2.5
local throwStrengthSlow         = 4.5



-- Metatable
local api = {}
local libMt = {__index=api}
local lib = {}
setmetatable(lib, libMt)

-- Värden
local k = {}

-- Tabeller
local methods = {instanceType='scrollBlock'}







--=======================================================================================
--=======================================================================================
--= FUNKTIONER ==========================================================================
--=======================================================================================
--=======================================================================================



local collectPosition
local getScrollContentHeight
local interactiveTouchBeganHandler
local resetTouchTargetsHandler
local scrollBlockFocusBeganHandler, scrollBlockFocusMovedHandler, scrollBlockFocusEndedHandler
local transitionScrollTo







function collectPosition(scrollBlock)
	local data = scrollBlock[k]
	local positionHistory = data.positionHistory
	if #positionHistory >= maxPositionHistoryLength then table.remove(positionHistory, 1) end
	positionHistory[#positionHistory+1] = {x=data.touchX, y=data.touchY}
end







function getScrollContentHeight(scrollBlock)
	local h = 0
	for i, obj in tenfLib.ipairs(scrollBlock[k].scrollContent) do
		local getHeight = obj.getHeight
		h = obj.y+math.max(h, getHeight and getHeight(obj) or obj.height)
	end
	return h
end







-- Touch began handler för interactive-objekt
function interactiveTouchBeganHandler(e)
	if e.stopImmediatePropagation or e.phase ~= 'began' then return end
	local interactive = e.target
	local interactiveData = interactive[k]
	local scrollSettings, scrollBlockData = interactiveData.scroll, interactiveData.scrollBlock[k]

	-- Lägg till objektet i scrollBlockets touchTargets-lista
	if scrollBlockData.enabled and not scrollBlockData.overLimit then
		scrollBlockData.touchTargets[#scrollBlockData.touchTargets+1] = interactive
		if scrollSettings then
			if scrollSettings.x then scrollBlockData.canScrollX = true end
			if scrollSettings.y then scrollBlockData.canScrollY = true end
		end
	end

end







-- Event handler för resetTouchTargets-event
function resetTouchTargetsHandler(e)
	e.target[k].touchTargets = {}
	return true
end







-- Focus began handler för scrollBlock
function scrollBlockFocusBeganHandler(e)
	local scrollBlock = e.target
	local data = scrollBlock[k]
	if not data.enabled or data.unstoppableScroll or data.overLimit then return true end

	scrollBlock:dispatchEvent{ name='interactionBegan', target=scrollBlock }

	local skipActivation = false
	if data.transitionScroll then

		-- Avbryt pågående scrollning
		data.transitionScroll:cancel()
		data.transitionScroll = nil
		scrollBlock:dispatchEvent{ name='scrollEnded', target=scrollBlock }
		for i = #data.touchTargets, 1, -1 do
			local targetData = data.touchTargets[i][k]
			if targetData.activationTap or targetData.activationPress then
				table.remove(data.touchTargets, i)
			end
		end
		data.ignoreTap = true
		skipActivation = true

	else

		-- Avfyra activationPressBegan-event
		for _, target in ipairs(data.touchTargets) do
			if target[k].activationPress then
				local returnValue = dispatchBubblingEvent{ name='activationPressBegan', target=target, activationTarget=target, x=e.x, y=e.y }
				if returnValue == 'abortAll' then
					scrollBlock:dispatchEvent{ name='interactionEnded', target=scrollBlock }
					return true
				elseif returnValue == 'abortActivation' then
					data.ignoreTap = true
					skipActivation = true
				end
			end
		end
	end

	-- Förbered timer för activationPress-event
	if data.activationPressEnabled and not skipActivation then
		data.activationTimerId = timer.performWithDelay(activationPressTime, function()
			data.activationTimerId = nil

			-- Stoppa möjlighet till scrollning
			data.ignoreTap = true
			local touchTargets = data.touchTargets -- spara touchTargets-tabellen (vilken annars ersätts i touch ended här nedan)
			scrollBlock:dispatchEvent{ name='touch', phase='ended', target=scrollBlock, x=e.xStart, y=e.yStart, xStart=e.xStart, yStart=e.yStart }

			-- Hitta vilket objekt som ska aktiveras
			for _, target in ipairs(touchTargets) do
				if target[k].activationPress then
					dispatchBubblingEvent{ name='activationPress', target=target, activationTarget=target, x=e.x, y=e.y }
				end
			end
			dispatchBubblingEvent{ name='activationPress', target=scrollBlock, activationTarget=scrollBlock, x=e.x, y=e.y }

		end)
	end

end







-- Focus moved handler för scrollBlock
function scrollBlockFocusMovedHandler(e)
	local scrollBlock = e.target
	local data = scrollBlock[k]

	local scrollOptions = data.scrollOptions

	-- Om scrollning pågår
	----------------------------------------------------------------
	if data.isScrolling then

		-- Scrolla scrollTarget om något finns, annars scrolla scrollBlock
		local scrollTarget = data.scrollTarget
		local limitX, limitY
		if scrollTarget then
			scrollOptions = scrollTarget[k].scroll
			if data.scrollingAxis == 'x' then
				limitX = math.min((scrollOptions.scrollHeight or data.width)-scrollTarget:getWidth(), 0) -- negativt tal
			end
			if data.scrollingAxis == 'y' then
				limitY = math.min((scrollOptions.scrollHeight or data.height)-scrollTarget:getHeight(), 0) -- negativt tal
			end
		elseif scrollOptions then
			scrollTarget = scrollBlock
			if data.scrollingAxis == 'x' and scrollOptions.x then
				limitX = math.min(data.width-data.scrollContent.width, 0) -- negativt tal
			end
			if data.scrollingAxis == 'y' and scrollOptions.y then
				limitY = math.min(data.height-getScrollContentHeight(scrollBlock), 0) -- negativt tal
			end
		end
		if scrollTarget then
			local x, y
			if limitX then
				local limit = scrollOptions.infiniteX and -math.huge or limitX
				if scrollOptions.strictX then
					x = math.max(math.min(e.x-data.scrollStartX, 0), limit)
				else
					x = e.x-data.scrollStartX
					if x > 0 then x = x/3; data.overLimit = true; elseif x < limit then x = (x-limit)/3+limit; data.overLimit = true; end
				end
			end
			if limitY then
				local limit = scrollOptions.infiniteY and -math.huge or limitY
				if scrollOptions.strictY then
					y = math.max(math.min(e.y-data.scrollStartY, 0), limit)
				else
					y = e.y-data.scrollStartY
					if y > 0 then y = y/3; data.overLimit = true; elseif y < limit then y = (y-limit)/3+limit; data.overLimit = true; end
				end
			end
			local oldX, oldY = scrollTarget:getScrollPosition()
			if (x and x ~= oldX) or (y and y ~= oldY) then
				scrollTarget:scrollTo(x, y)
				scrollBlock:dispatchEvent{ name='scroll', target=scrollBlock, scrollTarget=scrollTarget, x=x, y=y, xLimit=limitX, yLimit=limitY }
				data.limitX, data.limitY = limitX, limitY
			end
		end

		-- Uppdatera parametrar för fingerpositionsinsamling
		data.touchX, data.touchY = e.x, e.y

	-- Om scrollning ska påbörjas
	----------------------------------------------------------------
	else
		if tenfLib.pointDist(e.x, e.y, e.xStart, e.yStart) > scrollDeadZoneRadius then

			-- Hämta/återställ canScroll-parametrar
			local canScrollX = (scrollOptions and scrollOptions.x) or data.canScrollX
			local canScrollY = (scrollOptions and scrollOptions.y) or data.canScrollY
			data.canScrollX, data.canScrollY = false, false

			-- Stoppa activation från att kunna avfyras
			if data.activationTimerId then
				timer.cancel(data.activationTimerId)
				data.activationTimerId = nil
			end
			for _, target in ipairs(data.touchTargets) do
				if target[k].activationPress then
					dispatchBubblingEvent{ name='activationPressCancelled', target=target, activationTarget=target, x=e.x, y=e.y }
				end
			end

			scrollBlock:dispatchEvent{ name='scrollBegan', target=scrollBlock, x=e.x, y=e.y }

			-- Förbered scroll-data
			data.isScrolling = true; data.overLimit = false;
			data.scrollStartX, data.scrollStartY = e.x, e.y
			data.scrollPositionStartX, data.scrollPositionStartY = scrollBlock:getScrollPosition()
			if canScrollX and canScrollY then
				local ang = math.abs(math.deg(math.atan2(e.x-e.xStart, e.yStart-e.y)))
				data.scrollingAxis = (ang < horizontalScrollAngle or ang > 180-horizontalScrollAngle) and 'y' or 'x'
			else
				data.scrollingAxis = canScrollY and 'y' or 'x'
			end

			-- Hitta vilket objekt som ska scrollas
			for _, target in ipairs(data.touchTargets) do
				local scrollSettings = target[k].scroll
				if scrollSettings and ((scrollSettings.x and data.scrollingAxis=='x') or (scrollSettings.y and data.scrollingAxis=='y')) then
					data.scrollTarget = target
					local x, y = target:getScrollPosition()
					data.scrollStartX, data.scrollStartY = data.scrollStartX-x, data.scrollStartY-y
					data.scrollPositionStartX, data.scrollPositionStartY = x, y
					break
				end
			end
			if not data.scrollTarget then -- här ska scrollBlock (eller inget objekt alls) scrollas
				local x, y = scrollBlock:getScrollPosition()
				data.scrollStartX, data.scrollStartY = data.scrollStartX-x, data.scrollStartY-y
			end

			-- Börja samla fingerpositioner
			data.positionHistory = {{x=e.xStart,y=e.yStart}}; data.touchX, data.touchY = e.x, e.y;
			data.positionCollector()
			Runtime:addEventListener('enterFrame', data.positionCollector)

		----------------------------------------------------------------
		end
	end
end







-- Focus ended handler för scrollBlock
function scrollBlockFocusEndedHandler(e)
	local scrollBlock = e.target
	local data = scrollBlock[k]

	-- Stoppa activation från att kunna avfyras
	if data.activationTimerId then
		timer.cancel(data.activationTimerId)
		data.activationTimerId = nil
		for _, target in ipairs(data.touchTargets) do
			if target.dispatchEvent and target[k].activationPress then
				dispatchBubblingEvent{ name='activationPressCancelled', target=target, activationTarget=target, x=e.x, y=e.y }
			end
		end
	end

	-- Återställ scroll-data och avfyra tap-event
	if data.isScrolling then

		Runtime:removeEventListener('enterFrame', data.positionCollector)
		data.isScrolling = false

		-- Kör scroll-transition
		local scrollTarget, scrollOptions, history = data.scrollTarget, data.scrollOptions, data.positionHistory
		local x, y, scrollX, scrollY, scrollSpeed
		if scrollTarget then

			scrollOptions = scrollTarget[k].scroll
			local w, h = scrollOptions.scrollWidth, scrollOptions.scrollHeight
			scrollX, scrollY = scrollTarget:getScrollPosition()
			local throwStrength = data.overLimit and throwStrengthFast or throwStrengthSlow -- TODO: xSnap/ySnap för scrollTargets
			scrollSpeed = throwStrength == throwStrengthFast and scrollSpeedFast or scrollSpeedSlow
			if data.scrollingAxis == 'x' then
				local limit = scrollOptions.infiniteX and -math.huge or math.min((w or data.width)-scrollTarget:getWidth(), 0) -- negativt tal
				x = math.max(math.min(scrollX+(history[#history].x-history[1].x)*throwStrength, 0), limit)
			end
			if data.scrollingAxis == 'y' then
				local limit = scrollOptions.infiniteY and -math.huge or math.min((h or data.height)-scrollTarget:getHeight(), 0) -- negativt tal
				y = math.max(math.min(scrollY+(history[#history].y-history[1].y)*throwStrength, 0), limit)
			end

		elseif scrollOptions then

			scrollX, scrollY = scrollBlock:getScrollPosition()
			if data.scrollingAxis == 'x' and scrollOptions.x then
				local throwStrength = ((data.overLimit or scrollOptions.xSnap) and throwStrengthFast or throwStrengthSlow)
				scrollSpeed = throwStrength == throwStrengthFast and scrollSpeedFast or scrollSpeedSlow
				if scrollOptions.pageScrollX then
					local diff = history[#history].x-history[1].x
					x = data.scrollPositionStartX
					if diff ~= 0 then x = math.round(data.scrollPositionStartX/scrollOptions.xSnap+(diff > 0 and 1 or -1))*scrollOptions.xSnap end
					data.unstoppableScroll = true
				else
					x = scrollX+(history[#history].x-history[1].x)*throwStrength
					if scrollOptions.xSnap then x = math.round(x/scrollOptions.xSnap)*scrollOptions.xSnap; data.unstoppableScroll = true; end
				end
				local limit = scrollOptions.infiniteX and -math.huge or data.width-data.scrollContent.width
				x = math.max(math.min(math.round(x), 0), math.min(limit, 0))
			elseif data.scrollingAxis == 'y' and scrollOptions.y then
				local throwStrength = ((data.overLimit or scrollOptions.ySnap) and throwStrengthFast or throwStrengthSlow)
				scrollSpeed = throwStrength == throwStrengthFast and scrollSpeedFast or scrollSpeedSlow
				if scrollOptions.pageScrollY then
					local diff = history[#history].y-history[1].y
					y = data.scrollPositionStartY
					if diff ~= 0 then y = math.round(data.scrollPositionStartY/scrollOptions.ySnap+(diff > 0 and 1 or -1))*scrollOptions.ySnap end
					data.unstoppableScroll = true
				else
					y = scrollY+(history[#history].y-history[1].y)*throwStrength
					if scrollOptions.ySnap then y = math.round(y/scrollOptions.ySnap)*scrollOptions.ySnap; data.unstoppableScroll = true; end
				end
				local limit = scrollOptions.infiniteY and -math.huge or data.height-getScrollContentHeight(scrollBlock)
				y = math.max(math.min(math.round(y), 0), math.min(limit, 0))
			end
			scrollTarget = scrollBlock

		end
		if scrollTarget then
			scrollBlock:dispatchEvent{ name='beforeScrollEnded', target=scrollBlock, scrollTarget=scrollTarget, x=x, y=y }
			data.transitionScroll = transitionScrollTo(scrollBlock, scrollTarget, x, y, function()
				data.transitionScroll = nil
				data.unstoppableScroll = false; data.overLimit = false;
				if scrollBlock.dispatchEvent then
					scrollBlock:dispatchEvent{ name='scrollEnded', target=scrollBlock }
				end
			end, scrollSpeed)
		end

		-- Återställ scroll-data
		data.scrollStartX, data.scrollStartY = nil, nil
		data.scrollTarget = nil
		data.scrollingAxis = nil

	elseif not data.ignoreTap then

		-- Hitta vilket objekt som ska tappas på
		broadcastEvent{ name='attachCourseBlocks' }
		for _, target in ipairs(data.touchTargets) do
			if target[k].activationTap then
				if dispatchBubblingEvent{ name='activationTap', target=target, activationTarget=target } then break end
			end
		end
		dispatchBubblingEvent{ name='activationTap', target=scrollBlock, activationTarget=scrollBlock }

	end
	data.touchTargets = {}
	data.ignoreTap = nil

	scrollBlock:dispatchEvent{ name='interactionEnded', target=scrollBlock }
end







-- Kör transition.to på ett objekt, fast använder scrollTo-metoden istället för just transition.to
function transitionScrollTo(scrollBlock, target, toX, toY, completeHandler, scrollSpeed)
	local fromX, fromY = target:getScrollPosition()
	if not ((toX and fromX ~= toX) or (toY and fromY ~= toY)) then
		if completeHandler then completeHandler() end
		return nil
	end

	local handle = {}
	local percentDone = 0

	local function updateScroll()
		local data = scrollBlock[k]
		percentDone = percentDone+scrollSpeed
		if percentDone >= 1 then
			handle:cancel()
			target:scrollTo(toX and math.round(toX), toY and math.round(toY))
			if scrollBlock.dispatchEvent then scrollBlock:dispatchEvent{ name='scroll', target=scrollBlock, scrollTarget=target, x=toX, y=toY, xLimit=data.limitX, yLimit=data.limitY } end
			if completeHandler then completeHandler() end
		else
			local x = toX and easing.outQuad(percentDone, 1, fromX, toX-fromX) or nil
			local y = toY and easing.outQuad(percentDone, 1, fromY, toY-fromY) or nil
			target:scrollTo(x and math.round(x), y and math.round(y))
			if scrollBlock.dispatchEvent then scrollBlock:dispatchEvent{ name='scroll', target=scrollBlock, scrollTarget=target, x=x, y=y, xLimit=data.limitX, yLimit=data.limitY } end
		end
	end

	function handle:cancel()
		Runtime:removeEventListener('enterFrame', updateScroll)
	end

	Runtime:addEventListener('enterFrame', updateScroll)
	return handle
end







--=======================================================================================
--=======================================================================================
--= METODER =============================================================================
--=======================================================================================
--=======================================================================================







-- scrollBlock:append( child )
function methods.append(scrollBlock, child)
	scrollBlock[k].scrollContent:insert(child)
end







-- scrollBlock:clearInteractionMemory(  )
function methods.clearInteractionMemory(scrollBlock)
	resetTouchTargetsHandler{ target=scrollBlock }
end







-- scrollBlock:enable(  )
function methods.enable(scrollBlock)
	scrollBlock[k].enabled = true
end



-- scrollBlock:disable(  )
function methods.disable(scrollBlock)
	scrollBlock[k].enabled = false
end







-- scrollBlock:getWidth(  )
function methods.getWidth(scrollBlock)
	return scrollBlock[k].width
end



-- scrollBlock:getHeight(  )
function methods.getHeight(scrollBlock)
	return scrollBlock[k].height
end







-- scrollBlock:getScrollPosition(  )
function methods.getScrollPosition(scrollBlock)
	local scrollContent = scrollBlock[k].scrollContent
	return scrollContent.x, scrollContent.y
end

-- scrollBlock:scrollTo( [scrollTarget,] x, y [, time ] )
function methods.scrollTo(scrollBlock, scrollTarget, x, y, time)
	if type(scrollTarget) ~= 'table' then scrollTarget, x, y, time = scrollBlock, scrollTarget, x, y end
	if x then x = math.round(x) end
	if y then y = math.round(y) end
	if time and time > 0 then
		local data = scrollBlock[k]
		data.unstoppableScroll = true
		transitionScrollTo(scrollBlock, scrollTarget, x, y, function()
			data.unstoppableScroll = false
		end, 1/(time/1000*FPS))
	else
		tenfLib.setAttr(scrollBlock[k].scrollContent, {x=x, y=y})
	end
end







-- scrollBlock:registerInteractive( interactive, options )
function methods.registerInteractive(scrollBlock, interactive, options)

	options.scrollBlock = scrollBlock
	interactive[k] = options

	interactive:addEventListener('touch', interactiveTouchBeganHandler)

end



-- scrollBlock:unregisterInteractive( interactive )
function methods.unregisterInteractive(scrollBlock, interactive)
	interactive[k] = nil
	interactive:removeEventListener('touch', interactiveTouchBeganHandler)
end







--=======================================================================================
--=======================================================================================
--= CONSTRUCTOR =========================================================================
--=======================================================================================
--=======================================================================================







function libMt:__call(parent, width, height, scrollOptions, disableActivationPress)
	if type(parent) ~= 'table' then
		parent, width, height, scrollOptions, disableActivationPress = nil, parent, width, height, scrollOptions
	end



	local scrollBlock = tenfLib.setAttr(tenfLib.newGroup(parent), methods)
	tenfLib.enableFocusOnTouch(scrollBlock)
	tenfLib.enableTouchPhaseEvents(scrollBlock)



	-- Dataobjekt
	local data = {

		-- Inställningar
		activationPressEnabled = not disableActivationPress,
		scrollOptions = scrollOptions,
		width = width, height = height,

		-- Värden
		activationTimerId = nil,
		canScrollX = false, canScrollY = false,
		enabled = true,
		isScrolling = false,
		limitX = 0, limitY = 0,
		overLimit = false,
		scrollingAxis = nil,
		scrollStartX = nil, scrollStartY = nil,
		touchTargets = {},
		touchX = nil, touchY = nil,
		transitionScroll = nil,

		-- Positionssamlare
		positionCollector = function() collectPosition(scrollBlock) end,
		positionHistory = nil,

	}
	scrollBlock[k] = data



	-- Komponenter

	-- :: pekområde
	display.newRect(scrollBlock, 0, 0, width, height):setFillColor(0,0)

	-- :: innehållsgrupp
	data.scrollContent = tenfLib.newGroup(scrollBlock)



	-- Event handlers
	scrollBlock:addEventListener('focusBegan', scrollBlockFocusBeganHandler)
	scrollBlock:addEventListener('focusMoved', scrollBlockFocusMovedHandler)
	scrollBlock:addEventListener('focusEnded', scrollBlockFocusEndedHandler)
	scrollBlock:addEventListener('touchBegan', tenfLib.stopPropagation)
	scrollBlock:addEventListener('resetTouchTargets', resetTouchTargetsHandler)



	return scrollBlock
end







--=======================================================================================



return lib


