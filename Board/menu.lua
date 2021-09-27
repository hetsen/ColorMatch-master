local composer 	= require "composer"
local gamelogic 	= require "gamelogic"
local tenflib 		= require "modules.tenfLib"
local aud = 		require "audioo"
composer.purgeOnSceneChange = true
local scene 		= composer.newScene()
local _W 			= display.contentWidth
local _H 			= display.contentHeight
local m 			= {}
local num 
local doc_path 		
local page 			= {}
local myGroup 		= display.newGroup()
local icon			
local obj 			= {}
local pageScroller
local movescroll
local pageN = 1
local pageGroup = display.newGroup()
local listoflevelsplayed
local listofunlockedlevels
local currentlevel = {}
local dialogGroup 
local menucreated = false
local leveltext
local leveltext2
local leveltext3
local dialogueobj
local dialogButton1
local dialogButton2
local dialogButton4
local dialogtext3
local backbutton = {}
local params = {}
local dialogueactive = false
local lististrue = false
local list
p = {}
local starcounter = 0 
local star = {}
local userlevelsplayed = 0 
local usermode

local debugmode = _G.debugmode
local prev = 0

local pagePosition
local pageX 
local backdrop
local adRect
local levelTypeText
local pages


function scene:create(e)
icon = {}
backgroundmusic = "colorboard_ingame_2.mp3"

	local function unlockIcons(worldname)
		if worldname == "Find the Cure" then 
			worldname = ""
		end 
		local iconlist = tenflib.jsonLoad("state"..worldname..".txt")
		if iconlist == nil then 
			iconlist = {0}
		end 
		return #iconlist
	end

	local function pagePosition(worldname)
		if worldname == "Find the Cure" then 
			worldname = ""
		end 
		local position = tenflib.jsonLoad("whereWasI"..worldname)
		if position == nil then 
			position = {pagePosition = 1}
		end 
		return position.pagePosition
	end

	params = e.params
	p=params
	
	if params.worldName then 
		tenflib.jsonSave ("world.txt", params.worldName)
	else
		params.worldName = tenflib.jsonLoad ("world.txt")
	end 

	unlockIconNumber = unlockIcons(params.worldName)
	whichPage = pagePosition(params.worldName)

	print ("this world is called " ..params.worldName)
	print ("you're on page "..whichPage)
	print ("icons unlocked "..unlockIconNumber)

	--if e.params ~= nil then 
	--	p = e.params
	--end 
	if not tmpWorldName then 
		tmpWorldName = params.worldName
	end 

	if tmpWorldName == 'Find the Cure' then
		tmpWorldName = ''
	end

	local pagePosition = tenflib.jsonLoad("whereWasI"..tmpWorldName)

	dialogGroup = display.newGroup()
	pageN = 0
	local last = composer.getSceneName("previous")

	backdrop = require 'background'
	Runtime:addEventListener("enterFrame", backdrop.animateglow) 

	if _G.adsEnabled then
	end

	topText = display.newText ( "Level Select",0,0,systemfont,_G.mediumLargeFontSize)
	topText.x = _W*.5
	topText.y = _H*.04 + _G.adSpace


	if last then 
		composer.removeScene(last)
	end 
	
	local function onDelete(e)
		e.target.alpha = 1
		
		local deletelevel

		if e.phase == "ended" then 
			local levelstats = tenflib.jsonLoad ("stateuser.txt")

			for k,v in pairs(levelstats) do
				if v.name == currentlevel.level then
					deletelevel = k
				end 
			end 
					
			native.showAlert('Warning!', 'Are you sure you wish to delete "' .. currentlevel.level .. '"?', {'Yes', 'No'}, function(e)
				if e.index == 1 then
					
					local dir = system.DocumentsDirectory
					local result, reason = os.remove( system.pathForFile('levels/' .. currentlevel.level, dir  ) )
					
					if result then
						if levelstats[deletelevel] then
							levelstats[deletelevel].name = nil 
							levelstats[deletelevel].numStars = nil
							levelstats[deletelevel].points = nil
							levelstats[deletelevel].time = nil
							levelstats[deletelevel].pickedupcolors= nil
							levelstats[deletelevel].numberofmoves= nil

							tenflib.jsonSave ("stateuser.txt", levelstats)
						end

						gobacktomenu()
					else
						native.showAlert('Warning!', 'The file could not be deleted.', {'Ok'})
					end
				end
			end)
		end 
	end



		function m.findLevels()
			

			local levelList 	= {}
			local lfs = require "lfs"
			num = 0
			success = true 
			
				if p.menu == 1 then 
					doc_path 		= system.pathForFile( "",system.DocumentsDirectory )
					--doc_path 		= system.pathForFile( system.ResourceDirectory )
					usermode = false
					print("ResourceDirectory/New DocumentsDirectory")
				end

				if p.menu == 2 then 
					doc_path 		= system.pathForFile( "",system.DocumentsDirectory )
					usermode = true 
					print("DocumentsDirectory")
				end

				--print ("PATH"..doc_path)

			

				local success = lfs.chdir( doc_path ) -- returns true on success
				local new_folder_path

				if success then
		    			lfs.mkdir("levels")
		    			new_folder_path = lfs.currentdir() .. "/levels"
	
				end

				for file in lfs.dir(new_folder_path) do
		    		if file ~= "." then
		        		if file ~= ".." then 
		            		if file ~= ".DS_Store" then 
		                		if file ~= "bg.png" then  
		                    		if file ~= "listofgamelevels.txt" then
		                    			local worldName = p.worldName
		                    			
		                    			if worldName == nil
		                    			or (string.sub(file, 1, #worldName) ==  worldName)
		                    			or (string.sub(file, 1, 5) == 'level' and worldName == 'Find the Cure') then

		                    				--table.sort()
				                    		num = num + 1
				                    		levelList[num] = file

				                    		print("horsecock "..file)
				                    	
				                    	elseif p.menu == 2 then 
				                    	
				                    		num = num + 1
				                    		levelList[num] = file
				                    		print("horsecockTwo "..file)
				                    	end 
		                			end 
		                		end
		            		end
		        		end
		    		end
		    	end 
        		table.sort(levelList, function(a, b) return a < b end) -- sort by date of change
	    		for i=1,#levelList do
	    			print("New list "..levelList[i])
	    		end
	    		return levelList
	    		
		end 

	function m.cleanup(event)
		--removeEventListener("touch", trectlistener)
		for i = 1,#star do 
			display.remove (star[i])
		end 

		display.remove(trect)
		if #icon then 
			print ("ICON", #icon)
			for i=1,#icon do 
				icon[i]:removeEventListener("tap",m.tapEvent)
				display.remove(icon[i])
				display.remove(icon[i].t)
			end 
			icon = nil 
		end 
		display.remove(obj)
		display.remove(dialogueobj)
		display.remove(adRect)
	end 

	function m.startgame(level,list, params)
		if _G.adsEnabled then
			ads.hide()
		end
		_G.loadingScreen.alpha = 1
		_G.loadingScreen:toFront()
		params = {level = level}
		params.menu = p.menu
		params.list = list
		m.cleanup()
		timer.performWithDelay(2, function ()
			display.remove(backbutton)
			display.remove(dialogButton3)

			dialogButton1.touchLock = true
			dialogButton2.touchLock = true
			dialogButton3.touchLock = true

			dialogButton1.removeEL(dialogButton1)
			dialogButton2.removeEL(dialogButton2)
			dialogButton3.removeEL(dialogButton3)

			if usermode then
				dialogButton4.touchLock = true
				dialogButton4.removeEL(dialogButton4)
			end

			Runtime:removeEventListener("enterFrame", backdrop.animateglow)
			package.loaded['background'] = nil


			pageScroller:removeEventListener('scrollMoved', movescroll)
			display.remove(dialogGroup)
			display.remove(pageScroller)
			display.remove(backdrop)
			display.remove(topText)
			display.remove(backlogo)
			pageScroller = nil 
			--häst

			display.remove(pageScroller)
			pageScroller = nil 
		end )
		
		composer.gotoScene("controller",{params = params})
	end 

	function playgame(e)
			dialogButton1.touchLock = true
			dialogButton2.touchLock = true
			dialogButton3.touchLock = true

			e.target.alpha = 1
			local startlevel = 1

			ach.saveStarted( startlevel )

			dialogButton1.removeEL(dialogButton1)
			dialogButton2.removeEL(dialogButton2)
			dialogButton3.removeEL(dialogButton3)
			aud.play(sounds.click)

		transition.to (dialogGroup, {delay = 200,time = 200, x = -_W,transition = easing.inOutQuad, onComplete = function ()
					aud.play (sounds.sweep)
					m.startgame(currentlevel.level)

			end })
	
	end 

	function replay(e)
		dialogButton1.touchLock = true
		dialogButton2.touchLock = true
		dialogButton3.touchLock = true

		e.target.alpha = 1

		_G.loadingScreen.alpha = 1
		_G.loadingScreen:toFront()
		aud.play(sounds.click)
		for k,v in pairs(currentlevel) do
			--print(k,v)
		end
		params.level = currentlevel.level
		params.name = currentlevel.name
		params.list = isReplay
		aReplay=true
		timer.performWithDelay(800, function () m.startgame(currentlevel.level,params.list); end )
		dialogButton3:removeEventListener("touch",replay)
	end

	function gobacktomenu()
		backbutton.touchLock = true

		backgroundmusic = "colorboard_ingame_2.mp3"
		aud.playmusic(backgroundmusic)
		backbutton.removeEL(backbutton)
		aud.play(sounds.click)
		aud.play (sounds.sweep)
		transition.to (pageGroup, {time = 200, x = _W * 2, transition = easing.inOutQuad})
		transition.to (topText, {time = 200, y = -_H, transition = easing.inOutQuad})
		transition.to (backbutton,{time = 200, alpha = 0 })
		transition.to (backbutton.text,{time = 200, alpha = 0 })
		transition.to (obj, {time = 300, x = _W*2,transition = easing.inOutQuad, onComplete = function ()
		
			m.cleanup()
			
			if menucreated then 
				menucreated = false 
				timer.performWithDelay(2, function ()
					dialogButton1.removeEL(dialogButton1)
					dialogButton2.removeEL(dialogButton2)
					dialogButton3.removeEL(dialogButton3)

					if usermode then
						dialogButton4.touchLock = true
						dialogButton4.removeEL(dialogButton4)
					end

					display.remove(dialogGroup)
				end )
			end

			Runtime:removeEventListener("enterFrame", backdrop.animateglow)
			package.loaded['background'] = nil
			
			pageScroller:removeEventListener('scrollMoved', movescroll)
			display.remove(pageScroller)
			display.remove(backdrop)
			display.remove(topText)
			levelList = nil 
			pageScroller = nil 
			row	= nil
			col = nil 
			pageN = nil 
			display.remove(pageScroller)
			display.remove(backbutton.text)
			display.remove(backbutton)
			display.remove(backlogo)
			if _G.adsEnabled then
				ads.hide()
			end
				--print "Going back to startscreen"

			if p.menu == 2 then
				composer.gotoScene("customMenu")
			else
				composer.gotoScene("worldPicker")
			end

		end })

	end 

	function goback(e)
		dialogButton1.touchLock = true
		dialogButton2.touchLock = true
		dialogButton3.touchLock = true

		e.target.alpha = 1

		trect.x = _W*5
		backgroundmusic = "colorboard_ingame_2.mp3"
		aud.playmusic(backgroundmusic)
		aud.play(sounds.click)
		dialogueactive = false 
		transition.to (dialogGroup, {delay = 200,time = 200, x = -_W,transition = easing.inOutQuad, onComplete = function ()
			transition.to (pageGroup, {time = 300, alpha=1})

			transition.to (topText, {time = 300, y = _H*.04 + _G.adSpace, transition = easing.inOutQuad})
			transition.to (obj, {time = 300, x = _W*.5,transition = easing.inOutQuad})
			transition.to (backbutton, {time = 200, alpha = 1})
			transition.to (backbutton.text, {time = 200, alpha = 1})
						aud.play (sounds.sweep)

			end})
		--print "going back"
	end 


	function leveldialogue(level)
		dialogueactive = true 
		local hardness = {"One Segment","Two Segments", "Three Segments", "Four Segments", "Five Segments", "Emil"}

		for k,v in pairs(level) do
			print(k,v)
		end

		for k,v in pairs(currentlevel) do
			print(k,v)
		end

		if menucreated then
	
			leveltext.text = currentlevel.name
			leveltext.xScale = (_W*0.5) / leveltext.width
			leveltext.yScale = leveltext.xScale

			if leveltext.xScale > 1 then
				leveltext.xScale, leveltext.yScale = 1, 1
			end
			print "CURRENTLEVEL "
			print (currentlevel.level)
			
			
			if listoflevelsplayed then 
					thelevel = nil 
				for i = 1,#listoflevelsplayed do 
				if listoflevelsplayed[i].name == currentlevel.level then 
					print "FOUND"
					for k,v in pairs(listoflevelsplayed[i]) do
						print(k,v)
					end
					thelevel = i
				end 
			end
			end 
			if thelevel then 
				currentlevel.points = listoflevelsplayed[thelevel].points
			else 
				
				currentlevel.points = 0 
			end  

			print (currentlevel.points)

			leveltext2.text = hardness[currentlevel.hard]
			leveltext3.text = "High Score : "..currentlevel.points
			leveltext4.text = "Goal Time : "..currentlevel.Time.." Seconds"
			leveltext5.text = "Goal Moves : "..currentlevel.Steps
			isReplay = tenflib.jsonLoad(currentlevel.level.." replay")
			if isReplay then
				dialogButton3.alpha = 1
				dialogtext3.alpha = 1
			else
				dialogButton3.alpha = 0
				dialogtext3.alpha = 0
			end
		end 

		if not menucreated then
			

			dialogGroup:toFront()
			
			dialogueobj = display.newImageRect(dialogGroup, 'Graphics/Menu/menu_backdrop.png', 1032, 1032)
				dialogueobj.xScale, dialogueobj.yScale = (_W / 1032)*0.8, (_H / 1032)*0.78
				dialogueobj:setReferencePoint(display.CenterReferencePoint)
				--dialogueobj.anchorX = .5
				--dialogueobj.anchorY = .5
				dialogueobj.x = _W*.5
				dialogueobj.y = _H*.43 + _G.adSpace
				dialogueobj:setFillColor(200,255,255)

			for k,v in pairs(currentlevel) do
				--print(k,v)
			end

			if listoflevelsplayed then 
				thelevel = nil 
				for i = 1,#listoflevelsplayed do 
				if listoflevelsplayed[i].name == currentlevel.level then 
					print "FOUND"
					for k,v in pairs(listoflevelsplayed[i]) do
						print(k,v)
					end
					thelevel = i
				end 
			end
			end 
			
			if listoflevelsplayed then 
				if thelevel then 
				currentlevel.points = listoflevelsplayed[thelevel].points
			else 
				currentlevel.points = 0			
			end  
			end 



			local tmpPoints = currentlevel.points

			if tmpPoints <= 0 then tmpPoints = 'n/a' end

	
			leveltext = display.newText (dialogGroup,level.name,0,0,systemfont,_G.mediumLargeFontSize)
			obj.x =  _W*2
				leveltext.xScale = (_W*0.5) / leveltext.width
				leveltext.yScale = leveltext.xScale

				if leveltext.xScale > 1 then
					leveltext.xScale, leveltext.yScale = 1, 1
				end

				leveltext.x = _W*.5
				leveltext.y = _H*.1 + _G.adSpace
			leveltext2 = display.newText (dialogGroup,hardness[currentlevel.hard],0,0,systemfont,_G.mediumSmallFontSize)
				leveltext2.x = _W*.5
				leveltext2.y = _H*.2 + _G.adSpace

			levelTypeText = display.newText(dialogGroup, '', 0, 0, systemfont, _G.mediumSmallFontSize)
			levelTypeText.x, levelTypeText.y = _W*0.5, _H*0.16 + _G.adSpace

			leveltext3 = display.newText (dialogGroup,"High Score : "..tmpPoints,0,0,systemfont,_G.mediumFontSize)
				leveltext3.x = _W*.5
				leveltext3.y = _H*.45 + _G.adSpace
			leveltext4 = display.newText (dialogGroup,"Goal Time : "..currentlevel.Time.." Seconds",0,0,systemfont,_G.mediumFontSize)
				leveltext4.x = _W*.5
				leveltext4.y = _H*.51 + _G.adSpace
			leveltext5 = display.newText (dialogGroup,"Goal Moves : "..currentlevel.Steps,0,0,systemfont,_G.mediumFontSize)
				leveltext5.x = _W*.5
				leveltext5.y = _H*.57 + _G.adSpace
			print "CURRENTLEVEL "
			print (currentlevel.level)
			print (currentlevel.points)


			dialogButton1 = {}--display.newGroup()
			dialogButton2 = {}--display.newGroup()
			dialogButton3 = {}--display.newGroup()

			if usermode then
				dialogButton4 = {}--display.newGroup()

				dialogButton4Bg = {}--display.newImageRect (dialogButton4,'Graphics/Menu/small_btn_fill.png',384,190)
				dialogButton4Bg.path = 'Graphics/Menu/small_btn_fill.png'
				dialogButton4Bg.width = 384
				dialogButton4Bg.height = 190
				dialogButton4Bg.xScale, dialogButton4Bg.yScale = 0.08, 0.12
				dialogButton4Bg.color = {255,0,0}

				dialogButton4Fg = {}--display.newImageRect (dialogButton4,'Graphics/Menu/small_btn_texture.png',384,190)
				dialogButton4Fg.path = 'Graphics/Menu/small_btn_texture.png'
				dialogButton4Fg.width = 384
				dialogButton4Fg.height = 190
				dialogButton4Fg.xScale, dialogButton4Fg.yScale = 0.08, 0.12
				dialogButton4.x, dialogButton4.y = dialogueobj.x + dialogueobj.width*dialogueobj.xScale*0.5 - dialogButton4Bg.width*dialogButton4Bg.xScale*0.5 - _W*0.03, dialogueobj.y - dialogueobj.height*dialogueobj.yScale*0.5 + dialogButton4Bg.height*dialogButton4Bg.yScale*0.5 + _H*0.02 + _G.adSpace

				local dialogtext4 = {}--display.newText(dialogGroup,"☠",0,0,systemfont,_G.mediumFontSize)
				dialogtext4.text = '☠'
				dialogtext4.font = systemfont
				dialogtext4.fontSize = _G.mediumFontSize
				dialogtext4.x, dialogtext4.y = 0, 0 + _G.adSpace

				dialogButton4.bg = dialogButton4Bg
				dialogButton4.fg = dialogButton4Fg
				dialogButton4.text = dialogtext4

				dialogButton4.onEnded = onDelete

				dialogButton4 = createButton(dialogButton4)

				dialogButton4.touchLock = true

				dialogGroup:insert(dialogButton4)
			end

			dialogButton1Bg = {}--display.newImageRect (dialogButton1,'Graphics/Menu/small_btn_fill.png',384,190)
			dialogButton1Bg.path = 'Graphics/Menu/small_btn_fill.png'
			dialogButton1Bg.width = 384
			dialogButton1Bg.height = 190

			dialogButton2Bg = {}--display.newImageRect (dialogButton1,'Graphics/Menu/small_btn_fill.png',384,190)
			dialogButton2Bg.path = 'Graphics/Menu/small_btn_fill.png'
			dialogButton2Bg.width = 384
			dialogButton2Bg.height = 190

			dialogButton3Bg = {}--display.newImageRect (dialogButton1,'Graphics/Menu/small_btn_fill.png',384,190)
			dialogButton3Bg.path = 'Graphics/Menu/small_btn_fill.png'
			dialogButton3Bg.width = 384
			dialogButton3Bg.height = 190

			dialogButton1Bg.color = _G.playColor
			dialogButton2Bg.color = _G.continueColor
			dialogButton3Bg.color = _G.replayColor

			dialogButton1Fg = {}--display.newImageRect (dialogButton1,'Graphics/Menu/small_btn_texture.png',384,190)
			dialogButton1Fg.path = 'Graphics/Menu/small_btn_texture.png'
			dialogButton1Fg.width = 384
			dialogButton1Fg.height = 190

			dialogButton2Fg = {}--display.newImageRect (dialogButton2,'Graphics/Menu/small_btn_texture.png',384,190)
			dialogButton2Fg.path = 'Graphics/Menu/small_btn_texture.png'
			dialogButton2Fg.width = 384
			dialogButton2Fg.height = 190

			dialogButton3Fg = {}--display.newImageRect (dialogButton3,'Graphics/Menu/small_btn_texture.png',384,190)
			dialogButton3Fg.path = 'Graphics/Menu/small_btn_texture.png'
			dialogButton3Fg.width = 384
			dialogButton3Fg.height = 190

			dialogButton1Bg.xScale, dialogButton1Bg.yScale = 0.25, 0.25
			dialogButton2Bg.xScale, dialogButton2Bg.yScale = 0.25, 0.25
			dialogButton3Bg.xScale, dialogButton3Bg.yScale = 0.25, 0.25

			dialogButton1Fg.xScale, dialogButton1Fg.yScale = 0.25, 0.25
			dialogButton2Fg.xScale, dialogButton2Fg.yScale = 0.25, 0.25
			dialogButton3Fg.xScale, dialogButton3Fg.yScale = 0.25, 0.25
			
			dialogButton1.x = _W*.5
			dialogButton2.x = _W*.5 + _W*.2
			dialogButton3.x = _W*.5 - _W*.2
			dialogButton1.y = _H*.32 + _G.adSpace
			dialogButton2.y = _H*.73 + _G.adSpace
			dialogButton3.y = _H*.73 + _G.adSpace

			local dialogtext1 = {}--display.newText (dialogGroup,"Play",0,0,systemfont,_G.mediumFontSize)
			dialogtext1.text = 'Play'
			dialogtext1.font = systemfont
			dialogtext1.fontSize = _G.mediumFontSize

			local dialogtext2 = {}--display.newText (dialogGroup,"Back",0,0,systemfont,_G.mediumFontSize)
			dialogtext2.text = 'Back'
			dialogtext2.font = systemfont
			dialogtext2.fontSize = _G.mediumFontSize

			dialogtext3 = {}--display.newText (dialogGroup,"Replay",0,0,systemfont,_G.mediumFontSize)
			dialogtext3.text = 'Replay'
			dialogtext3.font = systemfont
			dialogtext3.fontSize = _G.mediumFontSize

			-- dialogtext1.x, dialogtext1.y = dialogButton1.x, dialogButton1.y
			-- dialogtext2.x, dialogtext2.y = dialogButton2.x, dialogButton2.y
			-- dialogtext3.x, dialogtext3.y = dialogButton3.x, dialogButton3.y

			dialogButton1.bg = dialogButton1Bg
			dialogButton1.fg = dialogButton1Fg
			dialogButton1.text = dialogtext1

			dialogButton2.bg = dialogButton2Bg
			dialogButton2.fg = dialogButton2Fg
			dialogButton2.text = dialogtext2

			dialogButton3.bg = dialogButton3Bg
			dialogButton3.fg = dialogButton3Fg
			dialogButton3.text = dialogtext3

			dialogButton1.onEnded = playgame
			dialogButton2.onEnded = goback
			dialogButton3.onEnded = replay

			dialogButton1 = createButton(dialogButton1)
			dialogButton2 = createButton(dialogButton2)
			dialogButton3 = createButton(dialogButton3)

			dialogGroup:insert(dialogButton1)
			dialogGroup:insert(dialogButton2)
			dialogGroup:insert(dialogButton3)

			dialogButton1.touchLock = true
			dialogButton2.touchLock = true
			dialogButton3.touchLock = true

			dialogGroup.x = -_W*2

			isReplay = tenflib.jsonLoad(currentlevel.level.." replay")
			if isReplay then
				--print"there is a replay"
			else
				dialogButton3.alpha = 0
				dialogtext3.alpha = 0
			end
		end

		if level.type == 'OneStep' then
			levelTypeText.text = 'Falling Tiles Mode'
		elseif level.type == "Default" or level.type == "default" then
			levelTypeText.text = 'Normal Mode'
		elseif level.type == "Grey" then
			levelTypeText.text = 'Normal Mode'
		end

		transition.to (dialogGroup, {time = 300, x=0, transition = easing.inOutQuad, onComplete = function ()
			dialogButton1.touchLock = false
			dialogButton2.touchLock = false
			dialogButton3.touchLock = false

			if not menucreated then
				if usermode then
					dialogButton4.touchLock = false
				end

				menucreated = true 
			end 
		end})		
	end 


	function m.showlevel(event,user)

		if user == "false" then p.menu = 1 end 
		lististrue = nil 
		list = nil 
		local level = event
		print (level)

		aud.play (sounds.sweep)
		local gameboard
		

			if p.menu == 1 then 
				gameboard= tenflib.jsonLoad( "levels/"..level, system.DocumentsDirectory )

			else
				gameboard = tenflib.jsonLoad( "levels/"..level, system.DocumentsDirectory )

			end
		
		if not gameboard.Time then gameboard.Time = 9001 end 
		if not gameboard.Steps then gameboard.Steps = 9001 end 

			list = tenflib.jsonLoad("state"..tmpWorldName..".txt",system.DocumentsDirectory)


		if list then 


			for i = 1,#list do 
				print (list[i].name, level)
				if list[i].name == level then 
					
					
					currentlevel.Time 	= gameboard.Time
					currentlevel.Steps 	= gameboard.Steps
					currentlevel.name 	= gameboard.Name
					currentlevel.type 	= gameboard.Type
					currentlevel.hard 	= gameboard.MarkerColorMaxSegments
					currentlevel.points = list[i].points
					currentlevel.steps 	= list[i].numberofmoves
					currentlevel.colors = list[i].pickedupcolors
					currentlevel.level 	= level 
					lististrue = true 
				else 
					print "öhrg!"
				end 

			end 
		end 

		if not lististrue then 
			currentlevel.Time   = gameboard.Time
			currentlevel.Steps 	= gameboard.Steps
			currentlevel.name 	= gameboard.Name
			currentlevel.type 	= gameboard.Type
			currentlevel.hard 	= gameboard.MarkerColorMaxSegments
			currentlevel.points = 0
			currentlevel.steps 	= 0
			currentlevel.colors = 0
			currentlevel.level 	= level 
		end 



		
		leveldialogue(currentlevel)

	end 

	function m.tapEvent(event)
		local function onReturnTrue(e)
			--return true
		end

		local overlayRect = display.newRect(0,0,_W,_H)
		overlayRect.x, overlayRect.y = _W*0.5, _H*0.5
		overlayRect.alpha = 0.01
		overlayRect:addEventListener('tap', onReturnTrue)
		overlayRect:addEventListener('touch', onReturnTrue)

		local touched = event.target.level
		trect.isVisible = false
		aud.play(sounds.click)	

		
		transition.to (backbutton,{time = 200, alpha = 0 })
		transition.to (backbutton.text,{time = 200, alpha = 0 })
		transition.to (backlogo, {time = 200, alpha = 0})
		transition.to (pageGroup, {time = 300, alpha=0, onComplete = function()
			display.remove(overlayRect)
		end})
		-- transition.to (pageGroup, {time = 200, x = _W * 2, transition = easing.inOutQuad})
		transition.to (topText, {time = 200, y = -_H, transition = easing.inOutQuad, onComplete = function () m.showlevel(touched) end})
		transition.to (obj, {time = 100, x = _W*2,transition = easing.inOutQuad})


		
	end 



	function m.createPage(levelList)
		local ip5 = false 
		local amtPages = math.ceil(#levelList / 16)
		--print (amtPages)
		if p.menu == 1 then 
			print ("horsesex"..tmpWorldName)
			listoflevelsplayed = tenflib.jsonLoad("state"..tmpWorldName..".txt",system.DocumentsDirectory)
		else
			local function compare(a, b)
				-- for k,v in pairs(a) do
				-- 	print(k,v)
				-- end

				if a.DateTime == nil then
					return true
				elseif b.DateTime == nil then
					return false
				end

				return a.DateTime < b.DateTime
				
			end

			local tmpList = {}

			for k,v in pairs(levelList) do
				tmpList[#tmpList+1] = tenflib.jsonLoad('levels/' .. v, system.DocumentsDirectory)
			end

			table.sort(tmpList, compare)

			levelList = {}

			for k,v in pairs(tmpList) do
				levelList[#levelList+1] = v.Name

			end

			listoflevelsplayed = tenflib.jsonLoad("stateuser.txt",system.DocumentsDirectory)
		end

		local row,col = 0,0 
		
		if ( (display.pixelHeight/display.pixelWidth) > 1.5 ) then
   			ip5 = true 
		end

		print ("iphone5"..tostring(ip5))

		obj = display.newImageRect('Graphics/Menu/menu_backdrop.png', 1032, 1032)
		

		obj:setReferencePoint(display.CenterReferencePoint)
		--obj.anchorX = .5
		--obj.anchorY = .5
		obj.x = _W*.5
		
		if not ip5 then 
			obj.xScale, obj.yScale = (_W / 1032)*0.8, (_H / 1032)*0.65
			obj.y = _H*.4 + _G.adSpace
		else 
			obj.xScale, obj.yScale = (_W / 1032)*0.8, (_H / 1032)*0.58
			obj.y = _H*.43 + _G.adSpace
		end 



		obj:setFillColor(255,10,135)
		local pageoffset = _W
		local iNum = 0 
		--for p = 1, amtPages do 
			comingsoon = display.newImage ("Graphics/Menu/coming_soon_small.png")
						comingsoon.x = _W/2 
						comingsoon.y = _H/2 - _H/10
						comingsoon.xScale = .4
						comingsoon.yScale = .4
			comingsoon.alpha = 0													
		

			for i = 1, #levelList do 
				iNum = iNum + 1
				row = row + 1 
				
				if row>4 then 
					col = col + 1 
					row = 1 
				end 
				
				if col > 3 then 
					col = 0 
					row = 1
					pageN = pageN + 1
				end 
				
			

				icon[iNum] = display.newImageRect (pageGroup,"Graphics/UI/level_btn.png",50,50)
				icon[iNum].t = display.newText (pageGroup,i,0,0,systemfont,_G.mediumFontSize)

				icon[iNum]:setReferencePoint (display.CenterReferencePoint)
				
				icon[iNum].level = levelList[i]
				icon[iNum].alpha = 1
				icon[iNum]:setFillColor (200,200,255)


				icon[iNum].x = row * 60 + 10 + (pageoffset*pageN)
				
				if not ip5 then 
					icon[iNum].y = col * 70 + _H*0.15 + _G.adSpace ---135
				else
					icon[iNum].y = col * 72 + 50 + _H*0.15 + _G.adSpace ---135
				end 

				if _G.model == "iPhone" or _G.model == "iPhone Retina" then 
					icon[iNum].y = col * 72 + 10 + _H*0.15 + _G.adSpace ---135
				end 


				icon[iNum].t.x = icon[i].x
				icon[iNum].t.y = icon[i].y
				
				
				
				--icon[iNum].strokeWidth = 2
				
				if p.menu == 1 then 
			

					if _G.lockdown then 
						pages = math.ceil (_G.lockdownlimit / 16)
						--print ("PAGES "..pages.."!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
					end 

					
					if listoflevelsplayed then 
						if iNum <= (#listoflevelsplayed + 1 - userlevelsplayed) then 
							icon[iNum]:setFillColor (200,200,255)
							icon[iNum]:setStrokeColor(0,0,255)
							icon[iNum].unlocked = true 
						
							
							print "setting regular color"
						
							print ("debugmode ".. tostring(debugmode), _G.lockdown)
						-- lockdown 
							if _G.lockdown then 
								if iNum< _G.lockdownlimit then 
									
										icon[iNum]:addEventListener("tap",m.tapEvent)
									
								end 
							else
								if debugmode then
									icon[iNum]:addEventListener("tap",m.tapEvent)
								end 
							end 
						
						else
							if debugmode then 
								icon[iNum]:addEventListener("tap",m.tapEvent)
							end 
							icon[iNum]:setFillColor (200,200,200)
							icon[iNum]:setStrokeColor(100,100,100)
						
							

						end 
					
						if _G.lockdown then 
							if iNum >= _G.lockdownlimit then 
								icon[iNum].t.alpha = .5
								icon[iNum]:setFillColor (60,60,60)
								icon[iNum]:setStrokeColor(100,0,0)
							end 	
						end 

					else 
						if iNum == 1 then 
							print "setting regular color"
							icon[iNum]:setFillColor (200,200,255)
							icon[iNum]:setStrokeColor(0,0,255)
							icon[iNum]:addEventListener("tap",m.tapEvent)
							icon[iNum].unlocked = true 
						else
							print "setting  locked color"
							if debugmode then 
								icon[iNum]:addEventListener("tap",m.tapEvent)
							end 
							icon[iNum]:setFillColor (200,200,200)
							icon[iNum]:setStrokeColor(100,100,100)
						end 
					end 
				
				else -- custom menu
				 	icon[iNum]:setFillColor (200,200,255)
					icon[iNum]:setStrokeColor(0,0,255)
					icon[iNum].unlocked = true 
					icon[iNum]:addEventListener("tap",m.tapEvent)
				end 
				--icon[iNum].alpha = .9
			end 
		
			

			if listoflevelsplayed then 

				for i = 1, iNum do 
					
								

							for n = 1, #listoflevelsplayed do 
							
							
								if listoflevelsplayed[n].name == icon[i].level then 
									if _G.lockdown then 
										if i >= _G.lockdownlimit then 
											print (i, _G.lockdownlimit)
										else
									icon[i]:setStrokeColor (0,255,0)
									icon[i]:setFillColor (200,255,200)

									if listoflevelsplayed[n].numStars then 

										if listoflevelsplayed[n].numStars.two == true then 
											starcounter = starcounter + 1
											star[starcounter] = display.newImageRect (pageGroup,"Graphics/Objects/star02.png",38,34)
											star[starcounter].xScale = .5
											star[starcounter].yScale = .5
											star[starcounter].x = icon[i].x 
											star[starcounter].y = icon[i].y - 20
											star[starcounter]:toFront()
										end 


										if listoflevelsplayed[n].numStars.one == true then 
											starcounter = starcounter + 1
											star[starcounter] = display.newImageRect (pageGroup,"Graphics/Objects/star02.png",38,34)
											star[starcounter].xScale = .5
											star[starcounter].yScale = .5
											star[starcounter].x = icon[i].x - 15
											star[starcounter].y = icon[i].y - 15
											star[starcounter]:toFront()
										end 

										

										if listoflevelsplayed[n].numStars.three == true then 
											starcounter = starcounter + 1
											star[starcounter] = display.newImageRect (pageGroup,"Graphics/Objects/star02.png",38,34)
											star[starcounter].xScale = .5
											star[starcounter].yScale = .5
											star[starcounter].x = icon[i].x + 15
											star[starcounter].y = icon[i].y - 15
											star[starcounter]:toFront()
										end 
									end 
								end 
							end 
						end 
					end 
				end 
			end 


			backbutton = {}--display.newGroup()

			local backbuttonBg = {}--display.newImageRect (backbutton, 'Graphics/Menu/small_btn_fill.png', 384, 190)
			backbuttonBg.path = 'Graphics/Menu/small_btn_fill.png'
			backbuttonBg.width = 384
			backbuttonBg.height = 190
			backbuttonBg.xScale, backbuttonBg.yScale = 0.2, 0.2
			backbuttonBg.color = _G.continueColor

			local backbuttonFg = {}--display.newImageRect (backbutton, 'Graphics/Menu/small_btn_texture.png', 384, 190)
			backbuttonFg.path = 'Graphics/Menu/small_btn_texture.png'
			backbuttonFg.width = 384
			backbuttonFg.height = 190
			backbuttonFg.xScale, backbuttonFg.yScale = 0.2, 0.2

			backbutton.x = _W*.75
			backbutton.y = _H*.78 + _G.adSpace

			backbutton.txt = {}--display.newText ("Back",0,0,systemfont,_G.mediumFontSize)
			backbutton.txt.text = 'Back'
			backbutton.txt.font = systemfont
			backbutton.txt.fontSize = _G.mediumFontSize

			backbutton.bg = backbuttonBg
			backbutton.fg = backbuttonFg
			backbutton.text = backbutton.txt
			backbutton.onEnded = gobacktomenu

			backbutton = createButton(backbutton)


			function movescroll(e)
				if not dialogueactive then
					
					pageGroup.x = _W*(1-e.x)
					local tmpWorldName = p.worldName
					print (p.worldname)
					if tmpWorldName == 'Find the Cure' then
						tmpWorldName = ''
					end

					local whereWasI = tenflib.jsonSave("whereWasI"..tmpWorldName, {pagePosition=pageScroller:getScrollPosition()})

					if p.menu == 1 then 
						if pageScroller:getScrollPosition() >= pages then 
							transition.to (comingsoon,{time = 200, alpha = 1}) 
						else 
							transition.to (comingsoon,{time = 200, alpha = 0}) 
						end 
					end 
					prev = pageGroup.x
				end
			end
			
			pageScroller = require('modules.pageScroller')(0, _H*.08, _W, _H*.65, _W*.80, _H, amtPages, 1, false)	
			pageScroller:addEventListener('scrollMoved', movescroll)
			
			if pagePosition and p.menu == 1 then
				pageScroller:scrollTo(pagePosition.pagePosition)
				pageX = pagePosition.pagePosition
			else
				pageX = 1
			end
	

	end 





	local levelList = m.findLevels()
	

	list = gamelogic.loadstate(usermode)
	
	

	pg = m.createPage(levelList)

	backbutton.alpha = 0 
	backbutton.text.alpha = 0 

	pageGroup:toFront()
	-- pageGroup.x = _W * 2
	topText.y = - _H 
	obj.x = pageGroup.x
	pageGroup.alpha = 0

if not p.replay then  
	aud.play (sounds.sweep)
	transition.to (pageGroup, {delay = 200, time = 300, alpha=1})
	transition.to (topText, {time = 300, y = _H*.04 + _G.adSpace, transition = easing.inOutQuad})
	transition.to (obj, {time = 300, x = _W*.5,transition = easing.inOutQuad})
	transition.to (backbutton, {time = 200, alpha = 1})
	transition.to (backbutton.text, {time = 200, alpha = 1})
	transition.to (backlogo, {delay = 200, time = 400, alpha = .4})
else
	backgroundmusic = "colorboard_ingame_1.mp3"
	print "showing level"
	
	if p.menu == 1 then 
		m.showlevel(p.level,"false")
	else 
		m.showlevel(p.level,"true")
		obj.x = _W*2
	end 

end 
	aud.playmusic(backgroundmusic)

	if _G.adsEnabled then
		ads.show( "banner", { x=0, y=_H - _G.adSpace} )
	end 

	comingsoon:toFront()
	trect = display.newRect (0,0,_W,_H)
			trect:toFront()
	trect.alpha = .01
	trect.isVisible = true
	local function trectlistener()
		--return true
	end 

	trect:addEventListener("touch", trectlistener)
	trect.x = _W*5

end 




function scene:show(e)
end 

function scene:hide(e)
display.remove(comingsoon)
tmpWorldName = nil 
--listoflevelsplayed = nil 
--print "exiting scene, bitch"

end 

function scene:destroy(e)
end





scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
