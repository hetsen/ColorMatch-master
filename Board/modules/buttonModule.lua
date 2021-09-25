local function createButton(params)
	local bg = params.bg
	local fg = params.fg
	local text = params.text
	local buttonParams = params.buttonParams or {}

	local onBegan = params.onBegan or function(e)
		e.target.alpha = 0.5
	end

	local onMoved = params.onMoved or function(e)
		
	end

	local onEnded = params.onEnded or function(e)
		e.target.alpha = 1
	end

	local onEndedOutside = params.onEndedOutside or function(e)
		e.target.alpha = 1
	end

	local function onTouch(e)
		timer.performWithDelay(1, function()
			if not e.target.touchLock then
				if e.phase == 'began' then
					display.getCurrentStage():setFocus(e.target)
					onBegan(e)
				elseif e.phase == 'moved' then
					onMoved(e)
				else
					display.getCurrentStage():setFocus(nil)

					local trueX, trueY = e.target:localToContent(0,0)

					if e.x < trueX + e.target.width*e.target.xScale*0.5
					and e.x > trueX - e.target.width*e.target.xScale*0.5
					and e.y < trueY + e.target.height*e.target.yScale*0.5
					and e.y > trueY - e.target.height*e.target.yScale*0.5 then
						onEnded(e)
					else
						onEndedOutside(e)
					end
				end
			end
		end)

		return true
	end

	local function removeEL(target)
		target:removeEventListener('touch', onTouch)
	end

	local button = display.newGroup()

	local buttonBg, buttonFg, buttonText

	if bg then
		buttonBg = display.newImageRect(button, bg.path or 'buttonBg.png', bg.width or 384, bg.height or 190)
		buttonBg.xScale, buttonBg.yScale = bg.xScale or 1, bg.yScale or 1
		buttonBg.x, buttonBg.y = bg.x or 0, bg.y or 0
		buttonBg.alpha = bg.alpha or 1
		buttonBg:setFillColor(unpack(bg.color or {255,255,255}))
	end

	if fg then
		buttonFg = display.newImageRect(button, fg.path or 'buttonFg.png', fg.width or 384, fg.height or 190)
		buttonFg.xScale, buttonFg.yScale = fg.xScale or 1, fg.yScale or 1
		buttonFg.x, buttonFg.y = fg.x or 0, fg.y or 0
		buttonFg.alpha = fg.alpha or 1
		buttonFg:setFillColor(unpack(fg.color or {255,255,255}))
	end

	if text then
		buttonText = display.newText(button, text.text or '', 0, 0, text.font, text.fontSize or 20)
		buttonText.x, buttonText.y = text.x or 0, text.y or 0
		buttonText.alpha = text.alpha or 1
		buttonText:setFillColor(unpack(text.color or {255,255,255}))
	end

	for k,v in pairs(buttonParams) do
		button[k] = v
	end

	button.x, button.y = params.x or 0, params.y or 0
	button.alpha = params.alpha or 1
	button.bg = buttonBg
	button.fg = buttonFg
	button.text = buttonText
	button.removeEL = removeEL
	button:addEventListener('touch', onTouch)

	return button
end

return createButton
