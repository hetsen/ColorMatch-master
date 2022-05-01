local composer 	= require "composer"
local lfs			= require "lfs"
local tenflib		= require "tenfLib"
local gamelogic		= require "gamelogic"
local scene 		= composer.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight
local dialogueobj
local button 		= {}
local textlist		= {}
local displayGroup	= display.newGroup()
local backdrop
local defaultField
function scene:create(e)
	params = e.params
	--print (params.level)
	prev = composer.getSceneName("previous")()
	if prev then 
		composer.removeScene(prev)
	end 

		local function cleanupReplay()
			--print("Mur")
			display.remove(defaultField)
			display.remove(topText)
			display.remove(dialogueobj)
			for i = 1,2 do 
				display.remove(button[i].text)
				display.remove(button[i])
			end 
			display.remove(displayGroup)
			display.remove(backdrop)
		end 

		local function taphandler(e)
			local clicked = e.target.id
			params.win = false 
			transition.to (displayGroup, {time = 200, x = -_W*2, transition = easing.inOutQuad})


			if clicked == 1 then 
				transition.to (topText, {time = 200, alpha = 0 })
				timer.performWithDelay(100, function () cleanupReplay() end )	
				timer.performWithDelay(200, function () composer.gotoScene("startscreen",{params = params}) ; end )
			end 
			if clicked == 2 then 
				timer.performWithDelay(100, function () cleanupReplay() end )	
				timer.performWithDelay(200, function () composer.gotoScene("menu",{params = params}) end )
			end
			if clicked == 3 then
				timer.performWithDelay(200, function () cleanupReplay() end )
				aReplay = true
			  	timer.performWithDelay(400,gamelogic.replayTwo)
			  	for k,v in pairs(params) do
			  		--print(k,v)
			  	end
			end

		end

		function displayStuff()



			textlist = {"Main Menu", "Level Select", "Show Replay"}

			dialogueobj = display.newImageRect(displayGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
			dialogueobj.xScale, dialogueobj.yScale = 0.25, 0.3
			--dialogueobj:setReferencePoint(display.CenterReferencePoint)
			dialogueobj.anchorX = 0.5
			dialogueobj.anchorY = 0.5
			dialogueobj.x = _W*.5
			dialogueobj.y = _H*.5
			dialogueobj:setFillColor(200,255,255)

			backdrop = display.newImageRect("pics/menu_backdrop.jpg",_W*3,_H)
			backdrop.x = _W/2
			backdrop.y = _H/2
			backdrop.alpha = .8

			topText = display.newText ( "Save Replay",0,0,systemfont,_G.mediumLargeFontSize)
			topText.x = _W*.5
			topText.y = _H*.08

			instructionText = display.newText(displayGroup,"Your replay is now saved",0,0,systemfont,_G.mediumSmallFontSize)
			instructionText.x = _W*.5
			instructionText.y = _H*.3

		for i = 1,3 do 
			button[i] = display.newGroup()

			local buttonBg = display.newImageRect (button[i], 'Graphics/Menu/small_btn_fill.png', 384, 190)
			buttonBg.x, buttonBg.y = 0, 0

			if i == 1 then
				buttonBg:setFillColor(unpack(_G.mainMenuColor))
			elseif i == 2 then
				buttonBg:setFillColor(unpack(_G.levelSelectColor))
			elseif i == 3 then
				buttonBg:setFillColor(unpack(_G.replayColor))
			end

			local buttonFg = display.newImageRect (button[i], 'Graphics/Menu/small_btn_texture.png', 384, 190)
			buttonFg.x, buttonFg.y = 0, 0
			displayGroup:insert(button[i])

			button[i].xScale, button[i].yScale = 0.25, 0.25
			button[i].text = display.newText (displayGroup,textlist[i],0,0,systemfont,_G.mediumSmallFontSize)
			button[i].id = i
		end  
			button[1].x = _W*.5 + _W*.2
			button[1].y = _H*.74
			button[2].x = _W*.5 - _W*.2
			button[2].y = _H*.74
			button[3].x = _W*.5
			button[3].y = _H*.5
		for i = 1,3 do 
			button[i].text.x = button[i].x
			button[i].text.y = button[i].y
			button[i]:addEventListener("tap", taphandler)
		end 
	end

		
	 
	

		function saveReplay(_callback)

		end
			displayStuff()
			--backdrop.alpha = 0 
			displayGroup.x = -_W*2
			saveReplay()
			displayGroup:toFront()

			transition.to (displayGroup, {time = 300, x = 0, transition = easing.inOutQuad}) 
			transition.to (backdrop, {time = 500, alpha = .8, transition = easing.inOutQuad}) 
	end


function scene:show(e)
end 

function scene:hide(e)
end 

function scene:destroy(e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene






