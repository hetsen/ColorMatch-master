--=======================================================================================
--=
--=  Skickavy
--=  av 10Fingers
--=
--=  Filuppdateringar:
--=   * 2013-06-19 <TommyLind> - Fil Uppdaterad.
--=   * 2013-06-18 <TommyLind> - Fil skapad.
--=

--[[
	Exempel:
	composer.gotoScene("modules.autoLAN.receiveObject")
]]
--=======================================================================================

local composer 	= require("composer")
local scene 		= composer.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight


--Moduler
	--AUTOLAN
		local server
	---
---

--Funktioner
	--AUTOLAN
		local playerDropped
		local addPlayer
		local serverReceived
		local serverFileReceived
		local sendPackageToAll
	---

	local tenfLib = require("modules.tenfLib")
	local setAttr = tenfLib.setAttr
	local newGroup = tenfLib.newGroup
	local fitTextInArea = tenfLib.fitTextInArea
	local imagePath = "modules/autoLAN/tempPic/"

	local aud = require 'audioo'
---

--Variabler
	local inThisScene
	local scrollListenerAdded = false
	local clients = {}
	local backdrop
---

function scene:create(e)
	local sceneView = self.view
	local sceneName = composer.getCurrentSceneName()
	local params = e.params
	inThisScene = true

	-- --Bakgrund
	-- 	setAttr(setAttr(display.newImageRect(sceneView, imagePath.."tempPic.png", _W, _H), {width=_W, height=_H}), {x=0, y=0}, {rp='TL', fc = {80}})
	-- --

	backdrop = require 'background'
	sceneView:insert(backdrop)
	
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	local frame = display.newImageRect(sceneView, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	frame.xScale, frame.yScale = (_W / 1032)*0.85, (_H / 1032)*0.75
	frame.x, frame.y = _W*0.5, _H*0.5

	local headline = display.newText(sceneView, 'Receive Level', 0, 0, systemfont, _G.mediumLargeFontSize)
	headline.x, headline.y = _W*0.5, _H*0.08

	local waitingText = display.newText(sceneView, 'Waiting for files to receive...', 0, 0, systemfont, _G.mediumSmallFontSize)
	waitingText.x, waitingText.y = _W*0.5, _H*0.45

	local function onBack(e)
		aud.play(sounds.click)
		composer.gotoScene('shareMenu')
	end

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

	--

	local nameOfSender = system.getInfo( "name" ) or "name unknown"

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
		local scrollBlock 
		local menuItems = {}
		local padding = 8
		local objectHeight = 40
		local margin = {x = 10, y = 10}
		--AUTOLAN
			local serverOptions = {}
		---
	---

	--Funktioner
		-- local getPositionOfReceiverListItem
		local removeReceiver
		local appendReceiverList
		local removeItemFromReceiverList
		local displayInformation
		local restorePreviousPoint
		local createSendFile
		local rePositionReceiverListItems
		--AUTOLAN
			local sendPackageTo
			local makeServer
			local sendReceivedResponse
		---
	---

	function makeServer()
		if server then
			print("Server: removing previous server")
			server:disconnect()
			server:stop()
			server = nil

			Runtime:removeEventListener("autolanPlayerDropped", playerDropped)
			Runtime:removeEventListener("autolanPlayerJoined", addPlayer)
			Runtime:removeEventListener("autolanReceived", serverReceived)
			Runtime:removeEventListener("autolanFileReceived", serverFileReceived)
		end
		if not inThisScene then return end
		print("Server: making server")
		server = tenfLib.requireNew("modules.autoLAN.modules.server")
		server:setOptions(serverOptions)

		server:startLocal()
		server:setCustomBroadcast(nameOfSender)

		--Lägger till event listeners
			Runtime:addEventListener("autolanPlayerDropped", playerDropped)
			Runtime:addEventListener("autolanPlayerJoined", addPlayer)
			Runtime:addEventListener("autolanReceived", serverReceived)
			Runtime:addEventListener("autolanFileReceived", serverFileReceived)
		---

		-- notify(getText('sharing_send_waitingForClient'), _G.fontSizeSmall)
		-- loadingIndicator.isVisible = true
		--notisen

	end

	function removeReceiver(receiverDropped)
		--Loopar igenom och hittar vilken mottagare som har lämnat
			local receiverID = table.indexOf(clients, receiverDropped)
		---
		--Tar bort menyobjektet samt klienten från listan
			if receiverID then
				-- removeItemFromReceiverList(receiverID)
				table.remove(clients, receiverID)
			else
				-- rePositionReceiverListItems()
			end
		---
		print "Server: --Clients left--"
		for k,v in pairs(clients) do
			print(k, v.name)
		end
		print "Server: ------------------------"
	end

	----Server(Sändare) Funktioner----
		function sendPackageToAll(_package)
			if clients then
				for i,v in ipairs(clients) do
					sendPackageTo(clients[i], _package)
				end
			end
		end

		function sendPackageTo(_receiver, _package)
			_receiver:send(_package)
		end


		function playerDropped(event)
			local receiverDropped = event.client
			print("Server: "..receiverDropped.name.." dropped because "..tostring(event.message))
			removeReceiver(receiverDropped)
			-- notify(getText('sharing_send_clientDisconnected', {serverName=tenfLib.shortenText(receiverDropped.name, 15, '...')}), _G.fontSizeSmall, 1000)
			--notisen
		end

		function addPlayer(event)
			local newReceiver = event.client
			newReceiver.myIP = event.clientIP
			if #clients <= 0 then
				print("Server: player joined")
				table.insert(clients, newReceiver)
				sendPackageTo(newReceiver, {[1] = 3}) --Skickar what's your name
			else
				print("Server: player disconnect it's full")
				table.insert(clients, newReceiver)
				sendPackageTo(newReceiver, {[1] = 4}) --Skickar it's full
			end
		end

		function sendReceivedResponse(_receiver)
			--Skickar svar att jag fått den
				local package = {[1] = 2}
				sendPackageTo(_receiver, package)
			---
		end




		function serverFileReceived(event)
			print("Server: I got file now, said the server")
			local client = clients[event.clientID]
			timer.performWithDelay(100, function()
				--FilnamnsData
					local lfs = require 'lfs'
					local doc_path = system.pathForFile("", system.DocumentsDirectory)
					lfs.chdir(doc_path)
					lfs.mkdir("levels")

					local fileName, fileDir = event.filename, event.fileDir

					local mapDestFileName, mapDestFileDir = 'levels/' .. fileName, system.DocumentsDirectory --här
					local fromPath, toPath = system.pathForFile(fileName, fileDir), system.pathForFile(mapDestFileName, mapDestFileDir)
				---

				--Skickar svar att jag fått objektet
					if client then
						sendReceivedResponse(client)
					end
				---

				local tmpDate = os.date('*t')

				local dateList = {}
				dateList[1] = tmpDate.year
				dateList[2] = tmpDate.month
				dateList[3] = tmpDate.day
				dateList[4] = tmpDate.hour
				dateList[5] = tmpDate.min

				for i = 1, #dateList do
					if dateList[i] < 10 then
						dateList[i] = '0' .. dateList[i]
					end
				end

				local dateTime = dateList[1] .. dateList[2] .. dateList[3] .. dateList[4] .. dateList[5]

				local theFile = tenfLib.jsonLoad(fileName, fileDir)

				theFile.DateTime = dateTime

				tenfLib.jsonSave(fileName, fileDir, theFile)

				native.showAlert("Received", ((client and client.name) or "Someone").." wants to send the map " .. fileName .. " to you.\nDo you want to save it?", {"Yes", "No"}, function(e)
					if e.index == 1 then --Yes
						--Lägger filen på rätt plats.				
							tenfLib.copyFile( fromPath, toPath )
							os.remove( fromPath )

							composer.gotoScene('shareMenu')
						---
					elseif e.index == 2 then --No
						os.remove( fromPath )
					end
				end)
			end)
		end

		function serverReceived(event)
			local client = event.client
			local message = event.message
			print("Server: I got message now, said the server")
			if message[1] == 2 then --objReceived (svar till sendingobj)
				print("Server: objReceived: Ska inte inträffa!")
				local index = table.indexOf(clients, client)
				local objID = message[2]
				if index then
					client.received = true
					client.sent = false
				end
			elseif message[1] == 3 then --myNameIs (svar till whatsYourName)
				print("Server: myNameIs: Sparar namnet på personen!")

				local index = table.indexOf(clients, client)
				if index then
					client.name = message[2]
					sendPackageTo(client, {[1] = 1}) --Skickar readyToReceive
				end
			end
		end
	---

	--Startar vyn
		--Skapar sändningsvyn.
			local function startSendingView()
				--Skapar scrollBlock
					local width, height = _W, _H - 2 * (margin.y + objectHeight / 2 + padding) - 10
					scrollBlock = require("modules.autoLAN.modules.scrollBlock")( width, height, { y=true } )
					scrollBlock.y = (margin.y + objectHeight / 2 + padding)
					sceneView:insert(scrollBlock)
					require("modules.utils.mask").setRectMask(scrollBlock, width, height, "L", "T")
				---
				makeServer()
			end
		---

		--Initiate
			startSendingView()
		---
	---
end

function scene:hide(e)
	print("Server: removing previous server")
	if server then
		server:disconnect()
		server:stop()
	end
	server = nil
	clients = {}
	inThisScene = false

	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil

	--Rensar eventlisteners
		Runtime:removeEventListener("autolanPlayerDropped", playerDropped)
		Runtime:removeEventListener("autolanPlayerJoined", addPlayer)
		Runtime:removeEventListener("autolanReceived", serverReceived)
		Runtime:removeEventListener("autolanFileReceived", serverFileReceived)
		scrollListenerAdded = false
	---
end

scene:addEventListener("create",scene)
scene:addEventListener("hide",scene)

return scene