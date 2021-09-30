local composer 	= require "composer"
local scene 	= composer.newScene()
local aud 		= require 'audioo'

local backdrop

function scene:create(e)
	params = e.params

	local mainFrameGroup = display.newGroup()

	local buttons = {}

	local tapTutorial
	local onBack
	local backButton

	backdrop = require 'background'
	self.view:insert(backdrop)
	
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	local frame = display.newImageRect(mainFrameGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	frame.xScale, frame.yScale = (_W / 1032)*0.85, (_H / 1032)*0.75
	frame.x, frame.y = _W*0.5, _H*0.5

	local headline = display.newText(mainFrameGroup, 'Tutorials', 0, 0, systemfont, _G.mediumLargeFontSize)
	headline.x, headline.y = _W*0.5, _H*0.08

	local function beforeLeaving(time, callback, e)
		backButton:removeEventListener('tap', onBack)

		for k,v in pairs(buttons) do
			v:removeEventListener('tap', tapTutorial)
		end

		aud.play(sounds.sweep)
		
		transition.to(
			backdrop,
			{
				time = time or 150,
				alpha = 0,
				transition = easing.inOutQuad
			}
		)
		
		transition.to(
			mainFrameGroup,
			{
				time = time or 150,
				y = _H*1.2,
				alpha = 0,
				transition = easing.inOutQuad,
				onComplete = function()
					callback(e)
				end
			}
		)
	end

	local function gotoTutorial(e)
		composer.gotoScene('tutorial', {params = {tutorial = e.target.path}})
	end
	
	local function createLayer(path, color, width)
		local layer = {}
		
		layer.path = path
		layer.width = width or 768
		layer.height = 190
		layer.xScale, layer.yScale = 0.25, 0.25
		layer.x, layer.y = 0, 0
		
		if( color ~= nil) then
			layer.color = color
		end
		
		return layer
	end

	function tapTutorial(e)
		aud.play(sounds.click)
		beforeLeaving(150, gotoTutorial, e)
	end

	local function showTutorials()
		local listOfTutorials = {
			{name = 'The Basics', path = 'tutorial1'},
			{name = 'Subtraction', path = 'tutorial2'},
			{name = 'Combining Colors', path = 'tutorial5'},
			{name = 'Segments', path = 'tutorial4'},
			{name = 'Falling Tiles', path = 'tutorial3'},
		}

		if _G.customLevelsEnabled then
			listOfTutorials[#listOfTutorials+1] = {name = 'Level Editor', path = 'tutorialCustom'}
		end

		for i = 1, #listOfTutorials do
			local tutorialButton = {} --display.newGroup()

			local bg = createLayer('Graphics/Menu/large_btn_fill.png', {0, 255, 0}, nil)
			local fg = createLayer('Graphics/Menu/large_btn_texture.png', nil, nil)

			local text = {}
			text.text = listOfTutorials[i].name
			text.font = systemfont
			text.fontSize = _G.mediumFontSize
			text.x, text.y = 0, 0

			tutorialButton.bg = bg
			tutorialButton.fg = fg
			tutorialButton.text = text

			if _G.model == "iPad" or _G.model == "iPad Retina" then 
				tutorialButton.x, tutorialButton.y = _W*0.5, _H*0.2 + fg.height*fg.yScale*i*1.05 - (fg.height*fg.yScale*0.5) - 20
			else
				tutorialButton.x, tutorialButton.y = _W*0.5, _H*0.2 + fg.height*fg.yScale*i*1.1 - fg.height*fg.yScale*0.5
			end

			tutorialButton.onEnded = tapTutorial

			tutorialButton = createButton(tutorialButton)

			tutorialButton.path = listOfTutorials[i].path
			buttons[i] = tutorialButton
			mainFrameGroup:insert(tutorialButton)
		end
	end

	local function gotoStartscreen(e)
		composer.gotoScene('startscreen')
	end

	function onBack(e)
		aud.play(sounds.click)
		beforeLeaving(150, gotoStartscreen, e)
	end

	mainFrameGroup.y = _H

	aud.play(sounds.sweep)
	transition.to(mainFrameGroup, {time = 150, y = 0, transition = easing.inOutQuad})

	showTutorials()

	backButton = {}--display.newGroup()

	local text = {}--display.newText(backButton, 'Back', 0, 0, systemfont, _G.mediumFontSize)
	text.text = 'Back'
	text.font = systemfont
	text.fontSize = _G.mediumFontSize
	text.x, text.y = 0, 0

	backButton.bg = createLayer('Graphics/Menu/small_btn_fill.png', _G.continueColor, 384)
	backButton.fg = createLayer('Graphics/Menu/small_btn_texture.png', nil, 384)
	backButton.text = text

	backButton.x, backButton.y = _W*0.7, _H*0.8
	backButton.x, backButton.y = _W*0.7, _H*0.8

	backButton.onEnded = onBack

	backButton = createButton(backButton)
	mainFrameGroup:insert(backButton)

	self.view:insert(mainFrameGroup)
end

function scene:show(e)

end 

function scene:hide(e)
	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil
end

function scene:destroy(e)

end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
