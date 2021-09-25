local composer 			= require "composer"
--composer.purgeOnSceneChange = true
composer.recycleOnSceneChange = true
local scene 			= composer.newScene()
local renderer			= require "newrender"
local gamelogic			= require "gamelogic"
local tenflib			= require "modules.tenfLib"
local hud				= require "hud"
local aud 				= require "audioo"
PathNodes 				= require("PathNodes")
PathFinding 			= require("PathFinding")
local MoveHistoryTable 	= {}
local NewPos 			= {x = TapedPosX, y = TapedPosY}
local delayspeed 		= 150
local values
local GameBoard, BoardState
local Tile
local params
local lastboard = {}
local laststate = {}
local numberofmoves = 0 
local pickedup = 0 
local leveldone
local replay = false
local flip = false
local win = false
local handle
local seconds = 0 
local blinktimer = 0 
local doblink = true 
replaymode = false
function scene:create(e)
end 

function scene:show(e)
	local backgroundmusic = "colorboard_ingame_1.mp3"
	aud.playmusic(backgroundmusic)


	params = e.params
	p = e.params
	
	if params.list then  
		print "replay HELLO I AM HERE!!!!"
		replaymode = true
	else 
		print "not replay  HELLO I AM HERE!!!!"
		replaymode = false
	end

	local prev = composer.getSceneName()

	if prev then 
		composer.removeScene( prev )
	end 

	function restartscene(mode,list)
		_G.loadingScreen.alpha = 1
		_G.loadingScreen:toFront()
		print ("HOLLAAAAAAAA "..params.menu)
		
		params.replay = true
		params.list = list

		if mode == true then 
			gamelogic.cleanUp()
			hud.removeListeners()
			timer.performWithDelay(400, function () cleanupdone = renderer.cleanup("all"); hud.nilItAll(); end )
			timer.performWithDelay(800, function () composer.gotoScene("emptyscene",{params = params}) ; end )
		else
			composer.gotoScene("emptyscene",{params = params})
		end 

	end

	function restartsceneTwo(mode,list)
		if mode == true then 
			params.replay = true
			params.list = list
			gamelogic.cleanUp()
			hud.removeListeners()
			timer.performWithDelay(400, function () cleanupdone = renderer.cleanup("all"); hud.nilItAll(); end )
			timer.performWithDelay(800, function () composer.gotoScene("emptyscene",{params = params}) ; end )
		else
			composer.gotoScene("emptyscene",{params = params})
		end 

	end

	function OpenOrClose(currentposition)
		-- determining which arrow-tiles should be open or closed.
		
		--making sure all tiles are closed at the start of each turn
		for i=1,#Tile do
			if Tile[i].type > 9 and Tile[i].type < 14 then
				Tile[i].oneway = true
				Tile[i].onewayid = i
				--renderer.opentiles(Tile[i],"close") --(commented out for debugging)
			end 
		end 
		-- determining which ones should open 
		
		tilevalue = gamelogic.PosToTile(currentposition, GameBoard.Size.x)
		tilevalue = tilevalue - GameBoard.Size.x
		print ("tile ID: "..tilevalue)
		print ("---------------------")




		-- setting up nodes for the arrow-tiles
		for i=1,#Tile do
			if Tile[i].type > 9 and Tile[i].type < 14 then
				local NodeID = PathNodes:GetNearestNode(Tile[i].xPos, Tile[i].yPos)
				if Tile[i].object.state == "open" then
					PathNodes:SetNodeActivation(NodeID, true)
				else
					PathNodes:SetNodeActivation(NodeID, false)
				end
			end
		end 
	end


	function TileTapListener( event )
		print ("ID"..event.target.id)
		print ("tile contains"..Tile[event.target.id].type)

		


		if Tile[event.target.id].type ~= 0 then 


			if renderer.getMoveInProgress() == false then
				
				if event.phase == "ended" then 
					--	if Tile[event.target.id].type >= 10 and Tile[event.target.id].type < 14 then
					--	print "Trying to hit a one way tile" -- debug
					--	if Tile[event.target.id].object.state == "close" then 
					--	print "Tile is closed" -- debug
				
					--	renderer.markTile(event.target.id,"red")
					--	aud.play (sounds.nope)
					--	return
					--  end
					--  end  



					local data = event.target.id
					local TapedPosX = event.target.xPos
					local TapedPosY = event.target.yPos
					


					local CurrentPos= { x = BoardState.MoveMarkerCurrentPos.x, y = BoardState.MoveMarkerCurrentPos.y }
					local MoveDir	= nil
					
					if not replay then 

						local newpos = {x=TapedPosX, y=TapedPosY}
						OpenOrClose(newpos)
					
						

						Pathf = PathFinding:InitiatePathFinding(PathNodes.NodeList, PathNodes.NodeCount, PathNodes:GetNearestNode(CurrentPos.x, CurrentPos.y), PathNodes:GetNearestNode(event.target.xPos, event.target.yPos))
					end 
					
					if Pathf then
						for i=1,#Pathf do
							local NodeX, NodeY = PathNodes:GetNodePos(Pathf[i])
							
						end
					end	
					moves = 1 
					if not Pathf then 
						renderer.markTile(data,"red")
					
						aud.play (sounds.nope)
					else  
						
						local tappedself = false
						if TapedPosX == CurrentPos.x then
							if TapedPosY == CurrentPos.y then 
							
								renderer.markTile(data,"blue")
								tappedself = true 
							end 
						end 

						if not tappedself then 
						renderer.markTile(data,"green")
						
						
						nMoves = #Pathf
						if GameBoard.Type == "OneStep" then nMoves=2 end 
					
						movearound(false)
						end 
					end 
				end 
			end 

		end 
		 
		
	end 

	function plusMinus()
		flip = not flip 
		state = gamelogic.addDelColor()
		aud.play (sounds.click)

		if state.AddingColor == false then 
			transition.to(minusButton, {delay=80,time=80, xScale=.6, yScale=.6,alpha=1})
			transition.to(plusButton, {time=80,xScale=.01,alpha=0})
		else 
			transition.to(minusButton, {time=80, xScale=.01,alpha=0})
			transition.to(plusButton, {time=80,xScale=.6,alpha=1})
		end 
		return true
	end

	function makelistovervalues()
		local tempvar = 255 / GameBoard.MarkerColorMaxSegments
		local valuelist = {}

		for i = 1, GameBoard.MarkerColorMaxSegments do 
			valuelist[i] = math.ceil(i * tempvar)
			print ("values "..valuelist[i])
		end

		if GameBoard.MarkerColorMaxSegments == 3 then
			valuelist[#valuelist+1] = 128
		end

		return valuelist
	end 

	
	local function findClosest(listOfValues, value)
		local closest = 1

		for i = 1, #listOfValues do
			if math.abs(listOfValues[i] - value) < math.abs(listOfValues[closest] - value) then
				closest = i
			end
		end
		print ("closest "..closest)
		return closest
	end

	function checkForCorrect(state, board)
		
		local opengoal = false
		local R,G,B
		R = false 
		G = false
		B = false

		for i = 1, #values do 
			if state.colorvalue.r == values[i] then R = true end 
		end 
		
		for i = 1, #values do 
			if state.colorvalue.g == values[i] then G = true end 
		end 
		
		for i = 1, #values do 
			if state.colorvalue.b == values[i] then B = true end 
		end 

		if state.colorvalue.r ~= 0 and R == false then 
			i = findClosest (values, state.colorvalue.r)
			state.colorvalue.r = values[i]
		end 

		if state.colorvalue.g ~= 0 and G == false then 
			i = findClosest (values, state.colorvalue.g)
			state.colorvalue.g = values[i]
		end 

		if state.colorvalue.b ~= 0 and B == false then 
			i = findClosest (values, state.colorvalue.b)
			state.colorvalue.b = values[i]
		end

		print(state.colorvalue.r, state.colorvalue.g, state.colorvalue.b)
		
		if board.GoalColor.r == state.colorvalue.r then
			if board.GoalColor.g == state.colorvalue.g then
				if board.GoalColor.b == state.colorvalue.b then
					opengoal=true 
				end
			end
		end

		if opengoal then 
			renderer.goal("open")
			--print "opening"
		else
			renderer.goal("close")
			--print "closing "
		end  

	end

	function checkForWin(state,board)
	
		local leveldone

		if board.GoalColor.r == state.colorvalue.r then
			if board.GoalColor.g == state.colorvalue.g then
				if board.GoalColor.b == state.colorvalue.b then
					--print "win"
					win = true 
					nMoves = 0 
					leveldone = renderer.explodeBoard()
					timer.cancel(handle)

					win = true 
					local played = 1
					ach.savelevelsPlayed( played )
					if not replay then 
						if board.User == true then user = true else user = false end 

						thislevel = gamelogic.saveState(params.level,0,numberofmoves, pickedup, seconds, user) 
						thislevel.replay = false
					else 
						thislevel = gamelogic.getBlob (params.level,0,numberofmoves, pickedup, seconds)
						thislevel.replay = true 
					end 

					nMoves = 0 
				end
			end
		end 
		
		 if win == false then 
			
		 	if state.colorsLeft < 1 then
		 	local failed = 1
			ach.savelevelsFailed( failed )
			aud.stopmusic()
					
		 	timer.performWithDelay(1000,function () hud.mainMenuFunc2() end)
		 	timer.performWithDelay(300,function () aud.play(sounds.fail) end)
		 	end 
		 end 

		local cleanupdone 

		if leveldone then 
			doblink = false
			timer.performWithDelay(500,function () gamelogic.cleanUp() end)
			timer.performWithDelay(1000, function () cleanupdone = renderer.cleanup("all"); end )	
			timer.performWithDelay(500,hud.nilItAll)
			hud.dontFail()
			params.win = win 
			params.thislevel = thislevel
			if thislevel.replay == true then 
				params.replay = true 
				params.win = false
				if params.menu == 2 then 
					params.isUserLevel = true
				end 
				
				print ("menuuu"..params.menu)
				aud.stopmusic()
				timer.performWithDelay(2000, function () composer.gotoScene("menu",{params=params}) end )		
			else
				params.newHighScore = gamelogic.newHighScore
				params.isUserLevel = user
				timer.performWithDelay(2000, function () composer.gotoScene("endgame",{params=params}) end )	
			end 
		end 
	end 

	function startover()
		
		local restartLevel = 1
		ach.saveRestartsAch( restartLevel )

		nMoves = 0 
		doblink = false
		timer.performWithDelay(300, function () gamelogic.cleanUp() end)

		timer.performWithDelay(400, function () cleanupdone = renderer.cleanup("all"); hud.nilItAll(); end )	
		timer.performWithDelay(800, function () restartscene() end )
	end

	function goToMain()
		doblink = false
		gamelogic.cleanUp()
		timer.performWithDelay(400, function () cleanupdone = renderer.cleanup("all"); hud.nilItAll(); end )	
		timer.performWithDelay(800, function () composer.gotoScene("startscreen",{params = params}) end )	
	end

	function goToLevelSelect()
		doblink = false
		gamelogic.cleanUp()
		timer.performWithDelay(400, function () cleanupdone = renderer.cleanup("all"); hud.nilItAll(); end )	
		timer.performWithDelay(800, function () composer.gotoScene("menu",{params = params}) end )	
	end
	
	function checktile(position)
		
		local tnum = gamelogic.PosToTile(position,GameBoard.Size.x)
		local item = GameBoard.Tile[tnum-GameBoard.Size.x]

		return item,tnum
	end 

	function manageTiles(position)
		
		local t = true
		local item,tnum = checktile(position)

				-- arrow tile check 

		-- 	i need to make some sort of dispatchevent stuff here to be able to get the tiletaplistener to work for me
		--  tile[newposition]:dispatchEvent("touch")



		if item >= 10 and item < 14 then 
			print "on a slide"
			if item == 10 then -- up  
				print ("move from "..NewPos.x, NewPos.y.." to "..NewPos.x, NewPos.y - 1)
			end 
			if item == 11 then -- right  
				print ("move from "..NewPos.x, NewPos.y.." to "..NewPos.x + 1, NewPos.y)
			end 
			if item == 12 then -- down  
				print ("move from "..NewPos.x, NewPos.y.." to "..NewPos.x, NewPos.y + 1)
			end 
			if item == 13 then -- left  
				print ("move from "..NewPos.x, NewPos.y.." to "..NewPos.x - 1, NewPos.y)
			end 

		end 



		if item == 2 then 
			checkForWin(BoardState,GameBoard)
		end 

		if item > 2 and item < 10 then 
			modifier = BoardState.AddingColor
			t,amountOfColors = gamelogic.markerColor(modifier,item)
			
			if t then 
				pickedup = pickedup + 1
				if flip then 
					aud.play (sounds.drop)
				else 
					aud.play(sounds.get)
				end 

				renderer.colorMarker(t.r,t.g,t.b)
				gamelogic.modifyBoard(tnum,1)
				renderer.updateBoard(tnum,1)
				hud.setBuckets(amountOfColors,GameBoard.MarkerColorMaxSegments)
				checkForCorrect(BoardState,GameBoard)
				
			else 
				aud.play (sounds.nope)
			end 
		end 
		

		return t
	end 
	
	

	function movearound(string)
			
		-- make a copy of the last boardstate
		if not lastboard.exists then 
			lastboard = tenflib.tableCopy (GameBoard,true)
			laststate = tenflib.tableCopy (BoardState,true)
				
				lastboard.exist = true 
		end 
		
		local CurrentPos= { x = BoardState.MoveMarkerCurrentPos.x, y = BoardState.MoveMarkerCurrentPos.y }
		
		if moves < nMoves then 
			
			if renderer.getMoveInProgress() == false then
				
				moves = moves + 1
				
				--TODO---- Update nodetree here 
			
				if replay then 
					NewPos.x = params.list[moves].x
					NewPos.y = params.list[moves].y

					if params.list[moves].flip ~= flip then 
						plusMinus()
					end 
				end 
				
				if not replay then 
					if not NewPos then
						NewPos.x = GameBoard.StartPos.x
						NewPos.y = GameBoard.StartPos.y
					end 

					local NodeX, NodeY = PathNodes:GetNodePos(Pathf[moves])
					NewPos.x = NodeX
					NewPos.y = NodeY
				end 
			
				if NewPos.x == CurrentPos.x + 1 and NewPos.x < GameBoard.Size.x + 1 and NewPos.y == CurrentPos.y then
					MoveDir = "right"
					
					--print( "Moving right" )
				--Did the tap happen to the left side of our marker, move if not at edge of level
				elseif NewPos.x == CurrentPos.x - 1 and NewPos.x > 0 and NewPos.y == CurrentPos.y then
					MoveDir = "left"
					--print( "Moving left" )
				--Did the tap happen to the above side of our marker, move if not at edge of level			
				elseif NewPos.y == CurrentPos.y - 1 and NewPos.y > 0 and NewPos.x == CurrentPos.x then
					MoveDir = "up"
					--print( "Moving up" )		
				--Did the tap happen to the below side of our marker, move if not at edge of level			
				elseif NewPos.y == CurrentPos.y + 1 and NewPos.y < GameBoard.Size.y + 1 and NewPos.x == CurrentPos.x then
					MoveDir = "down"
					--print( "Moving down" )
				end 
				
				local t = manageTiles(NewPos)
				
				if t then 
					numberofmoves = numberofmoves + 1 
					--print (numberofmoves)
					gamelogic.MoveMarker( NewPos, GameBoard, BoardState )
					renderer.moveMarker( NewPos.x, NewPos.y, MoveDir, GameBoard )
					renderer.directionPrinter(MoveHistoryTable)

					if not replay then gamelogic.AddMoveList( MoveHistoryTable, NewPos, MoveDir ) end 
					renderer.directionPrinter(MoveHistoryTable)

				else 
					nMoves = 0
				end 
			end 
				
			if lastboard.exist then 
				-- if the gametype is "OneStep", remove the tiles you've walked on
				if nMoves > 0 then 

					if GameBoard.Type == "OneStep" then 
						oldx,oldy = laststate.MoveMarkerCurrentPos.x,laststate.MoveMarkerCurrentPos.y
						local tmpPos = {x = oldx, y = oldy}
						if not leveldone then 
							local checkforgoaltile = checktile (tmpPos)
							if checkforgoaltile ~= 2 then 
								local lasttile = gamelogic.PosToTile(tmpPos,GameBoard.Size.x)
								gamelogic.modifyBoard(lasttile,0)
								renderer.updateBoard(lasttile,0)
							end 
						end 
					end 
				end 
			end 

			-- do another copy of the list	
			lastboard = tenflib.tableCopy (GameBoard,true)
			laststate = tenflib.tableCopy (BoardState,true)
			lastboard.exist = true 
			timer.performWithDelay(delayspeed,movearound) 
		else 
			replay = false
			renderer.moveeyes("down")
		end 
	end 
	GameBoard, BoardState = gamelogic.CreateBoard( params.level ) --Filename
	
	
	Tile = renderer.drawBoard( GameBoard )
	renderer.colorMarker(80,80,80)
	renderer.setGoalColor(GameBoard.GoalColor.r,GameBoard.GoalColor.g,GameBoard.GoalColor.b)
	hud.createHud(GameBoard,params)
	hud.setGoalColor(GameBoard)
	hud.findReplays(GameBoard)
	hud.name()
	renderer.directionPrinter(MoveHistoryTable)
	values = makelistovervalues()
	PathNodes:InitializeBasicSettings(4, GameBoard.Size.x + 1, GameBoard.Size.y + 1, 0, 0)

	for i=1,#Tile do
		if Tile[i].type ~= 0 then 
		print ("listing tile values "..Tile[i].type)
			PathNodes:CreateNode(Tile[i].xPos, Tile[i].yPos)
			if Tile[i].type > 2 and Tile[i].type < 9 then
				print ("setting weight")
				local NodeID = PathNodes:GetNearestNode(Tile[i].xPos, Tile[i].yPos)
				PathNodes:SetWeightAdd(NodeID, 9999)
			end
		end
	end

	PathNodes:AutoConnectAllNodesViaLength(1)

	---- Fix Properties for special Nodes
	print("Fix Special Properies on special Nodes")
	for i=1,#Tile do
		if Tile[i].type > 9 and Tile[i].type < 14 then
			--- Remove all neighbours and Set Unique paths
			print ("listing tile values "..Tile[i].type)
			local NodeID = PathNodes:GetNearestNode(Tile[i].xPos, Tile[i].yPos)

			local function UnConNodes(NodeID, X,Y, TypeNum,Num)
				local NNodeID = PathNodes:GetNearestNode(X, Y)
				if NNodeID ~= nil and TypeNum ~= Num then
					PathNodes:UnConnectNode(NodeID, NNodeID)
				end
			end
			UnConNodes(NodeID, Tile[i].xPos, Tile[i].yPos - 1, Tile[i].type, 10)
			UnConNodes(NodeID, Tile[i].xPos + 1, Tile[i].yPos, Tile[i].type, 11)
			UnConNodes(NodeID, Tile[i].xPos, Tile[i].yPos + 1, Tile[i].type, 12)
			UnConNodes(NodeID, Tile[i].xPos - 1, Tile[i].yPos, Tile[i].type, 13)

		end
	end

	Pathf = {}
	
	if params.list then
		replay = true 
		params.list[1].x = GameBoard.StartPos.x
		params.list[1].y = GameBoard.StartPos.y
		params.list[1].flip = false
		nMoves = #params.list

		for k = 1,#params.list do
			print(params.list[k].x,params.list[k].y,params.list[k].flip)
		end
		
		moves = 1
		timer.performWithDelay(500,function() movearound(); end )
	end 
	
	renderer.consolePrintBoard(GameBoard, BoardState)
	
	for i = 1, #Tile do
		Tile[i]:addEventListener( "touch", TileTapListener )
	end

	_G.loadingScreen.alpha = 0
end 

function incTimer()
	seconds = seconds + 1
	if doblink then 
		blinktimer = blinktimer + 1
		if blinktimer == 6 then 
			blinktimer = 0 
			renderer.blink()
		end 
	end 
end 

handle = timer.performWithDelay(1000, incTimer, 0)

function scene:hide(e)
	package.loaded['newrender'] = nil
	package.loaded['gamelogic'] = nil
	package.loaded['modules.tenfLib'] = nil
	package.loaded['hud'] = nil
	package.loaded['audioo'] = nil
	package.loaded['PathNodes'] = nil
	package.loaded['PathFinding'] = nil
end 

board = nil 
leveldone = nil 

function scene:destroy(e)
end

scene:addEventListener("create",scene)
scene:addEventListener("show",scene)
scene:addEventListener("hide",scene)
scene:addEventListener("destroy",scene)
return scene
