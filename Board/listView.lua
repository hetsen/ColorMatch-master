	--[[---------------------------------Användning------------------------------------------

EXEMPEL:

	local list = {}

	for i=1,20 do
		table.insert(list, {text = "hejsan!!"..i, path = "Mickes sökväg"..i})
	end
	local function mickeFunc(e)
		print(e.data.path)
	end
	local listView = require("listView"):createListView(nil, list, {
		listener = mickeFunc,
		-- distBetween = 100,
	})

	-- listView:setMask(masken!!)

	local _W, _H = display.contentWidth, display.contentHeight
	listView.x = _W / 2
	listView.y = _H / 2

--]]-------------------------------------------------------------------------------------


--[[
TODO:
--]]	

local proxy = {}

function proxy:createListView(_parent, _listOfItems, _params)
	--Hanterar parametrar
		local params = _params or {}

		--Inställningar
			local textPadding = params.padding or 10
			local distBetweenItems = params.distBetween or 5
			local font = params.font or native.systemFont
			local fontSize = params.fontSize or 20
			local buttonWidth = params.buttonWidth or 200
			local buttonHeight = params.buttonHeight or 40
			local scrollHeight = params.height or 120
			local dragToStart = params.dragStart or 10
			local textButtonColor = params.textButtonColor or {255}
			local bgButtonColor = params.bgButtonColor or graphics.newGradient({100}, {50}, "down")
			local bgColor = params.bgColor or {0, 0,}
			local listener = params.listener
		---

		local listOfItems = _listOfItems or {}
	---
	local mainGroup = display.newGroup()
	if _parent then
		_parent:insert(mainGroup)
	end
	mainGroup._userView_scrollEnabled = true
	-- require("modules.utils.mask").setRectMask(mainGroup, buttonWidth, scrollHeight, "C", "T", "y")


	--Skapar scrollYta
		local bg = display.newRect(mainGroup, 0, 0, buttonWidth, scrollHeight)
		bg:setFillColor(type(bgColor) == "table" and unpack(bgColor) or bgColor)
		bg.x, bg.y = 0, scrollHeight / 2
		bg.alpha = .5
	---

	local itemGroup = display.newGroup()
	--Maskar scrollyta
	---
	mainGroup:insert(itemGroup)
	for i, itemData in ipairs(listOfItems) do
		local textToWrite = itemData.text

		--Skapar meny-delen av ett item
			local item = display.newGroup()
			item.data = itemData
			item:addEventListener("tap", function(e)
				if listener then
					listener({target = e.target, data = e.target.data})
				end
			end)
			itemGroup:insert(item)

			--Skapar bakgrund
				local background = display.newRect(item, 0, 0, buttonWidth, buttonHeight)
				background.x, background.y = 0, background.height / 2
				
				background:setFillColor(type(bgButtonColor) == "table" and unpack(bgButtonColor) or bgButtonColor)
				item.background = background
			---

			--Skapar text
				local text = display.newText(item, textToWrite, 0, 0, font, fontSize)
				text:setReferencePoint(display.CenterLeftReferencePoint)
				text.x, text.y = -background.width / 2 + textPadding, background.y
				text:setTextColor(type(textButtonColor) == "table" and unpack(textButtonColor) or textButtonColor)


				item.text = text
			---

			--Sparar positioner
				item.x, item.y = 0, (i - 1) * (item.height + distBetweenItems)
				item.scrollToPos = {x = -item.x, y = -item.y}
				item.orgPos = {x = item.x, y = item.y}
			---
		---
	end

	--Funktioner för skrollning

		function mainGroup:scrollToTop(_time, _onComplete)
			local scrollMax = 0
			self:scrollToY(scrollMax, _time, _onComplete)
		end

		function mainGroup:setScrollStatus(_enable)
			self._userView_scrollEnabled = _enable
		end

		function mainGroup:scrollToIndex(_index, _time, _onComplete)
			self:scrollToY(itemGroup[_index].scrollToPos.y, _time, _onComplete)
		end

		function mainGroup:scrollToBotttom(_time, _onComplete)
			local scrollMin = -itemGroup.height + scrollHeight
			self:scrollToY(scrollMin, _time, _onComplete)
		end

		function mainGroup:getScrollPos()
			return self._userView_scrollPos
		end
		
		function mainGroup:scrollToY(_y, _time, _onComplete)
			if not _y then return end
			self._userView_scrollPos.y = _y
			if _time then
				for i = 1, itemGroup.numChildren do
					transition.to(itemGroup[i], {time = _time, y = itemGroup[i].orgPos.y + _y, transition = easing.inOutQuad, onComplete = function()
						if i == itemGroup.numChildren then
							if _onComplete then
								_onComplete()
							end
						end
					end})
				end
			else
				for i = 1, itemGroup.numChildren do
					itemGroup[i].y = itemGroup[i].orgPos.y + _y
				end
			end
		end
		mainGroup._userView_scrollPos = {x = 0, y = 0}

		mainGroup:addEventListener("touch", function(event)
			if mainGroup._userView_scrollEnabled then
				
				local scrollMin = -itemGroup.height + scrollHeight
				local scrollMax = 0

				local target = event.target
				local phase = event.phase
				if phase == "began" then
					if itemGroup.height > scrollHeight then
						display.getCurrentStage():setFocus(target)
						target._userView_hasFocus = true
						target._userView_offsetY = event.y - mainGroup._userView_scrollPos.y
						target._userView_originScrollValue = event.y - target._userView_offsetY
					end
				end
				if target._userView_hasFocus then
					if phase == "moved" then
						local scrollToValue = event.y - target._userView_offsetY
						if target._userView_isDragging or math.abs(target._userView_originScrollValue - scrollToValue) > dragToStart then
							target._userView_isDragging = true
							if not target._userView_dragOffset then
								if target._userView_originScrollValue - scrollToValue > 0 then
									target._userView_dragOffset = dragToStart
								else
									target._userView_dragOffset = -dragToStart
								end
							end
							target:scrollToY(scrollToValue + target._userView_dragOffset)
						end
					elseif phase == "ended" or phase == "cancelled" then
						local scrollToValue = event.y - target._userView_offsetY + (target._userView_dragOffset or 0)
						--_G.saraMod.clamp(event.y - target._userView_offsetY + target._userView_dragOffset, scrollMin, scrollMax)
						if scrollToValue > scrollMax then
							target:scrollToY(scrollMax, 500)
						elseif scrollToValue < scrollMin then
							target:scrollToY(scrollMin, 500)
						end
						target._userView_isDragging = false
						target._userView_hasFocus = false
						target._userView_offsetY = nil
						target._userView_dragOffset = nil
						display.getCurrentStage():setFocus(nil)
					end
				end
				return true
			end
		end)
	---

	return mainGroup
end

return proxy