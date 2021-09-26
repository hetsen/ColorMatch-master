
local hud 			= {}
local hudGroup 		= display.newGroup()
local tenflib 		= require "tenfLib"
local gamelogic		= require "gamelogic"
local listView		= require "listView"
local json 			= require "json"
local lfs			= require "lfs"
local aud 			= require "audioo"
local menu 			= require "menu"
local _W 			= display.viewableContentWidth
local _H 			= display.viewableContentHeight
local colorHolder
local bucketRed
local bucketGreen
local bucketBlue
local bucketRedOnTop
local bucketGreenOnTop
local bucketBlueOnTop
local bucketGroup 		= display.newGroup()
local GameBoard, BoardState
local red
local green
local blue

local holderRect
local holderCircle 

local holderIn
local holderOut

local saveBoxIn
local saveBoxOut
local colors
local replayButton
local replaySaveBox
local LoadButton
local doc_path 			= system.pathForFile("", system.DocumentsDirectory )
local selectFile 		= nil
local directionCount	= 0
local mainMenuGroup		= display.newGroup()
local menuBox
local menuMainButton
local copyFile
local FindName
local loadedReplay
local levelSelectButton
local levelSelectText
local replayButtonText
local mainMenuButtonText
local LoadButtonText
local removeListeners
local replayRect 
local bottomButton
local facebookButton
local twitterButton
local mailButton
local ftcLogo
local socialHudGroup 	= display.newGroup()
local socialHudBackgroundGroup 	= display.newGroup() -- This one for enabling transparcy between multiple display objects (Jeto 130816)

local minus = achSaves.fortyTwo
ach.savefourTwo( minus-minus )

local id = 0
local marked = display.newRect(0,0,200,40)
	local hudX = 30
	local hudSpacing = 30 
local thatReturnTrueRect
marked:setFillColor(0,255,0,100)
marked:setReferencePoint(display.TopCenterReferencePoint)
--marked.anchorX = .5
--marked.anchorY = 0
marked.isVisible = false

hudGroup:insert(bucketGroup)

function hud.createHud(GameBoard,group) 
	

	function hud.returntrue(e)
		return true
	end 
--[[
	function hud.postthingsFacebook(event)
		local function sendFb(event)
			local choice = event.index
			if choice == 1 then
				transition.to(socialHudGroup,{time=10,y=823472398})
				timer.performWithDelay(100,social.sendfbAppCapture("filename.jpg","I need help on "..GameBoard.Name))
				-- print("Your choice is: "..choice)
			elseif choice == 2 then
				-- print("Your choice is: "..choice)
			end
		end

		local alert = native.showAlert( "Ask for help on Facebook?", "", { "Yes", "No" }, sendFb )
	end

	function hud.postthingsTweet(event)
		local function sendTweet(event)
			local choice = event.index
			if choice == 1 then
				social.sendTweetAppCapture("filename2.jpg","I need help on "..GameBoard.Name)
				-- print("Your choice is: "..choice)
			elseif choice == 2 then
				-- print("Your choice is: "..choice)
			end
		end

		local alert = native.showAlert( "Ask for help on Twitter?", "", { "Yes", "No" }, sendTweet )
	end

	function hud.postthingsMail(event)
		local function sendMail(event)
			local choice = event.index
			if choice == 1 then
				-- print("I will send mail now....")
				ftcLogo.alpha = 1
				hud.socialHudFunc()
				-- print("Your choice is: "..choice)
				timer.performWithDelay(150,function()
					social.sendMailAppCapture("filename3.jpg","","I need help in the mobile game Find the Cure.","I am stuck on level "..GameBoard.Name)
				end)

				timer.performWithDelay(250,function()
					ftcLogo.alpha = 0
				end)

			elseif choice == 2 then
				-- print("Your choice is: "..choice)
			end
		end

		local alert = native.showAlert( "Ask for help through mail?", "", { "Yes", "No" }, sendMail )
	end
]]--

	colorHolder = display.newImageRect(hudGroup,"Graphics/UI/hud_panel_compact.png",320,107)
	holderUntap = display.newRect(hudGroup,0,0,320,65)
	holderUntap:toBack()
	holderUntap.alpha =.005
	holderUntap:addEventListener("tap",function()
		return true
	end)
	holderUntap:addEventListener("touch",function()
		return true
	end)
	
	thatReturnTrueRect = display.newRect(0,0,_W,_H)

	thatReturnTrueRect.alpha = 0.5
	transition.to(thatReturnTrueRect, {time=100, alpha=0})
	timer.performWithDelay(100,function()

		thatReturnTrueRect.alpha = 0.0
		thatReturnTrueRect.x = _W
		thatReturnTrueRect:addEventListener("touch",hud.returntrue)
		thatReturnTrueRect:addEventListener("tap",hud.returntrue)
	end)
	
	colorHolder:toBack()
	colorHolder.x = _W*.5
	colorHolder.y = colorHolder.y + 40



	--Red Bucket
	bucketRedOnTop = display.newRoundedRect(bucketGroup,0,15,17,40,4)
	bucketRedOnTop:setFillColor(255,0,0)
	bucketRedOnTop.yScale = .000001
	bucketRedOnTop:setReferencePoint(display.BottomCenterReferencePoint)
	--bucketRedOnTop.anchorX = .5
	--bucketRedOnTop.anchorY = 1
	bucketRedOnTop.x,bucketRedOnTop.y = 20,45

	--Green Bucket
	bucketGreenOnTop = display.newRoundedRect(bucketGroup,0,15,17,40,4)
	bucketGreenOnTop:setFillColor(0,255,0)
	bucketGreenOnTop.yScale = .000001
	bucketGreenOnTop:setReferencePoint(display.BottomCenterReferencePoint)
	--bucketGreenOnTop.anchorX = .5
	--bucketGreenOnTop.anchorY = 1
	bucketGreenOnTop.x,bucketGreenOnTop.y = 41,45


	--Blue Bucket
	bucketBlueOnTop = display.newRoundedRect(bucketGroup,0,15,17,40,4)
	bucketBlueOnTop:setFillColor(0,0,255)
	bucketBlueOnTop.yScale = .000001
	bucketBlueOnTop:setReferencePoint(display.BottomCenterReferencePoint)
	--bucketBlueOnTop.anchorX = .5
	--bucketBlueOnTop.anchorY = 1
	bucketBlueOnTop.x, bucketBlueOnTop.y = 62,45
	

	colorMixer = display.newImage(bucketGroup,"Graphics/UI/hud_mixer.png")
	-- print("asYdas"..bucketGreenOnTop.y)
	-- print("aXsdas"..bucketGreenOnTop.x)
	colorMixer.x, colorMixer.y = 42, 44
	colorMixer.xScale, colorMixer.yScale = .35,.35

	-- Find the Cure logo for show in shared screen shot.
	ftcLogo = display.newImageRect(hudGroup, "Graphics/Logo/findthecure_logo_notentacles.png",_W*0.25, _W*0.25*279/400)
	ftcLogo:setReferencePoint(BottomRightReferencePoint)
	--ftcLogo.anchorX = 1
	--ftcLogo.anchorY = 1
	ftcLogo.x = _W*0.86
	ftcLogo.y = _H*0.93
	ftcLogo.alpha = 0

	--[[
	--Socialhud
	local socialHudShows = false
	socialHud = display.newRect(socialHudBackgroundGroup,0,0,_W,70)
	socialHud:setFillColor(50,50,50)
	--socialHud.blendMode = "add"

	--socialHud.alpha = 0.5
	socialHudButton = display.newCircle(socialHudBackgroundGroup,0,0,40)
	socialHudButton:setFillColor(50,50,50)
	--socialHudButton.blendMode = "add"
	--socialHudButton.alpha = 0.5

	socialHudGroup:insert(socialHudBackgroundGroup)
	--socialHudBackgroundGroup.alpha = 0.5

	--Facebook knapp
	facebookButton = display.newImageRect(socialHudGroup,"Graphics/UI/FB-f-Logo__white_50.png",40,40)
	--facebookButton = display.newRect(socialHudGroup,0,0,40,40)
	--facebookButton:setFillColor(0,100,255)

	--Twitter knapp
	twitterButton = display.newImageRect(socialHudGroup,"Graphics/UI/twitter-bird-dark-bgs.png",40,40)
	--twitterButton = display.newRect(socialHudGroup,0,0,40,40)
	--twitterButton:setFillColor(0,200,255)

	--Mail knapp
	mailButton = display.newImageRect(socialHudGroup,"Graphics/UI/mail_vit.png",40,30)
	--mailButton = display.newRect(socialHudGroup,0,0,40,40)
	--mailButton:setFillColor(100,0,100)

	--Socialhud settings
	twitterButton.x 	= _W*.5
	twitterButton.y 	= 20
	mailButton.x 		= _W*.85
	mailButton.y 		= 20
	facebookButton.x 	= _W*.15
	facebookButton.y 	= 20
	socialHud.y 		= socialHud.y-15
	socialHudGroup.y 	= _H*1.035
	socialHudButton.x 	= _W*.5

	socialHudGroup:addEventListener("touch",hud.returntrue)
	socialHudGroup:addEventListener("tap",hud.returntrue)
	
	hudGroup:insert(socialHudGroup)


	facebookButton:addEventListener("touch",hud.postthingsFacebook)
	facebookButton:addEventListener("tap",hud.returntrue)

	twitterButton:addEventListener("touch",hud.postthingsTweet)
	twitterButton:addEventListener("tap",hud.returntrue)

	mailButton:addEventListener("touch",hud.postthingsMail)
	mailButton:addEventListener("tap",hud.returntrue)

	function hud.socialHudFunc()
		if not socialHudShows then
			transition.to(socialHudGroup, {time=150,y=_H*.90, transition=easing.inOutQuad})
			socialHudShows = true
		else
			transition.to(socialHudGroup, {time=150,y=_H*1.035, transition=easing.inOutQuad})
			socialHudShows = false
		end
	end

	socialHudButton:addEventListener("tap",hud.socialHudFunc)

	--End socialhud.
	]]--

	local sliders = {}
	local music = tenflib.jsonLoad("music.txt")
	local sound = tenflib.jsonLoad("sound.txt")
	local foregroundGroup = display.newGroup()
	function sliderFunc(e)
		local volume = e.target.x *0.0071428571428571
		if e.phase == "moved" then
			display.getCurrentStage():setFocus(e.target)

			e.target.x = e.x - e.target.group.x

			if (e.target.x > e.target.group.bg.width) then
				e.target.x = e.target.group.bg.width
			end

			if (e.target.x < 0) then
				e.target.x = 0  
			end

			if e.target.x then
				if e.target.name == 'music' then
					aud.setmusicvolume(volume)
					globalmusicvolume = volume
					print(e.target.name.." "..volume)
				else
					
                    aud.play(sounds.move, true)
                    aud.setsoundvolume(volume)
					globalsoundvolume = volume
					print(e.target.name.." "..volume)
					
				end
			end
		elseif e.phase == "ended" then 
			display.getCurrentStage():setFocus(nil)
			if e.target.name == 'music' then
				tenflib.jsonSave( "music.txt", {music=volume})
			else
				tenflib.jsonSave( "sound.txt", {sound=volume})
			end
		end

		return true
	end

	local function createSlider(name)
		local sliderGroup = display.newGroup()

		local sliderBg = display.newRoundedRect(sliderGroup, 0, 0, 140, 5, 2)
		sliderBg.x, sliderBg.y = sliderBg.width*0.5, 0
		sliderBg.group = sliderGroup

		local sliderFg = display.newGroup()

		local sfgBack = display.newRect(sliderFg, 0, 0, 60, 112)
		sfgBack.x, sfgBack.y = 0, 0
		sfgBack.alpha = 0.01

		local sfgFront = display.newImageRect(sliderFg, 'Graphics/Menu/slider_handle.png', 40, 28)
		sfgFront.x, sfgFront.y = 0, 0

		sliderFg.xScale, sliderFg.yScale = 0.5, 0.5
		sliderFg.x, sliderFg.y = sliderBg.width, 0
		sliderFg.group = sliderGroup
		sliderFg.name = name
		sliderFg:addEventListener('touch', sliderFunc)
		sliders[#sliders+1] = sliderFg
		sliderGroup:insert(sliderFg)

		sliderGroup.bg = sliderBg
		sliderGroup.fg = sliderFg
		foregroundGroup:insert(sliderGroup)

		return sliderGroup
	end
	
	sliderMenuBox = display.newImage(mainMenuGroup,"Graphics/Menu/menu_backdrop_small.png")
	sliderMenuBox:addEventListener("tap", hud.returntrue)
	sliderMenuBox:addEventListener("touch", hud.returntrue)
	sliderMenuBox:setFillColor(0,200,255)

	sliderMenuBox.xScale = .25
	sliderMenuBox.yScale = .3


	sliderMenuBox.x, sliderMenuBox.y = 0,205
	if _G.model == "iPhone" then
		sliderMenuBox.xScale = .5
		sliderMenuBox.yScale = .55
		sliderMenuBox.y = 215
		-- print("goes here")
	end	
	local soundText = display.newText(foregroundGroup, 'Music', 0, 0, systemfont, _G.mediumFontSize)
	soundText.x, soundText.y = _W*0.2, _H*0.22

	local soundMusicText = display.newText(foregroundGroup, 'Sound', 0, 0, systemfont, _G.mediumFontSize)
	soundMusicText.x, soundMusicText.y = _W*0.2, _H*0.31

	local soundSlider = createSlider('sound')
	soundSlider.x, soundSlider.y = _W*0.35, _H*0.230


	local musicSlider = createSlider('music')
	musicSlider.x, musicSlider.y = _W*0.35, _H*0.320
	

	
	if sound then
		soundSlider.fg.x = sound.sound*soundSlider.bg.width
	end

	if music then
		musicSlider.fg.x = music.music*musicSlider.bg.width
	end


	aud.play(sounds.sweep)

	mainMenuGroup:insert(foregroundGroup)
	foregroundGroup.x = -155
	foregroundGroup.y = _W*0.1


	menuBox = display.newImageRect(mainMenuGroup,"Graphics/Menu/menu_backdrop.png", 1032, 1032)
	menuBox.alpha =0
	menuBox.y = 30
	menuBox.xScale = .25
	menuBox.yScale = .15



	--MenuGroup settings


	mainMenuGroup:setReferencePoint(display.CenterReferencePoint)
	--mainMenuGroup.anchorX = .5
	--mainMenuGroup.anchorY = .5
	mainMenuGroup.x = -_W
	mainMenuGroup.y = _H*.4

	theBox = display.newImage(mainMenuGroup,"Graphics/Menu/menu_backdrop.png",0,0)
	theBox:setFillColor(0,200,255)
	theBox.x, theBox.y = 0,-4
	theBox.xScale = .249
	theBox.yScale = .230

	topGroup = display.newGroup()
	mainMenuGroup:insert(topGroup)
	topGroup.y = 15
	levelName = display.newText(topGroup, GameBoard.Name, 0, 0, systemfont, _G.mediumLargeFontSize)
	mapLength = string.len(GameBoard.Name)
	-- print(mapLength)
	if mapLength >= 9 then
		-- print("More than 9")
		levelName.size = _G.mediumFontSize
	end
	if mapLength >= 14 then
		-- print("More than 14")
		levelName.size = _G.mediumSmallFontSize 
	end
	if mapLength >= 16 then
		-- print("More than 16")
		levelName.size = _G.smallFontSize 
	end
	levelName.x, levelName.y = 0,-115
	levelSteps = display.newText(topGroup, "Goal Moves: "..GameBoard.Steps, 0, 0, systemfont, _G.mediumSmallFontSize)
	levelSteps.x, levelSteps.y = 0,-70
	levelTime = display.newText(topGroup, "Goal Time: "..GameBoard.Time.." Seconds", 0, 0, systemfont, _G.mediumSmallFontSize)
	levelTime.x, levelTime.y = 0, -85
	
	list = tenflib.jsonLoad("state.txt",system.DocumentsDirectory)
	if _G.model == "iPhone 5" then
			soundMusicText.x, soundMusicText.y = _W*0.2, _H*0.18
			soundSlider.x, soundSlider.y = _W*0.35, _H*0.180
			soundText.x, soundText.y = _W*0.2, _H*0.27
			musicSlider.x, musicSlider.y = _W*0.35, _H*0.270
			levelName.x, levelName.y = 0,-115
			sliderMenuBox.yScale = .27
			sliderMenuBox.y = 210
	end

	
	menuBoxRect = display.newRect(mainMenuGroup,0,0,_W*2,_H*2)
	menuBoxRect.x, menuBoxRect.y = 0,0
	menuBoxRect:toBack()
	menuBoxRect:setFillColor(0,0,0)
	menuBoxRect.alpha = .5
	
	menuBoxRect:addEventListener("touch", hud.mainMenuFunc)
	menuBoxRect:addEventListener("tap",hud.returntrue)

	
	autoScrollButton = display.newGroup()

	local autoScrollButtonBg = display.newImageRect(autoScrollButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	autoScrollButtonBg.xScale, autoScrollButtonBg.yScale = 0.12, 0.12
	autoScrollButtonBg.x, autoScrollButtonBg.y = menuBox.width*menuBox.xScale*0.45 - autoScrollButtonBg.width*autoScrollButtonBg.xScale*0.5, 0

	local autoScrollButtonFg = display.newImageRect(autoScrollButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	autoScrollButtonFg.xScale, autoScrollButtonFg.yScale = 0.12, 0.12
	autoScrollButtonFg.x, autoScrollButtonFg.y = autoScrollButtonBg.x, autoScrollButtonBg.y

	local onOrOff
	local onOffText

	local function checkAutoScroll(invert)
		local loadedList = tenflib.jsonLoad('autoScroll')
		local currentScroll = true

		if invert then
			currentScroll = false
		end

		if loadedList and loadedList[1] == true then
			currentScroll = false

			if invert then
				currentScroll = true
			end
		end

		tenflib.jsonSave('autoScroll', {currentScroll})

		onOrOff = 'On'
		local onOffFillColor = {0,255,0}

		if currentScroll == false then
			onOrOff = 'Off'
			onOffFillColor = {255,0,0}
		end

		if onOffText then
			onOffText.text = onOrOff
		end

		autoScrollButtonBg:setFillColor(unpack(onOffFillColor))

		return currentScroll
	end

	checkAutoScroll(true)

	onOffText = display.newText(autoScrollButton, onOrOff, 0, 0, systemfont, _G.mediumSmallFontSize)
	onOffText.x, onOffText.y = autoScrollButtonFg.x, autoScrollButtonFg.y

	autoScrollButton.x = -28
	autoScrollButton.y = 260
	mainMenuGroup:insert(autoScrollButton)

	local function onAutoScrollToggle(e)
		timer.performWithDelay(1, function()
			checkAutoScroll()
		end)

		return true
	end

	autoScrollButton:addEventListener('tap', onAutoScrollToggle)


	autoScrollButtonText = display.newText(autoScrollButton, "Auto Scroll", 0, 0, systemfont, _G.mediumFontSize)
	autoScrollButtonText.x = autoScrollButtonText.width*autoScrollButtonText.xScale*0.5 - menuBox.width*menuBox.xScale*0.35
	autoScrollButtonText.y = 0


	menuMainButton = display.newGroup()

	local menuMainButtonBg = display.newImageRect(menuMainButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
	menuMainButtonBg.xScale, menuMainButtonBg.yScale = 0.2, 0.2
	menuMainButtonBg.x, menuMainButtonBg.y = 0, 0
	menuMainButtonBg:setFillColor(unpack(_G.mainMenuColor))

	local menuMainButtonFg = display.newImageRect(menuMainButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
	menuMainButtonFg.xScale, menuMainButtonFg.yScale = 0.2, 0.2
	menuMainButtonFg.x, menuMainButtonFg.y = 0, 0

	menuMainButton.x = menuBox.x
	menuMainButton.y = menuBox.y + menuBox.height*menuBox.yScale*0.31
	mainMenuGroup:insert(menuMainButton)


	menuMainButtonText = display.newText(mainMenuGroup,"Main Menu",0,0,systemfont,20)
	menuMainButtonText.x = menuMainButton.x
	menuMainButtonText.y = menuMainButton.y



	menuRestartButton = display.newGroup()

	local menuRestartButtonBg = display.newImageRect(menuRestartButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
	menuRestartButtonBg.xScale, menuRestartButtonBg.yScale = 0.2, 0.2
	menuRestartButtonBg.x, menuRestartButtonBg.y = 0, 0
	menuRestartButtonBg:setFillColor(unpack(_G.continueColor))

	local menuRestartButtonFg = display.newImageRect(menuRestartButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
	menuRestartButtonFg.xScale, menuRestartButtonFg.yScale = 0.2, 0.2
	menuRestartButtonFg.x, menuRestartButtonFg.y = 0, 0

	menuRestartButton.x = menuBox.x
	menuRestartButton.y = menuBox.y - menuBox.height*menuBox.yScale*0.25
	mainMenuGroup:insert(menuRestartButton)
	menuRestartButton:toFront()

	
	levelSelectButton = display.newGroup()

	local levelSelectButtonBg = display.newImageRect(levelSelectButton, 'Graphics/Menu/large_btn_fill.png', 768, 190)
	levelSelectButtonBg.xScale, levelSelectButtonBg.yScale = 0.2, 0.2
	levelSelectButtonBg.x, levelSelectButtonBg.y = 0, 0
	levelSelectButtonBg:setFillColor(unpack(_G.levelSelectColor))

	local levelSelectButtonFg = display.newImageRect(levelSelectButton, 'Graphics/Menu/large_btn_texture.png', 768, 190)
	levelSelectButtonFg.xScale, levelSelectButtonFg.yScale = 0.2, 0.2
	levelSelectButtonFg.x, levelSelectButtonFg.y = 0, 0

	levelSelectButton.x = menuBox.x
	levelSelectButton.y = menuBox.y + menuBox.height*menuBox.yScale*0.03
	mainMenuGroup:insert(levelSelectButton)


	levelSelectButton:toFront()
	levelSelectButton:addEventListener("touch",hud.menuLevelselectButtonFunc)
	levelSelectButton:addEventListener("tap",hud.returntrue)

	--Map restart - text
	levelSelectText = display.newText(mainMenuGroup,"Level Select",0,0,systemfont,20)
	levelSelectText.x = levelSelectButton.x
	levelSelectText.y = levelSelectButton.y

	--Go to level select - text
	menuRestartButtonText = display.newText(mainMenuGroup,"Restart Level",0,0,systemfont,20)
	menuRestartButtonText.x = menuRestartButton.x
	menuRestartButtonText.y = menuRestartButton.y
	menuMainButton:addEventListener("touch",hud.menuMainButtonFunc)
	menuRestartButton:addEventListener("touch",hud.menuRestartButtonFunc)
	menuRestartButton:addEventListener("tap",hud.returntrue)


	--Plus pic
	plusminusFitting = display.newImage(bucketGroup,"Graphics/UI/hud_btn_fitting_compact.png",0,0)
	plusminusFitting.xScale, plusminusFitting.yScale = .6,.6
	plusminusFill = display.newImage(bucketGroup,"Graphics/UI/hud_btn_fill_compact.png",0,0)
	plusminusFill.xScale, plusminusFill.yScale = .6,.6
	plusButton = display.newImage(bucketGroup,"Graphics/UI/hud_btn_plus_compact.png",0,0)
	plusButton.x = plusButton.width+120
	plusButton.y = bucketRedOnTop.y-17
	plusButton.xScale = .6
	plusButton.yScale = .6
	--Minus pic
	minusButton = display.newImage(bucketGroup,"Graphics/UI/hud_btn_minus_compact.png",260,15)
	minusButton.x = plusButton.x
	minusButton.y = bucketRedOnTop.y-17
	minusButton.xScale = .01
	minusButton.yScale = .6
	minusButton.alpha = 0

	
	plusminusFill.x, plusminusFill.y = plusButton.x, plusButton.y
	plusminusFitting.x, plusminusFitting.y = plusminusFill.x, plusminusFill.y
	bottomButton = display.newImage(bucketGroup, 'Graphics/UI/hud_btn_menu_compact.png',0,0)
	bottomButton.xScale,bottomButton.yScale = .6,.6
	bottomButton.x, bottomButton.y =  plusminusFill.x+bottomButton.width*1.05, plusminusFill.y
	bottomButtonFitting = display.newImage(bucketGroup,"Graphics/UI/hud_btn_fitting_compact.png",0,0)
	bottomButtonFitting.xScale, bottomButtonFitting.yScale = .6,.6
	bottomButtonFitting.x, bottomButtonFitting.y = bottomButton.x, bottomButton.y

	bottomButton:addEventListener("touch", hud.mainMenuFunc)


	plusButton:addEventListener("tap", plusMinus)
	minusButton:addEventListener("tap", plusMinus)
	plusButton:addEventListener("touch", hud.returntrue)
	minusButton:addEventListener("touch", hud.returntrue)

	replayRect = display.newRect(0,0,_W,_H)
	replayRect.alpha=0
	replayRect:toFront()
	replayRect:addEventListener("touch",function()
		return true
	end)
	replayRect:addEventListener("tap",function()
		return true
	end)
	if aReplay then
		replayRect.alpha=.01
		aReplay=nil
	end
end

function hud.updateScore(score) -- uppdaterar score

end 


function hud.replayFunc(event)

end


function hud.name(_callback)

end


function hud.findReplays(GameBoard,loadedReplay)

end 

function hud.inTarget(e)
	local x, y = e.target:localToContent(0, 0)

	if e.x > x - e.target.width*e.target.xScale*0.5
	and e.x < x + e.target.width*e.target.xScale*0.5
	and e.y > y - e.target.height*e.target.yScale*0.5
	and e.y < y + e.target.height*e.target.yScale*0.5
	then
		return true
	else
		return false
	end
end


--Map restart function
function hud.menuRestartButtonFunc(event)
	if event.phase == "began" then
		display.getCurrentStage():setFocus(event.target)
		menuRestartButton.alpha = .2
	elseif event.phase == "ended" then
		if hud.inTarget(event) then
			menuRestartButton.alpha = .5
			menuMainButton:removeEventListener("touch",hud.menuMainButtonFunc)
			levelSelectButton:removeEventListener("touch",hud.menuLevelselectButtonFunc)
			levelSelectButton:removeEventListener("tap",hud.returntrue)
			menuRestartButton:removeEventListener("touch",hud.menuRestartButtonFunc)
			menuRestartButton:removeEventListener("tap",hud.returntrue)
			thatReturnTrueRect.alpha = .02
			
			startover()
		else
			menuRestartButton.alpha = 1
		end

		display.getCurrentStage():setFocus(nil)
	end
	return true
end

--Go to main menu function
function hud.menuMainButtonFunc(event)
	if event.phase == "began" then
		display.getCurrentStage():setFocus(event.target)
		menuMainButton.alpha = .2
	elseif event.phase == "ended" then
		if hud.inTarget(event) then
			menuMainButton.alpha = .5
			menuMainButton:removeEventListener("touch",hud.menuMainButtonFunc)
			aud.stopmusic()
			aud.disposemusic()
		
			menuMainButton:removeEventListener("touch",hud.menuMainButtonFunc)
			levelSelectButton:removeEventListener("touch",hud.menuLevelselectButtonFunc)
			levelSelectButton:removeEventListener("tap",hud.returntrue)
			menuRestartButton:removeEventListener("touch",hud.menuRestartButtonFunc)
			menuRestartButton:removeEventListener("tap",hud.returntrue)
			thatReturnTrueRect.alpha = .02
			timer.performWithDelay(5,function ()
			goToMain()
			end )
		else
			menuMainButton.alpha = 1
		end

		display.getCurrentStage():setFocus(nil)
	end
	return true
end

--Go to levelselect
function hud.menuLevelselectButtonFunc(event)
	if event.phase == "began" then
		display.getCurrentStage():setFocus(event.target)
		levelSelectButton.alpha = .2
	elseif event.phase == "ended" then
		if hud.inTarget(event) then
			levelSelectButton.alpha = .5
			menuMainButton:removeEventListener("touch",hud.menuMainButtonFunc)
			levelSelectButton:removeEventListener("touch",hud.menuLevelselectButtonFunc)
			levelSelectButton:removeEventListener("tap",hud.returntrue)
			menuRestartButton:removeEventListener("touch",hud.menuRestartButtonFunc)
			menuRestartButton:removeEventListener("tap",hud.returntrue)
			thatReturnTrueRect.alpha = .02
			aud.stopmusic()
			aud.disposemusic()
			goToLevelSelect()
		else
			levelSelectButton.alpha = 1
		end

		display.getCurrentStage():setFocus(nil)
	end
	return true
end

--Function for buckets, increases and decreases. 
function hud.setBuckets(colors,maxAmount) -- hämtar färgvärden och visar dom i buckets på skärmen
	print (colors)
	colors = colors or {0,0,0}
	local markerCol = gamelogic.getMarkerColor()
	height = 1/maxAmount 
		transition.to (bucketRedOnTop, {time = 200, yScale = (height*colors[1])+.000001, transition = easing.inOutQuad })
		transition.to (bucketGreenOnTop, {time = 200, yScale = (height*colors[2])+.000001, transition = easing.inOutQuad })
		transition.to (bucketBlueOnTop, {time = 200, yScale = (height*colors[3])+.000001, transition = easing.inOutQuad })
		ach.saveColorsAch( colors )
end

--This is the goalcolor
function hud.setGoalColor(color)
	id = id + 1
	red = color.GoalColor.r
	green = color.GoalColor.g
	blue = color.GoalColor.b
	-- print(color.MarkerColorMaxSegments)
	if color.MarkerColorMaxSegments == 1 then
		colorSegments = display.newImage(bucketGroup,"Graphics/UI/hud_scale1_compact.png",0,0)
		colorSegments.x, colorSegments.y = bucketRedOnTop.x+bucketRedOnTop.width+4, bucketRedOnTop.y-bucketRedOnTop.height*.5+1
		colorSegments.xScale, colorSegments.yScale = .55,.56
	elseif color.MarkerColorMaxSegments == 2 then 
		colorSegments = display.newImage(bucketGroup,"Graphics/UI/hud_scale2_compact.png",0,0)
		colorSegments.x, colorSegments.y = bucketRedOnTop.x+bucketRedOnTop.width+4, bucketRedOnTop.y-bucketRedOnTop.height*.5+1
		colorSegments.xScale, colorSegments.yScale = .55,.56
	elseif color.MarkerColorMaxSegments == 3 then
		colorSegments = display.newImage(bucketGroup,"Graphics/UI/hud_scale3_compact.png",0,0)
		colorSegments.x, colorSegments.y = bucketRedOnTop.x+bucketRedOnTop.width+4, bucketRedOnTop.y-bucketRedOnTop.height*.5+1
		colorSegments.xScale, colorSegments.yScale = .55,.56
	elseif color.MarkerColorMaxSegments == 4 then
		colorSegments = display.newImage(bucketGroup,"Graphics/UI/hud_scale4_compact.png",0,0)
		colorSegments.x, colorSegments.y = bucketRedOnTop.x+bucketRedOnTop.width+4, bucketRedOnTop.y-bucketRedOnTop.height*.5+1
		colorSegments.xScale, colorSegments.yScale = .55,.56
	end

	_G.goalColor = display.newImage(bucketGroup,"pics/marker.png",0,0)
	goalColor.x, goalColor.y = colorMixer.x+75,bucketRedOnTop.y-15
	goalColor.xScale, goalColor.yScale = .45,.45
	goalColor:setFillColor(red,green,blue)
	goalColor.id = id
	
	_G.startBgEyes = {}

	for i = 1,2 do
		local eyeGroup = display.newGroup()

		startBgEyes[i] = display.newGroup()
	
		startBgEyes[i].dotGroup = display.newGroup()
		startBgEyes[i]:insert(startBgEyes[i].dotGroup)
		startBgEyes[i].white = display.newImageRect(startBgEyes[i], "Graphics/Objects/eye_sclera.png", 36, 36)
		startBgEyes[i].dotWhite = display.newCircle(startBgEyes[i].dotGroup, 0, 0, 18)
		startBgEyes[i].dotWhite.alpha = 0
		startBgEyes[i].dot = display.newImageRect(startBgEyes[i].dotGroup, "Graphics/Objects/eye_pupil.png", 36, 36)
	
		startBgEyes[i].white.xScale = goalColor.xScale--*0.9
		startBgEyes[i].white.yScale = goalColor.yScale--*0.9
		
	
		startBgEyes[i].white.y = 0
	
		startBgEyes[i].dotGroup.xScale, startBgEyes[i].dotGroup.yScale = goalColor.xScale, goalColor.yScale
		startBgEyes[i]:toFront()
		startBgEyes[i].dotGroup:toFront()
		if i == 1 then
			eyeGroup.x = goalColor.x - goalColor.width*goalColor.xScale*0.155
		else
			eyeGroup.x = goalColor.x + goalColor.width*goalColor.xScale*0.155
		end


	
		startBgEyes[i].dot.x = startBgEyes[i].white.x
		startBgEyes[i].dot.y = startBgEyes[i].white.y + startBgEyes[i].white.height*startBgEyes[i].white.yScale*0.5


		eyeGroup.y = goalColor.y - goalColor.height*goalColor.yScale*0.15
		eyeGroup:insert(startBgEyes[i])
		bucketGroup:insert(eyeGroup)

	end

	function hud.moveEyes(e)
		if e.x and e.y and e.time then
			for i = 1, 2 do
				local x, y = goalColor:localToContent(0, 0)
				local rotation = 180 - math.deg(math.atan2(x - e.x, y - e.y))
				startBgEyes[i].dotGroup.rotation = (startBgEyes[i].dotGroup.rotation % 360)

				local dist = math.abs(x - e.x) + math.abs(y - e.y)

				if dist <= 25 then
					startBgEyes[i].dot.y = startBgEyes[i].white.y + startBgEyes[i].white.height*startBgEyes[i].white.yScale*0.02*dist
				else
					startBgEyes[i].dot.y = startBgEyes[i].white.y + startBgEyes[i].white.height*startBgEyes[i].white.yScale*0.5
				end

				if rotation + startBgEyes[i].dotGroup.rotation > 360 then
					startBgEyes[i].dotGroup.rotation = startBgEyes[i].dotGroup.rotation - 360
				end

				startBgEyes[i].dotGroup.rotation = rotation
			end
		end
	end

	Runtime:addEventListener('markerMoved', hud.moveEyes)



	
end 


function hud.plusMinusFunc()
		state = gamelogic.addDelColor()
		if state.AddingColor == false then 
			transition.to(minusButton, {delay=80, time=80, xScale=1, alpha=0})
			transition.to(plusButton, {time=80, xScale=.5, alpha=0})
		else 
			transition.to(minusButton, {time=80, xScale=.01, alpha=0})
			transition.to(plusButton, {time=80, xScale=.5, alpha=1})
		end 
		return true
	end



function hud.mainMenuFunc(event)
	print(event.phase)
	
	if event.phase == "ended" then
		if not mainMenuGroup.isShown then
			local completeFun1 = function ()
				transition.to(menuBoxRect, {time = 100, alpha = 0.7 })
			end
			transition.to(mainMenuGroup, {time=100,x=_W/2,transition = easing.inOutQuad,onComplete = completeFun1})
			-- if saveBoxGroup.x == _W/2 then
			-- 	transition.to(mainMenuGroup, {time=100,x=_W/2,transition = easing.inOutQuad})
			-- 	--transition.to(saveBoxGroup, {time=200,x=_W/2*4,transition = easing.inOutQuad})
			-- end
			bottomButton:setFillColor(127)
			mainMenuGroup.isShown = true
		else
		--if mainMenuGroup.x == _W/2 then
			bottomButton:setFillColor(255)
			local completeFun2 = function ()
				transition.to(mainMenuGroup, {time=100,x=-_W/2*4,transition = easing.inOutQuad})
			end
			transition.to(menuBoxRect, {time = 100, alpha = 0,  onComplete = completeFun2})
			
			mainMenuGroup.isShown = false
		end
	end
	return true	
end

function hud.mainMenuFunc2()
		
		if not mainMenuGroup.isShown then
			local completeFun1 = function ()
				transition.to(menuBoxRect, {time = 100, alpha = 0.7 })
			end
			transition.to(mainMenuGroup, {time=100,x=_W/2,transition = easing.inOutQuad,onComplete = completeFun1})
			bottomButton:setFillColor(127)
			mainMenuGroup.isShown = true
		else
			bottomButton:setFillColor(255)
			local completeFun2 = function ()
				transition.to(mainMenuGroup, {time=100,x=-_W/2*4,transition = easing.inOutQuad})
			end
			transition.to(menuBoxRect, {time = 100, alpha = 0,  onComplete = completeFun2})
			
			mainMenuGroup.isShown = false
		end
	
	return true	
end

function hud.removeListeners()
	mainMenuGroup:removeEventListener("tap", hud.returntrue)
	mainMenuGroup:removeEventListener("touch", hud.returntrue)
	plusButton:removeEventListener("tap", plusMinus)
	minusButton:removeEventListener("tap", plusMinus)
	plusButton:removeEventListener("touch", hud.returntrue)
	minusButton:removeEventListener("touch", hud.returntrue)
	levelSelectButton:removeEventListener("touch",hud.menuLevelselectButtonFunc)
	levelSelectButton:removeEventListener("tap",hud.returntrue)
	menuMainButton:removeEventListener("touch",hud.menuMainButtonFunc)
	menuRestartButton:removeEventListener("touch",hud.menuRestartButtonFunc)
	menuRestartButton:removeEventListener("tap",hud.returntrue)
	if loadSelectedFile ~= nil then
		LoadButton:removeEventListener("tap",loadingFunction)
	else
	end
	mainMenuButton:removeEventListener("tap",hud.mainMenuFunc)
	holderCircle:removeEventListener("tap",hud.theScroll)
	holderCircle:removeEventListener("touch",hud.returntrue)
	holderRect:removeEventListener("touch",hud.returntrue)
	Runtime:removeEventListener('markerMoved', hud.moveEyes)
end

function hud.nilItAll()
	if params.worldName then
		tenflib.jsonSave('theWorld', {params.worldName})
	end
	theWorld = tenflib.jsonLoad('theWorld',system.DocumentsDirectory)
	
	-- print("This is it: "..theWorld[1])
	if theWorld[1] == "Find the Cure" then
		world = "se.10fingers.findthecure.defaultList"

	elseif theWorld[1] == "Glistening Tides" then
		world = "se.10fingers.findthecure.GlisteningTides"

	end
	
	ach.postHighscore(world, theWorld[1]) -- Posts highscore to GameCenter
	
	transition.to(bucketGroup,{time=1,alpha=0})
	transition.to(hudGroup,{time=300,alpha=0})
	transition.to(mainMenuGroup,{time=300,alpha=0})
	transition.to(bottomButton, {time=300,alpha=0})
	timer.performWithDelay(305,function()
	end)
	


	timer.performWithDelay(302, function()
		display.remove(replayRect)
		display.remove(mainMenuGroup)
		display.remove(bucketGroup)
		display.remove(thatReturnTrueRect)
		thatReturnTrueRect = nil
		display.remove(hudGroup)
	end)
	GameBoard, BoardState = nil, nil
	red, green, blue = nil, nil, nil
end

function hud.dontFail()
	returntrueRect = display.newRect(0,0,display.contentWidth,display.contentHeight)
	returntrueRect.alpha = .01
	returntrueRect:addEventListener("tap",hud.returntrue)
	returntrueRect:addEventListener("touch",hud.returntrue)
	theTimer = timer.performWithDelay(2500,function()
		display.remove(returntrueRect)
		returntrueRect:removeEventListener("tap",hud.returntrue)
		returntrueRect:removeEventListener("touch",hud.returntrue)
		timer.cancel(theTimer)
	end)
end

aud.play(sounds.sweep)

return hud