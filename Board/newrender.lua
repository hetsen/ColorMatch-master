
--
local rend = {}
local tenflib 		= require "modules.tenfLib"
local physics 		= require "physics" 
local aud 			= require "audioo"
local _W 			= display.contentWidth
local _H 			= display.contentHeight
local level 		= {}
local tile 			= {}
local tilesize 		= 32

local counter 		= counter or 0 
local counter2 		= counter2 or 0 
local stepcounter 	= stepcounter or 0 
local groupscaling
local group 		= {}
					group.rubber = display.newGroup()
					group.tiles = display.newGroup()
					group.pan 	= display.newGroup()
					group.cam 	= display.newGroup()

					group.pan:insert(group.tiles)
					group.pan.atCenter = true
					group.cam:insert(group.pan)
					group.rubber:insert(group.cam)
local glow 			= true 
local animate 		= true
local inProgress 	= false
local followmarker 	= false  
local markerorigin  = {}
local origin 		= false 
local inProgress 	= false 
local goaltileopen 	= false
local randomcounter = 0 
local phone 		= true
local marker
local backg
local bgCreated 	= false
local animbg =  true 
local onewayID = {}
local owi = 0 
local cleaningUp
local sheetData
local sheet
local sequenceData
local spriteAnimation
local oldrand2
local rubberpan = true
local autocam = (tenflib.jsonLoad('autoScroll') or {true})[1]
local rotationlist = {0,90,180,270}

-- debugs
local longscreen = false
local boundscircles = false


function pan(e)
	print (group.pan.x, group.pan.y)
	print (boundsCircleX.x + boundsCircleX.width/2, boundsCircleY.y + boundsCircleY.width/2)

	if followmarker then 
		if e.phase == "began" then 
			if group.pan.atCenter then 
				group.pan.reverttoPosX = group.pan.x
				group.pan.reverttoPosY = group.pan.y
			end 
			
			group.pan.offsetX = group.pan.x - e.x
			group.pan.offsetY = group.pan.y - e.y

		elseif e.phase == "moved" and group.pan.offsetX and group.pan.offsetY then

			local movePos = {x = group.pan.offsetX + e.x, y = group.pan.offsetY + e.y}

			if group.pan.distReached or tenflib.pointDist(movePos.x, movePos.y, group.pan.reverttoPosX, group.pan.reverttoPosY) > 10 then
				display.getCurrentStage():setFocus(group.pan)


		
-- rubberpanning

				local Xoffset = 0
				local Yoffset = 0
				
				if group.pan.x > 0 then
					distFromEdgeX = (group.pan.x + Xoffset) - (boundsCircleX.x + boundsCircleX.width/2)
					tempXP = true
					print "x more than 0"
				else
					tempXP = false
					print "x less than 0"
					distFromEdgeX = ((boundsCircleX.x - boundsCircleX.contentWidth/2) - (group.pan.x+Xoffset)) - (boundsCircleX.x + boundsCircleX.contentWidth/2)
				end



				if group.pan.y > 0 then
					tempYP = true
					if _G.debugmode then
						print "y more than 0"
					end
					distFromEdgeY = (group.pan.y + Yoffset) - (boundsCircleY.y + boundsCircleY.width/2)
				else
					if _G.debugmode then
						print "y less than 0"
					end
					tempYP = false
					distFromEdgeY = ((boundsCircleY.y - boundsCircleY.contentWidth/2) - (group.pan.y+Yoffset)) - (boundsCircleY.y + boundsCircleY.contentWidth/2)
				end
				if _G.debugmode then				
					print "------"
					print (group.pan.x + Xoffset)
					print "------"
				end
					if distFromEdgeX > 0 then 
							if not tempXP then
								if _G.debugmode then 
									print "1!"
								end
								tempX = -(boundsCircleX.x + boundsCircleX.width/2) + 10 
								
								if distFromEdgeY < 0 then 
									tempY = group.pan.y
								end 

							else
								if _G.debugmode then
									print "2!"
								end

								tempX = (boundsCircleX.x + boundsCircleX.width/2) - 10 
								
								if distFromEdgeY < 0 then 
									tempY = group.pan.y
								end 

							end 
						rubberpanX = true
					else 
						rubberpanX = false
					end  
				
					if distFromEdgeY > 0 then 
							if not tempYP then 
								if _G.debugmode then
									print "3!"
								end
								tempY = -(boundsCircleY.y + boundsCircleY.width/2) + 10 
			
								if distFromEdgeX < 0 then 
									tempX = group.pan.x
								end 
			
							else
								if _G.debugmode then
									print "4!"
								end
								
								tempY = (boundsCircleY.y + boundsCircleY.width/2) - 10 

								if distFromEdgeX < 0 then 
									tempX = group.pan.x
								end 

							end 
						rubberpanY = true
					else
						rubberpanY = false
					end 
		
	

	
				if rubberpanX or rubberpanY then
			 	
				 	if not oldmpx then 
				 		oldmpx = movePos.x
				 	end 

				 	if not oldmpy then 
				 		oldmpy = movePos.y
				 	end 
			 	
				 	if _G.debugmode then
						print "rubberpan!"
					end
					local factor = (1 - math.min(math.exp(distFromEdgeX), 0.9))
					


					group.pan.x = movePos.x 
					group.pan.y = movePos.y

				else
					oldmpx = nil
					oldmpy = nil
					group.pan.x = movePos.x 
					group.pan.y = movePos.y
				end 
----

			
				group.pan.distReached = true	
			end 

		else --ended or cancelled 
			autocam = (tenflib.jsonLoad('autoScroll') or {true})[1]
			if autocam then 
				if rubberpanX or rubberpanY then 
					if _G.debugmode then
						print "heeeey!"
					end
					transition.to (group.rubber, {time = 100, x = 0, y= 0, transition = easing.inOutQuad})
					transition.to (group.pan, {time = 100, x = tempX, y = tempY, onComplete = function () 
					rubberlol = false 
					rubberpanX = false
					rubberpanY = false
					tempX = group.pan.x
					tempY = group.pan.y
					end})
				end 
			end 

			if group.pan.distReached then 
				display.getCurrentStage():setFocus(nil)
				group.pan.offsetX = nil
				group.pan.offsetY = nil
				group.pan.distReached = false
				group.pan.atCenter = false
			else 
				display.getCurrentStage():setFocus(nil)
				group.pan.offsetX = nil
				group.pan.offsetY = nil
				group.pan.distReached = false
						
				if group.pan.x == group.pan.reverttoPosX and group.pan.y == group.pan.reverttoPosX then 
		
				else
					autocam = (tenflib.jsonLoad('autoScroll') or {true})[1]
					if autocam then 
						panninginprogress = true	
						transition.to (group.pan, {time = 400, x = group.pan.reverttoPosX, y= group.pan.reverttoPosY, transition = easing.inOutQuad, onComplete =  function() panninginprogress = false; atCenter = true; end})
					end 
				end 
			end 
		end 
	end

	if group.pan.x and group.pan.y then
		local x, y = marker:localToContent(0,0)
		Runtime:dispatchEvent({name = 'markerMoved', x = x, y = y, time = 1})
	end
end 
 
function rend.goal(string)
	if goaltileopen then 
		if string == "close" then 

			aud.play(sounds.closegoal)
			 spriteAnimation:setSequence( "close" )
			 spriteAnimation:play()

			transition.to (lamp.glow, {time = 500, alpha = .6})
			transition.to (lamp, {time = 500, alpha = 1})
			
			lamp:toFront()
			lamp.glow:toFront()
			marker:toFront()
			
			goaltileopen = not goaltileopen
		else
		
		end
	else
		if string == "close" then 
		
		else
			aud.play(sounds.closegoal)
			 
			 spriteAnimation:setSequence( "open" )
			 spriteAnimation:play()

			 marker:toFront()

			transition.to (lamp.glow, {time = 500, alpha = 0})
			transition.to (lamp, {time = 500, alpha = 0})

			goaltileopen = not goaltileopen
		end 
	end
end 

function rend.loadtiles(set)
	local listoftiles = {}
	if not set then set = 1 end 

	for i = 1,8 do 
		listoftiles[i] = ("Graphics/Tiles/tile_s0"..set.."t0"..i..".png")
		if _G.debugmode then
			print (listoftiles[i])
		end
	end 
	return listoftiles
end

function rend.getTileType(x,y,id,level) -- function for figuring out if the tile is a corner-tile or a regular one.
	local tiletype = 2


	if level.tile[id-1]==0 or nil then 
		tiletype = 1
	end 
	if level.tile[id+1]==0 or nil then 
		tiletype = 3
	end 
	if level.tile[id+1]==0 or nil then 
		if level.tile[id-1]==0 then 
			tiletype = 4
		end
	end 
	if x-1 == 0 then 
		if level.tile[id+1]==0 then 
			tiletype = 4		
		else
			tiletype = 1
		end 
	end 
	if x == level.size.x then
		if level.tile[id-1]==0 then 
			tiletype = 4		
		else
			tiletype = 3
		end 
	end 
		

	return tiletype 
end



function rend.CannotWalkThere() -- does nothing. 
--print ("illegal move")
end

function rend.markTile(id,color) -- function for marking the tile you click on.
	if color == "red" then 
		touchTile:setFillColor (255,0,0)
		--inProgress = true
	end
	if color == "green" then 
		touchTile:setFillColor (0,255,0)
	end

	if color == "blue" then 
		touchTile:setFillColor (100,100,255)
	end

	touchTile.x = tile[id].x
	touchTile.y = tile[id].y-3
	
	transition.to(touchTile,{time = 100, alpha = 1, onComplete = function () 
	transition.to(touchTile,{time = 300, alpha = 0, onComplete = function () 
		end})
	end})
end 

function rend.colorMarker(r,g,b) -- setting the color of the marker
	if r+g+b == 0 then r=80 g=80 b=80 end 
		marker.blob:setFillColor(r,g,b)
		if _G.debugmode then
			print ("MARKER COLOR "..r,g,b)
		end
end 

function rend.setGoalColor(r,g,b) -- setting the color of the goal tile
	lamp:setFillColor(r,g,b)
	lamp.glow:setFillColor(r,g,b)
end  
	
function rend.directionPrinter( MoveHistoryTable )

end

function rend.consolePrintBoard(_board, _state)
	-- Prints the current board in the terminal window
	-- 2013-04-11 Jeto
	local marker
	for i = 1, _board.Size.y do -- loop rows
		local rowString = ""
		for j = 1, _board.Size.x do -- loop columns
			-- If-statement for printing the current marker position.
			if j == _state.MoveMarkerCurrentPos.x and i == _state.MoveMarkerCurrentPos.y then
				marker = "*"
			else
				marker = " "
			end	
			-- Append to string that represents current row.
			rowString = rowString .. _board.Tile[(i-1)*_board.Size.x+j] .. marker .." " 
		end
		--print(rowString)
	end
end 

function rend.getsize(levelsize)
	local check = false
	if levelsize.x > 6 then check = true end
	if levelsize.y > 6 then check = true end
	return check 
end 

function rend.getscale(levelsize)
	--print (globalresolution[1], globalresolution[2])

	local sizelist
	local minimumscale

	if phone then 
		sizelist = {2.5,2.3,1.8,1.6,1.36}
		minimumscale = 1.37
	else
		sizelist = {2.0,2.0,1.6,1.4}
		minimumscale = 1.0
	end 

	local size = sizelist[math.max(levelsize.x, levelsize.y) -1 ]
	
	if not size then size = minimumscale end 
	--print ("global scale "..size)
	return size
end 

function rend.setCamera(level, x, y)
	local middleX = (level.size.x/2 * tilesize)*groupscaling
	local middleY = ((level.size.y/2 * tilesize)) *groupscaling

	local markerX = ((level.marker.x*tilesize)-tilesize/2)*groupscaling
	local markerY = ((level.marker.y*tilesize)-tilesize/2)*groupscaling

	local moveX = middleX - markerX - (groupscaling*8)
	local moveY = middleY - markerY

	group.cam.x = moveX
	group.cam.y = moveY
	
	origo =  {moveX,moveY}

end 

function rend.moveCamera(origin,markerX,markerY,time)
	autocam = (tenflib.jsonLoad('autoScroll') or {true})[1]
	if autocam then 
		if not time then time = 500 end

		local X = origo[1]-(marker.x-origin[1])*groupscaling
		local Y = origo[2]-(marker.y-origin[2])*groupscaling

		if marker and marker.parent then
			local dispX, dispY = marker:localToContent(0,0)
			for i = 1, time*0.1 do
				timer.performWithDelay(i*10, function()
					if marker and marker.parent then
						dispX, dispY = marker:localToContent(0,0)
						Runtime:dispatchEvent({name = 'markerMoved', x = dispX, y = dispY, time = 200})
					end
				end)
			end
		end

		transition.to (group.cam, {time = time, x = X, y = Y, transition = easing.inOutQuad})


		
	end 
end

function rend.makerandom(base,base2)
local rand1 = math.random (10)
local rand2
	if rand1 > 8 then 
		rand2 = math.random(8)
	else 
		if base2 then 
			if oldrand2 then
				repeat
					rand2 = math.random(base,base2)
				until rand2 ~= oldrand2
			else
				rand2 = math.random(base,base2)
			end 	
				oldrand2 = rand2
		
		else 
			rand2 = base
		end
	end
return rand2
end  

function rend.randomrotate ()
	local rot = {90,180, 270,0}
	local r = math.random(4)
	local ret = rot[r]
	return ret
end 

function rend.drawBoard (data)
	

	local n = 0 

			local xoffset
			local yoffset

	level.imagelist	 		= data.imagelist
	level.colorlist			= data.colorlist
	level.itemlist 			= data.itemlist
	level.size 				= data.Size
	level.tile 				= data.Tile
	level.marker 			= data.StartPos
	level.gate 				= data.gate 
	level.background 		= data.background
	level.gametype 			= data.Type
	level.oneway 			= data.oneway

	if _G.debugmode then
		for k,v in pairs(data) do
			print("hello! "..k,v)
		end

		print ("gametype "..data.Type)
	end

	level.set = 2
	if data.Type == "OneStep" 	then level.set = 3 end
	if data.Type == "Grey"		then level.set = 1 end  



	groupscaling = rend.getscale(level.size)
	followmarker = rend.getsize(level.size)
	local function bgCreate()
		if bgCreated == false then
			bgCreated = true
			print("BG Created")
			backg = {}
			bg = display.newGroup() 
			backg.bottom = display.newImageRect(bg,level.background[1],_W,_H)
			backg.l1 = display.newImageRect(bg,level.background[2],_W,_H)
			backg.l2 = display.newImageRect(bg,level.background[3],_W,_H)
			backg.l3 = display.newImageRect(bg,level.background[4],_W,_H)

			backg.l1.alpha = .2
			backg.l2.alpha = .2
			backg.l3.alpha = .2

			backg.bottom.blendMode = "screen"
			backg.l1.blendMode = "screen"
			backg.l2.blendMode = "screen"
			backg.l3.blendMode = "screen"

			bg:toBack()
			bg.x = _W*.5
			bg.y = _H*.5
		else 
			print("BG Already created")
		end
	end
	bgCreate()

	local tileset = rend.loadtiles(level.set)
	local randomrotation 

	for y = 1, level.size.y do 
		for x = 1, level.size.x do 
			n = n + 1
			
			tType = rend.getTileType(x,y,n,level)

			local base = 1
			local base2 = false
			if level.set == 3 then 
				base = 1
				base2 = 5
			end 

			randomizer = rend.makerandom(base,base2)

				tile[n] = display.newGroup()
				tile[n].bottom = display.newImageRect (tile[n],level.imagelist[tType],32,38)
				tile[n].top = display.newImageRect (tile[n],tileset[randomizer],32,38) 

			
	

			randomrotation = 0

			xoffset = 0 
			yoffset = 0 

			if randomrotation == 90 then 
				xoffset = -2.6
				yoffset = -2.9 
			end
			
			if randomrotation == 180 then 
				xoffset = 0
				yoffset = -6 
			end
		
			if randomrotation == 270 then 
				xoffset = 2.6
				yoffset = -3 
			end

			if _G.debugmode then
				print ("rot "..randomrotation)
			end
				tile[n].top.rotation = randomrotation 
				tile[n].top.x = xoffset
				tile[n].top.y = yoffset
				tile[n].x = (x-0.5) * tilesize 
				tile[n].y = (y-0.5) * tilesize
				tile[n].id = n
				tile[n].xPos = x
				tile[n].yPos = y
				tile[n]:toFront()
				tile[n].type = level.tile[n]

				if tile[n].type == 0 then 
					tile[n].isVisible = false
				end 

				group.tiles:insert(tile[n])

				if level.tile[n] == 2 then 
					
					tile[n].object = display.newGroup() 

					goal = display.newImageRect(tile[n].object,level.gate[1],128,128)
					goal.alpha = 0 
					lamp = display.newImageRect(tile[n].object,level.gate.lamp[1],128,128)
					lamp.glow = display.newImageRect(tile[n].object,level.gate.lamp[2],128,128)
					lamp.glow.alpha = .6 
					goal.xScale, goal.yScale = 0.25, 0.25
					lamp.xScale, lamp.yScale = 0.25, 0.25
					lamp.glow.xScale, lamp.glow.yScale = 0.25, 0.25

						tile[n].object.x = tile[n].x
						tile[n].object.y = tile[n].y - 3
						tile[n].object.color = tile[n].type
					
					group.tiles:insert(tile[n].object)
				end 

			local function makeOneWayTile(direction, position)
				local sheetdata={width = 128, height = 128, numFrames = 4, sheetContentWidth = 512, sheetContentHeight = 128}
				local sheet = graphics.newImageSheet('Graphics/Objects/arrow_sprite.png', sheetdata)
					
					oSData = {
			 		{name = "open",frames = {2,3,4},time = 1500,loopCount = 0},
			 		{name = "close",frames = {1},time = 1500,loopCount = 1},
			 		}
			 		local otile = display.newSprite(group.tiles,sheet, oSData)
					
					otile.x, otile.y = tile[position].x,tile[position].y-3
					otile.xScale, otile.yScale = 0.25,0.25
					otile.rotation = direction
					otile:setSequence( "open" )
			 		otile:play()
			 		otile.direction = otile.rotation
					otile.state = "open"
				return otile
			end

	

				if level.tile[n] >= 10 and level.tile[n] < 14 then
					

					tile[n].object = makeOneWayTile(rotationlist[level.tile[n]-9],n)
					if _G.debugmode then
						print ("state "..tile[n].object.state)
					end
					owi = owi + 1
					--tile[n].object = display.newGroup() 
					--oneway = display.newImageRect(tile[n].object,level.oneway[1],128,128)
					
					


					--oneway.xScale, oneway.yScale = 0.20, 0.20
					tile[n].object.x = tile[n].x
					tile[n].object.y = tile[n].y - 3
					group.tiles:insert(tile[n].object)
					onewayID[owi] = owi 
					if _G.debugmode then
						print "one way tile"
						print (owi)
					end
					
				end 

				if level.tile[n] > 1 and level.tile[n] ~= 2 and level.tile[n] < 10 then 
					tile[n].object = display.newImageRect (level.itemlist[level.tile[n] ],22,22) 
						tile[n].object.x = tile[n].x
						tile[n].object.y = tile[n].y 
						tile[n].object.color = tile[n].type
					
					group.tiles:insert(tile[n].object)
					


					if level.tile[n] > 2 and level.tile[n] < 11 then 
						if glow then 
							tile[n].objectglow = display.newImageRect ("pics/glow.png",32,32)
								tile[n].objectglow.x,tile[n].objectglow.y =  tile[n].object.x, tile[n].object.y
								tile[n].objectglow:setFillColor(unpack (level.colorlist[level.tile[n] ]))
								tile[n].objectglow.blendMode = "add"
					
							group.tiles:insert(tile[n].objectglow)
						end 					
					
					end 
				end
				if level.tile[n] == 2 then 
					goaltileID = n
				end 

		end 
	

	end 

--implementing sheetdata for both goaltile and oneway-tile



	sheetData = {width = 128, height = 128, numFrames = 8, sheetContentWidth = 1024, sheetContentHeight = 128}
	sheet = graphics.newImageSheet('Graphics/Objects/gate_sprite.png', sheetData)
		sequenceData = {
			 {name = 'open',start = 1,count = 8,time = 500,loopCount = 1},
			 {name = "close",frames = {8,7,6,5,4,3,2,1},time = 500,loopCount = 1},
			 }



		spriteAnimation = display.newSprite(group.tiles,sheet, sequenceData)
		spriteAnimation.x, spriteAnimation.y = tile[goaltileID].x,tile[goaltileID].y-3
		spriteAnimation.xScale, spriteAnimation.yScale = ((goal.width*goal.xScale) / spriteAnimation.width), ((goal.height*goal.yScale) / spriteAnimation.height)
		
		

		tile[goaltileID].object:toFront()

		touchTile = display.newImageRect(data.touchtile,32,32)
		touchTile.blendMode = "add"
		touchTile.alpha = 0 
		group.tiles:insert(touchTile)	

		marker = display.newGroup()

		marker.blob = display.newImageRect(marker, "pics/marker.png",25,25 )
		marker.x = (level.marker.x-0.5) * tilesize
		marker.y = (level.marker.y-0.6) * tilesize
		marker.blob.alpha = .8
		marker:addEventListener("tap",plusMinus)
		marker.eye={}

		for i = 1,2 do 
			marker.eye[i] = display.newImageRect(marker,"Graphics/Objects/eye_sclera.png" ,70,70)
			marker.eye[i].dot = display.newImageRect(marker,"Graphics/Objects/eye_pupil.png", 6,6)
			
			marker.eye[i].yScale = .1
			marker.eye[i].xScale = .1
			
			marker.eye[i]:setFillColor(255,255,255)
			marker.eye[i].dot:setFillColor(0,0,0)

			marker.eye[i].y = -1
			marker.eye[i].dot.y = -2
			marker.eye[i]:toFront()
			marker.eye[i].dot:toFront()
		
		end
			marker.eye[1].x = -3.6
			marker.eye[2].x = 3.6
			marker.eye[1].dot.x = -3.6
			marker.eye[2].dot.x = 3.6

		group.tiles:insert(marker)
	

	
		group.tiles.xScale = groupscaling
		group.tiles.yScale = groupscaling
		group.tiles:setReferencePoint(display.CenterReferencePoint)
		group.tiles.x = _W/2 - 15
		group.tiles.y = _H/2

	if longscreen then group.pan.yScale = .84 
						
						group.pan.y = 32 
					end

	if followmarker then 
		group.pan.x = 15
		rend.setCamera (level,1,1)
	end 




		local bounds = group.tiles.contentBounds
	 	lps = {maxX = bounds.xMax*groupscaling, minX = bounds.xMin*groupscaling, maxY = bounds.yMax*groupscaling, minY = bounds.yMin*groupscaling}
		local realsizeX, realsizeY = lps.maxX - lps.minX, lps.maxY-lps.minY
		
		if _G.debugmode then
			print ("HELLOOOOOOO!!!!!!!!!!!!!!!!!!!!!!"..lps.maxX - lps.minX, lps.maxY-lps.minY)
		end	
		
		boundsCircleX = display.newCircle(group.pan,0,0,realsizeX/2 - realsizeX/6)
		boundsCircleY = display.newCircle(group.pan,0,0,realsizeY/2 - realsizeY/6)
		boundsCircleX.x = _W/2
		boundsCircleX.y = _H/2
		boundsCircleX:setFillColor (255,0,0)
		boundsCircleY.x = _W/2
		boundsCircleY.y = _H/2
		boundsCircleY:setFillColor (0,255,0)
		
		if boundscircles then 
			boundsCircleX.alpha = .3
			boundsCircleY.alpha = .3
		else 
			boundsCircleX.alpha = 0
			boundsCircleY.alpha = 0
		end 

	return tile
end

function rend.opentiles(tile, state)
	tile.object.state = state
	tile.object:setSequence( state )
	tile.object:play()
end 

function rend.moveMarker(x,y,way, GameBoard) -- moving the marker
	aud.play (sounds.move)
	
	if not origin then 
	
		markerorigin = {marker.x,marker.y}
		origin = true 
	
	end 

	local done = false 
	local moveX = (x-0.5) * tilesize
	local moveY = (y-0.6) * tilesize
	
	rend.moveeyes(way)

	inProgress = true

	if way == "up" or way == "down" then 
		transition.to (marker, {time = 100, xScale=.8, yScale = 1.8})
		transition.to (marker, {delay = 100, time = 100, xScale=1, yScale = 1, onComplete = function () done = true end })
	else 
		transition.to (marker, {time = 100, xScale=1.8, yScale = .8})
		transition.to (marker, {delay = 100, time = 100, xScale=1, yScale = 1, onComplete = function () done = true end })
	end 
	
	marker.prevPos = {x = marker.x, y = marker.y}
	marker.thisPos = {x = moveX, y=moveY}
	local tmpY,tmpX
	
	tmpX, tmpY = marker.prevPos.x - marker.thisPos.x, marker.prevPos.y - marker.thisPos.y

	local dispX, dispY = marker:localToContent(0,0)
	for i = 1, 20 do
		timer.performWithDelay(i*10, function()
			dispX, dispY = marker:localToContent(0,0)
			Runtime:dispatchEvent({name = 'markerMoved', x = dispX, y = dispY, time = 200})
		end)
	end

	transition.to (marker, {time = 200, x=moveX, y=moveY, transition = easing.inOutQuad, onComplete = function()
	inProgress = false
	
	if followmarker then 
		
		stepcounter = stepcounter + 1
		if stepcounter > 1 then 

			rend.moveCamera(markerorigin,moveX,moveY)
			stepcounter = 0 
		end 
	end 
	
	

	
	end})
	
end

function rend.getMoveInProgress() --returns if there is already a move in progress.

	return inProgress
end


function rend.updateBoard(tileID, Value) -- updating a single tile 
	local id = tileID-level.size.x

	tile[id].type = Value
	if Value == 1 then
		if tile[id].object then 
			local NodeID = PathNodes:GetNearestNode(tile[id].xPos, tile[id].yPos)
			PathNodes:SetWeightAdd(NodeID, 0)

			tile[id].object:toFront()
			
			transition.to (tile[id].object, {time = 50, xScale = 2, yScale = 2})
			transition.to (tile[id].object, {delay = 200, time = 200, xScale = .1, yScale = .1, onComplete = function() 

				display.remove(tile[id].object)
				tile[id].object = nil
				
				if glow then 
					display.remove(tile[id].objectglow) 
					tile[id].objectglow=nil
				end 
			end })
		end 
	end 

	if Value > 2 and Value < 11 then 
		
		tile[id].object = display.newImageRect (level.itemlist[Value],22,22) 
		tile[id].object.x = tile[id].x 
		tile[id].object.y = tile[id].y 
		tile[id].object.color = tile[id].type
		tilegroup:insert(tile[id].object)
		if glow then 
			tile[id].objectglow = display.newImageRect ("pics/glow.png",32,32)
			tile[id].objectglow.x,tile[id].objectglow.y =  tile[id].x+1, tile[id].y
			
			tile[id].objectglow:setFillColor(unpack (colorlist[Value]))
			tile[id].objectglow.blendMode = "add"
			tilegroup:insert(tile[id].objectglow)
		end 					


	end 




	if Value == 0 then 

			if replaymode then 
				transition.to (tile[id], {delay = 300, time = 200, alpha = 0, xScale = 0.01, yScale = 0.01, transition = easing.inQuad, onComplete = function ()
					if _G.debugmode then
						for k,v in pairs(tile) do
							print(k,v)
						end
					end
				end})
			else
				transition.to (tile[id], {delay = 300, time = 200, alpha = 0, xScale = 0.01, yScale = 0.01, transition = easing.inQuad, onComplete = function ()

				local NodeID = PathNodes:GetNearestNode(tile[id].xPos, tile[id].yPos)

				if tile[id].object then 
				
						display.remove(tile[id].object)
						tile[id].object = nil
						
						if glow then 
							display.remove(tile[id].objectglow) 
							tile[id].objectglow=nil
						end 
						
				
				end 



				PathNodes:DestroyNode(NodeID)


				tile[id]={}
				tile[id].type = 0 	
			end })
		end 
	end
end 

function rend.moveeyes(direction)
		if direction == "up" then
			--marker.blob:toFront()
			for i = 1,2 do 
				transition.to(marker.eye[i], {time = 100, alpha = .1})
				transition.to(marker.eye[i].dot,{time = 100, alpha = .1})
			end 	
			transition.to(marker.eye[1], {time = 100, x = -3.5})
			transition.to(marker.eye[2], {time = 100, x = 3.5})
			transition.to(marker.eye[1].dot, {time = 100, x = -3.5})
			transition.to(marker.eye[2].dot, {time = 100, x = 3.5})
		end 
	
		if direction == "down" then
			for i=1,2 do 
				marker.eye[i]:toFront()
				marker.eye[i].dot:toFront()

				transition.to(marker.eye[i], {time = 100, alpha = 1})
				transition.to(marker.eye[i].dot, {time = 100, alpha = 1})
			end 
			
			transition.to(marker.eye[1], {time = 100, x = -3.5})
			transition.to(marker.eye[2], {time = 100, x = 3.5})
			transition.to(marker.eye[1].dot, {time = 100, x = -3.5})
			transition.to(marker.eye[2].dot, {time = 100, x = 3.5})
		end 

		if direction == "left" then 
			for i=1,2 do 
				marker.eye[i]:toFront()
				marker.eye[i].dot:toFront()
				transition.to(marker.eye[i], {time = 100, alpha = 1})
				transition.to(marker.eye[i].dot, {time = 100, alpha = 1})
			end 
			transition.to(marker.eye[1], {time = 100, x = -3.5})
			transition.to(marker.eye[2], {time = 100, x = -3.5})
			transition.to(marker.eye[1].dot, {time = 100, x = -5.5})
			transition.to(marker.eye[2].dot, {time = 100, x = -5.5})
		end 

		if direction == "right" then 
			for i=1,2 do 
				marker.eye[i]:toFront()
				marker.eye[i].dot:toFront()
				transition.to(marker.eye[i], {time = 100, alpha = 1})
				transition.to(marker.eye[i].dot, {time = 100, alpha = 1})
			end 
			transition.to(marker.eye[1], {time = 100, x = 3.5})
			transition.to(marker.eye[2], {time = 100, x = 3.5})
			transition.to(marker.eye[1].dot, {time = 100, x = 5.5})
			transition.to(marker.eye[2].dot, {time = 100, x = 5.5})

		end 
end 

function rend.cleanup(argument)
	cleaningUp = true
	if not argument then argument = "all" end 

	if argument == "tiles" or argument == "all" then 

		--print "removing tiles"
		
		transition.to (group.tiles, {time = 300, alpha = 0, onComplete = function ()
		animate = false 
			for i = 1,#tile do 
				if tile[i].object ~= nil then 
					display.remove (tile[i].object)
					tile[i].object = nil 
					
					if glow then 
						if tile[i].type ~= 2 then 
							display.remove (tile[i].objectglow)
							tile[i].objectglow=nil
						end 
					end 
				
				end 
				display.remove (tile[i].bottom)
				display.remove (tile[i].top)
				display.remove (tile[i])
				--print ("removing "..tostring(tile[i]))
			end
		tile = nil 
		display.remove (group.tiles)
		cleaningUp = false
		end })

	end 

	if argument == "background" or argument == "all" then 
		--print "removing background"
		display.remove(backg.bottom)
		display.remove(backg.l1)
		display.remove(backg.l2)
		display.remove(backg.l3)

		display.remove(bg)	
		backg = nil
		bg = nil 
	end 

	if argument == "all" then 
		--print "removing all"
		Runtime:removeEventListener("touch",pan)
		Runtime:removeEventListener("enterFrame", rend.animate)
		display.remove(marker.eye[1])
		display.remove(marker.eye[2])
		display.remove(marker.eye[1].dot)
		display.remove(marker.eye[2].dot)
		display.remove(spriteAnimation)
		display.remove(marker.blob)
		display.remove(boundsCircleX)
		display.remove(boundsCircleY)
		
		display.remove(marker)
		marker = nil 
		


package.loaded ["tenflib"] = nil 
package.loaded ["physics"] = nil 
package.loaded ["aud"] = nil 
	
	-- DO NOT DO THIS EVER EVER EVER EVER EVER!
	--	for k,v in pairs(package.loaded) do
	--	package.loaded[k]=nil 
	--	end
	
	end 

	 
		return true


end 


function rend.explodeBoard(win) -- kills the board
	--print "explodeboard"
	marker:toFront()
	timer.performWithDelay(300, function ()
		physics.start()
			aud.play (sounds.falling)
			transition.to (marker, {time = 500, xScale = .1, yScale = .1, rotation = 400, onComplete = function () display.remove(marker) end })
		for i = 1,#tile do
			if tile[i] then 

				if tile[i].object ~= nil then 
			
					if glow then 
						if tile[i].type ~= 2 then 
						display.remove(tile[i].objectglow) 
						end 
					end 
				end 
			end 					
		end
	end ) 
	return true 

end

function rend.blink()
	if marker and marker.parent and (not cleaningUp) then 
		transition.to (marker.eye[1],{time = 50, yScale = .01, onComplete = 
		function ()
			transition.to (marker.eye[1],{time = 70, yScale = .1})
		end})
		transition.to (marker.eye[2],{time = 70, yScale = .01, onComplete = 
		function ()
			transition.to (marker.eye[2],{time = 70, yScale = .1})
		end})
	end 
end 


function rend.animate() -- animating the objects on screen. 
	if animate then 
		counter = counter + .08
		counter2 = counter2 + .03

		if counter > 359 then counter = counter - 360 end 
		if counter2 > 359 then counter2 = counter2 - 360 end 

		if animbg then 
			
			if backg then 
				backg.l2.xScale = 1+math.sin(counter2)*.05
				backg.l2.yScale = 1+math.cos(counter2)*.05
				backg.l3.xScale = 1+math.sin(counter2/2)*.04
				backg.l3.yScale = 1+math.cos(counter2/2)*.04
				backg.l1.xScale = 1+math.cos(counter2/4)*.08
				backg.l1.yScale = 1+math.sin(counter2/4)*.08
				backg.bottom.xScale = 1+math.cos(counter2/2)*0.001
				backg.bottom.yScale = 1+math.sin(counter2)*.02
			end 
		end 
		
		if marker then 
			for i = 1,2 do 
						marker.eye[i].y = -2 + math.sin(counter2-(i*10))*.1
			end 
		end 


		for i = 1,#tile do 
			if tile[i].object ~= nil then 
				if tile[i].type ~= 2 then 
					if tile[i].type < 10 then 

						if tile[i].object.pos == nil then 
							tile[i].object.pos = tile[i].object.y
						end
						tile[i].object.y = tile[i].object.pos + math.sin(counter+i)*2 - 4
						
						if glow then 
							if tile[i].objectglow then 
								
								tile[i].objectglow.y = tile[i].object.pos + math.sin(counter+i)*2 - 2.5
								tile[i].objectglow.alpha = (math.random (4,6))/10
								tile[i].objectglow.xScale = (math.random (3,6))/10
							end 
					end 
					end 
				end 
			end 
		end 
	end 
end



Runtime:addEventListener("touch",pan)
Runtime:addEventListener("enterFrame", rend.animate)

return rend 
