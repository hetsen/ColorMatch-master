local psoBackGroup = display.newGroup()
local psoFrontGroup = display.newGroup()

-- local hudWidth, hudHeight = 1536, 280
-- local compact = ''

-- if system.getInfo('model') == 'iPhone' then
-- 	hudWidth, hudHeight = 640, 200
-- 	compact = '_compact'
-- end
local hudWidth, hudHeight = 640, 177
local compact = '_compact'

local hud = display.newImageRect(psoBackGroup, 'Graphics/UI/hud_panel' .. compact .. '.png', hudWidth, hudHeight)
hud.xScale, hud.yScale = _W / hudWidth, _W / hudWidth
hud.x, hud.y = _W*0.5, hud.height*hud.yScale*0.5

-- Exempel:
-- local circ = display.newCircle(psoBackGroup, 0, 0, 50)
-- circ.x, circ.y = 150, 150

-- local rect = display.newRect(psoFrontGroup, 0, 0, 100, 100)
-- rect.x, rect.y = 200, 200

return {psoBackGroup, psoFrontGroup}