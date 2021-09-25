local tenflib = require("tenfLib")
local productBuyResult = require 'productBuyResult'

local composer 	= require "composer"
local scene 		= composer.newScene()
local sceneView
local backdrop

function scene:create(e)
	params = e.params or {}
	prev = composer.getSceneName("previous")()

	sceneView = self.view

	-- <fake>
	-- params.worldName = 'Fake World'
	-- local loadedWorldList = {
	-- 	{
	-- 		title = 'Fake World',
	-- 		description = 'In a world where everything is fake, one man does nothing to stop nothing from happening.',
	-- 		price = '7',
	-- 		localizedPrice = '7.00 Kr',
	-- 		productIdentifier = 'se.10fingers.findthecure.fakeworld'
	-- 	}
	-- }
	-- </fake>
	local loadedWorldList = tenflib.jsonLoad('worldList')

	print('--- Product Information Below ---')

	local product = {}

	for k,v in pairs(loadedWorldList) do
		print(v.title, params.worldName)
		if v.title == params.worldName then
			for k2,v2 in pairs(v) do
				print(k2,v2)
				product[k2] = v2
			end
		end
	end

	
	backdrop = require 'background'
	sceneView:insert(backdrop)
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	local background = display.newImageRect(sceneView, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	background.xScale, background.yScale = 0.25, 0.32
	background.x, background.y = _W*0.5, _H*0.5

	local titleGroup = display.newGroup()

	local titleText = display.newText(titleGroup, product.title, 0, 0, systemfont, _G.mediumLargeFontSize)
	titleText.x, titleText.y = 0, 0

	titleGroup.x, titleGroup.y = _W*0.5, _H*0.17
	sceneView:insert(titleGroup)

	--

	local descriptionGroup = display.newGroup()

	local descriptionText = display.newText(descriptionGroup, product.description, 0, 0, _W*0.6, _H*0.5, systemfont, _G.smallFontSize)
	descriptionText.x, descriptionText.y = 0, 0

	descriptionGroup.x, descriptionGroup.y = _W*0.5, _H*0.52
	sceneView:insert(descriptionGroup)

	--

	local priceGroup = display.newGroup()

	local priceText = display.newText(priceGroup, product.localizedPrice, 0, 0, systemfont, _G.mediumFontSize)
	priceText.x, priceText.y = 0, 0

	priceGroup.x, priceGroup.y = _W*0.5, _H*0.23
	sceneView:insert(priceGroup)

	--

	if params.hasBeenUnlocked then
		priceText.text = 'Unlocked'
	else
		local buyGroup = display.newGroup()

		local buyBg = display.newImageRect(buyGroup, 'Graphics/Menu/small_btn_fill.png', 384, 190)
		buyBg.x, buyBg.y = 0, 0
		buyBg:setFillColor(255,255,0)
		buyBg.xScale, buyBg.yScale = 0.2, 0.2

		local buyFg = display.newImageRect(buyGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
		buyFg.x, buyFg.y = 0, 0
		--buyFg:setFillColor(255,255,0)
		buyFg.xScale, buyFg.yScale = 0.2, 0.2

		local buyText = display.newText(buyGroup, 'Buy', 0, 0, systemfont, _G.mediumFontSize)
		buyText.x, buyText.y = 0, 0

		local function onBuyButton(e)
			if store.canMakePurchase then
				_G.inAppPurchaseProcessing.onBuy(product)
			else
				native.showAlert('Warning!', 'In-app purchases are disabled on this device.', {'Ok'})
			end
		end

		buyGroup.x, buyGroup.y = _W*0.37, _H*0.8
		buyGroup:addEventListener('tap', onBuyButton)
		sceneView:insert(buyGroup)
	end

	--
	local backGroup = display.newGroup()

	local backBg = display.newImageRect(backGroup, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	backBg.x, backBg.y = 0, 0
	backBg:setFillColor(0,128,255)
	backBg.xScale, backBg.yScale = 0.2, 0.2

	local backFg = display.newImageRect(backGroup, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	backFg.x, backFg.y = 0, 0
	--buyFg:setFillColor(255,255,0)
	backFg.xScale, backFg.yScale = 0.2, 0.2

	local backText = display.newText(backGroup, 'Back', 0, 0, systemfont, _G.mediumFontSize)
	backText.x, backText.y = 0, 0

	local function onBackButton(e)
		composer.gotoScene('worldPicker')
	end

	backGroup.x, backGroup.y = _W*0.63, _H*0.8
	backGroup:addEventListener('tap', onBackButton)
	sceneView:insert(backGroup)
end

function scene:show(e) end

function scene:hide(e)
	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil
end

function scene:destroy(e) end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)

return scene
