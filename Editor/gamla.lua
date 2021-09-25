local storyboard = require 'storyboard'
local scene = storyboard.newScene()

function scene:enterScene(e)
	
display.setStatusBar(display.HiddenStatusBar)
local json = require 'json'

local _W, _H = display.contentWidth, display.contentHeight
local canvasW, canvasH = _W, _H*0.9
local notCanvasH = _H*0.1

local currentColor
local currentValue = 1
local indicatorColor
local hText, wText, diffText
local mapGroup
local colorGroup
local goalIndicator
local flatGrid
local sizeX, sizeY = 9, 9
local startPosX, startPosY = 1, 1
local goalColor
local grid
local nameInput, colNumInput
local buttonGradient = graphics.newGradient({192,192,192},{96,96,96},'down')

local colors = {
	{0,0,0},
	{255,255,255},
	{255,0,0},
	{0,255,0},
	{0,0,255},
	{0,255,255},
	{255,0,255},
	{255,255,0},
}

local function save(data, fileName)
	local path = system.pathForFile(fileName, system.DocumentsDirectory)
	local file = io.open(path, 'w+')
	local data = json.encode(data)
	file:write(data)
	io.close(file)
end

local function onSave(e)
	local tileData = {}
	local allColorsOnBoard = {}
	local goals, starts = 0, 0

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
	
	if goals == 1 and starts == 1 then
		save({
			Type = theType or 'Default',
			Name = nameInput.text or os.time(),
			Size = {x = sizeX, y = sizeY},
			Tile = tileData,
			StartPos = {x = startPosX or 1, y = startPosY or 1},
			GoalColor = {r = goalColor[1] or 255, g = goalColor[2] or 255, b = goalColor[3] or 255},
			MarkerColorMaxSegments = colNum or 1,
			nColorsOnBoard = #allColorsOnBoard
		},
		'saveFile')
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

	local fgRect = display.newRoundedRect(saveGroup, 0, 0, _W*0.5, _H*0.33, _H*0.01)
	fgRect.x, fgRect.y = bgRect.x, bgRect.y
	fgRect:setFillColor(0,127,255)
	fgRect:addEventListener('tap', onFgTouch)
	fgRect:addEventListener('touch', onFgTouch)

	local nameText = display.newText(saveGroup, 'Name of map', 0, 0, nil, _W/32)
	nameText.x, nameText.y = fgRect.x, fgRect.y - fgRect.height*0.5 + nameText.height

	nameInput = native.newTextField(0, 0, fgRect.width*0.5, fgRect.height*0.15)
	saveGroup:insert(nameInput)
	nameInput.x, nameInput.y = nameText.x, nameText.y + nameText.height*2

	local colNumText = display.newText(saveGroup, 'Number of each color', 0, 0, nil, _W/32)
	colNumText.x, colNumText.y = nameInput.x, nameInput.y + nameInput.height*1.5

	colNumInput = native.newTextField(0, 0, fgRect.width*0.5, fgRect.height*0.15)
	colNumInput.inputType = 'number'
	saveGroup:insert(colNumInput)
	colNumInput.x, colNumInput.y = colNumText.x, colNumText.y + colNumText.height*2

	local function onDone(e)
		onSave()
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

	local doneText = display.newText(saveGroup, 'Save', 0, 0, nil, _W/32)
	doneText.x, doneText.y = doneButton.x, doneButton.y
end

local function onChangeTile(e)
	e.target.color = currentColor
	e.target.value = currentValue
	e.target:setFillColor(unpack(e.target.color))

	if startIndicator.alpha == 1 then
		e.target.startSign.alpha = 1
	else
		e.target.startSign.alpha = 0
	end

	if goalIndicator.alpha == 1 then
		e.target.goalSign.alpha = 1
	else
		e.target.goalSign.alpha = 0
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

			local startSign = display.newText(mapGroup, 'Start', 0, 0, nil, (canvasW/width)*0.25)
			startSign.x, startSign.y = tile.x, tile.y
			startSign.alpha = 0
			startSign:setTextColor(64)
			tile.startSign = startSign

			local goalSign = display.newText(mapGroup, 'Goal', 0, 0, nil, (canvasW/width)*0.25)
			goalSign.x, goalSign.y = tile.x, tile.y
			goalSign.alpha = 0
			goalSign:setTextColor(64)
			tile.goalSign = goalSign

			tile:setFillColor(unpack(colors[1]))
			tile.color = colors[1]
			tile:addEventListener('touch', onChangeTile)

			grid[i][j] = tile
			print(j*width+i - width)
			flatGrid[j*width+i - width] = tile
		end
	end

	return grid
end

local function onColor(e)
	currentColor = e.target.color
	currentValue = e.target.value
	indicatorColor:setFillColor(unpack(currentColor))
end

local function createColors()
	display.remove(colorGroup)
	colorGroup = display.newGroup()

	currentColor = colors[1]

	local bg = display.newRect(colorGroup, 0, 0, canvasW, notCanvasH)
	bg.x, bg.y = bg.width*0.5, bg.height*0.5 + canvasH
	bg:setFillColor(64)

	indicatorColor = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH)
	indicatorColor.x, indicatorColor.y = indicatorColor.width*0.5, indicatorColor.height*0.5 + canvasH
	indicatorColor:setFillColor(unpack(colors[1]))

	startIndicator = display.newText(colorGroup, 'Start', 0, 0, nil, _W/32)
	startIndicator.x, startIndicator.y = indicatorColor.x, indicatorColor.y
	startIndicator:setTextColor(64, 64, 64)
	startIndicator.alpha = 0

	goalIndicator = display.newText(colorGroup, 'Goal', 0, 0, nil, _W/32)
	goalIndicator.x, goalIndicator.y = indicatorColor.x, indicatorColor.y
	goalIndicator:setTextColor(64, 64, 64)
	goalIndicator.alpha = 0

	local xPos = indicatorColor.x + indicatorColor.width*0.5
	local colorWidth = 0

	for i = 1, #colors do
		local color = display.newRect(colorGroup, 0, 0, (_W*0.4) / (#colors*0.5), notCanvasH*0.5)
		color.x, color.y = xPos + color.width*0.5, indicatorColor.y - color.y
		color:setFillColor(unpack(colors[i]))
		color:addEventListener('tap', onColor)
		color.color = colors[i]

		if i < 3 then
			color.value = i-1
		else
			color.value = i
		end

		if i % 2 == 0 then
			color.y = color.y + color.height
			xPos = xPos + color.width
			colorWidth = color.width
		end
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
		startIndicator.alpha = (startIndicator.alpha + 1) % 2

		if startIndicator.alpha == 1 then
			currentColor = colors[2]
			currentValue = 1
			indicatorColor:setFillColor(unpack(currentColor))
		end
	end

	local function onGoalTap(e)
		startIndicator.alpha = 0
		goalIndicator.alpha = (goalIndicator.alpha + 1) % 2
	end

	xPos = _W*0.5

	local startButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
	startButton.x, startButton.y = xPos + startButton.width*0.5, _H - startButton.height*1.5
	startButton:setFillColor(buttonGradient)
	startButton:addEventListener('tap', onStartTap)

	startText = display.newText(colorGroup, 'Start', 0, 0, nil, _W/32)
	startText.x, startText.y = startButton.x, startButton.y

	local goalButton = display.newRect(colorGroup, 0, 0, _W*0.1, notCanvasH*0.5)
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
	-- Ska ha en eventlistener som skickar anvÃ¤ndaren till menyn.

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










