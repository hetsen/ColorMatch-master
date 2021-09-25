local composer = require "composer"
local lfs 		 = require "lfs"
local tenflib 	 = require 'tenfLib'
local aud 		 = require 'audioo'

local scene = composer.newScene()

local mapGroup
local colorGroup

function scene:show(e)
local sceneView = self.view
	
display.setStatusBar(display.HiddenStatusBar)
local json = require 'json'

local _W, _H = display.contentWidth, display.contentHeight
local canvasW, canvasH = _W, _H*0.9
local notCanvasH = _H*0.1

local currentColor
local currentValue = 1
local indicatorColor
local hText, wText, diffText
local goalIndicator
local arrowIndicator
local flatGrid
local sizeX, sizeY = 7, 7
local startPosX, startPosY = 1, 1
local goalColor, mixedColor
local grid
local currentFile
local theType, Name
local nameInput, colNumInput, timeInput, stepInput
local typedName, typedColNum, typedTime, typedSteps, typedFalling
local buttonColor = {255,255,255}--graphics.newGradient({192,192,192},{96,96,96},'down')
local startButton, goalButton
local loadedName, loadedTime, loadedSteps, loadedMaxColors

local model = system.getInfo('model')
local compact = ''

if model == 'iPhone' then compact = '_compact' end

local indicatorRed
local indicatorGreen
local indicatorBlue

local selectionColors

local colors = {
	{0,0,0},
	{255,255,255},
	{255,0,0},
	{0,255,0},
	{0,0,255},
	{0,255,255},
	{255,0,255},
	{255,255,0},
	-- {255,128,0},
	-- {0,255,128},
	-- {128,0,255},
	-- {128,255,0},
	-- {0,128,255},
	-- {255,0,128},
}

--
-- Variabler från banpaket
--

local arrowEnabled = _G.worldsUnlocked['Glistening Tides']

--
--
--

--local acceptableValues = {255,192,128,64,0}

local grayBg = display.newRect(0, 0, canvasW, canvasH)
grayBg.x, grayBg.y = canvasW*0.5, canvasH*0.5
grayBg:setFillColor(32)
sceneView:insert(grayBg)

--Create map "levels" in system.DocumentsDirectory
local doc_path = system.pathForFile("", system.DocumentsDirectory)
lfs.chdir(doc_path)
lfs.mkdir("levels")

local function getAllFiles()
	local fileList = {}

	for file in lfs.dir(lfs.currentdir() .. "/levels") do
		if file ~= "." then
			if file ~= ".." then
				if file ~= ".DS_Store" then
					if file ~= "bg.png" then
						fileList[#fileList+1] = file
						--print( "Found file: " .. file )
					end
				end
			end
		end
	end

	return fileList
end

local function save(data, fileName)
	

	--print ("levels/"..padding..tostring(#F+1).."_"..fileName)

	local path = system.pathForFile("levels/"..fileName, system.DocumentsDirectory)
	local file = io.open(path, 'w+')
	local data = json.encode(data)
	file:write(data)
	io.close(file)
end

local function drawBlob(xScale, yScale)
	local blob = display.newGroup()

	local startBgCircle = display.newImageRect(blob, 'pics/marker.png', 128, 128)
	startBgCircle.xScale, startBgCircle.yScale = xScale, yScale
	startBgCircle.x, startBgCircle.y = 0, 0
	startBgCircle:setFillColor(128)

	local startBgEyes = {}

	for i = 1,2 do 
		startBgEyes[i] = display.newCircle(blob, 0,0,30)
		startBgEyes[i].dot = display.newCircle(blob, 0,0,10)
		
		startBgEyes[i].xScale = startBgCircle.xScale*0.5
		startBgEyes[i].yScale = startBgCircle.yScale*0.5
		
		startBgEyes[i]:setFillColor(255,255,255)
		startBgEyes[i].dot:setFillColor(0,0,0)

		startBgEyes[i]:setStrokeColor(0,0,0)
		startBgEyes[i].strokeWidth = 3
		startBgEyes[i].y =  - startBgCircle.height*startBgCircle.yScale*0.125
		startBgEyes[i].dot.y =  startBgEyes[i].y - startBgEyes[i].height*startBgEyes[i].yScale*0.125
		startBgEyes[i].dot.xScale, startBgEyes[i].dot.yScale = startBgCircle.xScale*0.5, startBgCircle.yScale*0.5
		startBgEyes[i]:toFront()
		startBgEyes[i].dot:toFront()
	
	end

	startBgEyes[1].x = - startBgCircle.width*startBgCircle.xScale*0.125
	startBgEyes[2].x = startBgCircle.width*startBgCircle.xScale*0.125
	startBgEyes[1].dot.x = startBgEyes[1].x
	startBgEyes[2].dot.x = startBgEyes[2].x

	return blob
end

local function onSave(OneStep)
	local tileData = {}
	local allColorsOnBoard = {}
	local goals, starts = 0, 0

	if OneStep then
		theType = 'OneStep'
	else
		theType = 'Default'
	end

	for i = 1, #flatGrid do
		tileData[i] = flatGrid[i].value or 0

		if flatGrid[i].startSign.alpha == 1 then
			starts = starts + 1
			tileData[i] = 1
			startPosX, startPosY = flatGrid[i].i, flatGrid[i].j
		elseif flatGrid[i].goalSign.alpha == 1 then
			goals = goals + 1
			tileData[i] = 2
			goalColor = flatGrid[i].color
		elseif flatGrid[i].arrowSign and flatGrid[i].arrowSign.alpha == 1 then
			local arrowDir = 0
			local rot = flatGrid[i].arrowSign.rotation

			if rot == 90 then
				arrowDir = 1
			elseif rot == 180 then
				arrowDir = 2
			elseif rot == 270 then
				arrowDir = 3
			end

			tileData[i] = 10 + arrowDir
		elseif flatGrid[i].color ~= colors[1] and flatGrid[i].color ~= colors[2] then
			local unique = true

			for k,v in pairs(allColorsOnBoard) do
				if flatGrid[i].color == v then
					unique = false
				end
			end

			if unique then
				allColorsOnBoard[#allColorsOnBoard+1] = flatGrid[i].color
			end
		end
	end

	local colNum = colNumInput.text
	if colNum == '' then colNum = nil end
	colNum = tonumber(colNum)
	if colNum == 0 then colNum = 1 end

	local time = timeInput.text
	if time == '' then time = nil end
	time = tonumber(time)
	if time == 0 then time = 1 end

	local steps = stepInput.text
	if steps == '' then steps = nil end
	steps = tonumber(steps)
	if steps == 0 then steps = 1 end

	if nameInput.text == '' or nameInput.text == nil then
		Name = os.time()
	else
		Name = nameInput.text or os.time()
	end

	local function doSave()
		local numberOfSegments = 1
		local numberOfZeros = 0

		for i = 1, 3 do
			if goalColor[i] == 64 then
				numberOfSegments = 4
			elseif goalColor[i] == 192 and numberOfSegments < 3 then
				numberOfSegments = 3
			elseif goalColor[i] == 128 and numberOfSegments < 2 then
				numberOfSegments = 2
			elseif goalColor[i] == 0 then
				numberOfZeros = numberOfZeros + 1
			end
		end

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

		colNum = colNum or 1

		local dateTime = dateList[1] .. dateList[2] .. dateList[3] .. dateList[4] .. dateList[5]

		if colNum >= numberOfSegments or numberOfZeros >= 2 then
			if colNum <= 4 then
				save({
					DateTime = dateTime,
					User = true,
					Time = time or 10,
					Steps = steps or 10,
					Type = theType,
					Name = Name,
					Size = {x = sizeX, y = sizeY},
					Tile = tileData,
					StartPos = {x = startPosX or 1, y = startPosY or 1},
					GoalColor = {r = goalColor[1] or 255, g = goalColor[2] or 255, b = goalColor[3] or 255},
					MarkerColorMaxSegments = colNum,
					nColorsOnBoard = #allColorsOnBoard
				},
				Name)
				native.showAlert('Saved', 'The file was saved successfully', {'Ok'})
			else
				native.showAlert('Warning!', 'You have selected too many color segments. The maximum amount is 4.', {'Ok'})
			end
		else
			native.showAlert('Warning!', 'You have selected too few color segments. The minimum for this level is ' .. numberOfSegments, {'Ok'})
		end
	end
	
	if goals == 1 and starts == 1 then
		local path = system.pathForFile(('levels/' .. Name), system.DocumentsDirectory)
		local nameExists = false

		if path then
			local handle, errStr = io.open(path, 'r')
			
			if handle then
				nameExists = true
				io.close(handle)
			end
		end

		if nameExists then
			native.showAlert('The level already exists!', 'Do you wish to overwrite it?', {'Yes', 'No'}, function(e)
				if e.index == 1 then
					doSave()
				end
			end)
		else
			doSave()
		end
	else
		native.showAlert('Warning', 'You must have exactly one start and one goal on custom levels.', {'Ok'})
	end
end

local function overlayEndedTransition(e)
	e.target.ending = true

	native.setKeyboardFocus(nil)

	transition.to(e.target.overlay, {time = 199, alpha = 0})
	transition.to(e.target, {time = 200, y = e.target.originY, onComplete=function()
		display.remove(e.target.overlay)
		e.target.overlay = nil

		nameInput.isVisible = true
		colNumInput.isVisible = true
		timeInput.isVisible = true
		stepInput.isVisible = true

		e.target.ending = false
	end})
end

local function createOverlay(event)
	local overlay = display.newRect(sceneView, 0, 0, _W, _H)
	overlay.x, overlay.y = _W*0.5, _H*0.5
	overlay.alpha = 0
	overlay:setFillColor(0)

	local function onOverlayTouch(e)
		timer.performWithDelay(1, function()
			if not event.target.ending then
				overlayEndedTransition(event)
			end
		end)

		return true
	end

	overlay:addEventListener('touch', onOverlayTouch)
	overlay:addEventListener('tap', onOverlayTouch)

	return overlay
end

local function saveMenu()
	local saveGroup = display.newGroup()
	sceneView:insert(saveGroup)

	local function onBgTap(e)
		timer.performWithDelay(1, function()
			display.remove(saveGroup)
		end)

		return true
	end

	local function onBgTouch(e)
		return true
	end

	local bgRect = display.newRect(saveGroup, 0, 0, _W, _H)
	bgRect.x, bgRect.y = _W*0.5, _H*0.5
	bgRect.alpha = 0.5
	bgRect:setFillColor(0)
	bgRect:addEventListener('tap', onBgTap)
	bgRect:addEventListener('touch', onBgTouch)

	local function onFgTouch(e)
		return true
	end

	local fgScaleX, fgScaleY = 0.2, 0.3
	local buttonScale = 0.12
	local smallFSize = _G.smallFontSize
	local mediumSmallFSize = _G.mediumSmallFontSize
	local mediumFSize = _G.mediumFontSize

	if model == 'iPhone' then
		fgScaleX, fgScaleY = 0.3, 0.4
		buttonScale = 0.2
		smallFSize = _G.mediumSmallFontSize
		mediumSmallFSize = _G.mediumFontSize
		mediumFSize = _G.largeFontSize
	end

	local fgRect = display.newImageRect(saveGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	fgRect.xScale, fgRect.yScale = fgScaleX, fgScaleY
	fgRect.x, fgRect.y = bgRect.x, bgRect.y
	fgRect:setFillColor(255,0,64)
	fgRect:addEventListener('tap', onFgTouch)
	fgRect:addEventListener('touch', onFgTouch)

	local nameText = display.newText(saveGroup, 'Name of level', 0, 0, systemfont, smallFSize)
	nameText.x, nameText.y = fgRect.x, fgRect.y - fgRect.height*fgRect.yScale*0.5 + nameText.height

	nameInput = native.newTextField(0, 0, fgRect.width*fgRect.xScale*0.5, fgRect.height*fgRect.yScale*0.08)
	saveGroup:insert(nameInput)
	nameInput.align = 'center'
	nameInput.text = loadedName or typedName or ''
	nameInput.x, nameInput.y = nameText.x, nameText.y + nameText.height*2
	nameInput:addEventListener('userInput', function(e)
		if #e.target.text > 20 then
			e.target.text = string.sub(e.target.text, 1, 20)
		end

		if e.phase == 'began' then
			if not e.target.overlay then
				e.target.overlay = createOverlay(e)

				colNumInput.isVisible = false
				timeInput.isVisible = false
				stepInput.isVisible = false

				e.target.originY = e.target.y
				transition.to(e.target, {time = 200, y = _H*0.25})
				transition.to(e.target.overlay, {time = 200, alpha = 1})
			end
		elseif e.phase == 'submitted' or e.phase == 'ended' then

			typedName = e.target.text

			overlayEndedTransition(e)
		end
	end)

	local colNumText = display.newText(saveGroup, 'Amount of color segments', 0, 0, systemfont, smallFSize)
	colNumText.x, colNumText.y = nameInput.x, nameInput.y + nameInput.height

	colNumInput = native.newTextField(0, 0, fgRect.width*fgRect.xScale*0.25, fgRect.height*fgRect.yScale*0.08)
	colNumInput.inputType = 'number'
	colNumInput.align = 'center'
	saveGroup:insert(colNumInput)
	colNumInput.text = loadedMaxColors or typedColNum or ''
	colNumInput.x, colNumInput.y = colNumText.x, colNumText.y + colNumText.height*2
	colNumInput:addEventListener('userInput', function(e)
		if #e.target.text > 1 then
			e.target.text = string.sub(e.target.text, 1, 1)
		end

		if tonumber(e.target.text) and (tonumber(e.target.text) > 4 or tonumber(e.target.text) < 1) then
			e.target.text = ''
		elseif tonumber(e.target.text) == nil then
			e.target.text = ''
		end

		if e.phase == 'began' then
			if not e.target.overlay then
				e.target.overlay = createOverlay(e)

				nameInput.isVisible = false
				timeInput.isVisible = false
				stepInput.isVisible = false

				e.target.originY = e.target.y
				transition.to(e.target, {time = 200, y = _H*0.25})
				transition.to(e.target.overlay, {time = 200, alpha = 1})
			end
		elseif e.phase == 'submitted' or e.phase == 'ended' then
			typedColNum = e.target.text

			overlayEndedTransition(e)
		end
	end)

	local timeText = display.newText(saveGroup, 'Time Bonus Threshold', 0, 0, systemfont, smallFSize)
	timeText.x, timeText.y = colNumInput.x, colNumInput.y + colNumInput.height

	timeInput = native.newTextField(0, 0, fgRect.width*fgRect.xScale*0.25, fgRect.height*fgRect.yScale*0.08)
	timeInput.inputType = 'number'
	saveGroup:insert(timeInput)
	timeInput.align = 'center'
	timeInput.text = loadedTime or typedTime or ''
	timeInput.x, timeInput.y = timeText.x, timeText.y + timeText.height*2
	timeInput:addEventListener('userInput', function(e)
		if #e.target.text > 3 then
			e.target.text = string.sub(e.target.text, 1, 3)
		end
		
		if tonumber(e.target.text) and (tonumber(e.target.text) > 300 or tonumber(e.target.text) < 1) then
			e.target.text = ''
		elseif tonumber(e.target.text) == nil then
			e.target.text = ''
		end

		if e.phase == 'began' then
			if not e.target.overlay then
				e.target.overlay = createOverlay(e)

				nameInput.isVisible = false
				colNumInput.isVisible = false
				stepInput.isVisible = false

				e.target.originY = e.target.y
				transition.to(e.target, {time = 200, y = _H*0.25})
				transition.to(e.target.overlay, {time = 200, alpha = 1})
			end
		elseif e.phase == 'submitted' or e.phase == 'ended' then
			typedTime = e.target.text

			overlayEndedTransition(e)
		end
	end)

	local stepText = display.newText(saveGroup, 'Step Bonus Threshold', 0, 0, systemfont, smallFSize)
	stepText.x, stepText.y = timeInput.x, timeInput.y + timeInput.height

	stepInput = native.newTextField(0, 0, fgRect.width*fgRect.xScale*0.25, fgRect.height*fgRect.yScale*0.08)
	stepInput.inputType = 'number'
	saveGroup:insert(stepInput)
	stepInput.align = 'center'
	stepInput.text = loadedSteps or typedSteps or ''
	stepInput.x, stepInput.y = stepText.x, stepText.y + stepText.height*2
	stepInput:addEventListener('userInput', function(e)
		if #e.target.text > 3 then
			e.target.text = string.sub(e.target.text, 1, 3)
		end
		
		if tonumber(e.target.text) and (tonumber(e.target.text) > 200 or tonumber(e.target.text) < 1) then
			e.target.text = ''
		elseif tonumber(e.target.text) == nil then
			e.target.text = ''
		end

		if e.phase == 'began' then
			if not e.target.overlay then
				e.target.overlay = createOverlay(e)

				nameInput.isVisible = false
				colNumInput.isVisible = false
				timeInput.isVisible = false

				e.target.originY = e.target.y
				transition.to(e.target, {time = 200, y = _H*0.25})
				transition.to(e.target.overlay, {time = 200, alpha = 1})
			end
		elseif e.phase == 'submitted' or e.phase == 'ended' then
			typedSteps = e.target.text

			overlayEndedTransition(e)
		end
	end)

	local blockFallingText = display.newText(saveGroup, 'Falling tiles', 0, 0, systemfont, smallFSize)
	blockFallingText.x, blockFallingText.y = stepInput.x, stepInput.y + stepInput.height

	local function onSwitch(e)
		aud.play(sounds.click)
		e.target.alpha = 1

		if e.target.text.text == 'Off' then
			e.target.text.text = 'On'
			e.target.bg:setFillColor(0,255,0)
			typedFalling = true
		else
			e.target.text.text = 'Off'
			e.target.bg:setFillColor(255,0,0)
			typedFalling = false
		end
	end

	local blockFallingSwitch = {}--display.newGroup()

	local blockBg = {}--display.newImageRect(blockFallingSwitch, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	blockBg.path = 'Graphics/Menu/small_btn_fill.png'
	blockBg.width = 384
	blockBg.height = 190
	blockBg.xScale, blockBg.yScale = buttonScale, buttonScale
	blockBg.x, blockBg.y = 0, 0
	blockBg.color = {255,0,0}

	local blockFg = {}--display.newImageRect(blockFallingSwitch, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	blockFg.path = 'Graphics/Menu/small_btn_texture.png'
	blockFg.width = 384
	blockFg.height = 190
	blockFg.xScale, blockFg.yScale = buttonScale, buttonScale
	blockFg.x, blockFg.y = 0, 0

	blockFallingSwitch.onEnded = onSwitch
	blockFallingSwitch.x, blockFallingSwitch.y = blockFallingText.x, blockFallingText.y + blockFallingText.height*2

	local blockFallingSwitchText = {}--display.newText(saveGroup, 'Off', 0, 0, systemfont, smallFSize)
	--blockFallingSwitchText.x, blockFallingSwitchText.y = blockFallingSwitch.x, blockFallingSwitch.y
	blockFallingSwitchText.text = 'Off'
	blockFallingSwitchText.font = systemfont
	blockFallingSwitchText.fontSize = smallFSize

	-- blockFg.bg = blockBg
	-- blockFg.blockText = blockFallingSwitchText
	blockFallingSwitch.bg = blockBg
	blockFallingSwitch.blockText = blockFallingSwitchText

	if typedFalling == true then
		blockFallingSwitchText.text = 'On'
		blockBg.color = {0,255,0}
	elseif typedFalling == false then
		blockFallingSwitchText.text = 'Off'
		blockBg.color = {255,0,0}
	end

	blockFallingSwitch.bg = blockBg
	blockFallingSwitch.fg = blockFg
	blockFallingSwitch.text = blockFallingSwitchText

	blockFallingSwitch = createButton(blockFallingSwitch)

	saveGroup:insert(blockFallingSwitch)

	local function onDone(e)
		aud.play(sounds.click)

		if e.target.blockText.text == 'On' then
			onSave(true)
		else
			onSave(false)
		end

		display.remove(saveGroup)
	end

	local cancelButton = {}--display.newGroup()

	local cancelBg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	cancelBg.path = 'Graphics/Menu/small_btn_fill.png'
	cancelBg.width = 384
	cancelBg.height = 190
	cancelBg.x, cancelBg.y = 0, 0
	cancelBg.xScale, cancelBg.yScale = buttonScale, buttonScale
	cancelBg.color = _G.continueColor

	local cancelFg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	cancelFg.path = 'Graphics/Menu/small_btn_texture.png'
	cancelFg.width = 384
	cancelFg.height = 190
	cancelFg.xScale, cancelFg.yScale = buttonScale, buttonScale
	cancelFg.x, cancelFg.y = 0, 0

	cancelButton.x, cancelButton.y = fgRect.x - fgRect.width*fgRect.xScale*0.44 + cancelBg.width*cancelBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.46 - cancelBg.height*cancelBg.yScale*0.5
	cancelButton.onEnded = onBgTap

	local cancelText = {}--display.newText(saveGroup, 'Cancel', 0, 0, systemfont, smallFSize)
	cancelText.text = 'Cancel'
	cancelText.font = systemfont
	cancelText.fontSize = smallFSize
	--cancelText.x, cancelText.y = cancelButton.x, cancelButton.y

	cancelButton.bg = cancelBg
	cancelButton.fg = cancelFg
	cancelButton.text = cancelText

	cancelButton = createButton(cancelButton)

	saveGroup:insert(cancelButton)

	local doneButton = {}--display.newGroup()

	local doneBg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	doneBg.path = 'Graphics/Menu/small_btn_fill.png'
	doneBg.width = 384
	doneBg.height = 190
	doneBg.x, doneBg.y = 0, 0
	doneBg.xScale, doneBg.yScale = buttonScale, buttonScale
	doneBg.color = _G.playColor

	local doneFg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	doneFg.path = 'Graphics/Menu/small_btn_texture.png'
	doneFg.width = 384
	doneFg.height = 190
	doneFg.xScale, doneFg.yScale = buttonScale, buttonScale
	doneFg.x, doneFg.y = 0, 0

	local doneText = {}--display.newText(saveGroup, 'Save', 0, 0, systemfont, smallFSize)
	doneText.text = 'Save'
	doneText.font = systemfont
	doneText.fontSize = smallFSize
	doneText.x, doneText.y = doneButton.x, doneButton.y

	doneButton.x, doneButton.y = fgRect.x + fgRect.width*fgRect.xScale*0.44 - doneBg.width*doneBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.46 - doneBg.height*doneBg.yScale*0.5
	doneButton.bg = doneBg
	doneButton.fg = doneFg
	doneButton.text = doneText
	doneButton.onEnded = onDone
	doneButton.buttonParams = {blockText = blockFallingSwitchText}

	doneButton = createButton(doneButton)

	saveGroup:insert(doneButton)
end

function showTubeColors(mixedColor)
	indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 1, 1, 1
	indicatorRed.yScale = (mixedColor[1] / 4) + 0.01
	indicatorGreen.yScale = (mixedColor[2] / 4) + 0.01
	indicatorBlue.yScale = (mixedColor[3] / 4) + 0.01
	indicatorRed.y = indicatorRed.originY - indicatorRed.height*indicatorRed.yScale*0.5 + indicatorRed.height*0.5 --_H - indicatorRed.height*0.5*indicatorRed.yScale + 2
	indicatorGreen.y = indicatorGreen.originY - indicatorGreen.height*indicatorGreen.yScale*0.5 + indicatorGreen.height*0.5 --_H - indicatorGreen.height*0.5*indicatorGreen.yScale + 2
	indicatorBlue.y = indicatorBlue.originY - indicatorBlue.height*indicatorBlue.yScale*0.5 + indicatorBlue.height*0.5 --_H - indicatorBlue.height*0.5*indicatorBlue.yScale + 2	
end

local function onChangeTile(e)
	mixedColor = nil

	local hasGoal = false

	for k,v in pairs(flatGrid) do
		if v.goalSign.alpha == 1 and not (v == e.target) then
			hasGoal = true
		end
	end

	if hasGoal and (goalIndicator.alpha == 1) then
		native.showAlert('Warning!', 'You already have a goal tile.', {'Ok'})
		goalButton.alpha = 1
		goalIndicator.alpha = 0
	else
		if goalIndicator.alpha == 1 then
			if e.phase == 'ended' then
				local biggestValue = 1

				if currentColor[1] == 0 and currentColor[2] == 0 and currentColor[3] == 0 then
					for i = 1, #e.target.colorList do
						e.target.colorList[i] = e.target.colorList[i] - 1

						if e.target.colorList[i] < 0 then e.target.colorList[i] = 4 end

						if e.target.colorList[i] > e.target.colorList[biggestValue] then
							biggestValue = i
						end
					end
				else
					for i = 1, #e.target.colorList do
						if currentColor[i] == 255 then
							e.target.colorList[i] = e.target.colorList[i] + 1

							if e.target.colorList[i] > 4 then e.target.colorList[i] = 0 end
						end

						if e.target.colorList[i] > e.target.colorList[biggestValue] then
							biggestValue = i
						end
					end
				end

				e.target.color = {0,0,0}

				for i = 1, 3 do
					if e.target.colorList[i] > 0 or e.target.colorList[biggestValue] > 0 then
						e.target.color[i] = math.ceil((e.target.colorList[i] / e.target.colorList[biggestValue])*255)
					else
						e.target.color[i] = 0
					end
				end

				-- e.target.color = {
				-- 	math.ceil((e.target.colorList[1] / e.target.colorList[biggestValue])*255),
				-- 	math.ceil((e.target.colorList[2] / e.target.colorList[biggestValue])*255),
				-- 	math.ceil((e.target.colorList[3] / e.target.colorList[biggestValue])*255)
				-- }
			end

			mixedColor = {e.target.color[1],e.target.color[2],e.target.color[3]}

			showTubeColors(e.target.colorList)
		else
			e.target.colorList = {0,0,0}
			e.target.color = currentColor
			e.target.value = currentValue
			--indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 0, 0, 0
		end

		if ((goalIndicator.alpha == 1 and e.phase == 'ended') or goalIndicator.alpha == 0) and ((arrowIndicator and not (arrowIndicator.alpha == 1)) or not arrowIndicator) then
			local tmpColor = {e.target.color[1],e.target.color[2],e.target.color[3]}

			if (tmpColor[1] == 255 and tmpColor[2] == 255 and tmpColor[3] == 255)
			or (tmpColor[1] == 0 and tmpColor[2] == 0 and tmpColor[3] == 0) then
				e.target.vial.alpha = 0

				if (tmpColor[1] == 0 and tmpColor[2] == 0 and tmpColor[3] == 0) then
					e.target.alpha = 0.01
				else
					e.target.alpha = 1
				end
			else
				e.target.vial.alpha = 1
				e.target.alpha = 1
			end

			e.target.vial.bg:setFillColor(unpack(e.target.color))
			e.target.goalColor:setFillColor(unpack(e.target.color))

			if mixedColor then
				indicatorColor.alpha = 1
				indicatorColor:setFillColor(unpack(e.target.color))
			end

			e.target.startSign.alpha = 0

			if startIndicator.alpha == 1 then
				local hasStart = false

				for k,v in pairs(flatGrid) do
					if v.startSign.alpha == 1 then
						hasStart = true
					end
				end

				if hasStart then
					native.showAlert('Warning!', 'You already have a start tile.', {'Ok'})
					startButton.alpha = 1
					startIndicator.alpha = 0
				else
					e.target.startSign.alpha = 1
				end
			end

			e.target.goalSign.alpha = 0
			e.target.goalColor.alpha = 0

			if goalIndicator.alpha == 1 then
				e.target.goalSign.alpha = 1
				e.target.goalColor.alpha = 1
			end
		elseif arrowIndicator and arrowIndicator.alpha == 1 and e.phase == 'ended' then
			e.target.alpha = 1
			e.target.vial.alpha = 0
			e.target.startSign.alpha = 0
			e.target.goalSign.alpha = 0	
			e.target.goalColor.alpha = 0

			if e.target.arrowSign.alpha == 1 then
				e.target.arrowSign.rotation = (e.target.arrowSign.rotation + 90) % 360

				if e.target.arrowSign.rotation == 0 then
					e.target.arrowSign.alpha = 0
				end
			else
				e.target.arrowSign.alpha = 1
			end
		end

		if e.target.goalSign.alpha == 1 then
			e.target.alpha = 1

			if arrowEnabled then
				e.target.arrowSign.alpha = 0
				e.target.arrowSign.rotation = 0
			end
		end
	end

	if arrowIndicator and arrowIndicator.alpha == 0 then
		e.target.arrowSign.alpha = 0
	end
end

local function createMap(width, height)
	display.remove(mapGroup)
	mapGroup = display.newGroup()
	sceneView:insert(mapGroup)
	local grid = {}
	flatGrid = {}

	local actualW, actualH = canvasW, canvasW
	sizeX, sizeY = width, height

	if width > height then
		actualH = (canvasW / width) * height
	else
		actualW = (canvasW / height) * width
	end

	repeat
		if actualW / width > 128 then
			actualW = actualW * 0.9
			actualH = actualH * 0.9
		end
	until actualW / width <= 128

	for i = 1, width do
		grid[i] = {}

		for j = 1, height do
			local tile = display.newImageRect('Graphics/Objects/editor_tile.png', 128, 128)
			tile.xScale, tile.yScale = (actualW/width) / tile.width, (actualH/height) / tile.height

			local addToY = 0

			if _G.iphoneFive then
				addToY = (canvasH*0.5 - actualH*0.5)*0.5
			elseif not (compact == '_compact') then
				addToY = canvasH*0.5 - actualH*0.5
			end

			tile.x, tile.y = i*(actualW/width) - (actualW/width)*0.5 + (canvasW*0.5 - actualW*0.5), j*(actualH/height) - (actualH/height)*0.5 + addToY
			tile.i, tile.j = i, j
			tile.alpha = 0.01

			local bgTile = display.newImageRect(mapGroup, 'Graphics/Objects/editor_tile.png', 128, 128)
			bgTile.xScale, bgTile.yScale = tile.xScale, tile.yScale
			bgTile.x, bgTile.y = tile.x, tile.y
			bgTile:setFillColor(0)
			bgTile.strokeWidth = 2 / (bgTile.xScale + bgTile.yScale)
			bgTile:setStrokeColor(64)

			mapGroup:insert(tile)

			local vial = display.newGroup()

			local vialBg = display.newImageRect(vial, 'Graphics/Objects/vial_liquid.png', 128, 128)
			vialBg.xScale, vialBg.yScale = 0.25, 0.25
			vialBg.x, vialBg.y = 0, 0

			local vialFg = display.newImageRect(vial, 'Graphics/Objects/vial_empty.png', 128, 128)
			vialFg.xScale, vialFg.yScale = 0.25, 0.25
			vialFg.x, vialFg.y = 0, 0

			vial.bg, vial.fg = vialBg, vialFg
			vial.xScale, vial.yScale = (tile.xScale + tile.yScale), (tile.xScale + tile.yScale)
			vial.x, vial.y = tile.x, tile.y - vial.height*vial.yScale*0.5 + tile.height*tile.yScale*0.2
			vial.alpha = 0
			mapGroup:insert(vial)
			tile.vial = vial

			local fontSize = (canvasW/width)*0.25
			if fontSize > _W/16 then
				fontSize = _W/16
			end

			local startSign = drawBlob(1, 1)
			startSign.x, startSign.y = tile.x, tile.y
			startSign.xScale, startSign.yScale = tile.xScale*0.9, tile.yScale*0.8
			startSign.alpha = 0
			tile.startSign = startSign
			mapGroup:insert(startSign)

			local goalSign = display.newImageRect(mapGroup, 'Graphics/Objects/gate_01.png', 128, 128)
			goalSign.x, goalSign.y = tile.x, tile.y
			goalSign.xScale, goalSign.yScale = tile.xScale, tile.yScale
			goalSign.alpha = 0
			tile.goalSign = goalSign

			if arrowEnabled then
				local sheetData = {width = 128, height = 128, numFrames = 4, sheetContentWidth = 512, sheetContentHeight = 128}
				local sheet = graphics.newImageSheet('Graphics/Objects/arrow_sprite.png', sheetData)
				local sequenceData = {
					{name = 'loop', start = 1, count = 4, time = 700, loopCount = 0},
				}

				local arrowSign = display.newSprite(mapGroup, sheet, sequenceData)
				arrowSign:play()

				--arrowSign = display.newImageRect(mapGroup, 'Graphics/Objects/arrow_sprite.png', 128, 128)
				arrowSign.x, arrowSign.y = tile.x, tile.y
				arrowSign.xScale, arrowSign.yScale = tile.xScale, tile.yScale
				arrowSign.alpha = 0
				tile.arrowSign = arrowSign
			end

			local goalColor = display.newImageRect(mapGroup, 'Graphics/Objects/gate_color.png', 128, 128)
			goalColor.x, goalColor.y = tile.x, tile.y
			goalColor.xScale, goalColor.yScale = tile.xScale, tile.yScale
			goalColor.alpha = 0
			tile.goalColor = goalColor

			--tile:setFillColor(unpack(colors[1]))
			tile.color = colors[1]
			tile.colorList = {0,0,0}
			tile:addEventListener('touch', onChangeTile)

			grid[i][j] = tile
			flatGrid[j*width+i - width] = tile
		end
	end

	return grid
end

local function onColor(e)
	aud.play(sounds.click)

	currentColor = e.target.color
	currentValue = e.target.value
	--indicatorColor:setFillColor(unpack(currentColor))

	for k,v in pairs(selectionColors) do
		v.glow.alpha = 0
	end

	e.target.glow.alpha = 1

	if mixedColor then
		indicatorColor.alpha = 1
		indicatorColor:setFillColor(unpack(mixedColor))
	end
end

local function createColors()
	display.remove(colorGroup)
	colorGroup = display.newGroup()
	sceneView:insert(colorGroup)

	currentColor = colors[1]

	local pSize = {x = 1536, y = 306}

	if compact == '_compact' then
		pSize = {x = 640, y = 306}
	end

	local bg = display.newImageRect(colorGroup, 'Graphics/UI/editor_panel' .. compact .. '.png', pSize.x, pSize.y)
	bg.xScale, bg.yScale = canvasW / bg.width, canvasW / bg.width
	bg.x, bg.y = bg.width*bg.xScale*0.5, _H - bg.height*bg.yScale*0.5

	local mrSize = {x = 240, y = 356}
	local mrScale = 0.205

	local indicatorSize 	= {x = _W*0.032, y = notCanvasH*0.5}
	local redPosition 		= {x = _W*0.043, y = _H*0.948}
	local greenPosition 	= {x = _W*0.082, y = _H*0.948}
	local bluePosition 		= {x = _W*0.12, y = _H*0.948}

	if compact == '_compact' then
		mrSize = {x = 180, y = 320}
		mrScale = 0.5
		indicatorSize 	= {x = _W*0.065, y = notCanvasH*0.95}
		redPosition 	= {x = _W*0.0445, y = _H - 70}
		greenPosition 	= {x = _W*0.125, y = _H - 70}
		bluePosition 	= {x = _W*0.205, y = _H - 70}
	end

	indicatorColor = display.newImageRect(colorGroup, 'Graphics/UI/mixer_result' .. compact .. '.png', mrSize.x, mrSize.y)
	indicatorColor.xScale, indicatorColor.yScale = mrScale, mrScale
	indicatorColor.x, indicatorColor.y = indicatorColor.width*indicatorColor.xScale*0.5, _H - indicatorColor.height*indicatorColor.yScale*0.5
	--indicatorColor:setFillColor(unpack(colors[1]))
	indicatorColor.alpha = 0

	indicatorRed = display.newRect(colorGroup, 0, 0, indicatorSize.x, indicatorSize.y)
	indicatorRed.x, indicatorRed.y = redPosition.x, redPosition.y
	indicatorRed:setFillColor(255,0,0)
	indicatorRed.alpha = 0
	indicatorRed.originX, indicatorRed.originY = indicatorRed.x, indicatorRed.y

	indicatorGreen = display.newRect(colorGroup, 0, 0, indicatorSize.x, indicatorSize.y)
	indicatorGreen.x, indicatorGreen.y = greenPosition.x, greenPosition.y
	indicatorGreen:setFillColor(0,255,0)
	indicatorGreen.alpha = 0
	indicatorGreen.originX, indicatorGreen.originY = indicatorGreen.x, indicatorGreen.y

	indicatorBlue = display.newRect(colorGroup, 0, 0, indicatorSize.x, indicatorSize.y)
	indicatorBlue.x, indicatorBlue.y = bluePosition.x, bluePosition.y
	indicatorBlue:setFillColor(0,0,255)
	indicatorBlue.alpha = 0
	indicatorBlue.originX, indicatorBlue.originY = indicatorBlue.x, indicatorBlue.y

	startIndicator = display.newText(colorGroup, 'Start', 0, 0, systemfont, _G.smallFontSize)
	startIndicator.x, startIndicator.y = indicatorColor.x, indicatorColor.y
	startIndicator:setTextColor(64, 64, 64)
	startIndicator.alpha = 0
	startIndicator.isVisible = false

	goalIndicator = display.newText(colorGroup, 'Goal', 0, 0, systemfont, _G.smallFontSize)
	goalIndicator.x, goalIndicator.y = indicatorColor.x, indicatorColor.y
	goalIndicator:setTextColor(64, 64, 64)
	goalIndicator.alpha = 0
	goalIndicator.isVisible = false

	if arrowEnabled then
		arrowIndicator = display.newText(colorGroup, 'Arrow', 0, 0, systemfont, _G.smallFontSize)
		arrowIndicator.x, arrowIndicator.y = indicatorColor.x, indicatorColor.y
		arrowIndicator:setTextColor(64, 64, 64)
		arrowIndicator.alpha = 0
		arrowIndicator.isVisible = false
	end

	local mSize = {x = 240, y = 356}
	local mScale = 0.205

	if compact == '_compact' then
		mSize = {x = 180, y = 320}
		mScale = 0.5
	end

	local mixer = display.newImageRect(colorGroup, 'Graphics/UI/mixer' .. compact .. '.png', mSize.x, mSize.y)
	mixer.xScale, mixer.yScale = mScale, mScale
	mixer.x, mixer.y = mixer.width*mixer.xScale*0.5, _H - mixer.height*mixer.yScale*0.5

	local xPos = _W*0.1715
	local colorWidth = 0
	selectionColors = {}

	local glowOffset = {37,37,37,37,37,37,37,37}
	local cScale = {x = 0.22, y = 0.5}
	local positionList = {
		{x = _W*0.208, y = _H*0.958},
		{x = _W*0.272, y = _H*0.958},
		{x = _W*0.337, y = _H*0.958},
		{x = _W*0.400, y = _H*0.958},
		{x = _W*0.465, y = _H*0.958},
		{x = _W*0.529, y = _H*0.958},
		{x = _W*0.593, y = _H*0.958},
		{x = _W*0.658, y = _H*0.958}
	}

	if model == 'iPhone' then
		glowOffset = {45, 96, 96, 96, 96, 45, 45, 45}
		cScale = {x = 0.45, y = 0.5}
		positionList = {
			{x = _W*0.735, y = _H*0.95},
			{x = _W*0.735, y = _H*0.85},
			{x = _W*0.355, y = _H*0.85},
			{x = _W*0.482, y = _H*0.85},
			{x = _W*0.608, y = _H*0.85},
			{x = _W*0.355, y = _H*0.95},
			{x = _W*0.482, y = _H*0.95},
			{x = _W*0.608, y = _H*0.95}
		}
	end

	for i = 1, #colors do
		local color = display.newImageRect(colorGroup, 'Graphics/UI/btn_white.png', 88, 88)
		color.xScale, color.yScale = cScale.x, cScale.y
		color.alpha = 0.01
		color.x, color.y = positionList[i].x, positionList[i].y
		color:setFillColor(unpack(colors[i]))
		color:addEventListener('tap', onColor)
		color.color = colors[i]

		local cgSize = {x = 102, y = 83}
		local cgScale = 0.25

		if compact == '_compact' then
			cgSize = {x = 85, y = 73}
			cgScale = 0.55
		end

		local colorGlow = display.newImageRect(colorGroup, 'Graphics/UI/indicator_glow' .. compact .. '.png', cgSize.x, cgSize.y)
		colorGlow.xScale, colorGlow.yScale = cgScale, cgScale
		colorGlow.x, colorGlow.y = color.x, _H - glowOffset[i]
		colorGlow.alpha = 0

		color.glow = colorGlow

		if i < 3 then
			color.value = i-1
		else
			color.value = i
		end

		xPos = xPos + color.width*color.xScale + 1.2
		colorWidth = color.width

		table.insert(selectionColors, color)
	end

	--

	local function onSizeTap(e)
		e.target.alpha = 1
		aud.play(sounds.click)

		if e.target.up then
			if e.target.w then
				wText.text = tonumber(wText.text) + 1
			else
				hText.text = tonumber(hText.text) + 1
			end
		else
			if e.target.w then
				wText.text = tonumber(wText.text) - 1
			else
				hText.text = tonumber(hText.text) - 1
			end
		end

		if tonumber(wText.text) < 2 then wText.text = 2 end
		if tonumber(hText.text) < 2 then hText.text = 2 end

		if tonumber(wText.text) > 12 then wText.text = 12 end
		if tonumber(hText.text) > 12 then hText.text = 12 end
	end

	local function onCreateNewMap()
		grid = createMap(tonumber(wText.text), tonumber(hText.text))
	end

	local function cloneMap(file)
		local newFile = tenflib.jsonLoad('levels/' .. file.name)
		loadedName = newFile.Name
		loadedTime = newFile.Time
		loadedSteps = newFile.Steps
		loadedMaxColors = newFile.MarkerColorMaxSegments

		typedName, typedColNum, typedTime, typedSteps, typedFalling = nil, nil, nil, nil, nil

		grid = createMap(tonumber(newFile.Size.x), tonumber(newFile.Size.y))

		for i = 1, #newFile.Tile do
			flatGrid[i].alpha = 1

			if newFile.Tile[i] == 0 or newFile.Tile[i] == 1 then
				if newFile.Tile[i] == 0 then
					flatGrid[i].alpha = 0.01
				end

				flatGrid[i].vial.alpha = 0
			else
				flatGrid[i].vial.alpha = 1
			end

			if newFile.Tile[i] == 0 or newFile.Tile[i] == 1 then
				flatGrid[i].color = colors[newFile.Tile[i] + 1]
				flatGrid[i].vial.bg:setFillColor(unpack(flatGrid[i].color))
			elseif newFile.Tile[i] == 2 then
				flatGrid[i].color = {newFile.GoalColor.r, newFile.GoalColor.g, newFile.GoalColor.b}
				flatGrid[i].goalSign.alpha = 1
				flatGrid[i].goalColor.alpha = 1
				flatGrid[i].goalColor:setFillColor(unpack(flatGrid[i].color))
				indicatorColor:setFillColor(unpack(flatGrid[i].color))
				indicatorColor.alpha = 1
				flatGrid[i].vial.bg:setFillColor(unpack(flatGrid[i].color))

				local sendColor = {}

				for j = 1, 3 do
					if flatGrid[i].color[j] <= 32 then
						sendColor[j] = 0
					elseif flatGrid[i].color[j] <= 96 then
						sendColor[j] = 1
					elseif flatGrid[i].color[j] <= 164 then
						sendColor[j] = 2
					elseif flatGrid[i].color[j] <= 215 then
						sendColor[j] = 3
					else
						sendColor[j] = 4
					end
				end

				showTubeColors(sendColor)

				goalColor = flatGrid[i].color
			elseif newFile.Tile[i] == 10 then
				if arrowEnabled then
					flatGrid[i].color = colors[1]
					flatGrid[i].arrowSign.alpha = 1
					flatGrid[i].arrowSign.rotation = 0
				else
					flatGrid[i].vial.alpha = 0
				end
			elseif newFile.Tile[i] == 11 then
				if arrowEnabled then
					flatGrid[i].color = colors[1]
					flatGrid[i].arrowSign.alpha = 1
					flatGrid[i].arrowSign.rotation = 90
				else
					flatGrid[i].vial.alpha = 0
				end
			elseif newFile.Tile[i] == 12 then
				if arrowEnabled then
					flatGrid[i].color = colors[1]
					flatGrid[i].arrowSign.alpha = 1
					flatGrid[i].arrowSign.rotation = 180
				else
					flatGrid[i].vial.alpha = 0
				end
			elseif newFile.Tile[i] == 13 then
				if arrowEnabled then
					flatGrid[i].color = colors[1]
					flatGrid[i].arrowSign.alpha = 1
					flatGrid[i].arrowSign.rotation = 270
				else
					flatGrid[i].vial.alpha = 0
				end
			else
				flatGrid[i].color = colors[newFile.Tile[i]]
				flatGrid[i].vial.bg:setFillColor(unpack(flatGrid[i].color))
			end

			flatGrid[i].value = newFile.Tile[i]
		end

		grid[newFile.StartPos.x][newFile.StartPos.y].startSign.alpha = 1
	end

	xPos = xPos - colorWidth*0.39

	local function loadFilePopup()
		local files = getAllFiles()

		local loadFileGroup = display.newGroup()
		sceneView:insert(loadFileGroup)

		local function onBgTap(e)
			timer.performWithDelay(1, function()
				display.remove(loadFileGroup)
			end)

			return true
		end

		local function onBgTouch(e)
			return true
		end

		local bgRect = display.newRect(loadFileGroup, 0, 0, _W, _H)
		bgRect.x, bgRect.y = _W*0.5, _H*0.5
		bgRect.alpha = 0.5
		bgRect:setFillColor(0)
		bgRect:addEventListener('tap', onBgTap)
		bgRect:addEventListener('touch', onBgTouch)

		local function onFgTouch(e)
			return true
		end

		local fgScaleX, fgScaleY = 0.18, 0.2
		local buttonScale = 0.15
		local smallFSize = _G.smallFontSize
		local mediumSmallFSize = _G.mediumSmallFontSize
		local mediumFSize = _G.mediumFontSize

		if model == 'iPhone' then
			fgScaleX, fgScaleY = 0.25, 0.3
			buttonScale = 0.25
			smallFSize = _G.mediumSmallFontSize
			mediumSmallFSize = _G.mediumFontSize
			mediumFSize = _G.largeFontSize
		end

		local fgRect = display.newImageRect(loadFileGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
		fgRect.xScale, fgRect.yScale = fgScaleX, fgScaleY
		fgRect.x, fgRect.y = bgRect.x, bgRect.y
		fgRect:setFillColor(255,0,64)
		fgRect:addEventListener('tap', onFgTouch)
		fgRect:addEventListener('touch', onFgTouch)

		local headlineText = display.newText(loadFileGroup, 'Load level', 0, 0, systemfont, mediumSmallFSize)
		headlineText.x, headlineText.y = fgRect.x, fgRect.y - fgRect.height*fgRect.yScale*0.4

		local function onDone(e)
			aud.play(sounds.click)

			if currentFile then
				cloneMap(currentFile)
			else
				native.showAlert('Warning!', 'No file is selected.', {'Ok'})
			end

			display.remove(loadFileGroup)
			currentFile = nil
		end

		local function onFileTap(e)
			aud.play(sounds.click)

			currentFile = e.target

			for k,v in pairs(e.target.group.subGroups) do
				v.bg.theBg:setFillColor(255)
			end

			currentFile.bg.theBg:setFillColor(0,0,255)
		end

		local function fadeGroups(e)
			for i = 1, #e.target.subGroups do
				if (e.target.subGroups[i].y + e.target.y) <= e.target.originalTop + e.target.subGroups[i].height*0.5 then
					local newAlpha = (((e.target.subGroups[i].y + e.target.y) - e.target.originalTop) / e.target.subGroups[i].height)

					if newAlpha < 0 then newAlpha = 0 end

					 e.target.subGroups[i].alpha = newAlpha
				elseif (e.target.subGroups[i].y + e.target.y) >= e.target.originalBottom - e.target.subGroups[i].height*0.5 then
					local newAlpha = ((e.target.originalBottom - (e.target.subGroups[i].y + e.target.y)) / e.target.subGroups[i].height)

					if newAlpha < 0 then newAlpha = 0 end

					 e.target.subGroups[i].alpha = newAlpha

				else
					 e.target.subGroups[i].alpha = 1
				end
			end
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
						fadeGroups(e)
					end})

					e.target.originTouchY = 0
					display.getCurrentStage():setFocus(nil)
					e.target.swiping = false
				end

				fadeGroups(e)
			end
		end

		local filesGroup = display.newGroup()
		filesGroup.subGroups = {}

		for i = 1, #files do
			local tmpGroup = display.newGroup()
			local vi = files[i]

			local bg = display.newGroup()

			local bgbg = display.newImageRect(bg, 'Graphics/Menu/large_btn_fill.png', 768, 190)
			bgbg.xScale, bgbg.yScale = buttonScale, buttonScale
			bgbg.x, bgbg.y = 0, 0

			local bgfg = display.newImageRect(bg, 'Graphics/Menu/large_btn_texture.png', 768, 190)
			bgfg.xScale, bgfg.yScale = buttonScale, buttonScale
			bgfg.x, bgfg.y = 0, 0

			bg.x, bg.y = 0, 0
			bg.theBg = bgbg
			bg.fg = bgfg
			tmpGroup:insert(bg)

			if i == 1 then
				bg.theBg:setFillColor(0,0,255)
			end

			local fg = display.newText(tmpGroup, vi, 0, 0, systemfont, smallFSize)
			fg.x, fg.y = bg.x, bg.y

			tmpGroup.x, tmpGroup.y = 0, i*(bg.height*bg.yScale+4) - bg.height*bg.yScale*0.5 - 2
			tmpGroup.name = vi
			tmpGroup:addEventListener('tap', onFileTap)
			tmpGroup.bg = bg
			tmpGroup.fg = fg
			tmpGroup.isSomeKindOfGroup = true
			tmpGroup.group = filesGroup
			filesGroup.subGroups[#filesGroup.subGroups+1] = tmpGroup
			filesGroup:insert(tmpGroup)
		end

		currentFile = filesGroup.subGroups[1]

		filesGroup.x, filesGroup.y = fgRect.x, fgRect.y - fgRect.height*0.025
		filesGroup.originalTop, filesGroup.originalBottom = fgRect.y - fgRect.height*fgRect.yScale*0.22, fgRect.y + fgRect.height*fgRect.yScale*0.22
		filesGroup:addEventListener('touch', onScroll)
		onScroll({target = filesGroup, phase = 'ended'})

		local superGroup = display.newGroup()
		superGroup:insert(filesGroup)

		-- local mask = graphics.newMask('pics/normalMask.png')
		-- superGroup:setMask(mask)
		-- superGroup.maskX, superGroup.maskY = fgRect.x, fgRect.y - fgRect.height*0.025
		-- superGroup.maskScaleX, superGroup.maskScaleY = 1, 0.45

		loadFileGroup:insert(superGroup)

		local cancelButton = {}--display.newGroup()

		local cancelBg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		cancelBg.path = 'Graphics/Menu/small_btn_fill.png'
		cancelBg.width = 384
		cancelBg.height = 190
		cancelBg.xScale, cancelBg.yScale = buttonScale, buttonScale
		cancelBg.x, cancelBg.y = 0, 0
		cancelBg.color = _G.continueColor

		local cancelFg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		cancelFg.path = 'Graphics/Menu/small_btn_texture.png'
		cancelFg.width = 384
		cancelFg.height = 190
		cancelFg.xScale, cancelFg.yScale = buttonScale, buttonScale
		cancelFg.x, cancelFg.y = 0, 0

		local cancelText = {}--display.newText(loadFileGroup, 'Cancel', 0, 0, systemfont, smallFSize)
		cancelText.text = 'Cancel'
		cancelText.font = systemfont
		cancelText.fontSize = smallFSize

		cancelButton.x, cancelButton.y = fgRect.x - fgRect.width*fgRect.xScale*0.45 + cancelBg.width*cancelBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.45 - cancelBg.height*cancelBg.yScale*0.5
		cancelButton.bg = cancelBg
		cancelButton.fg = cancelFg
		cancelButton.text = cancelText
		cancelButton.onEnded = onBgTap

		cancelButton = createButton(cancelButton)

		loadFileGroup:insert(cancelButton)

		local doneButton = {}--display.newGroup()

		local doneBg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		doneBg.path = 'Graphics/Menu/small_btn_fill.png'
		doneBg.width = 384
		doneBg.height = 190
		doneBg.x, doneBg.y = 0, 0
		doneBg.xScale, doneBg.yScale = buttonScale, buttonScale
		doneBg.color = _G.playColor

		local doneFg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		doneFg.path = 'Graphics/Menu/small_btn_texture.png'
		doneFg.width = 384
		doneFg.height = 190
		doneFg.xScale, doneFg.yScale = buttonScale, buttonScale
		doneFg.x, doneFg.y = 0, 0

		local doneText = {}--display.newText(loadFileGroup, 'Load', 0, 0, systemfont, smallFSize)
		doneText.text = 'Load'
		doneText.font = systemfont
		doneText.fontSize = smallFSize

		doneButton.x, doneButton.y = fgRect.x + fgRect.width*fgRect.xScale*0.45 - doneBg.width*doneBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.45 - doneBg.height*doneBg.yScale*0.5
		doneButton.bg = doneBg
		doneButton.fg = doneFg
		doneButton.text = doneText
		doneButton.onEnded = onDone

		doneButton = createButton(doneButton)

		loadFileGroup:insert(doneButton)
	end

	local function onNewTap(e)
		local newMapGroup = display.newGroup()
		sceneView:insert(newMapGroup)

		local function onBgTap(e)
			timer.performWithDelay(1, function()
				display.remove(newMapGroup)
			end)

			return true
		end

		local function onBgTouch(e)
			return true
		end

		local bgRect = display.newRect(newMapGroup, 0, 0, _W, _H)
		bgRect.x, bgRect.y = _W*0.5, _H*0.5
		bgRect.alpha = 0.5
		bgRect:setFillColor(0)
		bgRect:addEventListener('tap', onBgTap)
		bgRect:addEventListener('touch', onBgTouch)

		local function onFgTouch(e)
			return true
		end

		local fgScaleX, fgScaleY = 0.18, 0.2
		local buttonScale = 0.1
		local smallFSize = _G.smallFontSize
		local mediumSmallFSize = _G.mediumSmallFontSize
		local mediumFSize = _G.mediumFontSize

		if model == 'iPhone' then
			fgScaleX, fgScaleY = 0.25, 0.3
			buttonScale = 0.2
			smallFSize = _G.mediumSmallFontSize
			mediumSmallFSize = _G.mediumFontSize
			mediumFSize = _G.largeFontSize
		end

		local fgRect = display.newImageRect(newMapGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
		fgRect.xScale, fgRect.yScale = fgScaleX, fgScaleY
		fgRect.x, fgRect.y = bgRect.x, bgRect.y
		fgRect:setFillColor(255,0,64)
		fgRect:addEventListener('tap', onFgTouch)
		fgRect:addEventListener('touch', onFgTouch)

		local headlineText = display.newText(newMapGroup, 'New level', 0, 0, systemfont, mediumFSize)
		headlineText.x, headlineText.y = fgRect.x, fgRect.y - fgRect.height*fgRect.yScale*0.4

		local widthText = display.newText(newMapGroup, 'Width', 0, 0, systemfont, mediumSmallFSize)
		widthText.x, widthText.y = fgRect.x - fgRect.width*fgRect.xScale*0.25, fgRect.y - fgRect.height*fgRect.yScale*0.25

		local heightText = display.newText(newMapGroup, 'Height', 0, 0, systemfont, mediumSmallFSize)
		heightText.x, heightText.y = fgRect.x + fgRect.width*fgRect.xScale*0.25, fgRect.y - fgRect.height*fgRect.yScale*0.25

		local wUp = {}

		local wUpBg = {}--display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		wUpBg.path = 'Graphics/Menu/small_btn_texture.png'
		wUpBg.width = 384
		wUpBg.height = 190
		wUpBg.xScale, wUpBg.yScale = buttonScale, buttonScale

		wUpText = {}--display.newText(newMapGroup, '^', 0, 0, systemfont, smallFSize)
		wUpText.text = '^'
		wUpText.font = systemfont
		wUpText.fontSize = smallFSize

		wUp.x, wUp.y = fgRect.x - fgRect.width*fgRect.xScale*0.25, fgRect.y - fgRect.height*fgRect.yScale*0.1
		wUp.bg = wUpBg
		wUp.text = wUpText
		wUp.onEnded = onSizeTap
		wUp.buttonParams = {
			up = true,
			w = true
		}

		wUp = createButton(wUp)
		newMapGroup:insert(wUp)

		--

		-- local wDown = display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		-- wDown.xScale, wDown.yScale = buttonScale, buttonScale
		-- wDown.x, wDown.y = fgRect.x - fgRect.width*fgRect.xScale*0.25, fgRect.y + fgRect.height*fgRect.yScale*0.1
		-- wDown.up = false
		-- wDown.w = true
		-- wDown:addEventListener('tap', onSizeTap)

		-- wDownText = display.newText(newMapGroup, 'v', 0, 0, systemfont, smallFSize)
		-- wDownText.x, wDownText.y = wDown.x, wDown.y

		local wDown = {}

		local wDownBg = {}--display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		wDownBg.path = 'Graphics/Menu/small_btn_texture.png'
		wDownBg.width = 384
		wDownBg.height = 190
		wDownBg.xScale, wDownBg.yScale = buttonScale, buttonScale

		wDownText = {}--display.newText(newMapGroup, '^', 0, 0, systemfont, smallFSize)
		wDownText.text = 'v'
		wDownText.font = systemfont
		wDownText.fontSize = smallFSize

		wDown.x, wDown.y = fgRect.x - fgRect.width*fgRect.xScale*0.25, fgRect.y + fgRect.height*fgRect.yScale*0.1
		wDown.bg = wDownBg
		wDown.text = wDownText
		wDown.onEnded = onSizeTap
		wDown.buttonParams = {
			up = false,
			w = true
		}

		wDown = createButton(wDown)
		newMapGroup:insert(wDown)

		--

		wText = display.newText(newMapGroup, '7', 0, 0, systemfont, smallFSize)
		wText.x, wText.y = wUp.x, (wUp.y + wDown.y)/2

		--

		-- local hUp = display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		-- hUp.xScale, hUp.yScale = buttonScale, buttonScale
		-- hUp.x, hUp.y = fgRect.x + fgRect.width*fgRect.xScale*0.25, fgRect.y - fgRect.height*fgRect.yScale*0.1
		-- hUp.up = true
		-- hUp.w = false
		-- hUp:addEventListener('tap', onSizeTap)

		-- hUpText = display.newText(newMapGroup, '^', 0, 0, systemfont, smallFSize)
		-- hUpText.x, hUpText.y = hUp.x, hUp.y

		--

		local hUp = {}

		local hUpBg = {}--display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		hUpBg.path = 'Graphics/Menu/small_btn_texture.png'
		hUpBg.width = 384
		hUpBg.height = 190
		hUpBg.xScale, hUpBg.yScale = buttonScale, buttonScale

		hUpText = {}--display.newText(newMapGroup, '^', 0, 0, systemfont, smallFSize)
		hUpText.text = '^'
		hUpText.font = systemfont
		hUpText.fontSize = smallFSize

		hUp.x, hUp.y = fgRect.x + fgRect.width*fgRect.xScale*0.25, fgRect.y - fgRect.height*fgRect.yScale*0.1
		hUp.bg = hUpBg
		hUp.text = hUpText
		hUp.onEnded = onSizeTap
		hUp.buttonParams = {
			up = true,
			w = false
		}

		hUp = createButton(hUp)
		newMapGroup:insert(hUp)

		--

		-- local hDown = display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		-- hDown.xScale, hDown.yScale = buttonScale, buttonScale
		-- hDown.x, hDown.y = fgRect.x + fgRect.width*fgRect.xScale*0.25, fgRect.y + fgRect.height*fgRect.yScale*0.1
		-- hDown.up = false
		-- hDown.w = false
		-- hDown:addEventListener('tap', onSizeTap)

		-- hDownText = display.newText(newMapGroup, 'v', 0, 0, systemfont, smallFSize)
		-- hDownText.x, hDownText.y = hDown.x, hDown.y

		--

		local hDown = {}

		local hDownBg = {}--display.newImageRect(newMapGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		hDownBg.path = 'Graphics/Menu/small_btn_texture.png'
		hDownBg.width = 384
		hDownBg.height = 190
		hDownBg.xScale, hDownBg.yScale = buttonScale, buttonScale

		hDownText = {}--display.newText(newMapGroup, '^', 0, 0, systemfont, smallFSize)
		hDownText.text = 'v'
		hDownText.font = systemfont
		hDownText.fontSize = smallFSize

		hDown.x, hDown.y = fgRect.x + fgRect.width*fgRect.xScale*0.25, fgRect.y + fgRect.height*fgRect.yScale*0.1
		hDown.bg = hDownBg
		hDown.text = hDownText
		hDown.onEnded = onSizeTap
		hDown.buttonParams = {
			up = false,
			w = false
		}

		hDown = createButton(hDown)
		newMapGroup:insert(hDown)

		--

		hText = display.newText(newMapGroup, '7', 0, 0, systemfont, smallFSize)
		hText.x, hText.y = hUp.x, (hUp.y + hDown.y)/2

		local function onDone(e)
			aud.play(sounds.click)

			indicatorColor.alpha = 0
			loadedName, loadedTime, loadedSteps, loadedMaxColors = nil, nil, nil, nil
			typedName, typedColNum, typedTime, typedSteps, typedFalling = nil, nil, nil, nil, nil
			display.remove(newMapGroup)
			onCreateNewMap()
		end

		local cancelButton = {}--display.newGroup()

		local cancelBg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		cancelBg.path = 'Graphics/Menu/small_btn_fill.png'
		cancelBg.width = 384
		cancelBg.height = 190
		cancelBg.xScale, cancelBg.yScale = buttonScale, buttonScale
		cancelBg.x, cancelBg.y = 0, 0
		cancelBg.color = _G.continueColor

		local cancelFg = {}--display.newImageRect(cancelButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		cancelFg.path = 'Graphics/Menu/small_btn_texture.png'
		cancelFg.width = 384
		cancelFg.height = 190
		cancelFg.xScale, cancelFg.yScale = buttonScale, buttonScale
		cancelFg.x, cancelFg.y = 0, 0

		local cancelText = {}--display.newText(newMapGroup, 'Cancel', 0, 0, systemfont, smallFSize)
		cancelText.text = 'Cancel'
		cancelText.font = systemfont
		cancelText.fontSize = smallFSize

		cancelButton.x, cancelButton.y = fgRect.x - fgRect.width*fgRect.xScale*0.45 + cancelBg.width*cancelBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.45 - cancelBg.height*cancelBg.yScale*0.5
		cancelButton.onEnded = onBgTap

		cancelButton.bg = cancelBg
		cancelButton.fg = cancelFg
		cancelButton.text = cancelText

		cancelButton = createButton(cancelButton)

		newMapGroup:insert(cancelButton)

		--

		local doneButton = {}--display.newGroup()

		local doneBg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		doneBg.path = 'Graphics/Menu/small_btn_fill.png'
		doneBg.width = 384
		doneBg.height = 190
		doneBg.x, doneBg.y = 0, 0
		doneBg.xScale, doneBg.yScale = buttonScale, buttonScale
		doneBg.color = _G.playColor

		local doneFg = {}--display.newImageRect(doneButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		doneFg.path = 'Graphics/Menu/small_btn_texture.png'
		doneFg.width = 384
		doneFg.height = 190
		doneFg.xScale, doneFg.yScale = buttonScale, buttonScale
		doneFg.x, doneFg.y = 0, 0

		local doneText = {}--display.newText(newMapGroup, 'Create', 0, 0, systemfont, smallFSize)
		doneText.text = 'Create'
		doneText.font = systemfont
		doneText.fontSize = smallFSize

		doneButton.x, doneButton.y = fgRect.x + fgRect.width*fgRect.xScale*0.45 - doneBg.width*doneBg.xScale*0.5, fgRect.y + fgRect.height*fgRect.yScale*0.45 - doneBg.height*doneBg.yScale*0.5
		doneButton.onEnded = onDone

		doneButton.bg = doneBg
		doneButton.fg = doneFg
		doneButton.text = doneText

		doneButton = createButton(doneButton)

		newMapGroup:insert(doneButton)
	end

	local function onArrowTap(e)
		aud.play(sounds.click)

		goalIndicator.alpha = 0
		startIndicator.alpha = 0
		goalButton.alpha = 1
		startButton.alpha = 1

		arrowIndicator.alpha = (arrowIndicator.alpha + 1) % 2

		if arrowIndicator.alpha == 1 then
			arrowButton.alpha = 0.01
		else
			arrowButton.alpha = 1
		end
	end

	local function onStartTap(e)
		aud.play(sounds.click)

		goalIndicator.alpha = 0

		if arrowEnabled then
			arrowIndicator.alpha = 0
			arrowButton.alpha = 1
		end

		startIndicator.alpha = (startIndicator.alpha + 1) % 2
		goalButton.alpha = 1

		if startIndicator.alpha == 1 then
			startButton.alpha = 0.01
			for k,v in pairs(selectionColors) do
				v.glow.alpha = 0
			end

			selectionColors[2].glow.alpha = 1

			currentColor = colors[2]
			currentValue = 1
			--indicatorColor:setFillColor(unpack(currentColor))
		else
			startButton.alpha = 1
		end
	end

	local function onGoalTap(e)
		aud.play(sounds.click)

		startIndicator.alpha = 0

		if arrowEnabled then
			arrowIndicator.alpha = 0
			arrowButton.alpha = 1
		end

		goalIndicator.alpha = (goalIndicator.alpha + 1) % 2
		startButton.alpha = 1

		if goalIndicator.alpha == 0 then
			--indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 0, 0, 0
			--indicatorColor:setFillColor(unpack(currentColor))
			goalButton.alpha = 1
		else
			indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 1, 1, 1
			goalButton.alpha = 0.01
		end
	end

	xPos = _W*0.5

	local sScale = 0.21, 0.21
	local sPosition = {x = _W*0.735, y = _H*0.951}

	local gScale = 0.17
	local gPosition = {x = _W*0.81, y = _H*0.95}

	if compact == '_compact' then
		sScale = 0.42, 0.42
		sPosition = {x = _W*0.898, y = _H - 75}

		gScale = 0.32
		gPosition = {x = _W*0.898, y = _H - 27}
	end

	local startBg = drawBlob(sScale, sScale)

	startBg.x, startBg.y = sPosition.x, sPosition.y
	colorGroup:insert(startBg)

	startButton = display.newImageRect(colorGroup, 'pics/marker.png', 128, 128)
	startButton.xScale, startButton.yScale = sScale, sScale
	startButton.x, startButton.y = startBg.x, startBg.y
	startButton:addEventListener('tap', onStartTap)

	xPos = xPos + startButton.width*startButton.xScale

	local goalBg = display.newImageRect(colorGroup, 'Graphics/Objects/gate_08.png', 128, 128)
	goalBg.xScale, goalBg.yScale = gScale, gScale
	goalBg.x, goalBg.y = gPosition.x, gPosition.y

	goalButton = display.newImageRect(colorGroup, 'Graphics/Objects/gate_01.png', 128, 128)
	goalButton.xScale, goalButton.yScale = goalBg.xScale, goalBg.yScale
	goalButton.x, goalButton.y = goalBg.x, goalBg.y
	goalButton:addEventListener('tap', onGoalTap)

	--xPos = xPos + goalButton.width*goalButton.xScale

	if arrowEnabled then
		local arrowBg = display.newImageRect(colorGroup, 'Graphics/Objects/gate_08.png', 128, 128)
		arrowBg.xScale, arrowBg.yScale = gScale, gScale
		arrowBg.x, arrowBg.y = _W*0.222, _H*0.87

		arrowButton = display.newImageRect(colorGroup, 'Graphics/Objects/gate_01.png', 128, 128)
		arrowButton.xScale, arrowButton.yScale = arrowBg.xScale, arrowBg.yScale
		arrowButton.x, arrowButton.y = arrowBg.x, arrowBg.y
		arrowButton:addEventListener('tap', onArrowTap)
	end

	local mPosition = {x = _W*0.918, y = _H - 22}
	local mWidth = _W*0.14

	if compact == '_compact' then
		mPosition = {x = _W*0.126, y = _H - 22}
		mWidth = _W*0.2
	end

	local menuButton = display.newRoundedRect(colorGroup, 0, 0, mWidth, notCanvasH*0.75, notCanvasH*0.05)
	menuButton.x, menuButton.y = mPosition.x, mPosition.y
	menuButton:setFillColor(unpack(buttonColor))
	menuButton.alpha = .01

	local function gotoMainMenu()
		local loadingOverlay = display.newRect(sceneView, 0, 0, _W, _H)
		loadingOverlay.x, loadingOverlay.y = _W*0.5, _H*0.5
		loadingOverlay.alpha = 0.01

		local function onLoadingTouch(e)
			return true
		end

		loadingOverlay:addEventListener('touch', onLoadingTouch)
		loadingOverlay:addEventListener('tap', onLoadingTouch)


		transition.to(sceneView, {time = 400, alpha = 0, onComplete = function()
			composer.gotoScene("customMenu")
		end})
		--timer.performWithDelay(400, function() display.remove(mapGroup);display.remove(colorGroup);display.remove(grayBg) end)
	end

	local function theMenu()
		local menuGroup = display.newGroup()

		local function onBgTap(e)
			timer.performWithDelay(1, function()
				display.remove(menuGroup)
			end)

			return true
		end

		local function onBgTouch(e)
			return true
		end

		local bgRect = display.newRect(menuGroup, 0, 0, _W, _H)
		bgRect.x, bgRect.y = _W*0.5, _H*0.5
		bgRect.alpha = 0.5
		bgRect:setFillColor(0)
		bgRect:addEventListener('tap', onBgTap)
		bgRect:addEventListener('touch', onBgTouch)

		local function onFgTouch(e)
			return true
		end

		local fgScaleX, fgScaleY = 0.14, 0.18
		local buttonScale = 0.15
		local smallFSize = _G.smallFontSize
		local mediumFSize = _G.mediumFontSize

		if model == 'iPhone' then
			fgScaleX, fgScaleY = 0.3, 0.36
			buttonScale = 0.3
			smallFSize = _G.mediumLargeFontSize
			mediumFSize = _G.largeFontSize
		end

		local fgRect = display.newImageRect(menuGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
		fgRect.xScale, fgRect.yScale = fgScaleX, fgScaleY
		fgRect.x, fgRect.y = bgRect.x, bgRect.y
		fgRect:setFillColor(255,0,64)
		fgRect:addEventListener('tap', onFgTouch)
		fgRect:addEventListener('touch', onFgTouch)

		local headlineText = display.newText(menuGroup, 'Menu', 0, 0, systemfont, mediumFSize)
		headlineText.x, headlineText.y = fgRect.x, fgRect.y - fgRect.height*fgRect.yScale*0.4

		local function onClone(e)
			loadFilePopup()
			display.remove(newMapGroup)
		end

		local function onButtonPress(e)
			aud.play(sounds.click)

			display.remove(menuGroup)

			if e.target.whereTo == 'onNewTap' then
				onNewTap(e)
			elseif e.target.whereTo == 'saveMenu' then
				saveMenu(e)
			elseif e.target.whereTo == 'gotoMainMenu' then
				gotoMainMenu(e)
			elseif e.target.whereTo == 'onClone' then
				onClone(e)
			else
				onBgTap(e)
			end
		end

		local newButton = {}--display.newGroup()

		local newBg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		newBg.path = 'Graphics/Menu/large_btn_fill.png'
		newBg.width = 768
		newBg.height = 190
		newBg.x, newBg.y = 0, 0
		newBg.xScale, newBg.yScale = buttonScale, buttonScale
		newBg.color = _G.levelSelectColor

		local newFg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		newFg.path = 'Graphics/Menu/large_btn_texture.png'
		newFg.width = 768
		newFg.height = 190
		newFg.xScale, newFg.yScale = buttonScale, buttonScale
		newFg.x, newFg.y = 0, 0

		local newText = {}--display.newText(menuGroup, 'New', 0, 0, systemfont,smallFSize)
		newText.text = 'New'
		newText.font = systemfont
		newText.fontSize = smallFSize

		newButton.x, newButton.y = fgRect.x, headlineText.y + headlineText.height*0.5 + newBg.height*newBg.yScale*0.6
		newButton.buttonParams = {whereTo = 'onNewTap'}
		newButton.bg = newBg
		newButton.fg = newFg
		newButton.text = newText
		newButton.onEnded = onButtonPress

		newButton = createButton(newButton)

		menuGroup:insert(newButton)

		--

		-- local cloneButton = display.newGroup()

		-- local cloneBg = display.newImageRect(cloneButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		-- cloneBg.x, cloneBg.y = 0, 0
		-- cloneBg:setFillColor(unpack(_G.replayColor))

		-- local cloneFg = display.newImageRect(cloneButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		-- cloneFg.x, cloneFg.y = 0, 0

		-- cloneButton.xScale, cloneButton.yScale = buttonScale, buttonScale
		-- cloneButton.x, cloneButton.y = fgRect.x, newButton.y + newButton.height*newButton.yScale*1.2
		-- cloneButton.whereTo = 'onClone'
		-- cloneButton:addEventListener('tap', onButtonPress)

		-- menuGroup:insert(cloneButton)

		-- local cloneText = display.newText(menuGroup, 'Load', 0, 0, systemfont, smallFSize)
		-- cloneText.x, cloneText.y = cloneButton.x, cloneButton.y

		--

		local cloneButton = {}--display.newGroup()

		local cloneBg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		cloneBg.path = 'Graphics/Menu/large_btn_fill.png'
		cloneBg.width = 768
		cloneBg.height = 190
		cloneBg.x, cloneBg.y = 0, 0
		cloneBg.xScale, cloneBg.yScale = buttonScale, buttonScale
		cloneBg.color = _G.replayColor

		local cloneFg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		cloneFg.path = 'Graphics/Menu/large_btn_texture.png'
		cloneFg.width = 768
		cloneFg.height = 190
		cloneFg.xScale, cloneFg.yScale = buttonScale, buttonScale
		cloneFg.x, newFg.y = 0, 0

		local cloneText = {}--display.newText(menuGroup, 'New', 0, 0, systemfont,smallFSize)
		cloneText.text = 'Load'
		cloneText.font = systemfont
		cloneText.fontSize = smallFSize

		cloneButton.x, cloneButton.y = fgRect.x, newButton.y + newButton.height*newButton.yScale*1.2
		cloneButton.buttonParams = {whereTo = 'onClone'}
		cloneButton.bg = cloneBg
		cloneButton.fg = cloneFg
		cloneButton.text = cloneText
		cloneButton.onEnded = onButtonPress

		cloneButton = createButton(cloneButton)

		menuGroup:insert(cloneButton)

		--

		-- local saveButton = display.newGroup()

		-- local saveBg = display.newImageRect(saveButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		-- saveBg.x, saveBg.y = 0, 0
		-- saveBg:setFillColor(unpack(_G.replayColor))

		-- local saveFg = display.newImageRect(saveButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		-- saveFg.x, saveFg.y = 0, 0

		-- saveButton.xScale, saveButton.yScale = buttonScale, buttonScale
		-- saveButton.x, saveButton.y = fgRect.x, cloneButton.y + cloneButton.height*cloneButton.yScale*1.2
		-- saveButton.whereTo = 'saveMenu'
		-- saveButton:addEventListener('tap', onButtonPress)

		-- menuGroup:insert(saveButton)

		-- local saveText = display.newText(menuGroup, 'Save', 0, 0, systemfont, smallFSize)
		-- saveText.x, saveText.y = saveButton.x, saveButton.y

		--

		local saveButton = {}--display.newGroup()

		local saveBg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		saveBg.path = 'Graphics/Menu/large_btn_fill.png'
		saveBg.width = 768
		saveBg.height = 190
		saveBg.x, saveBg.y = 0, 0
		saveBg.xScale, saveBg.yScale = buttonScale, buttonScale
		saveBg.color = _G.replayColor

		local saveFg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		saveFg.path = 'Graphics/Menu/large_btn_texture.png'
		saveFg.width = 768
		saveFg.height = 190
		saveFg.xScale, saveFg.yScale = buttonScale, buttonScale
		saveFg.x, newFg.y = 0, 0

		local saveText = {}--display.newText(menuGroup, 'New', 0, 0, systemfont,smallFSize)
		saveText.text = 'Save'
		saveText.font = systemfont
		saveText.fontSize = smallFSize

		saveButton.x, saveButton.y = fgRect.x, cloneButton.y + cloneButton.height*cloneButton.yScale*1.2
		saveButton.buttonParams = {whereTo = 'saveMenu'}
		saveButton.bg = saveBg
		saveButton.fg = saveFg
		saveButton.text = saveText
		saveButton.onEnded = onButtonPress

		saveButton = createButton(saveButton)

		menuGroup:insert(saveButton)

		--

		-- local exitButton = display.newGroup()

		-- local exitBg = display.newImageRect(exitButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		-- exitBg.x, exitBg.y = 0, 0
		-- exitBg:setFillColor(unpack(_G.mainMenuColor))

		-- local exitFg = display.newImageRect(exitButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		-- exitFg.x, exitFg.y = 0, 0

		-- exitButton.xScale, exitButton.yScale = buttonScale, buttonScale
		-- exitButton.x, exitButton.y = fgRect.x, saveButton.y + saveButton.height*saveButton.yScale*1.2
		-- exitButton.whereTo = 'gotoMainMenu'
		-- exitButton:addEventListener('tap', onButtonPress)

		-- menuGroup:insert(exitButton)

		-- local exitText = display.newText(menuGroup, 'Menu', 0, 0, systemfont, smallFSize)
		-- exitText.x, exitText.y = exitButton.x, exitButton.y

		--

		local exitButton = {}--display.newGroup()

		local exitBg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		exitBg.path = 'Graphics/Menu/large_btn_fill.png'
		exitBg.width = 768
		exitBg.height = 190
		exitBg.x, exitBg.y = 0, 0
		exitBg.xScale, exitBg.yScale = buttonScale, buttonScale
		exitBg.color = _G.mainMenuColor

		local exitFg = {}--display.newImageRect(newButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		exitFg.path = 'Graphics/Menu/large_btn_texture.png'
		exitFg.width = 768
		exitFg.height = 190
		exitFg.xScale, exitFg.yScale = buttonScale, buttonScale
		exitFg.x, newFg.y = 0, 0

		local exitText = {}--display.newText(menuGroup, 'New', 0, 0, systemfont,smallFSize)
		exitText.text = 'Menu'
		exitText.font = systemfont
		exitText.fontSize = smallFSize

		exitButton.x, exitButton.y = fgRect.x, saveButton.y + saveButton.height*saveButton.yScale*1.2
		exitButton.buttonParams = {whereTo = 'gotoMainMenu'}
		exitButton.bg = exitBg
		exitButton.fg = exitFg
		exitButton.text = exitText
		exitButton.onEnded = onButtonPress

		exitButton = createButton(exitButton)

		menuGroup:insert(exitButton)

		-- local cancelButton = display.newGroup()

		-- local cancelBg = display.newImageRect(cancelButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
		-- cancelBg.x, cancelBg.y = 0, 0
		-- cancelBg:setFillColor(unpack(_G.continueColor))

		-- local cancelFg = display.newImageRect(cancelButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
		-- cancelFg.x, cancelFg.y = 0, 0

		-- cancelButton.xScale, cancelButton.yScale = buttonScale, buttonScale
		-- cancelButton.x, cancelButton.y = fgRect.x, exitButton.y + exitButton.height*exitButton.yScale*1.2
		-- cancelButton:addEventListener('tap', onBgTap)

		-- menuGroup:insert(cancelButton)

		-- local cancelText = display.newText(menuGroup, 'Close', 0, 0, systemfont, smallFSize)
		-- cancelText.x, cancelText.y = cancelButton.x, cancelButton.y
	end

	menuButton:addEventListener('tap', theMenu)

	menuText = display.newText(colorGroup, 'Menu', 0, 0, systemfont, _G.smallFontSize)
	menuText.x, menuText.y = menuButton.x, menuButton.y

	onNewTap()
end

currentColor = colors[1]
grid = createMap(7, 7)
createColors()

sceneView.alpha = 0
transition.to(sceneView, {time = 400, alpha = 1})

end

function scene:create(e)
local sceneView = self.view
end
function scene:hide(e)
local sceneView = self.view
end
function scene:destroy(e) end

scene:addEventListener('create', scene)
scene:addEventListener('show', scene)
scene:addEventListener('hide', scene)
scene:addEventListener('destroy', scene)

return scene

-- ╔════════════════╗ --
-- ║█▀▀▀▀▀▀▀▀▀▀▀▀▀▀█║ --
-- ║█              █║ --
-- ║█   The Game   █║ --
-- ║█              █║ --
-- ║█▄▄▄▄▄▄▄▄▄▄▄▄▄▄█║ --
-- ╚════════════════╝ --







