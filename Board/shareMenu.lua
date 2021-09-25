local composer 	= require "composer"
local scene 		= composer.newScene()
local aud 			= require 'audioo'

local backdrop

function scene:create(e)
	params = e.params
	local filesList = {}
	local sceneView = self.view

	local mainFrameGroup = display.newGroup()

	local buttons = {}

	local onBack
	local backButton

	backdrop = require 'background'
	sceneView:insert(backdrop)
	
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	local frame = display.newImageRect(mainFrameGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	frame.xScale, frame.yScale = (_W / 1032)*0.85, (_H / 1032)*0.75
	frame.x, frame.y = _W*0.5, _H*0.5

	local headline = display.newText(mainFrameGroup, 'Share', 0, 0, systemfont, _G.mediumLargeFontSize)
	headline.x, headline.y = _W*0.5, _H*0.08

	local function beforeLeaving(time, callback, e)
		--backButton:removeEventListener('tap', onBack)
		backButton.touchLock = true
		backButton.removeEL(backButton)

		for k,v in pairs(buttons) do
			--v:removeEventListener('tap', tapButton)
			v.touchLock = true
			v.removeEL(v)
		end
		
		aud.play(sounds.sweep)
		transition.to(backdrop, {time = time or 150, alpha = 0, transition = easing.inOutQuad})
		transition.to(mainFrameGroup, {time = time or 150, y = _H*1.2, alpha = 0, transition = easing.inOutQuad, onComplete = function()
			callback(e)
		end})
	end

	local function gotoPath(e)
		composer.gotoScene(e.target.path, {params = {menu = 2}})
	end

	function tapButton(e)
		aud.play(sounds.click)
		beforeLeaving(150, gotoPath, e)
	end

	local function showButtons()
		local listOfButtons = {
			{name = 'Share Level', path = 'modules.autoLAN.sendObject'},
			{name = 'Receive Level', path = 'modules.autoLAN.receiveObject'},
		}

		for i = 1, #listOfButtons do
			local button = {}--display.newGroup()

			local bg = {}--display.newImageRect(button, 'Graphics/Menu/large_btn_fill.png', 768, 190)
			bg.path = 'Graphics/Menu/large_btn_fill.png'
			bg.width = 768
			bg.height = 190
			bg.xScale, bg.yScale = 0.25, 0.25
			bg.x, bg.y = 0, 0

			if i == 1 then
				bg.color = _G.playColor
			elseif i == 2 then
				bg.color = _G.levelSelectColor
			else
				bg.color = _G.replayColor
			end

			local fg = {}--display.newImageRect(button, 'Graphics/Menu/large_btn_texture.png', 768, 190)
			fg.path = 'Graphics/Menu/large_btn_texture.png'
			fg.width = 768
			fg.height = 190
			fg.xScale, fg.yScale = 0.25, 0.25
			fg.x, fg.y = 0, 0

			local text = {}--display.newText(button, listOfButtons[i].name, 0, 0, systemfont, _G.mediumFontSize)
			text.text = listOfButtons[i].name
			text.font = systemfont
			text.fontSize = _G.mediumFontSize
			text.x, text.y = 0, 0

			button.bg = bg
			button.fg = fg
			button.text = text
			button.x, button.y = _W*0.5, _H*0.2 + bg.height*bg.yScale*i*1.1 - bg.height*bg.yScale*0.5
			button.buttonParams = {path = listOfButtons[i].path}

			if ((not _G.shareEnabled) and i == 3) then
				bg.alpha = 0.5
				fg.alpha = 0.5
				text.alpha = 0.5

				local lockedImage = display.newImageRect(button, 'Graphics/Objects/lock_small.png', 256, 310)
				lockedImage.x, lockedImage.y = 0, 0
				lockedImage.xScale, lockedImage.yScale = 0.1, 0.1
			else
				button.onEnded = tapButton
			end

			button = createButton(button)

			buttons[#buttons+1] = button

			mainFrameGroup:insert(button)
		end
	end

	local function gotoStartscreen(e)
		composer.gotoScene('customMenu')
	end

	function onBack(e)
		aud.play(sounds.click)
		beforeLeaving(150, gotoStartscreen, e)
	end

	mainFrameGroup.y = _H

	aud.play(sounds.sweep)
	transition.to(mainFrameGroup, {time = 150, y = 0, transition = easing.inOutQuad})

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

	mainFrameGroup:insert(backButton)

	showButtons()

	sceneView:insert(mainFrameGroup)
end

function scene:show(e)end 
function scene:hide(e)
	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil
end 
function scene:destroy(e)end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
