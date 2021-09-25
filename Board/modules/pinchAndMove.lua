


return function(_parent, _onTap)
	--Parametrar:
		--_parent är master-gruppen som innehåller alla objekt som ska scrollas och zoomas. (OBS: kan sättas senare)
		--_onTap är funktionen som kallas när man tapar på något av tap-objekten.	(OBS: kan sättas senare)

system.activate("multitouch")
local lib = {}

--Variabler
	local tappables = {}
	local _W, _H = display.contentWidth, display.contentHeight
	local _w, _h = _W / 2, _H / 2

	--Variabler
	    --Boundries
	        local xMinOffset    = 999999
	        local yMinOffset    = 999999
	        local xMaxOffset    = 999999
	        local yMaxOffset    = 999999
	    ---
	    --Scaling
	        local MaxScale      = 2
	        local MinScale      = 0.5
	    ---
	    local moveEnabled       = true
	    local zoomEnabled		= true
	    local tapEnabled        = true
	    local zoomObject        = _parent
	    local userOnTap			= _onTap
	---
---




--Funktioner
	--Globala
		local enableMove
		local disableMove
		local disableZoom
		local enableZoom
		local enableTap
		local disableTap
		local addTappable
		local removeTappable
		local setMinScale
		local setMaxScale
		local dispose
		local setZoomObject
		local setOnTap
	---
	--Privata
		local onTap
		local distanceToCoordinate
		local clamp
		local calculateDelta
		local calculateCenter
		local touch
	---
---

--Funktioner
	--Globala
		function dispose()
			Runtime:removeEventListener( "touch", touch )
			system.deactivate("multitouch")
		end
		lib.dispose = dispose

		function enableMove()
			moveEnabled = true
		end
		lib.enableMove = enableMove

		function disableMove()
			moveEnabled = false
		end
		lib.disableMove = disableMove

		function disableZoom()
			zoomEnabled = false
		end
		lib.disableZoom = disableZoom

		function enableZoom()
			zoomEnabled = true
		end
		lib.enableZoom = enableZoom

		function enableTap()
			tapEnabled = true
		end
		lib.enableTap = enableTap

		function disableTap()
			tapEnabled = false
		end
		lib.disableTap = disableTap

		function addTappable(_tappable)
			local exists = false
			for i, tappable in ipairs(tappables) do
				if _tappable == tappable then
					exists = true
					break
				end
			end
			if not exists then
				table.insert(tappables, _tappable)
			end
			return (not exists)
		end
		lib.addTappable = addTappable

		function removeTappable(_tappable)
			local index = table.indexOf(_tappable)
			if index then
				table.remove(tappables, index)
				return true
			else
				return false
			end
		end
		lib.removeTappable = removeTappable

		function setBoundsOffset(_xMinOffset, _yMinOffset, _xMaxOffset, _yMaxOffset)
			xMinOffset = _xMinOffset
	        xMaxOffset = _xMaxOffset
	        yMinOffset = _yMinOffset
	        yMaxOffset = _yMaxOffset
		end
		lib.setBoundsOffset = setBoundsOffset

		function setZoomObject(_obj)
			zoomObject = _obj
		end
		lib.setZoomObject = setZoomObject

		function setOnTap(_func)
			userOnTap = _func
		end
		lib.setOnTap = setOnTap

		function setMinScale(_minScale)
			local scale
			if _minScale then
				scale = _minScale
			else
				local b = zoomObject.contentBounds
				if (b.xMax - b.xMin) < (b.yMax - b.yMin) then
					scale = (_W / ((b.xMax - b.xMin) * 1.1))
				else
					scale = (_H / ((b.yMax - b.yMin) * 1.1))
				end
			end
			MinScale = scale
		end
		lib.setMinScale = setMinScale

		function setMaxScale(_maxScale)
			local scale  = _maxScale or 1.5
			MaxScale = scale
		end
		lib.setMaxScale = setMaxScale

		function getScale()
			return zoomObject.xScale
		end
		lib.getScale = getScale

	---

	--Lokala
		function onTap(e)
			local isTapable = false

			for i, tapable in pairs(tappables) do
				if tapable == e.target then
					isTapable = true
					break
				end
			end

			if isTapable then
				if userOnTap then
					userOnTap(e)
				end
			end
		end

		function distanceToCoordinate(x1, y1, x2, y2)
			return  (math.sqrt((x2-x1)^2 + (y2-y1)^2))
		end

		function clamp(value, min, max)
		    if value <= min then
		        return min
		    elseif value >= max then
		        return max
		    else 
		        return value
		    end
		end
		 
		function calculateDelta( previousTouches, event )
		    local id,touch = next( previousTouches )
		    if event.id == id then
		        id,touch = next( previousTouches, id )
		        assert( id ~= event.id )
		    end
		    local dx = touch.x - event.x
		    local dy = touch.y - event.y
		    return dx, dy 
		end
		 
		function calculateCenter( previousTouches, event )
			local id,touch = next( previousTouches )
			if event.id == id then
				id,touch = next( previousTouches, id )
				assert( id ~= event.id )
			end
			local cx = math.floor( ( touch.x + event.x ) * 0.5 )
			local cy = math.floor( ( touch.y + event.y ) * 0.5 )
			return cx, cy
		end

		function touch( event )
		    local phase = event.phase
		    local eventTime = event.time
		    local previousTouches = zoomObject.previousTouches
		    
		    if not zoomObject.xScaleStart then
		        zoomObject.xScaleStart, zoomObject.yScaleStart = zoomObject.xScale, zoomObject.yScale
		    end

		    local numTotalTouches = 1
		    if previousTouches then
		        -- add in total from previousTouches, subtract one if event is already in the array
		        numTotalTouches = numTotalTouches + zoomObject.numPreviousTouches
		        if previousTouches[event.id] then
					numTotalTouches = numTotalTouches - 1
		        end
		    end

		    if "began" == phase then
			    -- Very first "began" event
			    if not zoomObject.isFocus then
			        -- Subsequent touch events will target button even if they are outside the contentBounds of button
			        display.getCurrentStage():setFocus( zoomObject )
			        zoomObject.isFocus = true
			        
			        -- Store initial position
			        zoomObject.x0 = event.x - zoomObject.x
			        zoomObject.y0 = event.y - zoomObject.y

			        previousTouches = {}
			        zoomObject.previousTouches = previousTouches
			        zoomObject.numPreviousTouches = 0
			        zoomObject.firstTouch = event
			            
			    elseif not zoomObject.distance then
			        local dx,dy
			        local cx,cy

			        if previousTouches and numTotalTouches >= 2 then
			            dx,dy = calculateDelta( previousTouches, event )
			            cx,cy = calculateCenter( previousTouches, event )
			        end

			        -- initialize to distance between two touches
			        if dx and dy then
			            local d = math.sqrt( dx*dx + dy*dy )
				        if d > 0 then
			                zoomObject.distance = d
			                zoomObject.xScaleOriginal = zoomObject.xScale
			                zoomObject.yScaleOriginal = zoomObject.yScale
			                
			                zoomObject.x0 = cx - zoomObject.x
			                zoomObject.y0 = cy - zoomObject.y
			            end
			        end
			    end
			    if not previousTouches[event.id] then
			            zoomObject.numPreviousTouches = zoomObject.numPreviousTouches + 1
			    end
			    previousTouches[event.id] = event
		    elseif zoomObject.isFocus then
		        if "moved" == phase and moveEnabled then
		            if zoomObject.distance then
		                local dx,dy
		                local cx,cy
		                if previousTouches and numTotalTouches == 2 then
		                    dx,dy = calculateDelta( previousTouches, event )
		                    cx,cy = calculateCenter( previousTouches, event )
		                end

		                if dx and dy then
		                    local newDistance = math.sqrt( dx*dx + dy*dy )
		                    local scale = newDistance / zoomObject.distance

		                    if scale > 0 then

		                    	if zoomEnabled then
			                        zoomObject.xScale = zoomObject.xScaleOriginal * scale
			                        zoomObject.yScale = zoomObject.yScaleOriginal * scale

			                        zoomObject.xScale = clamp(zoomObject.xScale, MinScale, MaxScale)
			                        zoomObject.yScale = clamp(zoomObject.yScale, MinScale, MaxScale)
			                    end

		                        if zoomObject.xScale >= MaxScale or zoomObject.xScale <= MinScale then
									--När skalan är max eller min.

		                        else
		                        	--När skalan är någonstans mellan.
		                            zoomObject.x = cx - zoomObject.x0 * scale
		                            zoomObject.y = cy - zoomObject.y0 * scale
		                        end

		                        
		                        local zoomBounds = zoomObject.contentBounds
		                        local centerPoint = {x = zoomBounds.xMin + (zoomBounds.xMax - zoomBounds.xMin) / 2, y = zoomBounds.yMin + (zoomBounds.yMax - zoomBounds.yMin) / 2}

		                        local offset = {x = (zoomObject.x - centerPoint.x), y = zoomObject.y - centerPoint.y}

		                         --Skapar bounds och lägger på offset på varje sida
		                            local bounds = display.getCurrentStage().contentBounds

		                            bounds.xMin = xMinOffset - zoomObject.contentWidth / 2 + offset.x
		                            bounds.xMax = _W - xMaxOffset + zoomObject.contentWidth / 2 + offset.x

		                            bounds.yMin = yMinOffset - zoomObject.contentHeight / 2 + offset.y
		                            bounds.yMax = _H - yMaxOffset + zoomObject.contentHeight / 2 + offset.y
		                        ---

		                        --Clampar positionen
		                            zoomObject.x = clamp(zoomObject.x, bounds.xMin, bounds.xMax)
		                            zoomObject.y = clamp(zoomObject.y, bounds.yMin, bounds.yMax)
		                        ---
		                    end
		                end
		            else
		                if event.id == zoomObject.firstTouch.id then
		                    -- don't move unless this is the first touch id.
		                    -- Make object move (we subtract zoomObject.x0, zoomObject.y0 so that moves are
		                    -- relative to initial grab point, rather than object "snapping").


		                    zoomObject.x = event.x - zoomObject.x0
		                    zoomObject.y = event.y - zoomObject.y0

		                    local zoomBounds = zoomObject.contentBounds
		                    local centerPoint = {x = zoomBounds.xMin + (zoomBounds.xMax - zoomBounds.xMin) / 2, y = zoomBounds.yMin + (zoomBounds.yMax - zoomBounds.yMin) / 2}

		                    local offset = {x = (zoomObject.x - centerPoint.x), y = zoomObject.y - centerPoint.y}

		                     --Skapar bounds och lägger på offset på varje sida
		                        local bounds = display.getCurrentStage().contentBounds

		                        bounds.xMin = xMinOffset - zoomObject.contentWidth / 2 + offset.x
		                        bounds.xMax = _W - xMaxOffset + zoomObject.contentWidth / 2 + offset.x

		                        bounds.yMin = yMinOffset - zoomObject.contentHeight / 2 + offset.y
		                        bounds.yMax = _H - yMaxOffset + zoomObject.contentHeight / 2 + offset.y
		                    ---

		                    --Clampar positionen
		                        zoomObject.x = clamp(zoomObject.x, bounds.xMin, bounds.xMax)
		                        zoomObject.y = clamp(zoomObject.y, bounds.yMin, bounds.yMax)
		                    ---
		                end
		            end
		            
		            if event.id == zoomObject.firstTouch.id then
		                zoomObject.firstTouch = event
		            end

		            if not previousTouches[event.id] then
		                zoomObject.numPreviousTouches = zoomObject.numPreviousTouches + 1
		            end
		            previousTouches[event.id] = event
		        elseif "ended" == phase or "cancelled" == phase then
		            -- check for taps
		            local dx = math.abs( event.xStart - event.x )
		            local dy = math.abs( event.yStart - event.y )
		            if (eventTime - previousTouches[event.id].time < 500 and dx < 5 and dy < 5) then
		                if not zoomObject.tapTime then
		                    -- single tap
		                    if enableTap then
		                        if onTap then
		                            for i = 1, zoomObject.numChildren do
		                                local bounds = zoomObject[i].contentBounds
		                                if event.x <= bounds.xMax and event.x >= bounds.xMin and 
		                                event.y <= bounds.yMax and event.y >= bounds.yMin  then
		                                    onTap({target = zoomObject[i], tapCount = 1})
		                                    break
		                                end
		                            end
		                        end
		                    end

		                    --För att double tap ska fungera
		                        zoomObject.tapTime = eventTime
		                        zoomObject.tapDelay = timer.performWithDelay( 300, function()
		                            zoomObject.tapTime = nil
		                        end )
		                    ---
		                elseif eventTime - zoomObject.tapTime < 300 then
		                    -- double tap
		                    if enableTap then
		                        for i = 1, zoomObject.numChildren do
		                            local bounds = zoomObject[i].contentBounds
		                            if event.x <= bounds.xMax and event.x >= bounds.xMin and 
		                            event.y <= bounds.yMax and event.y >= bounds.yMin  then
		                                onTap({target = zoomObject[i], tapCount = 2})
		                                break
		                            end
		                        end
		                    end
		                end
		            end
		    
		            --
		            if previousTouches[event.id] then
		                zoomObject.numPreviousTouches = zoomObject.numPreviousTouches - 1
		                previousTouches[event.id] = nil
		            end

		            if zoomObject.numPreviousTouches == 1 then
		                -- must be at least 2 touches remaining to pinch/zoom
		                zoomObject.distance = nil
		                -- reset initial position
		                local id,touch = next( previousTouches )
		                zoomObject.x0 = touch.x - zoomObject.x
		                zoomObject.y0 = touch.y - zoomObject.y
		                zoomObject.firstTouch = touch

		            elseif zoomObject.numPreviousTouches == 0 then
		                -- previousTouches is empty so no more fingers are touching the screen
		                -- Allow touch events to be sent normally to the objects they "hit"
		                display.getCurrentStage():setFocus( nil )
		                zoomObject.isFocus = false
		                zoomObject.distance = nil
		                zoomObject.xScaleOriginal = nil
		                zoomObject.yScaleOriginal = nil

		                -- reset array
		                zoomObject.previousTouches = nil
		                zoomObject.numPreviousTouches = nil
		            end
		        end
		    end
			return true
		end
	---
---

Runtime:addEventListener( "touch", touch )

return lib
end
