local isNameSet = false
local GameBoard
local scoresys = require ("scoresystem")
local tenflib = require( "modules.tenfLib" )
local aud = require ("audioo")
local gl = {}
local MoveHistoryCounter = 0
local positions = 0
local markerDirection
local miniMapGroup = display.newGroup()
local markerCol = {0,0,0}
local MoveHistoryTable = {}
	  markerCol.amount = 0 
local flip = false
local colorvalue = {r=0,g=0,b=0} 
local BoardState = {}
	BoardState.colorvalue = colorvalue

--Get Tile id for tile at this position
function gl.TileToPos( Tile, GameBoard )
	local Position = { x=Tile % GameBoard.Size.x, y=math.ceil( Tile / GameBoard.Size.x )-1}
	if Position.x == 0 then
		Position.x = GameBoard.Size.x
	end

	return Position
end

function gl.PosToTile( Position,width )
		local ret = ((Position.y) * width) + Position.x 
	return ret
end

function gl.markerColor(modifier,color)
	color = color-2
	colorlist = {red = {1,0,0},green = {0,1,0},blue = {0,0,1},cyan = {0,1,1},magenta = {1,0,1}, yellow = {1,1,0}}
	local move = true 
	
	if modifier == true then 
		if color > 0 and color < 4 then 
			if markerCol[color]< markerCol.max then 
				markerCol[color] = markerCol[color] + 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 
	
		if color == 4 then 
			if markerCol[2]< markerCol.max and markerCol[3]< markerCol.max then 
				markerCol[2] = markerCol[2] + 1
				markerCol[3] = markerCol[3] + 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 

		if color == 5 then 
			if markerCol[1]< markerCol.max and markerCol[3]< markerCol.max then 
				markerCol[1] = markerCol[1] + 1
				markerCol[3] = markerCol[3] + 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 

		if color == 6 then 
			if markerCol[1]< markerCol.max and markerCol[2]< markerCol.max then 
				markerCol[1] = markerCol[1] + 1
				markerCol[2] = markerCol[2] + 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 

	end 

	if modifier == false then 
		if color > 0 and color < 4 then 

			if markerCol[color]> 0 then 
				markerCol[color] = markerCol[color] - 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false
			end
		end 
		
			if color == 4 then 
			if markerCol[2]> 0 and markerCol[3]>0 then 
				markerCol[2] = markerCol[2] - 1
				markerCol[3] = markerCol[3] - 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 

		if color == 5 then 
			if markerCol[1]> 0 and markerCol[3]> 0 then 
				markerCol[1] = markerCol[1] - 1
				markerCol[3] = markerCol[3] - 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 

		if color == 6 then 
			if markerCol[1]> 0 and markerCol[2]> 0 then 
				markerCol[1] = markerCol[1] - 1
				markerCol[2] = markerCol[2] - 1
				markerCol.amount = markerCol.amount+1
			else 
				move = false 
			end 
		end 



	end


	if markerCol[1]+markerCol[2]+markerCol[3] ~= 0 then 
		colorvalue.r = math.floor(255 / markerCol.amount * markerCol[1]) 
		colorvalue.g = math.floor(255 / markerCol.amount * markerCol[2])
		colorvalue.b = math.floor(255 / markerCol.amount * markerCol[3])
		local multi = 255 / math.max(colorvalue.r, colorvalue.g, colorvalue.b)
		colorvalue.r = math.round(colorvalue.r*multi)
		colorvalue.g = math.round(colorvalue.g*multi)
		colorvalue.b = math.round(colorvalue.b*multi)
		if colorvalue.r > 255 then colorvalue.r = 255 end 
		if colorvalue.g > 255 then colorvalue.g = 255 end 
		if colorvalue.b > 255 then colorvalue.b = 255 end 
	else 
		colorvalue.r = 0; colorvalue.g = 0; colorvalue.b = 0
	end 

	if GameBoard then 
		BoardState.colorsLeft = GameBoard.nColorsOnBoard - markerCol.amount
		BoardState.colorvalue = colorvalue
		
		if move then 
			return colorvalue, markerCol
		else 
			return false 
		end 
	end 	
end

function gl.getMarkerColor()
	return markerCol
end

function gl.modifyBoard(index,value)
	local ind = index-GameBoard.Size.x
	GameBoard.Tile[ind] = value
end 

function gl.CreateBoard( BoardName )

	for k,v in pairs(p) do
		print("CONTENTS OF P"..k,v)
	end
	if p.menu == 2 then 
		GameBoard= tenflib.jsonLoad( "levels/"..BoardName, system.DocumentsDirectory )
	else
		GameBoard= tenflib.jsonLoad( "levels/"..BoardName, system.ResourceDirectory )
	end
	
	
	
	GameBoard.colorlist = {0,0,{255,0,0},{0,255,0},{100,100,255},{0,255,255}, {255,0,255}, {255,255,0}}
	
	local glist = require ("graphicpicker")
	local templist = glist.list ("default")

	GameBoard.imagelist 	= templist.imagelist	
	GameBoard.itemlist  	= templist.itemlist
	GameBoard.touchtile 	= templist.touchtile
	GameBoard.gate 			= templist.gate
	GameBoard.gate.lamp 	= templist.gate.lamp
	GameBoard.background 	= templist.background
	GameBoard.star 			= templist.star
	GameBoard.oneway		= templist.oneway
	templist = nil
	
	if not GameBoard.User then
		GameBoard.User = false
	end
	
	if GameBoard.Time == nil then 
		GameBoard.Time = 100
		print ("THIS LEVEL DOES NOT HAVE A SET TIME LIMIT!")
	end 
	if GameBoard.Steps == nil then 
		GameBoard.Steps = 100
		print ("THIS LEVEL DOES NOT HAVE A SET STEP LIMIT!")
	end 


	GameBoard.maximumTime = GameBoard.Time
	GameBoard.maxMoves = GameBoard.Steps
	

	BoardState 	= { MoveMarkerCurrentPos = { x = GameBoard.StartPos.x, y = GameBoard.StartPos.y }, 
							AddingColor = true }
	
	markerCol.totalAmount = 0 
	for i = 1,#GameBoard.Tile do 
		if GameBoard.Tile[i] >2 and GameBoard.Tile[i] < 10 then 
			markerCol.totalAmount = markerCol.totalAmount + 1
		end 
	end 
	GameBoard.nColorsOnBoard = markerCol.totalAmount 

	markerCol.max = GameBoard.MarkerColorMaxSegments

	BoardState.colorsLeft = GameBoard.nColorsOnBoard
	BoardState.colorvalue = colorvalue
	return GameBoard, BoardState
end




function gl.addDelColor()
	flip = not flip 
	if BoardState then
		if BoardState.AddingColor == true then
			BoardState.AddingColor = false
		
		elseif BoardState.AddingColor == false then
			BoardState.AddingColor = true
		
		end
	end
	return BoardState
end

function gl.MoveMarker( Position, GameBoard, BoardState )
	
	BoardState.MoveMarkerCurrentPos.x = Position.x
	BoardState.MoveMarkerCurrentPos.y = Position.y

end

function gl.loadstate(user)
local listoverlevels




if user then  


	listoverlevels = tenflib.jsonLoad( "stateuser.txt", system.DocumentsDirectory)
else 
	tmpWorldName = tenflib.jsonLoad("world.txt")
	listoverlevels = tenflib.jsonLoad( "state"..tmpWorldName..".txt", system.DocumentsDirectory)
end 

return listoverlevels

end 

function gl.getBlob(boardname,points,numberofmoves,pickedup, seconds)

	local scoreblob = {numberofmoves,pickedup,seconds}
	local thislevel = scoresys.load(scoreblob,GameBoard)

return thislevel
end 

function gl.saveState(boardname,points,numberofmoves,pickedup,seconds)

	local levelInQuestion
	local listoverlevels = gl.loadstate(user)


	local scoreblob = {numberofmoves,pickedup,seconds}

	local thislevel = scoresys.load(scoreblob,GameBoard)

	local tmpList = tenflib.jsonLoad("state"..(tmpWorldName or "User")..".txt", system.DocumentsDirectory)
	if tmpList then 
		for k,v in pairs(tmpList) do
			if v.name == boardname then
				points = v.points
			end
		end
	end
	
	if (not points) or (thislevel.totalscore > points) then
		points = thislevel.totalscore
		gl.newHighScore = true
	end

	local savenewlevel = true 
	local savenewscore = true

	if listoverlevels then 


		for i = 1, #listoverlevels do 
			if listoverlevels[i].name == boardname then 
				savenewlevel = false
				levelInQuestion = i
			end 
		end 

		if savenewlevel then 
			listoverlevels[#listoverlevels+1] 					= {}
			listoverlevels[#listoverlevels].name 			= boardname
			listoverlevels[#listoverlevels].points 			= points
			listoverlevels[#listoverlevels].numberofmoves 	= numberofmoves
			listoverlevels[#listoverlevels].pickedupcolors 	= pickedup
			listoverlevels[#listoverlevels].time 			= seconds
			listoverlevels[#listoverlevels].numStars 		= thislevel.numStars

		else 
			
			if listoverlevels[levelInQuestion].points < points then 
	
				listoverlevels[levelInQuestion].points = points	
			else
		
			end 

			if listoverlevels[levelInQuestion].numberofmoves > numberofmoves then 

				listoverlevels[levelInQuestion].numberofmoves = numberofmoves	
			else

			end 

			if listoverlevels[levelInQuestion].pickedupcolors > pickedup then 
	
				listoverlevels[levelInQuestion].pickedupcolors = pickedup
			else
	
			end 

	
			if listoverlevels[levelInQuestion].time > seconds then 
			
				listoverlevels[levelInQuestion].time = seconds
			else
		
			end 

			listoverlevels[levelInQuestion].numStars.one = true 
			
			if listoverlevels[levelInQuestion].numStars.two == false then 
				if thislevel.numStars.two == true then 
					listoverlevels[levelInQuestion].numStars.two = true
			
				end 
		
			end 

			if listoverlevels[levelInQuestion].numStars.three == false then 
				if thislevel.numStars.three == true then 
					listoverlevels[levelInQuestion].numStars.three = true
		
				end 
				
			end 
		end 
	else 
		listoverlevels = {}
		listoverlevels[1] = {}
		listoverlevels[1].name = {}
		listoverlevels[1].name 				= boardname
		listoverlevels[1].points 			= points
		listoverlevels[1].numberofmoves 	= numberofmoves
		listoverlevels[1].pickedupcolors 	= pickedup
		listoverlevels[1].time 				= seconds
		listoverlevels[1].numStars	 		= thislevel.numStars
	end 
		
		if not user then 
			tenflib.jsonSave( "state"..tmpWorldName..".txt", system.DocumentsDirectory, listoverlevels )
		else 
			tenflib.jsonSave( "stateuser.txt", system.DocumentsDirectory, listoverlevels )
		end 
	return thislevel
end 	


function gl.replay(markerDirection)
	local replaylist = {}
	local replay = tenflib.jsonLoad("recentMove.txt")
	local count = 0
	for k,v in pairs(replay) do

		count = count + 1
		if k ~= "positions" then  

		replaylist[count] = {x=v.x , y=v.y, flip=v.flip}

		end
	end
	restartscene(true, replaylist)
end

function gl.replayTwo(markerDirection)
	local replaylist = {}
	
	local replay = tenflib.jsonLoad("recentMove.txt")
	local count = 0
	for k,v in pairs(replay) do

		count = count + 1

		if k ~= "positions" then  
		
		replaylist[count] = {x=v.x , y=v.y, flip=v.flip}

		end
	end
	restartsceneTwo(true, replaylist)

end



function gl.AddMoveList( MoveHistoryTable, CurrentPos, MoveDir, way )

if isNameSet == false then 
	local name = {Name = GameBoard.Name}
	table.insert(MoveHistoryTable, name)
	isNameSet=true
end 

	if CurrentPos.x then 

	local positions = {x=CurrentPos.x, y=CurrentPos.y, flip = flip}

	table.insert(MoveHistoryTable, positions)

	tenflib.jsonSave("recentMove.txt",MoveHistoryTable)

	end 

end

function gl.DecMoveList( MoveHistoryTable, CurentPos )
	
	MoveHistoryCounter = MoveHistoryCounter - 1
	MoveHistoryTable.MoveHistoryCounter = { x=CurrentPos.x, y=CurrentPos.y }
end



function gl.isInteger( value )
	local Value1 = value * 0.5
	local Value2 = math.round( value * 0.5 )

	if Value1 == Value2 then
		return true
	else
		return false
	end
end

function gl.cleanUp()
	BoardState = nil
	GameBoard = nil
	MoveHistoryCounter = nil
	MoveHistoryTable = nil

	package.loaded['scoresystem'] = nil
	package.loaded['modules.tenfLib'] = nil
	package.loaded['audioo'] = nil

end 

return gl









