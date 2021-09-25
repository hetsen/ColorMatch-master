local composer 			= require "composer"
local scene 			= composer.newScene()
--composer.purgeOnSceneChange = true
composer.recycleOnSceneChange = true
local aud				= require "audioo"

local _W 				= display.contentWidth
local _H 				= display.contentHeight
local group_Background 	= display.newGroup()
local group_Logo 		= display.newGroup()
local group_Menubox 	= display.newGroup()
local group_MenuChoices = display.newGroup()
local beenthere = false 
local obj 				= {}
obj.mChoices 			= {}
obj.mChoicesBox 		= {}
local choice
local startgame
local dosomething
local gamestarted = false
local tutorialButton
local backgroundmusic

local c1
local c2
local varTransition1
local varTransition2
local spheretrans
local secondSheretrans
local shadowSpheretrans
local secondShadowSpheretrans
local menubool = false
local menuisopen = false

function scene:create (e)
backgroundmusic = "colorboard_ingame_2.mp3"
aud.playmusic(backgroundmusic)



gamestarted = false 
local last = composer.getSceneName("previous")

	if last then 
		--print ("coming from "..last)
		composer.removeScene(last)


	else 
		--print ("first scene, not coming from anywhere")
	end  

	if last == "main" or last == nil then 

		beenthere = false

	else 
		beenthere = true 

	end 


function startgame(e)
	local function onReturnTrue(e)
		return true
	end

	local overlayRect = display.newRect(0,0,_W,_H)
	overlayRect.x, overlayRect.y = _W*0.5, _H*0.5
	overlayRect.alpha = 0.01
	overlayRect:addEventListener('tap', onReturnTrue)
	overlayRect:addEventListener('touch', onReturnTrue)

	if not gamestarted then 
		timer.performWithDelay(1,function () obj.playButton:removeEventListener('tap',startgame) end)
			
		gamestarted = true 
		
		transition.to (obj.menuboxText,{time = 200, alpha = 0, onComplete = function () aud.play(sounds.sweep) end }) 
		transition.to (obj.menubox, {delay = 200, time = 400, yScale = obj.menubox.originYScale, xScale = obj.menubox.originXScale, alpha = 1, transition = easing.inOutQuad})
		transition.to (group_MenuChoices, {delay = 400, time = 200, x=0, transition = easing.inOutQuad, onComplete = function () menuisopen = true; display.remove(overlayRect) end })
	else 
		if e.target.id then 
			aud.play(sounds.click)

			transition.to (group_MenuChoices, {time = 400, x = _W*2, transition = easing.inOutQuad})
			transition.to (group_Logo, {time = 400, alpha = 0, transition = easing.inOutQuad})
			transition.to (c1.cellGroup, {time = 400, alpha = 0, transition = easing.inOutQuad})
			transition.to (c2.cellGroup, {time = 400, alpha = 0, transition = easing.inOutQuad})

			transition.to (obj.menubox, {delay = 200, time = 200, x= _W*2, transition = easing.inOutQuad, onComplete = function()
				choice = e.target.id
				--print (choice)
				dosomething(choice)
				display.remove(overlayRect)
			end})
		else
			display.remove(overlayRect)
		end
	end
end 


local function cleanup(choice, dontGotoScene)
	
	--print (#obj.mChoicesBox)
	local params = {}
	params.menu = choice 

	--print ("params sent "..params.menu)
	gamestarted = false
	
--	obj.sphere:removeEventListener ("tap",switch)
--	obj.menubox:removeEventListener("tap", returntrue)

	display.remove(tutorialButton)
	display.remove(kreditsButton)
	for i = 1, #obj.mChoicesBox do 
		display.remove (obj.mChoicesBox[i]) 
		display.remove (obj.mChoices[i])
	end 
		
	display.remove (obj.background)
	display.remove (obj.menubox)
	display.remove (obj.menuboxText)
	display.remove (obj.logo)
	display.remove (obj.stepTiles)
	display.remove (obj.sphere)
	display.remove (obj.shadow)

	display.remove (obj.vial_shadow)
	display.remove (obj.vial_inside)
	display.remove (obj.vial_glow)
	display.remove (obj.vial)


	display.remove (group_Vial)
	transition.cancel(spheretrans)
	transition.cancel(secondSheretrans)
	transition.cancel(shadowSpheretrans)
	transition.cancel(secondShadowSpheretrans)
	transition.cancel(vialtrans)
	transition.cancel(secondvialtrans)
	transition.cancel(vialshadowtrans)
	transition.cancel(secondvialshadowtrans)
	
	if c1 then
		display.remove (c1.cellGroup)
		c1 = nil
	end
	if c2 then
		display.remove (c2.cellGroup)
		c2 = nil
	end

	local scenelist = {"worldPicker","tutorialMenu","options","customMenu"}


	if not dontGotoScene then
		timer.performWithDelay (5, function ()
			print "leaving"
			for k,v in pairs(params) do
				print("params!"..k,v)
			end
			composer.gotoScene(scenelist[choice],{params = params})
		end ) 
	end
	transition.cancel(varTransition1)
	transition.cancel(varTransition2)

	Runtime:removeEventListener("enterFrame", onEveryFrame)
end 

function dosomething(e)
	choice = e 

	if choice == 1 then 
		--print "goto level select"
		
	end 
	if choice == 2 then 
		--print "goto level select:User"
	end 
	if choice == 3 then 
		--print "goto Options"
	end 
	if choice == 4 then 
		--print "goto leveledit"
	end 

	
	cleanup(choice)

end

local model = system.getInfo('model')

if model == 'ipad' or model == 'iPad' then
	model = 'ipad'
else
	model = 'iphone'
end


obj.background = display.newRect (group_Background,0,0,_W,_H)
	obj.background.x = _W/2
	obj.background.y = _H/2
	obj.background:setFillColor(0,0,0)
	obj.background.alpha = 0 

obj.stepTiles = display.newImageRect (group_Logo,"Graphics/Logo/startscreen_tiles_ipad.png", 1536, 2048)
	obj.stepTiles.xScale, obj.stepTiles.yScale = 0.22, 0.22
	obj.stepTiles.x = _W*0.5
	obj.stepTiles.y = _H - obj.stepTiles.height*obj.stepTiles.yScale*0.5


	local cell = require("cell")
	c1 = cell.new(_W/2,_H/2,{1,1,0},{1,1,0},1)
	c2 = cell.new(_W/2,_H/2,{1,0,0},{1,0,0},1)
	c1.cellGroup.alpha = 0
	c2.cellGroup.alpha = 0
	group_Background:insert(c1.cellGroup)
	group_Background:insert(c2.cellGroup)

-- Set colors for sphere and make sure at least one is set... 
local r1, g1, b1 = 0,0,0
local r2, g2, b2 = 0,0,0


	
repeat
	r1 = math.random(0,1)
	g1 = math.random(0,1)
	b1 = math.random(0,1)
until r1 == 1 or g1 == 1 or b1 == 1 

	repeat 
		repeat
			repeat
			r2 = math.random(0,1)
			g2 = math.random(0,1)
			b2 = math.random(0,1)
		until r2 == 1 or g2 == 1 or b2 == 1 
	until r2+g2+b2 ~= 3
until r1 ~= r2 


obj.shadow = display.newImageRect (group_Logo,"Graphics/Menu/sphere_shadow_white.png", 144, 49)
	obj.shadow.xScale, obj.shadow.yScale = 1, 1
	obj.shadow.x = _W*0.55
	obj.shadow.y = _H - obj.shadow.height*obj.shadow.yScale*0.8 -6
	obj.shadow:setFillColor(50*r1,50*g1,50*b1)
	--obj.shadow:setFillColor(100,100,255)
	obj.shadow.alpha = 0.6

group_Vial = display.newGroup()
obj.vial_shadow = display.newImageRect (group_Logo,"Graphics/Menu/sphere_shadow_white.png",144,49)
obj.vial_inside = display.newImageRect (group_Vial,"Graphics/Objects/vial_liquid_large.png",623,782)
obj.vial_glow = display.newImageRect (group_Vial,"Graphics/Objects/vial_glow_large.png",623,782)
obj.vial = display.newImageRect (group_Vial,"Graphics/Objects/vial_empty_faded.png",623,782)

obj.vial_glow.alpha = .5
obj.vial_inside.alpha = .8
obj.vial_glow.blendMode = "add"
obj.vial_shadow.alpha = 0.3
obj.vial:setFillColor(220,220,220)
obj.vial.alpha = 0.85

	obj.vial_shadow. x = _W*.62
	obj.vial_shadow.y = _H*.65
	obj.vial_shadow:setFillColor(40*r2,40*g2,40*b2)
	obj.vial_shadow.xScale = 0.5
	obj.vial_shadow.yScale = 0.5
	obj.vial_shadow.rotation = -20
	obj.vial_shadow:setReferencePoint(BottomLeftReferencePoint)
	--obj.vial_shadow.anchorX = 0
	--obj.vial_shadow.anchorY = 1

	obj.vial.x = _W*.5
	--obj.vial.y = _H*.59
	obj.vial.xScale = .18
	obj.vial.yScale = .18
	obj.vial.y = _H - obj.vial.height*obj.vial.yScale*1.3
	obj.vial_inside.x = _W*.5
	obj.vial_inside.y = obj.vial.y
	obj.vial_inside.xScale = .178
	obj.vial_inside.yScale = .178
	obj.vial_glow.x = _W*.5
	obj.vial_glow.y = obj.vial.y
	obj.vial_glow.xScale = .18
	obj.vial_glow.yScale = .18
	obj.vial_inside:setFillColor(255*r2,255*g2,255*b2)
	obj.vial_glow:setFillColor(255*r2,255*g2,255*b2)
group_Vial:toBack()
group_Logo:insert(group_Vial)

--group_Vial.y =  _H - obj.vial.height*obj.vial.yScale*1.1

obj.sphere = display.newImageRect (group_Logo,"Graphics/Menu/sphere.png", 200, 200)
	obj.sphere.xScale, obj.sphere.yScale = 1, 0.6
	obj.sphere.x = _W*0.5
	obj.sphere.y = _H - obj.sphere.height*obj.sphere.yScale*0.9

	local yval = obj.sphere.y
	--obj.sphere.y = yval + 10 
	
	obj.sphere:setFillColor(255*r1,255*g1,255*b1)
	obj.sphere.alpha = 0.85
	
	local function sphereScale()
	
			spheretrans = transition.to(obj.sphere, {time=1000,xScale=.75,yScale = .7, y = yval ,transition = easing.inOutQuad,onComplete=function()
			secondSheretrans= transition.to(obj.sphere, {time=1000, xScale=0.85, yScale = .6,transition = easing.inOutQuad})
		end})
			shadowSpheretrans = transition.to(obj.shadow, {time=1000,xScale=.9,yScale = 1.1,transition = easing.inOutQuad,onComplete=function()
			secondShadowSpheretrans = transition.to(obj.shadow, {time=1000, xScale=1,yScale = 1.3,transition = easing.inOutQuad,onComplete=sphereScale})
		end})
	end
	
	local function vialScale()
			vialtrans = transition.to (group_Vial,{ time = 1500,y = 10, transition = easing.inOutQuad, onComplete = function()
			secondvialtrans = transition.to (group_Vial,{ time = 1500,y = -10, transition = easing.inOutQuad,onComplete=vialScale}) 
		end })
	end 

	local function vialShadowScale()
				vialshadowtrans = transition.to (obj.vial_shadow,{ time = 1500,x = obj.vial_shadow.x -20,y = obj.vial_shadow.y+ 5, xScale = 0.5, yScale = 0.5,transition = easing.inOutQuad, onComplete = function()
			secondvialshadowtrans = transition.to (obj.vial_shadow,{ time = 1500,x = obj.vial_shadow.x+ 20,y = obj.vial_shadow.y -5,  xScale = 0.6, yScale = 0.6,transition = easing.inOutQuad,onComplete=vialShadowScale}) 
		end })
	end

	vialScale()
	sphereScale()
	vialShadowScale()






obj.logo = display.newImageRect (group_Logo,"Graphics/Logo/findthecure_title.png", 1360, 842)
	obj.logo.xScale, obj.logo.yScale = 0.22, 0.22
	obj.logo.x = _W*0.5
	obj.logo.y = _H*0.22

	group_Logo.alpha = 0
	
			local function switch()
			
			print (menubool)
			if menuisopen then 
				menubool = not menubool
				aud.play(sounds.sweep)
				if menubool then 
					
					transition.to (obj.menuboxText,{time = 200,x = -_W - _W/2, alpha = 1}) 
					transition.to (group_MenuChoices, {time = 200,x = _W * 2, transition = easing.inOutQuad})
					transition.to (group_Menubox, {delay = 200,time = 200,x = _W * 2, transition = easing.inOutQuad})
				else 
					transition.to (obj.menuboxText,{time = 200, alpha = 0}) 
					transition.to (group_MenuChoices, {time = 200, x = 0, transition = easing.inOutQuad})
					transition.to (group_Menubox, {delay = 200, time = 200,x = 0, transition = easing.inOutQuad})
				end 
			end 
		end


	obj.logo:addEventListener('tap', switch)



	--obj.logo:setFillColor(200,0,0)

local choicelist = {"Play", "Tutorial", "Options", "Custom Levels"}

local bigBoxSize

for i = 1,#choicelist do

	local boxBg = {}
		boxBg.path = 'Graphics/Menu/large_btn_fill.png'
		boxBg.width = 768
		boxBg.height = 190
		boxBg.xScale = (_H / 190)*0.09
		boxBg.yScale = boxBg.xScale
		boxBg.alpha = 1

		bigBoxSize = {x = boxBg.width*boxBg.xScale*1.2, y = boxBg.height*boxBg.yScale*5.5}

		if i == 1 then
			boxBg.color = _G.playColor
		elseif i == 2 then
			boxBg.color = _G.continueColor
		elseif i == 3 then
			boxBg.color = _G.mainMenuColor
		elseif i == 4 then
			boxBg.color = _G.levelSelectColor
		end

	local boxFg = {}
		boxFg.path = 'Graphics/Menu/large_btn_texture.png'
		boxFg.width = 768
		boxFg.height = 190
		boxFg.xScale = boxBg.yScale
		boxFg.yScale = boxFg.xScale
		boxFg.alpha = 1

	local onEnded
		
	if (i ~= 4) or (choicelist[4] and _G.customLevelsEnabled) then
		onEnded = startgame
	else
		obj.mChoices[i].alpha = 0.25

		local lockedImage = display.newImageRect(group_MenuChoices, 'Graphics/Objects/lock_small.png', 256, 310)
		lockedImage.x, lockedImage.y = obj.mChoices[i].x, obj.mChoices[i].y
		lockedImage.xScale, lockedImage.yScale = 0.1, 0.1
	end

	obj.mChoicesBox[i] = createButton({x = _W/2, y = _H*.45 + (_H*.105)*i, onEnded = onEnded, bg = boxBg, fg = boxFg, buttonParams = {id = i}})

	boxBg = obj.mChoicesBox[i].bg
	boxFg = obj.mChoicesBox[i].fg

	group_MenuChoices:insert(obj.mChoicesBox[i])

	obj.mChoices[i] = display.newText (group_MenuChoices, choicelist[i],0,0,systemfont,20)
		obj.mChoices[i].x = _W/2
		obj.mChoices[i].y = _H*.45 + (_H*.105)*i

	group_MenuChoices.x = _W*2
end 

--

obj.menubox = display.newImageRect(group_Menubox, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
		obj.menubox:setReferencePoint(display.CenterReferencePoint)
		--obj.menubox.anchorX = .5
		--obj.menubox.anchorY = .5
		obj.menubox.x = _W*.5
		obj.menubox.y = _H*.7
		obj.menubox.alpha = 0.01
		obj.menubox.xScale = .1
		obj.menubox.yScale = .04
		obj.menubox.originXScale = bigBoxSize.x / 1032
		obj.menubox.originYScale = bigBoxSize.y / 1032
		print(bigBoxSize.x / 1032)
		print(bigBoxSize.y / 1032)

obj.playButton = display.newRect(group_Menubox, 0, 0, _W, _H)
		obj.playButton.x, obj.playButton.y = _W*.5, _H*.5
		obj.playButton.alpha = 0.01
		obj.playButton:addEventListener('tap', startgame)



obj.menuboxText = display.newText(group_Menubox, "Start", 0,0,systemfont,40)
		obj.menuboxText.x = _W*.5
		--obj.menuboxText.y = _H*.75
		obj.menuboxText.y = _H - obj.menuboxText.height*obj.menuboxText.yScale*2.2

local function returntrue()
	return true
end 

obj.sphere:addEventListener ("tap", switch)
obj.menubox:addEventListener("tap", returntrue)


if beenthere then
	startgame()
	--group_Logo.y = 0
	group_Menubox.x = _H*2
	obj.background.alpha = 0.8
else 

	group_Menubox.x = _H*2
	transition.to (obj.background, {delay = 400, time = 1000, alpha = .8, transition = easing.inOutQuad})
end 
	--group_Logo.y = -_H
transition.to (group_Logo, {time = 500, alpha = 1, transition = easing.inOutQuad})
transition.to (group_Menubox, {time = 500, x = 0, transition = easing.inOutQuad})


--- functions dealing with cell animation.
------------------------------------------

local cellAnimation

local function cellRepat()
	timer.performWithDelay(500, cellAnimation)
end

function cellAnimation()
	c1.faceCell(c2)
	c2.faceCell(c1)
	-- Set up color (not the same...)
	firstColor = c1.randomizeColor()
	repeat 
		secondColor =  c2.randomizeColor()
	until firstColor ~= secondColor

	-- set up new scale
	scale = math.random(3,8)
	c1.cellGroup.xScale = scale/10
	c1.cellGroup.yScale = scale/10
	c2.cellGroup.xScale = scale/10
	c2.cellGroup.yScale = scale/10


	-- if scale == 8 then
	-- 	c1.cellGroup:toFront()
	-- 	c2.cellGroup:toFront()
	-- else
	-- 	c1.cellGroup:toBack()
	-- 	c2.cellGroup:toBack()
	-- end

	-- Setup postions again
	yStart1 = math.random(50,_H/3)
	yStart2 = math.random(50,_H/3)
	yEnd1 = math.random(50,_H/3)
	yEnd2 =  math.random(50,_H/3)

	c1.cellGroup.x = -_W/4
	c2.cellGroup.x = _W*5/4
	c1.cellGroup.y = yStart1
	c2.cellGroup.y = yStart2

	-- set up time
	local time1 = 9000 - 1000*math.random(3,scale)
	local time2 = 9000 - 1000*math.random(3,scale)

	local function completeFunction1() 
		if time1 >= time2 then
			cellAnimation()
		end
	end

	local function completeFunction2() 
		if time1 < time2 then
			cellAnimation()
		end
	end

	c1.cellGroup.alpha = 1
	c2.cellGroup.alpha = 1

	varTransition1 = transition.to(c2.cellGroup,{time = time1, x = -_W/4, y = yEnd1, onComplete = completeFunction1})
	varTransition2 = transition.to(c1.cellGroup,{time = time2, x = _W*5/4, y = yEnd2, onComplete = completeFunction2})
end


timer.performWithDelay(100, cellAnimation)

local function onEveryFrame( event )
	if c1 and c2 then
		c2.updateColors(c1)
	end
end




Runtime:addEventListener("enterFrame", onEveryFrame)




-- end functions cell anmination.
------------------------------------------



end

function scene:show (e)
end

function scene:hide (e)

end

function scene:destroy (e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene