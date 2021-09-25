local composer 		= require "composer"
local tenflib 		= require "tenfLib"
local scene 		= composer.newScene()

local sceneView
local backdrop
local worldListGroup, superListGroup

function scene:create(e)
	params = e.params or {}
	prev = composer.getSceneName("previous")
	sceneView = self.view

	backdrop = require 'background'
	sceneView:insert(backdrop)
	Runtime:addEventListener("enterFrame", backdrop.animateglow)

	local background = display.newImageRect(sceneView, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
	background.xScale, background.yScale = 0.29, (_H/background.height)*0.92
	background.x, background.y = _W*0.5, _H*0.5

	local height = 60
	local world, bg, fg

	local function onScroll(e)
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
				if e.target.y + e.target.height <= e.target.middlePoint then
					e.target.scrollTransition = true
					transition.to(e.target, {time = 200, y = e.target.middlePoint - e.target.height, onComplete=function()
						e.target.scrollTransition = false
					end})
				elseif e.target.y >= e.target.middlePoint then
					e.target.scrollTransition = true
					transition.to(e.target, {time = 200, y = e.target.middlePoint, onComplete=function()
						e.target.scrollTransition = false
					end})
				end

				e.target.originTouchY = 0
				display.getCurrentStage():setFocus(nil)
				e.target.swiping = false
			end
		end
	end

	local function onTap(e)
		print ("PARAMS! ".. e.target.world)
		params.worldName = e.target.world
		params.menu = 1
		
		composer.gotoScene('menu', {params = params})
	end

	local function onLockedTap(e)
		params.worldName = e.target.world
		
		composer.gotoScene('levelPackInfo', {params = params})
	end

	local function onBack(e)
		composer.gotoScene('startscreen')
	end

	local function onInfoTap(e)
		timer.performWithDelay(1, function()
			print('worldName', e.target.worldName)
			composer.gotoScene('levelPackInfo', {params = {worldName = e.target.worldName, hasBeenUnlocked = true}})
		end)

		return true
	end

	local function returnCallback(_productList)
		--if composer.getCurrentSceneName() == 'worldPicker' then
		if composer.getSceneName("current") == 'worldPicker' then
			display.remove(superListGroup)
			worldListGroup = display.newGroup()
			
			if _productList then
				print("ProductList: ", _productList)
				for k,v in pairs(_productList) do
					print(k,v)
				end
			end

			local productList = _productList or {}

			local worlds = {}

			for k,v in pairs(_G.worldsUnlocked) do
				worlds[#worlds+1] = k
			end

			local tmpWorlds = {}

			for i = 1, #_G.worldListOrder do
				for k,v in pairs(worlds) do
					if v == _G.worldListOrder[i] then
						tmpWorlds[#tmpWorlds+1] = v
					end
				end
			end

			worlds = tmpWorlds

			print("Going through products...")

			local tmpProductList = {}

			for i = 1, #productList do
				local unique = true
				print("Product name: ", productList[i].title)

				for j = 1, #worlds do
					if worlds[j] == productList[i].title then
						unique = false
					end
				end

				if unique then
					tmpProductList[#tmpProductList+1] = productList[i]
					print("found unique product: ", productList[i].title)
				end
			end

			for i = 1, #_G.appleProductList do
				for k,v in pairs(tmpProductList) do
					if v.productIdentifier == _G.appleProductList[i] then
						worlds[#worlds+1] = v.title
					end
				end
			end

			local loadedWorldList = tenflib.jsonLoad('worldList') or {
				['Find the Cure'] = {
					title = 'Find the Cure',
					description = 'The original levels of the game.',
					price = 'Free',
					localizedPrice = 'Free'
				}
			}

			for i = 1, #worlds do
				local product

				for k,v in pairs(productList) do
					if worlds[i] == v.title then
						product = v
					end
				end

				if product then
					loadedWorldList[product.title] = {}

					for k,v in pairs(product) do
						loadedWorldList[product.title][k] = v
					end
				end
			end

			tenflib.jsonSave('worldList', loadedWorldList)

			for i = 1, #worlds do
				world = display.newGroup()

				bg = display.newRoundedRect(world, 0, 0, _W*0.75, height, 10)
				bg.x, bg.y = 0, 0
				bg:setFillColor(0,128,0) -- Temporärt. Ska vara bild.
				bg:setStrokeColor(0)
				bg.strokeWidth = 2

				fg = display.newText(world, worlds[i], 0, 0, systemfont, _G.mediumFontSize)
				fg.x, fg.y = 0, 0

				world.x, world.y = _W*0.5, i*height*1.1
				world.world = worlds[i]

				if _G.worldsUnlocked[worlds[i]] then
					world:addEventListener('tap', onTap)

					local info = display.newRoundedRect(world, 0, 0, bg.width*0.1, bg.height*0.4, bg.width*0.02)
					info.x, info.y = bg.width*0.5*bg.xScale - info.width*0.5 - 8, 0
					info.worldName = worlds[i]
					info:addEventListener('tap', onInfoTap)
				else
					world:addEventListener('tap', onLockedTap)

					local price = display.newText(world, loadedWorldList[world.world].localizedPrice, 0, 0, systemfont, _G.mediumFontSize)
					price.x, price.y = bg.width*0.5*bg.xScale - price.width*0.5 - 8, 0
					price:setTextColor(255,255,0)

					bg:setFillColor(128,128,128,128)
					fg:setTextColor(128,128,128,128)
				end

				worldListGroup:insert(world)
			end

			worldListGroup.y = _H*0.1
			worldListGroup.middlePoint = _H*0.37
			worldListGroup:addEventListener('touch', onScroll)

			superListGroup = display.newGroup()
			superListGroup:insert(worldListGroup)

			local mask = graphics.newMask('pics/normalMask.png')
			superListGroup:setMask(mask)
			superListGroup.maskX, superListGroup.maskY = _W*0.5, _H*0.45
			superListGroup.maskScaleX, superListGroup.maskScaleY = 5, (_H*0.75)/200

			sceneView:insert(superListGroup)
		end
	end

	returnCallback(_productList)
	_G.inAppPurchaseProcessing.returnProductsTo(returnCallback)
	_G.inAppPurchaseProcessing.setupMyStore()

	local bgGroup = {}--display.newGroup()

	backButtonFill = {}--display.newImageRect (bgGroup,'Graphics/Menu/small_btn_fill.png',384,190)
	backButtonFill.path = 'Graphics/Menu/small_btn_fill.png'
	backButtonFill.width = 384
	backButtonFill.height = 190
	backButtonFill.color = {255,255,0}
	backButtonFill.xScale, backButtonFill.yScale = .2,.2

	backButton = {}--display.newImageRect (bgGroup,'Graphics/Menu/small_btn_texture.png',384,190)
	backButton.path = 'Graphics/Menu/small_btn_texture.png'
	backButton.width = 384
	backButton.height = 190
	backButton.xScale, backButton.yScale = .2,.2

	backGroupText = {}--display.newText(bgGroup,"Back",0,0,systemfont,_G.mediumFontSize)
	backGroupText.text = 'Back'
	backGroupText.font = systemfont
	backGroupText.fontSize = _G.mediumFontSize

	bgGroup.bg = backButtonFill
	bgGroup.fg = backButton
	bgGroup.text = backGroupText
	bgGroup.x, bgGroup.y = _W*.75,_H*.9
	bgGroup.onEnded = onBack

	bgGroup = createButton(bgGroup)

	sceneView:insert(bgGroup)
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
