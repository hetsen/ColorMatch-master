local composer 	= require "composer"
local json 			= require "json"
local tenflib 		= require "tenfLib"
local aud = 		require "audioo"

--composer.purgeOnSceneChange = true
composer.recycleOnSceneChange = true
local scene 		= composer.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight
local dialogGroup
local button 		= {}
local counter = 0 
local countUpTimer
--print "endgame"
local skipp = false
local pressedskip = false
local cleanupDone = false
local backdrop
local ip5 = false 

if ( (display.pixelHeight/display.pixelWidth) > 1.5 ) then
   	ip5 = true 
end

function scene:create(e)
	params = e.params

	if not params then
		params= {win=true}
	end 



		local star = {}

		local totscore = 0
		local percentage = 0
		local mDif = 0
		local tDif = 0

		if params.win == true then 
			if params.thislevel.replay == false then   
				totscore = math.round(params.thislevel.totalscore)
				percentage = math.round(params.thislevel.percentage)
				mDif = math.round(params.thislevel.movedifference)
				tDif = math.round(params.thislevel.timedifference)
				first = params.thislevel.firstObjective
				second = params.thislevel.secondObjective
				third = params.thislevel.thirdObjective

			else 
			end 
		end 


	local function cleanUp()
		if cleanupDone == false then
			print"cleanup"
			display.remove(topText)
			display.remove(leveltext)
			display.remove(leveltext3)
			display.remove(leveltext4)
			display.remove(pointtext1)
			display.remove(pointtext2)
			display.remove(pointtext3)
			display.remove(pointtextR1)
			display.remove(pointtextR2)
			display.remove(pointtextR3)
			display.remove(pointtextRL1)
			display.remove(pointtextRL2)
			display.remove(pointtextRL3)
			display.remove(totalpointtext)
			display.remove(dialogueobj)
			Runtime:removeEventListener("enterFrame", backdrop.animateglow)
			package.loaded['background'] = nil
			display.remove(backdrop)

			for i = 1,3 do 
				display.remove(star[i])
			end 

			for i = 1,4 do 
				display.remove(button[i].text)
				display.remove(button[i])
			end 
			
			display.remove(dialogGroup)
			cleanup = nil
			params = e.params
			cleanupDone = true
		else
			print"Already deleted!"
		end
	end 

	local function findNextLevel(level)
		local currentWorld = 'Find the Cure'

		for k,v in pairs(_G.worldsUnlocked) do
			if string.sub(level, 1, #k) == k then
				currentWorld = k
			end
		end

		local worldName = currentWorld
		
		p.worldName = currentWorld

		if currentWorld == 'Find the Cure' then
			print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA')
			currentWorld = 'level'
		end

		local lastone = false
		if _G.lockdown then 
			print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!lockdown"
			print(currentWorld)
			print("------")
			print(level)
			local page = tonumber(string.sub(level,(#currentWorld + 2),(#currentWorld + 2)))
			local level = tonumber(string.sub(level,(#currentWorld + 4),(#currentWorld + 5)))

			print (page,level)

			local levelnumber = (page-1)*16 + level

			print ("level number.."..levelnumber)
			print (levelnumber > _G.lockdownWorldLimit[worldName])

			if levelnumber >= _G.lockdownWorldLimit[worldName] -1 then 
				lastone = true 
				aud.stopmusic()
				return "kredits"
			end 
		end

		if not lastone then
			if string.sub(level, (#currentWorld + 2), (#currentWorld + 2)) == '8' then
				if string.sub(level, (#currentWorld + 4),(#currentWorld + 5)) == '16' then
					aud.stopmusic()
					return 'kredits'
				
				else
					local addOne = (tonumber(string.sub(level, (#currentWorld + 4),(#currentWorld + 5))) + 1)
					if addOne < 10 then
						addOne = '0' .. addOne
					end

					return string.sub(level, 1, (#currentWorld + 3)) .. addOne
				end
			else
				if string.sub(level, (#currentWorld + 4),(#currentWorld + 5)) == '16' then
					return currentWorld .. ' ' .. (tonumber(string.sub(level, (#currentWorld + 2), (#currentWorld + 2))) + 1) .. '-01'
				else
					local addOne = (tonumber(string.sub(level, (#currentWorld + 4),(#currentWorld + 5))) + 1)

					if addOne < 10 then
						addOne = '0' .. addOne
					end

					return string.sub(level, 1, (#currentWorld + 3)) .. addOne
				end
			end
		end 

	end

	local function taphandler(e)
		local clicked = e.target.id
				aud.play(sounds.click)	

			Runtime:removeEventListener("enterFrame", backdrop.animateglow)
			Runtime:removeEventListener("tap",skip)
			package.loaded['background'] = nil

		params.win = false 
		



		if clicked == 1 then 
			_G.loadingScreen.alpha = 1
			_G.loadingScreen:toFront()
			transition.to (dialogGroup, {time = 50, x = -_W*2, transition = easing.inOutQuad})
			transition.to (topText, {time = 200, alpha = 0 })
			transition.to (backdrop, {time = 200, alpha = 0, transition = easing.inOutQuad})
			aud.halfvolume(false)

			timer.performWithDelay(200, function () cleanUp() end )	
			timer.performWithDelay(206, function () params.list=nil,composer.gotoScene("emptyscene",{params = params}); end )
		
		elseif clicked == 2 then
			transition.to (dialogGroup, {time = 50, x = -_W*2, transition = easing.inOutQuad})
			transition.to (topText, {time = 200, alpha = 0 })
			transition.to (backdrop, {time = 200, alpha = 0, transition = easing.inOutQuad})
			aud.halfvolume(false)
			timer.performWithDelay(200, function () cleanUp() end )	
			timer.performWithDelay(206, function ()
				params.level = findNextLevel(params.level)
				params.replay = true

				if params.level == 'kredits' then
					composer.gotoScene("kredits",{effect = "fade",time = 400,params = params})
				else
					composer.gotoScene("menu",{effect = "fade",time = 400,params = params})
				end
			end)
		
		elseif clicked == 4 then 
			transition.to (dialogGroup, {time = 50, x = -_W*2, transition = easing.inOutQuad})
			aud.stopmusic()
			aud.disposemusic()
			timer.performWithDelay(200, function () cleanUp() end )	
			timer.performWithDelay(206, function () composer.gotoScene("menu",{effect = "fade",time = 400,params = params}) end )
		elseif clicked == 3 then
			e.target.touchLock = true
			native.showAlert('Replay saved!', '', {'Ok'})
			transition.to(button[3].text, {time=100, alpha=.2})
			transition.to(button[3], {time=100, alpha=.5})
			aud.stopmusic()
			aud.disposemusic()
			copyFile = tenflib.jsonLoad("recentMove.txt")
			tenflib.jsonSave(params.level.." replay",copyFile)
		end
	end

	dialogGroup = display.newGroup()
	pageN = 0
	local last = composer.getSceneName("previous")
	
	if last then 
		composer.removeScene(last)
	end 
	
	local function makemenu()
		aud.halfvolume(true)

		backdrop = require 'background'
		
		Runtime:addEventListener("enterFrame", backdrop.animateglow) 
		topText = display.newText (" ",0,0,systemfont,_G.largeFontSize)
		topText.x = _W*.5
		topText.y = _H*.06

		if params.win == true then 
			topText.text = "Win"
		else
			topText.text = "Fail"
		end 

		dialogueobj = display.newImageRect(dialogGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
					dialogueobj.xScale, dialogueobj.yScale = (_W / 1032)*0.9, (_H / 1032)*0.85
					--dialogueobj:setReferencePoint(display.CenterReferencePoint)
					dialogueobj.anchorX = .5
					dialogueobj.anchorY = .5
					dialogueobj.x = _W*.5
					dialogueobj.y = _H*.52
					dialogueobj:setFillColor(200/255,255/255,255/255)

			leveltext = display.newText (dialogGroup,"Your Score",0,0,systemfont,_G.mediumLargeFontSize)
				leveltext.x = _W*.5
				leveltext.y = _H*.15
			leveltext3 = display.newText (dialogGroup,"Colors Grabbed",0,0,systemfont,_G.mediumFontSize)
				leveltext3.x = _W*.1 + leveltext3.width*0.5
				leveltext3.y = _H*.24
			leveltext4 = display.newText (dialogGroup,"Step Bonus",0,0,systemfont,_G.mediumFontSize)
				leveltext4.x = _W*.1 + leveltext4.width*0.5
				leveltext4.y = _H*.36
			leveltext5 = display.newText (dialogGroup,"Time Bonus",0,0,systemfont,_G.mediumFontSize)
				leveltext5.x = _W*.1 + leveltext5.width*0.5
				leveltext5.y = _H*.48

		local function countUp(text, score, doneEvent, pre, app)
			local cntr = 0 
			local cntr2 = 0 
			text.originX = text.x + text.width*0.5

			for i = 1, score do
	
				countUpTimer = timer.performWithDelay((i*600)/score, function()
				aud.play (sounds.countup1)

					text.text = tonumber(text.text) + 1
					text.x = text.originX - text.width*0.5
					if i == math.round(score) then
						text.text = text.text .. app
						if doneEvent then
							doneEvent()
						end
					end
				end)
			end

			if score <= 0 then
				if doneEvent then
					doneEvent()
				end
			end
		end

		local function showHighScoreText()
			local highScoreStamp = display.newImageRect(dialogGroup, 'Graphics/Objects/highscore.png', 302, 300)
			highScoreStamp.x, highScoreStamp.y = _W*0.5, _H*0.4
			highScoreStamp.rotation = -20
			highScoreStamp.alpha = 0
			highScoreStamp.xScale, highScoreStamp.yScale = 1.5, 1.5

			local highScoreStampBack = display.newImageRect(dialogGroup, 'Graphics/Objects/highscore.png', 302, 300)
			highScoreStampBack.x, highScoreStampBack.y = _W*0.5, _H*0.4
			highScoreStampBack.rotation = -20
			highScoreStampBack.alpha = 0
			highScoreStampBack.xScale, highScoreStampBack.yScale = 0.7, 0.7
			highScoreStampBack:toBack()

			aud.play(sounds.highscore)

			transition.to(highScoreStamp, {delay = 940, time = 50, alpha = 1, xScale = 0.7, yScale = 0.7, onComplete = function()
				highScoreStampBack.alpha = 1
				transition.to(highScoreStamp, {time = 1000, delay = 1000, alpha = 0})
			end})
		end
		
		local function counter4()
		
		 	pointtextRL3 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
		 	pointtextRL3.text = tDif*60
		 	pointtextRL3.x = _W*.63 + pointtextRL3.width*0.5
		 	pointtextRL3.y = _H*.52
		
		 	totalpointtext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
		 	totalpointtext.text = "" .. totscore
		 	totalpointtext.alpha = 0 
		 	totalpointtext.x = _W*.63 + totalpointtext.width*0.5
		 	totalpointtext.y = _H*.61
		 	transition.to (totalpointtext, {time = 400, delay = 500, alpha = 1})
		
		 	totalpointHeadlinetext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
		 	totalpointHeadlinetext.text = "Total Score"

			if params.newHighScore then
				totalpointHeadlinetext.text = "High Score"
			end
					
		 	totalpointHeadlinetext.alpha = 0 
		 	totalpointHeadlinetext.x = _W*.1 + totalpointHeadlinetext.width*0.5
		 	totalpointHeadlinetext.y = _H*.61
		 	transition.to (totalpointHeadlinetext, {time = 400, delay = 500, alpha = 1, onComplete = function ()

		 	for i=1,4 do
		 		if (i ~= 2) or (i == 2 and not params.isUserLevel) then
			 		transition.to (button[i].text, {time = 50, alpha = 1})
			 		transition.to (button[i], {time = 50, alpha = 1})
			 	else
			 		button[1].x = _W*0.5
			 		--button[1].text.x = _W*0.5
			 	end
		 	end 
		 	
		 	if params.win then 
		 		print "SKIP?"
		 		print (pressedskip)
		 	if not pressedskip then 
		 	skipActive = false
		 		taptap = true 
		 		print "Removing Listener C4"
		 		skiprect.x = _W*3
		 			startrans1 = transition.to (star[1],{time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[1],{time = 150,xScale = .6, yScale = .6}); aud.play(sounds.star1) end})
		 			
		 			local stars = 1
		 			ach.saveStars( stars )

		 		if second then 

		 			local stars = 1
		 			ach.saveStars( stars )

		 			startrans2 = transition.to (star[2],{delay = 300,time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[2],{time = 150,xScale = .6, yScale = .6}); aud.play(sounds.star2) end})
		 			
		 		end 
		 		if third then 

		 			local stars = 1
		 			ach.saveStars( stars )

		 			startrans3 = transition.to (star[3],{delay = 500,time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[3],{time = 150,xScale = .6, yScale = .6}); aud.play(sounds.star3); end})
		 			
		 		end
			 				
				timer.performWithDelay(800, function()
					
					if params.newHighScore then
						showHighScoreText()
					end

					for i = 1, 4 do
						button[i].touchLock = false--:addEventListener("tap", taphandler)
					end
				end)
		 	end 
		 	end 

		 	end })

		

		 end 

		local function counter3()
			countUp(pointtext3,tDif,nil,"","")

			pointtextRL3 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
			pointtextRL3.text = tDif*60
			pointtextRL3.x = _W*.63 + pointtextRL3.width*0.5
			pointtextRL3.y = _H*.52
		
		 	totalpointtext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
		 	totalpointtext.text = "" .. totscore
		 	totalpointtext.alpha = 0 
		 	totalpointtext.x = _W*.63 + totalpointtext.width*0.5
		 	totalpointtext.y = _H*.61
		 	transition.to (totalpointtext, {time = 400, delay = 500, alpha = 1})
		
			totalpointHeadlinetext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
			totalpointHeadlinetext.text = "Total Score"

			if params.newHighScore then
				totalpointHeadlinetext.text = "High Score"
			end

			totalpointHeadlinetext.alpha = 0 
			totalpointHeadlinetext.x = _W*.1 + totalpointHeadlinetext.width*0.5
			totalpointHeadlinetext.y = _H*.61
			transition.to (totalpointHeadlinetext, {time = 400, delay = 500, alpha = 1, onComplete = function ()

		 	for i=1,4 do 
		 		if (i ~= 2) or (i == 2 and not params.isUserLevel) then
			 		transition.to (button[i].text, {time = 50, alpha = 1})
			 		transition.to (button[i], {time = 50, alpha = 1})
			 	else
			 		button[1].x = _W*0.5
			 	end
		 	end 
		 		
		 		if params.win then 
		 			if not pressedskip then 
		 			skipActive = false
		 			print "Removing Listener C3"
		 			skiprect.x = _W*3

		 			local stars = 1
		 			ach.saveStars( stars )

		 			startrans1 = transition.to (star[1],{time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[1],{time = 150,xScale = .6, yScale = .6}) aud.play(sounds.star1) end})
			 		
			 		if second then

		 			local stars = 1
		 			ach.saveStars( stars )

			 		startrans2 = transition.to (star[2],{delay = 300,time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[2],{time = 150,xScale = .6, yScale = .6}) aud.play(sounds.star2) end})
			 		end 
			 		if third then 

		 			local stars = 1
		 			ach.saveStars( stars )
			 			
			 		startrans3 = transition.to (star[3],{delay = 500,time = 100,xScale = 1,yScale = 1,alpha = 1,onComplete=function() transition.to(star[3],{time = 150,xScale = .6, yScale = .6}) aud.play(sounds.star3) end})
			 		end 
			 		
					timer.performWithDelay(800, function()
						if params.newHighScore then
							showHighScoreText()
						end
							if skipActive == false then
								
								for i = 1, 4 do
									buttons = true
									button[i].touchLock = false--:addEventListener("tap", taphandler)
								end
							end
					end)
		 		end 
		 		end 
		 	end })

			pointtextRL2 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
			pointtextRL2.text = mDif*250
			if mDif == 42 then
				print"Lol"
				ach.savefourTwo( mDif )
			end
			pointtextRL2.x = _W*.63 + pointtextRL2.width*0.5
			pointtextRL2.y = _H*.40
		end

		local function counter2()
			
			if mDif > 0 then
				countUp(pointtext2,mDif,counter3,"","")
			else	
				countUp(pointtext3,tDif,counter4,"","")
				pointtextRL2 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
				pointtextRL2.text = mDif*250
					if mDif == 42 then
						print"Lol"
						ach.savefourTwo( mDif )
					end
				pointtextRL2.x = _W*.63 + pointtextRL2.width*0.5
				pointtextRL2.y = _H*.40
			end

			pointtextRL = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
			pointtextRL.text = percentage*10
			pointtextRL.x = _W*.63 + pointtextRL.width*0.5
			pointtextRL.y = _H*.28
		end
			
			pointtext = display.newText (dialogGroup,"0",0,0,systemfont,_G.mediumFontSize)
				pointtext.x = _W*.24 + pointtext.width*0.5
				pointtext.y = _H*.28
				pointtext.originX = pointtext.x + pointtext.width*0.5
			pointtextR = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
				pointtextR.text = "% x 1000 = "
				pointtextR.x = _W*.62 - pointtextR.width*0.5
				pointtextR.y = _H*.28
			pointtext2 = display.newText (dialogGroup,"0",0,0,systemfont,_G.mediumFontSize)
				pointtext2.x = _W*.33 + pointtext2.width*0.5
				pointtext2.y = _H*.40
			pointtextR2 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
				pointtextR2.text = "x 250 = "
				pointtextR2.x = _W*.62 - pointtextR2.width*0.5
				pointtextR2.y = _H*.40
			pointtext3 = display.newText (dialogGroup,"0",0,0,systemfont,_G.mediumFontSize)
				pointtext3.x = _W*.365 + pointtext3.width*0.5
				pointtext3.y = _H*.52
			pointtextR3 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
				pointtextR3.text = "x 60 = "
				pointtextR3.x = _W*.62 - pointtextR3.width*0.5
				pointtextR3.y = _H*.52

				if percentage > 0 then
					countish = timer.performWithDelay(500,function() countUp(pointtext,percentage,counter2,"","") end )

				else	
					timer.performWithDelay(500,function() countUp(pointtext2,mDif,counter3,"","") end )
					pointtextRL = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
					pointtextRL.text = percentage*10
					pointtextRL.x = _W*.63 + pointtextRL.width*0.5
					pointtextRL.y = _H*.28
				end

		local textlist = {"Play Again", "Continue", "Save Replay", "Level Select"}


		for i = 1,4 do 
			button[i] = display.newGroup()

			local buttonBg = {}--display.newImageRect (button[i],'Graphics/Menu/small_btn_texture.png', 384, 190)
			buttonBg.path = 'Graphics/Menu/small_btn_texture.png'
			buttonBg.width = 384
			buttonBg.height = 190
			buttonBg.xScale, buttonBg.yScale = 0.25, 0.25
			buttonBg.x, buttonBg.y = 0, 0

			if i == 1 then
				buttonBg.color = _G.playColor
			elseif i == 2 then
				buttonBg.color = _G.continueColor
			elseif i == 3 then
				buttonBg.color = _G.replayColor
			elseif i == 4 then
				buttonBg.color = _G.levelSelectColor
			end

			local buttonFg = {}--display.newImageRect (button[i],'Graphics/Menu/small_btn_texture.png', 384, 190)
			buttonFg.path = 'Graphics/Menu/small_btn_texture.png'
			buttonFg.width = 384
			buttonFg.height = 190
			buttonFg.xScale, buttonFg.yScale = 0.25, 0.25
			buttonFg.x, buttonFg.y = 0, 0

			button[i].bg = buttonBg
			button[i].fg = buttonFg
			button[i].alpha = 0

			button[i].text = {}--display.newText (dialogGroup,textlist[i],0,0,systemfont,_G.mediumSmallFontSize)
			button[i].text.text = textlist[i]
			button[i].text.font = systemfont
			button[i].text.fontSize = _G.mediumSmallFontSize

			button[i].buttonParams = {id = i}
		end

		button[1].x = _W*.5 - _W*.2
		button[1].y = _H*.85 - 53
		button[2].x = _W*.5 + _W*.2
		button[2].y = _H*.85 - 53
		button[3].x = _W*.5 - _W*.2
		button[3].y = _H*.85
		button[4].x = _W*.5 + _W*.2
		button[4].y = _H*.85

		for i = 1,4 do 
			button[i].text.alpha = 0 
			-- button[i].text.x = button[i].x
			-- button[i].text.y = button[i].y
		end 

		for i = 1,3 do 
			star[i]=display.newImageRect (dialogGroup,"Graphics/Objects/star02.png",40,40)
				star[i]:toFront()	
			star[i].xScale = .00001
			star[i].yScale = .00001
			
			star[i].alpha = 0
		end 
		if not ip5 then 
			star[1].x, star[1].y = _W*.85,_H*.28
			star[2].x, star[2].y = _W*.85,_H*.40
			star[3].x, star[3].y = _W*.85,_H*.52
		else 
			star[1].x, star[1].y = _W*.85,_H*.275
			star[2].x, star[2].y = _W*.85,_H*.395
			star[3].x, star[3].y = _W*.85,_H*.515
		end

		for i = 1, #button do
			button[i].onEnded = taphandler

			button[i] = createButton(button[i])
			dialogGroup:insert(button[i])

			button[i].touchLock = true
		end

		dialogGroup:toFront()
	end 
	
makemenu()
backdrop.alpha = 0 
dialogGroup.x = -_W*2
transition.to (dialogGroup, {time = 300, x = 0, transition = easing.inOutQuad}) 
transition.to (backdrop, {time = 500, alpha = .8, transition = easing.inOutQuad}) 


local function skip()
print "SKIP"
skipp = true
pressedskip = true 
params = e.params
skiprect:removeEventListener("tap",skip)
skiprect.x = _W * 4

if buttons then

else
	for k=1,#button do
		button[k].text.alpha = 1
	end
	for i = 1, #button do
		button[i].touchLock = false
	end
end
	for j=1,#button do
		button[j].alpha = 1
	end
	timer.cancel(countish)


local function checkcountUp()
	if countUpTimer then
		timer.cancel(countUpTimer)
		Runtime:removeEventListener("enterFrame", checkcountUp)
	end
end

Runtime:addEventListener("enterFrame", checkcountUp)

if startrans1 then 
	transition.cancel(startrans1)
end 

if startrans2 then  
	transition.cancel(startrans2)
end 

if  startrans3 then
	transition.cancel(startrans3)
end 

	-- if first then
	if params.win then 
		star[1].alpha = 1
		star[1].xScale = .6
		star[1].yScale = .6
	end
	if second then 
		star[2].alpha = 1
		star[2].xScale = .6
		star[2].yScale = .6
	end
	if third then
		star[3].alpha = 1
		star[3].xScale = .6
		star[3].yScale = .6
	end

if params.win then 
		star[1].alpha = 1
		star[1].xScale = .6
		star[1].yScale = .6
	end
	if second then 
		star[2].alpha = 1
		star[2].xScale = .6
		star[2].yScale = .6
	end
	if third then
		star[3].alpha = 1
		star[3].xScale = .6
		star[3].yScale = .6

	end

	totalpointtext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
	totalpointtext.text = "" .. totscore
	totalpointtext.x = _W*.63 + totalpointtext.width*0.5
	totalpointtext.y = _H*.61

	if totalpointHeadlinetext then 
		totalpointHeadlinetext.alpha = 0
	end
	totalpointHeadlinetext = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumLargeFontSize)
	totalpointHeadlinetext.text = "Total Score"
	totalpointHeadlinetext.alpha = 1
	if params.newHighScore then
		totalpointHeadlinetext.text = "High Score"
		local highScoreStampBack = display.newImageRect(dialogGroup, 'Graphics/Objects/highscore.png', 302, 300)
		highScoreStampBack.x, highScoreStampBack.y = _W*0.5, _H*0.4
		highScoreStampBack.rotation = -20
		highScoreStampBack.alpha = 1
		highScoreStampBack.xScale, highScoreStampBack.yScale = 0.7, 0.7
		highScoreStampBack:toBack()
	end
	totalpointHeadlinetext.x = _W*.1 + totalpointHeadlinetext.width*0.5
	totalpointHeadlinetext.y = _H*.61
	Runtime:removeEventListener("tap",skip)

 	pointtextRL3 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
 	pointtextRL3.text = tDif*60
 	pointtextRL3.x = _W*.63 + pointtextRL3.width*0.5
 	pointtextRL3.y = _H*.52

	pointtextRL2 = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
	pointtextRL2.text = mDif*250

	if mDif == 42 then
		print"Lol"
		ach.savefourTwo( mDif )
	end

	pointtextRL2.x = _W*.63 + pointtextRL2.width*0.5
	pointtextRL2.y = _H*.40

	pointtext2.text = mDif
	pointtext3.text = tDif

	pointtext.alpha=0

	pointtextNew = display.newText (dialogGroup,"0",0,0,systemfont,_G.mediumFontSize)
	pointtextNew.x = pointtext.x
	pointtextNew.y = _H*.28
	pointtextNew.text = percentage
	pointtextNew.x = pointtext.originX - pointtextNew.width*0.5

	pointtextRL = display.newText (dialogGroup,"",0,0,systemfont,_G.mediumFontSize)
	pointtextRL.text = percentage*10
	pointtextRL.x = _W*.63 + pointtextRL.width*0.5
	pointtextRL.y = _H*.28


end
timer.performWithDelay(200,function()
skiprect = display.newRect(0,0,_W,_H)
skiprect.alpha = .001

	skiprect:addEventListener("tap",skip)
end)




end

function scene:show(e)
	
end 

function scene:hide(e)

	Runtime:removeEventListener("enterFrame", backdrop.animateglow)
	package.loaded['background'] = nil
	timer.performWithDelay(100,function()
		if backdrop then
			display.remove(backdrop)
		end
	end)
end 

function scene:destroy(e)

end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
