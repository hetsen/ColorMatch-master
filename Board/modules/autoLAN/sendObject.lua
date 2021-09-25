--=======================================================================================
--=
--=  Ta emot-vy
--=  av 10Fingers
--=
--=  Filuppdateringar:
--=   * 2013-06-19 <TommyLind> - Fil Uppdaterad.
--=   * 2013-06-18 <TommyLind> - Fil skapad.

--[[
	Exempel:

	composer.gotoScene("modules.autoLAN.sendObject", {
	params = {
		mapToSend = {
			fileName = "levels/senderTest",
			fileDir = system.ResourceDirectory,
		}
	}
})
]]
--=======================================================================================

-- if _G.adsEnabled then
-- 	ads.hide()
-- end
-- if _G.adsEnabled then
-- 	ads.show( "banner", { x=0, y=_H} )
-- end 

local composer 	= require("composer")
local scene 		= composer.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight

--Variabler
	local servers = {}
	local listingItems = false
	local scrollListenerAdded = false
	local inThisScene
	local fileNameToSend, fileDirToSend
---

--Moduler
	--AUTOLAN
		local client
	---
---

--Funktioner
	--AUTOLAN
		local clientReceived
		local clientFileReceived
		local connectionAttemptFailed
		local receiverDisconnected
		local receiverConnected
		local createListItem
	---

	local tenfLib = require("modules.tenfLib")
	local setAttr = tenfLib.setAttr
	local newGroup = tenfLib.newGroup
	local fitTextInArea = tenfLib.fitTextInArea

	local aud = require 'audioo'
	local dd  = require "devicedetector"
	
	local buttonList, buttonGroup
	local serverObjList, serverObjGroup
---

function scene:create(e)
	local sceneView = self.view
	local sceneName = composer.getCurrentSceneName()
	local params = e.params
	inThisScene = true

	local sendObj
	local scrollBlock

	-- --Bakgrund
	-- 	setAttr(setAttr(display.newImageRect(sceneView, "modules/autoLAN/tempPic/tempPic.png", _W, _H), {width=_W, height=_H}), {x=0, y=0}, {rp='TL', fc = {80}})
	-- --

	backdrop = require 'background'
	sceneView:insert(backdrop)
	
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	if _G.adsEnabled then
		ads.show("banner", { x=0, y=_H - _G.adSpace})
	end 

	local frame = display.newImageRect(sceneView, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	frame.xScale, frame.yScale = (_W / 1032)*0.85, (_H / 1032)*0.75
	frame.x, frame.y = _W*0.5, _H*0.5

	local headline = display.newText(sceneView, 'Share Level', 0, 0, systemfont, _G.mediumLargeFontSize)
	headline.x, headline.y = _W*0.5, _H*0.08

	local infoText = display.newText(sceneView, params.infoTextText or 'Searching for devices', 0, 0, systemfont, _G.mediumSmallFontSize)
	infoText.x, infoText.y = _W*0.5, _H*0.16

	local fontSize = (_G.mediumSmallFontSize + _G.smallFontSize)*0.5

	if dd.get() == "iPad Retina" then
		fontSize = _G.smallFontSize
	end

	local warningText = display.newText(sceneView, 'To share a level, it must be a custom level, you must play it and you must get all stars.', 0, 0, _W*0.8, _H*0.5, systemfont, fontSize)
	warningText.x, warningText.y = _W*0.5, _H*0.66 + warningText.height*warningText.yScale*0.5

	local function onBack(e)
		aud.play(sounds.click)

		if _G.adsEnabled then
			ads.hide()
		end
		
		composer.gotoScene('shareMenu')
	end

	local sharingInfo = display.newText(sceneView, 'Sharing only works over wifi. The wifi must allow device-to-device communication.', 0, 0, _W*0.4, _H*0.3, systemfont, _G.smallFontSize)
	sharingInfo.x, sharingInfo.y = _W*0.3, _H*0.74 + sharingInfo.height*sharingInfo.yScale*0.5

	timer.performWithDelay(1, function()
		backButton = {}--display.newGroup()

		local bg = {}--display.newImageRect(backButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		bg.path = 'Graphics/Menu/small_btn_fill.png'
		bg.width = 384
		bg.height = 190
		bg.xScale, bg.yScale = 0.25, 0.25
		bg.x, bg.y = 0, 0
		bg.color = _G.continueColor

		local fg = {}--display.newImageRect(backButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		fg.path = 'Graphics/Menu/small_btn_texture.png'
		fg.width = 384
		fg.height = 190
		fg.xScale, fg.yScale = 0.25, 0.25
		fg.x, fg.y = 0, 0

		local text = {}--display.newText(backButton, 'Back', 0, 0, systemfont, _G.mediumFontSize)
		text.text = 'Back'
		text.font = systemfont
		text.fontSize = _G.mediumFontSize
		text.x, text.y = 0, 0

		backButton.bg = bg
		backButton.fg = fg
		backButton.text = text
		backButton.x, backButton.y = _W*0.7, _H*0.8
		backButton.onEnded = onBack

		backButton = createButton(backButton)

		sceneView:insert(backButton)
	end)

	local function onButtonTap(e)
		fileNameToSend = e.target.name
		fileDirToSend = system.DocumentsDirectory

		sendObj()

		serverObjGroup.isVisible = true
		display.remove(buttonGroup)
	end

	local function showLevelsToShare(receiver, list)
		local buttonList = {}
		local buttonGroup = display.newGroup()

		for i = 1, #list do
			local button = display.newGroup()

			local bg = display.newImageRect(button, 'Graphics/Menu/large_btn_fill.png', 768, 190)
			bg.x, bg.y = 0, 0
			bg.xScale, bg.yScale = 0.2, 0.2

			-- if i % 2 == 1 then
			-- 	bg:setFillColor(255)
			-- else
			-- 	bg:setFillColor(192)
			-- end

			local fg = display.newImageRect(button, 'Graphics/Menu/large_btn_texture.png', 768, 190)
			fg.x, fg.y = 0, 0
			fg.xScale, fg.yScale = 0.2, 0.2

			local text = display.newText(button, list[i].name, 0, 0, systemfont, _G.mediumSmallFontSize)
			text.x, text.y = 0, 0

			button.receiver = receiver
			button.name = list[i].name
			button:addEventListener('tap', onButtonTap)
			button.x, button.y = 0, button.height*button.yScale*1.1*i - button.height*button.yScale*0.55
			buttonGroup:insert(button)
			buttonList[#buttonList+1] = button
		end

		return buttonList, buttonGroup
	end

	function onScroll(e)
		if not e.target.scrollTransition then
			if e.phase == 'began' then
				e.target.originTouchY = e.y
				display.getCurrentStage():setFocus(e.target)
				e.target.swiping = true
			elseif e.phase == 'moved' and e.target.swiping then
				local yDiff = (e.target.originTouchY or e.y) - e.y
				e.target.y = e.target.y - yDiff

				e.target.originTouchY = e.y
			else
				local tmpY = e.target.y
				e.target.scrollTransition = true

				if e.target.y + e.target.height <= e.target.originalBottom then
					tmpY = e.target.originalBottom - e.target.height
				end

				if e.target.y >= e.target.originalTop or tmpY >= e.target.originalTop then
					tmpY = e.target.originalTop
				end

				transition.to(e.target, {time = 250, y = tmpY, onComplete = function()
					e.target.scrollTransition = false
				end})

				e.target.originTouchY = 0
				display.getCurrentStage():setFocus(nil)
				e.target.swiping = false
			end
		end
	end

	local function showAvailableLevels(receiver)
		infoText.text = 'Shareable levels loaded'
		local tmpList = tenfLib.jsonLoad("stateuser.txt") or {}
		local sendList = {}

		for i = 1, #tmpList do
			if tmpList[i].numStars and tmpList[i].numStars['one'] and tmpList[i].numStars['two'] and tmpList[i].numStars['three'] then
				sendList[#sendList+1] = tmpList[i]
			end
		end

		buttonList, buttonGroup = showLevelsToShare(receiver, sendList)

		buttonGroup.originalTop, buttonGroup.originalBottom = _H*0.42 - 100, _H*0.42 + 100
		buttonGroup.x, buttonGroup.y = _W*0.5, _H*0.5
		buttonGroup:addEventListener('touch', onScroll)

		local superGroup = display.newGroup()
		superGroup:insert(buttonGroup)
		sceneView:insert(superGroup)

		local mask = graphics.newMask('pics/normalMask.png')
		superGroup:setMask(mask)
		superGroup.maskX, superGroup.maskY = _W*0.5, _H*0.42
	end

	--

	local nameOfReceiver = system.getInfo( "name" ) or "name unknown"

	--Hanterar parametrar
		-- if params then
		-- 	if params.mapToSend then

		-- 		fileNameToSend = params.mapToSend.fileName
		-- 		if not fileNameToSend then
		-- 			print ("WARNING: Server: fileNameToSend is nil")
		-- 			return
		-- 		end

		-- 		fileDirToSend = params.mapToSend.fileDir
		-- 		if not fileDirToSend then
		-- 			print ("WARNING: Server: fileDirToSend is nil")
		-- 			return
		-- 		end

		-- 	else
		-- 		print ("WARNING: Server: mapToSend is nil")
		-- 		return
		-- 	end
		-- else
		-- 	print ("WARNING: Server: params is nil")
		-- 	return
		-- end
	---


	--Variabler
		local menuGroup
		local padding = 8
		local objectHeight = 40
		local margin = {x = 10, y = 10}
		--AUTOLAN
			local clientOptions = {}
		---
	---

	--Funktioner
		local getPositionOfServerListItem
		local notify
		local findServerFromIP
		local createMenus
		local restorePreviousPoint
		local sendResponse
		--AUTOLAN
			local makeClient
			local sendFile
		---
	---


	function getPositionOfServerListItem(i)
		infoText.text = 'Device found'
		local x = _W / 2
		local y = (objectHeight / 2) + ((i - 1) * (objectHeight + padding))
		return x, y
	end

	function findServerFromIP(_IP)
		if servers then
			for i, v in ipairs(servers) do
				if servers[i].serverIP == _IP then
					return servers[i]
				end
			end
		end
	end

	function sendFile(...)
		--... -> <pathToFile>, <dir>, <fileNameToReceiver>
		if client then
			client:sendFile(...)
			--print(...)
			--print(client.connectedTo)

			serverObjGroup.isVisible = false

			local sendingScreen = display.newGroup()

			local function onSendingBg(e)
				return true
			end

			local sendingBg = display.newRect(sendingScreen, 0, 0, _W, _H)
			sendingBg.x, sendingBg.y = 0, 0
			sendingBg.alpha = 0.5
			sendingBg:setFillColor(0)
			sendingBg:addEventListener('tap', onSendingBg)
			sendingBg:addEventListener('touch', onSendingBg)

			local sendingFg = display.newText(sendingScreen, 'Sending...', 0, 0, systemfont, _G.mediumLargeFontSize)
			sendingFg.x, sendingFg.y = 0, 0

			sendingScreen.x, sendingScreen.y = _W*0.5, _H*0.5
			sceneView:insert(sendingScreen)

			timer.performWithDelay(1000, function()
				if _G.adsEnabled then
					ads.hide()
				end

				composer.gotoScene('emptyscene', {params = {infoTextText = 'The level has been sent', toPrev = true}})
			end)
		end
	end

	function sendObj()
		--Skickar banan
			sendFile('levels/' .. fileNameToSend, fileDirToSend, fileNameToSend)
		---
	end

	function clientReceived(event)
		print "Client: I got message now, said the client"
		local message = event.message
		if message[1] == 4 then --it's full
			print("Client: It's full: I will disconnect")
			local serverDiconnectedFrom = findServerFromIP(client.connectedTo)
			client.connectedTo = nil
			if serverDiconnectedFrom then
				serverDiconnectedFrom:setColor("disconnected")
			end
			timer.performWithDelay(1000, function()
				if inThisScene then
					client:disconnect()
				end
			end)
			-- notify(getText('sharing_receive_clientBlocked'), _G.fontSizeSmall, 2000) --notisen
		elseif message[1] == 3 then --whatsYourName
			print("Client: whatsYourName: My name is "..nameOfReceiver)
			local package = {[1] = 3, [2] = nameOfReceiver}
			if client then
				client:send(package)
			end
		elseif message[1] == 2 then --received
			print("Client: received: Här ska mottagningen visas grafiskt") --här
			tenfLib.printObj(event)
		elseif message[1] == 1 then --readyToReceive
			print("Client: readyToReceive: Nu ska jag skicka filen!")
			showAvailableLevels()
		end
	end

	-- function deviceWasTapped(e)
	-- 	showAvailableLevels()
	-- end

	function clientFileReceived(event)
		print("Client: I got file now, said the client")--Ska inte inträffa
	end

	function receiverConnected(event)
		print("Client: Connected!")
		if client.connectedTo then
			local connectedServer = findServerFromIP(client.connectedTo)
			if connectedServer then
				connectedServer:setColor("receiving")
				-- local txt = getText('sharing_receive_connected', {serverName=tenfLib.shortenText(tostring(event.customBroadcast), 20, '...')})
				-- notify(txt, _G.fontSizeSmall, 1000) --notisen
			end
		end
	end

	function receiverDisconnected(event)
		print("Client: Disconnected!")
		connectionAttemptFailed(event)
	end

	local function removeServer(_server)
		if _server then
			print "Client: removing server"
			local serverIndexToRemove = {}
			for i, server in ipairs(servers) do
				if _server == server then
					table.insert(serverIndexToRemove, i)
					break
				end
			end
			table.sort(serverIndexToRemove, function(a, b)
				return a > b
			end)
			for _, indexToRemove in ipairs(serverIndexToRemove) do
				print ("Client: removing serverIndex "..indexToRemove)
				local server = table.remove(servers, indexToRemove)
				display.remove(server)
				server = nil
			end
		else
			print "Client: Away with all"
			for i, v in ipairs(servers) do
				display.remove(servers[i])
				servers[i] = nil
			end
			servers = {}
		end

		for i, server in ipairs(servers) do
			servers[i].x, servers[i].y = getPositionOfServerListItem(i)
		end
	end

	function connectionAttemptFailed(event)
		print("Client: Connection lost!")
		local serverDiconnectedFrom = findServerFromIP(event.serverIP)
		if serverDiconnectedFrom then
			serverDiconnectedFrom:setColor("disconnected")
		end

		timer.performWithDelay(1000, makeClient)
		-- notify(getText('sharing_receive_connectionLost'), _G.fontSizeLarge, 2000, makeClient)
		--notisen
	end

	function makeClient()
		removeServer(nil)
		local clientBefore = not not client
		if clientBefore then
			print("Client: removing previous client")
			client:disconnect()
			client:stop()
			client = nil
			Runtime:removeEventListener("autolanReceived", clientReceived)
			Runtime:removeEventListener("autolanFileReceived", clientFileReceived)
			Runtime:removeEventListener("autolanConnectionFailed", connectionAttemptFailed)
			Runtime:removeEventListener("autolanDisconnected", receiverDisconnected)
			Runtime:removeEventListener("autolanConnected", receiverConnected)
		end
		if not inThisScene then return end
		print("Client: making client")
		client = tenfLib.requireNew("modules.autoLAN.modules.client")

		client:setOptions(clientOptions)

		client:start()
		client:scanServers()

		--Lägger till event listeners för autoLAN
			Runtime:addEventListener("autolanReceived", clientReceived)
			Runtime:addEventListener("autolanFileReceived", clientFileReceived)
			Runtime:addEventListener("autolanConnectionFailed", connectionAttemptFailed)
			Runtime:addEventListener("autolanDisconnected", receiverDisconnected)
			Runtime:addEventListener("autolanConnected", receiverConnected)
		---
		createMenus()
	end

	function createMenus(restoreBool)
		if not sceneView or not sceneView.insert then return end
		if type(menuGroup) == "table" and menuGroup.numChildren then
			for i = 1, menuGroup.numChildren do
				display.remove(menuGroup[i])
				menuGroup[i] = nil
			end
		end
		display.remove(menuGroup)
		menuGroup = nil
		if sceneView and sceneView.insert then
			menuGroup = newGroup(sceneView)
		else
			display.remove(menuGroup)
			menuGroup = nil
			return
		end

		display.remove(serverObjGroup)
		display.remove(serverObjSuperGroup)
		serverObjGroup = display.newGroup()
		serverObjSuperGroup = display.newGroup()

		serverObjSuperGroup:insert(serverObjGroup)
		sceneView:insert(serverObjSuperGroup)

		serverObjGroup.originalTop, serverObjGroup.originalBottom = _H*0.2, _H*0.6
		serverObjGroup.y = _H*0.2
		serverObjGroup:addEventListener('touch', onScroll)

		local mask = graphics.newMask('pics/normalMask.png')
		serverObjSuperGroup:setMask(mask)
		serverObjSuperGroup.maskX, serverObjSuperGroup.maskY = _W*0.5, _H*0.45
		serverObjSuperGroup.maskScaleY = 1.1

		function createListItem(event, prevID)
			print('Client: autolanServerFound')
			--event innehåller: serverIP, port, customBroadcast, serverName
			-- loadingIndicator.isVisible = false
			if not sceneView or not sceneView.insert then
				return
			end
			for i, server in pairs(servers) do
				if server.serverIP == event.serverIP and not prevID then
					return
				end
			end
			local function onRelease(target)
				if not client.connectedTo then
					print "Client: Start connecting"
					local result = client:connect(target.serverIP)
					if result then
						client.connectedTo = target.serverIP
					else
						Runtime:removeEventListener("autolanServerFound", createListItem)
						listingItems = false
					end
				elseif client.connectedTo == target.serverIP then
					--print('DISCONNECTED')
					client.connectedTo = nil
					client:disconnect()
					-- notify(getText('sharing_receive_disconnecting'), _G.fontSizeSmall)
					--notisen
					target:setColor("disconnected")
				else
					print "Client: cannot press"
				end
			end

			local serverObj

			if sceneView and sceneView.insert then
				serverObj = newGroup(sceneView)
			else
				display.remove(serverObj)
				serverObj = nil
				return
			end

			--

			serverObj.back = display.newImageRect(serverObj, 'Graphics/Menu/large_btn_fill.png', 768, 190)
			serverObj.back.x, serverObj.back.y = 0, 0
			serverObj.back.xScale, serverObj.back.yScale = 0.2, 0.2

			local fg = display.newImageRect(serverObj, 'Graphics/Menu/large_btn_texture.png', 768, 190)
			fg.x, fg.y = 0, 0
			fg.xScale, fg.yScale = 0.2, 0.2

			serverObj.label = display.newText(serverObj, event.customBroadcast, 0, 0, systemfont, _G.mediumSmallFontSize)
			serverObj.label.x, serverObj.label.y = 0, 0
			fitTextInArea(serverObj.label, serverObj.back.width*serverObj.back.xScale - 20, nil, "...")
			--

			-- serverObj.back = display.newRoundedRect(serverObj, 0, 0, _W - 40, objectHeight, 10)
			-- serverObj.back.x, serverObj.back.y = 0, 0

			-- serverObj.label = display.newText(serverObj, event.customBroadcast, 0, 0, _G.fontName, _G.fontSizeSmall)
			-- fitTextInArea(serverObj.label, serverObj.back.width - 20, nil, "...")
			-- serverObj.label.x, serverObj.label.y = 0, 0

			serverObj.labelColor = {default = {255}, over = {200}}
			serverObj.color = {default = {70, 70, 70}, over = {50, 50, 50}}

			local function onDeviceTap(e)
				onRelease(e.target)
				serverObjGroup.isVisible = false
				infoText.text = 'Loading your custom levels...'
				--showAvailableLevels()
			end

			serverObj:addEventListener('tap', onDeviceTap)
			serverObjGroup:insert(serverObj)
			-- scrollBlock:append(serverObj)
			-- scrollBlock:registerInteractive(serverObj, { activationPress = true, activationPress = true, activationTap = true })

			local function defaultColor(e, firstTime)
				local t = e.activationTarget
				if not client.connectedTo or firstTime then
					if t.back then t.back:setFillColor(unpack(t.color.default)) end
					if t.label then t.label:setTextColor(unpack(t.labelColor.default)) end
				end
			end

			local function overColor(e)
				local t = e.activationTarget
				if not client.connectedTo then
					t.back:setFillColor(unpack(t.color.over))
					t.label:setTextColor(unpack(t.labelColor.over))
				end
			end

			-- if not scrollListenerAdded then
			-- 	scrollBlock:addEventListener("activationTap", function(e)
			-- 		if e.activationTarget.instanceType == 'scrollBlock' then return end
			-- 		defaultColor(e)
			-- 		onRelease(e.activationTarget)
			-- 	end)
			-- 	scrollBlock:addEventListener("activationPressCancelled", defaultColor)
			-- 	scrollBlock:addEventListener("activationPressBegan", overColor)
			-- 	scrollListenerAdded = true
			-- end

			defaultColor({activationTarget = serverObj}, true)
			

			if prevID then
				servers[prevID] = serverObj
			else
				table.insert(servers, serverObj)
			end

			serverObj.x, serverObj.y = getPositionOfServerListItem(#servers)
			serverObj.y = serverObj.y + _H*0.2

			serverObj.customBroadcast = event.customBroadcast
			serverObj.serverName = serverObj.customBroadcast
			serverObj.serverIP = event.serverIP

			function serverObj:setColor(col1, col2)
				if type(col1) == "string" then
					if col1 == "connected" then
						col1 = {70, 120, 70}
						col2 = {180, 230, 180}
					elseif col1 == "receiving" then
						col1 = {120, 120, 70}
						col2 = {230, 230, 180}
					elseif col1 == "disconnected" then
						col1 = {180, 70, 70}
						col2 = {230, 180, 180}
					else
						col1 = {70, 70, 70}
						col2 = {180, 180, 180}	
					end
				else
					col1 = col1 or {70, 70, 70}
					col2 = col2 or {180, 180, 180}
				end

				col1 = col1 or {255, 0, 0}
				col2 = col2 or {255, 0, 0}

				self.currentColor = {col1 = col1, col2 = col2}

				if self and self.back then
					if self.back.setFillColor then
						self.back:setFillColor(unpack(col1))
					end
					if self.back.setStrokeColor then
						self.back:setStrokeColor(unpack(col2))
					end
					--self.back.strokeWidth = 2
				end
			end
			if prevID and client.connectedTo == serverObj.serverIP then
				serverObj:setColor("connected")
			else
				serverObj:setColor()
			end
		end

		if restoreBool then
			local tmpServers = {}
			for i,v in ipairs(servers) do
				tmpServers[i] = servers[i]
			end
			for i,serverData in ipairs(tmpServers) do
				createListItem(serverData, i)
			end
		else
			if not listingItems then
				Runtime:addEventListener("autolanServerFound", createListItem)
			end
			listingItems = true
			-- notify(getText('sharing_receive_searching'), _G.fontSizeSmall)
			--notisen
			-- loadingIndicator.isVisible = true
		end
	end

	--Skapar mottagningsvyn.
		local function startReceivingView()
			--Skapar scrollBlock
				local width, height = _W, _H - 60
				-- scrollBlock = require("modules.autoLAN.modules.scrollBlock")( width, height, { y=true }, true )
				-- scrollBlock.y = margin.y
				-- sceneView:insert(scrollBlock)
				-- require("modules.utils.mask").setRectMask(scrollBlock, width, height, "L", "T")
			---
			makeClient()
		end
	---

	--Initiate
		startReceivingView()
	---


end

function scene:hide(e)

	if client then
		print("Client: removing previous client")
		client:stopScanning()
		client:disconnect()
		client:stop()
		client = nil
	end

	servers = {}
	inThisScene = false

	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil

	--Rensar lyssnare
		Runtime:removeEventListener("autolanReceived", clientReceived)
		Runtime:removeEventListener("autolanFileReceived", clientFileReceived)
		Runtime:removeEventListener("autolanConnectionFailed", connectionAttemptFailed)
		Runtime:removeEventListener("autolanDisconnected", receiverDisconnected)
		Runtime:removeEventListener("autolanConnected", receiverConnected)
		Runtime:removeEventListener("autolanServerFound", createListItem)
		scrollListenerAdded = false
		listingItems = false
	---
end


scene:addEventListener("create",scene)
scene:addEventListener("hide",scene)

return scene
