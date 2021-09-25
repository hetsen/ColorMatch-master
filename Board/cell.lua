-- Cell stub
-- state: single, double
-- combine (two singles)
-- split
-- grow
-- disolve
-- shrink
-- pulse

-- props:
-- radius

-- detect distance from every single to each other.


lib = {}

local smoothStep = function(x)
	x = math.max(0, math. min(1, x))
	return x * x * (3 - 2 * x)
end


local new = function(x, y, col1, col2, size)

	local faceCell

	local self = {}
	
	local _new = function(_x, _y, _col1, _col2, _size)
		

		local function onTouch( event )
	
			local t = event.target
			local parent = t.parent
			--print(t)
			local phase = event.phase
		
			if "began" == phase then
			
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				
				
				for i = 1, parent.numChildren do
					if t == parent[i] then 
					
					else 
					
						--Face each other:
						local angle = math.atan2( -(t.y - parent[i].y), -(t.x - parent[i].x))
						
						t.rotation = (angle*180/math.pi)
						parent[i].rotation = (angle*180/math.pi-180)

					end

				end
				-- Spurious events can be sent to the target, e.g. the user presses 
				-- elsewhere on the screen and then moves the finger over the target.
				-- To prevent this, we add this flag. Only when it's true will "move"
				-- events be sent to the target.
				t.isFocus = true

				-- Store initial position
				t.x0 = event.x - t.x
				t.y0 = event.y - t.y
			elseif t.isFocus then
				if "moved" == phase then
					-- Make object move (we subtract t.x0,t.y0 so that moves are
					-- relative to initial grab point, rather than object "snapping").
					-- TODO: print("Check if other cells are closer...")
					t.x = event.x - t.x0
					t.y = event.y - t.y0

					for i = 1, parent.numChildren do
						if t == parent[i] then 
	
						else 
				
					
							local dist = math.sqrt((t.y - parent[i].y)^2 + (t.x - parent[i].x)^2)
			
							
							perc = smoothStep((dist-50)/100)
							pClose = smoothStep(dist/50)

							if (perc < 1 and perc > 0) or (pClose < 1  and pClose > 0) then

								--To face each other, we need the angle
								local angleDeg = 180/math.pi*math.atan2( -(t.y - parent[i].y), -(t.x - parent[i].x))
							
								t.rotation = (angleDeg)
								parent[i].rotation = (angleDeg-180)

								-- Calculate colors:
								--print("Yes! now the color will change!")
								local med_col = {}
								med_col = { (t.color2[1]+parent[i].color2[1]),
											(t.color2[2]+parent[i].color2[2]),
											(t.color2[3]+parent[i].color2[3])
											}
					
								local amount = t.color2[1] + parent[i].color2[1] + 
												t.color2[2] + parent[i].color2[2] +
												t.color2[3] + parent[i].color2[3] 

								if t.color2[1]+t.color2[2]+t.color2[3] ~= 0 then 
									med_col[1] = math.floor(255 / amount * med_col[1]) 
									med_col[2] = math.floor(255 / amount * med_col[2])
									med_col[3] = math.floor(255 / amount * med_col[3])
									local multi = 255 / math.max(med_col[1], med_col[2], med_col[3])
									med_col[1] = math.ceil(med_col[1]*multi)
									med_col[2] = math.ceil(med_col[2]*multi)
									med_col[3] = math.ceil(med_col[3]*multi)
									if med_col[1] > 255 then med_col[1] = 255 end 
									if med_col[2] > 255 then med_col[2] = 255 end 
									if med_col[3] > 255 then med_col[3] = 255 end 
								else 
									med_col[1] = 0; med_col[2] = 0; med_col[3] = 0
								end 
								-- This will be the resulting color:
--								--print("Medium color is: "..med_col[1]..", "..med_col[2]..", "..med_col[3] )

			
								--These two for sides facing each other (long distanse -> use perc)
								for j = 1, t.numChildren do
									if t[j].tag == "col2" then
										local rd = (255*t.color2[1]*perc+med_col[1]*(1-perc))
										local gr = (255*t.color2[2]*perc+med_col[2]*(1-perc))
										local bl = (255*t.color2[3]*perc+med_col[3]*(1-perc))
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										if rd > 255 then rd = 255 end
										if gr > 255 then gr = 255 end
										if bl > 255 then bl = 255 end
					
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										t[j]:setFillColor(rd, gr, bl)
									end
								end 
								for j = 1, parent[i].numChildren do
									if parent[i][j].tag == "col2" then
										local rd = (255*parent[i].color2[1]*perc+med_col[1]*(1-perc))
										local gr = (255*parent[i].color2[2]*perc+med_col[2]*(1-perc))
										local bl = (255*parent[i].color2[3]*perc+med_col[3]*(1-perc))
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										if rd > 255 then rd = 255 end
										if gr > 255 then gr = 255 end
										if bl > 255 then bl = 255 end
										--print("Color is: r_"..rd.." g_"..gr.." b_"..bl)
										parent[i][j]:setFillColor(rd, gr, bl)
									end
								end 
								-- ( end facing sides ) 

								--These two for sides oposing each other (short distanse -> use pClose)
								for j = 1, t.numChildren do
									if t[j].tag == "col1" then
										local rd = (255*t.color1[1]*pClose+med_col[1]*(1-pClose))
										local gr = (255*t.color1[2]*pClose+med_col[2]*(1-pClose))
										local bl = (255*t.color1[3]*pClose+med_col[3]*(1-pClose))
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										if rd > 255 then rd = 255 end
										if gr > 255 then gr = 255 end
										if bl > 255 then bl = 255 end
					
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										t[j]:setFillColor(rd, gr, bl)
									end
								end 
								for j = 1, parent[i].numChildren do
									if parent[i][j].tag == "col1" then
										local rd = (255*parent[i].color1[1]*pClose+med_col[1]*(1-pClose))
										local gr = (255*parent[i].color1[2]*pClose+med_col[2]*(1-pClose))
										local bl = (255*parent[i].color1[3]*pClose+med_col[3]*(1-pClose))
										--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
										if rd > 255 then rd = 255 end
										if gr > 255 then gr = 255 end
										if bl > 255 then bl = 255 end
										--print("Color is: r_"..rd.." g_"..gr.." b_"..bl)
										parent[i][j]:setFillColor(rd, gr, bl)
									end
								end
								-- ( end oposing sides ) 
							end
						end

					end

				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
				end
			end

			-- Important to return true. This tells the system that the event
			-- should not be propagated to listeners of any objects underneath.
			return true
		end

		local size = _size or 1
		local col1 = _col1 or {1,1,1}
		local col2 = _col2 or {1,1,1}


		local gr = display.newGroup()



		local imageRight = display.newImageRect(gr, "Graphics/Backgrounds/cellright.png", 80, 78 )
		imageRight:setReferencePoint( display.CenterReferencePoint )
		--imageRight.anchorX = .5
		--imageRight.anchorY = .5
		imageRight:setFillColor(255*col2[1],255*col2[2],255*col2[3])
		imageRight.tag = "col2"

		local imageLeft = display.newImageRect(gr, "Graphics/Backgrounds/cellleft.png", 80, 78 )
		imageLeft:setReferencePoint( display.CenterReferencePoint )
		--imageLeft.anchorX = .5
		--imageLeft.anchorY = .5
		imageLeft:setFillColor(255*col1[1],255*col1[2],255*col1[3])
		imageLeft.tag = "col1"

		local imageOntop = display.newImageRect(gr, "Graphics/Menu/sphere.png", 79, 79 )
		imageOntop:setReferencePoint( display.CenterReferencePoint )
		--imageOntop.anchorX = .5
		--imageOntop.anchorY = .5
		imageOntop.alpha = 0.35


		gr:setReferencePoint( display.CenterReferencePoint )
		--gr.anchorX = .5
		--gr.anchorY = .5
		gr:scale(size,size)
		gr.x, gr.y = _x, _y
		gr.color1 = col1
		gr.color2 = col2

		--gr:addEventListener( "touch", onTouch )

		--print("Touch function:")
		--print(onTouch)

		return gr
	end

	local cellGroup = _new(x, y, col1, col2, size)

	local faceCell = function( otherCell )
		--print("STUB: faceCell")

		--print("My own x-value: ".. self.cellGroup.x)
		--print("The other cell's x-value: "..otherCell.x())
		-- calculate angle to other cell
		local angle = math.atan2( -(self.cellGroup.y - otherCell.y()), -(self.cellGroup.x - otherCell.x())  )
		--print("Angle is : "..angle*180/math.pi)

		-- rotate self with left side towards other cell...
		self.cellGroup:rotate(angle*180/math.pi)
	end

	local updateColors = function( otherCell )
		--print("STUB: updateColors")
		local t = self.cellGroup
		local parent = t.parent
		--print("The group:")
		--print(t)
		--print("The parent:")
		--print(parent)
		--print("The other:")
		--print(otherCell)
		--faceCell(otherCell)

		--print("How far are they?")
		local dist = math.sqrt((t.y - otherCell.cellGroup.y)^2 + (t.x - otherCell.cellGroup.x)^2)
		--print("The distance is: "..dist)
		--local perc = dist / 255
		--print("Percentage i: "..perc)
		


		--To face each other, we need the angle
		local angleDeg = 180/math.pi*math.atan2( -(t.y - otherCell.cellGroup.y), -(t.x - otherCell.cellGroup.x))
	
		t.rotation = (angleDeg)
		otherCell.cellGroup.rotation = (angleDeg-180)

		perc = smoothStep((dist-75)/150)
		pClose = smoothStep(dist/150)

		if (perc < 1 and perc >= 0) or (pClose < 1  and pClose >= 0) then


			-- Calculate colors:
			--print("Yes! now the color will change!")
			local med_col = {}
			med_col = { (t.color2[1]+otherCell.cellGroup.color2[1]),
						(t.color2[2]+otherCell.cellGroup.color2[2]),
						(t.color2[3]+otherCell.cellGroup.color2[3])
						}
			--local amount_r = t.color2[1] + parent.color2[1] 
			--local amount_g = t.color2[2] + parent.color2[2]
			--local amount_b = t.color2[3] + parent.color2[3] 
			local amount = t.color2[1] + otherCell.cellGroup.color2[1] + 
							t.color2[2] + otherCell.cellGroup.color2[2] +
							t.color2[3] + otherCell.cellGroup.color2[3] 

			if t.color2[1]+t.color2[2]+t.color2[3] ~= 0 then 
				med_col[1] = math.floor(255 / amount * med_col[1]) 
				med_col[2] = math.floor(255 / amount * med_col[2])
				med_col[3] = math.floor(255 / amount * med_col[3])
				local multi = 255 / math.max(med_col[1], med_col[2], med_col[3])
				med_col[1] = math.ceil(med_col[1]*multi)
				med_col[2] = math.ceil(med_col[2]*multi)
				med_col[3] = math.ceil(med_col[3]*multi)
				if med_col[1] > 255 then med_col[1] = 255 end 
				if med_col[2] > 255 then med_col[2] = 255 end 
				if med_col[3] > 255 then med_col[3] = 255 end 
			else 
				med_col[1] = 0; med_col[2] = 0; med_col[3] = 0
			end 
			-- This will be the resulting color:
			--print("Medium color is: "..med_col[1]..", "..med_col[2]..", "..med_col[3] )


			--These two for sides facing each other (long distanse -> use perc)
			for j = 1, t.numChildren do
				if t[j].tag == "col2" then
					local rd = (255*t.color2[1]*perc+med_col[1]*(1-perc))
					local gr = (255*t.color2[2]*perc+med_col[2]*(1-perc))
					local bl = (255*t.color2[3]*perc+med_col[3]*(1-perc))
					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					if rd > 255 then rd = 255 end
					if gr > 255 then gr = 255 end
					if bl > 255 then bl = 255 end

					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					t[j]:setFillColor(rd, gr, bl)
				end
				--print(t[j].tag)
			end 
			--print("How many objects: "..parent.numChildren)


			for j = 1, otherCell.cellGroup.numChildren do
				--print(otherCell.cellGroup[j].tag)

				if otherCell.cellGroup[j].tag == "col2" then
					--print("We found the tag: col2")
					local rd = (255*otherCell.cellGroup.color2[1]*perc+med_col[1]*(1-perc))
					local gr = (255*otherCell.cellGroup.color2[2]*perc+med_col[2]*(1-perc))
					local bl = (255*otherCell.cellGroup.color2[3]*perc+med_col[3]*(1-perc))
					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					if rd > 255 then rd = 255 end
					if gr > 255 then gr = 255 end
					if bl > 255 then bl = 255 end
					--print("Color is: r_"..rd.." g_"..gr.." b_"..bl)
					otherCell.cellGroup[j]:setFillColor(rd, gr, bl)
				end
			end 
			-- ( end facing sides ) 

			--These two for sides oposing each other (short distanse -> use pClose)
			for j = 1, t.numChildren do
				if t[j].tag == "col1" then
					local rd = (255*t.color1[1]*pClose+med_col[1]*(1-pClose))
					local gr = (255*t.color1[2]*pClose+med_col[2]*(1-pClose))
					local bl = (255*t.color1[3]*pClose+med_col[3]*(1-pClose))
					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					if rd > 255 then rd = 255 end
					if gr > 255 then gr = 255 end
					if bl > 255 then bl = 255 end

					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					t[j]:setFillColor(rd, gr, bl)
				end
			end 
			for j = 1, otherCell.cellGroup.numChildren do
				if otherCell.cellGroup[j].tag == "col1" then
					local rd = (255*otherCell.cellGroup.color1[1]*pClose+med_col[1]*(1-pClose))
					local gr = (255*otherCell.cellGroup.color1[2]*pClose+med_col[2]*(1-pClose))
					local bl = (255*otherCell.cellGroup.color1[3]*pClose+med_col[3]*(1-pClose))
					--print("Color is: r_"..rd.." g_"..bl.." b_"..gr)
					if rd > 255 then rd = 255 end
					if gr > 255 then gr = 255 end
					if bl > 255 then bl = 255 end
					--print("Color is: r_"..rd.." g_"..gr.." b_"..bl)
					otherCell.cellGroup[j]:setFillColor(rd, gr, bl)
				end
			end
			-- ( end oposing sides ) 
		else

			for j = 1, t.numChildren do
				t[j]:setFillColor(255*self.cellGroup.color1[1],255*self.cellGroup.color1[2],255*self.cellGroup.color1[3])
			end
			for j = 1, otherCell.cellGroup.numChildren do
				otherCell.cellGroup[j]:setFillColor(255*otherCell.cellGroup.color1[1],255*otherCell.cellGroup.color1[2],255*otherCell.cellGroup.color1[3])
			end
		end


	end

	local getXValue = function()
		return self.cellGroup.x
	end

	local getYValue = function()
		return self.cellGroup.y
	end

	local randomizeColor = function()
		local colList = {{1,0,0},{0,1,0},{0,0,1},{1,1,0},{1,0,1},{0,1,1}}
		local n = math.random(#colList)
		--print("Random color: "..n)

		for j = 1, self.cellGroup.numChildren do	
			self.cellGroup[j]:setFillColor(255*colList[n][1],255*colList[n][2],255*colList[n][3])
		end
		self.cellGroup.color1 = colList[n]
		self.cellGroup.color2 = colList[n]
		return n
	end
	--local cellGroup = _new(x, y, col1, col2, size)
	--	print("Function outside:")
	--print(updateColors)

	self = {
			cellGroup = cellGroup,
			updateColors = updateColors
		}

	return {faceCell = faceCell,
			x = getXValue,
			y = getYValue,
			cellGroup = cellGroup,
			updateColors = updateColors,
			randomizeColor = randomizeColor
		}
end


lib.new = new

return lib 