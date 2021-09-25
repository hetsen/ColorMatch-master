local storyboard = require 'storyboard'
local scene = storyboard.newScene()

local mapGroup
local colorGroup

function scene:enterScene(e)
	
display.setStatusBar(display.HiddenStatusBar)
local json = require 'json'

local _W, _H = display.contentWidth, display.contentHeight
local canvasW, canvasH = _W, _H*0.85
local notCanvasH = _H*0.15

local currentColor
local currentValue = 1
local indicatorColor
local hText, wText, diffText
local goalIndicator
local flatGrid
local sizeX, sizeY = 9, 9
local startPosX, startPosY = 1, 1
local goalColor
local grid
local addOneHundred = 0
local theType, Name
local nameInput, colNumInput
local buttonGradient = graphics.newGradient({192,192,192},{96,96,96},'down')

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

--local acceptableValues = {255,192,128,64,0}

local function save(data, fileName)
	local path = system.pathForFile(fileName, system.DocumentsDirectory)
	local file = io.open(path, 'w+')
	local data = json.encode(data)
	file:write(data)
	io.close(file)
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

	if nameInput.text == '' or nameInput.text == nil then
		Name = os.time()
	else
		Name = nameInput.text or os.time()
	end

	local function doSave()
		save({
			Type = theType,
			Name = Name,
			Size = {x = sizeX, y = sizeY},
			Tile = tileData,
			StartPos = {x = startPosX or 1, y = startPosY or 1},
			GoalColor = {r = goalColor[1] or 255, g = goalColor[2] or 255, b = goalColor[3] or 255},
			MarkerColorMaxSegments = colNum or 1,
			nColorsOnBoard = #allColorsOnBoard
		},
		'Custom_' .. Name)
	end
	
	if goals == 1 and starts == 1 then
		local path = system.pathForFile(('Custom_' .. Name), system.DocumentsDirectory)
		local nameExists = false

		if path then
			local handle = io.open(path, 'r')
			
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
		native.showAlert('Warning', 'You must have exactly one start and one goal on custom maps.', {'Ok'})
	end
end

local function saveMenu()
	local saveGroup = display.newGroup()

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

	local fgRect = display.newRoundedRect(saveGroup, 0, 0, _W*0.5, _H*0.45, _H*0.01)
	fgRect.x, fgRect.y = bgRect.x, bgRect.y
	fgRect:setFillColor(0,127,255)
	fgRect:addEventListener('tap', onFgTouch)
	fgRect:addEventListener('touch', onFgTouch)

	local nameText = display.newText(saveGroup, 'Name of map', 0, 0, nil, _W/32)
	nameText.x, nameText.y = fgRect.x, fgRect.y - fgRect.height*0.5 + nameText.height

	nameInput = native.newTextField(0, 0, fgRect.width*0.5, fgRect.height*0.12)
	saveGroup:insert(nameInput)
	nameInput.x, nameInput.y = nameText.x, nameText.y + nameText.height*2

	local colNumText = display.newText(saveGroup, 'Number of each color', 0, 0, nil, _W/32)
	colNumText.x, colNumText.y = nameInput.x, nameInput.y + nameInput.height

	colNumInput = native.newTextField(0, 0, fgRect.width*0.5, fgRect.height*0.12)
	colNumInput.inputType = 'number'
	saveGroup:insert(colNumInput)
	colNumInput.x, colNumInput.y = colNumText.x, colNumText.y + colNumText.height*2

	local blockFallingText = display.newText(saveGroup, 'Falling blocks', 0, 0, nil, _W/32)
	blockFallingText.x, blockFallingText.y = colNumInput.x, colNumInput.y + colNumInput.height

	local function onSwitch(e)
		if e.target.blockText.text == 'Off' then
			e.target.blockText.text = 'On'
		else
			e.target.blockText.text = 'Off'
		end
	end

	local blockFallingSwitch = display.newRect(saveGroup, 0, 0, fgRect.width*0.25, fgRect.height*0.12)
	blockFallingSwitch.x, blockFallingSwitch.y = blockFallingText.x, blockFallingText.y + blockFallingText.height*2
	blockFallingSwitch:setFillColor(buttonGradient)
	blockFallingSwitch:addEventListener('tap', onSwitch)

	local blockFallingSwitchText = display.newText(saveGroup, 'Off', 0, 0, nil, _W/32)
	blockFallingSwitchText.x, blockFallingSwitchText.y = blockFallingSwitch.x, blockFallingSwitch.y
	blockFallingSwitch.blockText = blockFallingSwitchText

	local function onDone(e)
		if e.target.blockText.text == 'On' then
			onSave(true)
		else
			onSave(false)
		end

		display.remove(saveGroup)
	end

	local cancelButton = display.newRect(saveGroup, 0, 0, fgRect.width*0.49, fgRect.height*0.15)
	cancelButton.x, cancelButton.y = fgRect.x - fgRect.width*0.5 + cancelButton.width*0.5, fgRect.y + fgRect.height*0.5 - cancelButton.height*0.5
	cancelButton:addEventListener('tap', onBgTap)
	cancelButton:setFillColor(buttonGradient)

	local cancelText = display.newText(saveGroup, 'Cancel', 0, 0, nil, _W/32)
	cancelText.x, cancelText.y = cancelButton.x, cancelButton.y

	local doneButton = display.newRect(saveGroup, 0, 0, fgRect.width*0.49, fgRect.height*0.15)
	doneButton.x, doneButton.y = fgRect.x + fgRect.width*0.5 - doneButton.width*0.5, fgRect.y + fgRect.height*0.5 - doneButton.height*0.5
	doneButton:addEventListener('tap', onDone)
	doneButton:setFillColor(buttonGradient)
	doneButton.blockText = blockFallingSwitchText

	local doneText = display.newText(saveGroup, 'Save', 0, 0, nil, _W/32)
	doneText.x, doneText.y = doneButton.x, doneButton.y
end

local function onChangeTile(e)
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

			print(e.target.color[1],e.target.color[2],e.target.color[3])
		end

		indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 1, 1, 1
		indicatorRed.yScale = (e.target.colorList[1] / 4) + 0.01
		indicatorGreen.yScale = (e.target.colorList[2] / 4) + 0.01
		indicatorBlue.yScale = (e.target.colorList[3] / 4) + 0.01
		indicatorRed.y = _H - indicatorRed.height*0.5*indicatorRed.yScale + 2
		indicatorGreen.y = _H - indicatorGreen.height*0.5*indicatorGreen.yScale + 2
		indicatorBlue.y = _H - indicatorBlue.height*0.5*indicatorBlue.yScale + 2
	else
		e.target.colorList = {0,0,0}
		e.target.color = currentColor
		e.target.value = currentValue + addOneHundred
		indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 0, 0, 0
	end

	if (goalIndicator.alpha == 1 and e.phase == 'ended') or goalIndicator.alpha == 0 then
		e.target:setFillColor(unpack(e.target.color))

		if startIndicator.alpha == 1 then
			e.target.startSign.alpha = 1
		else
			e.target.startSign.alpha = 0
		end

		if gateIndicator.alpha == 1 then
			e.target.gateSign.alpha = 1
		else
			e.target.gateSign.alpha = 0
		end

		if goalIndicator.alpha == 1 then
			e.target.goalSign.alpha = 1
		else
			e.target.goalSign.alpha = 0
		end
	end
end

local function createMap(width, height)
	display.remove(mapGroup)
	mapGroup = display.newGroup()
	local grid = {}
	flatGrid = {}
	sizeX, sizeY = width, height

	for i = 1, width do
		grid[i] = {}

		for j = 1, height do
			local tile = display.newRect(mapGroup, 0, 0, canvasW/width, canvasH/height)
			tile.x, tile.y = i*(canvasW/width) - (canvasW/width)*0.5, j*(canvasH/height) - (canvasH/height)*0.5
			tile.i, tile.j = i, j
			tile.strokeWidth = 1
			tile:setStrokeColor(64)

			local startSign = display.newText(mapGroup, 'Start', 0, 0, nil, (canvasW/width)*0.25)
			startSign.x, startSign.y = tile.x, tile.y
			startSign.alpha = 0
			startSign:setTextColor(64)
			tile.startSign = startSign

			local gateSign = display.newText(mapGroup, 'Gate', 0, 0, nil, (canvasW/width)*0.25)
			gateSign.x, gateSign.y = tile.x, tile.y
			gateSign.alpha = 0
			gateSign:setTextColor(64)
			tile.gateSign = gateSign

			local goalSign = display.newText(mapGroup, 'Goal', 0, 0, nil, (canvasW/width)*0.25)
			goalSign.x, goalSign.y = tile.x, tile.y
			goalSign.alpha = 0
			goalSign:setTextColor(64)
			tile.goalSign = goalSign

			tile:setFillColor(unpack(colors[1]))
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
	currentColor = e.target.color
	currentValue = e.target.value
	indicatorColor:setFillColor(unpack(currentColor))

	for k,v in pairs(selectionColors) do
		v:setStrokeColor(64)
	end

	e.target:setStrokeColor(255)
end

local function createColors()
	display.remove(colorGroup)
	colorGroup = display.newGroup()

	currentColor = colors[1]

	local bg = display.newRect(colorGroup, 0, 0, canvasW, notCanvasH)
	bg.x, bg.y = bg.width*0.5, bg.height*0.5 + canvasH
	bg:setFillColor(64)

	indicatorColor = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
	indicatorColor.x, indicatorColor.y = indicatorColor.width*0.5, indicatorColor.height*0.5 + canvasH
	indicatorColor:setFillColor(unpack(colors[1]))

	indicatorRed = display.newRect(colorGroup, 0, 0, _W*0.032, notCanvasH*0.5 - 1)
	indicatorRed.x, indicatorRed.y = indicatorColor.width*0.166, _H - indicatorRed.height*0.5
	indicatorRed:setFillColor(255,0,0)
	indicatorRed.strokeWidth = 1
	indicatorRed.alpha = 0
	indicatorRed:setStrokeColor(64)

	indicatorGreen = display.newRect(colorGroup, 0, 0, _W*0.032, notCanvasH*0.5 - 1)
	indicatorGreen.x, indicatorGreen.y = indicatorColor.width*0.5, _H - indicatorGreen.height*0.5
	indicatorGreen:setFillColor(0,255,0)
	indicatorGreen.strokeWidth = 1
	indicatorGreen.alpha = 0
	indicatorGreen:setStrokeColor(64)

	indicatorBlue = display.newRect(colorGroup, 0, 0, _W*0.032, notCanvasH*0.5 - 1)
	indicatorBlue.x, indicatorBlue.y = indicatorColor.width*0.833, _H - indicatorBlue.height*0.5
	indicatorBlue:setFillColor(0,0,255)
	indicatorBlue.strokeWidth = 1
	indicatorBlue.alpha = 0
	indicatorBlue:setStrokeColor(64)

	startIndicator = display.newText(colorGroup, 'Start', 0, 0, nil, _W/32)
	startIndicator.x, startIndicator.y = indicatorColor.x, indicatorColor.y
	startIndicator:setTextColor(64, 64, 64)
	startIndicator.alpha = 0

	gateIndicator = display.newText(colorGroup, 'Gate', 0, 0, nil, _W/32)
	gateIndicator.x, gateIndicator.y = indicatorColor.x, indicatorColor.y
	gateIndicator:setTextColor(64, 64, 64)
	gateIndicator.alpha = 0

	goalIndicator = display.newText(colorGroup, 'Goal', 0, 0, nil, _W/32)
	goalIndicator.x, goalIndicator.y = indicatorColor.x, indicatorColor.y
	goalIndicator:setTextColor(64, 64, 64)
	goalIndicator.alpha = 0

	local xPos = indicatorColor.x + indicatorColor.width*0.5
	local colorWidth = 0
	selectionColors = {}

	for i = 1, #colors do
		local color = display.newRect(colorGroup, 0, 0, ((_W*0.4) / (#colors*0.5)) - 4, notCanvasH*0.5 - 4)
		color.x, color.y = xPos + color.width*0.5 + 2, indicatorColor.y + indicatorColor.height*0.5 - color.y
		color:setFillColor(unpack(colors[i]))
		color:addEventListener('tap', onColor)
		color.color = colors[i]
		color.strokeWidth = 2
		color:setStrokeColor(64)

		if i < 3 then
			color.value = i-1
		else
			color.value = i
		end

		if i % 2 == 0 then
			color.y = color.y + color.height
			xPos = xPos + color.width + 2
			colorWidth = color.width
		end

		table.insert(selectionColors, color)
	end

	--

	local function onSizeTap(e)
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

		if tonumber(wText.text) > 20 then wText.text = 20 end
		if tonumber(hText.text) > 20 then hText.text = 20 end
	end

	local function onCreateNewMap(e)
		grid = createMap(tonumber(wText.text), tonumber(hText.text))
	end

	xPos = xPos - colorWidth*0.39

	local function onNewTap(e)
		local newMapGroup = display.newGroup()

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

		local fgRect = display.newRoundedRect(newMapGroup, 0, 0, _W*0.5, _H*0.33, _H*0.01)
		fgRect.x, fgRect.y = bgRect.x, bgRect.y
		fgRect:setFillColor(0,127,255)
		fgRect:addEventListener('tap', onFgTouch)
		fgRect:addEventListener('touch', onFgTouch)

		local widthText = display.newText(newMapGroup, 'Width', 0, 0, nil, _W/24)
		widthText.x, widthText.y = fgRect.x - fgRect.width*0.25, fgRect.y - fgRect.height*0.25

		local heightText = display.newText(newMapGroup, 'Height', 0, 0, nil, _W/24)
		heightText.x, heightText.y = fgRect.x + fgRect.width*0.25, fgRect.y - fgRect.height*0.25

		local wUp = display.newRect(newMapGroup, 0, 0, _W*0.1, fgRect.height*0.1)
		wUp.x, wUp.y = fgRect.x - fgRect.width*0.25, fgRect.y - fgRect.height*0.1
		wUp:setFillColor(buttonGradient)
		wUp.up = true
		wUp.w = true
		wUp:addEventListener('tap', onSizeTap)

		wUpText = display.newText(newMapGroup, '^', 0, 0, nil, _W/32)
		wUpText.x, wUpText.y = wUp.x, wUp.y

		local wDown = display.newRect(newMapGroup, 0, 0, _W*0.1, fgRect.height*0.1)
		wDown.x, wDown.y = fgRect.x - fgRect.width*0.25, fgRect.y + fgRect.height*0.1
		wDown:setFillColor(buttonGradient)
		wDown.up = false
		wDown.w = true
		wDown:addEventListener('tap', onSizeTap)

		wDownText = display.newText(newMapGroup, 'v', 0, 0, nil, _W/32)
		wDownText.x, wDownText.y = wDown.x, wDown.y

		wText = display.newText(newMapGroup, '9', 0, 0, nil, _W/32)
		wText.x, wText.y = wUp.x, (wUp.y + wDown.y)/2

		local hUp = display.newRect(newMapGroup, 0, 0, _W*0.1, fgRect.height*0.1)
		hUp.x, hUp.y = fgRect.x + fgRect.width*0.25, fgRect.y - fgRect.height*0.1
		hUp:setFillColor(buttonGradient)
		hUp.up = true
		hUp.w = false
		hUp:addEventListener('tap', onSizeTap)

		hUpText = display.newText(newMapGroup, '^', 0, 0, nil, _W/32)
		hUpText.x, hUpText.y = hUp.x, hUp.y

		local hDown = display.newRect(newMapGroup, 0, 0, _W*0.1, fgRect.height*0.1)
		hDown.x, hDown.y = fgRect.x + fgRect.width*0.25, fgRect.y + fgRect.height*0.1
		hDown:setFillColor(buttonGradient)
		hDown.up = false
		hDown.w = false
		hDown:addEventListener('tap', onSizeTap)

		hDownText = display.newText(newMapGroup, 'v', 0, 0, nil, _W/32)
		hDownText.x, hDownText.y = hDown.x, hDown.y

		hText = display.newText(newMapGroup, '9', 0, 0, nil, _W/32)
		hText.x, hText.y = hUp.x, (hUp.y + hDown.y)/2

		local function onDone(e)
			onCreateNewMap()
			display.remove(newMapGroup)
		end

		local cancelButton = display.newRect(newMapGroup, 0, 0, fgRect.width*0.49, fgRect.height*0.15)
		cancelButton.x, cancelButton.y = fgRect.x - fgRect.width*0.5 + cancelButton.width*0.5, fgRect.y + fgRect.height*0.5 - cancelButton.height*0.5
		cancelButton:addEventListener('tap', onBgTap)
		cancelButton:setFillColor(buttonGradient)

		local cancelText = display.newText(newMapGroup, 'Cancel', 0, 0, nil, _W/32)
		cancelText.x, cancelText.y = cancelButton.x, cancelButton.y

		local doneButton = display.newRect(newMapGroup, 0, 0, fgRect.width*0.49, fgRect.height*0.15)
		doneButton.x, doneButton.y = fgRect.x + fgRect.width*0.5 - doneButton.width*0.5, fgRect.y + fgRect.height*0.5 - doneButton.height*0.5
		doneButton:addEventListener('tap', onDone)
		doneButton:setFillColor(buttonGradient)

		local doneText = display.newText(newMapGroup, 'Create map', 0, 0, nil, _W/32)
		doneText.x, doneText.y = doneButton.x, doneButton.y
	end

	local function onStartTap(e)
		goalIndicator.alpha = 0
		gateIndicator.alpha = 0
		startIndicator.alpha = (startIndicator.alpha + 1) % 2

		if startIndicator.alpha == 1 then
			currentColor = colors[2]
			currentValue = 1
			indicatorColor:setFillColor(unpack(currentColor))
		end
	end

	local function onGateTap(e)
		goalIndicator.alpha = 0
		startIndicator.alpha = 0
		gateIndicator.alpha = (gateIndicator.alpha + 1) % 2

		if addOneHundred == 100 then
			addOneHundred = 0
		else
			addOneHundred = 100
		end
	end

	local function onGoalTap(e)
		startIndicator.alpha = 0
		gateIndicator.alpha = 0
		goalIndicator.alpha = (goalIndicator.alpha + 1) % 2

		if goalIndicator.alpha == 0 then
			indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 0, 0, 0
		else
			indicatorRed.alpha, indicatorGreen.alpha, indicatorBlue.alpha = 1, 1, 1
		end
	end

	xPos = _W*0.5

	local startButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.33)
	startButton.x, startButton.y = xPos + startButton.width*0.5, _H - startButton.height*2.5
	startButton:setFillColor(buttonGradient)
	startButton:addEventListener('tap', onStartTap)

	startText = display.newText(colorGroup, 'Start', 0, 0, nil, _W/32)
	startText.x, startText.y = startButton.x, startButton.y

	local gateButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.33)
	gateButton.x, gateButton.y = xPos + gateButton.width*0.5, _H - gateButton.height*1.5
	gateButton:setFillColor(buttonGradient)
	gateButton:addEventListener('tap', onGateTap)

	startText = display.newText(colorGroup, 'Gate', 0, 0, nil, _W/32)
	startText.x, startText.y = gateButton.x, gateButton.y

	local goalButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.33)
	goalButton.x, goalButton.y = xPos + goalButton.width*0.5, _H - goalButton.height*0.5
	goalButton:setFillColor(buttonGradient)
	goalButton:addEventListener('tap', onGoalTap)

	goalText = display.newText(colorGroup, 'Goal', 0, 0, nil, _W/32)
	goalText.x, goalText.y = goalButton.x, goalButton.y

	local newButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
	newButton.x, newButton.y = _W*0.675, _H - notCanvasH*0.5
	newButton:setFillColor(buttonGradient)
	newButton:addEventListener('tap', onNewTap)

	local newText = display.newText(colorGroup, 'New', 0, 0, nil, _W/32)
	newText.x, newText.y = newButton.x, newButton.y

	local saveButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
	saveButton.x, saveButton.y = _W*0.8, _H - notCanvasH*0.5
	saveButton:setFillColor(buttonGradient)
	saveButton:addEventListener('tap', saveMenu)

	saveText = display.newText(colorGroup, 'Save', 0, 0, nil, _W/32)
	saveText.x, saveText.y = saveButton.x, saveButton.y

	local menuButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
	menuButton.x, menuButton.y = _W*0.925, _H - notCanvasH*0.5
	menuButton:setFillColor(buttonGradient)
	-- Ska ha en eventlistener som skickar användaren till menyn.

	menuText = display.newText(colorGroup, 'Menu', 0, 0, nil, _W/32)
	menuText.x, menuText.y = menuButton.x, menuButton.y
end

currentColor = colors[1]
grid = createMap(9, 9)
createColors()

end

function scene:createScene(e) end
function scene:exitScene(e) end
function scene:destroyScene(e) end

scene:addEventListener('createScene', scene)
scene:addEventListener('enterScene', scene)
scene:addEventListener('exitScene', scene)
scene:addEventListener('destroyScene', scene)

return scene











