local composer 		= require "composer"
local tenflib 		= require "tenfLib"
local aud 			= require "audioo"
local scene 		= composer.newScene()

function scene:create(event)
	local sceneView = self.view
	local music = tenflib.jsonLoad("music.txt")
	local sound = tenflib.jsonLoad("sound.txt")

	local themeColor = {0,128,255}
	local foregroundGroup = display.newGroup()
	sceneView:insert(foregroundGroup)

	local sliders = {}
	local bgGroup
	local tenfingersBadge
	local coronaBadge
	local onBack
	local onCoronaTap
	local onTenFingersTap
	local onReset
	local onKredits
	local resetData
	local kreditsButton

	backdrop = require 'background'
	Runtime:addEventListener('enterFrame', backdrop.animateglow)
	sceneView:insert(backdrop)
	backdrop:toBack()

	bgRect = display.newImageRect(foregroundGroup, "Graphics/Menu/menu_backdrop.png", 1032, 1032)
	bgRect.x, bgRect.y = _W*.5,_H*.27
	bgRect.xScale, bgRect.yScale = (_W / 1032)*0.9, (_H / 1032)*0.5
	bgRect:setFillColor(unpack(themeColor))

	bgRect2 = display.newImageRect(foregroundGroup, "Graphics/Menu/menu_backdrop.png", 1032, 1032)
	bgRect2.x, bgRect2.y = _W*.5,_H*.74
	bgRect2.xScale, bgRect2.yScale = (_W / 1032)*0.9, (_H / 1032)*0.4
	bgRect2:setFillColor(unpack(themeColor))

	local headline = display.newText(foregroundGroup, 'Options', 0, 0, systemfont, _G.mediumLargeFontSize)
	headline.x, headline.y = _W*0.5, _H*0.08

	local function beforeLeaving(time, callback, e, noTransitions)
		bgGroup:removeEventListener('tap', onBack)
		coronaBadge:removeEventListener('tap', onCoronaTap)
		tenfingersBadge:removeEventListener('tap', onTenFingersTap)
		resetData:removeEventListener('tap', onReset)
		kreditsButton:removeEventListener('tap', onKredits)

		for k,v in pairs(sliders) do
			v:removeEventListener('tap', sliderFunc)
		end

		if not noTransitions then
			aud.play(sounds.sweep)
			transition.to(backdrop, {time = time or 150, alpha = 0, transition = easing.inOutQuad})
			transition.to(foregroundGroup, {time = time or 150, y = _H*1.2, alpha = 0, transition = easing.inOutQuad, onComplete = function()
				callback(e)
			end})
		end
	end

	local function goBack(e)
		composer.gotoScene('startscreen')
	end

	function onBack(e)
		if not e.target.clicked then
			e.target.clicked = true
			aud.play(sounds.click)
			beforeLeaving(150, goBack, e)
		end
	end

	bgGroup = {}--display.newGroup()

	backButtonFill = {}--display.newImageRect (bgGroup,'Graphics/Menu/small_btn_fill.png',384,190)
	backButtonFill.path = 'Graphics/Menu/small_btn_fill.png'
	backButtonFill.width = 384
	backButtonFill.height = 190
	backButtonFill.color = themeColor
	backButtonFill.xScale, backButtonFill.yScale = .25,.25

	backButton = {}--display.newImageRect (bgGroup,'Graphics/Menu/small_btn_texture.png',384,190)
	backButton.path = 'Graphics/Menu/small_btn_texture.png'
	backButton.width = 384
	backButton.height = 190
	backButton.xScale, backButton.yScale = .25,.25

	backGroupText = {}--display.newText(bgGroup,"Back",0,0,systemfont,_G.mediumFontSize)
	backGroupText.text = 'Back'
	backGroupText.font = systemfont
	backGroupText.fontSize = _G.mediumFontSize

	bgGroup.bg = backButtonFill
	bgGroup.fg = backButton
	bgGroup.text = backGroupText
	bgGroup.x, bgGroup.y = _W*.75,_H*.43
	bgGroup.onEnded = onBack

	bgGroup = createButton(bgGroup)

	foregroundGroup:insert(bgGroup)

	local function gotoKredits(e)
		timer.performWithDelay (5,function ()
			composer.gotoScene('kredits')
		end )
	end

	function onKredits(e)
		timer.performWithDelay (5, function ()
			aud.stopmusic(backgroundmusic)
			aud.play(sounds.click)
			beforeLeaving(150, gotoKredits, e)
		end)
	end

	kreditsButton = {}--display.newGroup()

	local bg = {}--display.newImageRect(kreditsButton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
	bg.path = 'Graphics/Menu/small_btn_fill.png'
	bg.width = 384
	bg.height = 190
	bg.xScale, bg.yScale = 0.25, 0.25
	bg.x, bg.y = 0, 0
	bg.color = _G.continueColor

	local fg = {}--display.newImageRect(kreditsButton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
	fg.path = 'Graphics/Menu/small_btn_texture.png'
	fg.width = 384
	fg.height = 190
	fg.xScale, fg.yScale = 0.25, 0.25
	fg.x, fg.y = 0, 0

	local text = {}--display.newText(kreditsButton, 'Credits', 0, 0, systemfont, _G.mediumFontSize)
	text.text = 'Credits'
	text.font = systemfont
	text.fontSize = _G.mediumFontSize
	text.x, text.y = 0, 0

	kreditsButton.bg = bg
	kreditsButton.fg = fg
	kreditsButton.text = text
	kreditsButton.x, kreditsButton.y = _W*0.25, _H*0.43
	kreditsButton.onEnded = onKredits

	kreditsButton = createButton(kreditsButton)

	foregroundGroup:insert(kreditsButton)

	local versionText = display.newText(foregroundGroup, 'Version ' .. _G.appVersion, 0, 0, systemfont, _G.mediumSmallFontSize)
	versionText.x, versionText.y = _W*0.02 + versionText.width*versionText.xScale*0.5, _H*0.99 - versionText.height*versionText.yScale*0.5

	local function completedNow(event)
		if event.index == 1 then
			local filesToRemove = {'state.txt','stateuser.txt','whereWasI','recentMove.txt'}

			for k,v in pairs(filesToRemove) do
				local result, reason = os.remove(system.pathForFile(v, system.DocumentsDirectory))
				-- print('Result: ', result)
				-- print('Reason: ', reason)
			end

			native.showAlert('Reset complete!', 'The user data has now been deleted.', {'Ok'})
		end
	end

	function onReset(e)
		native.showAlert('Warning!', 'Are you sure you wish to delete your user data? (this will not affect custom levels)', {'Yes', 'No'}, completedNow)
	end

	resetData = display.newText(foregroundGroup, 'Reset User Data', 0, 0, systemfont, _G.mediumFontSize)
	resetData.x, resetData.y = _W*0.5, _H*0.32
	resetData:addEventListener('tap', onReset)

	function onTenFingersTap(e)
		system.openURL('http://findthecure.10fingers.se/')
	end

	tenfingersBadge = display.newGroup()

	local producedBy = display.newText(tenfingersBadge, 'Developed by', 0, 0, systemfont, _G.mediumSmallFontSize)
	producedBy.y = producedBy.height*producedBy.yScale*0.45

	local badge = display.newImageRect(tenfingersBadge, 'Graphics/Logo/logotyp_10F_inverted_small.png', 381, 116)
	badge.x, badge.y = 0, producedBy.height*producedBy.yScale*0.45 + badge.height*badge.yScale*0.25
	badge.xScale, badge.yScale = 0.4, 0.4

	producedBy.x = badge.x + badge.width*badge.xScale*0.5 - producedBy.width*producedBy.xScale*0.5

	tenfingersBadge.x, tenfingersBadge.y = _W*0.5, _H*0.65 - tenfingersBadge.height*tenfingersBadge.yScale*0.5
	tenfingersBadge:addEventListener('tap', onTenFingersTap)
	foregroundGroup:insert(tenfingersBadge)

	function onCoronaTap(e)
		system.openURL('http://coronalabs.com/')
	end

	coronaBadge = display.newImageRect(foregroundGroup, 'Graphics/Menu/coronasdk_sdklogo_small.png', 512, 96)
	coronaBadge.xScale, coronaBadge.yScale = 0.47, 0.47
	coronaBadge.x, coronaBadge.y = _W*0.5, _H*0.85
	coronaBadge:addEventListener('tap', onCoronaTap)

	function sliderFunc(e)
		local volume = e.target.x *0.00625

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
					print(volume)
				else
					
                    aud.play(sounds.move, true)
                    aud.setsoundvolume(volume)
					globalsoundvolume = volume
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

		local sliderBg = display.newRoundedRect(sliderGroup, 0, 0, 160, 5, 2)
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

	local soundText = display.newText(foregroundGroup, 'Sound', 0, 0, systemfont, _G.mediumFontSize)
	soundText.x, soundText.y = _W*0.2, _H*0.16

	local soundText = display.newText(foregroundGroup, 'Music', 0, 0, systemfont, _G.mediumFontSize)
	soundText.x, soundText.y = _W*0.2, _H*0.26

	local soundSlider = createSlider('sound')
	soundSlider.x, soundSlider.y = _W*0.35, _H*0.165

	local musicSlider = createSlider('music')
	musicSlider.x, musicSlider.y = _W*0.35, _H*0.265

	if sound then
		soundSlider.fg.x = sound.sound*soundSlider.bg.width
	end

	if music then
		musicSlider.fg.x = music.music*musicSlider.bg.width
	end

	foregroundGroup.y = _H
	aud.play(sounds.sweep)
	transition.to(foregroundGroup, {time = 150, y = 0, transition = easing.inOutQuad})
end

function scene:show( event )

end

function scene:hide( event )
	local screen = self.view
	Runtime:addEventListener('enterFrame', backdrop.animateglow)
	package.loaded['background'] = nil
end

function scene:destroy( event )

end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene