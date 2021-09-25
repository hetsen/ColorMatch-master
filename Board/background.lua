

local fillColor = {
	{255,0,0},
	{0,255,0},
	{0,0,255},
	{255,255,0},
	{0,255,255},
	{255,0,255},
}

local bgGroup = display.newGroup()

local grid = display.newImageRect(bgGroup, 'Graphics/Backgrounds/menu_background_grid.png', 640, 960)
grid.xScale, grid.yScale = _W / 640, _H / 960
grid.x, grid.y = 0, 0

local holes = display.newImageRect(bgGroup, 'Graphics/Backgrounds/menu_background_holes.png', 640, 960)
holes.xScale, holes.yScale = _W / 640, _H / 960
holes.x, holes.y = 0, 0

local glow = display.newImageRect(bgGroup, 'Graphics/Backgrounds/menu_background_glow.png', 640, 960)
glow.xScale, glow.yScale = _W / 640, _H / 960
glow.x, glow.y = 0, 0
glow.color = math.random(#fillColor)
glow:setFillColor(unpack(fillColor[glow.color]))
glow.blendMode = "add"

local glow2 = display.newImageRect(bgGroup, 'Graphics/Backgrounds/menu_background_glow.png', 640, 960)
glow2.xScale, glow2.yScale = _W / 640, _H / 960
glow2.x, glow2.y = 0, 0

repeat
	glow2.color = math.random(#fillColor)
until glow2.color ~= glow.color

glow2:setFillColor(unpack(fillColor[glow2.color]))
glow2.blendMode = "add"
glow2.alpha = 0

local shadow = display.newImageRect(bgGroup, 'Graphics/Backgrounds/menu_background_shadow.png', 640, 960)
shadow.xScale, shadow.yScale = _W / 640, _H / 960
shadow.x, shadow.y = 0, 0
shadow.alpha = 0.85

local function animateglow()
	bgGroup.counter = bgGroup.counter +.04
	if bgGroup.counter > 360 then bgGroup.counter = 0 end 
	if bgGroup and bgGroup.parent and bgGroup.glow and bgGroup.glow.parent then 
		bgGroup.glow.alpha = (math.sin(bgGroup.counter)+1)/2	
		bgGroup.glow2.alpha = 1-bgGroup.glow.alpha
	end 
end 

bgGroup.counter = 0
bgGroup.grid = grid
bgGroup.holes = holes
bgGroup.glow = glow
bgGroup.glow2 = glow2
bgGroup.shadow = shadow
bgGroup.animateglow = animateglow
bgGroup.x, bgGroup.y = _W*0.5, _H*0.5

return bgGroup

--local bg = createBackground()