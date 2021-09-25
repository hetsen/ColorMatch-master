local composer 	= require "composer"
local scene 			= composer.newScene()

local tmpH = 480

function scene:create(e)
	local params = e.params
	local sceneView = self.view

	local cancelAnimation
	local objectList
	local pause
	local objectGroup
	local pausedOne
	local tutorial
	local atEnd
	local completed
	local nextButton
	local projectSpecificObjectsBack
	local projectSpecificObjectsFront
	local bg

	local function colorTransition(obj, newColor, time)
		local oldColor = obj.color
		local middleColor
		local dir

		for i = 1, 100 do
			timer.performWithDelay((time or 200)*0.01*i, function()
				if obj and obj.parent then
					middleColor = {}

					for j = 1, 3 do

						if oldColor[j] < newColor[j] then
							dir = 1
						else
							dir = - 1
						end

						middleColor[j] = math.round(oldColor[j] + ((math.abs(oldColor[j] - newColor[j]) / 100) * i)*dir)
					end

					if obj.isText then
						obj:setTextColor(unpack(middleColor))
					else
						obj:setFillColor(unpack(middleColor))
					end
					obj.color = middleColor
				end
			end)
		end
	end

	local function afterDelay(i, preAnimation, postAnimation)
		completed = false
		local vi = tutorial.animationSteps[i]

		if preAnimation then
			vi = tutorial.preAnimations[i]
		elseif postAnimation then
			vi = tutorial.postAnimations[i]
		end

		timer.performWithDelay(vi.delay or 1, function()
			if not cancelAnimation then
				for k,v in pairs(objectList) do
					if v.name == vi.target then
						local tmpX, tmpY = vi.xInPercentOfScreen, vi.yInPercentOfScreen

						if tmpX then
							tmpX = tmpX * _W
						elseif vi.x then
							tmpX = vi.x
						else
							tmpX = v.x
						end

						if tmpY then
							tmpY = tmpY * tmpH
						elseif vi.y then
							tmpY = vi.y

							if vi.fromH then
								tmpY = tmpH - vi.y

								if vi.realH then
									tmpY = _H - vi.y
								end
							end
						else
							tmpY = v.y
						end

						if vi.color then
							colorTransition(v, vi.color, vi.time)
						end

						local hasDoneNext = false

						local function whenComplete()
							if vi.doNextAuto then
								currentStep = currentStep + 1

								if not hasDoneNext then
									afterDelay(i+1)
								end
							else
								completed = true
								if nextButton then
									nextButton.alpha = 1
									nextButton.text.alpha = 1
								end

								if (not tutorial.animationSteps[i+1]) and (not preAnimation) then
									nextButton.text.text = '< Back to Menu >'
									atEnd = true
								end
							end
						end

						if vi.simultaneous then
							hasDoneNext = true
							afterDelay(i+1)
						end

						if vi.text then
							v.text = vi.text
						end

						if vi.time == 0 then
							v.x = tmpX
							v.y = tmpY
							v.xScale = (vi.xScale or v.xScale)
							v.yScale = (vi.yScale or v.yScale)
							v.alpha = (vi.alpha or v.alpha)
							v.rotation = (vi.rotation or v.rotation)
							whenComplete()
						else
							transition.to(v, {
								time = (vi.time or 1000),
								x = tmpX,
								y = tmpY,
								xScale = (vi.xScale or v.xScale),
								yScale = (vi.yScale or v.yScale),
								alpha = (vi.alpha or v.alpha),
								rotation = (vi.rotation or v.rotation),
								onComplete = whenComplete
							})
						end
					end
				end
			end
		end)
	end

	local function createObject(vi)
		local obj

		if vi.objectType == 'rect' then
			obj = display.newRect(objectGroup, 0, 0, vi.width, vi.height)
		elseif vi.objectType == 'roundedRect' then
			obj = display.newRoundedRect(objectGroup, 0, 0, vi.width, vi.height, vi.rounding)
		elseif vi.objectType == 'circle' then
			obj = display.newCircle(objectGroup, 0, 0, vi.radius)
		elseif vi.objectType == 'text' then
			local objWidth, objHeight = _W*0.85, tmpH*0.1

			if _G.model == 'iPad' then
				objWidth = objWidth*1.01
			end

			if vi.noBox then
				obj = display.newText(objectGroup, (vi.text or 'No text'), 0, 0, (vi.font or font or native.systemFont), (vi.fontSize or fontSize or 20))
			else
				obj = display.newText(objectGroup, (vi.text or 'No text'), 0, 0, objWidth, objHeight, (vi.font or font or native.systemFont), (vi.fontSize or fontSize or 20))
			end

			obj.isText = true
		elseif vi.objectType == 'image' then
			obj = display.newImageRect(objectGroup, vi.path, vi.width, vi.height)
		elseif vi.objectType == 'complexObject' then
			obj = display.newGroup()

			for j = 1, #vi.objects do
				local tmpObj = createObject(vi.objects[j])
				obj:insert(tmpObj)
			end

			objectGroup:insert(obj)
		end

		if vi.strokeWidth then
			obj.strokeWidth = vi.strokeWidth
			obj:setStrokeColor(unpack(vi.strokeColor or {0,0,0}))
		end

		local theH = tmpH

		if vi.realH then
			theH = _H
		end

		obj.x, obj.y = _W*(vi.xInPercentOfScreen or 0.5), theH*(vi.yInPercentOfScreen or 0.5)
		obj.xScale, obj.yScale = vi.xScale or 1, vi.yScale or 1
		obj.alpha = vi.alpha or 0
		obj.name = vi.name or ''
		obj.color = {255,255,255}
		objectList[#objectList+1] = obj

		if vi.x then
			obj.x = vi.x

			if vi.fromW then
				obj.x = _W - vi.x
			end
		end

		if vi.y then
			obj.y = vi.y
			
			if vi.fromH then
				obj.y = theH - vi.y
			end
		end

		--print(obj.name, obj.x, obj.y, obj.alpha, obj.isVisible, obj.xScale, obj.yScale)
		return obj
	end

	local function showTutorial(tutorial)
		objectGroup = display.newGroup()
		objectList = {}

		if nextButton then
			nextButton.alpha = 0.5
			nextButton.text.alpha = 0
		end

		if tutorial.background then
			local tbg = tutorial.background

			bg = display.newImageRect(sceneView, tbg.path, tbg.width, tbg.height)
			bg.xScale, bg.yScale = tbg.xScale, tbg.yScale*(_H / tmpH)
			bg.x, bg.y = _W*0.5, _H*0.5
		end

		for i = 1, #tutorial.objects do
			local vi = tutorial.objects[i]

			createObject(vi)
		end

		sceneView:insert(objectGroup)

		if nextButton then
			objectGroup:toBack()
		end

		local buttonDelay = 0

		for i = 1, #tutorial.preAnimations do
			afterDelay(i, true)
			currentStep = 0

			if tutorial.preAnimations[i].time + (tutorial.preAnimations[i].delay or 0) > buttonDelay then
				buttonDelay = tutorial.preAnimations[i].time + (tutorial.preAnimations[i].delay or 0)
			end
		end

		timer.performWithDelay(1, function()
			projectSpecificObjectsBack:toBack()
			if bg then
				bg:toBack()
			end
		end)

		timer.performWithDelay(buttonDelay, function()
			nextButton.alpha = 1
			nextButton.text.alpha = 1
		end)
	end

	tutorial = require ('Tutorials.' .. params.tutorial)

	local tmpPSO

	if tutorial.custom then
		tmpPSO = require 'Tutorials.projectSpecificObjects2'
		projectSpecificObjectsBack, projectSpecificObjectsFront = tmpPSO[1], tmpPSO[2]
	else
		tmpPSO = require 'Tutorials.projectSpecificObjects'
		projectSpecificObjectsBack, projectSpecificObjectsFront = tmpPSO[1], tmpPSO[2]
	end
	currentStep = 0
	completed = true
	showTutorial(tutorial)

	local togglesGroup = display.newGroup()

	local function fromStart()
		if tutorial.postAnimations then
			local delayTime = 0

			for i = 1, #tutorial.postAnimations do
				afterDelay(i, false, true)
				currentStep = 0

				if tutorial.postAnimations[i].time + (tutorial.postAnimations[i].delay or 0) > delayTime then
					delayTime = tutorial.postAnimations[i].time + (tutorial.postAnimations[i].delay or 0)
				end
			end

			timer.performWithDelay(delayTime+1, function()
				currentStep = 0
				display.remove(objectGroup)
				display.remove(bg)

				pausedOne = nil
				cancelAnimation = nil
				objectList = nil
				pause = nil
				objectGroup = nil

				showTutorial(tutorial)

				objectGroup:toFront()
				projectSpecificObjectsFront:toFront()
			end)
		else
			currentStep = 0
			display.remove(objectGroup)
			display.remove(bg)

			pausedOne = nil
			cancelAnimation = nil
			objectList = nil
			pause = nil
			objectGroup = nil

			showTutorial(tutorial)

			objectGroup:toFront()
			projectSpecificObjectsFront:toFront()
		end
	end

	local function onNext(e)
		if atEnd then
			composer.gotoScene('tutorialMenu')
			-- nextButton.text.text = '< Tap to continue >'
			-- nextButton.alpha = 0.5
			-- nextButton.text.alpha = 0
			-- atEnd = false
			-- fromStart()
		else
			if completed then
				e.target.alpha = 0.5
				e.target.text.alpha = 0
				currentStep = currentStep + 1
				afterDelay(currentStep)
			end
		end
	end

	nextButton = display.newGroup()

	local bg = display.newImageRect(nextButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
	bg.x, bg.y = 0, 0
	bg.xScale, bg.yScale = 0.4, 0.4

	local fg = display.newImageRect(nextButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
	fg.x, fg.y = 0, 0
	fg.xScale, fg.yScale = 0.4, 0.4

	local text = display.newText(nextButton, '< Tap to continue >', 0, 0, systemfont, _G.smallFontSize)
	text.x, text.y = nextButton.width*nextButton.xScale*0.48 - text.width*text.xScale*0.5, nextButton.height*nextButton.yScale*0.125

	nextButton.text = text
	nextButton.x, nextButton.y = _W*0.5, _H - nextButton.height*nextButton.yScale*0.25
	nextButton:addEventListener('tap', onNext)
	nextButton.alpha = 0.5

	if tutorial.custom then
		nextButton.y = nextButton.height*nextButton.yScale*0.25
		nextButton.text.y = nextButton.height*nextButton.yScale*0.3
	end

	togglesGroup:insert(nextButton)

	sceneView:insert(projectSpecificObjectsBack)
	sceneView:insert(togglesGroup)
	objectGroup:toFront()
	sceneView:insert(projectSpecificObjectsFront)

	local function onMenu(e)
		composer.gotoScene('tutorialMenu')
	end

	local backScale = 0.5

	if _G.model == 'iPad' then
		--backScale = 0.25
	end

	local backButton = display.newGroup()

	local bg = display.newImageRect(backButton, 'Graphics/UI/hud_btn_fitting.png', 114, 114)
	bg.xScale, bg.yScale = backScale, backScale
	bg.x, bg.y = 0, 0

	local fg = display.newImageRect(backButton, 'Graphics/UI/hud_btn_menu.png', 114, 114)
	fg.xScale, fg.yScale = backScale, backScale
	fg.x, fg.y = 0, 0

	backButton.xScale, backButton.yScale = 0.85, 0.85
	backButton.x, backButton.y = _W*0.855, tmpH*0.058
	backButton:addEventListener('tap', onMenu)
	togglesGroup:insert(backButton)

	if tutorial.custom then
		backButton.x = _W - backButton.width*backButton.xScale*0.5
		backButton.y = _H - backButton.height*backButton.yScale*0.5
		backButton.alpha = 0.01

		if system.getInfo('model') == 'iPhone' then
			backButton.x = backButton.width*backButton.xScale*0.5
		end
	end
end 

function scene:show(e)
	
end 

function scene:hide(e)
	package.loaded['Tutorials.projectSpecificObjects'] = nil
	package.loaded['Tutorials.projectSpecificObjects2'] = nil
	_G['Tutorials.projectSpecificObjects'] = nil
	_G['Tutorials.projectSpecificObjects2'] = nil
end 

function scene:destroy(e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
