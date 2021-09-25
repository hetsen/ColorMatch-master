local psoBackGroup = display.newGroup()
local psoFrontGroup = display.newGroup()

local hudWidth, hudHeight = 1536, 306
local compact = ''

if system.getInfo('model') == 'iPhone' then
	hudWidth, hudHeight = 640, 306
	compact = '_compact'
end

local hud = display.newImageRect(psoBackGroup, 'Graphics/UI/editor_panel' .. compact .. '.png', hudWidth, hudHeight)
hud.xScale, hud.yScale = _W / hudWidth, _W / hudWidth
hud.x, hud.y = _W*0.5, _H - hud.height*hud.yScale*0.5

-- Exempel:
-- local circ = display.newCircle(psoBackGroup, 0, 0, 50)
-- circ.x, circ.y = 150, 150

-- local rect = display.newRect(psoFrontGroup, 0, 0, 100, 100)
-- rect.x, rect.y = 200, 200

return {psoBackGroup, psoFrontGroup}